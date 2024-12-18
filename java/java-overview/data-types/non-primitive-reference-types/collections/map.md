# Map

## **About**

The `Map` interface in Java is part of the `java.util` package and represents a collection of key-value pairs. It provides an abstract data structure where each key is mapped to a specific value, enabling efficient data retrieval based on unique keys. Unlike a `Collection`, a `Map` does not allow duplicate keys, but it permits duplicate values.

* **Introduced in Java 1.2**, the `Map` interface forms a core part of the Java Collections Framework.
* It is widely used for tasks such as data indexing, lookups, caching, and configuration management.
* Maps are unordered by default unless you use implementations like `LinkedHashMap` or `TreeMap`.

## **Features**

1. **Key-Value Pairs**: Each entry in a `Map` consists of a unique key and an associated value. The uniqueness of keys ensures efficient access.
2. **No Duplicate Keys**: While values can be duplicated, keys must be unique. Adding a duplicate key will replace the previous mapping.
3. **Various Implementations**:
   * `HashMap`: Fast, unordered, allows one `null` key and multiple `null` values.
   * `TreeMap`: Ordered based on keys' natural ordering or a provided comparator.
   * `LinkedHashMap`: Maintains insertion or access order.
4. **Versatility**: A `Map` can store objects of different types using generic parameters, e.g., `Map<String, Integer>`.
5. **Thread Safety**:
   * Basic `Map` implementations like `HashMap` are not thread-safe.
   * Concurrent implementations such as `ConcurrentHashMap` ensure thread safety.
6. **Functional Programming Support**: From Java 8 onwards, `Map` includes several functional-style methods like `forEach`, `compute`, `merge`, and `replaceAll`.

## **Key Methods**

<table data-header-hidden data-full-width="true"><thead><tr><th width="309"></th><th></th></tr></thead><tbody><tr><td><strong>Method</strong></td><td><strong>Description</strong></td></tr><tr><td><code>put(K key, V value)</code></td><td>Associates the specified value with the specified key in the map.</td></tr><tr><td><code>get(Object key)</code></td><td>Retrieves the value associated with the given key, or <code>null</code> if the key is not present.</td></tr><tr><td><code>remove(Object key)</code></td><td>Removes the mapping for the specified key, if it exists.</td></tr><tr><td><code>containsKey(Object key)</code></td><td>Returns <code>true</code> if the map contains the specified key.</td></tr><tr><td><code>containsValue(Object value)</code></td><td>Returns <code>true</code> if the map contains one or more keys mapped to the specified value.</td></tr><tr><td><code>keySet()</code></td><td>Returns a <code>Set</code> view of all the keys in the map.</td></tr><tr><td><code>values()</code></td><td>Returns a <code>Collection</code> view of all the values in the map.</td></tr><tr><td><code>entrySet()</code></td><td>Returns a <code>Set</code> view of all the key-value mappings (<code>Map.Entry&#x3C;K, V></code> objects).</td></tr><tr><td><code>size()</code></td><td>Returns the number of key-value pairs in the map.</td></tr><tr><td><code>isEmpty()</code></td><td>Checks if the map is empty.</td></tr><tr><td><code>clear()</code></td><td>Removes all key-value mappings from the map.</td></tr><tr><td><code>putIfAbsent(K key, V value)</code></td><td>Adds the value only if the key is not already associated with another value.</td></tr><tr><td><code>compute(K key, BiFunction)</code></td><td>Computes a value for the specified key using the given function.</td></tr><tr><td><code>merge(K key, V value, BiFunction)</code></td><td>Merges the existing value with the provided one using the given function.</td></tr></tbody></table>

## **Map Implementations**

### **1. `HashMap`**

* **Features**:
  * Backed by a hash table.
  * No ordering of keys or values.
  * Allows `null` key and multiple `null` values.
* **Performance**:
  * O(1) for `put` and `get` operations in ideal conditions.
* **Use Case**: General-purpose map for fast lookups.

### **2. `LinkedHashMap`**

* **Features**:
  * Maintains insertion order or access order (configurable).
* **Performance**: Slightly slower than `HashMap`.
* **Use Case**: LRU (Least Recently Used) caches or when iteration order matters.

### **3. `TreeMap`**

* **Features**:
  * Implements `NavigableMap`.
  * Sorted based on natural ordering or a custom comparator.
* **Performance**: O(log n) for insertion, deletion, and lookup.
* **Use Case**: Sorted map for ranges and queries.

### **4. `Hashtable`**

* **Features**:
  * Legacy class.
  * Thread-safe but slower than modern alternatives.
  * Does not allow `null` keys or values.
* **Use Case**: Avoid unless compatibility with older code is required.

### **5. `ConcurrentHashMap`**

* **Features**:
  * Thread-safe.
  * Allows concurrent access without locking the entire map.
* **Use Case**: Multi-threaded environments.

### **6. `EnumMap`**

* **Features**:
  * Designed specifically for `enum` keys.
  * Backed by an array, making it fast and memory-efficient.
* **Use Case**: Maps with fixed, predefined keys.

## **Custom Implementations of Map**

### **Why Create a Custom Map?**

Custom `Map` implementations are useful when the standard implementations do not meet specific requirements, such as:

* Custom hashing or equality logic.
* Special behavior for specific keys or values.
* Optimized performance for a particular use case.

### **Steps to Implement a Custom Map**

1. **Implement the `Map` Interface**:
   * The `Map` interface has 16 methods to implement.
   * We can extend `AbstractMap` to simplify the process as it provides default implementations for some methods.
2. **Key Points to Consider**:
   * **Storage**: Decide how the key-value pairs will be stored (e.g., array, linked list, tree).
   * **Hashing and Equality**: Define custom logic for hashing or equality if necessary.
   * **Concurrency**: Ensure thread safety if required.

### **Example: Custom Fixed-Size Map**

```java
import java.util.AbstractMap;
import java.util.Set;
import java.util.HashSet;

public class FixedSizeMap<K, V> extends AbstractMap<K, V> {
    private final int maxSize;
    private final HashSet<Entry<K, V>> entries;

    public FixedSizeMap(int maxSize) {
        this.maxSize = maxSize;
        this.entries = new HashSet<>();
    }

    @Override
    public V put(K key, V value) {
        if (entries.size() >= maxSize) {
            throw new IllegalStateException("Map is full");
        }
        remove(key); // Ensure no duplicate keys
        entries.add(new SimpleEntry<>(key, value));
        return value;
    }

    @Override
    public V get(Object key) {
        for (Entry<K, V> entry : entries) {
            if (entry.getKey().equals(key)) {
                return entry.getValue();
            }
        }
        return null;
    }

    @Override
    public Set<Entry<K, V>> entrySet() {
        return entries;
    }
}
```

### **Use Case of Custom Map**

* A fixed-size map where additional inserts beyond a certain limit throw an exception.
* Maps with encryption for keys or values.

