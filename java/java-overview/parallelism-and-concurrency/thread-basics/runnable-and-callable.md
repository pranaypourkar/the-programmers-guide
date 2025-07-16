# Runnable & Callable

## About

`Runnable` and `Callable` are two interfaces in Java used for executing tasks in separate threads. Both are commonly used in multithreading and concurrency but have differences in functionality.

## **Runnable Interface**

### Definition

* `Runnable` is an interface that represents a **task** to be executed by a thread.
*   It has **one method**:

    ```java
    void run();
    ```
* It does **not** return a result and **cannot throw checked exceptions**.

{% hint style="info" %}
Since Java 8, `Runnable`  can be used with **lambdas**:

```java
Runnable runnable = () -> System.out.println("Runnable task executed.");
```
{% endhint %}

### **Usage**

A `Runnable` task can be executed by:

1. **Creating a `Thread` object**
2. **Using `ExecutorService`**

## **Example 1: Implementing Runnable using a Class**

```java
public class MyRunnable implements Runnable {
    @Override
    public void run() {
        System.out.println("Executing task in thread: " + Thread.currentThread().getName());
    }
}

public class RunnableExample {
    public static void main(String[] args) {
        Thread thread = new Thread(new MyRunnable()); // Assign task to thread
        thread.start(); // Starts a new thread
    }
}
```

Here, the `run()` method is executed in a **separate thread**.

### **Example 2: Using Runnable with ExecutorService**

```java
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class RunnableWithExecutor {
    public static void main(String[] args) {
        ExecutorService executor = Executors.newFixedThreadPool(2);
        executor.submit(new MyRunnable());
        executor.shutdown();
    }
}
```

`ExecutorService` is a **thread pool manager** that efficiently manages threads.

## **Callable Interface**

### **Definition**

* `Callable<T>` is a **functional interface** introduced in Java 5.
* Unlike `Runnable`, it **returns a result** and **can throw checked exceptions**.
*   It has one method:

    ```java
    T call() throws Exception;
    ```
* The return type `T` allows it to be used for **asynchronous computation**.

{% hint style="info" %}
Since Java 8, `Callable` can be used with **lambdas**:

```java
Callable<String> callable = () -> "Callable task executed.";
```
{% endhint %}

### **Usage**

A `Callable` task is executed using an **ExecutorService** and returns a `Future<T>` object.

### **Example 1: Implementing Callable with ExecutorService**&#x20;

```java
import java.util.concurrent.Callable;

class MyCallable implements Callable<String> {
    @Override
    public String call() throws Exception {
        Thread.sleep(2000); // Simulate delay
        return "Task completed by " + Thread.currentThread().getName();
    }
}
```

```java
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

public class CallableExample {
    public static void main(String[] args) throws Exception {
        ExecutorService executor = Executors.newSingleThreadExecutor();
        Future<String> future = executor.submit(new MyCallable()); // Submit task

        System.out.println("Waiting for result...");
        String result = future.get(); // Blocks until the result is available
        System.out.println("Result: " + result);

        executor.shutdown();
    }
}
```



## **Combining Runnable and Callable**

If we want a **Runnable** but need a result, use `Executors.callable().` This is useful when converting a `Runnable` to `Callable`.

```java
import java.util.concurrent.Callable;
import java.util.concurrent.Executors;

public class RunnableToCallable {
    public static void main(String[] args) {
        Callable<Object> callableTask = Executors.callable(() -> 
            System.out.println("Runnable inside Callable"));
    }
}
```

## **Using FutureTask (Runnable + Callable)**

If we need **both Runnable and Callable behaviors**, use `FutureTask<T>`.`FutureTask` allows combining `Runnable` execution with `Callable` result handling.

```java
import java.util.concurrent.FutureTask;

public class FutureTaskExample {
    public static void main(String[] args) throws Exception {
        FutureTask<String> futureTask = new FutureTask<>(() -> "Task completed!");
        Thread thread = new Thread(futureTask);
        thread.start();
        System.out.println("Result: " + futureTask.get());
    }
}
```

## **Comparison Runnable and Callable**

<table data-full-width="true"><thead><tr><th width="254">Feature</th><th>Runnable</th><th>Callable</th></tr></thead><tbody><tr><td>Introduced in</td><td>Java 1.0</td><td>Java 5</td></tr><tr><td>Method</td><td><code>void run()</code></td><td><code>T call() throws Exception</code></td></tr><tr><td>Return Value</td><td><strong>No (void)</strong></td><td><strong>Yes (Generic T)</strong></td></tr><tr><td>Exception Handling</td><td><strong>Cannot throw checked exceptions</strong></td><td><strong>Can throw checked exceptions</strong></td></tr><tr><td>Used With</td><td><code>Thread</code>, <code>ExecutorService</code></td><td><code>ExecutorService</code>, <code>Future</code></td></tr><tr><td>Best For</td><td><strong>Executing tasks without result</strong></td><td><strong>Executing tasks that return a value</strong></td></tr></tbody></table>

## **When to Use `Runnable` vs `Callable` vs Others**

<table data-header-hidden data-full-width="true"><thead><tr><th width="386"></th><th width="198"></th><th></th></tr></thead><tbody><tr><td>Use Case</td><td><strong>Use</strong></td><td><strong>Why?</strong></td></tr><tr><td>You need to execute a task <strong>without returning a result</strong></td><td><strong>Runnable</strong></td><td><code>Runnable.run()</code> has a <code>void</code> return type, making it ideal for simple background tasks.</td></tr><tr><td>You need to execute a task <strong>and return a result</strong></td><td><strong>Callable</strong></td><td><code>Callable.call()</code> returns a value, allowing you to capture the task's output.</td></tr><tr><td>You need to execute a task <strong>but may need to check its completion later</strong></td><td><strong>Callable + Future</strong></td><td><code>Future&#x3C;T></code> allows retrieving the result later without blocking the main thread.</td></tr><tr><td>You need to execute a task <strong>and get notified when it's completed</strong></td><td><strong>FutureTask</strong></td><td><code>FutureTask</code> allows combining <code>Runnable</code> and <code>Callable</code>, and it can be used as a <code>Future</code>.</td></tr><tr><td>You need to execute multiple independent tasks <strong>and wait for all to complete</strong></td><td><strong>ExecutorService + invokeAll()</strong></td><td><code>invokeAll()</code> submits multiple <code>Callable</code>tasks and waits for all results.</td></tr><tr><td>You need to execute multiple independent tasks <strong>and get the first completed result</strong></td><td><strong>ExecutorService + invokeAny()</strong></td><td><code>invokeAny()</code> submits multiple <code>Callable</code>tasks and returns the first successful result.</td></tr><tr><td>You need <strong>fine-grained control</strong> over thread execution (e.g., priority, interruption)</td><td><strong>Thread + Runnable</strong></td><td><code>Thread</code> can directly manage execution but is less flexible than thread pools.</td></tr><tr><td>You need to <strong>handle checked exceptions</strong> in a background task</td><td><strong>Callable</strong></td><td><code>Callable.call()</code> supports throwing checked exceptions.</td></tr><tr><td>You need to execute a task <strong>repeatedly at a fixed rate</strong></td><td><strong>ScheduledExecutorService</strong></td><td><code>scheduleAtFixedRate()</code> and <code>scheduleWithFixedDelay()</code> allow scheduled execution.</td></tr><tr><td>You need to execute <strong>CPU-intensive parallel tasks</strong></td><td><strong>ForkJoinPool</strong></td><td><code>ForkJoinPool</code> supports work-stealing, ideal for recursive and parallel tasks.</td></tr><tr><td>You need to execute <strong>stream operations in parallel</strong></td><td><strong>Parallel Streams</strong></td><td><code>stream().parallel()</code> splits work across multiple cores automatically.</td></tr><tr><td>You need to process <strong>a collection of tasks asynchronously</strong></td><td><strong>CompletableFuture</strong></td><td><code>CompletableFuture</code> allows non-blocking execution and chaining tasks together.</td></tr><tr><td>You need to execute <strong>a task with a timeout</strong></td><td><strong>ExecutorService + Future.get(timeout)</strong></td><td><code>Future.get(timeout, TimeUnit.SECONDS)</code>prevents indefinite waiting.</td></tr><tr><td>You need to execute a task <strong>in the background and monitor progress</strong></td><td><strong>CompletableFuture + thenApply/thenAccept</strong></td><td><code>CompletableFuture</code> allows progress tracking and callbacks.</td></tr><tr><td>You need <strong>non-blocking, event-driven async execution</strong></td><td><strong>CompletableFuture + SupplyAsync()</strong></td><td>Asynchronous execution without blocking threads.</td></tr></tbody></table>
