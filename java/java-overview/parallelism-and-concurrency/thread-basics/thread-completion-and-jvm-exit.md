# Thread Completion & JVM Exit

## About

This page explains what happens when threads are created using different mechanisms in Java, and how the JVM handles **thread completion**, especially in relation to **main thread exit**. It focuses on when threads may silently fail to complete, what causes that, and how to prevent it.

In Java, the main thread is the first thread that starts when a program begins. Any additional threads — whether created manually or using concurrency tools like `ExecutorService` or `CompletableFuture` — run **asynchronously**. Once the main thread finishes execution, the Java Virtual Machine (JVM) begins shutdown.

If background threads are not finished by the time the JVM shuts down, they may be **terminated abruptly**, causing unexpected behavior such as **missing output**, **incomplete processing**, or **tasks silently dropped**.

## **JVM Thread Lifecycle**

* The JVM stays alive **as long as there are non-daemon threads** running.
* When the main thread finishes:
  * If all remaining threads are **daemon threads**, the JVM **shuts down immediately**.
  * If there are **non-daemon threads** still running, the JVM waits for them to complete.

## Thread Creation Mechanisms and Behaviour

Most Java thread creation utilities use daemon threads from thread pools. That means the JVM does not wait for them by default unless explicitly told to.

### **1. Using `Thread` (Extending or Runnable)**

```java
new Thread(() -> System.out.println("Hello")).start();
```

* This creates a **non-daemon thread** by default.
* Even if the main thread exits, the JVM will wait for this thread to finish.
* **No special handling is needed** in most cases.

**But:** If we explicitly mark it as a daemon thread:

```java
Thread t = new Thread(() -> System.out.println("Hello"));
t.setDaemon(true);
t.start();
```

* Then the JVM **will not wait** for it - the task may not finish.

### **2. Using `ExecutorService`**

ExecutorService is a high-level API introduced in Java 5 as part of the `java.util.concurrent` package. It abstracts thread management and provides a flexible mechanism for submitting tasks without having to manually manage thread lifecycle.

When a task is submitted using `ExecutorService`, it is assigned to a thread from an internal thread pool, and executed asynchronously.

```java
ExecutorService executor = Executors.newFixedThreadPool(2);
executor.submit(() -> System.out.println("Hello"));
```

* Threads used by most `ExecutorService` implementations (e.g. `FixedThreadPool`, `CachedThreadPool`) are **non-daemon**.
* This means the JVM **will not shut down** immediately after the main thread exits **if you don’t explicitly call** `executor.shutdown()`.
* However, failure to shut down an executor may result in the JVM **hanging indefinitely**, especially if the thread pool has long-running or blocking tasks.

#### Lifecycle behavior

* If we submit a task and **do not call `shutdown()`**, the executor will keep the JVM alive waiting for more tasks.
* If we submit a task and **immediately shut down the executor**, but don't wait for termination, the task might be interrupted mid-way if still running.
*   A proper approach is always shut down the executor gracefully:

    ```java
    executor.shutdown();
    executor.awaitTermination(timeout, unit);
    ```

This ensures graceful completion of all submitted tasks before JVM termination.





