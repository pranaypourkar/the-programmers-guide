# LinkedList - TBU

## About

The `LinkedList` class in Java is a part of the `java.util` package and implements both the `List` and `Deque` interfaces. It is a doubly-linked list, meaning each node in the list contains three elements:

* **Data**: The value stored in the node.
* **Reference to the next node**: Pointer to the next element in the list.
* **Reference to the previous node**: Pointer to the previous element in the list.

Since it implements the `Deque` interface, `LinkedList` can function as a **FIFO (First-In-First-Out) queue** or **LIFO (Last-In-First-Out) stack**.

## **Features**

1. **Dynamic Size**: Unlike arrays, `LinkedList` can dynamically grow and shrink as elements are added or removed.
2. **Efficient Insertions/Deletions**: Adding or removing elements from the beginning or middle is efficient compared to `ArrayList`.
3. **Implements Multiple Interfaces**:
   * `List`: Allows indexed access and supports duplicate elements.
   * `Deque`: Enables usage as a stack, queue, or deque.
4. **Non-Synchronized**: Not thread-safe by default but can be synchronized using `Collections.synchronizedList`.
5. **Allows Nulls**: Null elements are allowed as valid entries.
6. **Iterators**: Provides fail-fast iterators that throw `ConcurrentModificationException` if the list is structurally modified while iterating.

## **Key Methods**

Here are some of the commonly used methods in `LinkedList` and their descriptions:

<table data-full-width="true"><thead><tr><th width="360">Method</th><th>Description</th></tr></thead><tbody><tr><td><code>add(E e)</code></td><td>Appends the specified element to the end of the list.</td></tr><tr><td><code>add(int index, E element)</code></td><td>Inserts the element at the specified position in the list.</td></tr><tr><td><code>addFirst(E e)</code> / <code>offerFirst(E e)</code></td><td>Adds the element at the beginning of the list.</td></tr><tr><td><code>addLast(E e)</code> / <code>offerLast(E e)</code></td><td>Adds the element at the end of the list.</td></tr><tr><td><code>remove()</code></td><td>Removes the first element (head) of the list.</td></tr><tr><td><code>removeFirst()</code> / <code>pollFirst()</code></td><td>Removes and returns the first element.</td></tr><tr><td><code>removeLast()</code> / <code>pollLast()</code></td><td>Removes and returns the last element.</td></tr><tr><td><code>get(int index)</code></td><td>Returns the element at the specified position.</td></tr><tr><td><code>getFirst()</code> / <code>peekFirst()</code></td><td>Retrieves the first element without removing it.</td></tr><tr><td><code>getLast()</code> / <code>peekLast()</code></td><td>Retrieves the last element without removing it.</td></tr><tr><td><code>size()</code></td><td>Returns the number of elements in the list.</td></tr><tr><td><code>contains(Object o)</code></td><td>Returns <code>true</code> if the list contains the specified element.</td></tr><tr><td><code>indexOf(Object o)</code> / <code>lastIndexOf(Object o)</code></td><td>Returns the index of the first/last occurrence of the specified element.</td></tr><tr><td><code>clear()</code></td><td>Removes all elements from the list.</td></tr><tr><td><code>descendingIterator()</code></td><td>Returns an iterator that iterates in reverse order.</td></tr></tbody></table>

## **Big O Complexity for Operations**

<table data-full-width="true"><thead><tr><th width="230">Operation</th><th width="138">Complexity</th><th>Explanation</th></tr></thead><tbody><tr><td>Access (by index)</td><td>O(n)</td><td>Traverses the list from the beginning or end, whichever is closer to the index.</td></tr><tr><td>Insertion (at head/tail)</td><td>O(1)</td><td>Adding elements at the start or end is constant time due to direct pointer manipulation.</td></tr><tr><td>Insertion (at index)</td><td>O(n)</td><td>Requires traversal to the index, then updates pointers.</td></tr><tr><td>Deletion (head/tail)</td><td>O(1)</td><td>Removing the first or last element is constant time.</td></tr><tr><td>Deletion (at index)</td><td>O(n)</td><td>Requires traversal to the index, then updates pointers.</td></tr><tr><td>Search</td><td>O(n)</td><td>Needs to traverse the list to find the element.</td></tr></tbody></table>

## **Examples**

### **1. Basic Usage**

```java
import java.util.LinkedList;

public class LinkedListExample {
    public static void main(String[] args) {
        LinkedList<String> list = new LinkedList<>();

        // Adding elements
        list.add("Alice");
        list.add("Bob");
        list.add("Charlie");
        System.out.println(list); // Output: [Alice, Bob, Charlie]

        // Adding at specific positions
        list.addFirst("Zara");
        list.addLast("Daniel");
        System.out.println(list); // Output: [Zara, Alice, Bob, Charlie, Daniel]

        // Accessing elements
        System.out.println("First: " + list.getFirst()); // Output: First: Zara
        System.out.println("Last: " + list.getLast());   // Output: Last: Daniel
        System.out.println("Index 2: " + list.get(2));   // Output: Index 2: Bob

        // Removing elements
        list.remove(); // Removes the first element
        System.out.println(list); // Output: [Alice, Bob, Charlie, Daniel]

        list.removeLast(); // Removes the last element
        System.out.println(list); // Output: [Alice, Bob, Charlie]
    }
}
```

### **2. Queue Operations**

```java
import java.util.LinkedList;
import java.util.Queue;

public class QueueExample {
    public static void main(String[] args) {
        Queue<Integer> queue = new LinkedList<>();

        queue.offer(10);
        queue.offer(20);
        queue.offer(30);
        System.out.println(queue); // Output: [10, 20, 30]

        System.out.println("Peek: " + queue.peek()); // Output: Peek: 10
        System.out.println("Poll: " + queue.poll()); // Output: Poll: 10
        System.out.println(queue); // Output: [20, 30]
    }
}
```

### **3. Stack Operations**

```java
import java.util.LinkedList;

public class StackExample {
    public static void main(String[] args) {
        LinkedList<Integer> stack = new LinkedList<>();

        stack.push(5); // Push onto stack
        stack.push(10);
        stack.push(15);
        System.out.println(stack); // Output: [15, 10, 5]

        System.out.println("Pop: " + stack.pop()); // Output: Pop: 15
        System.out.println(stack); // Output: [10, 5]
    }
}
```

### **4. Converting to Array**

```java
import java.util.LinkedList;

public class ArrayConversion {
    public static void main(String[] args) {
        LinkedList<String> list = new LinkedList<>();
        list.add("Red");
        list.add("Green");
        list.add("Blue");

        String[] array = list.toArray(new String[0]);
        for (String color : array) {
            System.out.println(color); 
            // Output:
            // Red
            // Green
            // Blue
        }
    }
}
```



