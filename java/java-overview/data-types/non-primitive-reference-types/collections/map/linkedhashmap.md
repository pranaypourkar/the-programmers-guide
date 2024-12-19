# LinkedHashMap

## **About**

`LinkedHashMap` is a subclass of `HashMap` introduced in Java 1.4. It maintains the order of elements, unlike `HashMap`, which is unordered. This class is part of the `java.util` package and implements the `Map` interface. The order of elements can be **insertion order** or **access order**, depending on the configuration.

* **Insertion Order**: The order in which entries are inserted is preserved.
* **Access Order**: The order is updated based on recent access if configured.

## **Features**

1. **Preserves Order**: Maintains insertion or access order.
2. **Backed by HashMap**: Internally uses a `HashMap` for storage.
3. **Doubly Linked List**: Maintains a linked list of entries for ordering.
4. **Allows Null Keys and Values**: Similar to `HashMap`, it allows one `null` key and multiple `null` values.
5. **Not Thread-Safe**: By default, it is not synchronized. Use `Collections.synchronizedMap()` for thread-safe operations.
6. **Performance**: Slightly slower than `HashMap` due to linked list maintenance but faster than `TreeMap` for ordered operations.

## Internal Working

The **`LinkedHashMap`** combines the functionality of `HashMap` with a **doubly linked list** to maintain insertion or access order.

### **Data Structure**

`LinkedHashMap` relies on two main data structures:

1. **HashMap**:
   * Stores the key-value pairs in an array of buckets.
   * Each bucket contains a singly linked list (or a tree for large buckets in modern Java versions).
   * Hashing is used to distribute keys uniformly across buckets.
2. **Doubly Linked List**:
   * Maintains the order of entries.
   * Each entry in `LinkedHashMap` is linked to the previous and next entries using two additional pointers (`before`and `after`).

### **Components**

* **Entry Class**:\
  Each entry in `LinkedHashMap` is represented by an inner class `LinkedHashMap.Entry<K, V>`, which extends `HashMap.Node<K, V>`. It has two extra fields:
  * `before`: Points to the previous entry in the linked list.
  * `after`: Points to the next entry in the linked list.

```java
static class Entry<K, V> extends HashMap.Node<K, V> {
    Entry<K, V> before, after;
    Entry(int hash, K key, V value, Node<K, V> next) {
        super(hash, key, value, next);
    }
}
```

* **Head and Tail Pointers**:
  * The doubly linked list is anchored by a `head` and `tail`.
  * The `head` points to the first inserted entry.
  * The `tail` points to the most recently inserted (or accessed, in access-order mode) entry.

### **How Order Is Maintained**

1. **Insertion Order**:
   * When a new entry is added, it is appended to the end of the doubly linked list.
   * This preserves the order of insertion.
2. **Access Order**:
   * If `accessOrder` is set to `true`, the linked list is updated every time an entry is accessed (via `get`, `put`, or `putIfAbsent` methods).
   * The accessed entry is moved to the end of the list.

### **Rehashing**

1. Triggered when the size exceeds the load factor threshold.
2. The `HashMap` resizes its bucket array, and entries are rehashed to new buckets.
3. During rehashing:
   * The linked list structure is preserved.
   * The `before` and `after` pointers of all entries remain intact.

### **Operations**

**`put(K key, V value)`**

1. Calculates the hash for the key.
2. Determines the bucket index based on the hash.
3. Checks if the key already exists:
   * If yes, updates the value.
   * If no, creates a new `Entry`.
4. Inserts the entry in the `HashMap`.
5. Updates the doubly linked list:
   * Links the new entry to the current `tail`.
   * Updates the `tail` pointer.

**`get(Object key)`**

1. Uses the hash to locate the bucket.
2. Searches for the key in the bucket’s chain.
3. If the key is found:
   * Returns the value.
   * Updates the order in the doubly linked list if `accessOrder` is `true`.

**`remove(Object key)`**

1. Locates the entry in the `HashMap` using the hash.
2. Removes the entry from the bucket's chain.
3. Updates the doubly linked list:
   * Unlinks the entry from its `before` and `after` neighbors.
   * Adjusts the `head` or `tail` pointers if necessary.

## **Key Methods**

<table data-header-hidden data-full-width="true"><thead><tr><th width="397"></th><th></th></tr></thead><tbody><tr><td><strong>Method</strong></td><td><strong>Description</strong></td></tr><tr><td><code>put(K key, V value)</code></td><td>Adds a key-value pair. If the key exists, updates the value.</td></tr><tr><td><code>get(Object key)</code></td><td>Retrieves the value associated with the key. Updates order if <code>accessOrder</code> is <code>true</code>.</td></tr><tr><td><code>remove(Object key)</code></td><td>Removes the key-value pair for the specified key.</td></tr><tr><td><code>containsKey(Object key)</code></td><td>Checks if the map contains the specified key.</td></tr><tr><td><code>containsValue(Object value)</code></td><td>Checks if the map contains the specified value.</td></tr><tr><td><code>keySet()</code></td><td>Returns a <code>Set</code> of keys in order.</td></tr><tr><td><code>values()</code></td><td>Returns a <code>Collection</code> of values in order.</td></tr><tr><td><code>entrySet()</code></td><td>Returns a <code>Set</code> of key-value mappings in order.</td></tr><tr><td><code>clear()</code></td><td>Removes all mappings.</td></tr><tr><td><code>removeEldestEntry(Map.Entry&#x3C;K,V>)</code></td><td>Determines whether to remove the eldest entry when a new entry is added.</td></tr></tbody></table>

## **Big-O for Operations**

| **Operation** | **Average Case** | **Worst Case** |
| ------------- | ---------------- | -------------- |
| **Put**       | O(1)             | O(n)           |
| **Get**       | O(1)             | O(n)           |
| **Remove**    | O(1)             | O(n)           |
| **Iteration** | O(n)             | O(n)           |

## **Limitations**

1. **Memory Overhead**: The doubly linked list adds memory overhead compared to `HashMap`.
2. **Not Thread-Safe**: Requires external synchronization for concurrent use.
3. **Slightly Slower Than `HashMap`**: Maintaining order introduces additional overhead.
4. **Unpredictable Behavior with Null Keys**: While it allows `null` keys, unexpected behaviors may occur if `null` is frequently accessed in access-order mode.

## **Real-World Usage**

1. **Caches**: Used to implement **Least Recently Used (LRU)** caches by overriding `removeEldestEntry()`.
2. **Maintaining Order**: Useful in applications where insertion or access order is critical.
3. **Data Stores**: Ideal for implementing ordered data stores, like log files or access history.

## **Examples**

### **1. Basic Operations**

```java
import java.util.LinkedHashMap;

public class LinkedHashMapExample {
    public static void main(String[] args) {
        LinkedHashMap<Integer, String> map = new LinkedHashMap<>();

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
        for (var entry : map.entrySet()) {
            System.out.println(entry.getKey() + ": " + entry.getValue());
            // Output:
            // 2: Bob
            // 3: Charlie
        }
    }
}
```

### **2. Access Order**

```java
import java.util.LinkedHashMap;

public class AccessOrderExample {
    public static void main(String[] args) {
        LinkedHashMap<Integer, String> map = new LinkedHashMap<>(16, 0.75f, true);

        map.put(1, "Alice");
        map.put(2, "Bob");
        map.put(3, "Charlie");

        // Accessing elements
        map.get(1);
        map.get(3);

        System.out.println(map); // Output: {2=Bob, 1=Alice, 3=Charlie}
    }
}
```

### **3. Implementing LRU Cache**

```java
import java.util.LinkedHashMap;
import java.util.Map;

class LRUCache<K, V> extends LinkedHashMap<K, V> {
    private final int capacity;

    public LRUCache(int capacity) {
        super(capacity, 0.75f, true);
        this.capacity = capacity;
    }

    @Override
    protected boolean removeEldestEntry(Map.Entry<K, V> eldest) {
        return size() > capacity;
    }
}

public class LRUCacheExample {
    public static void main(String[] args) {
        LRUCache<Integer, String> cache = new LRUCache<>(3);

        cache.put(1, "Alice");
        cache.put(2, "Bob");
        cache.put(3, "Charlie");
        System.out.println(cache); // Output: {1=Alice, 2=Bob, 3=Charlie}

        cache.get(1); // Access key 1
        cache.put(4, "Diana"); // Add a new entry
        System.out.println(cache); // Output: {2=Bob, 3=Charlie, 1=Alice}
    }
}
```
