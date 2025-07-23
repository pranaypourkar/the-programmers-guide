# Java 8

## About

Java 8 introduced numerous significant features that changed the way Java developers write code.

## **1. Lambda Expressions**

Lambda expressions provide a clear and concise way to represent anonymous functions. They eliminate the need for boilerplate code when implementing functional interfaces.

**Example:**

```java
import java.util.*;

public class LambdaExample {
    public static void main(String[] args) {
        List<String> names = Arrays.asList("John", "Mary", "Peter", "Alice");

        // Using lambda expression to sort the list
        names.sort((s1, s2) -> s1.compareToIgnoreCase(s2));

        System.out.println(names);
    }
}
```

## **2. Functional Interfaces and `@FunctionalInterface` Annotation**

A **functional interface** is an interface with exactly one abstract method, used as a type for lambda expressions.

**Example:**

```java
@FunctionalInterface
interface MathOperation {
    int operate(int a, int b);
}

public class FunctionalInterfaceExample {
    public static void main(String[] args) {
        MathOperation addition = (a, b) -> a + b;
        System.out.println("Sum: " + addition.operate(5, 3));
    }
}
```

## **3. Default and Static Methods in Interfaces**

Interfaces can now contain default and static methods with implementations.

**Example:**

```java
interface Vehicle {
    default void print() {
        System.out.println("This is a vehicle");
    }

    static void soundHorn() {
        System.out.println("Honking...");
    }
}

class Car implements Vehicle {
    // Inherits default method
}

public class DefaultStaticMethodExample {
    public static void main(String[] args) {
        Vehicle car = new Car();
        car.print();
        Vehicle.soundHorn();
    }
}
```

## **4. Streams API**

The Streams API allows functional-style operations on collections.

#### **Example:**

```java
import java.util.*;
import java.util.stream.Collectors;

public class StreamExample {
    public static void main(String[] args) {
        List<String> names = Arrays.asList("Alice", "Bob", "Charlie", "David", "Eve");

        // Filter names starting with 'A' and collect to a list
        List<String> filteredNames = names.stream()
                .filter(name -> name.startsWith("A"))
                .collect(Collectors.toList());

        System.out.println(filteredNames);
    }
}
```

## **5. Method References**

Method references provide a shorthand notation for calling methods.

**Example:**

```java
import java.util.*;

public class MethodReferenceExample {
    public static void main(String[] args) {
        List<String> names = Arrays.asList("John", "Jane", "Alex");

        // Using method reference
        names.forEach(System.out::println);
    }
}
```

## **6. Optional Class**

The `Optional` class helps avoid `NullPointerException` by wrapping values that may be null.

**Example:**

```java
import java.util.Optional;

public class OptionalExample {
    public static void main(String[] args) {
        Optional<String> optionalValue = Optional.ofNullable(null);

        // Provide a default value if null
        String result = optionalValue.orElse("Default Value");
        System.out.println(result);
    }
}
```

## **7. New Date and Time API (`java.time` package)**

Java 8 introduced a modern `java.time` API to replace the legacy `java.util.Date` and `java.util.Calendar`.

**Example:**

```java
import java.time.*;

public class DateTimeExample {
    public static void main(String[] args) {
        LocalDate today = LocalDate.now();
        LocalTime currentTime = LocalTime.now();
        LocalDateTime dateTime = LocalDateTime.now();

        System.out.println("Date: " + today);
        System.out.println("Time: " + currentTime);
        System.out.println("DateTime: " + dateTime);
    }
}
```

## **8. Collectors in Streams**

`Collectors` are used to accumulate elements of a stream into a collection.

**Example:**

```java
import java.util.*;
import java.util.stream.Collectors;

public class CollectorsExample {
    public static void main(String[] args) {
        List<String> names = Arrays.asList("John", "Jane", "Alex", "Emma");

        // Collect names into a comma-separated string
        String result = names.stream()
                .collect(Collectors.joining(", "));

        System.out.println(result);
    }
}
```

## **9. `forEach()` Method in Iterable**

Java 8 introduced the `forEach` method for `Iterable` to iterate through collections.

**Example:**

```java
import java.util.*;

public class ForEachExample {
    public static void main(String[] args) {
        List<String> items = Arrays.asList("Apple", "Banana", "Cherry");

        items.forEach(item -> System.out.println(item));
    }
}
```

## **10. `computeIfAbsent()` and `computeIfPresent()` in `Map`**

Java 8 enhanced the `Map` interface with new methods.

**Example:**

{% hint style="success" %}
**`map.computeIfAbsent(K key, Function<? super K, ? extends V> mappingFunction)`**

* If the specified key is **not already associated with a value**, this method computes a value using the given mapping function and inserts it into the map.
* If the key is **already present**, it does nothing and returns the existing value.
* Useful for **lazy initialization** of values in a map.



**`map.computeIfPresent(K key, BiFunction<? super K, ? super V, ? extends V> remappingFunction)`**

* If the specified key is **already associated with a value**, this method computes a new value using the given remapping function and updates the map.
* If the function returns `null`, the key is removed from the map.
* If the key is **not present**, it does nothing.
* Useful for **modifying existing values** in a map without checking for null manually.
{% endhint %}

```java
import java.util.*;

public class MapEnhancements {
    public static void main(String[] args) {
        Map<String, Integer> map = new HashMap<>();

        map.put("A", 5);
        map.computeIfAbsent("B", key -> 10);
        map.computeIfPresent("A", (key, val) -> val * 2);

        System.out.println(map);
    }
}
```

{% hint style="info" %}
**`map.computeIfAbsent("B", key -> 10);`**

* Checks if the key `"B"` exists in the map.
* If not present, it computes a value using the lambda function `key -> 10` and puts `"B"` with the computed value `10` into the map.
* If already present, it does nothing and keeps the existing value.



**`map.computeIfPresent("A", (key, val) -> val * 2);`**

* Checks if the key `"A"` exists in the map.
* If present, it applies the function `(key, val) -> val * 2`, which doubles the value of `"A"`.
* If not present, it does nothing.
{% endhint %}

## **11. String Joiner (`java.util.StringJoiner`)**

The `StringJoiner` class is used for efficient string concatenation.

**Example:**

```java
import java.util.StringJoiner;

public class StringJoinerExample {
    public static void main(String[] args) {
        StringJoiner joiner = new StringJoiner(", ", "[", "]");

        joiner.add("Apple").add("Banana").add("Cherry");

        System.out.println(joiner.toString());
    }
}
```

## **12. Base64 Encoding and Decoding**

Java 8 introduced `Base64` encoding and decoding.

**Example:**

```java
import java.util.Base64;

public class Base64Example {
    public static void main(String[] args) {
        String originalString = "HelloWorld";
        
        String encoded = Base64.getEncoder().encodeToString(originalString.getBytes());
        String decoded = new String(Base64.getDecoder().decode(encoded));

        System.out.println("Encoded: " + encoded);
        System.out.println("Decoded: " + decoded);
    }
}
```

## **13. `Arrays.parallelSort()`**

Java 8 introduced `parallelSort()` to sort arrays in parallel.

**Example:**

```java
import java.util.Arrays;

public class ParallelSortExample {
    public static void main(String[] args) {
        int[] numbers = {5, 3, 8, 1, 2};
        Arrays.parallelSort(numbers);
        System.out.println(Arrays.toString(numbers));
    }
}
```
