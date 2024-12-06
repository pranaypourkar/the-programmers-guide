# Vector

## **About**

`Vector` is a dynamic array class that implements the `List` interface in Java. It is part of the `java.util` package and is similar to `ArrayList`, but with a few key differences. `Vector` was introduced in the original version of Java and is considered legacy since newer classes like `ArrayList` are more commonly used due to performance reasons. However, `Vector` still provides a thread-safe, growable array implementation.

## **Features**

1. **Dynamic Sizing:** Like `ArrayList`, `Vector` resizes itself automatically as elements are added or removed.
2. **Resizable Array:** The array dynamically expands as needed, doubling its size when it runs out of space.
3. **Thread-Safety:** `Vector` is synchronized, meaning it can be safely used in multithreaded environments.
4. **Allowing Duplicates:** `Vector` allows duplicate elements, just like `ArrayList`.
5. **Legacy Class:** `Vector` was part of the original Java, whereas `ArrayList` was introduced later with better performance characteristics.
6. **Index-Based Access:** Elements in a `Vector` can be accessed by index like an array.
7. **Growth Factor:** By default, `Vector` grows by doubling its size whenever it runs out of space, but this can be customized.
8. **Element Access:** It allows retrieving elements from any position using `get()` and modifying them with `set()`.
9. **Thread-Safe Operations:** Since it is synchronized, operations like `add()`, `remove()`, and `get()` are thread-safe.
10. **Bulk Operations:** It provides methods for performing bulk operations such as `addAll()`, `removeAll()`, and `retainAll()`.

## **Key Methods**

* `add(E e)`: Adds an element to the end of the vector.
* `remove(Object o)`: Removes the first occurrence of the specified element.
* `get(int index)`: Returns the element at the specified index.
* `set(int index, E element)`: Replaces the element at the specified index with a new element.
* `size()`: Returns the number of elements in the vector.
* `clear()`: Removes all elements from the vector.
* `isEmpty()`: Returns `true` if the vector is empty.
* `capacity()`: Returns the current capacity (size of the underlying array) of the vector.
* `ensureCapacity(int minCapacity)`: Ensures the vector can hold at least the specified number of elements without resizing.
* `trimToSize()`: Reduces the capacity of the vector to the current size.
* `removeAllElements()`: Removes all elements from the vector.
* `clone()`: Creates a shallow copy of the vector.
* `contains(Object o)`: Returns `true` if the vector contains the specified element.

## Big(O) for Operations on Vector

<table data-header-hidden data-full-width="true"><thead><tr><th width="430"></th><th width="166"></th><th></th></tr></thead><tbody><tr><td><strong>Operation</strong></td><td><strong>Time Complexity</strong></td><td><strong>Explanation</strong></td></tr><tr><td><strong>Access by Index (<code>get()</code> or <code>set()</code>)</strong></td><td><strong>O(1)</strong></td><td>Direct access to an element by index, as <code>Vector</code> uses a dynamic array internally.</td></tr><tr><td><strong>Insert at End (<code>add(element)</code>)</strong></td><td><strong>O(1)</strong>(amortized)</td><td>Adding at the end is efficient unless the array needs to be resized, in which case it’s O(n).</td></tr><tr><td><strong>Insert at Specific Index (<code>add(index, element)</code>)</strong></td><td><strong>O(n)</strong></td><td>Requires shifting all elements after the insertion point.</td></tr><tr><td><strong>Remove by Index (<code>remove(index)</code>)</strong></td><td><strong>O(n)</strong></td><td>Elements after the removed index must be shifted.</td></tr><tr><td><strong>Remove by Value (<code>remove(element)</code>)</strong></td><td><strong>O(n)</strong></td><td>Requires scanning the entire <code>Vector</code> to find the element, and then shifting elements.</td></tr><tr><td><strong>Search by Value (<code>indexOf()</code> or <code>contains()</code>)</strong></td><td><strong>O(n)</strong></td><td>Requires a linear scan of the <code>Vector</code> to find the element.</td></tr><tr><td><strong>Iteration (e.g., using <code>for-each</code> loop)</strong></td><td><strong>O(n)</strong></td><td>Traverses all elements in the <code>Vector</code>.</td></tr><tr><td><strong>Resize (when capacity is exceeded)</strong></td><td><strong>O(n)</strong></td><td>Involves allocating a new array, copying old elements, and adding the new element.</td></tr></tbody></table>

## Examples

### Basic Operation

```java
import java.util.Vector;

public class VectorExample {
    public static void main(String[] args) {
        // Creating a Vector of Strings
        Vector<String> vector = new Vector<>();

        // Add elements to the vector
        vector.add("Apple");
        vector.add("Banana");
        vector.add("Cherry");
        vector.add("Date");
        System.out.println("Vector after add operations: " + vector); // Vector after add operations: [Apple, Banana, Cherry, Date]

        // Get an element by index
        System.out.println("Element at index 2: " + vector.get(2)); // Element at index 2: Cherry

        // Set an element at a specific index
        vector.set(2, "Grape");
        System.out.println("Vector after setting index 2: " + vector); // Vector after setting index 2: [Apple, Banana, Grape, Date]

        // Remove an element
        vector.remove("Banana");
        System.out.println("Vector after removing Banana: " + vector); // Vector after removing Banana: [Apple, Grape, Date]

        // Size of the vector
        System.out.println("Size of vector: " + vector.size()); // Size of vector: 3

        // Check if the vector contains an element
        System.out.println("Does the vector contain 'Apple'? " + vector.contains("Apple")); // Does the vector contain 'Apple'? true

        // Capacity of the vector
        System.out.println("Capacity of the vector: " + vector.capacity()); // Capacity of the vector: 10

        // Ensure capacity
        vector.ensureCapacity(10);  // Ensure at least 10 elements can be added
        System.out.println("Capacity after ensuring capacity: " + vector.capacity()); // Capacity after ensuring capacity: 10

        // Trim the size of the vector to its current size
        vector.trimToSize();
        System.out.println("Capacity after trimming: " + vector.capacity()); // Capacity after trimming: 3

        // Clone the vector
        Vector<String> clonedVector = (Vector<String>) vector.clone();
        System.out.println("Cloned Vector: " + clonedVector); // Cloned Vector: [Apple, Grape, Date]

        // Check if the vector is empty
        System.out.println("Is the vector empty? " + vector.isEmpty()); // Is the vector empty? false

        // Clear the vector
        vector.clear();
        System.out.println("Vector after clear: " + vector); // Vector after clear: []
    }
}
```

### **Using Generics with Vector**

We can create a `Vector` for any type of data, ensuring type safety.

```java
Vector<Integer> numberVector = new Vector<>();
numberVector.add(10);
numberVector.add(20);
System.out.println("Sum of vector: " + numberVector.stream().mapToInt(Integer::intValue).sum());
```

### **Custom Objects in Vector**

Like `ArrayList`, We can store custom objects in `Vector`.

```java
class Book {
    String title;
    double price;

    public Book(String title, double price) {
        this.title = title;
        this.price = price;
    }

    @Override
    public String toString() {
        return "Book{title='" + title + "', price=" + price + "}";
    }
}

Vector<Book> bookVector = new Vector<>();
bookVector.add(new Book("Java Basics", 19.99));
bookVector.add(new Book("Advanced Java", 29.99));

System.out.println("Books in vector: " + bookVector);
```

### **Thread-Safety in Vector (Synchronized)**

Since `Vector` is synchronized, it can be used safely in multithreaded environments, but newer alternatives like `CopyOnWriteArrayList` are preferred due to better performance.

```java
Vector<Integer> threadSafeVector = new Vector<>();
synchronized (threadSafeVector) {
    threadSafeVector.add(1);
    threadSafeVector.add(2);
}
```

## **Why Vector is Not Preferred in Modern Java ?**

1. **Synchronization Overhead:** The synchronization in `Vector` can be costly in performance, especially when it’s not needed. For concurrent access, `CopyOnWriteArrayList` or other concurrent collections are preferred.
2. **Better Alternatives:** `ArrayList` provides similar functionality without the overhead of synchronization and is generally faster.
3. **Legacy Class:** `Vector` is part of the original Java versions, and while still supported, it has been superseded by newer, more efficient collections.

## **When to Use Vector ?**

* **Thread-Safe Operations:** If you need automatic synchronization, you can use `Vector`, but better alternatives exist like `CopyOnWriteArrayList` or `ArrayBlockingQueue`.
* **Legacy Code:** In some cases, legacy systems might still use `Vector` and refactoring to a more modern collection like `ArrayList` may not be immediately feasible.
