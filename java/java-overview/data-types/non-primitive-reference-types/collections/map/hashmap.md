# HashMap

## **About**

`HashMap` is a part of the `java.util` package and is used to store key-value pairs. It is based on **hashing** and provides constant-time performance for basic operations like insertion, deletion, and lookup under ideal conditions.

* Keys are unique, while values can be duplicated.
* Allows `null` as a key (only one `null` key is allowed) and multiple `null` values.
* It is unsynchronized and not thread-safe by default.

## **Features**

1. **Key-Value Mapping**: Stores data as key-value pairs where the key is unique.
2. **Fast Access**: O(1) average time complexity for most operations.
3. **Dynamic Resizing**: Automatically resizes when the number of entries exceeds the load factor.
4. **Allows Null**: Accepts one `null` key and multiple `null` values.
5. **Order**: Does not guarantee any order of keys or values.
6. **Non-Synchronized**: Use `Collections.synchronizedMap()` for thread-safe operations or `ConcurrentHashMap` for better performance.
7. **Customizable Hashing**: Custom objects can be used as keys by overriding `hashCode()` and `equals()`.

## Internal Working

The internal mechanism of `HashMap` revolves around **hashing**, which maps keys to bucket indices for efficient data storage and retrieval.

### **Data Structure**

* Internally, `HashMap` uses an **array of `Node<K, V>` objects** (or `Entry<K, V>` in earlier versions of Java).
* Each node is a linked list node (or tree node in Java 8+).

```java
static class Node<K, V> implements Map.Entry<K, V> {
    final int hash;    // Hash code of the key
    final K key;       // Key
    V value;           // Value
    Node<K, V> next;   // Pointer to the next node in the bucket (for collisions)
}
```

### **Hashing**

* When a key-value pair is inserted, the key’s `hashCode()` method generates an integer hash code.
*   The hash code is then compressed into a bucket index using this formula:

    ```java
    index = (hash & 0x7FFFFFFF) % capacity
    ```

    * `hash` is the hash code of the key.
    * `capacity` is the size of the internal array (default: 16).
    * The bitwise AND operation with `0x7FFFFFFF` (a mask) ensures that the hash code is converted into a **non-negative value**.
    * `0x7FFFFFFF` is the maximum positive value for a 32-bit signed integer (`2³¹ - 1` in decimal).&#x20;
    * The result effectively removes the sign bit of the hash code, making it non-negative

### **Buckets**

* Each bucket in the array stores a linked list or a balanced binary tree (Java 8+).
* If two keys hash to the same index, they are stored in the same bucket, forming a **collision chain**.

### **Collision Handling**

* **Separate Chaining**: Colliding keys are stored as nodes in a linked list within the same bucket.
* **Treeify (Java 8+)**: When a bucket's size exceeds a threshold (default: 8), the list is converted into a red-black tree for faster lookup.

{% hint style="info" %}
**Treeification in Java 8+**

* **Why Treeify?** To improve lookup time in case of many collisions. A linked list traversal is O(n), while a red-black tree lookup is O(log n).
* **How Treeify Works:**
  * When the number of nodes in a bucket exceeds a threshold (`TREEIFY_THRESHOLD = 8`), the linked list is converted into a red-black tree.
  * If the size of the bucket reduces (due to deletions), the tree is converted back to a linked list.
{% endhint %}

### **Load Factor and Resizing**

*   **Load Factor:** The ratio of the number of elements to the capacity of the bucket array.

    ```java
    loadFactor = size / capacity
    ```

    * Default load factor: 0.75.
    * When the load factor exceeds this value, resizing is triggered.
* **Resizing Process:**
  1. Create a new array with double the capacity.
  2. Rehash all entries from the old array to the new one.
  3. This ensures even distribution across buckets.

### **Operations**

#### **Insertion**

1. Compute the hash code of the key using `hashCode()`.
2. Calculate the index using the hash code and the bucket array size.
3. If no entry exists at the index, the new key-value pair is added.
4. If a collision occurs:
   * Traverse the bucket’s linked list or tree to check if the key already exists.
   * If the key exists, update its value.
   * Otherwise, append a new node to the list (or add it to the tree).

#### **Retrieval**

1. Compute the hash code of the key and calculate the bucket index.
2. Traverse the linked list or tree at the calculated index to find the node with the matching key.
3. Return the value associated with the key, or `null` if not found.

#### **Resizing**

* When the `HashMap` exceeds its **load factor** (default: 0.75), the bucket array is resized to double its previous size.
* All existing entries are rehashed and redistributed into the new array.
  * This is an expensive operation, as it involves recomputing indices for all keys.

## **Key Methods**

<table data-header-hidden><thead><tr><th width="292"></th><th></th></tr></thead><tbody><tr><td><strong>Method</strong></td><td><strong>Description</strong></td></tr><tr><td><code>put(K key, V value)</code></td><td>Associates the specified value with the specified key.</td></tr><tr><td><code>get(Object key)</code></td><td>Returns the value associated with the key or <code>null</code> if the key is not present.</td></tr><tr><td><code>remove(Object key)</code></td><td>Removes the key-value pair for the specified key.</td></tr><tr><td><code>containsKey(Object key)</code></td><td>Checks if the map contains the specified key.</td></tr><tr><td><code>containsValue(Object value)</code></td><td>Checks if the map contains the specified value.</td></tr><tr><td><code>keySet()</code></td><td>Returns a <code>Set</code> view of the keys contained in the map.</td></tr><tr><td><code>values()</code></td><td>Returns a <code>Collection</code> view of the values.</td></tr><tr><td><code>entrySet()</code></td><td>Returns a <code>Set</code> view of the key-value pairs.</td></tr><tr><td><code>size()</code></td><td>Returns the number of key-value mappings in the map.</td></tr><tr><td><code>isEmpty()</code></td><td>Checks if the map is empty.</td></tr><tr><td><code>clear()</code></td><td>Removes all key-value pairs.</td></tr></tbody></table>

## **Big-O for Operations**

| **Operation**              | **Average Case** | **Worst Case** |
| -------------------------- | ---------------- | -------------- |
| **Get/Put (No Collision)** | O(1)             | O(n)           |
| **Remove**                 | O(1)             | O(n)           |
| **Contains Key/Value**     | O(1)             | O(n)           |
| **Iteration**              | O(n)             | O(n)           |

## **Limitations**

* Not thread-safe (use `ConcurrentHashMap` for thread safety).
* Performance degrades with a poor hash function or excessive collisions.
* Resizing can be computationally expensive.

## **Real-World Usage**

* **Caching Systems**: Store frequently accessed data for quick retrieval.
* **Configuration Maps**: Store application settings as key-value pairs.
* **Data Deduplication**: Quickly identify duplicates in large datasets.

## **Examples**

### **1. Basic Operations**

```java
import java.util.HashMap;

public class HashMapExample {
    public static void main(String[] args) {
        HashMap<Integer, String> map = new HashMap<>();

        // Adding elements
        map.put(1, "Alice");
        map.put(2, "Bob");
        map.put(3, "Charlie");
        System.out.println(map); // Output: {1=Alice, 2=Bob, 3=Charlie}

        // Accessing elements
        System.out.println("Value for key 2: " + map.get(2)); // Output: Value for key 2: Bob

        // Check presence of key or value
        System.out.println("Contains key 3: " + map.containsKey(3)); // Output: Contains key 3: true
        System.out.println("Contains value 'Bob': " + map.containsValue("Bob")); // Output: Contains value 'Bob': true

        // Removing an element
        map.remove(1);
        System.out.println(map); // Output: {2=Bob, 3=Charlie}
    }
}
```

### **2. Iteration**

```java
import java.util.HashMap;
import java.util.Map;

public class IterationExample {
    public static void main(String[] args) {
        HashMap<String, Integer> map = new HashMap<>();
        map.put("Apple", 3);
        map.put("Banana", 5);
        map.put("Cherry", 2);

        // Iterating using entrySet
        for (Map.Entry<String, Integer> entry : map.entrySet()) {
            System.out.println(entry.getKey() + " -> " + entry.getValue());
            // Output:
            // Apple -> 3
            // Banana -> 5
            // Cherry -> 2
        }

        // Iterating using keySet
        for (String key : map.keySet()) {
            System.out.println("Key: " + key + ", Value: " + map.get(key));
            // Output:
            // Key: Apple, Value: 3
            // Key: Banana, Value: 5
            // Key: Cherry, Value: 2
        }
    }
}
```

### **3. Handling Null Keys and Values**

```java
import java.util.HashMap;

public class NullHandlingExample {
    public static void main(String[] args) {
        HashMap<String, String> map = new HashMap<>();
        map.put(null, "NullKey"); // Adding a null key
        map.put("Test", null);   // Adding a null value
        System.out.println(map); // Output: {null=NullKey, Test=null}
    }
}
```

### **4. Custom Key with Overridden `hashCode()` and `equals()`**

```java
import java.util.HashMap;
import java.util.Objects;

class Employee {
    int id;
    String name;

    Employee(int id, String name) {
        this.id = id;
        this.name = name;
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, name);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Employee employee = (Employee) o;
        return id == employee.id && Objects.equals(name, employee.name);
    }

    @Override
    public String toString() {
        return "Employee{id=" + id + ", name='" + name + "'}";
    }
}

public class CustomKeyExample {
    public static void main(String[] args) {
        HashMap<Employee, String> map = new HashMap<>();
        map.put(new Employee(1, "Alice"), "HR");
        map.put(new Employee(2, "Bob"), "Finance");
        System.out.println(map);
        // Output: {Employee{id=1, name='Alice'}=HR, Employee{id=2, name='Bob'}=Finance}
    }
}
```





