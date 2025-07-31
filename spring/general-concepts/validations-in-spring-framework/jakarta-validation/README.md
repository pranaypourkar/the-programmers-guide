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
@RestController
@Validated
public class UserController { ... }
```

### 3. Nested (Recursive) Validation with `@Valid`

```java
public class OrderDto {
    @Valid
    private AddressDto address;

    @Valid
    private List<ItemDto> items;
}
```

#### Internal Workflow:

* During traversal, Spring checks if a field has `@Valid`.
* If yes, it descends into that object and applies all constraints.
* Recursion happens automatically.

```java
public class ItemDto {
    @NotNull
    private String name;
}
```

If one `ItemDto` has null `name`, it’s picked up as a nested constraint violation.

### 4. Service-layer (Method-level) Validation using `@Validated`

Service-layer validation using `@Validated` allows us to **validate method parameters or return values** in any Spring-managed bean—especially in the **service layer**, where we might not rely on Spring MVC controller-level validation. It’s part of the **Method Validation** feature provided by **Jakarta Bean Validation** and integrated into Spring via proxies.

When we annotate a class with `@Validated`, Spring uses **AOP (Aspect-Oriented Programming)** to create a proxy that intercepts method calls and performs validation before the actual method runs. Internally, Spring uses the `MethodValidationPostProcessor` bean which wraps beans with a proxy capable of method validation.

#### Execution Flow:

1. Spring boot automatically registers a `MethodValidationPostProcessor`.
2. We annotate our class with `@Validated`.
3. Spring creates a **proxy** of the class.
4. Before executing our method, Spring uses the `ExecutableValidator` to:
   * Validate **method parameters**
   * Optionally validate the **return value**
5. If validation fails, Spring throws a `ConstraintViolationException`.

#### Example

```java
@Service
@Validated
public class UserService {

    public void registerUser(@NotBlank String name, @Min(18) int age) {
        // Business logic
    }

    public @NotNull String findUsernameById(@Positive Long id) {
        return "john_doe";
    }
}
```

#### Calling code:

```java
userService.registerUser("", 15);
```

#### Result:

Spring will throw a `ConstraintViolationException` because:

* `name` is blank (`@NotBlank`)
* `age` is less than 18 (`@Min(18)`)

### 5. Validation Groups Internally

```java
public class UserDto {
    @NotNull(groups = Update.class)
    private Long id;

    @NotBlank(groups = {Create.class, Update.class})
    private String name;
}
```

#### How It Works:

* Spring detects group classes passed in `@Validated(Update.class)`
*   Passes these group classes to the validator:

    ```java
    validator.validate(userDto, Update.class)
    ```
* Only the constraints in that group are applie

### 6. Manual Validation using Validator

```java
@Autowired
private Validator validator;

public void checkUser(UserDto user) {
    Set<ConstraintViolation<UserDto>> violations = validator.validate(user);

    for (ConstraintViolation<UserDto> violation : violations) {
        System.out.println(violation.getPropertyPath() + ": " + violation.getMessage());
    }
}
```

## When and How Validation is Triggered ?

If I Add Jakarta Validation Annotations to a DTO and Populate It — Will Constraints Be Checked Automatically?

**No**, the constraints **will not be checked automatically** just because we annotated our DTO with validation annotations (like `@NotBlank`, `@Email`, etc.).\
They are **only enforced when explicitly triggered** — either:

* By Spring (e.g., using `@Valid`, `@Validated`)
* Or manually by calling `Validator.validate(...)`

### Example

#### 1. **DTO With Constraints**

```java
public class UserDto {
    @NotBlank
    private String name;

    @Email
    private String email;

    // getters and setters
}
```

#### 2. **Populating DTO Manually**

```java
UserDto user = new UserDto();
user.setName("");                 // Invalid: @NotBlank violated
user.setEmail("not-an-email");   // Invalid: @Email violated

System.out.println(user.getName()); // This prints "" without any error
```

#### What Happens Here?

* **Nothing is validated** at this point.
* Java doesn't throw errors just because annotations exist — they’re metadata.
* The validation must be explicitly **triggered**.

{% hint style="success" %}
if you have a custom class (e.g., an entity or DTO) annotated with Jakarta validation constraints, those constraints do nothing unless validation is explicitly triggered.
{% endhint %}

### How to Trigger Validation ?

#### Option A: **Manual Trigger**

```java
Validator validator = Validation.buildDefaultValidatorFactory().getValidator();
Set<ConstraintViolation<UserDto>> violations = validator.validate(user);

for (ConstraintViolation<UserDto> v : violations) {
    System.out.println(v.getPropertyPath() + ": " + v.getMessage());
}
```

This will print:

```
name: must not be blank
email: must be a well-formed email address
```

#### Option B: **Automatically via Spring**

When used in a Spring controller or service, Spring triggers validation for us.

**Controller:**

```java
@PostMapping("/create")
public ResponseEntity<?> createUser(@Valid @RequestBody UserDto userDto) {
    ...
}
```

* Spring will call `validator.validate(userDto)`
* If any violation, it throws `MethodArgumentNotValidException`

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
