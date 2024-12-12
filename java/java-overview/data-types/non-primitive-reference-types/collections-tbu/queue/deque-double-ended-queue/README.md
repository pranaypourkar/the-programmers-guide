# Deque (Double-Ended Queue)

## **About**&#x20;

A **Deque (Double-Ended Queue)** is a linear data structure in Java that allows the addition and removal of elements from both ends (head and tail). It is part of the `java.util` package and is an interface, with common implementations such as `ArrayDeque` and `LinkedList`. Deques can function as both stacks (LIFO) and queues (FIFO), making them versatile.

## **Features**

1. **Bi-Directional Access:** Elements can be added or removed from both ends, providing more flexibility than a regular queue.
2. **Stack-Like Operations:** Functions as a stack when elements are added/removed from the same end.
3. **Queue-Like Operations:** Functions as a regular queue when operations are restricted to one end for addition and the other for removal.
4. **Non-Capacity Bound (default):** Most implementations of `Deque` are unbounded, except for `ArrayBlockingQueue`.
5. **No Null Elements:** Null values are not allowed in `Deque` implementations like `ArrayDeque` (avoids ambiguity in certain operations).
6. **Thread-Safe Variants:** The `Deque` interface has thread-safe implementations like `LinkedBlockingDeque` in the `java.util.concurrent` package.
7. **Custom Ordering:** Specialized implementations like `PriorityBlockingDeque` allow priority-based ordering.
8. **Highly Efficient:** Both head and tail operations are optimized for performance in most `Deque` implementations.

## **Key Methods**

<table data-header-hidden data-full-width="true"><thead><tr><th width="244"></th><th width="234"></th><th></th></tr></thead><tbody><tr><td><strong>Method Type</strong></td><td><strong>Method</strong></td><td><strong>Description</strong></td></tr><tr><td><strong>Add Operations</strong></td><td><code>addFirst(E e)</code></td><td>Inserts the element at the front of the deque.</td></tr><tr><td></td><td><code>addLast(E e)</code></td><td>Inserts the element at the rear of the deque.</td></tr><tr><td></td><td><code>offerFirst(E e)</code></td><td>Adds an element at the front without throwing an exception if the deque is full.</td></tr><tr><td></td><td><code>offerLast(E e)</code></td><td>Adds an element at the rear without throwing an exception if the deque is full.</td></tr><tr><td><strong>Remove Operations</strong></td><td><code>removeFirst()</code></td><td>Removes and returns the first element. Throws an exception if the deque is empty.</td></tr><tr><td></td><td><code>removeLast()</code></td><td>Removes and returns the last element. Throws an exception if the deque is empty.</td></tr><tr><td></td><td><code>pollFirst()</code></td><td>Retrieves and removes the first element, or returns <code>null</code> if the deque is empty.</td></tr><tr><td></td><td><code>pollLast()</code></td><td>Retrieves and removes the last element, or returns <code>null</code> if the deque is empty.</td></tr><tr><td><strong>Access Operations</strong></td><td><code>getFirst()</code></td><td>Retrieves the first element without removing it. Throws an exception if the deque is empty.</td></tr><tr><td></td><td><code>getLast()</code></td><td>Retrieves the last element without removing it. Throws an exception if the deque is empty.</td></tr><tr><td></td><td><code>peekFirst()</code></td><td>Retrieves the first element without removing it; returns <code>null</code> if empty.</td></tr><tr><td></td><td><code>peekLast()</code></td><td>Retrieves the last element without removing it; returns <code>null</code> if empty.</td></tr><tr><td><strong>Iterators</strong></td><td><code>descendingIterator()</code></td><td>Returns an iterator that traverses elements in reverse order.</td></tr></tbody></table>

## **Deque Implementations in `java.util`**

### **1. ArrayDeque**

* **Description:** A resizable array implementation of the `Deque` interface. It allows the addition and removal of elements from both ends.
* **Use Case:** Suitable for scenarios where frequent additions and removals are needed from both ends of the queue, such as for implementing a sliding window or a double-ended stack.
* **Features:**
  * Non-thread-safe (not synchronized).
  * Dynamic resizing with amortized constant-time complexity for adding/removing elements from both ends.
  * Does not support null elements.

### **2. LinkedList**

* **Description:** A doubly-linked list implementation of the `Deque` interface. It supports insertion and removal of elements from both ends.
* **Use Case:** Suitable for use cases where a linked list structure is preferred (i.e., frequent insertions/removals), such as implementing deques, stacks, and queues.
* **Features:**
  * Thread-unsafe.
  * Efficient for adding/removing elements from both ends (O(1) time complexity).
  * Allows null elements.
  * Can be used as both a stack and queue (FIFO/LIFO).

## **Deque Implementations in `java.util.concurrent`**

### **1. ConcurrentLinkedDeque**

* **Description:** A non-blocking, lock-free, thread-safe implementation of a `Deque`. This implementation uses an optimistic concurrency mechanism.
* **Use Case:** Ideal for multi-threaded environments where elements need to be added/removed from both ends in a highly concurrent, non-blocking manner, such as for producer-consumer systems.
* **Features:**
  * Thread-safe and non-blocking.
  * Ideal for concurrent applications that require high throughput and low contention.
  * Does not support blocking operations.

### **2. LinkedBlockingDeque**

* **Description:** A thread-safe, optionally bounded blocking deque. This implementation supports both blocking and non-blocking operations.
* **Use Case:** Suitable for bounded capacity queues in concurrent programming, where threads can block until space becomes available or an element becomes available.
* **Features:**
  * Supports both blocking and non-blocking operations.
  * Can be bounded or unbounded, providing flexibility in capacity management.
  * Thread-safe with support for concurrent access.

### **3. DelayQueue**

* **Description:** An implementation of the `BlockingQueue` interface that supports scheduling of elements with an associated delay. It is a specialized form of a blocking deque.
* **Use Case:** Ideal for scenarios where tasks need to be delayed until a specific time, such as scheduling tasks or implementing time-based buffers.
* **Features:**
  * Thread-safe and supports blocking operations.
  * Blocks until the delay for an element has elapsed, after which it can be removed.
  * Often used for scheduled task execution or time-based event handling.

### **4. PriorityBlockingDeque**

* **Description:** A thread-safe, blocking deque that supports elements with a priority order. This implementation behaves like a priority queue but allows insertion/removal from both ends.
* **Use Case:** Useful when you need a deque with priorities and blocking capabilities, such as for managing tasks with varying urgency.
* **Features:**
  * Thread-safe with blocking support.
  * Supports custom ordering of elements based on priority.
  * Elements are sorted based on priority and can be removed in order of priority.

## Implementations Comparison Table

<table data-header-hidden data-full-width="true"><thead><tr><th width="262"></th><th width="92"></th><th width="121"></th><th width="109"></th><th width="114"></th><th></th></tr></thead><tbody><tr><td><strong>Implementation</strong></td><td><strong>Thread-Safe</strong></td><td><strong>Blocking Operations</strong></td><td><strong>Resizable</strong></td><td><strong>Features</strong></td><td><strong>When to use</strong></td></tr><tr><td><strong>ArrayDeque</strong></td><td>No</td><td>No</td><td>Yes</td><td>Fast, resizable array, no null elements</td><td>Best for high-performance situations where we need to frequently add/remove elements from both ends and do not require thread safety.</td></tr><tr><td><strong>LinkedList</strong></td><td>No</td><td>No</td><td>Yes</td><td>Doubly-linked list, allows null elements</td><td>Use when we need a simple doubly linked list structure that supports both ends for adding/removing elements.</td></tr><tr><td><strong>ConcurrentLinkedDeque</strong></td><td>Yes</td><td>No</td><td>Yes</td><td>Lock-free, non-blocking, high concurrency</td><td>Ideal for high-concurrency scenarios where we need thread safety but do not require blocking operations.</td></tr><tr><td><strong>LinkedBlockingDeque</strong></td><td>Yes</td><td>Yes</td><td>Yes</td><td>Blocking, bounded, thread-safe</td><td>Perfect for use cases involving bounded blocking queues where threads may wait for space to become available or for elements to be processed.</td></tr><tr><td><strong>DelayQueue</strong></td><td>Yes</td><td>Yes</td><td>No</td><td>Time-based scheduling, thread-safe</td><td>Use this when we need to schedule elements with a delay or timeout, such as for time-based event handling.</td></tr><tr><td><strong>PriorityBlockingDeque</strong></td><td>Yes</td><td>Yes</td><td>Yes</td><td>Priority-based, thread-safe</td><td>Use when we need a priority queue with blocking capabilities, where elements can be processed in order of priority.</td></tr></tbody></table>

## **When to Use Deques ?**

1. **Double-Ended Operations:** When both ends need frequent addition/removal.
2. **Implementing Stacks:** Use `Deque` instead of `Stack` for a modern and efficient stack implementation.
3. **Sliding Window Problems:** Deques are ideal for maintaining a window of elements during array traversal.
4. **Task Scheduling:** Manage tasks with varying priority by adding to specific ends of the deque.
