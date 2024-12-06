# PriorityQueue

## **About**

A **PriorityQueue** is a queue in which each element is associated with a priority. The elements are ordered based on their priority, and elements with higher priority are dequeued before elements with lower priority. It is part of the `java.util`package and implements the `Queue` interface.

Unlike a regular queue, which operates in a FIFO (First In, First Out) order, the `PriorityQueue` provides an ordering of elements according to their priority, where the element with the highest priority is dequeued first. By default, it orders elements according to their natural ordering (via `Comparable`), but a custom comparator can also be provided for custom ordering.

## **Features**

1. **Unbounded:** `PriorityQueue` is typically unbounded, meaning it can grow dynamically as elements are added.
2. **Element Ordering:** By default, elements are ordered in natural ascending order. However, a custom comparator can be provided for custom ordering.
3. **Not Thread-Safe:** `PriorityQueue` is not thread-safe. If multiple threads will access the queue concurrently, external synchronization or using `PriorityBlockingQueue` is needed.
4. **No Null Elements:** Null elements are not allowed in `PriorityQueue`. Attempting to insert a `null` will throw a `NullPointerException`.
5. **Heap-Based Implementation:** Internally, `PriorityQueue` uses a heap (usually a binary heap) to maintain the ordering of elements.
6. **Custom Comparators:** A custom comparator can be provided to define the priority ordering. This is useful for priority queues that are not based on natural ordering.
7. **Efficient Insertions and Removals:** Insertion (`add()`) and removal (`poll()`) operations are efficient, with a time complexity of O(log n).
8. **Peeking at Head:** The `peek()` operation allows you to view the element with the highest priority without removing it from the queue.
9. **Support for Duplicates:** The `PriorityQueue` allows duplicates, unlike some other collections that may reject duplicates.

## **Key Methods**

<table data-header-hidden data-full-width="true"><thead><tr><th width="216"></th><th width="185"></th><th></th></tr></thead><tbody><tr><td><strong>Method Type</strong></td><td><strong>Method</strong></td><td><strong>Description</strong></td></tr><tr><td><strong>Add Operations</strong></td><td><code>add(E e)</code></td><td>Inserts the specified element into the priority queue.</td></tr><tr><td></td><td><code>offer(E e)</code></td><td>Inserts the specified element into the queue, returns <code>false</code> if full (rare).</td></tr><tr><td><strong>Remove Operations</strong></td><td><code>remove()</code></td><td>Removes a single instance of the specified element from the queue.</td></tr><tr><td></td><td><code>poll()</code></td><td>Retrieves and removes the highest priority element from the queue.</td></tr><tr><td><strong>Access Operations</strong></td><td><code>peek()</code></td><td>Retrieves the highest priority element without removing it.</td></tr><tr><td></td><td><code>element()</code></td><td>Retrieves the highest priority element without removing it. Throws exception if empty.</td></tr><tr><td><strong>Size and Clearing</strong></td><td><code>size()</code></td><td>Returns the number of elements in the priority queue.</td></tr><tr><td></td><td><code>clear()</code></td><td>Removes all elements from the priority queue.</td></tr><tr><td><strong>Iterators</strong></td><td><code>iterator()</code></td><td>Returns an iterator over the elements of the priority queue.</td></tr></tbody></table>

## **Big O Time Complexity for PriorityQueue Operations**

<table data-header-hidden data-full-width="true"><thead><tr><th width="232"></th><th width="257"></th><th></th></tr></thead><tbody><tr><td><strong>Operation</strong></td><td><strong>Time Complexity</strong></td><td><strong>Details</strong></td></tr><tr><td><strong>Insert (add/offer)</strong></td><td>O(log n)</td><td>Insertion in the heap structure.</td></tr><tr><td><strong>Remove (poll/remove)</strong></td><td>O(log n)</td><td>Removal of the root element (highest priority).</td></tr><tr><td><strong>Peek (peek/element)</strong></td><td>O(1)</td><td>Accessing the root element without removal.</td></tr><tr><td><strong>Search (contains)</strong></td><td>O(n)</td><td>Searching for an element requires scanning through the queue.</td></tr><tr><td><strong>Size</strong></td><td>O(1)</td><td>Retrieving the number of elements in the queue.</td></tr><tr><td><strong>Iterator</strong></td><td>O(n)</td><td>Iterating over all elements in the queue.</td></tr></tbody></table>

## Example

### Basic Operation

```java
import java.util.*;

public class PriorityQueueExample {
    public static void main(String[] args) {
        // PriorityQueue with natural ordering
        PriorityQueue<Integer> pq = new PriorityQueue<>();

        // Add elements to the PriorityQueue
        pq.add(10);
        pq.add(20);
        pq.add(15);
        pq.add(5);

        // Display the PriorityQueue
        System.out.println("PriorityQueue: " + pq); //PriorityQueue: [5, 10, 15, 20]

        // Retrieve the highest priority element without removing
        System.out.println("Peek (highest priority): " + pq.peek()); //Peek (highest priority): 5

        // Retrieve and remove the highest priority element
        System.out.println("Polled (removed): " + pq.poll()); //Polled (removed): 5

        // Display the PriorityQueue after polling
        System.out.println("PriorityQueue after poll: " + pq); //PriorityQueue after poll: [10, 20, 15]

        // Iterate through the PriorityQueue
        System.out.println("Iterating through PriorityQueue:"); //Iterating through PriorityQueue:
        for (Integer element : pq) {
            System.out.println(element);
        }
        //10
        //20
        //15

        // Custom comparator to create a max-heap
        PriorityQueue<Integer> maxHeap = new PriorityQueue<>(Collections.reverseOrder());
        maxHeap.add(10);
        maxHeap.add(20);
        maxHeap.add(15);
        maxHeap.add(5);

        // Display the max-heap
        System.out.println("Max-Heap: " + maxHeap); //Max-Heap: [20, 10, 15, 5]

        // Custom object example with priority
        PriorityQueue<Task> taskQueue = new PriorityQueue<>(Comparator.comparingInt(Task::getPriority));
        taskQueue.add(new Task("Task 1", 2));
        taskQueue.add(new Task("Task 2", 1));
        taskQueue.add(new Task("Task 3", 3));

        System.out.println("Task Queue (ordered by priority): "); //Task Queue (ordered by priority): 
        while (!taskQueue.isEmpty()) {
            System.out.println(taskQueue.poll().getName());
        }
        //Task 2    
        //Task 1
        //Task 3
    }
}

class Task {
    private String name;
    private int priority;

    public Task(String name, int priority) {
        this.name = name;
        this.priority = priority;
    }

    public String getName() {
        return name;
    }

    public int getPriority() {
        return priority;
    }
}
```

**Using PriorityQueue for Task Scheduling (Max-Heap):**

```java
import java.util.*;

public class TaskScheduler {
    public static void main(String[] args) {
        // Max-heap using custom comparator
        PriorityQueue<Task> taskQueue = new PriorityQueue<>(Comparator.comparingInt(Task::getPriority).reversed());

        // Adding tasks with different priorities
        taskQueue.add(new Task("Critical Task", 1));
        taskQueue.add(new Task("High Priority Task", 2));
        taskQueue.add(new Task("Low Priority Task", 5));

        // Scheduling tasks (polling from the queue)
        while (!taskQueue.isEmpty()) {
            Task task = taskQueue.poll();
            System.out.println("Executing: " + task.getName());
        }
    }
}

class Task {
    private String name;
    private int priority;

    public Task(String name, int priority) {
        this.name = name;
        this.priority = priority;
    }

    public String getName() {
        return name;
    }

    public int getPriority() {
        return priority;
    }
}
```

### **PriorityQueue for Sorting Elements**

```java
import java.util.*;

public class SortWithPriorityQueue {
    public static void main(String[] args) {
        List<Integer> numbers = Arrays.asList(15, 10, 20, 5, 30);
        PriorityQueue<Integer> pq = new PriorityQueue<>(numbers);

        System.out.println("Sorted elements using PriorityQueue:");
        while (!pq.isEmpty()) {
            System.out.print(pq.poll() + " ");
        }
    }
}
```

## **When to Use PriorityQueue ?**

1. **Task Scheduling:** Use `PriorityQueue` to schedule tasks where the priority of each task varies.
2. **Dijkstra’s Algorithm:** Priority queues are commonly used in graph algorithms like Dijkstra’s shortest path algorithm.
3. **Real-time Systems:** When processing events with different priorities (e.g., priority messaging systems).
4. **Merging Multiple Sorted Streams:** Use `PriorityQueue` to merge multiple sorted streams efficiently.
