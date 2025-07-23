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
* This means the JVM **will not shut down** immediately after the main thread exits **if we don’t explicitly call** `executor.shutdown()`.
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

### **3. Using `ExecutorService` + `Future` (without `get()`)**

```java
ExecutorService executor = Executors.newSingleThreadExecutor();
Future<?> future = executor.submit(() -> System.out.println("Task running"));
```

#### What happens

* A task is submitted and runs in a background thread.
* The main thread **continues immediately** without waiting for the task.
* If the executor is not shut down and the future is not checked, the program **may hang** or may **end before the task prints**, depending on how long the main thread lives.

Even though most executor threads are non-daemon, the main thread may finish execution before the task completes. If the program is short and the thread is slow, it’s possible the output never appears.

#### Why it happens

* `submit()` is **non-blocking**.
* If `get()` is not called, the main thread **has no dependency** on whether the task completes.
* And if `executor.shutdown()` is called immediately, the task may not get a chance to complete.

#### Solution:

Call `future.get()` to block the main thread until the task completes:

```java
future.get(); // Waits for result (even if it's void)
```

This guarantees the task will complete **before** the program exits.

### **4. Using `Callable` and `Future`**

```java
Callable<Integer> task = () -> 5 + 10;
Future<Integer> result = executor.submit(task);
System.out.println(result.get());
```

#### What happens:

* `Callable` is like `Runnable`, but it returns a value.
* When submitted, it runs in the executor’s background thread.
* The `Future` represents the result of the asynchronous computation.
* Calling `get()` on the future will **block the main thread** until the result is available.

#### Why it's safe:

* As long as we call `get()`, the main thread waits.
* JVM will not exit until `get()` returns, even if the thread used is a daemon, because `get()` introduces a **blocking point** that ties the main thread to the result.

#### If `get()` is skipped:

* Same risk as in #3 — we’ve scheduled a background task and **not waited** for it.
* In short programs, the task may not run in time, and the program may exit before anything is printed.

#### Best practice:

Always call `get()` if we want the main thread to **depend** on the result or ensure completion.

### **5. Using `CompletableFuture`**

```java
CompletableFuture.supplyAsync(() -> "Hello")
    .thenApply(s -> "Welcome " + s)
    .thenAccept(System.out::println);
```

#### What happens

* This starts an asynchronous pipeline:
  1. Supply data in a background thread.
  2. Apply transformation.
  3. Print result.
* These tasks are scheduled in the **ForkJoinPool.commonPool**, which uses **daemon threads** by default.

#### The problem

* Daemon threads **do not prevent JVM shutdown**.
* If the main thread finishes execution **before the background threads complete**, the JVM exits — the pipeline may never finish.
* So even though the code is correct, **we may never see the result printed**.

#### Why it sometimes works

* If the background thread is fast and finishes before the main thread exits, it works.
* But there is **no guarantee**.

#### Solution

Always call `.join()` or `.get()` on the final stage:

```java
CompletableFuture
    .supplyAsync(() -> "Hello")
    .thenApply(s -> "Welcome " + s)
    .thenAccept(System.out::println)
    .join(); // waits for the whole pipeline
```

### **6. Using `thenCompose` in `CompletableFuture`**

```java
CompletableFuture.supplyAsync(() -> "user123")
    .thenCompose(user -> CompletableFuture.supplyAsync(() -> "Orders for " + user))
    .thenAccept(System.out::println);
```

#### What happens

* We’re creating a **nested asynchronous structure**:
  * Task 1: supply user
  * Task 2: use result to trigger another async task to fetch orders
* Each `supplyAsync` runs on a separate background thread.
* All of these use daemon threads by default (via `ForkJoinPool.commonPool`).

#### The problem

* Now we're relying on **two layers of async tasks** to complete.
* The main thread may exit **before either or both tasks finish**.
* Since no `.join()` or `.get()` is used, there is **nothing holding the program open**.

This is the **most likely to fail** form of async code.

#### Why

* `thenCompose` introduces an additional async call inside another async task.
* Neither task is awaited, and both may get killed if the main thread ends.

#### Solution

Chain `.join()` or `.get()` to the final stage:

```java
CompletableFuture.supplyAsync(() -> "user123")
    .thenCompose(user -> CompletableFuture.supplyAsync(() -> "Orders for " + user))
    .thenAccept(System.out::println)
    .join();
```

This ensures both the outer and inner async tasks finish before the main thread exits.
