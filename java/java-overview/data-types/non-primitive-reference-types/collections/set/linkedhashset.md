# LinkedHashSet

## **About**

`LinkedHashSet` is a part of the Java Collections Framework that combines the unique element storage of `HashSet` with predictable iteration order. It maintains a doubly-linked list running through all its entries, which preserves the order in which elements were inserted.

## **Features**

1. **Preserves Insertion Order**: Unlike `HashSet`, the iteration order of elements in a `LinkedHashSet` is predictable and matches the insertion order.
2. **No Duplicates**: Ensures all elements are unique.
3. **Null Element**: Allows one `null` element.
4. **Backed by `LinkedHashMap`**: Internally uses a `LinkedHashMap` to store elements.
5. **Non-Synchronized**: Not thread-safe. External synchronization is required for concurrent access.
6. **Efficient Performance**: Provides O(1) time complexity for basic operations like add, remove, and contains.

## **Internal Working**

### **1. LinkedHashMap as the Backbone**

* `LinkedHashSet` internally uses a `LinkedHashMap` where elements are stored as keys, and a constant dummy object (`PRESENT`) is stored as values.

### **2. Maintaining Insertion Order**

* The `LinkedHashMap` maintains a doubly-linked list that connects all entries in the map in their insertion order.
* This doubly-linked list ensures that the iteration order is consistent with the insertion order.

### **3. Adding Elements**

* When an element is added using the `add()` method, the `put()` method of the underlying `LinkedHashMap` is called.
* If the element is already present, it is ignored, ensuring uniqueness.

### **4. Removing Elements**

* The `remove()` method removes the key-value pair from the underlying `LinkedHashMap`, which also updates the doubly-linked list.

### **5. Iteration**

* The iterator traverses the doubly-linked list maintained by the `LinkedHashMap`, ensuring the order of elements matches their insertion order.

## **Key Methods**

<table data-header-hidden><thead><tr><th width="284"></th><th></th></tr></thead><tbody><tr><td><strong>Method</strong></td><td><strong>Description</strong></td></tr><tr><td><code>add(E e)</code></td><td>Adds the specified element to the set if it is not already present.</td></tr><tr><td><code>remove(Object o)</code></td><td>Removes the specified element from the set if it exists.</td></tr><tr><td><code>contains(Object o)</code></td><td>Checks if the set contains the specified element.</td></tr><tr><td><code>size()</code></td><td>Returns the number of elements in the set.</td></tr><tr><td><code>clear()</code></td><td>Removes all elements from the set.</td></tr><tr><td><code>isEmpty()</code></td><td>Checks if the set is empty.</td></tr><tr><td><code>iterator()</code></td><td>Returns an iterator over the elements in the set in insertion order.</td></tr><tr><td><code>toArray()</code></td><td>Returns an array containing all the elements in the set.</td></tr></tbody></table>

## **Big-O for Operations**

<table data-header-hidden><thead><tr><th width="281"></th><th></th></tr></thead><tbody><tr><td><strong>Operation</strong></td><td><strong>Time Complexity</strong></td></tr><tr><td><strong>Add</strong></td><td>O(1) (average case)</td></tr><tr><td><strong>Remove</strong></td><td>O(1) (average case)</td></tr><tr><td><strong>Contains</strong></td><td>O(1) (average case)</td></tr><tr><td><strong>Iteration</strong></td><td>O(n)</td></tr></tbody></table>

## **Limitations**

1. **Not Thread-Safe**: Requires external synchronization for concurrent access.
2. **Memory Overhead**: Higher memory usage than `HashSet` due to the maintenance of a doubly-linked list.
3. **Dependent on Hashing**: Relies on well-implemented `hashCode()` and `equals()` methods for element uniqueness.

## **Real-World Usage**

1. **Preserving Order**: Scenarios where the order of elements matters, such as caching or building ordered collections.
2. **Unique Collections**: Storing unique elements while maintaining insertion order.
3. **Deterministic Iteration**: Applications requiring predictable iteration order, like serializing data.

## **Examples**

### **1. Basic Operations**

```java
import java.util.LinkedHashSet;

public class LinkedHashSetExample {
    public static void main(String[] args) {
        LinkedHashSet<String> set = new LinkedHashSet<>();

        // Adding elements
        set.add("Apple");
        set.add("Banana");
        set.add("Cherry");
        set.add("Apple"); // Duplicate, ignored
        System.out.println(set); // Output: [Apple, Banana, Cherry]

        // Checking for an element
        System.out.println(set.contains("Banana")); // Output: true

        // Removing an element
        set.remove("Banana");
        System.out.println(set); // Output: [Apple, Cherry]

        // Checking size
        System.out.println(set.size()); // Output: 2
    }
}
```

### **2. Iteration**

```java
import java.util.LinkedHashSet;

public class IterationExample {
    public static void main(String[] args) {
        LinkedHashSet<Integer> numbers = new LinkedHashSet<>();

        numbers.add(10);
        numbers.add(20);
        numbers.add(30);

        // Using for-each loop
        for (Integer number : numbers) {
            System.out.println(number);
        }
        // Output:
        // 10
        // 20
        // 30
    }
}
```

### **3. Preserving Order**

```java
import java.util.LinkedHashSet;

public class PreserveOrderExample {
    public static void main(String[] args) {
        LinkedHashSet<String> set = new LinkedHashSet<>();

        set.add("Third");
        set.add("First");
        set.add("Second");
        set.add("First"); // Duplicate, ignored

        System.out.println(set); // Output: [Third, First, Second]
    }
}
```

### **4. Using `Collections.synchronizedSet()`**

```java
javaCopy codeimport java.util.Collections;
import java.util.LinkedHashSet;
import java.util.Set;

public class SynchronizedSetExample {
    public static void main(String[] args) {
        Set<String> syncSet = Collections.synchronizedSet(new LinkedHashSet<>());

        syncSet.add("Alpha");
        syncSet.add("Beta");
        syncSet.add("Gamma");

        synchronized (syncSet) {
            for (String s : syncSet) {
                System.out.println(s);
            }
        }
        // Output:
        // Alpha
        // Beta
        // Gamma
    }
}
```



