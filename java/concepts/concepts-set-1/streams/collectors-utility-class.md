# Collectors Utility Class

## About

In Java, the `Collectors` class is a part of the `java.util.stream` package and provides a variety of utility methods to perform reduction operations on streams. These methods are used to accumulate elements from a stream into a collection or to summarize elements in various ways.

**Basic Syntax**

```java
stream.collect(Collectors.someCollectorMethod());
```

* `stream` → The Stream we want to collect data from.
* `collect(Collectors.someMethod())` → Applies a reduction operation.

## **Collecting into Lists, Sets, and Maps**

<table data-full-width="true"><thead><tr><th>Method</th><th>Description</th></tr></thead><tbody><tr><td><code>toList()</code></td><td>Collects elements into an <strong>unmodifiable <code>List</code></strong></td></tr><tr><td><code>toUnmodifiableList()</code></td><td>Returns an <strong>immutable <code>List</code></strong></td></tr><tr><td><code>toSet()</code></td><td>Collects elements into an <strong>unmodifiable <code>Set</code></strong></td></tr><tr><td><code>toUnmodifiableSet()</code></td><td>Returns an <strong>immutable <code>Set</code></strong></td></tr><tr><td><code>toMap(keyMapper, valueMapper)</code></td><td>Collects elements into a <strong>Map</strong> (throws error for duplicate keys)</td></tr><tr><td><code>toMap(keyMapper, valueMapper, mergeFunction)</code></td><td>Collects into a <strong>Map</strong>, merging duplicates</td></tr><tr><td><code>toMap(keyMapper, valueMapper, mergeFunction, mapSupplier)</code></td><td>Collects into a <strong>custom Map implementation</strong></td></tr></tbody></table>

{% hint style="success" %}
`toList()` vs. `toUnmodifiableList()?`

**Unmodifiable List (`toList()`)**

* **Returns:** An unmodifiable list (but not necessarily immutable).
* **Implementation Detail:** The returned list may still allow modifications through the original collection.
* **Use Case:**
  * If we don’t need to modify the list but don’t require strict immutability.
  * If we're okay with the underlying implementation potentially being mutable.
  * Used when we want to prevent modifications via this specific reference but don’t need a truly immutable list.

```java
List<String> list = List.of("Alice", "Bob");
List<String> unmodifiableList = list.stream().collect(Collectors.toList());
// Modifications via unmodifiableList will fail. But, if it's backed by a 
// mutable list, changes to the original source can reflect in unmodifiableList
unmodifiableList.add("Charlie"); // Throws UnsupportedOperationException
```



**Immutable List (`toUnmodifiableList()`)**

* **Returns:** A truly immutable list (Java 10+).
* **Implementation Detail:** The list is explicitly created as immutable, ensuring no external modifications.
* **Use Case:**
  * When we want absolute immutability, meaning even if the original source changes, this list won't.
  * When working in a concurrent environment to ensure thread safety.
  * Useful for returning API responses where data should not be modified by the consumer.

```java
List<String> immutableList = List.of("Alice", "Bob")
        .stream()
        .collect(Collectors.toUnmodifiableList());
```

```java
// Guaranteed to be immutable, regardless of the source.
// Modification attempts will always fail
immutableList.add("Charlie"); // Throws UnsupportedOperationException
```
{% endhint %}

{% hint style="success" %}
#### **What is `Function.identity()`?**

`Function.identity()` is a built-in function in Java that returns the input as-is.

```java
List<String> names = List.of("Alice", "Bob", "Charlie");

Map<String, Integer> nameLengths = names.stream()
        .collect(Collectors.toMap(Function.identity(), String::length));

System.out.println(nameLengths); // {Alice=5, Bob=3, Charlie=7}
```

* `Function.identity()` means use the element itself as the key.
* `String::length` provides the valu&#x65;**.**

**Equivalent Lambda Expression:**

```java
.collect(Collectors.toMap(name -> name, name -> name.length()));
```

But `Function.identity()` is cleaner and more readable.
{% endhint %}

```java
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

public class CollectorsExample {
    public static void main(String[] args) {
        List<String> names = List.of("Alice", "Bob", "Charlie", "Alice", "David");

        // 1. Collecting into an unmodifiable List
        List<String> list1 = names.stream().collect(Collectors.toList());

        // 2. Collecting into an immutable List
        List<String> list2 = names.stream().collect(Collectors.toUnmodifiableList());

        // 3. Collecting into an unmodifiable Set
        Set<String> set1 = names.stream().collect(Collectors.toSet());

        // 4. Collecting into an immutable Set
        Set<String> set2 = names.stream().collect(Collectors.toUnmodifiableSet());

        // 5. Collecting into a Map (throws error for duplicate keys)
        try {
            Map<String, Integer> map1 = names.stream()
                    .collect(Collectors.toMap(Function.identity(), String::length));
        } catch (IllegalStateException e) {
            System.out.println("toMap(keyMapper, valueMapper) failed due to duplicate keys.");
        }

        // 6. Collecting into a Map with merging function (in case of duplicate keys, keep the longest name)
        Map<String, Integer> map2 = names.stream()
                .collect(Collectors.toMap(Function.identity(), String::length, Integer::max));

        // 7. Collecting into a custom Map (LinkedHashMap to maintain insertion order)
        Map<String, Integer> map3 = names.stream()
                .collect(Collectors.toMap(Function.identity(), String::length, Integer::max, LinkedHashMap::new));
    }
}
```

## **Aggregation and Summarization**

<table data-full-width="true"><thead><tr><th>Method</th><th>Description</th></tr></thead><tbody><tr><td><code>counting()</code></td><td>Counts the number of elements</td></tr><tr><td><code>summarizingInt(ToIntFunction&#x3C;T>)</code></td><td>Returns IntSummaryStatistics (count, min, max, sum, avg)</td></tr><tr><td><code>summarizingDouble(ToDoubleFunction&#x3C;T>)</code></td><td>Returns DoubleSummaryStatistics</td></tr><tr><td><code>summarizingLong(ToLongFunction&#x3C;T>)</code></td><td>Returns LongSummaryStatistics</td></tr><tr><td><code>maxBy(Comparator&#x3C;T>)</code></td><td>Returns the maximum element</td></tr><tr><td><code>minBy(Comparator&#x3C;T>)</code></td><td>Returns the minimum element</td></tr><tr><td><code>reducing(BinaryOperator&#x3C;T>)</code></td><td>Performs a general reduction</td></tr></tbody></table>

```java
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class CollectorsExample {
    public static void main(String[] args) {
        List<Integer> numbers = List.of(10, 20, 30, 40, 50, 10, 20);

        // 1. Counting the number of elements
        long count = numbers.stream().collect(Collectors.counting());

        // 2. Summarizing Int (count, min, max, sum, avg)
        IntSummaryStatistics intStats = numbers.stream().collect(Collectors.summarizingInt(Integer::intValue));

        // 3. Summarizing Double
        DoubleSummaryStatistics doubleStats = numbers.stream().collect(Collectors.summarizingDouble(Double::valueOf));

        // 4. Summarizing Long
        LongSummaryStatistics longStats = numbers.stream().collect(Collectors.summarizingLong(Long::valueOf));

        // 5. Finding maximum element
        numbers.stream().collect(Collectors.maxBy(Integer::compareTo))
                .ifPresent(max -> System.out.println("maxBy(): " + max));

        // 6. Finding minimum element
        numbers.stream().collect(Collectors.minBy(Integer::compareTo))
                .ifPresent(min -> System.out.println("minBy(): " + min));

        // 7. Reducing (sum of elements)
        int sum = numbers.stream().collect(Collectors.reducing(0, Integer::intValue, Integer::sum));
    }
}
```

## **Joining Strings**

<table data-full-width="true"><thead><tr><th width="412">Method</th><th>Description</th></tr></thead><tbody><tr><td><code>joining()</code></td><td>Concatenates elements into a single string</td></tr><tr><td><code>joining(delimiter)</code></td><td>Joins elements with a delimiter</td></tr><tr><td><code>joining(delimiter, prefix, suffix)</code></td><td>Joins with a delimiter, prefix, and suffix</td></tr></tbody></table>

```java
import java.util.List;
import java.util.stream.Collectors;

public class CollectorsJoiningExample {
    public static void main(String[] args) {
        List<String> words = List.of("Apple", "Banana", "Cherry");

        // 1. Joining elements into a single string
        String joined1 = words.stream().collect(Collectors.joining());
        System.out.println("joining(): " + joined1);  
        // Output: joining(): AppleBananaCherry

        // 2. Joining elements with a delimiter
        String joined2 = words.stream().collect(Collectors.joining(", "));
        System.out.println("joining(delimiter): " + joined2);  
        // Output: joining(delimiter): Apple, Banana, Cherry

        // 3. Joining with a delimiter, prefix, and suffix
        String joined3 = words.stream().collect(Collectors.joining(", ", "[", "]"));
        System.out.println("joining(delimiter, prefix, suffix): " + joined3);  
        // Output: joining(delimiter, prefix, suffix): [Apple, Banana, Cherry]
    }
}
```

## **Grouping & Partitioning**

<table data-full-width="true"><thead><tr><th>Method</th><th>Description</th></tr></thead><tbody><tr><td><code>groupingBy(classifier)</code></td><td>Groups elements into a Map&#x3C;K, List&#x3C;T>></td></tr><tr><td><code>groupingBy(classifier, collector)</code></td><td>Groups with a custom downstream collector</td></tr><tr><td><code>groupingBy(classifier, supplier, collector)</code></td><td>Groups elements into a custom Map implementation</td></tr><tr><td><code>partitioningBy(predicate)</code></td><td>Splits elements into two groups (true/false)</td></tr><tr><td><code>partitioningBy(predicate, downstream)</code></td><td>Splits elements into two groups (true/false) with a downstream collector</td></tr></tbody></table>

```java
import java.util.*;
import java.util.stream.Collectors;

public class CollectorsGroupingPartitioningExample {
    public static void main(String[] args) {
        List<String> words = List.of("apple", "banana", "cherry", "avocado", "blueberry", "apricot");

        // 1. groupingBy(classifier) - Groups words by their first letter
        Map<Character, List<String>> groupedByFirstLetter = words.stream()
                .collect(Collectors.groupingBy(word -> word.charAt(0)));
        System.out.println("groupingBy(classifier): " + groupedByFirstLetter);
        // Output: {a=[apple, avocado, apricot], b=[banana, blueberry], c=[cherry]}

        // 2. groupingBy(classifier, collector) - Groups words by length and collects into a Set
        Map<Integer, Set<String>> groupedByLength = words.stream()
                .collect(Collectors.groupingBy(String::length, Collectors.toSet()));
        System.out.println("groupingBy(classifier, collector): " + groupedByLength);
        // Output: {6=[banana, cherry], 5=[apple], 7=[avocado], 9=[blueberry, apricot]}

        // 3. groupingBy(classifier, supplier, collector) - Uses LinkedHashMap to maintain order
        Map<Character, List<String>> linkedGroupedByFirstLetter = words.stream()
                .collect(Collectors.groupingBy(word -> word.charAt(0), LinkedHashMap::new, Collectors.toList()));
        System.out.println("groupingBy(classifier, supplier, collector): " + linkedGroupedByFirstLetter);
        // Output: {a=[apple, avocado, apricot], b=[banana, blueberry], c=[cherry]}

        // 4. partitioningBy(predicate) - Splits words into two groups: length > 6 (true) and <= 6 (false)
        Map<Boolean, List<String>> partitionedByLength = words.stream()
                .collect(Collectors.partitioningBy(word -> word.length() > 6));
        System.out.println("partitioningBy(predicate): " + partitionedByLength);
        // Output: {false=[apple, banana, cherry], true=[avocado, blueberry, apricot]}

        // 5. partitioningBy(predicate, downstream) - Partitions words by length and collects into Sets
        Map<Boolean, Set<String>> partitionedByLengthSet = words.stream()
                .collect(Collectors.partitioningBy(word -> word.length() > 6, Collectors.toSet()));
        System.out.println("partitioningBy(predicate, downstream): " + partitionedByLengthSet);
        // Output: {false=[apple, banana, cherry], true=[avocado, blueberry, apricot]}
    }
}
```

## **Custom Reduction (reducing)**

<table data-full-width="true"><thead><tr><th>Method</th><th>Description</th></tr></thead><tbody><tr><td><code>reducing(BinaryOperator&#x3C;T>)</code></td><td>Reduces elements using custom logic</td></tr><tr><td><code>reducing(identity, BinaryOperator&#x3C;T>)</code></td><td>Reduces elements with a default value</td></tr></tbody></table>

```java
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

public class CollectorsReducingExample {
    public static void main(String[] args) {
        List<Integer> numbers = List.of(10, 20, 30, 40, 50);

        // 1. reducing(BinaryOperator<T>) - Reduces elements using a custom logic (sum in this case)
        Optional<Integer> sumOptional = numbers.stream()
                .collect(Collectors.reducing((a, b) -> a + b));
        System.out.println("reducing(BinaryOperator<T>): " + sumOptional.orElse(0));
        // Output: reducing(BinaryOperator<T>): 150

        // 2. reducing(identity, BinaryOperator<T>) - Reduces with a default value (identity = 0)
        int sumWithIdentity = numbers.stream()
                .collect(Collectors.reducing(0, (a, b) -> a + b));
        System.out.println("reducing(identity, BinaryOperator<T>): " + sumWithIdentity);
        // Output: reducing(identity, BinaryOperator<T>): 150

        // Example of reducing to find max value
        Optional<Integer> maxOptional = numbers.stream()
                .collect(Collectors.reducing(Integer::max));
        System.out.println("reducing(BinaryOperator<T>) to find max: " + maxOptional.orElse(0));
        // Output: reducing(BinaryOperator<T>) to find max: 50

        // Example of reducing to find min value with identity
        int minWithIdentity = numbers.stream()
                .collect(Collectors.reducing(Integer.MAX_VALUE, Integer::min));
        System.out.println("reducing(identity, BinaryOperator<T>) to find min: " + minWithIdentity);
        // Output: reducing(identity, BinaryOperator<T>) to find min: 10
    }
}
```

