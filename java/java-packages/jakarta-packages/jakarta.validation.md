# jakarta.validation

## About

The `jakarta.validation` package is the result of the **Java EE to Jakarta EE namespace migration**. Starting with **Jakarta EE 9**, all enterprise APIs moved from the `javax.*` namespace to `jakarta.*`.

Thus, `jakarta.validation` is **functionally equivalent** to `javax.validation`, but **in a different namespace**. It continues to evolve as part of the Jakarta EE platform.

* **JSR 380 (Bean Validation 2.0)** is the latest finalized version.
* **Specification name**: Jakarta Bean Validation.
* **Maintained by**: Eclipse Foundation.
* **Reference Implementation**: Hibernate Validator.

{% hint style="success" %}
Many frameworks (like Spring Boot < 3.0) still rely on `javax.*`. Spring Boot 3.0+ supports `jakarta.validation`.
{% endhint %}

## **Package Purpose**

The package provides a standard **constraint declaration and validation model** for JavaBeans and method-level parameters/return values. It allows for:

* Declarative constraints on bean properties.
* Constraint composition and custom validators.
* Validation groups.
* Constraint validation on method parameters and return types.

## **Namespace Migration Note**

| Old API (`javax.validation`) | New API (`jakarta.validation`) |
| ---------------------------- | ------------------------------ |
| javax.validation.Validator   | jakarta.validation.Validator   |
| javax.validation.constraints | jakarta.validation.constraints |
| javax.validation.Payload     | jakarta.validation.Payload     |

The classes and functionality are **identical** unless newer versions extend them.

## **Validator Interface**

Main entry point for programmatic validation.

```java
jakarta.validation.Validator validator = factory.getValidator();
Set<ConstraintViolation<MyBean>> violations = validator.validate(bean);
```

## **Constraint Annotations**

Defined in `jakarta.validation.constraints`. Used on fields, getters, parameters, and more.

| Constraint                | Description                                   |
| ------------------------- | --------------------------------------------- |
| `@NotNull`                | Field must not be null.                       |
| `@Size(min=, max=)`       | Validates size of collections/strings.        |
| `@Min(value=)`            | Field must be greater than or equal to value. |
| `@Max(value=)`            | Field must be less than or equal to value.    |
| `@Pattern(regexp=)`       | Field must match the given regex.             |
| `@Email`                  | Valid email syntax.                           |
| `@Positive` / `@Negative` | Positive/negative numbers only.               |
| `@Past`, `@Future`        | For date/time fields.                         |
| `@Null`                   | Field must be null.                           |
| `@NotEmpty`               | Collection or string must not be empty.       |
| `@NotBlank`               | String must contain non-whitespace text.      |

### **Bean Validation Flow**

1. **Define Constraints** on our Java class using annotations.
2. **Create a Validator** using `Validation.buildDefaultValidatorFactory()`.
3. **Call validate()** method on the bean.
4. **Handle ConstraintViolations** for errors.

### **Example: Simple Bean with Jakarta Validation**

```java
public class User {
    @NotNull
    private String username;

    @Size(min = 6)
    private String password;

    @Email
    private String email;
}
```

```java
ValidatorFactory factory = Validation.buildDefaultValidatorFactory();
Validator validator = factory.getValidator();

User user = new User();
Set<ConstraintViolation<User>> violations = validator.validate(user);
```

### **ConstraintViolation\<T>**

Each violation contains:

* `getMessage()` – the error message.
* `getPropertyPath()` – path to the property.
* `getInvalidValue()` – the invalid value.
* `getRootBean()` – original bean.
* `getConstraintDescriptor()` – annotation metadata.

### **Custom Constraints with `ConstraintValidator`**

Define your own validation logic.

**Step 1: Define the annotation**

```java
@Constraint(validatedBy = MyValidator.class)
@Target({ FIELD })
@Retention(RUNTIME)
public @interface MyConstraint {
    String message() default "Invalid data";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
```

**Step 2: Implement `ConstraintValidator`**

```java
public class MyValidator implements ConstraintValidator<MyConstraint, String> {
    public boolean isValid(String value, ConstraintValidatorContext context) {
        return value != null && value.startsWith("ABC");
    }
}
```

### **`@Valid` Annotation**

Used for **cascading validation** on nested objects.

```java
public class Order {
    @Valid
    private Customer customer;
}
```

If `Customer` has constraints, they are validated too.

### **Validation Groups**

Groups enable conditional validation.

```java
public interface Create {}
public interface Update {}

@NotNull(groups = Create.class)
private String name;
```

```java
validator.validate(bean, Create.class);
```

## **Executable Validation (Method and Constructor Parameters)**

Validate method arguments and return values.

```java
public class UserService {
    public void register(@NotNull User user) { ... }
}
```

Use `jakarta.validation.executable.ExecutableValidator`.

## **Parameter Validation on Constructors**

```java
public class Product {
    public Product(@NotNull String id, @Positive int quantity) {
        ...
    }
}
```

Handled via `ExecutableValidator`.

## **Message Customization**

Default messages come from the annotation, or we can externalize them using a `ValidationMessages.properties` file.

```properties
my.custom.message=This value is not allowed
```

## **Programmatic Constraint Declaration**

While annotations are the most common, the `jakarta.validation` API allows building constraints programmatically via metadata APIs (rarely used in practice).

### **ConstraintTarget and Payload Use**

* `ConstraintTarget` is used when we want to apply constraint on a return value vs. parameters.
* `Payload` can carry metadata (e.g., error severity or category).
