# Types of Work Queues

## About

Work queues in Java are a critical component of thread pools, used to hold tasks before they are executed by worker threads. The type of work queue used can significantly affect the behavior and performance of the thread pool.

## **1. Unbounded Queues**

**Example**: `LinkedBlockingQueue`

### **Characteristics**:

* **Capacity**: Unlimited, meaning there is no fixed limit on the number of tasks it can hold.
* **Usage**: Suitable when tasks are submitted faster than they are processed, but you want to avoid task rejection and you have enough memory.
* **Behavior**: Tasks are queued until a thread becomes available. This can lead to a large number of queued tasks if the producer outpaces the consumer.

### How core pool size and max pool size influence ?

**Core Pool Size**:

* Tasks are added to the queue if all core pool threads are busy.
* Threads up to the core pool size are kept alive, even if they are idle.

**Maximum Pool Size**:

* The maximum pool size is not relevant with unbounded queues because tasks will keep getting added to the queue without creating new threads beyond the core pool size.
* Additional threads are not created beyond the core pool size.

**Behavior**:

* New tasks are always added to the queue if the core pool is full.
* The queue size can grow indefinitely, potentially leading to high memory usage.
* Threads are reused to handle tasks from the queue when they become available.

### **Advantages**:

* No task rejection due to full queue.
* Simplifies task submission as tasks are always accepted.

### **Disadvantages**:

* Can lead to high memory usage if tasks accumulate faster than they are processed.
* Potential for OutOfMemoryError if the task submission rate is very high.

### Example Usage

```java
ExecutorService executor = new ThreadPoolExecutor(
    5, // core pool size
    10, // maximum pool size
    60L, // keep-alive time
    TimeUnit.SECONDS, // time unit
    new LinkedBlockingQueue<>()
);
```

## **2. Bounded Queues**

**Example**: `ArrayBlockingQueue`

### **Characteristics**:

* **Capacity**: Fixed, meaning there is a set limit on the number of tasks it can hold.
* **Usage**: Suitable when you want to limit the number of queued tasks to control memory usage and provide backpressure to the task producer.
* **Behavior**: When the queue is full, new tasks will be handled according to the rejection policy or the caller will block (if using synchronous handoff).

### How core pool size and max pool size influence ?

**Core Pool Size**:

* Tasks are added to the queue if all core pool threads are busy.
* Threads up to the core pool size are kept alive, even if they are idle.

**Maximum Pool Size**:

* If the queue is full and the number of active threads is less than the maximum pool size, a new thread is created to handle the task.
* Once the number of threads reaches the maximum pool size, additional tasks are either blocked, rejected, or handled based on the rejection policy.

**Behavior**:

* New tasks are added to the queue if it is not full and the core pool is full.
* If the queue is full, new threads are created up to the maximum pool size.
* Once the maximum pool size is reached and the queue is full, tasks are handled based on the configured rejection policy.

### **Advantages**:

* Controlled memory usage.
* Provides a natural backpressure mechanism, preventing excessive task submission.

### **Disadvantages**:

* Risk of task rejection or caller blocking if the queue fills up and all threads are busy.

### **Example Usage**:

```java
ExecutorService executor = new ThreadPoolExecutor(
    5, // core pool size
    10, // maximum pool size
    60L, // keep-alive time
    TimeUnit.SECONDS, // time unit
    new ArrayBlockingQueue<>(100)
);
```

## **3. Priority Queues**

**Example**: `PriorityBlockingQueue`

### **Characteristics**:

* **Capacity**: Unbounded, but tasks are ordered based on their priority.
* **Usage**: Suitable when tasks have different priorities and should be executed based on their priority rather than their order of submission.
* **Behavior**: Tasks with higher priority are executed before those with lower priority.

### How core pool size and max pool size influence ?

**Core Pool Size**:

* Tasks are added to the queue if all core pool threads are busy.
* Threads up to the core pool size are kept alive, even if they are idle.

**Maximum Pool Size**:

* If tasks are coming in faster than they can be handled by the core pool and the queue is theoretically large, new threads up to the maximum pool size can be created to handle the load.
* Once the number of threads reaches the maximum pool size, additional tasks are either blocked, rejected, or handled based on the rejection policy.

**Behavior**:

* New tasks are added to the queue and are ordered based on priority.
* Higher priority tasks are executed first.
* If the queue is full, new threads are created up to the maximum pool size.
* Once the maximum pool size is reached and the queue is full, tasks are handled based on the configured rejection policy.

### **Advantages**:

* Allows high-priority tasks to be processed first.
* Flexible task ordering.

### **Disadvantages**:

* Requires tasks to implement the `Comparable` interface.
* Increased complexity in managing task priorities.

### **Example Usage**:

{% hint style="info" %}
The `new PriorityBlockingQueue<>()` constructor initializes the queue with a default initial capacity, but this queue is still unbounded.

The `new PriorityBlockingQueue<>(3)` specifies an initial capacity of 3, but this does not mean it is bounded. The initial capacity is just a hint for internal array sizing; the queue can still grow beyond this limit as needed.
{% endhint %}

```java
ExecutorService executor = new ThreadPoolExecutor(
    5, // core pool size
    10, // maximum pool size
    60L, // keep-alive time
    TimeUnit.SECONDS, // time unit
    new PriorityBlockingQueue<>()
);
```

## **4. Synchronous Queues**

**Example**: `SynchronousQueue`

### **Characteristics**:

* **Capacity**: Zero capacity, meaning it does not store tasks. Instead, each task submission must directly hand off the task to a worker thread.
* **Usage**: Suitable for scenarios where tasks need to be executed immediately and the thread pool is sized to always have a thread available.
* **Behavior**: Tasks are handed off directly to a worker thread. If no threads are available, the caller will block or the task will be rejected, depending on the configuration.

### How core pool size and max pool size influence ?

**Core Pool Size**:

* Tasks are handed off directly to a worker thread without being queued.
* If all core pool threads are busy, a new thread is created to handle the task until the maximum pool size is reached.

**Maximum Pool Size**:

* If all threads are busy and the maximum pool size is reached, additional tasks are either blocked, rejected, or handled based on the rejection policy.

**Behavior**:

* Each task submission must be directly handed off to a worker thread.
* If no threads are available, the task is either blocked or rejected based on the configuration.
* No task queuing, tasks are processed immediately if a thread is available.

### **Advantages**:

* Ensures that tasks are executed as soon as they are submitted.
* Reduces memory usage as tasks are not stored.

### **Disadvantages**:

* Requires a well-sized thread pool to avoid task rejection or caller blocking.
* Can lead to high contention if the thread pool is undersized.

### **Example Usage**:

```java
ExecutorService executor = new ThreadPoolExecutor(
    5, // core pool size
    10, // maximum pool size
    60L, // keep-alive time
    TimeUnit.SECONDS, // time unit
    new SynchronousQueue<>()
);
```

## **5. Delay Queues**

**Example**: `DelayQueue`

### **Characteristics**:

* **Capacity**: Unbounded, but tasks are delayed for a specified period before being eligible for execution.
* **Usage**: Suitable for scheduling tasks that should only be executed after a certain delay.
* **Behavior**: Tasks are not eligible for execution until their delay has expired.

### How core pool size and max pool size influence ?

**Core Pool Size**:

* Tasks are added to the queue with a delay period.
* Threads up to the core pool size are kept alive, even if they are idle.

**Maximum Pool Size**:

* If the queue is full and the number of active threads is less than the maximum pool size, a new thread is created to handle the task.
* Once the number of threads reaches the maximum pool size, additional tasks are either blocked, rejected, or handled based on the rejection policy.

**Behavior**:

* Tasks are added to the queue and will be delayed for a specified period before they are eligible for execution.
* Threads execute tasks as they become eligible based on the delay.
* If the queue is full and additional threads are needed, new threads are created up to the maximum pool size.

### **Advantages**:

* Ideal for scheduling delayed tasks.
* Flexible delay management.

### **Disadvantages**:

* Requires tasks to implement the `Delayed` interface.
* Delayed tasks might accumulate, leading to potential memory issues.

### **Example Usage**:

```java
DelayQueue<DelayedTask> delayQueue = new DelayQueue<>();
```



## Comparison table summarizing the different types of work queues

<table data-header-hidden data-full-width="true"><thead><tr><th></th><th></th><th></th><th></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Feature</strong></td><td><strong>Unbounded Queue</strong>(<code>LinkedBlockingQueue</code>)</td><td><strong>Bounded Queue</strong>(<code>ArrayBlockingQueue</code>)</td><td><strong>Priority Queue</strong>(<code>PriorityBlockingQueue</code>)</td><td><strong>Synchronous Queue</strong>(<code>SynchronousQueue</code>)</td><td><strong>Delay Queue</strong>(<code>DelayQueue</code>)</td></tr><tr><td><strong>Capacity</strong></td><td>Unlimited</td><td>Fixed</td><td>Unlimited</td><td>Zero</td><td>Unlimited</td></tr><tr><td><strong>Task Ordering</strong></td><td>FIFO (First-In-First-Out)</td><td>FIFO</td><td>Priority-based (requires <code>Comparable</code>)</td><td>N/A (direct handoff)</td><td>FIFO with delay</td></tr><tr><td><strong>Memory Usage</strong></td><td>Can be high</td><td>Controlled</td><td>Can be high</td><td>Minimal</td><td>Can be high</td></tr><tr><td><strong>Task Rejection</strong></td><td>Rare (only if memory runs out)</td><td>Possible if queue is full</td><td>Rare (only if memory runs out)</td><td>Possible if no threads available</td><td>Rare (only if memory runs out)</td></tr><tr><td><strong>Task Execution Delay</strong></td><td>None</td><td>None</td><td>None</td><td>None</td><td>Delay specified per task</td></tr><tr><td><strong>Ideal Use Case</strong></td><td>High throughput with many tasks</td><td>Controlled task submission rate</td><td>Handling tasks with varying priorities</td><td>Immediate task execution</td><td>Scheduling tasks with delay</td></tr></tbody></table>

