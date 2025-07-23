# TreeSet

## **About**

`TreeSet` is a part of the Java Collections Framework that implements the `Set` interface and is backed by a `TreeMap`. It is a sorted collection, where elements are arranged in their natural order or according to a custom comparator provided at creation time. Being a `NavigableSet`, it provides methods for range searches and navigation.

## **Features**

1. **Sorted Order**: Elements are stored in ascending order by default.
2. **Custom Sorting**: Supports custom ordering using a `Comparator`.
3. **No Duplicates**: Ensures all elements are unique.
4. **Implements `NavigableSet`**: Provides methods for navigation (e.g., `floor`, `ceiling`, `higher`, `lower`).
5. **Tree-Based Structure**: Backed by a Red-Black tree.
6. **Non-Synchronized**: Not thread-safe. External synchronization is needed for concurrent access.
7. **Null Element**: Does not allow `null` in Java 8 and later versions.

## **Internal Working**

### **1. Backed by TreeMap**

* Internally, `TreeSet` uses a `TreeMap` to store elements as keys, with a constant dummy value (`PRESENT`).
* This ensures elements are unique and sorted.

### **2. Red-Black Tree**

* The `TreeMap` is implemented as a Red-Black tree, a self-balancing binary search tree.
* The tree ensures that:
  * No two consecutive nodes are red.
  * The path from the root to the farthest leaf is no more than twice as long as the path to the nearest leaf.

### **3. Sorting**

* **Natural Order**: By default, elements are sorted using their `compareTo` method (from the `Comparable` interface).
* **Custom Comparator**: A `Comparator` can be provided to override the natural ordering.

### **4. Insertion**

* New elements are added using the `put` operation of the underlying `TreeMap`.
* The Red-Black tree rebalances itself during insertion to maintain its properties.

### **5. Navigation**

* Methods like `floor`, `ceiling`, `higher`, and `lower` leverage the Red-Black tree's sorted nature to efficiently find and return elements based on specific criteria.

## **Key Methods**

<table data-header-hidden><thead><tr><th width="239"></th><th></th></tr></thead><tbody><tr><td><strong>Method</strong></td><td><strong>Description</strong></td></tr><tr><td><code>add(E e)</code></td><td>Adds the specified element to the set.</td></tr><tr><td><code>remove(Object o)</code></td><td>Removes the specified element from the set.</td></tr><tr><td><code>contains(Object o)</code></td><td>Returns <code>true</code> if the set contains the specified element.</td></tr><tr><td><code>first()</code></td><td>Returns the smallest element in the set.</td></tr><tr><td><code>last()</code></td><td>Returns the largest element in the set.</td></tr><tr><td><code>ceiling(E e)</code></td><td>Returns the least element greater than or equal to the given element.</td></tr><tr><td><code>floor(E e)</code></td><td>Returns the greatest element less than or equal to the given element.</td></tr><tr><td><code>higher(E e)</code></td><td>Returns the least element strictly greater than the given element.</td></tr><tr><td><code>lower(E e)</code></td><td>Returns the greatest element strictly less than the given element.</td></tr><tr><td><code>pollFirst()</code></td><td>Retrieves and removes the first (smallest) element.</td></tr><tr><td><code>pollLast()</code></td><td>Retrieves and removes the last (largest) element.</td></tr><tr><td><code>subSet(E from, E to)</code></td><td>Returns a view of the portion of this set whose elements range from <code>from</code> (inclusive) to <code>to</code>.</td></tr><tr><td><code>headSet(E to)</code></td><td>Returns a view of the portion of this set whose elements are strictly less than <code>to</code>.</td></tr><tr><td><code>tailSet(E from)</code></td><td>Returns a view of the portion of this set whose elements are greater than or equal to <code>from</code>.</td></tr></tbody></table>

## **Big-O for Operations**

| **Operation** | **Time Complexity** |
| ------------- | ------------------- |
| **Add**       | O(log n)            |
| **Remove**    | O(log n)            |
| **Contains**  | O(log n)            |
| **Iteration** | O(n)                |

## **Limitations**

1. **Memory Overhead**: Higher memory consumption due to the Red-Black tree structure.
2. **Slower than `HashSet`**: Operations like `add` and `remove` are slower compared to `HashSet` due to tree rebalancing.
3. **Non-Synchronized**: Requires external synchronization for concurrent access.
4. **No Null Elements**: Does not allow `null` elements, unlike some other `Set` implementations.

## **Real-World Usage**

1. **Sorted Data**: Storing elements in sorted order for scenarios like range queries or leaderboard rankings.
2. **Unique Elements**: Ensuring uniqueness with a requirement for predictable ordering.
3. **Custom Order Requirements**: Applications where elements must follow a custom sort order.

## **Examples**

### **1. Basic Operations**

```java
import java.util.TreeSet;

public class TreeSetExample {
    public static void main(String[] args) {
        TreeSet<Integer> treeSet = new TreeSet<>();

        // Adding elements
        treeSet.add(10);
        treeSet.add(5);
        treeSet.add(20);
        treeSet.add(10); // Duplicate, ignored

        System.out.println(treeSet); // Output: [5, 10, 20]

        // Checking for an element
        System.out.println(treeSet.contains(10)); // Output: true

        // Removing an element
        treeSet.remove(5);
        System.out.println(treeSet); // Output: [10, 20]

        // Iterating elements
        for (Integer num : treeSet) {
            System.out.println(num);
        }
        // Output:
        // 10
        // 20
    }
}
```

### **2. Using Custom Comparator**

```java
import java.util.TreeSet;
import java.util.Comparator;

public class CustomComparatorExample {
    public static void main(String[] args) {
        TreeSet<Integer> treeSet = new TreeSet<>(Comparator.reverseOrder());

        treeSet.add(10);
        treeSet.add(5);
        treeSet.add(20);

        System.out.println(treeSet); // Output: [20, 10, 5]
    }
}
```

### **3. Navigation Operations**

```java
import java.util.TreeSet;

public class NavigationExample {
    public static void main(String[] args) {
        TreeSet<Integer> treeSet = new TreeSet<>();

        treeSet.add(10);
        treeSet.add(20);
        treeSet.add(30);

        System.out.println(treeSet.floor(15)); // Output: 10
        System.out.println(treeSet.ceiling(15)); // Output: 20
        System.out.println(treeSet.higher(20)); // Output: 30
        System.out.println(treeSet.lower(10)); // Output: null
    }
}
```

### **4. Subset Operations**

```java
import java.util.TreeSet;

public class SubSetExample {
    public static void main(String[] args) {
        TreeSet<Integer> treeSet = new TreeSet<>();

        treeSet.add(10);
        treeSet.add(20);
        treeSet.add(30);
        treeSet.add(40);

        System.out.println(treeSet.subSet(15, 35)); // Output: [20, 30]
        System.out.println(treeSet.headSet(25)); // Output: [10, 20]
        System.out.println(treeSet.tailSet(25)); // Output: [30, 40]
    }
}
```



