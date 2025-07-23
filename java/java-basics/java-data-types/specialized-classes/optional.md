# Optional

## **About**

The `Optional` class in Java is a container object that may or may not contain a non-null value. It is part of the `java.util`package and was introduced in Java 8 to address the problem of `NullPointerException`. Instead of returning `null` to represent an absent value, you can return an `Optional` object, which explicitly indicates whether a value is present or absent.

The use of `Optional` promotes functional programming practices and enhances code readability by making null-checks explicit and reducing boilerplate code.

## **Features**

1. **Null-Safety:** Prevents `NullPointerException` by explicitly requiring developers to handle cases where a value might be absent.
2. **Clear Intent:** Encapsulates a value that might be null, making the code more readable and its intent clearer.
3. **Functional Paradigm:** Offers functional-style methods like `map`, `filter`, and `flatMap` for operating on values without directly handling nulls.
4. **Avoids Null Checks:** Simplifies code by replacing traditional null-checks with built-in methods like `ifPresent()`.
5. **Immutability:** Once an `Optional` is created, it is immutable, ensuring thread-safety and predictability.
6. **Interoperability:** Can be seamlessly used with streams, making it easier to handle optional values in pipelines.

## **Declaration & Functions**

### **Declaration**

To use `Optional`, import it and create an instance:

```java
import java.util.Optional;
```

### **Creating an Optional**

1.  **Empty Optional:**

    ```java
    Optional<String> emptyOptional = Optional.empty();
    ```
2.  **Optional with a Non-Null Value:**

    ```java
    Optional<String> optional = Optional.of("Hello");
    ```
3.  **Optional with a Nullable Value:**

    ```java
    Optional<String> nullableOptional = Optional.ofNullable(null); // Can contain null
    ```

### **Key Methods and Functions**

1.  **Checking Presence of Value:**

    ```java
    boolean isPresent = optional.isPresent();  // Returns true if value is present
    boolean isEmpty = optional.isEmpty();     // Returns true if value is absent (Java 11+)
    ```
2.  **Retrieving Values:**

    ```java
    String value = optional.get();            // Returns the value if present; throws NoSuchElementException if absent
    String orElse = optional.orElse("Default"); // Returns the value if present; otherwise returns the default value
    String orElseGet = optional.orElseGet(() -> "Default"); // Uses a supplier for the default value
    String orElseThrow = optional.orElseThrow(() -> new IllegalArgumentException("Value not found")); // Throws an exception if absent
    ```
3.  **Transforming Values:**

    ```java
    Optional<Integer> length = optional.map(String::length); // Applies the mapping function if value is present
    ```
4.  **Chaining Operations:**

    ```java
    Optional<String> flatMapped = optional.flatMap(value -> Optional.of("Processed: " + value));
    ```
5.  **Filtering Values:**

    ```java
    Optional<String> filtered = optional.filter(value -> value.startsWith("H"));
    ```
6.  **Performing Actions:**

    ```java
    optional.ifPresent(System.out::println);  // Executes the given action if value is present
    ```

## **Usage**

### **1. Avoiding NullPointerException:**

* `Optional` can replace null checks and provide safe access to a value.

```java
Optional<String> name = Optional.ofNullable(getName());
System.out.println(name.orElse("Default Name"));
```

### **2. Working with Streams:**

* Integrate `Optional` with streams for efficient data processing.

```java
List<String> names = Arrays.asList("Alice", null, "Bob");
List<String> result = names.stream()
                           .map(Optional::ofNullable)
                           .filter(Optional::isPresent)
                           .map(Optional::get)
                           .collect(Collectors.toList());
System.out.println(result); // Output: [Alice, Bob]
```

### **3. Database Queries:**

* Use `Optional` to represent the result of a query that may not return a value.

```java
Optional<User> user = userRepository.findById(userId);
user.ifPresent(u -> System.out.println(u.getName()));
```

### **4. Chained Processing:**

* Chain multiple operations without explicit null checks.

```java
String result = optional
    .map(String::toUpperCase)
    .filter(value -> value.length() > 3)
    .orElse("Default");
System.out.println(result);
```

**5. Replacing `null` in APIs:**

* Replace `null` return values in API methods with `Optional`.

```java
public Optional<User> findUserById(String id) {
    return Optional.ofNullable(userDatabase.get(id));
}
```

**6. Default Values:**

* Use `orElse` and `orElseGet` to provide fallback values.

```java
String value = optional.orElse("Default Value");
```

## **Best Practices**

* **Do Use:**
  * When a value might or might not be present (e.g., for results of database queries or configurations).
  * In APIs to make nullability explicit and avoid confusion.
* **Do Not Use:**
  * For every field or method return type, as overusing `Optional` can unnecessarily complicate code.
  * As a field in an entity class, as it complicates serialization and increases memory overhead.



