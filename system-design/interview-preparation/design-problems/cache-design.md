# Cache Design

## 1. Estimate Cache Memory needed for caching 1 million entries of a Java object

### About

In a typical Spring Boot microservice, suppose we are caching frequently accessed data using an in-memory cache like `ConcurrentHashMap`, `Caffeine`, or Spring’s built-in caching abstraction. Each cached entry consists of:

* **Key**: A unique identifier (e.g., String or UUID)
* **Value**: A Java object with approximately 10–15 fields

Let’s estimate how much **JVM heap memory** will be required to cache **1 million such objects**.

**Breakdown of Memory Usage**

### 1. Object Overhead (JVM Internal Structure)

Every object in the JVM has some built-in memory overhead, regardless of the fields it contains. This includes:

<table data-full-width="true"><thead><tr><th width="159.98046875">Component</th><th>Size (Bytes)</th><th>Description</th></tr></thead><tbody><tr><td>Object Header</td><td><strong>12 bytes</strong> (on 64-bit JVM with compressed oops)</td><td>Stores object metadata like identity hash, GC info, and type pointer.</td></tr><tr><td>Object Padding</td><td><strong>Up to 8 bytes</strong> (to align to 8-byte boundaries)</td><td>JVM aligns object size to 8-byte multiples for efficient memory access.</td></tr><tr><td>Reference Fields</td><td><strong>4 or 8 bytes each</strong></td><td>Depending on whether compressed oops are enabled.</td></tr><tr><td>Internal Pointers</td><td>Adds indirection and slight overhead when objects contain references to other objects.</td><td></td></tr></tbody></table>

{% hint style="info" %}
**Typical overhead per object (excluding fields):** \~12–16 bytes\
If references are involved, field alignment and padding increase usage further.
{% endhint %}

### 2. Estimated Field Composition (Example: 10 Fields)

Let's assume the object being cached looks like this:

```java
public class UserProfile {
    private UUID id;
    private String name;
    private String email;
    private int age;
    private boolean active;
    private long createdAt;
    private String country;
    private String phone;
    private int loginCount;
    private boolean verified;
    // Total: 10 fields
}
```

<table data-full-width="true"><thead><tr><th width="101.87890625">Field Type</th><th width="67.53125">Count</th><th width="253.1953125">Estimated Size</th><th>Notes</th></tr></thead><tbody><tr><td><code>UUID</code></td><td>1</td><td>16 bytes</td><td>Backed by two <code>long</code> values</td></tr><tr><td><code>String</code></td><td>4</td><td>40–80 bytes each</td><td>Depends on string length; average 60 bytes</td></tr><tr><td><code>int</code></td><td>2</td><td>4 bytes each</td><td>Total: 8 bytes</td></tr><tr><td><code>boolean</code></td><td>2</td><td>1 byte each (but rounded up)</td><td>Total padded to 4–8 bytes</td></tr><tr><td><code>long</code></td><td>1</td><td>8 bytes</td><td>64-bit long</td></tr></tbody></table>

**Total estimated size of fields**:

* `UUID` = 16 bytes
* `4 Strings` = \~240 bytes
* `2 int` = 8 bytes
* `2 boolean` (padded) = \~8 bytes
* `1 long` = 8 bytes

**→ Total = \~280–320 bytes for fields**

### 3. Additional Memory Per Entry (Cache-Level Overhead)

When storing these objects in a map or cache (e.g., `ConcurrentHashMap` or `Caffeine`), we also need to account for:

<table><thead><tr><th width="191.87109375">Component</th><th width="150.5078125">Estimated Size</th><th>Description</th></tr></thead><tbody><tr><td><strong>Key Object</strong></td><td>~40–60 bytes</td><td>UUID or String, including its internal character array</td></tr><tr><td><strong>Map Entry Overhead</strong></td><td>~32–48 bytes</td><td>Bucket pointer, hash, references</td></tr><tr><td><strong>Value Object</strong></td><td>~300–350 bytes</td><td>As estimated above</td></tr><tr><td><strong>References</strong></td><td>~8–16 bytes</td><td>Reference to value and key</td></tr></tbody></table>

**Total per cache entry**:\
&#xNAN;**\~400–500 bytes** conservatively\
In worst cases, may grow up to **550–600 bytes**.

### 4. Total Estimated Memory Usage

To calculate total memory for 1 million entries:

```
Per Entry (average): 500 bytes
Total Entries       : 1,000,000
-------------------------------
Total Memory Needed : 500 * 1,000,000 = 500,000,000 bytes ≈ 476 MB
```

#### Buffering for Safety

Due to GC metadata, alignment, fragmentation, and fluctuations in field size:

* Add 30–40% buffer
* **Recommended Heap Size**: **700–800 MB**

### 5. How to Measure Actual Memory Usage (Empirical Approach) ?

To validate the estimate with real data:

1.  **Write a test class** to load 1 million objects into a `Map`:

    ```java
    Map<UUID, UserProfile> cache = new HashMap<>();
    for (int i = 0; i < 1_000_000; i++) {
        cache.put(UUID.randomUUID(), new UserProfile(...));
    }
    ```
2. **Use a Java profiler**:
   * **JVisualVM**: Attach to the JVM and inspect heap usage.
   * **Eclipse MAT** (Memory Analyzer Tool): For analyzing heap dumps.
   * **YourKit** or **JProfiler**: For in-depth memory profiling.
3. **Compare memory usage before and after population.**



## **2.** LRU Cache

Design and build a "least recently used" cache, which evicts the least recently used item. The cache should map from keys to values (allowing us to insert and retrieve a value associated with a particular key) and be initialized with a max size. When it is full, it should evict the least recently used item.

We need to **design a cache** that:

1. Stores key-value pairs.
2. Has a **maximum size** (capacity).
3. When inserting a new item and the cache is **full**, it must **evict the least recently used (LRU)** item.
4. Both `get(key)` and `put(key, value)` operations must be done in **O(1)** time.

To support O(1) operations:

* Use a **HashMap** to store key → node mappings.
* Use a **Doubly Linked List** to track usage order (most recently used at head, least at tail).

Whenever:

* We `get(key)`: Move the node to the front (MRU).
* We `put(key, value)`:
  * If key exists: Update and move to front.
  * If key doesn’t exist and at capacity: Remove tail (LRU), insert new node at head.

```java
import java.util.HashMap;
import java.util.Map;

public class LRUCache {
    
    // Doubly linked list node
    private class Node {
        int key, value;
        Node prev, next;

        Node(int key, int value) {
            this.key = key;
            this.value = value;
        }
    }

    private final int capacity;
    private final Map<Integer, Node> cache; // Maps keys to nodes
    private final Node head, tail;          // Dummy head and tail for ease of insertion/removal

    public LRUCache(int capacity) {
        this.capacity = capacity;
        this.cache = new HashMap<>();

        // Initialize dummy head and tail to avoid null checks
        head = new Node(0, 0); 
        tail = new Node(0, 0);
        head.next = tail;
        tail.prev = head;
    }

    // Get the value associated with a key
    public int get(int key) {
        if (!cache.containsKey(key)) {
            return -1; // Not found
        }

        Node node = cache.get(key);

        // Move the accessed node to the front (most recently used)
        moveToFront(node);
        return node.value;
    }

    // Put a key-value pair into the cache
    public void put(int key, int value) {
        if (cache.containsKey(key)) {
            // Key exists: update value and move to front
            Node node = cache.get(key);
            node.value = value;
            moveToFront(node);
        } else {
            // New key
            if (cache.size() == capacity) {
                // Remove least recently used (LRU) node from tail
                Node lru = tail.prev;
                removeNode(lru);
                cache.remove(lru.key);
            }

            Node newNode = new Node(key, value);
            addToFront(newNode);
            cache.put(key, newNode);
        }
    }

    // Move an existing node to the front (MRU position)
    private void moveToFront(Node node) {
        removeNode(node);
        addToFront(node);
    }

    // Add a node right after dummy head
    private void addToFront(Node node) {
        node.prev = head;
        node.next = head.next;

        head.next.prev = node;
        head.next = node;
    }

    // Remove a node from the list
    private void removeNode(Node node) {
        node.prev.next = node.next;
        node.next.prev = node.prev;
    }
}
```

```java
public class Main {
    public static void main(String[] args) {
        LRUCache cache = new LRUCache(2);

        cache.put(1, 10); // cache = {1=10}
        cache.put(2, 20); // cache = {2=20, 1=10}

        System.out.println(cache.get(1)); // returns 10, cache = {1=10, 2=20}

        cache.put(3, 30); // evicts key 2, cache = {3=30, 1=10}
        System.out.println(cache.get(2)); // returns -1

        cache.put(4, 40); // evicts key 1, cache = {4=40, 3=30}
        System.out.println(cache.get(1)); // returns -1
        System.out.println(cache.get(3)); // returns 30
        System.out.println(cache.get(4)); // returns 40
    }
}
```

