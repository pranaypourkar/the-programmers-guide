---
hidden: true
---

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









