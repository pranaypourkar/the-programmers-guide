# HashSet

## **About**

`HashSet` is a part of the Java Collections Framework and is implemented using a `HashMap` internally. It represents a collection of unique elements and does not allow duplicate entries. `HashSet` relies on the hashing mechanism for storing and retrieving elements efficiently.

## **Features**

1. **No Duplicates**: Ensures all elements are unique. Duplicate entries are ignored.
2. **Null Element**: Allows a single `null` element.
3. **Unordered**: Does not maintain insertion order; the order is determined by the hash table.
4. **High Performance**: Provides constant-time performance for basic operations like add, remove, and contains (O(1)), assuming the hash function disperses elements properly.
5. **Not Thread-Safe**: `HashSet` is not synchronized. For thread safety, you need to use `Collections.synchronizedSet()` or consider `ConcurrentHashSet` alternatives.
6. **Backed by `HashMap`**: Internally uses a `HashMap` with the elements as keys and a dummy value.

## **Internal Working**

### **1. HashMap as the Backbone**

* `HashSet` internally uses a `HashMap` to store its elements.
* Each element in the `HashSet` is stored as a key in the underlying `HashMap`, and the value is a constant dummy object (`PRESENT`).

### **2. Adding Elements**

* When an element is added using `add(E e)`, `HashSet` calls the `put()` method of the underlying `HashMap`.
* If the key (element) already exists, it is ignored, ensuring uniqueness.

### **3. Retrieving Elements**

* The `contains(Object o)` method uses the `containsKey()` method of the `HashMap` to check if the element exists.

### **4. Hashing and Buckets**

* The `HashSet` relies on the `hashCode()` and `equals()` methods to determine the uniqueness of elements.
* Elements are distributed across buckets based on their hash values.
* Collisions are handled by storing multiple elements in a linked list or tree structure (depending on Java version).

### **5. Removing Elements**

* The `remove(Object o)` method calls the `remove()` method of the underlying `HashMap`, which removes the key-value pair corresponding to the element.

## **Key Methods**

<table data-header-hidden><thead><tr><th width="258"></th><th></th></tr></thead><tbody><tr><td><strong>Method</strong></td><td><strong>Description</strong></td></tr><tr><td><code>add(E e)</code></td><td>Adds the specified element to the set if it is not already present.</td></tr><tr><td><code>remove(Object o)</code></td><td>Removes the specified element from the set if it exists.</td></tr><tr><td><code>contains(Object o)</code></td><td>Checks if the set contains the specified element.</td></tr><tr><td><code>size()</code></td><td>Returns the number of elements in the set.</td></tr><tr><td><code>clear()</code></td><td>Removes all elements from the set.</td></tr><tr><td><code>isEmpty()</code></td><td>Checks if the set is empty.</td></tr><tr><td><code>iterator()</code></td><td>Returns an iterator over the elements in the set.</td></tr><tr><td><code>toArray()</code></td><td>Returns an array containing all the elements in the set.</td></tr></tbody></table>

## **Big-O for Operations**

| **Operation** | **Time Complexity** |
| ------------- | ------------------- |
| **Add**       | O(1) (average case) |
| **Remove**    | O(1) (average case) |
| **Contains**  | O(1) (average case) |
| **Iteration** | O(n)                |

## **Limitations**

1. **No Ordering**: The iteration order is not guaranteed.
2. **Not Thread-Safe**: Requires external synchronization for concurrent access.
3. **Dependent on Hashing**: Poorly implemented `hashCode()` and `equals()` can lead to performance degradation.
4. **Memory Overhead**: Requires extra memory due to the underlying `HashMap`.

## **Real-World Usage**

1. **Unique Collections**: Maintaining a collection of unique elements, such as a list of unique IDs.
2. **Membership Testing**: Checking whether an element exists in a collection.
3. **Set Operations**: Performing mathematical set operations like union, intersection, and difference.

## **Examples**

### **1. Basic Operations**

```java
import java.util.HashSet;

public class HashSetExample {
    public static void main(String[] args) {
        HashSet<String> set = new HashSet<>();

        // Adding elements
        set.add("Apple");
        set.add("Banana");
        set.add("Cherry");
        set.add("Apple"); // Duplicate, ignored
        System.out.println(set); // Output: [Banana, Apple, Cherry] (order may vary)

        // Checking for an element
        System.out.println(set.contains("Banana")); // Output: true

        // Removing an element
        set.remove("Banana");
        System.out.println(set); // Output: [Apple, Cherry] (order may vary)

        // Checking size
        System.out.println(set.size()); // Output: 2
    }
}
```

### **2. Iteration**

```java
import java.util.HashSet;

public class IterationExample {
    public static void main(String[] args) {
        HashSet<Integer> numbers = new HashSet<>();

        numbers.add(10);
        numbers.add(20);
        numbers.add(30);

        // Using for-each loop
        for (Integer number : numbers) {
            System.out.println(number);
        }
        // Output:
        // 10
        // 20
        // 30 (order may vary)
    }
}
```

### **3. Set Operations**

```java
import java.util.HashSet;

public class SetOperations {
    public static void main(String[] args) {
        HashSet<String> set1 = new HashSet<>();
        set1.add("A");
        set1.add("B");
        set1.add("C");

        HashSet<String> set2 = new HashSet<>();
        set2.add("B");
        set2.add("C");
        set2.add("D");

        // Union
        HashSet<String> union = new HashSet<>(set1);
        union.addAll(set2);
        System.out.println("Union: " + union); // Output: Union: [A, B, C, D]

        // Intersection
        HashSet<String> intersection = new HashSet<>(set1);
        intersection.retainAll(set2);
        System.out.println("Intersection: " + intersection); // Output: Intersection: [B, C]

        // Difference
        HashSet<String> difference = new HashSet<>(set1);
        difference.removeAll(set2);
        System.out.println("Difference: " + difference); // Output: Difference: [A]
    }
}
```



