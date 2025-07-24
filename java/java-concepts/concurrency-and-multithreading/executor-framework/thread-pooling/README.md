---
hidden: true
---

# Thread Pooling

## About

A thread pool in Java is a collection of pre-instantiated reusable threads that can be used to execute multiple tasks. Thread pools are used to manage a pool of worker threads, making it easier to handle a large number of concurrent tasks without the overhead of creating and destroying threads frequently.

## **Key Points to Understand**

### **1. Core Pool Size**

The minimum number of threads to keep in the pool, even if they are idle. These threads will stay alive and be reused to execute incoming tasks.

#### **Behavior**

* If the number of tasks is less than or equal to the core pool size, new threads are created to handle them.
* Once the core pool size is reached, subsequent tasks are queued unless the queue is full.

### **2. Maximum Pool Size**

The maximum number of threads allowed in the pool.

#### **Behavior**

* If the number of tasks exceeds the core pool size and the queue is full, new threads are created up to the maximum pool size to handle the overflow.
* If the maximum pool size is reached and the queue is full, the `RejectedExecutionHandler` is invoked to handle the task.

### **3. Keep Alive Time**

The amount of time an idle thread can remain alive in the pool before being terminated.

#### **Behavior**

* When the number of threads exceeds the core pool size, excess idle threads are terminated after the keep alive time elapses. This helps to optimize resource utilization.

### **4. Work Queue**

A queue used to hold tasks before they are executed. Different types of work queues affect how tasks are scheduled, ordered, and managed.

#### **Behavior**

* When the number of tasks exceeds the core pool size, new tasks are added to the work queue.
* The type of queue (e.g., `ArrayBlockingQueue`, `LinkedBlockingQueue`) affects the behavior of the thread pool.

#### Types of Work Queues

1. **Unbounded Queues (e.g.,** `LinkedBlockingQueue`**)**
2. **Bounded Queues (e.g.,** `ArrayBlockingQueue`**)**
3. **Priority Queues (e.g.,** `PriorityBlockingQueue`**)**
4. **Synchronous Queues (e.g.,** `SynchronousQueue`**)**

#### Key Considerations for Choosing a Work Queue

* **Task arrival rate:** How often new tasks are submitted to the pool.
* **Task processing time:** How long it takes to process a task.
* **Resource constraints:** Memory and CPU limitations.
* **Fairness:** How important it is for tasks to be processed in a specific order.
* **Priority:** Whether tasks have different priorities.
* **Delayed execution:** If tasks need to be executed at specific times.

## How They Work Together

The interaction of these parameters determines the behavior of the thread pool:

1. **Task Submission:** A task is submitted to the executor.
2. **Core Pool:** If the number of threads is less than the core pool size, a new thread is created to handle the task.
3. **Work Queue:** If the core pool is full, the task is added to the work queue.
4. **Maximum Pool Size:** If the work queue is full and the number of threads is less than the maximum pool size, a new thread is created to handle the task.
5. **Rejected Execution Handler:** If the maximum pool size is reached and the queue is full, the rejected execution handler is invoked.
6. **Keep Alive Time:** Idle threads beyond the core pool size are terminated after the keep alive time.

## **Thread Pool Benefits**

1. **Performance**:
   * By reusing existing threads, thread pools minimize the overhead associated with thread creation and destruction. This leads to better performance, especially in applications that require handling many short-lived tasks.
2. **Resource Management**:
   * Thread pools help in managing system resources effectively by controlling the number of active threads. This prevents resource exhaustion and ensures the system remains responsive.
3. **Task Management**:
   * Thread pools provide mechanisms for scheduling and managing tasks, allowing for more efficient execution of concurrent tasks.
4. **Scalability**:
   * Thread pools can be configured to handle varying workloads by adjusting the core pool size, maximum pool size, and keep-alive time. This makes it easier to scale applications to meet demand.
