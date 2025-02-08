# Comparator Interface

## About

The `Comparator<T>` @FunctionalInterface interface in Java is part of the `java.util` package and is used to define custom sorting logic for objects. Unlike `Comparable<T>`, which imposes a natural ordering within a class, `Comparator<T>` allows sorting logic to be defined externally.

**Key Features of Comparator**

* Enables **custom sorting** for objects.
* Can be used to **sort objects based on multiple fields**.
* Provides various **default methods** (since Java 8) for enhanced functionality.
* Supports **method references and lambda expressions** for concise syntax.

## Abstract Methods

**`int compare(T o1, T o2)`**

This is the only abstract method in `Comparator`. It must be implemented to define custom comparison logic.

{% hint style="info" %}
Compares two objects and returns:\
\- Negative if `o1 < o2`\
\- Zero if `o1 == o2`\
\- Positive if `o1 > o2`
{% endhint %}

```java
Comparator<Integer> intComparator = (a, b) -> Integer.compare(a, b);
System.out.println(intComparator.compare(10, 20)); // Output: -1
```

```java
import java.util.*;

public class ComparatorExample {
    public static void main(String[] args) {
        Comparator<Integer> intComparator = new Comparator<Integer>() {
            @Override
            public int compare(Integer o1, Integer o2) {
                return o1 - o2; // Ascending order comparison
            }
        };

        List<Integer> numbers = Arrays.asList(5, 2, 8, 1);
        Collections.sort(numbers, intComparator);

        // Output: [1, 2, 5, 8]
        System.out.println(numbers);
    }
}
```

## Default Methods

<table data-full-width="true"><thead><tr><th width="610">Method</th><th>Description</th></tr></thead><tbody><tr><td><code>Comparator&#x3C;T> </code><strong><code>reversed</code></strong><code>();</code></td><td>Returns a comparator that reverses the order of comparison.</td></tr><tr><td><code>Comparator&#x3C;T> </code><strong><code>thenComparing</code></strong><code>(Comparator&#x3C;? super T> other);</code></td><td>Allows chaining multiple comparison criteria.</td></tr><tr><td><code>&#x3C;U> Comparator&#x3C;T> </code><strong><code>thenComparing</code></strong><code>(Function&#x3C;? super T, ? extends U> keyExtractor, Comparator&#x3C;? super U> keyComparator);</code></td><td>Sorts using a key extracted from the object.</td></tr><tr><td><code>&#x3C;U extends Comparable&#x3C;? super U>> Comparator&#x3C;T> </code><strong><code>thenComparing</code></strong><code>(Function&#x3C;? super T, ? extends U> keyExtractor);</code></td><td>Sorts using a Comparable key extracted from the object.</td></tr><tr><td><code>Comparator&#x3C;T> </code><strong><code>thenComparingInt</code></strong><code>(ToIntFunction&#x3C;? super T> keyExtractor);</code></td><td>Sorts based on an <code>int</code> key.</td></tr><tr><td><code>Comparator&#x3C;T> </code><strong><code>thenComparingLong</code></strong><code>(ToLongFunction&#x3C;? super T> keyExtractor);</code></td><td>Sorts based on a <code>long</code> key.</td></tr><tr><td><code>Comparator&#x3C;T> </code><strong><code>thenComparingDouble</code></strong><code>(ToDoubleFunction&#x3C;? super T> keyExtractor);</code></td><td>Sorts based on a <code>double</code> key.</td></tr></tbody></table>

```java
import java.util.*;
import java.util.function.*;

class Employee {
    String name;
    int age;
    double salary;

    Employee(String name, int age, double salary) {
        this.name = name;
        this.age = age;
        this.salary = salary;
    }

    @Override
    public String toString() {
        return name + " (Age: " + age + ", Salary: " + salary + ")";
    }
}

public class ComparatorExample {
    public static void main(String[] args) {
        List<Employee> employees = Arrays.asList(
            new Employee("Alice", 30, 55000),
            new Employee("Bob", 25, 50000),
            new Employee("Charlie", 30, 60000),
            new Employee("Dave", 25, 50000)
        );

        // Comparator by age
        Comparator<Employee> byAge = Comparator.comparingInt(emp -> emp.age);

        // reversed() - Reverse sorting order
        employees.sort(byAge.reversed());
        System.out.println("Sorted by Age (Descending): " + employees);
        // Output: [Alice (Age: 30, Salary: 55000.0), Charlie (Age: 30, Salary: 60000.0), Bob (Age: 25, Salary: 50000.0), Dave (Age: 25, Salary: 50000.0)]

        // thenComparing(Comparator) - First by age, then by salary
        employees.sort(byAge.thenComparing(Comparator.comparingDouble(emp -> emp.salary)));
        System.out.println("Sorted by Age, then Salary: " + employees);
        // Output: [Bob (Age: 25, Salary: 50000.0), Dave (Age: 25, Salary: 50000.0), Alice (Age: 30, Salary: 55000.0), Charlie (Age: 30, Salary: 60000.0)]

        // thenComparing(Function, Comparator) - First by age, then by name (custom comparator)
        employees.sort(byAge.thenComparing(emp -> emp.name, Comparator.naturalOrder()));
        System.out.println("Sorted by Age, then Name: " + employees);
        // Output: [Bob (Age: 25, Salary: 50000.0), Dave (Age: 25, Salary: 50000.0), Alice (Age: 30, Salary: 55000.0), Charlie (Age: 30, Salary: 60000.0)]

        // thenComparing(Function) - First by salary, then by name (natural ordering)
        employees.sort(Comparator.comparingDouble(emp -> emp.salary).thenComparing(emp -> emp.name));
        System.out.println("Sorted by Salary, then Name: " + employees);
        // Output: [Bob (Age: 25, Salary: 50000.0), Dave (Age: 25, Salary: 50000.0), Alice (Age: 30, Salary: 55000.0), Charlie (Age: 30, Salary: 60000.0)]

        // thenComparingInt(ToIntFunction) - First by salary, then by age
        employees.sort(Comparator.comparingDouble(emp -> emp.salary).thenComparingInt(emp -> emp.age));
        System.out.println("Sorted by Salary, then Age: " + employees);
        // Output: [Bob (Age: 25, Salary: 50000.0), Dave (Age: 25, Salary: 50000.0), Alice (Age: 30, Salary: 55000.0), Charlie (Age: 30, Salary: 60000.0)]

        // thenComparingLong(ToLongFunction) - (Assume a long field like employee ID, but here using age)
        employees.sort(Comparator.comparing(emp -> emp.name).thenComparingLong(emp -> emp.age));
        System.out.println("Sorted by Name, then Age: " + employees);
        // Output: [Alice (Age: 30, Salary: 55000.0), Bob (Age: 25, Salary: 50000.0), Charlie (Age: 30, Salary: 60000.0), Dave (Age: 25, Salary: 50000.0)]

        // thenComparingDouble(ToDoubleFunction) - First by age, then by salary
        employees.sort(Comparator.comparingInt(emp -> emp.age).thenComparingDouble(emp -> emp.salary));
        System.out.println("Sorted by Age, then Salary (double): " + employees);
        // Output: [Bob (Age: 25, Salary: 50000.0), Dave (Age: 25, Salary: 50000.0), Alice (Age: 30, Salary: 55000.0), Charlie (Age: 30, Salary: 60000.0)]
    }
}
```

## **Static Methods**

Java 8 introduced several static methods for creating comparators.

<table data-full-width="true"><thead><tr><th width="567">Method</th><th>Description</th></tr></thead><tbody><tr><td><code>Comparator&#x3C;T> </code><strong><code>naturalOrder</code></strong><code>();</code></td><td>Returns a comparator based on natural ordering (assumes <code>T</code> implements <code>Comparable&#x3C;T></code>).</td></tr><tr><td><code>Comparator&#x3C;T> </code><strong><code>reverseOrder</code></strong><code>();</code></td><td>Returns a comparator that reverses natural ordering.</td></tr><tr><td><code>&#x3C;T, U extends Comparable&#x3C;? super U>> Comparator&#x3C;T> </code><strong><code>comparing</code></strong><code>(Function&#x3C;? super T, ? extends U> keyExtractor);</code></td><td>Compares using a key extracted from the object.</td></tr><tr><td><code>&#x3C;T, U> Comparator&#x3C;T> </code><strong><code>comparing</code></strong><code>(Function&#x3C;? super T, ? extends U> keyExtractor, Comparator&#x3C;? super U> keyComparator);</code></td><td>Compares using a key with a custom comparator.</td></tr><tr><td><code>&#x3C;T> Comparator&#x3C;T> </code><strong><code>comparingInt</code></strong><code>(ToIntFunction&#x3C;? super T> keyExtractor);</code></td><td>Compares objects using an integer key.</td></tr><tr><td><code>&#x3C;T> Comparator&#x3C;T> </code><strong><code>comparingLong</code></strong><code>(ToLongFunction&#x3C;? super T> keyExtractor);</code></td><td>Compares objects using a long key.</td></tr><tr><td><code>&#x3C;T> Comparator&#x3C;T> </code><strong><code>comparingDouble</code></strong><code>(ToDoubleFunction&#x3C;? super T> keyExtractor);</code></td><td>Compares objects using a double key.</td></tr></tbody></table>

```java
import java.util.*;
import java.util.function.*;

class Employee {
    String name;
    int age;
    double salary;

    Employee(String name, int age, double salary) {
        this.name = name;
        this.age = age;
        this.salary = salary;
    }

    @Override
    public String toString() {
        return name + " (" + age + " yrs, $" + salary + ")";
    }
}

public class ComparatorExample {
    public static void main(String[] args) {
        List<Employee> employees = Arrays.asList(
            new Employee("Alice", 30, 60000.50),
            new Employee("Bob", 25, 50000.75),
            new Employee("Charlie", 35, 70000.25),
            new Employee("Dave", 28, 45000.00)
        );

        // 1. Natural Order (Assumes T implements Comparable)
        employees.sort(Comparator.comparing(Employee::name));
        System.out.println("Natural Order (by name): " + employees);
        // Output: [Alice (30 yrs, $60000.5), Bob (25 yrs, $50000.75), Charlie (35 yrs, $70000.25), Dave (28 yrs, $45000.0)]

        // 2. Reverse Order
        employees.sort(Comparator.comparing(Employee::name).reversed());
        System.out.println("Reverse Order (by name): " + employees);
        // Output: [Dave (28 yrs, $45000.0), Charlie (35 yrs, $70000.25), Bob (25 yrs, $50000.75), Alice (30 yrs, $60000.5)]

        // 3. Comparing by Extracted Key (by age)
        employees.sort(Comparator.comparing(Employee::age));
        System.out.println("Sorted by Age: " + employees);
        // Output: [Bob (25 yrs, $50000.75), Dave (28 yrs, $45000.0), Alice (30 yrs, $60000.5), Charlie (35 yrs, $70000.25)]

        // 4. Comparing by Extracted Key with Custom Comparator (by name in reverse)
        employees.sort(Comparator.comparing(Employee::name, Comparator.reverseOrder()));
        System.out.println("Sorted by Name (reverse): " + employees);
        // Output: [Dave (28 yrs, $45000.0), Charlie (35 yrs, $70000.25), Bob (25 yrs, $50000.75), Alice (30 yrs, $60000.5)]

        // 5. Comparing using an Integer Key (by age)
        employees.sort(Comparator.comparingInt(Employee::age));
        System.out.println("Sorted by Age (int comparator): " + employees);
        // Output: [Bob (25 yrs, $50000.75), Dave (28 yrs, $45000.0), Alice (30 yrs, $60000.5), Charlie (35 yrs, $70000.25)]

        // 6. Comparing using a Long Key (Assume we have long ID field, here we use age for demo)
        employees.sort(Comparator.comparingLong(Employee::age));
        System.out.println("Sorted by Age (long comparator): " + employees);
        // Output: [Bob (25 yrs, $50000.75), Dave (28 yrs, $45000.0), Alice (30 yrs, $60000.5), Charlie (35 yrs, $70000.25)]

        // 7. Comparing using a Double Key (by salary)
        employees.sort(Comparator.comparingDouble(Employee::salary));
        System.out.println("Sorted by Salary (double comparator): " + employees);
        // Output: [Dave (28 yrs, $45000.0), Bob (25 yrs, $50000.75), Alice (30 yrs, $60000.5), Charlie (35 yrs, $70000.25)]
    }
}
```

## **Utility Methods in `Map.Entry`**

The `Map.Entry` class provides useful comparators for sorting maps.

<table data-full-width="true"><thead><tr><th width="597">Method</th><th>Description</th></tr></thead><tbody><tr><td><code>static &#x3C;K, V extends Comparable&#x3C;? super V>> Comparator&#x3C;Map.Entry&#x3C;K, V>> </code><strong><code>comparingByValue</code></strong><code>();</code></td><td>Returns a comparator that compares <code>Map.Entry</code> objects by value.</td></tr><tr><td><code>static &#x3C;K, V> Comparator&#x3C;Map.Entry&#x3C;K, V>> </code><strong><code>comparingByValue</code></strong><code>(Comparator&#x3C;? super V> cmp);</code></td><td>Compares <code>Map.Entry</code> objects by value using a custom comparator.</td></tr><tr><td><code>static &#x3C;K extends Comparable&#x3C;? super K>, V> Comparator&#x3C;Map.Entry&#x3C;K, V>> </code><strong><code>comparingByKey</code></strong><code>();</code></td><td>Compares <code>Map.Entry</code> objects by key.</td></tr><tr><td><code>static &#x3C;K, V> Comparator&#x3C;Map.Entry&#x3C;K, V>> </code><strong><code>comparingByKey</code></strong><code>(Comparator&#x3C;? super K> cmp);</code></td><td>Compares <code>Map.Entry</code> objects by key using a custom comparator.</td></tr></tbody></table>

```java
import java.util.*;
import java.util.Map.Entry;

public class ComparatorMapExample {
    public static void main(String[] args) {
        Map<String, Integer> salaryMap = new HashMap<>();
        salaryMap.put("Alice", 60000);
        salaryMap.put("Bob", 50000);
        salaryMap.put("Charlie", 70000);
        salaryMap.put("Dave", 45000);

        List<Entry<String, Integer>> entryList = new ArrayList<>(salaryMap.entrySet());

        // 1. Comparing by Value (Natural Order)
        entryList.sort(Entry.comparingByValue());
        System.out.println("Sorted by Value (ascending): " + entryList);
        // Output: [Dave=45000, Bob=50000, Alice=60000, Charlie=70000]

        // 2. Comparing by Value (Descending Order)
        entryList.sort(Entry.comparingByValue(Comparator.reverseOrder()));
        System.out.println("Sorted by Value (descending): " + entryList);
        // Output: [Charlie=70000, Alice=60000, Bob=50000, Dave=45000]

        // 3. Comparing by Key (Natural Order)
        entryList.sort(Entry.comparingByKey());
        System.out.println("Sorted by Key (ascending): " + entryList);
        // Output: [Alice=60000, Bob=50000, Charlie=70000, Dave=45000]

        // 4. Comparing by Key (Descending Order)
        entryList.sort(Entry.comparingByKey(Comparator.reverseOrder()));
        System.out.println("Sorted by Key (descending): " + entryList);
        // Output: [Dave=45000, Charlie=70000, Bob=50000, Alice=60000]
    }
}
```
