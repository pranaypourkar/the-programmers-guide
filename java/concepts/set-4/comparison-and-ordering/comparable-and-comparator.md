# Comparable and Comparator

## Comparable Interface

### About

In Java, `Comparable` is an interface used for defining natural ordering of objects. This interface is found in the `java.lang` package and contains a single method `compareTo(Object obj)`. By implementing `Comparable`, a class specifies how its instances should be compared with each other for the purpose of ordering.

### Key Points to Note

1. **Interface Definition**:
   *   The `Comparable` interface is defined as:

       ```java
       public interface Comparable<T> {
           public int compareTo(T o);
       }
       ```
   * Here, `T` represents the type of objects that this object may be compared with.
2. **`compareTo()` Method**:
   * The `compareTo()` method compares the current object (`this`) with another object (`o`).
   * It returns a negative integer, zero, or a positive integer as `this` object is less than, equal to, or greater than the specified object `o`.
   *   The method signature is typically:

       ```java
       public int compareTo(T o);
       ```
   * Implementation of `compareTo()` should adhere to the following contract:
     * **Reflexive**: `x.compareTo(x)` should return zero.
     * **Symmetric**: If `x.compareTo(y)` returns zero, then `y.compareTo(x)` should also return zero.
     * **Transitive**: If `x.compareTo(y)` returns zero and `y.compareTo(z)` returns zero, then `x.compareTo(z)` should also return zero.
     * **Consistent with Equals**: Objects that are equal (`equals()` returns true) should return zero when compared using `compareTo()`.
3. **Natural Ordering**:
   * Implementing `Comparable` allows objects to define their natural ordering.
   * Natural ordering means the default way objects are compared without specifying a separate comparator.
4. **Uses in Java Collections**:
   * Classes that implement `Comparable` can be sorted automatically by collections that maintain order (e.g., `TreeSet`, `TreeMap`, sorting methods like `Collections.sort()`).
5. **Example Implementation**:
   *   Here’s an example of a class `Person` implementing `Comparable` based on age:

       ```java
       public class Person implements Comparable<Person> {
           private String name;
           private int age;
           
           // Constructor, getters, setters
           
           @Override
           public int compareTo(Person o) {
               return Integer.compare(this.age, o.age);
           }
       }
       ```
6. **Handling Null Values**:
   * The `compareTo()` method should handle null values gracefully if comparison involves nullable attributes.
7. **Multiple Fields Comparison**:
   * For classes where natural ordering is based on multiple attributes, `compareTo()` can be implemented to compare each field sequentially.

### Example

```java
public class ComparableExample {
    public static void main(String[] args) {
        List<Person> people = new ArrayList<>();
        people.add(new Person("Alice", 30));
        people.add(new Person("Bob", 25));
        people.add(new Person("Charlie", 35));

        System.out.println("Before sorting:");
        for (Person person : people) {
            System.out.println(person.getName() + " - " + person.getAge());
        }

        Collections.sort(people);

        System.out.println("\nAfter sorting by age:");
        for (Person person : people) {
            System.out.println(person.getName() + " - " + person.getAge());
        }
    }
}
```

## Comparator Interface

### About

In Java, `Comparator` is an interface used for defining custom sorting order for objects. Unlike `Comparable`, which defines natural ordering within the class of the objects being compared, `Comparator` allows you to define multiple different ways to compare objects of a class, without modifying the class itself.

### Key Points to Note

1. **Interface Definition**:
   *   The `Comparator` interface is defined as:

       ```java
       public interface Comparator<T> {
           int compare(T o1, T o2);
           boolean equals(Object obj);
       }
       ```
   * Here, `T` represents the type of objects that this comparator can compare.
2. **`compare()` Method**:
   * The `compare()` method compares its two arguments (`o1` and `o2`) for order.
   * It returns a negative integer, zero, or a positive integer as `o1` is less than, equal to, or greater than `o2`.
   * Unlike `Comparable`, where `compareTo()` is part of the object being compared, `compare()` is a standalone method that can be used to compare objects based on any criteria.
3. **Custom Sorting Order**:
   * Implementing `Comparator` allows us to define custom sorting orders that may differ from the natural order defined by `Comparable`.
   * This is particularly useful when we want to sort objects based on criteria other than their natural order (e.g., sorting `Person` objects by name, age, etc.).
4. **Uses in Java Collections**:
   * `Comparator` is widely used in Java collections for sorting, searching, and ordering elements.
   * Classes like `Collections`, `Arrays`, and various collection classes (e.g., `TreeSet`, `TreeMap`) provide overloaded methods that accept `Comparator` to facilitate custom sorting.
5. **Multiple Criteria**:
   * `Comparator` can be used to sort objects based on multiple criteria by chaining multiple comparators or by implementing complex logic within the `compare()` method.
6. **Handling Null Values**
   * When implementing `Comparator`, ensure it handles null values gracefully if comparison involves nullable attributes.

### Example

```java
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

public class ComparatorExample {
    public static void main(String[] args) {
        List<Person> people = new ArrayList<>();
        people.add(new Person("Alice", 30));
        people.add(new Person("Bob", 25));
        people.add(new Person("Charlie", 35));

        System.out.println("Before sorting:");
        for (Person person : people) {
            System.out.println(person.getName() + " - " + person.getAge());
        }

        // Sorting by age using Comparator
        Collections.sort(people, new AgeComparator());

        System.out.println("\nAfter sorting by age:");
        for (Person person : people) {
            System.out.println(person.getName() + " - " + person.getAge());
        }
    }
}

class Person {
    private String name;
    private int age;

    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }

    public String getName() {
        return name;
    }

    public int getAge() {
        return age;
    }
}

class AgeComparator implements Comparator<Person> {
    @Override
    public int compare(Person o1, Person o2) {
        return Integer.compare(o1.getAge(), o2.getAge());
    }
}
```

## Comparable vs Comparator

<table data-header-hidden data-full-width="true"><thead><tr><th width="181"></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Feature</strong></td><td><strong>Comparable</strong></td><td><strong>Comparator</strong></td></tr><tr><td><strong>Interface</strong></td><td>Implemented by the class of objects being compared.</td><td>Standalone interface that can compare any objects.</td></tr><tr><td><strong>Method</strong></td><td><code>compareTo(Object obj)</code></td><td><code>compare(T o1, T o2)</code></td></tr><tr><td><strong>Purpose</strong></td><td>Defines natural ordering of objects within a class.</td><td>Defines custom sorting order for objects externally.</td></tr><tr><td><strong>Usage</strong></td><td>Objects of a class can be sorted automatically.</td><td>Objects can be sorted in multiple custom ways.</td></tr><tr><td><strong>Location</strong></td><td>Part of the object's class.</td><td>Independent of the object's class.</td></tr><tr><td><strong>Flexibility</strong></td><td>Limited to one way of sorting per class.</td><td>Multiple comparators can be defined for one class.</td></tr><tr><td><strong>Implementation</strong></td><td>Changes made within the object's class.</td><td>Implemented separately, often as inner classes.</td></tr><tr><td><strong>Sorting</strong></td><td>Used by Java collections for default sorting.</td><td>Used for custom sorting and ordering.</td></tr><tr><td><strong>Natural Order</strong></td><td>Natural ordering is inherent to the class.</td><td>No inherent natural ordering; flexible definitions.</td></tr><tr><td><strong>Example</strong></td><td>Sorting integers based on their natural order.</td><td>Sorting people by age, name, or other criteria.</td></tr></tbody></table>

## How to decide ordeing (Ascending and Descending) ?

When using `compareTo`, the way the objects are compared determines the order of sorting (ascending or descending). The key difference between `o1.compareTo(o2)` and `o2.compareTo(o1)` lies in the **direction of the comparison**.

### **How `o1.compareTo(o2)` Works**

* **`o1.compareTo(o2)`** means **"compare object `o1` with object `o2`."**
* The result defines the relative order of `o1` compared to `o2`:
  * Returns **negative** if `o1` is less than `o2`.
  * Returns **positive** if `o1` is greater than `o2`.
  * Returns **0** if `o1` and `o2` are equal.

This is commonly used for **ascending order** sorting.

### **How `o2.compareTo(o1)` Works**

* **`o2.compareTo(o1)`** means **"compare object `o2` with object `o1`."**
* The result defines the relative order of `o2` compared to `o1`:
  * Returns **negative** if `o2` is less than `o1`.
  * Returns **positive** if `o2` is greater than `o1`.
  * Returns **0** if `o2` and `o1` are equal.

This is commonly used for **descending order** sorting because it flips the direction of comparison.
