# ConcurrentHashMap

## **About**

`ConcurrentHashMap` is a thread-safe, high-performance implementation of the `Map` interface introduced in Java 1.5 as part of the `java.util.concurrent` package. It allows concurrent read and write operations without explicit synchronization. Unlike `HashMap`, which is not thread-safe, and `Hashtable`, which synchronizes the entire map, `ConcurrentHashMap`employs advanced concurrency techniques to ensure high efficiency.

## **Features**

1. **Thread-Safe**: Allows multiple threads to read and write concurrently.
2. **No Null Keys or Values**: Unlike `HashMap`, `ConcurrentHashMap` does not allow `null` keys or values.
3. **Segmented Locking**: Divides the map into segments to reduce contention during updates.
4. **High Performance**: Better performance than `Hashtable` for concurrent operations.
5. **Non-Blocking Reads**: Uses volatile fields and CAS (Compare-And-Swap) for faster reads.
6. **Partial Synchronization**: Only updates on specific segments are synchronized, not the entire map.

## **Internal Working**

### **Data Structure**

* The `ConcurrentHashMap` in Java 8 uses an array of `Node<K,V>` objects (called buckets) as the base structure.
* Each bucket may contain a chain of nodes (linked list) or a balanced **red-black tree** when the bucket size exceeds a threshold (usually 8 elements). This improves search time from O(n)O(n) to O(log⁡n)O(logn).

### **Concurrency Mechanism**

* Instead of segment-level locking (used in Java 7), Java 8 employs **bucket-level locks**.
* The locking mechanism uses:
  * **CAS operations** for most operations, ensuring lock-free updates.
  * **Synchronized blocks** for updates when contention occurs, reducing overhead compared to segment locks.

### **CAS Operations**

* CAS ensures atomicity during updates, such as inserting or updating elements. The `Unsafe` class is used to implement CAS.
* Example: During put operations, the `compareAndSwap` method is used to add a node if the bucket is empty.

{% hint style="info" %}
**CAS (Compare-And-Swap)** is an atomic operation used to achieve synchronization in multithreaded environments without explicit locking. It ensures that a variable is updated only if it matches an expected value, enabling safe concurrent modifications.

#### **How CAS Works**

1. **Input Values**:
   * **Memory Location**: The variable or field you want to update.
   * **Expected Value**: The current value you expect the variable to have.
   * **New Value**: The value you want to set if the current value matches the expected value.
2. **Atomic Check-and-Update**:
   * CAS checks if the value at the memory location matches the expected value.
   * If it matches, the value is updated to the new value.
   * If it doesn't match, the operation fails, and no update occurs.
3. **Retry Mechanism**:
   * CAS operations typically use a loop to retry until the update succeeds, ensuring eventual consistency.
{% endhint %}

### **Treeification**

* When the number of nodes in a bucket exceeds 8 (threshold), the bucket transitions into a red-black tree to maintain O(log⁡n)O(logn) performance for lookups.
* If the size of the tree shrinks below 6, it reverts back to a linked list.

### **Resizing**

* Resizing occurs when the number of elements exceeds the load factor (default: 0.75).
* Resizing doubles the table size and redistributes elements across new buckets.
* The process uses **lazy transfer**:
  * A resize task is distributed across multiple threads for better performance.
  * Threads work on splitting the old buckets into the new ones, avoiding a single-thread bottleneck.

### **Locking on Updates**

* For updates (like put or remove) on a bucket that already has entries, a synchronized block ensures mutual exclusion.
* This localized locking avoids global locks and allows high concurrency.

### **Read Operations**

* Read operations (`get`, `containsKey`) are **lock-free**:
  * They traverse the bucket (linked list or tree) directly.
  * As reads don't block, high concurrency is achieved for reading data.

### **Thread-Safety**

* The combination of CAS and synchronized blocks ensures thread-safe access to the map without significant contention.
* This architecture allows multiple threads to operate on different buckets simultaneously without locking the entire map.

## **Key Methods**

<table data-header-hidden data-full-width="true"><thead><tr><th width="454"></th><th></th></tr></thead><tbody><tr><td><strong>Method</strong></td><td><strong>Description</strong></td></tr><tr><td><code>put(K key, V value)</code></td><td>Associates the specified value with the key.</td></tr><tr><td><code>get(Object key)</code></td><td>Retrieves the value for the specified key.</td></tr><tr><td><code>remove(Object key)</code></td><td>Removes the mapping for the specified key.</td></tr><tr><td><code>containsKey(Object key)</code></td><td>Checks if the map contains the specified key.</td></tr><tr><td><code>containsValue(Object value)</code></td><td>Checks if the map contains the specified value.</td></tr><tr><td><code>replace(K key, V oldValue, V newValue)</code></td><td>Replaces the old value with a new value if the key is present.</td></tr><tr><td><code>computeIfAbsent(K key, Function&#x3C;K,V>)</code></td><td>Computes the value if the key is not already associated with one.</td></tr><tr><td><code>compute(K key, BiFunction&#x3C;K,V,V>)</code></td><td>Updates the value for a key using the provided function.</td></tr><tr><td><code>forEach()</code></td><td>Performs the given action for each entry in the map.</td></tr><tr><td><code>merge(K key, V value, BiFunction&#x3C;V,V,V>)</code></td><td>Merges the given value with the existing value for the specified key.</td></tr></tbody></table>

## **Big-O for Operations**

| **Operation** | **Average Case** | **Worst Case** |
| ------------- | ---------------- | -------------- |
| **Put**       | O(1)             | O(n)           |
| **Get**       | O(1)             | O(n)           |
| **Remove**    | O(1)             | O(n)           |
| **Iteration** | O(n)             | O(n)           |

## **Limitations**

1. **No Null Keys or Values**: Does not support `null` keys or values to prevent ambiguity in concurrent environments.
2. **Higher Memory Usage**: Segments and internal structures may increase memory overhead compared to `HashMap`.
3. **Iteration Limitations**: Iterators are weakly consistent and do not reflect real-time changes.

## **Real-World Usage**

1. **Caching Systems**: Used in concurrent caches to store frequently accessed data.
2. **Thread-Safe Data Structures**: Ideal for multithreaded applications that need a shared map.
3. **Concurrent Algorithms**: Used in scenarios requiring concurrent lookups and updates, such as real-time analytics or monitoring.

## **Examples**

### **1. Basic Operations**

```java
import java.util.concurrent.ConcurrentHashMap;

public class ConcurrentHashMapExample {
    public static void main(String[] args) {
        ConcurrentHashMap<Integer, String> map = new ConcurrentHashMap<>();

        // Adding elements
        map.put(1, "Alice");
        map.put(2, "Bob");
        map.put(3, "Charlie");
        System.out.println(map); // Output: {1=Alice, 2=Bob, 3=Charlie}

        // Accessing elements
        System.out.println("Value for key 2: " + map.get(2)); // Output: Value for key 2: Bob

        // Removing an element
        map.remove(1);
        System.out.println(map); // Output: {2=Bob, 3=Charlie}

        // Iterating through entries
        map.forEach((key, value) -> System.out.println(key + ": " + value));
        // Output:
        // 2: Bob
        // 3: Charlie
    }
}
```

### **2. Concurrent Access**

```java
import java.util.concurrent.ConcurrentHashMap;

public class ConcurrentAccessExample {
    public static void main(String[] args) {
        ConcurrentHashMap<Integer, String> map = new ConcurrentHashMap<>();

        // Adding elements
        map.put(1, "Alice");
        map.put(2, "Bob");

        // Updating value concurrently
        map.computeIfAbsent(3, key -> "Charlie");
        System.out.println(map); // Output: {1=Alice, 2=Bob, 3=Charlie}

        // Concurrent replace
        map.replace(2, "Bob", "David");
        System.out.println(map); // Output: {1=Alice, 2=David, 3=Charlie}
    }
}
```

### **3. Real-Time Analytics**

```java
import java.util.concurrent.ConcurrentHashMap;

public class RealTimeAnalytics {
    public static void main(String[] args) {
        ConcurrentHashMap<String, Integer> hitCount = new ConcurrentHashMap<>();

        // Simulating hits
        hitCount.merge("Page1", 1, Integer::sum);
        hitCount.merge("Page2", 1, Integer::sum);
        hitCount.merge("Page1", 1, Integer::sum);

        System.out.println(hitCount); // Output: {Page1=2, Page2=1}
    }
}
```

