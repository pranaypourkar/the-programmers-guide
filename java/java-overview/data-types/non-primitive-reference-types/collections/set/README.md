# Set

## **About**

The `Set` interface, part of the `java.util` package, is a specialized collection that **does not allow duplicate elements**. It models a mathematical set and is a child of the `Collection` interface. The primary purpose of a `Set` is to store unique elements in no particular order (unless specified by an implementation).

* Introduced in Java 1.2 as part of the **Java Collections Framework (JCF)**.
* Commonly used to represent collections of distinct items, such as IDs, tags, or unique objects.
* All implementations ensure that no two elements are equal as determined by their `equals()` method.

## **Features**

1. **Unique Elements**: A `Set` contains no duplicate elements, i.e., no two elements in the set are considered equal based on the `equals()` method.
2. **Optional Ordering**:
   * `HashSet`: No ordering.
   * `LinkedHashSet`: Maintains insertion order.
   * `TreeSet`: Maintains natural or custom sorting order.
3. **Efficient Membership Testing**: The `contains()` method is optimized in most `Set` implementations for quick membership testing.
4. **Null Handling**:
   * `HashSet` and `LinkedHashSet` allow a single `null` element.
   * `TreeSet` does not allow `null` if it uses natural ordering (throws `NullPointerException`).
5. **Thread-Safety**:
   * Basic implementations are not thread-safe.
   * Use `Collections.synchronizedSet` or `ConcurrentSkipListSet` for thread-safe operations.
6. **Functional Programming Support**: From Java 8 onwards, `Set` supports methods like `forEach`, `stream`, and `removeIf` for functional-style operations.

## **Key Methods**

<table data-header-hidden data-full-width="true"><thead><tr><th width="361"></th><th></th></tr></thead><tbody><tr><td><strong>Method</strong></td><td><strong>Description</strong></td></tr><tr><td><code>add(E e)</code></td><td>Adds the specified element to the set if it is not already present.</td></tr><tr><td><code>remove(Object o)</code></td><td>Removes the specified element from the set if it is present.</td></tr><tr><td><code>contains(Object o)</code></td><td>Returns <code>true</code> if the set contains the specified element.</td></tr><tr><td><code>size()</code></td><td>Returns the number of elements in the set.</td></tr><tr><td><code>isEmpty()</code></td><td>Checks if the set is empty.</td></tr><tr><td><code>clear()</code></td><td>Removes all elements from the set.</td></tr><tr><td><code>iterator()</code></td><td>Returns an iterator over the elements in the set.</td></tr><tr><td><code>toArray()</code></td><td>Converts the set to an array.</td></tr><tr><td><code>addAll(Collection&#x3C;? extends E>)</code></td><td>Adds all elements from the specified collection to the set.</td></tr><tr><td><code>retainAll(Collection&#x3C;?> c)</code></td><td>Retains only the elements in this set that are contained in the specified collection.</td></tr><tr><td><code>removeAll(Collection&#x3C;?> c)</code></td><td>Removes all elements in the set that are also contained in the specified collection.</td></tr><tr><td><code>stream()</code></td><td>Returns a sequential stream of the set’s elements.</td></tr></tbody></table>

## **Set Implementations**

### **1. `HashSet`**

* **Features**:
  * Backed by a hash table.
  * No ordering of elements.
  * Allows a single `null` element.
* **Performance**:
  * O(1) for `add`, `remove`, and `contains` in average cases.
* **Use Case**: General-purpose set for quick lookups.

### **2. `LinkedHashSet`**

* **Features**:
  * Maintains insertion order.
  * Slightly slower than `HashSet`.
  * Allows one `null` element.
* **Performance**: Slightly higher overhead due to order tracking.
* **Use Case**: When consistent iteration order is required.

### **3. `TreeSet`**

* **Features**:
  * Implements `NavigableSet`.
  * Elements are stored in a sorted (natural or custom comparator) order.
  * Does not allow `null` elements.
* **Performance**: O(log n) for `add`, `remove`, and `contains`.
* **Use Case**: Ordered collections and range-based operations.

### **4. `EnumSet`**

* **Features**:
  * Specialized for `enum` types.
  * Very fast and memory-efficient (uses bitwise operations internally).
* **Performance**: Faster than `HashSet` for `enum` keys.
* **Use Case**: Collections with predefined, fixed values.

### **5. `ConcurrentSkipListSet`**

* **Features**:
  * Thread-safe.
  * Sorted using natural order or a custom comparator.
* **Use Case**: Multi-threaded applications where a sorted set is required.

### **6. `CopyOnWriteArraySet`**

* **Features**:
  * Thread-safe set based on a copy-on-write strategy.
  * Ideal for sets that are mostly read but occasionally updated.
* **Use Case**: Concurrent read-heavy applications.

## **Custom Implementations of Set**

### **Why Create a Custom Set?**

Custom `Set` implementations are useful when:

* We need custom equality or hashing logic.
* Standard implementations are not optimized for specific scenarios.
* Additional constraints or behaviors are required (e.g., a bounded set).

### **Steps to Implement a Custom Set**

1. **Implement the `Set` Interface**:
   * The `Set` interface has 12 methods to implement.
   * Extending `AbstractSet` simplifies the implementation by providing default behavior for some methods.
2. **Key Considerations**:
   * **Storage**: Decide how to store the elements (e.g., array, list, or tree).
   * **Equality**: Override `equals()` and `hashCode()` methods.
   * **Concurrency**: Decide whether thread-safety is needed.

### **Example: Fixed-Size Set**

```java
import java.util.AbstractSet;
import java.util.Iterator;
import java.util.HashSet;

public class FixedSizeSet<E> extends AbstractSet<E> {
    private final int maxSize;
    private final HashSet<E> internalSet;

    public FixedSizeSet(int maxSize) {
        this.maxSize = maxSize;
        this.internalSet = new HashSet<>();
    }

    @Override
    public boolean add(E e) {
        if (internalSet.size() >= maxSize) {
            throw new IllegalStateException("Set is full");
        }
        return internalSet.add(e);
    }

    @Override
    public boolean remove(Object o) {
        return internalSet.remove(o);
    }

    @Override
    public boolean contains(Object o) {
        return internalSet.contains(o);
    }

    @Override
    public Iterator<E> iterator() {
        return internalSet.iterator();
    }

    @Override
    public int size() {
        return internalSet.size();
    }
}
```

### **Use Case of Custom Set**

* **Fixed-Size Sets**: Ensure the number of elements does not exceed a certain limit.
* **Validation Logic**: Enforce constraints on elements being added.

