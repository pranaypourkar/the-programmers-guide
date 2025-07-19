# Hashtable

## **About**

A `Hashtable` in Java is a legacy class that implements the `Map` interface and is part of the `java.util` package. It is used to store key-value pairs, similar to `HashMap`. However, it is synchronized and thread-safe, making it suitable for concurrent programming where multiple threads access the data simultaneously.

* **Introduced**: Java 1.0
* **Thread Safety**: Synchronized but less efficient than modern alternatives.
* **Null Handling**: Does not allow `null` keys or `null` values.

## **Features**

1. **Key-Value Mapping**: Stores key-value pairs where keys are unique.
2. **Thread-Safe**: All methods are synchronized, making it suitable for multithreaded environments.
3. **No Null Keys or Values**: Unlike `HashMap`, `null` keys or `null` values are not allowed.
4. **Dynamic Resizing**: Automatically resizes when the load factor exceeds the threshold.
5. **Enumerations**: Supports legacy `Enumeration` for traversing elements.
6. **Hashing Mechanism**: Uses hashing to store and retrieve elements efficiently.

## **Internal Working**

### **Data Storage**

* Data is stored in an internal array of **buckets**.
* Each bucket is a linked list of key-value pairs, used for collision handling.

### **Hashing Mechanism**

* A key's `hashCode()` is computed to determine its bucket index in the array.
* The hash is modulated by the array size to fit the key into a valid index.

### **Collision Handling**

* Uses **Separate Chaining**: If two keys hash to the same index, they are stored as a linked list in the same bucket.
* During retrieval, the list is traversed, and keys are compared using `equals()`.

### **Synchronization**

* All operations (like `get`, `put`, `remove`) are synchronized using the **object-level lock** on the `Hashtable`.
* This prevents simultaneous access by multiple threads but can cause contention and degrade performance.

### **Load Factor and Resizing**

* The default load factor is 0.75.
* When the size exceeds the capacity × load factor, the table resizes by doubling its size and rehashing all entries.

### **Key Methods for Hashing**

* The `hashCode()` method is used to compute the hash.
* The `equals()` method checks if two keys are equal.

## **Key Methods**

<table data-header-hidden><thead><tr><th width="331"></th><th></th></tr></thead><tbody><tr><td><strong>Method</strong></td><td><strong>Description</strong></td></tr><tr><td><code>put(K key, V value)</code></td><td>Associates the specified value with the specified key.</td></tr><tr><td><code>get(Object key)</code></td><td>Returns the value associated with the specified key, or <code>null</code> if the key is not present.</td></tr><tr><td><code>remove(Object key)</code></td><td>Removes the key-value pair for the specified key.</td></tr><tr><td><code>containsKey(Object key)</code></td><td>Checks if the table contains the specified key.</td></tr><tr><td><code>containsValue(Object value)</code></td><td>Checks if the table contains the specified value.</td></tr><tr><td><code>size()</code></td><td>Returns the number of key-value pairs.</td></tr><tr><td><code>isEmpty()</code></td><td>Checks if the table is empty.</td></tr><tr><td><code>clear()</code></td><td>Removes all key-value pairs.</td></tr><tr><td><code>elements()</code></td><td>Returns an enumeration of the values.</td></tr><tr><td><code>keys()</code></td><td>Returns an enumeration of the keys.</td></tr></tbody></table>

## **Big-O for Operations**

| **Operation**              | **Average Case** | **Worst Case** |
| -------------------------- | ---------------- | -------------- |
| **Put/Get (No Collision)** | O(1)             | O(n)           |
| **Remove**                 | O(1)             | O(n)           |
| **Contains Key/Value**     | O(1)             | O(n)           |
| **Iteration**              | O(n)             | O(n)           |

## **Limitations**

1. **Performance**: Synchronization causes slower performance compared to non-synchronized collections like `HashMap`.
2. **No Null Keys/Values**: `Hashtable` does not allow `null` keys or `null` values, unlike `HashMap`.
3. **Legacy Class**: Considered obsolete and rarely used in modern applications; `ConcurrentHashMap` is preferred for thread-safe operations.
4. **Iteration Mechanism**: Does not support modern Java iteration mechanisms like the enhanced `for` loop or streams.

## **Real-World Usage**

1. **Thread-Safe Caches**: Used in multithreaded applications where key-value pairs are cached.
2. **Small-Scale Legacy Systems**: Often found in older Java codebases written before Java 2 Collections Framework.
3. **Configuration Management**: Used for storing configuration settings in key-value format where thread safety is essential.

## **Examples**

### **1. Basic Operations**

```java
import java.util.Hashtable;

public class HashtableExample {
    public static void main(String[] args) {
        Hashtable<Integer, String> table = new Hashtable<>();

        // Adding elements
        table.put(1, "Alice");
        table.put(2, "Bob");
        table.put(3, "Charlie");
        System.out.println(table); // Output: {3=Charlie, 2=Bob, 1=Alice}

        // Accessing elements
        System.out.println("Value for key 2: " + table.get(2)); // Output: Value for key 2: Bob

        // Check presence of key or value
        System.out.println("Contains key 3: " + table.containsKey(3)); // Output: Contains key 3: true
        System.out.println("Contains value 'Bob': " + table.containsValue("Bob")); // Output: Contains value 'Bob': true

        // Removing an element
        table.remove(1);
        System.out.println(table); // Output: {3=Charlie, 2=Bob}
    }
}
```

### **2. Iteration Using Enumeration**

```java
import java.util.Enumeration;
import java.util.Hashtable;

public class EnumerationExample {
    public static void main(String[] args) {
        Hashtable<String, Integer> table = new Hashtable<>();
        table.put("Apple", 3);
        table.put("Banana", 5);
        table.put("Cherry", 2);

        // Iterating over keys
        Enumeration<String> keys = table.keys();
        while (keys.hasMoreElements()) {
            String key = keys.nextElement();
            System.out.println("Key: " + key + ", Value: " + table.get(key));
            // Output:
            // Key: Apple, Value: 3
            // Key: Banana, Value: 5
            // Key: Cherry, Value: 2
        }
    }
}
```

### **3. Thread-Safe Usage**

```java
import java.util.Hashtable;

public class ThreadSafeExample {
    public static void main(String[] args) {
        Hashtable<Integer, String> table = new Hashtable<>();

        Runnable task = () -> {
            for (int i = 0; i < 5; i++) {
                table.put(i, "Value " + i);
                System.out.println(Thread.currentThread().getName() + " added: " + i); 
            }
        };

        Thread t1 = new Thread(task);
        Thread t2 = new Thread(task);

        t1.start();
        t2.start();
    }
}
```

### **4. Attempting Null Key or Value**

```java
import java.util.Hashtable;

public class NullExample {
    public static void main(String[] args) {
        Hashtable<Integer, String> table = new Hashtable<>();
        try {
            table.put(null, "NullKey"); // Throws NullPointerException
        } catch (NullPointerException e) {
            System.out.println("Null keys are not allowed in Hashtable.");
        }

        try {
            table.put(1, null); // Throws NullPointerException
        } catch (NullPointerException e) {
            System.out.println("Null values are not allowed in Hashtable.");
        }
    }
}
```

