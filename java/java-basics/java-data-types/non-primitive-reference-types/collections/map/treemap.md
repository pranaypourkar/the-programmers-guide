# TreeMap

## **About**

`TreeMap` is a part of the Java Collections Framework under the `java.util` package. It implements the `NavigableMap`interface and extends `AbstractMap`. Internally, it uses a self-balancing **Red-Black Tree** to store key-value pairs, maintaining the natural order of keys or a custom order defined by a `Comparator`. `TreeMap` is particularly useful when ordered traversal or range queries are needed.

## **Features**

1. **Sorted Order**: Keys are sorted either by their natural order or a provided `Comparator`.
2. **NavigableMap Interface**: Supports navigation methods such as `lowerKey`, `higherKey`, `floorKey`, and `ceilingKey`.
3. **Thread-Safe Alternative**: `TreeMap` is not thread-safe; for concurrent access, use `Collections.synchronizedMap()` or a `ConcurrentSkipListMap`.
4. **Allows Null Values**: Values can be `null`, but keys cannot be `null` (throws `NullPointerException`).
5. **Efficient Range Operations**: Provides sub-map views using methods like `subMap`, `headMap`, and `tailMap`

## Internal Working

### **Red-Black Tree**

1. **Structure**:
   * A Red-Black Tree is a self-balancing binary search tree.
   * Each node contains a key, a value, references to left and right children, a parent pointer, and a color (either red or black).
2. **Properties of Red-Black Tree**:
   * **Property 1**: Every node is either red or black.
   * **Property 2**: The root is always black.
   * **Property 3**: Red nodes cannot have red children (no two consecutive red nodes).
   * **Property 4**: Every path from a node to its descendant leaves has the same number of black nodes (black-height).
3. **Tree Operations**:
   * **Insertion**: Adds a new node, initially red. If it violates any property, the tree is restructured using rotations and recoloring.
   * **Deletion**: Removes a node. If it disrupts balance, fixes are applied to maintain Red-Black Tree properties.
   * **Balancing**: Rotations (left and right) are used to maintain balance.
4. **Node Comparison**:
   * Keys are compared using their natural ordering (`Comparable`) or a custom `Comparator`.
   * The comparison determines where to place a new node and ensures sorted order.

### **How TreeMap Works**

1. **Storage**:
   * The map stores entries (`Map.Entry<K, V>`) as nodes in a Red-Black Tree.
   * Each node contains `key`, `value`, `left`, `right`, `parent`, and `color`.
2. **Adding an Entry (`put()` method)**:
   * Starts at the root and traverses the tree based on the key's comparison result.
   * Places the entry in its correct position and then balances the tree.
3. **Removing an Entry (`remove()` method)**:
   * Locates the node by key and removes it.
   * If the node has two children, replaces it with its in-order successor and then fixes the tree balance.
4. **Searching (`get()` method)**:
   * Starts at the root and traverses left or right based on the key comparison until the key is found or the traversal ends.
5. **Iteration**:
   * In-order traversal of the Red-Black Tree ensures the keys are retrieved in sorted order.

## **Key Methods**

<table data-header-hidden data-full-width="true"><thead><tr><th width="322"></th><th></th></tr></thead><tbody><tr><td><strong>Method</strong></td><td><strong>Description</strong></td></tr><tr><td><code>put(K key, V value)</code></td><td>Associates the specified value with the specified key, balancing the tree if necessary.</td></tr><tr><td><code>get(Object key)</code></td><td>Retrieves the value associated with the specified key.</td></tr><tr><td><code>remove(Object key)</code></td><td>Removes the mapping for the specified key.</td></tr><tr><td><code>firstKey()</code></td><td>Returns the smallest key in the map.</td></tr><tr><td><code>lastKey()</code></td><td>Returns the largest key in the map.</td></tr><tr><td><code>subMap(K fromKey, K toKey)</code></td><td>Returns a view of the portion of the map whose keys range from <code>fromKey</code> to <code>toKey</code>.</td></tr><tr><td><code>headMap(K toKey)</code></td><td>Returns a view of the portion of the map whose keys are less than <code>toKey</code>.</td></tr><tr><td><code>tailMap(K fromKey)</code></td><td>Returns a view of the portion of the map whose keys are greater than or equal to <code>fromKey</code>.</td></tr><tr><td><code>ceilingKey(K key)</code></td><td>Returns the smallest key greater than or equal to the given key.</td></tr><tr><td><code>floorKey(K key)</code></td><td>Returns the largest key less than or equal to the given key.</td></tr></tbody></table>

## **Big-O for Operations**

| **Operation** | **Average Case** | **Worst Case** |
| ------------- | ---------------- | -------------- |
| **Put**       | O(log n)         | O(log n)       |
| **Get**       | O(log n)         | O(log n)       |
| **Remove**    | O(log n)         | O(log n)       |
| **Iteration** | O(n)             | O(n)           |

## **Limitations**

1. **No Null Keys**: Unlike `HashMap`, `TreeMap` does not support `null` keys.
2. **Not Thread-Safe**: Needs external synchronization for concurrent access.
3. **Higher Overhead**: The tree structure incurs more memory overhead compared to hash-based maps.

## **Real-World Usage**

1. **Range Queries**: Efficient for applications requiring range-based queries, such as databases and scheduling systems.
2. **Sorted Data**: Ideal for scenarios where keys must remain sorted, like navigation menus or ranking systems.
3. **Custom Order**: Used when a custom order is required, such as case-insensitive string comparisons.

## **Examples**

### **1. Basic Operations**

```java
import java.util.TreeMap;

public class TreeMapExample {
    public static void main(String[] args) {
        TreeMap<Integer, String> treeMap = new TreeMap<>();

        // Adding elements
        treeMap.put(3, "Alice");
        treeMap.put(1, "Bob");
        treeMap.put(2, "Charlie");
        System.out.println(treeMap); // Output: {1=Bob, 2=Charlie, 3=Alice}

        // Accessing elements
        System.out.println("Value for key 2: " + treeMap.get(2)); // Output: Value for key 2: Charlie

        // Removing an element
        treeMap.remove(1);
        System.out.println(treeMap); // Output: {2=Charlie, 3=Alice}
    }
}
```

### **2. Range Queries**

```java
import java.util.TreeMap;

public class RangeQueryExample {
    public static void main(String[] args) {
        TreeMap<Integer, String> treeMap = new TreeMap<>();
        treeMap.put(10, "Ten");
        treeMap.put(20, "Twenty");
        treeMap.put(30, "Thirty");

        // Getting a sub-map
        System.out.println(treeMap.subMap(15, 25)); // Output: {20=Twenty}

        // Getting the ceiling and floor keys
        System.out.println(treeMap.ceilingKey(15)); // Output: 20
        System.out.println(treeMap.floorKey(25));  // Output: 20
    }
}
```

### **3. Custom Comparator**

```java
import java.util.TreeMap;

public class CustomOrderExample {
    public static void main(String[] args) {
        TreeMap<String, Integer> treeMap = new TreeMap<>((s1, s2) -> s2.compareTo(s1));

        // Adding elements in reverse order
        treeMap.put("Alice", 1);
        treeMap.put("Bob", 2);
        treeMap.put("Charlie", 3);

        System.out.println(treeMap); // Output: {Charlie=3, Bob=2, Alice=1}
    }
}
```

