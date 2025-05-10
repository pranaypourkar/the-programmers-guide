# Validations in Spring Framework

## What is Validation?

**Validation** is the process of checking whether the input data is **correct**, **complete**, and **meets certain rules or constraints** before it's processed or saved.

In Java, and especially in Spring applications, validation ensures that:

* A field is not `null` when it must have a value.
* A string meets minimum or maximum length.
* A number is within a certain range.
* An email address is properly formatted.
* Custom business rules (like "age must be above 18") are enforced.

Validation is usually applied to:

* Data received from users (form submissions, JSON payloads).
* Objects used in APIs (DTOs).
* Data models before saving them to the database.

**Example of a simple constraint:**

```java
public class User {
    @NotBlank
    private String username;

    @Email
    private String email;
}
```

This example says: _username should not be blank, and email must be in proper email format._

## Why is Validation Important in Spring Applications?

Spring applications commonly deal with:

* User input via APIs
* Form data from websites
* External data (like messages, files)

If data is not validated:

* **Invalid or incomplete data** may reach your business logic or database.
* It can cause **runtime exceptions**, **data corruption**, or **security vulnerabilities**.
* It becomes harder to debug or trace what went wrong.

By validating early (at the controller level), we:

* Prevent bad data from entering your system.
* Return useful and specific error messages to the user.
* Keep your core logic clean and focused on business rules.

**Spring makes this process easy** by integrating with Jakarta Bean Validation (like `@NotNull`, `@Size`, etc.) and automatically triggering checks.

## Difference between Manual & Automatic (Declarative) Validation

### Manual Validation

In manual validation, **we write the code** to check values and handle errors ourself.

**Example:**

```java
if (user.getUsername() == null || user.getUsername().isEmpty()) {
    throw new IllegalArgumentException("Username is required");
}
```

This approach:

* Requires more code
* Is error-prone
* Needs to be duplicated if used in many places
* Offers no built-in grouping or nesting support

### Automatic (Declarative) Validation

Spring uses **declarative validation** with annotations like `@NotNull`, `@Size`, `@Valid`, etc.

**We annotate the class fields**, and Spring + Jakarta Validation will automatically check them.

**Example:**

```java
public class User {
    @NotBlank(message = "Username is required")
    private String username;

    @Email(message = "Invalid email")
    private String email;
}
```

Then in the controller:

```java
@PostMapping("/register")
public ResponseEntity<?> register(@Valid @RequestBody User user) {
    // If validation fails, Spring throws MethodArgumentNotValidException
    return ResponseEntity.ok("Registered");
}
```

We don't write if-checks — the framework handles it.

{% hint style="success" %}
**Advantages of Declarative Validation:**

* Less boilerplate code
* Reusable annotations
* Built-in internationalization of error messages
* Supports groups, nesting, and custom constraints
* Cleaner separation of validation rules from logic
{% endhint %}

## Validation Types in Spring

Spring supports multiple ways of performing validation. Depending on the use case and complexity, we can choose:

1. Bean Validation (Jakarta Validation API – `jakarta.validation.*`)
2. Spring’s own `Validator` interface (`org.springframework.validation.Validator`)
3. Custom Validation (annotations + logic)
4. Programmatic vs Declarative Validation

### 1. Bean Validation (Jakarta Validation API)

This is the **most common and recommended approach** in Spring applications.

* Uses annotations from `jakarta.validation` (previously `javax.validation`) like `@NotNull`, `@Size`, `@Email`, `@Pattern`, etc.
* Spring integrates with Jakarta Validation and performs the checks automatically.
* Used mostly in:
  * DTOs for REST APIs
  * Form submissions
  * Method parameters

**Example:**

```java
public class UserDTO {
    @NotBlank
    private String name;

    @Email
    private String email;
}
```

In the controller:

```java
@PostMapping("/users")
public ResponseEntity<?> createUser(@Valid @RequestBody UserDTO dto) {
    // If invalid, Spring returns 400 with error details
}
```

* Validation is recursive — if `UserDTO` contains another object with annotations, it is also validated using `@Valid`.

{% hint style="success" %}
**Behind the scenes**, Spring Boot uses **Hibernate Validator** as the default implementation of the Jakarta Bean Validation API.
{% endhint %}

### 2. Spring’s `Validator` Interface

* This is **Spring’s native validation mechanism** before it adopted Jakarta Bean Validation.
* We **implement the interface `org.springframework.validation.Validator`** and manually define validation logic.
* Often used for:
  * Complex business validations that can't be captured with simple annotations
  * Older Spring applications
  * Manual validation within services/controllers

**Example:**

```java
public class UserValidator implements Validator {
    @Override
    public boolean supports(Class<?> clazz) {
        return User.class.isAssignableFrom(clazz);
    }

    @Override
    public void validate(Object target, Errors errors) {
        User user = (User) target;

        if (user.getName() == null || user.getName().length() < 3) {
            errors.rejectValue("name", "name.tooShort", "Name must be at least 3 characters");
        }
    }
}
```

In controller:

```java
@Autowired
private UserValidator userValidator;

@PostMapping("/users")
public String submitForm(@ModelAttribute User user, BindingResult result) {
    userValidator.validate(user, result);
    if (result.hasErrors()) {
        return "form";
    }
    return "success";
}
```

This approach gives us full control but requires more boilerplate.

### 3. Custom Validation

This includes **custom annotations and validation logic**, usually built on top of Bean Validation.

Use when:

* Built-in annotations aren’t sufficient (e.g., checking that a username is unique in the DB)
* You want reusable annotations for business rules

**Steps:**

1. Create an annotation
2. Create a validator that implements `ConstraintValidator`

**Example:**

```java
@Target({ ElementType.FIELD })
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = UniqueUsernameValidator.class)
public @interface UniqueUsername {
    String message() default "Username already exists";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
```

Validator:

```java
public class UniqueUsernameValidator implements ConstraintValidator<UniqueUsername, String> {
    @Override
    public boolean isValid(String username, ConstraintValidatorContext context) {
        // Call repository to check if username exists
        return !userRepository.existsByUsername(username);
    }
}
```

Use in DTO:

```java
@UniqueUsername
private String username;
```

### 4. Programmatic vs Declarative Validation

**Declarative Validation:**

* Uses annotations like `@NotNull`, `@Valid`, etc.
* Cleaner and less code
* Handled automatically by the framework

**Example:**

```java
@Size(min = 3)
private String username;
```

Spring automatically checks this and returns a 400 response if invalid.

**Programmatic Validation:**

* Manual checks in Java code using `Validator` or `if` conditions
* Offers full control
* More verbose

**Example:**

```java
Validator validator = Validation.buildDefaultValidatorFactory().getValidator();
Set<ConstraintViolation<User>> violations = validator.validate(user);
```

We inspect `violations` and act accordingly.

**When to use:**

* Use **declarative** for most use-cases (cleaner and standard).
* Use **programmatic** only when:
  * We need dynamic constraints
  * We're writing libraries
  * We're validating inside services instead of controllers

## Comparison

### 1. Bean Validation (Jakarta Validation API – `jakarta.validation.*`)

<table data-full-width="true"><thead><tr><th width="173.17578125">Aspect</th><th>Description</th></tr></thead><tbody><tr><td><strong>What it is</strong></td><td>Standard Java validation via annotations (JSR-380 / Bean Validation 2.0).</td></tr><tr><td><strong>Provided by</strong></td><td><code>jakarta.validation</code> (formerly <code>javax.validation</code>).</td></tr><tr><td><strong>Annotations used</strong></td><td><code>@NotNull</code>, <code>@Size</code>, <code>@Email</code>, <code>@Min</code>, <code>@Pattern</code>, etc.</td></tr><tr><td><strong>Where it's used</strong></td><td>DTOs, Entities, Request bodies.</td></tr><tr><td><strong>Spring Integration</strong></td><td>Deeply integrated — works automatically with <code>@Valid</code> / <code>@Validated</code> in controllers.</td></tr><tr><td><strong>Custom groups</strong></td><td>Yes, supports <code>groups</code>.</td></tr><tr><td><strong>Nested validation</strong></td><td>Yes, with <code>@Valid</code>.</td></tr><tr><td><strong>Best for</strong></td><td>Common, field-level validation (input validation, simple rules).</td></tr></tbody></table>

{% hint style="info" %}
Most commonly used in modern Spring apps.
{% endhint %}

### 2. Spring’s `Validator` Interface (`org.springframework.validation.Validator`)

<table data-full-width="true"><thead><tr><th width="159.44140625">Aspect</th><th>Description</th></tr></thead><tbody><tr><td><strong>What it is</strong></td><td>Spring-specific interface for imperative, programmatic validation.</td></tr><tr><td><strong>Method</strong></td><td>Must implement <code>validate(Object, Errors)</code> method.</td></tr><tr><td><strong>No annotations</strong></td><td>Logic is written in Java code, not annotations.</td></tr><tr><td><strong>Use case</strong></td><td>When you need full control over validation logic or want to validate objects not annotated.</td></tr><tr><td><strong>Registration</strong></td><td>Must be registered manually or via <code>@InitBinder</code>.</td></tr><tr><td><strong>Groups support</strong></td><td>Manual.</td></tr><tr><td><strong>Drawback</strong></td><td>Verbose and manual.</td></tr></tbody></table>

{% hint style="info" %}
Best when:

* You want **logic-based validation**
* You're **validating a non-annotated object**
* You need **complex cross-field logic**
{% endhint %}

### 3. Custom Validation (Annotations + Logic)

<table data-full-width="true"><thead><tr><th width="141.7578125">Aspect</th><th>Description</th></tr></thead><tbody><tr><td><strong>What it is</strong></td><td>User-defined annotation + corresponding <code>ConstraintValidator</code>.</td></tr><tr><td><strong>Example</strong></td><td><code>@ValidPassword</code>, <code>@ValidUsername</code>, etc.</td></tr><tr><td><strong>How</strong></td><td>Define an annotation → implement validator → apply it to fields.</td></tr><tr><td><strong>Powerful</strong></td><td>Can include external service calls, database checks.</td></tr><tr><td><strong>Reusable</strong></td><td>Yes — once defined, works like any built-in annotation.</td></tr><tr><td><strong>Spring aware</strong></td><td>If needed, validator can be made Spring-aware via <code>@Autowired</code>.</td></tr></tbody></table>

{% hint style="info" %}
Best when:

* You have **domain-specific rules** (e.g., username must be unique)
* Need **reusability across projects or modules**
{% endhint %}

### 4. Programmatic vs Declarative Validation

<table><thead><tr><th width="128.890625">Comparison</th><th>Programmatic</th><th>Declarative</th></tr></thead><tbody><tr><td><strong>How</strong></td><td>Call validator manually in code</td><td>Use annotations on fields and classes</td></tr><tr><td><strong>Example</strong></td><td><code>validator.validate(object)</code></td><td><code>@NotBlank</code>, <code>@Valid</code>, <code>@Size</code>, etc.</td></tr><tr><td><strong>Flexible?</strong></td><td>Yes – full control</td><td>Less flexible, but cleaner</td></tr><tr><td><strong>Verbose?</strong></td><td>Yes</td><td>No – concise</td></tr><tr><td><strong>When to use</strong></td><td>For conditional logic, external checks</td><td>For field-level rules</td></tr></tbody></table>

{% hint style="info" %}
**Declarative validation** is ideal for most cases.\
Use **programmatic** when logic is dynamic, conditional, or involves services.
{% endhint %}

### When to Use What ?

<table data-full-width="true"><thead><tr><th>Use Case</th><th>Recommended Validation Type</th></tr></thead><tbody><tr><td>Simple form field checks</td><td><strong>Bean Validation (Jakarta)</strong></td></tr><tr><td>Request DTO validation in controller</td><td><strong>Jakarta + <code>@Valid</code> / <code>@Validated</code></strong></td></tr><tr><td>Cross-field or logic-based validation</td><td><strong>Spring <code>Validator</code> OR Custom ConstraintValidator</strong></td></tr><tr><td>Need reusability and domain-specific rule</td><td><strong>Custom Annotation + Validator</strong></td></tr><tr><td>Complex condition-based logic</td><td><strong>Programmatic validation</strong></td></tr><tr><td>Different rules for create/update/view actions</td><td><strong>Validation Groups + <code>@Validated</code></strong></td></tr></tbody></table>

## Validation Groups

### What are Validation Groups?

Validation groups allow us to apply **different sets of constraints** depending on the context.

For example:

* When **creating** a user, we might want to validate fields like `username`, `email`, and `password`.
* When **updating**, we might only want to validate `email` (not `password` or `username`).

Instead of duplicating your DTOs or writing custom logic, we can define **groups** and apply them using the `groups` attribute on annotations.

### Purpose of Validation Groups

* **Context-aware validation** — apply only relevant constraints based on the use case (e.g., create vs update).
* **Reusability** — same DTO with different validation behavior depending on operation.
* **Cleaner code** — avoids manual condition-based checks.

### How to Define and Use Validation Groups

**1. Define Group Interfaces**

```java
public interface Create {}
public interface Update {}
```

These are just **marker interfaces** — no methods inside.

**2. Annotate Fields with Group Info**

Use the `groups` parameter on constraints to specify where they should apply:

```java
public class UserDTO {

    @NotNull(groups = Update.class)
    private Long id;

    @NotBlank(groups = Create.class)
    private String username;

    @NotBlank(groups = {Create.class, Update.class})
    private String email;
}
```

Explanation:

* `id` must be present only during **update**
* `username` must be provided only during **create**
* `email` must be valid in **both cases**

**3. Trigger Group-Specific Validation in Spring**

In **Spring MVC**, use `@Validated` instead of `@Valid` to specify the group:

```java
@PostMapping("/users")
public ResponseEntity<?> createUser(@Validated(Create.class) @RequestBody UserDTO user) {
    // Validates only fields with Create group
}
```

```java
@PutMapping("/users")
public ResponseEntity<?> updateUser(@Validated(Update.class) @RequestBody UserDTO user) {
    // Validates only fields with Update group
}
```
