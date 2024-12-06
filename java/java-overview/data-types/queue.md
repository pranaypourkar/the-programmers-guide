# Queue

## **About**

In Java, a `Queue` is an interface that represents a collection designed to hold elements before processing them, following a particular order (usually **FIFO - First In, First Out**). It is part of the `java.util` package and provides methods for adding, removing, and inspecting elements in a queue-like manner.

The `Queue` interface is implemented by several classes in Java, such as `LinkedList`, `PriorityQueue`, and `ArrayDeque`. Specialized concurrent implementations like `BlockingQueue` are available in the `java.util.concurrent` package.

## **Features**

1. **FIFO Ordering:** Elements are processed in the order they are added (First In, First Out), though exceptions like `PriorityQueue` use custom ordering.
2. **Non-Capacity Bound (default):** Most `Queue` implementations are unbounded, except for specific implementations like `ArrayBlockingQueue`.
3. **Add/Remove Operations:** It offers operations to enqueue (`add`/`offer`) and dequeue (`remove`/`poll`) elements.
4. **Null Prohibition:** Some implementations (like `PriorityQueue`) do not allow `null` elements.
5. **Blocking Queues:** Concurrent implementations like `ArrayBlockingQueue` and `LinkedBlockingQueue` support thread-safe operations and allow blocking for producer-consumer scenarios.
6. **Custom Ordering:** `PriorityQueue` allows elements to be ordered based on a comparator or their natural ordering.
7. **Deque Support:** Double-ended queues like `ArrayDeque` and `LinkedList` implement both `Queue` and `Deque`interfaces, supporting insertion and removal from both ends.
8. **Concurrent Variants:** Queues like `ConcurrentLinkedQueue` allow thread-safe operations without explicit synchronization.

## **Key Methods**

* `add(E e)`: Adds an element to the queue, throwing an exception if it fails.
* `offer(E e)`: Adds an element to the queue, returning `false` if it fails.
* `remove()`: Removes and returns the head of the queue; throws an exception if the queue is empty.
* `poll()`: Removes and returns the head of the queue; returns `null` if the queue is empty.
* `element()`: Returns the head of the queue without removing it; throws an exception if the queue is empty.
* `peek()`: Returns the head of the queue without removing it; returns `null` if the queue is empty.
* `size()`: Returns the number of elements in the queue.
* `isEmpty()`: Checks if the queue is empty.
* `clear()`: Removes all elements from the queue.



## **Queue Implementations in `java.util`**

### **1. LinkedList**

* **Description:** Implements `Queue` and `Deque` interfaces.
* **Use Case:** General-purpose queue or double-ended queue.
* **Features:**
  * Allows `null` elements.
  * Dynamic size.

### **2. PriorityQueue**

* **Description:** A queue that orders elements according to their natural ordering or a custom comparator.
* **Use Case:** Priority-based task scheduling.
* **Features:**
  * Does not allow `null` elements.
  * Backed by a binary heap.

### **3. ArrayDeque**

* **Description:** Implements `Deque` and can act as a double-ended queue.
* **Use Case:** Efficient queue operations without thread safety.
* **Features:**
  * Does not allow `null` elements.
  * Resizable array-based implementation.

## **Queue Implementations in `java.util.concurrent`**

### **1. ArrayBlockingQueue**

* **Description:** A bounded blocking queue backed by an array.
* **Use Case:** Fixed-capacity queues for producer-consumer problems.
* **Features:**
  * Thread-safe.
  * Supports blocking operations.

### **2. LinkedBlockingQueue**

* **Description:** A bounded or unbounded blocking queue backed by linked nodes.
* **Use Case:** High-throughput producer-consumer problems.
* **Features:**
  * Thread-safe.
  * Allows an optional capacity limit.

### **3. PriorityBlockingQueue**

* **Description:** A thread-safe version of `PriorityQueue`.
* **Use Case:** Concurrent priority-based task scheduling.
* **Features:**
  * No capacity limit.
  * Elements are ordered based on natural ordering or a comparator.

### **4. DelayQueue**

* **Description:** A blocking queue that holds elements until their delay expires.
* **Use Case:** Scheduling tasks for execution after a delay.
* **Features:**
  * Thread-safe.
  * Stores elements implementing `Delayed`.

### **5. SynchronousQueue**

* **Description:** A blocking queue where each insertion must wait for a corresponding removal.
* **Use Case:** Direct handoff between producer and consumer.
* **Features:**
  * Thread-safe.
  * No capacity; acts as a synchronization point.

### **6. LinkedTransferQueue**

* **Description:** A specialized queue optimized for producer-consumer interactions, supporting transfer operations.
* **Use Case:** Large-scale concurrent task sharing.
* **Features:**
  * Thread-safe.
  * No capacity limit.

### **7. ConcurrentLinkedQueue**

* **Description:** An unbounded thread-safe non-blocking queue based on linked nodes.
* **Use Case:** High-performance, low-latency concurrent applications.
* **Features:**
  * Uses CAS (compare-and-swap) for operations.
  * No blocking support.

## **Implementation** Comparison Table

<table data-header-hidden data-full-width="true"><thead><tr><th></th><th width="153"></th><th width="185"></th><th></th></tr></thead><tbody><tr><td><strong>Implementation</strong></td><td><strong>Thread Safety</strong></td><td><strong>Capacity</strong></td><td><strong>Special Features</strong></td></tr><tr><td><code>LinkedList</code></td><td>No</td><td>Unbounded</td><td>General-purpose queue with <code>Deque</code> support.</td></tr><tr><td><code>PriorityQueue</code></td><td>No</td><td>Unbounded</td><td>Priority-based ordering.</td></tr><tr><td><code>ArrayDeque</code></td><td>No</td><td>Unbounded</td><td>Fast double-ended queue.</td></tr><tr><td><code>ArrayBlockingQueue</code></td><td>Yes</td><td>Bounded</td><td>Fixed capacity with thread-safe blocking.</td></tr><tr><td><code>LinkedBlockingQueue</code></td><td>Yes</td><td>Bounded/Unbounded</td><td>High-throughput queue with optional capacity.</td></tr><tr><td><code>PriorityBlockingQueue</code></td><td>Yes</td><td>Unbounded</td><td>Concurrent priority-based queue.</td></tr><tr><td><code>DelayQueue</code></td><td>Yes</td><td>Unbounded</td><td>Holds elements until a delay expires.</td></tr><tr><td><code>SynchronousQueue</code></td><td>Yes</td><td>No capacity</td><td>Handoff mechanism for producer-consumer synchronization.</td></tr><tr><td><code>LinkedTransferQueue</code></td><td>Yes</td><td>Unbounded</td><td>Optimized for direct transfers.</td></tr><tr><td><code>ConcurrentLinkedQueue</code></td><td>Yes</td><td>Unbounded</td><td>High-performance non-blocking queue.</td></tr></tbody></table>
