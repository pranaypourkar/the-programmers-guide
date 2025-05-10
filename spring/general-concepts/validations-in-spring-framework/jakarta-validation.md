# Jakarta Validation

## About

**Bean Validation** is a standard framework for **declaring and enforcing validation rules on JavaBeans** (POJOs) using annotations. It provides a way to validate the state of objects either automatically (e.g., during web requests in Spring) or manually (programmatically).

It originated as **JSR-303**, evolved to **JSR-380 (Bean Validation 2.0)**, and now resides under the **Jakarta EE** umbrella as `jakarta.validation`.

This API does **not implement validation logic itself**. It defines **metadata (annotations)** and **interfaces**. The actual logic is implemented by a **provider**, most commonly **Hibernate Validator**.

## Why is Jakarta Bean Validation important in Spring ?

* It integrates seamlessly with Spring Web MVC and Spring Boot.
* It supports both **automatic validation** of controller inputs and **manual validation** in service layers.
* It enables declarative and reusable constraint definitions.
* It standardizes validation across frameworks and layers.

## Jakarta Bean Validation Components

### 1. Constraint Annotations

These are placed on class fields or method parameters:

* `@NotNull`: Value must not be null.
* `@NotEmpty`: Value must not be null or empty (for strings, collections).

### 2. Meta Annotations

* `@Constraint`: Used when defining custom constraints.
* `@Valid`: Triggers recursive validation on associated objects or collections.

### 3. Interfaces

* `jakarta.validation.Validator`: The core interface to validate beans.
* `jakarta.validation.ConstraintValidator<A extends Annotation, T>`: Interface for implementing custom constraint logic.
* `jakarta.validation.ConstraintViolation<T>`: Represents a single validation error.

### 4. Bootstrap API

* `Validation.buildDefaultValidatorFactory()` creates a `ValidatorFactory` which provides a `Validator`.

## Features

* Declarative constraints using annotations
* Pluggable constraint validators
* Support for nested validation (`@Valid`)
* Group-based validation (`groups`)
* Method and constructor parameter validation
* Custom constraints

## How Spring Integrates with Jakarta Validation ?

When `jakarta.validation` (or `javax.validation`) API and a provider like **Hibernate Validator** is on the classpath, Spring Boot auto-configures:

* `LocalValidatorFactoryBean`: A Spring `Validator` that delegates to Jakarta Validator.
* `MethodValidationPostProcessor`: Enables method-level validation using `@Validated`.

**Dependencies**

```xml
<!-- Required for Bean Validation -->
<dependency>
  <groupId>org.hibernate.validator</groupId>
  <artifactId>hibernate-validator</artifactId>
</dependency>
```

{% hint style="success" %}
Spring Boot starter `spring-boot-starter-web` includes Hibernate Validator by default.
{% endhint %}

## Spring Validation Flow

Spring integrates with the **Jakarta Bean Validation API** via the `LocalValidatorFactoryBean` and auto-wires it as a global validator.

There are **two major validation triggers** in Spring:

1. **Method-level validation** (Spring MVC controllers, service beans, etc.)
2. **Manual (programmatic) validation** using `Validator`

Spring internally:

* Detects the `@Valid` or `@Validated` annotations
* Delegates to the `jakarta.validation.Validator` interface (via Hibernate Validator)
* Collects `ConstraintViolation`s and throws exceptions like:
  * `MethodArgumentNotValidException` (for body-bound beans)
  * `ConstraintViolationException` (for method parameter validation)
  * `BindException` (for form data)

### 1. Controller-level Validation on `@RequestBody` DTO

```javascript
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public class UserDto {

    @NotBlank(message = "Username must not be blank")
    @Size(min = 3, max = 20, message = "Username must be between 3 and 20 characters")
    private String username;

    @NotBlank(message = "Email must not be blank")
    @Email(message = "Email must be a well-formed email address")
    private String email;

    // Constructors
    public UserDto() {}

    public UserDto(String username, String email) {
        this.username = username;
        this.email = email;
    }

    // Getters and Setters
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}

```

```java
@PostMapping("/users")
public ResponseEntity<?> createUser(@Valid @RequestBody UserDto userDto) {
    return ResponseEntity.ok("Created");
}
```

**Internal Workflow:**

1. **Deserialization**: JSON request body is deserialized into `UserDto` using Jackson.
2. **Validation Trigger**: Spring detects `@Valid` on the parameter.
3. **Validator Bean**: Calls `validator.validate(userDto)` using `LocalValidatorFactoryBean`.
4. **Hibernate Validator** executes all constraints like `@NotBlank`, `@Email`.
5. **Failure**: If constraints fail:
   * Spring throws `MethodArgumentNotValidException`.
   * Handled globally with `@ExceptionHandler` or `@ControllerAdvice`.

**Example:**

```json
POST /users
{
  "username": "",
  "email": "abc"
}
```

Response:

```json
{
  "status": 400,
  "errors": [
    {"field": "username", "message": "Username must not be blank"},
    {"field": "email", "message": "Email must be a well-formed email address"}
  ]
}
```







## Validation Groups

By default, all validations belong to the **Default** group. Groups allow conditional or staged validation.

#### Define Marker Interfaces

```java
public interface Create {}
public interface Update {}
```

#### Apply to Fields

```java
public class User {

    @NotNull(groups = Update.class)
    private Long id;

    @NotBlank(groups = {Create.class, Update.class})
    private String name;
}
```

#### Validate with Groups

```java
@PostMapping("/users")
public ResponseEntity<?> create(@Validated(Create.class) @RequestBody User user) {
    ...
}
```

Spring uses `@Validated` (from `org.springframework.validation.annotation`) to support groups. `@Valid` does not support groups.

## Custom Constraints

### 1. Define annotation

```java
@Constraint(validatedBy = StrongPasswordValidator.class)
@Target({ FIELD, METHOD, PARAMETER, ANNOTATION_TYPE })
@Retention(RUNTIME)
public @interface StrongPassword {
    String message() default "Weak password";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
```

### 2. Implement logic

```java
public class StrongPasswordValidator implements ConstraintValidator<StrongPassword, String> {

    @Override
    public boolean isValid(String value, ConstraintValidatorContext context) {
        return value != null && value.length() >= 8 && value.matches(".*\\d.*");
    }
}
```

### 3. Use it in our bean

```java
@StrongPassword
private String password;
```

### 2. Controller-level Validation on `@RequestParam`, `@PathVariable`

```java
@GetMapping("/users/{id}")
public ResponseEntity<?> getUser(@PathVariable @Positive Long id) {
    ...
}
```

#### Internal Workflow:

* Uses **method-level validation**.
* Triggers via Spring’s `MethodValidationPostProcessor`.
* Detects `@Validated` on the class or method.
* Calls `executableValidator.validateParameters(...)`
* If invalid: throws `ConstraintViolationException`.

**Important**: `@Validated` must be applied at **class level** for method parameter validation:

```java
javaCopyEdit@RestController
@Validated
public class UserController { ... }
```

