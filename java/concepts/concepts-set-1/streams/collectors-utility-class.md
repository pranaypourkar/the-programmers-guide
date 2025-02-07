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

| Method                                                      | Description                                                        |
| ----------------------------------------------------------- | ------------------------------------------------------------------ |
| `toList()`                                                  | Collects elements into an **unmodifiable `List`**                  |
| `toUnmodifiableList()`                                      | Returns an **immutable `List`**                                    |
| `toSet()`                                                   | Collects elements into an **unmodifiable `Set`**                   |
| `toUnmodifiableSet()`                                       | Returns an **immutable `Set`**                                     |
| `toMap(keyMapper, valueMapper)`                             | Collects elements into a **Map** (throws error for duplicate keys) |
| `toMap(keyMapper, valueMapper, mergeFunction)`              | Collects into a **Map**, merging duplicates                        |
| `toMap(keyMapper, valueMapper, mergeFunction, mapSupplier)` | Collects into a **custom Map implementation**                      |

**Example: Collecting into `List`, `Set`, and `Map`**

```java
javaCopyEditimport java.util.*;
import java.util.stream.Collectors;

public class CollectorsExample {
    public static void main(String[] args) {
        List<String> names = List.of("Alice", "Bob", "Charlie", "Alice");

        // Convert to List
        List<String> nameList = names.stream().collect(Collectors.toList());

        // Convert to Set (removes duplicates)
        Set<String> nameSet = names.stream().collect(Collectors.toSet());

        // Convert to Map (name -> length)
        Map<String, Integer> nameMap = names.stream()
            .collect(Collectors.toMap(name -> name, String::length, (existing, replacement) -> existing));

        System.out.println(nameList); // [Alice, Bob, Charlie, Alice]
        System.out.println(nameSet);  // [Alice, Bob, Charlie]
        System.out.println(nameMap);  // {Alice=5, Bob=3, Charlie=7}
    }
}
```

***

#### **2.2 Aggregation and Summarization**

| Method                                   | Description                                                  |
| ---------------------------------------- | ------------------------------------------------------------ |
| `counting()`                             | Counts the number of elements                                |
| `summarizingInt(ToIntFunction<T>)`       | Returns **IntSummaryStatistics** (count, min, max, sum, avg) |
| `summarizingDouble(ToDoubleFunction<T>)` | Returns **DoubleSummaryStatistics**                          |
| `summarizingLong(ToLongFunction<T>)`     | Returns **LongSummaryStatistics**                            |
| `maxBy(Comparator<T>)`                   | Returns the **maximum element**                              |
| `minBy(Comparator<T>)`                   | Returns the **minimum element**                              |
| `reducing(BinaryOperator<T>)`            | Performs a **general reduction**                             |

**Example: Aggregation**

```java
javaCopyEditimport java.util.*;
import java.util.stream.Collectors;

public class AggregationExample {
    public static void main(String[] args) {
        List<Integer> numbers = List.of(5, 10, 15, 20, 25);

        long count = numbers.stream().collect(Collectors.counting());

        int sum = numbers.stream().collect(Collectors.summingInt(Integer::intValue));

        double average = numbers.stream().collect(Collectors.averagingDouble(Integer::doubleValue));

        Optional<Integer> max = numbers.stream().collect(Collectors.maxBy(Integer::compareTo));

        System.out.println("Count: " + count);     // 5
        System.out.println("Sum: " + sum);         // 75
        System.out.println("Average: " + average); // 15.0
        System.out.println("Max: " + max.get());   // 25
    }
}
```

***

#### **2.3 Joining Strings**

| Method                               | Description                                    |
| ------------------------------------ | ---------------------------------------------- |
| `joining()`                          | Concatenates elements into a single string     |
| `joining(delimiter)`                 | Joins elements with a **delimiter**            |
| `joining(delimiter, prefix, suffix)` | Joins with a **delimiter, prefix, and suffix** |

**Example: Joining Strings**

```java
javaCopyEditimport java.util.List;
import java.util.stream.Collectors;

public class JoiningExample {
    public static void main(String[] args) {
        List<String> names = List.of("Alice", "Bob", "Charlie");

        String joined = names.stream().collect(Collectors.joining(", "));

        String jsonLike = names.stream().collect(Collectors.joining(", ", "[", "]"));

        System.out.println(joined);    // Alice, Bob, Charlie
        System.out.println(jsonLike);  // [Alice, Bob, Charlie]
    }
}
```

***

#### **2.4 Grouping & Partitioning**

| Method                              | Description                                      |
| ----------------------------------- | ------------------------------------------------ |
| `groupingBy(classifier)`            | Groups elements into a **Map\<K, List\<T>>**     |
| `groupingBy(classifier, collector)` | Groups with a **custom downstream collector**    |
| `partitioningBy(predicate)`         | Splits elements into **two groups (true/false)** |

**Example: Grouping Data**

```java
javaCopyEditimport java.util.*;
import java.util.stream.Collectors;

class Employee {
    String name;
    String department;

    Employee(String name, String department) {
        this.name = name;
        this.department = department;
    }
}

public class GroupingExample {
    public static void main(String[] args) {
        List<Employee> employees = List.of(
            new Employee("Alice", "HR"),
            new Employee("Bob", "IT"),
            new Employee("Charlie", "IT"),
            new Employee("David", "HR")
        );

        // Group by department
        Map<String, List<Employee>> groupedByDept = employees.stream()
            .collect(Collectors.groupingBy(emp -> emp.department));

        System.out.println(groupedByDept);
    }
}
```

**Output**

```json
jsonCopyEdit{HR=[Alice, David], IT=[Bob, Charlie]}
```

***

#### **2.5 Custom Reduction (reducing)**

| Method                                  | Description                               |
| --------------------------------------- | ----------------------------------------- |
| `reducing(BinaryOperator<T>)`           | Reduces elements using **custom logic**   |
| `reducing(identity, BinaryOperator<T>)` | Reduces elements with a **default value** |

**Example: Finding the Longest String**

```java
javaCopyEditimport java.util.List;
import java.util.stream.Collectors;

public class ReducingExample {
    public static void main(String[] args) {
        List<String> names = List.of("Alice", "Bob", "Charlie", "Dave");

        String longestName = names.stream()
            .collect(Collectors.reducing("", (name1, name2) -> name1.length() >= name2.length() ? name1 : name2));

        System.out.println(longestName); // Charlie
    }
}
```
