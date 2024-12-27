# Parallelism and Concurrency

## About

Parallelism and Concurrency are both important concepts in asynchronous computation, but they are distinct and address different aspects of task execution.

{% hint style="info" %}
OS has two main concepts:

* **Process**: A process is a task (program) running over a operative system. An operative system can have multiple process running at the same time.
* **Thread**: A thread is a subtask running over a process (program). A process can have multiple threads running at the same time.

<img src="../../../../.gitbook/assets/image (518).png" alt="" data-size="original">
{% endhint %}

{% hint style="info" %}
An application can be said to be neither parallel nor concurrent, means that it can processes all tasks one at a time, sequentially.

An application can be said to be concurrent but not parallel, means it can processes more than one task at the same time, but no two tasks are executing at the same time instant.

An application can be said to be parallel but not concurrent, means it can processes multiple sub-tasks of a task in multi-core CPU at the same time.
{% endhint %}

### **Here is a Analogy to understand further**

{% hint style="success" %}
**Cooking Dinner and Doing Laundry**

* **No Concurrency and No Parallelism:**\
  You first complete cooking dinner entirely and then start doing the laundry. Each task is done in sequence without any overlap.
* **Concurrency Without Parallelism:**\
  You start cooking dinner and while the food is simmering or baking, you begin doing the laundry. When you need to check the food, you pause the laundry task, attend to the food, and then return to the laundry. The tasks overlap in time, but you're switching between them rather than doing both at exactly the same time.
* **Concurrency With Parallelism:**\
  You cook dinner while your washing machine runs the laundry. You cooks the food, and the washing machine handles the laundry simultaneously, both tasks proceeding independently at the same time.
{% endhint %}

## **Concurrency**

Concurrency refers to the ability of a system to handle multiple tasks at the same time. It doesn't necessarily mean these tasks are executed simultaneously. Instead, concurrency is about managing the execution of tasks in a way that they appear to run in parallel, even if they are executed on a single processor core. Concurrency creates a illusion of parallelism, however actually the chunks of a task aren’t parallelly processed. Concurrency is when the execution of multiple tasks can overlap.

<figure><img src="../../../../.gitbook/assets/image (16).png" alt="" width="563"><figcaption></figcaption></figure>

### **Key Characteristics**

* **Interleaving:** Tasks are broken down into smaller units, which are executed in a time-sliced manner.
* **Context Switching:** The scheduler frequently switches between tasks, saving and restoring the state of each task.
* **Single-Core Execution:** Concurrency can happen on a single core by slicing time among tasks.
* **Debugging**: In concurrency, debugging is a bit hard due to non-deterministic control flow approach.

### **Concurrency Utilities in Java**

1. **Executors:**
   * **Thread Management:** The `Executors` framework abstracts the management of threads and provides various methods to create thread pools (e.g., `newFixedThreadPool`, `newCachedThreadPool`, `newSingleThreadExecutor`). This abstraction allows developers to focus on task execution rather than thread creation and management.
   * **Task Submission:** Tasks can be submitted for execution via methods like `submit()` or `execute()`. The framework takes care of scheduling and executing these tasks in an efficient manner.
2. **Concurrent Collections:**
   * **Thread-Safe Collections:** Java provides thread-safe variants of standard collections, such as `ConcurrentHashMap`, `ConcurrentLinkedQueue`, `CopyOnWriteArrayList`, and `BlockingQueue`. These collections are designed for concurrent access, allowing multiple threads to interact with the collection without the need for explicit synchronization.
   * **Scalability:** These collections are optimized for performance and scalability, ensuring that operations like adding, removing, or retrieving elements are efficient even under heavy concurrent usage.
3. **Future and Callable:**
   * **Asynchronous Computation:** `Callable` is an interface similar to `Runnable`, but it can return a result or throw an exception. When a `Callable` is submitted to an `ExecutorService`, it returns a `Future` object.
   * **Future:** The `Future` represents the result of an asynchronous computation. It provides methods to check if the computation is complete, retrieve the result, or cancel the task.
4. **Locks:**
   * **Advanced Locking Mechanisms:** The `java.util.concurrent.locks` package provides a set of locking mechanisms that offer more flexibility than traditional `synchronized` blocks. Examples include `ReentrantLock`, `ReentrantReadWriteLock`, and `StampedLock`.
   * **Fairness and Condition Variables:** These locks support features like fairness policies (ensuring that the longest-waiting thread gets the lock first) and condition variables for more fine-grained thread coordination.
5. **Atomic Variables:**
   * **Atomic Operations:** Java provides classes like `AtomicInteger`, `AtomicLong`, `AtomicReference`, and `AtomicBoolean` in the `java.util.concurrent.atomic` package. These classes provide methods for performing atomic operations (e.g., `compareAndSet`, `incrementAndGet`) without the need for synchronization, ensuring thread safety.
6. **CountDownLatch and CyclicBarrier:**
   * **Coordination Between Threads:** `CountDownLatch` is used to block a set of threads until some other operations are completed. `CyclicBarrier` allows a group of threads to wait for each other to reach a common execution point.
7. **Semaphore:**
   * **Controlling Access:** A `Semaphore` is used to control access to a resource by multiple threads. It maintains a set of permits, and threads must acquire a permit before proceeding, releasing it afterward.
8. **ThreadLocal:**
   * **Per-Thread Variables:** `ThreadLocal` provides a way to maintain thread-local variables. Each thread accessing such a variable will have its own independent copy, ensuring that no two threads can interfere with each other's values.

## **Parallelism**

Parallelism involves executing multiple tasks simultaneously. It requires multiple processors or cores, where each core executes a separate task at the same time.

<figure><img src="../../../../.gitbook/assets/image (17).png" alt="" width="563"><figcaption></figcaption></figure>

### **Key Characteristics:**

* **Simultaneous Execution:** Multiple tasks are executed at the same time on different processors or cores.
* **Multi-Core Execution:** Requires multiple cores or processors to achieve parallelism.
* **No Context Switching:** Unlike concurrency, there's no need for frequent context switching between tasks.
* **Debugging**: While in this also, debugging is hard but simple than concurrency due to deterministic control flow approach.

### **Parallelism Utilities in Java**

1. **Parallel Streams:**
   * **Stream Processing:** Java 8 introduced the concept of parallel streams, allowing data processing pipelines to be executed in parallel, leveraging multiple cores. By simply calling `.parallelStream()` on a collection, Java can divide the data and process it concurrently across multiple threads.
2. **Fork/Join Framework:**
   * **Divide-and-Conquer Algorithm:** The `ForkJoinPool` is a framework for parallel execution that implements a work-stealing algorithm. It is designed for tasks that can be broken down into smaller tasks, which are then processed in parallel. The framework automatically balances the workload among available cores.
   * **RecursiveTask and RecursiveAction:** These are the two key classes in the Fork/Join framework, representing tasks that return a result or perform an action respectively.
3. **CompletableFuture:**
   * **Advanced Async Computation:** `CompletableFuture` is a powerful addition in Java 8 that supports asynchronous programming patterns like `thenApply`, `thenAccept`, `thenCombine`, etc. It allows chaining and combining multiple asynchronous computations in a non-blocking way.
4. **Stream API with Parallelism:**
   * **Parallel Array Operations:** Java 8’s Stream API provides a mechanism for parallel array operations, enabling the concurrent processing of array elements using parallel streams.

## Example

Here, thread1 and thread2 are overlapping and hence they are concurrent. So there is concurrency.

If there was just a single core and no hyperthreading, there is no parallelism possible and only 1 thread can be running at any moment.

On modern CPUs, both threads can run in parallel since there are multiple cores. So if the 2 threads are running at the same time, then there is also parallelism.

```java
package practice;

public class Main3 {
    public static void main(String[] args) throws InterruptedException {
        Thread thread1 = new Thread(() -> {
            try {
                System.out.println(System.nanoTime() + " " + Thread.currentThread() + " Before Sleep");
                Thread.sleep(2000);
                System.out.println(System.nanoTime() + " " + Thread.currentThread() + " After Sleep");
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        });

        Thread thread2 = new Thread(() -> {
            try {
                System.out.println(System.nanoTime() + " " + Thread.currentThread() + " Before Sleep");
                Thread.sleep(2000);
                System.out.println(System.nanoTime() + " " + Thread.currentThread() + " After Sleep");
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        });

        System.out.println(System.nanoTime() + " " + Thread.currentThread() + " Starting");

        thread1.start();
        thread2.start();

        System.out.println(System.nanoTime() + " " + Thread.currentThread() + " Started");

        thread1.join();
        thread2.join();
    }
}
```

<figure><img src="../../../../.gitbook/assets/image (519).png" alt="" width="563"><figcaption></figcaption></figure>
