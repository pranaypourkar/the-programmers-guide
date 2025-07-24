# Validation

## About

Jakarta Validation (formerly Bean Validation) is a Java specification that allows us to **declaratively define constraints** on object models (beans) and validate them **at runtime**. It is defined by the Jakarta EE platform and comes under the package `jakarta.validation`.

Originally part of the `javax.validation` package, it was renamed as part of the Jakarta EE transition. Jakarta Validation can be used in any Java SE application.

{% hint style="info" %}
Refer to the following pages fro more details - [javax.validation.md](../../java-packages/jakarta-packages/javax.validation.md "mention") & [jakarta.validation.md](../../java-packages/jakarta-packages/jakarta.validation.md "mention")
{% endhint %}

## **Primary Use Cases**

* Validating user input (e.g., REST API requests)
* Validating data transfer objects (DTOs)
* Validating method parameters and return values
* Applying cross-field and class-level validations

## Important Terminology

<table><thead><tr><th width="209.40625">Term</th><th>Description</th></tr></thead><tbody><tr><td>Constraint</td><td>A rule that must be satisfied by a field or object</td></tr><tr><td>Constraint Validator</td><td>A class that checks whether a given constraint is satisfied</td></tr><tr><td>Constraint Violation</td><td>A validation failure message returned after validation</td></tr><tr><td>Metadata</td><td>The annotations and their parameters defined on fields/methods</td></tr><tr><td>ConstraintDescriptor</td><td>Runtime metadata for each constraint</td></tr><tr><td>Validator</td><td>Main interface to perform validation operations</td></tr><tr><td><code>@Valid</code></td><td>Annotation to enable recursive/nested validation</td></tr><tr><td>Group</td><td>Allows validating only a specific subset of constraints</td></tr></tbody></table>

## **Example: Basic Flow**

```java
public class User {
    @NotNull
    @Size(min = 3)
    private String username;

    @Email
    private String email;
}
```

```java
User user = new User();
user.setUsername("ab"); // too short
user.setEmail("invalid_email");

Validator validator = Validation.buildDefaultValidatorFactory().getValidator();
Set<ConstraintViolation<User>> violations = validator.validate(user);
```

### **Execution Steps (Internal):**

1. At runtime, `Validator` reflects on the class `User`.
2. For each field:
   * It checks what constraint annotations are present.
   * Each constraint is mapped to a `ConstraintValidator` implementation.
3. The field value is extracted (e.g., `username = "ab"`).
4. The validator (`SizeValidator`) is executed.
5. If validation fails, it creates a `ConstraintViolation` with metadata like:
   * invalid value
   * message
   * path
   * constraint type
6. The process is repeated for all constraints and fields.
7. The result is a `Set<ConstraintViolation<T>>`.

{% hint style="success" %}
**Do we have to check violations manually?**

* Yes, if we're using pure Java SE (no Spring, no Jakarta EE web framework), we must manually invoke the validator as shown above.
* The framework does not validate automatically when we call `setUsername(...)`. Constraints are only applied when we call `validator.validate(obj)` or via framework support.

**Will Java do this automatically?**

* No. Not in Java SE.
* Yes. If we use a framework like Spring Boot or Jakarta REST with annotations like `@Valid`, then the framework will do this automatically.
{% endhint %}

## **Validator Interface and ConstraintValidator**

* `jakarta.validation.Validator`: Entry point to the validation engine.
* `jakarta.validation.ConstraintValidator<A, T>`: Generic interface to implement custom validation logic.

**How a Validator Works Internally**

Let’s walk through the execution using `@Email`.

```java
@Email
private String email;
```

1. The validation engine sees `@Email`.
2. The `EmailValidator` class is registered as the implementation of `ConstraintValidator<Email, String>`.
3. During validation:
   * The `initialize()` method of `EmailValidator` is called (if needed).
   * Then, the `isValid(value, context)` method is called.
   * Inside `isValid`, logic like regex matching or domain checking is applied.

**Code behind the scenes:**

```java
public class EmailValidator implements ConstraintValidator<Email, CharSequence> {
    public boolean isValid(CharSequence value, ConstraintValidatorContext context) {
        if (value == null) return true; // handled by @NotNull if needed
        return EmailValidatorImpl.isValidEmail(value.toString());
    }
}
```

## **Constraint Declaration and Meta-Annotations**

Every annotation like `@Email`, `@NotNull` is:

* Annotated with `@Constraint(validatedBy = X.class)`
* Annotated with `@Target`, `@Retention`
* Must define `message`, `groups`, `payload`

**Example: Behind `@NotNull`**

```java
@Constraint(validatedBy = NotNullValidator.class)
@Target({ METHOD, FIELD, PARAMETER })
@Retention(RUNTIME)
public @interface NotNull {
    String message() default "{jakarta.validation.constraints.NotNull.message}";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
```

## How Recursive / Nested Validation Works (`@Valid`)

Scenario:

```java
public class Order {
    @NotNull
    private String id;

    @Valid
    private Customer customer;
}

public class Customer {
    @NotNull
    private String name;

    @Email
    private String email;
}
```

#### What happens when we validate `Order`?

* When `Validator.validate(order)` is called:
  1. It sees `@Valid` on `customer` field.
  2. It recursively calls `validate(customer)`.
  3. Then applies `@NotNull` and `@Email` on the `Customer` fields.
* If `@Valid` is **not** present, **the nested object is skipped**.

## Validation Groups

We use Validation Groups if we want different validation rules in different scenarios (e.g., Create vs Update).

**Step 1: Define groups**

```java
public interface CreateGroup {}
public interface UpdateGroup {}
```

**Step 2: Use in model**

```java
public class User {
    @NotNull(groups = CreateGroup.class)
    private String username;

    @NotNull(groups = UpdateGroup.class)
    private Long id;
}
```

**Step 3: Validate by group**

```java
Validator validator = Validation.buildDefaultValidatorFactory().getValidator();

Set<ConstraintViolation<User>> createViolations = validator.validate(user, CreateGroup.class);
Set<ConstraintViolation<User>> updateViolations = validator.validate(user, UpdateGroup.class);
```
