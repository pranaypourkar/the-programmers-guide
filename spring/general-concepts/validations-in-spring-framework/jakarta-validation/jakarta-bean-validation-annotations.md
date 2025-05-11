# Jakarta Bean Validation Annotations

## About

Here is a table for all core annotations in the **Jakarta Bean Validation API** (`jakarta.validation.constraints`)

{% hint style="success" %}
**Note**

* All annotations belong to the package: `jakarta.validation.constraints.*`
* Use `@Valid` on fields or method parameters to trigger validation recursively for complex/nested objects.
* These annotations are declarative and interpreted at runtime by a `Validator` implementation (like Hibernate Validator).
{% endhint %}

## Table

<table data-full-width="true"><thead><tr><th width="230.796875">Annotation</th><th width="199.48828125">Applies To</th><th>Description</th></tr></thead><tbody><tr><td><code>@NotNull</code></td><td>All types</td><td>Ensures that the value is not <code>null</code>. Commonly used for required fields. Does not check for emptiness (e.g., <code>""</code> is valid).</td></tr><tr><td><code>@Null</code></td><td>All types</td><td>Ensures the value is <code>null</code>. Rarely used alone, but can be useful with validation groups (e.g., <code>id</code> must be null during creation).</td></tr><tr><td><code>@NotEmpty</code></td><td><code>String</code>, <code>Collection</code>, <code>Map</code>, <code>Array</code></td><td>Ensures the value is not <code>null</code> and not empty. For strings, <code>""</code> fails. For collections/maps, <code>size > 0</code> is required.</td></tr><tr><td><code>@NotBlank</code></td><td><code>String</code> only</td><td>Stronger than <code>@NotEmpty</code>. Ensures string is not <code>null</code>, not <code>""</code>, and not only whitespace.</td></tr><tr><td><code>@Size(min=, max=)</code></td><td><code>String</code>, <code>Collection</code>, <code>Map</code>, <code>Array</code></td><td>Ensures that the length or size falls within the specified bounds.</td></tr><tr><td><code>@Min(value)</code></td><td>Numeric types (<code>int</code>, <code>long</code>, etc.)</td><td>Ensures that the value is <strong>greater than or equal to</strong> the specified minimum.</td></tr><tr><td><code>@Max(value)</code></td><td>Numeric types</td><td>Ensures the value is <strong>less than or equal to</strong> the specified maximum.</td></tr><tr><td><code>@DecimalMin(value, inclusive=true)</code></td><td>Numeric types, <code>String</code>, <code>BigDecimal</code></td><td>Ensures the value is ≥ the specified decimal value. <code>inclusive=false</code> allows exclusive min.</td></tr><tr><td><code>@DecimalMax(value, inclusive=true)</code></td><td>Same as above</td><td>Ensures the value is ≤ the specified decimal value.</td></tr><tr><td><code>@Positive</code></td><td>Numeric types</td><td>Ensures the value is strictly greater than 0.</td></tr><tr><td><code>@PositiveOrZero</code></td><td>Numeric types</td><td>Ensures the value is 0 or greater.</td></tr><tr><td><code>@Negative</code></td><td>Numeric types</td><td>Ensures the value is strictly less than 0.</td></tr><tr><td><code>@NegativeOrZero</code></td><td>Numeric types</td><td>Ensures the value is less than or equal to 0.</td></tr><tr><td><code>@Digits(integer=, fraction=)</code></td><td>Numeric types</td><td>Ensures the number has up to <code>integer</code> digits before the decimal and <code>fraction</code> digits after.</td></tr><tr><td><code>@Past</code></td><td><code>Date</code>, <code>Calendar</code>, <code>LocalDate</code>, etc.</td><td>Ensures the date is before the current time.</td></tr><tr><td><code>@PastOrPresent</code></td><td>Same as above</td><td>Ensures the date is either in the past or now.</td></tr><tr><td><code>@Future</code></td><td>Same as above</td><td>Ensures the date is strictly in the future.</td></tr><tr><td><code>@FutureOrPresent</code></td><td>Same as above</td><td>Ensures the date is in the future or now.</td></tr><tr><td><code>@Pattern(regexp="...")</code></td><td><code>String</code> only</td><td>Validates the string against the given regular expression. Commonly used for phone numbers, usernames, etc.</td></tr><tr><td><code>@Email</code></td><td><code>String</code> only</td><td>Ensures that the string is a valid email address. Also accepts a <code>regexp</code> for stricter formats.</td></tr><tr><td><code>@AssertTrue</code></td><td><code>boolean</code>, <code>Boolean</code></td><td>Validates that the value is <code>true</code>. Commonly used for checkboxes or policy acceptance.</td></tr><tr><td><code>@AssertFalse</code></td><td><code>boolean</code>, <code>Boolean</code></td><td>Validates that the value is <code>false</code>.</td></tr><tr><td><code>@Valid</code></td><td>Object, Collection of objects</td><td>Triggers nested validation. This is required if the validated bean has fields or properties that are other beans with their own validation annotations.</td></tr><tr><td><code>@GroupSequence</code></td><td>On interfaces</td><td>Used to define the order in which validation groups are evaluated. If a group fails, later ones are skipped.</td></tr><tr><td><code>@ConvertGroup(from=, to=)</code></td><td>On <code>@Valid</code> annotated fields</td><td>Allows converting one validation group to another for nested beans. Used when different rules apply depending on parent context.</td></tr><tr><td><code>@ReportAsSingleViolation</code></td><td>On custom composed annotations</td><td>When used in a composed constraint, makes sure the composed annotation reports only a single violation message, not one per sub-constraint.</td></tr><tr><td><code>@Constraint(validatedBy=...)</code></td><td>Custom annotation</td><td>This is used to mark a custom constraint annotation and specify the associated validator implementation. Mandatory for creating your own validation annotations.</td></tr></tbody></table>

## What is @Valid and @Validated Annotation ?

### `@Valid`

* `@Valid` is part of **Jakarta Bean Validation** (`jakarta.validation.Valid`).
* It tells Spring or the Validator to **perform validation on the object it is placed on**.
* It can be used on:
  * Method parameters (especially in controllers)
  * Fields (for nested validation)
  * Inside service or other layers when using the Validator API

#### Use Cases and Working

**1. Controller-level validation (with @RequestBody):**

```java
@PostMapping("/users")
public ResponseEntity<Void> createUser(@RequestBody @Valid UserDto userDto) {
    // If userDto is invalid, Spring will return 400 Bad Request with error details.
}
```

**Explanation:**

* When Spring sees `@Valid` on `@RequestBody`, it checks the `UserDto` class for validation annotations (`@NotNull`, `@Size`, etc.).
* If validation fails, **Spring automatically returns** a `400 Bad Request`.
* You don’t need to write any manual validation logic.

{% hint style="info" %}
Spring’s automatic validation for `@RequestBody` only kicks in for **complex objects** marked with `@Valid` or `@Validated`. For primitives like `String`, it won't do anything — even if we annotate them with constraint annotations like @NotNull.

We need it to wrap to make it work.

public class NameRequest {\
@NotNull\
private String str;\
}

public ResponseEntity createUser(@RequestBody @Valid NameRequest request) {\
// Now it will be validated correctly.\
}
{% endhint %}

**2. Nested object validation:**

```java
public class Order {
    @Valid
    private Customer customer;
}
```

**Explanation:**

* When validating an `Order`, Spring/Validator will **recursively validate** the `Customer` object if it's annotated with `@Valid`.

**3. Manual validation (in service or elsewhere):**

```java
Validator validator = Validation.buildDefaultValidatorFactory().getValidator();
Set<ConstraintViolation<UserDto>> violations = validator.validate(userDto);
```

**Explanation:**

* We explicitly call the validator and check the result.
* Useful when we're outside the controller (e.g., in services, CLI apps).

### `@Validated`

* `@Validated` is **provided by Spring** (`org.springframework.validation.annotation.Validated`).
* It **enhances** `@Valid` by adding:
  * **Validation Groups support**
  * **Method-level validation** (when used on Spring-managed beans)

#### Use Cases and Working

**1. Validation groups (selective validation):**

```java
@PostMapping("/users")
public ResponseEntity<Void> createUser(@RequestBody @Validated(Create.class) UserDto userDto) {
    // Only constraints marked with Create.class will be validated
}
```

**Explanation:**

* We can define multiple validation scenarios using interfaces (`Create`, `Update`, etc.).
* Use them to apply different rules depending on the operation (create, update).

**2. Service-layer method validation:**

```java
@Validated
@Service
public class UserService {

    public void updateUser(@Valid @NotNull UserDto userDto) {
        // Spring AOP intercepts this and performs validation on method parameters.
    }
}
```

**Explanation:**

#### 1. **`@Validated` on the `UserService` class:**

* `@Validated` is a Spring annotation that triggers **method-level validation**.
* When applied at the **class level**, Spring will **automatically validate** method parameters marked with validation annotations (like `@Valid`, `@NotNull`) for every method in the class.
* It works by using **Spring AOP (Aspect-Oriented Programming)**. A proxy is created around the `UserService` class, and this proxy intercepts method calls to validate the parameters of the method before execution.
* **Key point**: This will only work if `UserService` is a Spring-managed bean (i.e., it is created by Spring’s IoC container, which is the case because it's annotated with `@Service`).

#### 2. **`@Service` on the `UserService` class:**

* The `@Service` annotation marks this class as a Spring **service component**.
* Spring will manage this class, and it will be available for **dependency injection** in other parts of your application.
* This means Spring will automatically create an instance of `UserService` when needed and apply any AOP (like validation) to its methods.

#### 3. **`@Valid` on the `userDto` parameter:**

* The `@Valid` annotation is a **Jakarta Bean Validation annotation** (`jakarta.validation.Valid`).
* It triggers the **validation** of the `userDto` object and all its **nested properties**.
* Spring will check whether the `userDto` object and its fields conform to any constraints defined in the `UserDto` class (such as `@NotNull`, `@Size`, etc.).
* If the `userDto` is invalid (i.e., one of its constraints is violated), Spring will **throw an exception** or **return a 400 Bad Request** if used in a controller.

#### 4. **`@NotNull` on the `userDto` parameter:**

* The `@NotNull` annotation is a **constraint** that indicates the `userDto` cannot be `null`.
* This works in conjunction with `@Valid` to ensure that not only the `userDto` object is validated, but also that the `userDto` itself is not `null`.
* If the `userDto` is `null`, a validation violation occurs.
