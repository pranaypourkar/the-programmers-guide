# List

## **About**

The `List` interface in Java is a part of the **java.util** package and provides an ordered collection (sequence) of elements. It is a parent interface implemented by classes like `ArrayList`, `LinkedList`, and `Vector`.

* **Interface**: `List` is an interface, meaning it cannot be instantiated directly. It defines methods that must be implemented by its concrete classes.
* **Order**: Elements in a `List` maintain their insertion order.
* **Allows Duplicates**: A `List` can contain duplicate elements.
* **Generics Support**: `List` can be declared with generics to enforce type safety at compile time.
* **Index-Based Access**: Provides access to elements using zero-based indexing.

## **Features**

1. **Ordered Collection**: Retains the order of insertion.
2. **Index-Based Access**: Retrieve, add, or remove elements by index.
3. **Allows Null**: Accepts `null` as an element (implementation-dependent).
4. **Generics**: Allows type-safe collections:

```
List<String> names = new ArrayList<>();
```

5. **Polymorphism**: Use `List` as the reference type for flexibility:

```
List<Integer> numbers = new LinkedList<>();
```

6. **Iterators**: Supports iterators for traversal.
7. **Thread Safety**: Use synchronized versions like `Collections.synchronizedList()` for thread-safe operations.
8. **Stream API Compatibility**: Efficient bulk operations like filtering and mapping.
9. **Immutable List**: Use `List.of()` to create immutable lists.

## **Key Methods**

* `add(E e)`: Adds an element.
* `get(int index)`: Retrieves an element by index.
* `set(int index, E element)`: Replaces the element at a specified position.
* `remove(int index)` / `remove(Object o)`: Removes an element.
* `size()`: Returns the number of elements.
* `isEmpty()`: Checks if the list is empty.
* `contains(Object o)`: Checks if the list contains a specified element.
* `clear()`: Removes all elements.
* `addAll(Collection<? extends E> c)`: Adds all elements of a collection.
* `retainAll(Collection<?> c)`: Retains only elements present in the specified collection.
* `subList(int fromIndex, int toIndex)`: Returns a portion of the list.
* `toArray()`: Converts the list into an array.

## **`List` Implementations**

### **1. ArrayList**

* **Description**: A resizable array-backed implementation of `List`.
* **Key Features**:
  * Allows fast random access to elements (`O(1)` access by index).
  * Slower when frequently inserting or deleting elements in the middle (`O(n)` for add/remove).
  * Not synchronized (not thread-safe).
* **Use Case**: When frequent random access is required and insertions/deletions are infrequent.
* **Class**: `java.util.ArrayList`

```java
import java.util.ArrayList;

public class ArrayListExample {
    public static void main(String[] args) {
        ArrayList<Integer> list = new ArrayList<>();
        list.add(10);
        list.add(20);
        list.add(30);
        
        System.out.println("ArrayList: " + list);
        System.out.println("Get element at index 1: " + list.get(1));
        list.remove(Integer.valueOf(20));
        System.out.println("After removing 20: " + list);
    }
}
```

### **2. LinkedList**

* **Description**: A doubly-linked list implementation of `List`.
* **Key Features**:
  * Efficient for frequent insertions and deletions (`O(1)` for add/remove at ends).
  * Slower for random access as it requires traversal (`O(n)` access by index).
  * Implements both `List` and `Deque` (can be used as a queue or stack).
* **Use Case**: When frequent insertions and deletions are required in the middle of the list.
* **Class**: `java.util.LinkedList`

```java
import java.util.LinkedList;

public class LinkedListExample {
    public static void main(String[] args) {
        LinkedList<String> list = new LinkedList<>();
        list.add("Alice");
        list.addFirst("Bob");
        list.addLast("Charlie");
        
        System.out.println("LinkedList: " + list);
        System.out.println("First Element: " + list.getFirst());
        System.out.println("Last Element: " + list.getLast());
        
        list.removeFirst();
        System.out.println("After removing first element: " + list);
    }
}
```

### **3. Vector**

* **Description**: A synchronized, thread-safe version of `ArrayList`.
* **Key Features**:
  * Automatically grows and shrinks in size as elements are added or removed.
  * Synchronized for thread-safe operations, but slower due to overhead.
  * Legacy class, replaced by `ArrayList` for non-thread-safe use cases and `CopyOnWriteArrayList` for thread-safe use cases.
* **Use Case**: When thread-safe operations are needed and alternative solutions are unavailable.
* **Class**: `java.util.Vector`

```java
import java.util.Vector;

public class VectorExample {
    public static void main(String[] args) {
        Vector<Double> vector = new Vector<>();
        vector.add(1.1);
        vector.add(2.2);
        vector.add(3.3);
        
        System.out.println("Vector: " + vector);
        vector.remove(1);
        System.out.println("After removing element at index 1: " + vector);
        
        System.out.println("Capacity: " + vector.capacity());
    }
}
```

### **4. Stack**

* **Description**: A last-in-first-out (LIFO) stack implementation based on `Vector`.
* **Key Features**:
  * Extends `Vector` and adds stack-specific methods like `push`, `pop`, and `peek`.
  * Inherits synchronization from `Vector`.
  * Considered a legacy class; use `Deque` implementations like `ArrayDeque` instead.
* **Use Case**: For LIFO (stack) behavior in older Java versions.
* **Class**: `java.util.Stack`

```java
import java.util.Stack;

public class StackExample {
    public static void main(String[] args) {
        Stack<Integer> stack = new Stack<>();
        stack.push(10);
        stack.push(20);
        stack.push(30);
        
        System.out.println("Stack: " + stack);
        System.out.println("Top element: " + stack.peek());
        stack.pop();
        System.out.println("After popping: " + stack);
    }
}
```

### **5. CopyOnWriteArrayList (Thread-Safe Implementation)**

* **Description**: A thread-safe version of `ArrayList` where all write operations (add/remove) create a new copy of the array.
* **Key Features**:
  * Iterators do not throw `ConcurrentModificationException`.
  * High overhead for write operations but efficient for read-heavy scenarios.
* **Use Case**: When multiple threads mostly read data and modifications are infrequent.
* **Class**: `java.util.concurrent.CopyOnWriteArrayList`

```java
import java.util.concurrent.CopyOnWriteArrayList;

public class CopyOnWriteArrayListExample {
    public static void main(String[] args) {
        CopyOnWriteArrayList<String> list = new CopyOnWriteArrayList<>();
        list.add("A");
        list.add("B");
        list.add("C");

        System.out.println("CopyOnWriteArrayList: " + list);
        for (String s : list) {
            System.out.println("Iterating: " + s);
            // Safe to modify during iteration
            list.add("D");
        }
        System.out.println("After modification: " + list);
    }
}
```

### **6. SynchronizedList (Thread-Safe Implementation)**

* **Description**: A thread-safe wrapper around any `List`, created using `Collections.synchronizedList()`.
* **Key Features**:
  * Provides synchronized access to all `List` operations.
  * External synchronization is required for iteration to avoid `ConcurrentModificationException`.
* **Use Case**: When an existing `List` needs to be made thread-safe.
* **Class**: `java.util.Collections`.

```java
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class SynchronizedListExample {
    public static void main(String[] args) {
        List<String> list = Collections.synchronizedList(new ArrayList<>());
        list.add("X");
        list.add("Y");
        
        synchronized (list) {
            for (String s : list) {
                System.out.println("Iterating: " + s);
            }
        }
    }
}
```

### **6. Immutable List (Immutable Implementations)**

* **Description**: Provides an unmodifiable, immutable list implementation.
* **Key Features**:
  * Created using `List.of(...)` or `Collections.unmodifiableList(...)`.
  * Any attempt to modify the list will throw `UnsupportedOperationException`.
* **Use Case**: When we want a list that cannot be modified.
* **Class**: `java.util.List` (created using factory methods like `List.of()` or `Collections.unmodifiableList()`)

```java
import java.util.List;

public class ImmutableListExample {
    public static void main(String[] args) {
        List<String> list = List.of("One", "Two", "Three");
        System.out.println("Immutable List: " + list);
        
        // The following line would throw UnsupportedOperationException
        // list.add("Four");
    }
}
```

## **Custom Implementations of `List`**

### **1. AbstractList**

* **Description**: A skeletal implementation of the `List` interface for creating custom `List` implementations.
* **Key Features**:
  * Reduces the effort required to implement a custom `List`.
  * Requires only the implementation of `get` and `size`.
* **Use Case**: When creating a custom `List` implementation.
* **Class**: `java.util.AbstractList`.

```java
import java.util.AbstractList;

class RangeList extends AbstractList<Integer> {
    private final int start;
    private final int end;

    public RangeList(int start, int end) {
        if (start > end) {
            throw new IllegalArgumentException("Start must be less than or equal to end.");
        }
        this.start = start;
        this.end = end;
    }

    @Override
    public Integer get(int index) {
        if (index < 0 || index >= size()) {
            throw new IndexOutOfBoundsException("Index out of bounds: " + index);
        }
        return start + index;
    }

    @Override
    public int size() {
        return end - start + 1;
    }
}

public class AbstractListExample {
    public static void main(String[] args) {
        RangeList rangeList = new RangeList(5, 10);
        System.out.println("Range List: " + rangeList);

        // Access elements
        System.out.println("Element at index 2: " + rangeList.get(2)); // Output: 7

        // Iterating over elements
        for (Integer num : rangeList) {
            System.out.print(num + " "); // Output: 5 6 7 8 9 10
        }
    }
}
```

### **2. AbstractSequentialList**

* **Description**: A skeletal implementation of the `List` interface for sequential access lists.
* **Key Features**:
  * Designed for data structures where elements are accessed sequentially (e.g., linked lists).
  * Requires implementing `listIterator` and `size`.
* **Use Case**: When creating a sequential access list.
* **Class**: `java.util.AbstractSequentialList`.

```java
import java.util.AbstractSequentialList;
import java.util.ListIterator;
import java.util.NoSuchElementException;

class DoublyLinkedList<E> extends AbstractSequentialList<E> {
    private static class Node<E> {
        E data;
        Node<E> next;
        Node<E> prev;

        Node(E data) {
            this.data = data;
        }
    }

    private Node<E> head;
    private Node<E> tail;
    private int size = 0;

    @Override
    public ListIterator<E> listIterator(int index) {
        if (index < 0 || index > size) {
            throw new IndexOutOfBoundsException("Index: " + index);
        }

        return new ListIterator<E>() {
            private Node<E> current = (index == size) ? null : getNode(index);
            private int currentIndex = index;

            @Override
            public boolean hasNext() {
                return current != null;
            }

            @Override
            public E next() {
                if (!hasNext()) {
                    throw new NoSuchElementException();
                }
                E data = current.data;
                current = current.next;
                currentIndex++;
                return data;
            }

            @Override
            public boolean hasPrevious() {
                return currentIndex > 0;
            }

            @Override
            public E previous() {
                if (!hasPrevious()) {
                    throw new NoSuchElementException();
                }
                current = (current == null) ? tail : current.prev;
                currentIndex--;
                return current.data;
            }

            @Override
            public int nextIndex() {
                return currentIndex;
            }

            @Override
            public int previousIndex() {
                return currentIndex - 1;
            }

            @Override
            public void remove() {
                throw new UnsupportedOperationException("Remove is not supported.");
            }

            @Override
            public void set(E e) {
                if (current == null) {
                    throw new IllegalStateException();
                }
                current.data = e;
            }

            @Override
            public void add(E e) {
                throw new UnsupportedOperationException("Add is not supported.");
            }
        };
    }

    private Node<E> getNode(int index) {
        Node<E> node = head;
        for (int i = 0; i < index; i++) {
            node = node.next;
        }
        return node;
    }

    @Override
    public int size() {
        return size;
    }

    public void addLast(E element) {
        Node<E> newNode = new Node<>(element);
        if (tail == null) {
            head = tail = newNode;
        } else {
            tail.next = newNode;
            newNode.prev = tail;
            tail = newNode;
        }
        size++;
    }
}

public class AbstractSequentialListExample {
    public static void main(String[] args) {
        DoublyLinkedList<String> list = new DoublyLinkedList<>();
        list.addLast("Alice");
        list.addLast("Bob");
        list.addLast("Charlie");

        System.out.println("DoublyLinkedList size: " + list.size());
        
        // Iterating forwards
        ListIterator<String> iterator = list.listIterator(0);
        System.out.println("Forward Iteration:");
        while (iterator.hasNext()) {
            System.out.println(iterator.next());
        }

        // Iterating backwards
        System.out.println("Backward Iteration:");
        while (iterator.hasPrevious()) {
            System.out.println(iterator.previous());
        }
    }
}
```

