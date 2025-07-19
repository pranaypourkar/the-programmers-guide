# Collision Resolution

## About

A **hash table** stores key-value pairs and allows for fast retrieval using a **hash function**. A key is hashed into an index of an internal array. A **collision** occurs in a hash table when **two different keys** get **mapped to the same index** in the hash table array.

This happens because:

* The hash table has **limited slots** (array size).
* The **hash function**, which converts keys into array indices, is not perfect and may map multiple keys to the same index.

### How Does Collision Happen?

Let’s consider a simple example:

```java
int index = key.hashCode() % tableSize;
```

If `tableSize = 10`, and:

* `"John".hashCode() % 10 = 3`
* `"Doe".hashCode() % 10 = 3`

Both keys will be placed at **index 3** → this is a **collision**.

This is a common situation in hash tables, especially when:

* The number of keys is large.
* The table is small or nearly full.
* The hash function does not distribute keys uniformly.

### Causes of Collisions

1. **Limited Hash Table Size**\
   If the array size is small (e.g., 10), only 10 different indices are possible.
2. **Bad Hash Functions**\
   A poor hash function may map many keys to the same index.
3. **Too Many Keys (High Load Factor)**\
   If many keys are inserted, chances of collision naturally increase.
4. **Similar Keys**\
   Certain key patterns (e.g., strings with common prefixes) may produce similar hashes.

{% hint style="warning" %}
**Load factor = number of elements / table size**

* If load factor is too high (e.g., > 0.75), chances of collision go up.
* Java’s `HashMap` resizes the table when load factor exceeds the threshold (default is 0.75).
{% endhint %}

### Implications of Collision

Collisions can lead to:

1. **Slower Lookups**\
   We must now **search through a list or probe** for the correct key, increasing time complexity from O(1) to O(n) in the worst case.
2. **Increased Memory Usage**\
   Chaining uses extra memory to store lists or trees at each bucket.
3. **Difficult Deletions**\
   Especially in open addressing, deleting keys may break the search/probe sequence.
4. **Clustering**\
   Some probing strategies (like linear probing) cause clusters of keys, worsening performance.
5. **Poor Performance on Rehash**\
   If collisions are excessive, resizing the table becomes costly, and even rehashed data may not solve the problem if the hash function is still poor.

## Goal of Good Collision Handling

A good hash table implementation ensures that:

* Collisions are **minimized** (via a good hash function).
* When they occur, they are **handled efficiently** (via chaining or probing).
* Lookup, insert, and delete operations remain **close to O(1)** on average.

## Collision Resolution Techniques

{% hint style="success" %}
Should We Learn Collision Resolution Techniques?

In **90% of business applications**, we should just use:

```java
Map<Key, Value> map = new HashMap<>();
```

Because:

* Java’s `HashMap` already handles collisions using **separate chaining** and later **balanced trees** (since Java 8, when bucket size exceeds threshold).
* It’s well-tested, fast, and handles resizing, load factor, etc., automatically.

However, we should be aware of the techniques.
{% endhint %}

### 1. **Separate Chaining (Open Hashing)**

* In this approach, **each slot in the hash table holds a list (or any dynamic structure)** of entries that map to the same index.
* When a collision occurs, the new element is simply added to the list at that index.

**Internal Structure:**

* `HashMap<K, V>` in Java uses a **linked list** or **red-black tree** for each bucket depending on the number of entries.

**Example:**

```java
Map<Integer, List<String>> hashTable = new HashMap<>();
```

**Advantages:**

* Easy to implement and debug.
* Allows table size to be smaller than number of elements.
* Can handle large numbers of collisions efficiently.

**Disadvantages:**

* Uses extra memory for the data structure at each index.
* If many keys collide, linked list search becomes O(n) in worst case (though Java optimizes this with trees).

**Use When:**

* Keys may have poor distribution.
* We prefer simplicity and flexibility over space.

### 2. **Open Addressing (Closed Hashing)**

In **open addressing**, all entries are stored directly in the array. If a collision occurs, we find another open slot based on a **probing sequence**.

#### **2.1 Linear Probing**

* If the hashed index is occupied, try the next one (`+1`), then `+2`, and so on until an empty slot is found.

**Formula:**

```java
index = (hash + i) % tableSize
```

**Problem:**

* **Primary clustering**: Long blocks of occupied slots increase the chance of more collisions.

**Advantages:**

* Simple and easy to implement.
* Cache-friendly due to linear memory access.

**Disadvantages:**

* Primary clustering reduces performance.
* Deletion is difficult since removing an element may break the probing chain.

**Use When:**

* We need cache efficiency and can keep the load factor low (< 0.7).

#### **2.2 Quadratic Probing**

* Instead of checking `i+1`, `i+2`, we try `i^2`, `i^4`, and so on.

**Formula:**

```java
index = (hash + c1*i + c2*i*i) % tableSize
```

Usually: `c1 = 0, c2 = 1` gives `(hash + i^2) % size`.

**Advantages:**

* Reduces clustering compared to linear probing.
* Better spread of values in the array.

**Disadvantages:**

* Can’t always guarantee to find a slot unless table size is prime.
* Secondary clustering: keys with same hash follow the same probe path.

**Use When:**

* We want to avoid primary clustering and can handle mathematical probing.

#### **2.3 Double Hashing**

* Use **two hash functions**: the second one decides the step size during probing.

**Formula:**

```java
index = (hash1(key) + i * hash2(key)) % tableSize
```

Where:

* `hash1(key)` gives initial position
* `hash2(key)` gives the step size (must not be 0)

**Example:**

```java
hash2 = prime - (key % prime)
```

**Advantages:**

* Best probe distribution.
* Minimizes both primary and secondary clustering.
* Access time close to ideal.

**Disadvantages:**

* Slightly more complex implementation.
* Second hash function must be carefully designed.

**Use When:**

* We want highest performance and good distribution.

### 3. **Rehashing (Resizing Hash Table)**

* As the number of elements increases, hash table gets **resized** (usually doubled).
* All existing entries are rehashed and placed into the new table.

**In Java:**

* `HashMap` resizes automatically when **load factor > 0.75**.
* Load factor = (number of entries) / (table size)

**Advantages:**

* Keeps performance optimal by avoiding too many collisions.
* Dynamic growth.

**Disadvantages:**

* Rehashing is expensive and time-consuming.
* Temporary performance hit during resizing.



