# ArrayDeque

## **About**

**ArrayDeque**, part of the `java.util` package, is a **resizable, double-ended queue** that uses a **dynamic array** internally to store its elements. It is one of the most efficient implementations of the `Deque` interface and is a popular choice for scenarios requiring stack or queue functionality. Unlike `LinkedList`, it avoids the overhead of maintaining node references.

## **Features**

1. **Resizable Array:** Automatically resizes its capacity when the internal array becomes full.
2. **Double-Ended:** Supports element insertion and removal at both ends.
3. **Efficient Operations:** Provides O(1) time complexity for most operations, including insertion and removal at either end.
4. **No Capacity Restrictions:** By default, it grows dynamically as needed (except when manually constrained by the user).
5. **Null Elements Not Allowed:** Helps prevent ambiguities during `null` checks in `poll` and `peek` methods.
6. **Better than Stack/LinkedList:** Faster and more efficient alternative for stack (`push` and `pop`) and queue implementations.
7. **High Cache Performance:** Operations are faster due to contiguous memory allocation, which benefits CPU caching.
8. **Thread-Unsafety:** Not thread-safe, but lightweight and faster in single-threaded applications. For concurrent usage, external synchronization or `ConcurrentLinkedDeque` is preferred.

## **Key Methods**

<table data-header-hidden data-full-width="true"><thead><tr><th width="177"></th><th width="233"></th><th></th></tr></thead><tbody><tr><td><strong>Method Type</strong></td><td><strong>Method</strong></td><td><strong>Description</strong></td></tr><tr><td><strong>Add Operations</strong></td><td><code>addFirst(E e)</code></td><td>Adds an element to the front of the deque. Throws exception if capacity is constrained.</td></tr><tr><td></td><td><code>addLast(E e)</code></td><td>Adds an element to the end of the deque. Throws exception if capacity is constrained.</td></tr><tr><td></td><td><code>offerFirst(E e)</code></td><td>Adds an element at the front without throwing exceptions.</td></tr><tr><td></td><td><code>offerLast(E e)</code></td><td>Adds an element at the end without throwing exceptions.</td></tr><tr><td><strong>Remove Operations</strong></td><td><code>removeFirst()</code></td><td>Removes and returns the first element. Throws an exception if the deque is empty.</td></tr><tr><td></td><td><code>removeLast()</code></td><td>Removes and returns the last element. Throws an exception if the deque is empty.</td></tr><tr><td></td><td><code>pollFirst()</code></td><td>Removes and returns the first element or <code>null</code> if the deque is empty.</td></tr><tr><td></td><td><code>pollLast()</code></td><td>Removes and returns the last element or <code>null</code> if the deque is empty.</td></tr><tr><td><strong>Access Operations</strong></td><td><code>getFirst()</code></td><td>Retrieves the first element without removing it.</td></tr><tr><td></td><td><code>getLast()</code></td><td>Retrieves the last element without removing it.</td></tr><tr><td></td><td><code>peekFirst()</code></td><td>Retrieves the first element without removal or <code>null</code> if the deque is empty.</td></tr><tr><td></td><td><code>peekLast()</code></td><td>Retrieves the last element without removal or <code>null</code> if the deque is empty.</td></tr><tr><td><strong>Stack Operations</strong></td><td><code>push(E e)</code></td><td>Pushes an element onto the stack (alias for <code>addFirst</code>).</td></tr><tr><td></td><td><code>pop()</code></td><td>Removes and returns the top element of the stack (alias for <code>removeFirst</code>).</td></tr><tr><td><strong>Iterator</strong></td><td><code>iterator()</code></td><td>Returns an iterator over elements in front-to-back order.</td></tr><tr><td></td><td><code>descendingIterator()</code></td><td>Returns an iterator over elements in reverse order.</td></tr></tbody></table>

## **Big O Time Complexity for ArrayDeque**

<table data-header-hidden data-full-width="true"><thead><tr><th></th><th width="168"></th><th></th></tr></thead><tbody><tr><td><strong>Operation</strong></td><td><strong>Time Complexity</strong></td><td><strong>Details</strong></td></tr><tr><td><strong>Insert at Head (addFirst)</strong></td><td>O(1)</td><td>Efficient insertion at the front due to circular buffer design.</td></tr><tr><td><strong>Insert at Tail (addLast)</strong></td><td>O(1)</td><td>Efficient insertion at the rear due to dynamic array resizing.</td></tr><tr><td><strong>Remove from Head (pollFirst)</strong></td><td>O(1)</td><td>Removes element from the front with constant time complexity.</td></tr><tr><td><strong>Remove from Tail (pollLast)</strong></td><td>O(1)</td><td>Removes element from the rear with constant time complexity.</td></tr><tr><td><strong>Peek at Head (peekFirst)</strong></td><td>O(1)</td><td>Accessing the front element without removing it.</td></tr><tr><td><strong>Peek at Tail (peekLast)</strong></td><td>O(1)</td><td>Accessing the rear element without removing it.</td></tr><tr><td><strong>Search (contains)</strong></td><td>O(n)</td><td>Linear scan for searching an element in the deque.</td></tr><tr><td><strong>Resize Operation</strong></td><td>O(n)</td><td>Occurs when the internal array exceeds capacity, rare but costly.</td></tr></tbody></table>

## Example

### Basic Operation

```java
import java.util.ArrayDeque;
import java.util.Deque;

public class ArrayDequeExample {
    public static void main(String[] args) {
        // Create an ArrayDeque
        Deque<String> deque = new ArrayDeque<>();

        // Add elements to both ends
        deque.addFirst("Alice");
        deque.addLast("Bob");
        System.out.println("Deque after additions: " + deque);

        // Access elements without removing
        System.out.println("First element (peekFirst): " + deque.peekFirst());
        System.out.println("Last element (peekLast): " + deque.peekLast());

        // Remove elements from both ends
        System.out.println("Removed first (pollFirst): " + deque.pollFirst());
        System.out.println("Removed last (pollLast): " + deque.pollLast());
        System.out.println("Deque after removals: " + deque);

        // Stack operations
        deque.push("Charlie");
        deque.push("David");
        System.out.println("Deque as stack: " + deque);
        System.out.println("Popped from stack: " + deque.pop());

        // Queue operations
        deque.offerFirst("Eve");
        deque.offerLast("Frank");
        System.out.println("Deque as queue: " + deque);

        // Iteration
        System.out.print("Iterating through deque: ");
        for (String name : deque) {
            System.out.print(name + " ");
        }

        // Reverse iteration
        System.out.print("\nReverse iteration: ");
        for (String name : deque.descendingIterator()) {
            System.out.print(name + " ");
        }
    }
}
```

### **Custom Objects in ArrayDeque**

```java
import java.util.ArrayDeque;
import java.util.Deque;

class Task {
    String name;
    int priority;

    Task(String name, int priority) {
        this.name = name;
        this.priority = priority;
    }

    @Override
    public String toString() {
        return "Task{name='" + name + "', priority=" + priority + '}';
    }
}

public class CustomObjectDeque {
    public static void main(String[] args) {
        Deque<Task> taskDeque = new ArrayDeque<>();

        // Adding custom objects
        taskDeque.addLast(new Task("Low Priority Task", 1));
        taskDeque.addFirst(new Task("High Priority Task", 3));
        System.out.println("Tasks: " + taskDeque);

        // Processing tasks
        System.out.println("Processing: " + taskDeque.pollFirst());
        System.out.println("Processing: " + taskDeque.pollLast());
    }
}
```

## **When to Use ArrayDeque ?**

1. **Double-Ended Operations:** Ideal when you need fast operations at both ends.
2. **As a Replacement for Stack:** Use instead of `Stack` for a modern implementation.
3. **Sliding Window Problems:** Great for maintaining dynamic windows in algorithmic problems.
4. **Thread-Safe Needs:** Use `ConcurrentLinkedDeque` if thread safety is a concern.

