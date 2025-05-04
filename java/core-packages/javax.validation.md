# javax.validation

## About

The `javax.validation` package provides the **Bean Validation** framework, introduced in **JSR 303** and updated in **JSR 349**. This framework is part of the Java EE specification but can also be used in standalone Java SE applications. It enables developers to validate JavaBeans (i.e., classes with fields or properties) in a declarative way using annotations or programmatically using a `Validator` instance.

The primary goal of **Bean Validation** (JSR 303/JSR 349) is to define a set of validation rules that can be applied to JavaBeans, ensuring that the data within the beans is consistent and correct. This validation can be triggered on fields, methods, and even constructor parameters, allowing for a flexible and unified approach to validation across different layers of an application.

## **Core Components of `javax.validation`**

The `javax.validation` package is built around a key components that interact with each other to facilitate validation. These components include annotations, constraint validators, and the `Validator` interface for executing validations.

### **1. Constraint Annotations**

These are **predefined annotations** that allow developers to specify validation rules for JavaBean fields. The annotations define **what** kind of validation is required and are applied to fields or methods in Java classes.

<table><thead><tr><th width="179.453125">Annotation</th><th>Description</th></tr></thead><tbody><tr><td><code>@NotNull</code></td><td>Ensures the field is <strong>not null</strong>.</td></tr><tr><td><code>@Null</code></td><td>Ensures the field is <strong>null</strong>.</td></tr><tr><td><code>@Size(min, max)</code></td><td>Ensures the size of the field is within the <code>min</code> and <code>max</code> bounds. Works for <code>String</code>, <code>Collection</code>, <code>Map</code>, and arrays.</td></tr><tr><td><code>@Min(value)</code></td><td>Ensures the field is greater than or equal to <code>value</code>.</td></tr><tr><td><code>@Max(value)</code></td><td>Ensures the field is less than or equal to <code>value</code>.</td></tr><tr><td><code>@Pattern(regex)</code></td><td>Ensures the field matches the specified regular expression.</td></tr><tr><td><code>@Email</code></td><td>Ensures the field contains a <strong>valid email address</strong>.</td></tr><tr><td><code>@Past</code></td><td>Ensures the date or <code>java.time</code> field is in the <strong>past</strong>.</td></tr><tr><td><code>@Future</code></td><td>Ensures the date or <code>java.time</code> field is in the <strong>future</strong>.</td></tr><tr><td><code>@AssertTrue</code></td><td>Ensures the field's boolean value is <strong>true</strong>.</td></tr><tr><td><code>@AssertFalse</code></td><td>Ensures the field's boolean value is <strong>false</strong>.</td></tr><tr><td><code>@Positive</code></td><td>Ensures the field is a <strong>positive number</strong>.</td></tr><tr><td><code>@Negative</code></td><td>Ensures the field is a <strong>negative number</strong>.</td></tr></tbody></table>

### **2. The Validator Interface**

The core of the **Bean Validation API** is the `Validator` interface, which defines methods to **validate** a bean or a property.

* **validate**: Validates an entire bean or object.
* **validateProperty**: Validates a single property of an object.
* **validateValue**: Validates a specific property with a given value, not tied to an actual object instance.

```java
ValidatorFactory factory = Validation.buildDefaultValidatorFactory();
Validator validator = factory.getValidator();

// Validate a bean (e.g., User object)
Set<ConstraintViolation<User>> violations = validator.validate(user);
for (ConstraintViolation<User> violation : violations) {
    System.out.println(violation.getMessage());
}
```

### **3. The ConstraintValidator Interface**

If the predefined annotations do not fulfill our validation needs, we can create **custom annotations** by implementing the `ConstraintValidator` interface.

This interface contains:

* `initialize()`: Initializes the custom validator (optional).
* `isValid()`: Defines the actual validation logic.

**Example:**

```java
@Target({ ElementType.FIELD })
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = MyValidator.class)
public @interface MyConstraint {
    String message() default "Invalid value";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}

public class MyValidator implements ConstraintValidator<MyConstraint, String> {
    @Override
    public boolean isValid(String value, ConstraintValidatorContext context) {
        return value != null && value.startsWith("ABC");
    }
}
```

### **4. ValidatorFactory**

* The `ValidatorFactory` is responsible for **creating** a `Validator` instance.
* It is obtained using `Validation.buildDefaultValidatorFactory()`.

**Example:**

```java
ValidatorFactory factory = Validation.buildDefaultValidatorFactory();
Validator validator = factory.getValidator();
```

### **5. Validation Groups**

Validation groups are used when we need **different validation constraints** for different scenarios (e.g., validation during creation vs. update). This allows for conditional validation based on context.

*   **Define Group Interfaces**:

    ```java
    public interface CreateGroup {}
    public interface UpdateGroup {}
    ```
*   **Apply Groups to Annotations**:

    ```java
    @NotNull(groups = CreateGroup.class)
    private String name;
    ```
*   **Validate with Specific Groups**:

    ```java
    validator.validate(user, CreateGroup.class);  // Only checks for `CreateGroup` constraints
    ```

### **6. The `Payload` Interface**

The `Payload` is used for carrying metadata information along with the validation constraints. It’s optional and often used in conjunction with custom constraints.

* It can be used to attach **additional information** such as an error code or other context-sensitive data.

### **7. Bootstrapping Validation**

Bean Validation requires **initialization** through a `ValidatorFactory`. This is typically done using the `Validation` class, which provides a simple way to initialize and retrieve a `ValidatorFactory` instance.

```java
ValidatorFactory factory = Validation.buildDefaultValidatorFactory();
Validator validator = factory.getValidator();
```

### **8. Validation Context**

* The `ConstraintViolation` interface provides details about the failed validation, including:
  * The **path** to the field that failed.
  * The **message** associated with the violation.
  * The **invalid value**.

**Example:**

```java
Set<ConstraintViolation<User>> violations = validator.validate(user);
for (ConstraintViolation<User> violation : violations) {
    System.out.println(violation.getPropertyPath() + " " + violation.getMessage());
}
```

### **9. Validating Method Parameters and Return Values**

* **Method-level validation** allows validating parameters and return values for methods. This is particularly useful in services and business logic.
* Use `@Valid` annotation on method parameters to trigger validation.

```java
public class UserService {
    public void createUser(@Valid User user) {
        // User object is validated before this method is invoked
    }
}
```

### **10. Integration with Java EE**

While `javax.validation` is independent of any framework, it can be **integrated with Java EE** (such as with CDI or EJB) or even with frameworks like **JSF**.

**Example:**

* In **CDI** (Contexts and Dependency Injection):
  * You can inject `Validator` directly into your CDI-managed beans.@Inject

```java
Validator validator;
```

### **11. Constraints for Collections and Maps**

The `javax.validation` API provides the ability to **validate collections** (such as `List`, `Set`, `Map`) with annotations like `@Size`, `@NotEmpty`, or `@NotNull`.

**Example:**

```java
@NotNull
@Size(min = 1)
private List<String> emails;
```

### **12. Constraining Dates and Time**

The API offers a variety of annotations for **validating dates and times**. This includes the `@Past` and `@Future` annotations for `java.util.Date` and `java.time` fields.

```java
@Past
private LocalDate birthDate;
```

### **13. Using the `Validation` Class**

The `Validation` class provides utility methods for **getting the default validator factory**. It's the entry point for starting the validation process.

```java
ValidatorFactory factory = Validation.buildDefaultValidatorFactory();
Validator validator = factory.getValidator();
```
