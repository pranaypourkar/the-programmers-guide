# ConcurrentSkipListSet

## **About**

`ConcurrentSkipListSet` is a thread-safe, high-performance implementation of a `NavigableSet` that is backed by a `ConcurrentSkipListMap`. It maintains elements in their natural order or a custom order specified by a `Comparator`. This class is particularly suitable for concurrent applications where multiple threads need efficient and consistent access to a sorted set.

## **Features**

1. **Thread-Safe**: Supports concurrent access by multiple threads without requiring external synchronization.
2. **Sorted**: Maintains elements in natural or custom order.
3. **Non-Blocking**: Uses lock-free algorithms internally for high performance in concurrent environments.
4. **Navigable**: Provides methods for retrieving elements relative to a given element, such as `lower()`, `floor()`, `ceiling()`, and `higher()`.
5. **Iterators Are Weakly Consistent**: Iterators reflect the state of the set at the time they are created but may not include subsequent modifications.
6. **No Nulls Allowed**: Does not permit `null` elements, as null values cannot be reliably compared.

## **Internal Working**

### **Skip List Structure**

* Internally, `ConcurrentSkipListSet` is implemented using a **skip list**.
* A skip list is a hierarchical structure where elements are organized into multiple levels of linked lists. The lowest level contains all elements in sorted order, and higher levels contain fewer elements, which act as "express lanes" for faster traversal.

### **Concurrent Modifications**

* Uses a lock-free algorithm to ensure thread-safety.
* Operations like insertion, deletion, and search are performed atomically without locking the entire structure.
* This ensures high throughput in multi-threaded environments.

### **Backing Map**

* The `ConcurrentSkipListSet` is backed by a `ConcurrentSkipListMap`, where the keys represent the elements of the set.
* Each key in the map corresponds to an element in the set, and the value associated with the key is a dummy object (used for internal purposes).

### **Node Structure**

* Each node in the skip list contains references to other nodes at various levels, enabling efficient jumps during traversal.

## **Key Methods**

<table data-header-hidden><thead><tr><th width="285"></th><th></th></tr></thead><tbody><tr><td><strong>Method</strong></td><td><strong>Description</strong></td></tr><tr><td><code>add(E e)</code></td><td>Adds the specified element to the set.</td></tr><tr><td><code>remove(Object o)</code></td><td>Removes the specified element from the set.</td></tr><tr><td><code>contains(Object o)</code></td><td>Returns <code>true</code> if the set contains the specified element.</td></tr><tr><td><code>size()</code></td><td>Returns the number of elements in the set.</td></tr><tr><td><code>clear()</code></td><td>Removes all elements from the set.</td></tr><tr><td><code>iterator()</code></td><td>Returns an iterator over the elements in the set in ascending order.</td></tr><tr><td><code>descendingIterator()</code></td><td>Returns an iterator over the elements in descending order.</td></tr><tr><td><code>ceiling(E e)</code></td><td>Returns the least element greater than or equal to the given element.</td></tr><tr><td><code>floor(E e)</code></td><td>Returns the greatest element less than or equal to the given element.</td></tr><tr><td><code>higher(E e)</code></td><td>Returns the least element strictly greater than the given element.</td></tr><tr><td><code>lower(E e)</code></td><td>Returns the greatest element strictly less than the given element.</td></tr><tr><td><code>first()</code></td><td>Returns the first (lowest) element in the set.</td></tr><tr><td><code>last()</code></td><td>Returns the last (highest) element in the set.</td></tr><tr><td><code>subSet(E from, E to)</code></td><td>Returns a view of the portion of the set within the specified range.</td></tr></tbody></table>

## **Big-O for Operations**

| **Operation** | **Time Complexity** |
| ------------- | ------------------- |
| **Add**       | O(log n)            |
| **Remove**    | O(log n)            |
| **Contains**  | O(log n)            |
| **Iteration** | O(n)                |

## **Limitations**

1. **Memory Overhead**: Due to its hierarchical structure, it uses more memory than simpler data structures like `TreeSet`.
2. **Relatively Slower Than Non-Thread-Safe Counterparts**: Slightly slower than `TreeSet` in single-threaded environments because of the overhead of thread-safety mechanisms.
3. **No Null Elements**: Does not support `null` values as they are incompatible with natural or custom ordering.

## **Real-World Usage**

1. **Concurrent Task Scheduling**: Storing and retrieving tasks in sorted order for execution in a multi-threaded application.
2. **Thread-Safe Logs**: Maintaining a thread-safe collection of sorted timestamps or events.
3. **Sorted Caches**: Implementing thread-safe, sorted caches with predictable iteration order.

## **Examples**

### **1. Basic Operations**

```java
import java.util.concurrent.ConcurrentSkipListSet;

public class ConcurrentSkipListSetExample {
    public static void main(String[] args) {
        ConcurrentSkipListSet<Integer> set = new ConcurrentSkipListSet<>();

        set.add(10);
        set.add(5);
        set.add(20);

        System.out.println(set); // Output: [5, 10, 20]

        // Check if an element exists
        System.out.println(set.contains(10)); // Output: true

        // Remove an element
        set.remove(10);
        System.out.println(set); // Output: [5, 20]
    }
}
```

### **2. Navigable Methods**

```java
import java.util.concurrent.ConcurrentSkipListSet;

public class NavigableMethodsExample {
    public static void main(String[] args) {
        ConcurrentSkipListSet<Integer> set = new ConcurrentSkipListSet<>();
        set.add(10);
        set.add(20);
        set.add(30);
        set.add(40);

        System.out.println(set.ceiling(25)); // Output: 30
        System.out.println(set.floor(25)); // Output: 20
        System.out.println(set.higher(30)); // Output: 40
        System.out.println(set.lower(30)); // Output: 20
    }
}
```

### **3. Concurrent Access**

```java
import java.util.concurrent.ConcurrentSkipListSet;

public class ConcurrentAccessExample {
    public static void main(String[] args) throws InterruptedException {
        ConcurrentSkipListSet<Integer> set = new ConcurrentSkipListSet<>();

        Runnable task = () -> {
            for (int i = 0; i < 10; i++) {
                set.add(i);
            }
        };

        Thread t1 = new Thread(task);
        Thread t2 = new Thread(task);

        t1.start();
        t2.start();

        t1.join();
        t2.join();

        System.out.println(set); // Output: [0, 1, 2, ..., 9]
    }
}
```



