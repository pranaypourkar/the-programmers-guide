# Optional

## **About**

`Optional` is a container object introduced in **Java 8** that is used to represent a value that may or may not be present. It is part of the `java.util` package and is designed to help avoid `NullPointerException` by providing a more expressive way to handle absent values. Instead of returning `null`, a method can return an `Optional`, signaling that the result might be missing.

`Optional` is commonly used in functional programming paradigms and makes code more readable by encouraging the handling of missing values explicitly.

## **Features**

1. **Null Safety**: Helps avoid `NullPointerException` by clearly signaling the possibility of a missing value.
2. **Immutability**: Once created, `Optional` objects are immutable.
3. **Functional Programming**: Supports functional-style operations like `map()`, `flatMap()`, `filter()`, and `ifPresent()`.
4. **Empty Representation**: `Optional` provides an `empty()` method for representing the absence of a value.
5. **Lazy Evaluation**: Operations on an `Optional` are lazily evaluated, meaning the value is only computed when needed.
6. **Chainable Operations**: Multiple operations can be chained together using methods like `map()`, `flatMap()`, and `filter()`.

## **Key Methods**

Here are some of the key methods provided by the `Optional` class:

<table data-header-hidden data-full-width="true"><thead><tr><th width="342"></th><th></th></tr></thead><tbody><tr><td><strong>Method</strong></td><td><strong>Description</strong></td></tr><tr><td><strong><code>empty()</code></strong></td><td>Returns an empty <code>Optional</code>, representing a missing value.</td></tr><tr><td><strong><code>of(T value)</code></strong></td><td>Returns an <code>Optional</code> containing the specified non-null value.</td></tr><tr><td><strong><code>ofNullable(T value)</code></strong></td><td>Returns an <code>Optional</code> containing the value, or an empty <code>Optional</code> if the value is <code>null</code>.</td></tr><tr><td><strong><code>isPresent()</code></strong></td><td>Returns <code>true</code> if the value is present (non-null), otherwise <code>false</code>.</td></tr><tr><td><strong><code>ifPresent(Consumer&#x3C;? super T> action)</code></strong></td><td>Executes the given action if the value is present.</td></tr><tr><td><strong><code>get()</code></strong></td><td>Returns the value contained in the <code>Optional</code> if present; throws <code>NoSuchElementException</code> if not present.</td></tr><tr><td><strong><code>orElse(T other)</code></strong></td><td>Returns the value if present; otherwise, returns the provided default value.</td></tr><tr><td><strong><code>orElseGet(Supplier&#x3C;? extends T> other)</code></strong></td><td>Returns the value if present; otherwise, invokes the provided supplier to return a default value.</td></tr><tr><td><strong><code>orElseThrow(Supplier&#x3C;? extends X> exceptionSupplier)</code></strong></td><td>Returns the value if present; otherwise, throws an exception provided by the supplier.</td></tr><tr><td><strong><code>map(Function&#x3C;? super T, ? extends U> mapper)</code></strong></td><td>If the value is present, applies the given function to it and returns an <code>Optional</code>containing the result.</td></tr><tr><td><strong><code>flatMap(Function&#x3C;? super T, Optional&#x3C;U>> mapper)</code></strong></td><td>Similar to <code>map()</code>, but the function must return an <code>Optional</code> instead of a plain value.</td></tr><tr><td><strong><code>filter(Predicate&#x3C;? super T> predicate)</code></strong></td><td>If the value is present and matches the predicate, returns an <code>Optional</code> containing the value; otherwise, returns an empty <code>Optional</code>.</td></tr></tbody></table>

## **Internal Working**

1. **Structure**:
   * `Optional` contains either a **value** (if present) or is **empty** (no value).
   * When an `Optional` is created with a value, it holds a reference to the actual object. If it's empty, it holds `null`internally but exposes a clean API for checking presence.
2. **Creation**:
   * We can create an `Optional` using `Optional.of(value)` (if non-null) or `Optional.ofNullable(value)` (if the value might be `null`).
3. **Value Handling**:
   * The `Optional` class provides methods to extract the value only if it's present, otherwise providing alternatives (e.g., `orElse`, `orElseGet`).
4. **Functional Operations**:
   * `map()` and `flatMap()` allow transformations of the value inside the `Optional`.
   * `ifPresent()` allows actions based on the presence of the value.
5. **Empty Representation**:
   * `Optional.empty()` represents the absence of a value, and methods like `isPresent()` and `ifPresent()`handle the absence explicitly.

## **Limitations**

1. **Overuse in Collections**:`Optional` should not be used in collections (e.g., `List<Optional<T>>`), as it leads to unnecessary complexity.
2. **Not for Null Parameters**: While `Optional` is great for return types, it should not be used for method parameters. A null check should suffice for arguments.
3. **No Performance Benefit**:`Optional` does not offer any performance improvement over using `null` values directly, and in some cases, it might add unnecessary overhead.
4. **Verbosity in Some Cases**: Using `Optional` for simple cases (like a single nullable field) might add unnecessary verbosity.
5. **Cannot Replace All Null Handling**:`Optional` can’t replace all instances of `null`. Some situations still require the use of `null` (like for legacy code or certain APIs).

## **Real-World Usage**

1. **Method Return Values**: Used in APIs to explicitly represent a value that might be absent, such as finding an object in a database.
2. **Functional Style Programming**: Encourages functional programming practices by enabling chainable operations and transformations.
3. **Null Safety**: Avoids `NullPointerExceptions` by forcing explicit handling of potential `null` values.
4. **Optional Chaining**: Enables safer chaining of operations when dealing with potentially missing values.

## **Examples**

### **1. Creating an Optional**

```java
import java.util.Optional;

public class OptionalExample {
    public static void main(String[] args) {
        // Creating an Optional with a value
        Optional<String> present = Optional.of("Hello");
        System.out.println(present.isPresent()); // Output: true

        // Creating an Optional with a nullable value
        Optional<String> absent = Optional.ofNullable(null);
        System.out.println(absent.isPresent()); // Output: false
    }
}
```

### **2. Using `ifPresent()` to Handle Presence**

```java
import java.util.Optional;

public class OptionalExample {
    public static void main(String[] args) {
        Optional<String> present = Optional.of("Hello");
        
        present.ifPresent(value -> System.out.println(value.toUpperCase())); // Output: HELLO
    }
}
```

### **3. Using `orElse()` for Default Value**

```java
import java.util.Optional;

public class OptionalExample {
    public static void main(String[] args) {
        Optional<String> absent = Optional.ofNullable(null);
        
        // If the value is not present, return a default value
        String result = absent.orElse("Default Value");
        System.out.println(result); // Output: Default Value
    }
}
```

### **4. Chaining Methods with `map()` and `flatMap()`**

```java
import java.util.Optional;

public class OptionalExample {
    public static void main(String[] args) {
        Optional<String> present = Optional.of("Java");

        // Use map to transform the value inside the Optional
        Optional<String> upperCase = present.map(String::toUpperCase);
        System.out.println(upperCase.get()); // Output: JAVA

        // Use flatMap when the transformation itself returns an Optional
        Optional<Optional<String>> transformed = present.flatMap(value -> Optional.of(value.toLowerCase()));
        System.out.println(transformed.get().get()); // Output: java
    }
}
```

### **5. Using `orElseThrow()` to Handle Absence**

```java
import java.util.Optional;

public class OptionalExample {
    public static void main(String[] args) {
        Optional<String> absent = Optional.ofNullable(null);

        // Throw an exception if the value is not present
        try {
            String value = absent.orElseThrow(() -> new IllegalArgumentException("Value is missing"));
        } catch (IllegalArgumentException e) {
            System.out.println(e.getMessage()); // Output: Value is missing
        }
    }
}
```
