# ExecutorService Usage

The `ExecutorService` in Java is a higher-level replacement for managing threads and tasks, providing a framework for concurrent task execution. It abstracts away the complexities of creating and managing threads directly. There are a several  ways to delegate tasks for execution to an `ExecutorService.`

## Creating an `ExecutorService`

Refer to the [executorservice-implementations.md](executorservice-implementations.md "mention")for more details.

```java
// Fixed Thread Pool
ExecutorService fixedThreadPool = Executors.newFixedThreadPool(10);
// Cached Thread Pool
ExecutorService cachedThreadPool = Executors.newCachedThreadPool();
// Single Thread Executor
ExecutorService singleThreadExecutor = Executors.newSingleThreadExecutor();
// Scheduled Thread Pool
ScheduledExecutorService scheduledExecutorService = Executors.newScheduledThreadPool(5);
```

## Submitting Tasks to `ExecutorService`

### **`execute(Runnable command)`**:

* Executes the given command at some point in the future asynchronously.
* No result is returned, and exceptions are not captured.

Example:

```java
fixedThreadPool.execute(() -> System.out.println("Task executed"));
```

```java
ExecutorService executorService = Executors.newSingleThreadExecutor();

executorService.execute(new Runnable() {
    public void run() {
        System.out.println("Asynchronous task");
    }
});

executorService.shutdown();
```

### **`submit(Runnable command)`**:

* The Java `ExecutorService` `submit(Runnable)` method also takes a `Runnable` implementation, but returns a `Future` object. This `Future` object can be used to check if the `Runnable` has finished executing.&#x20;

Example:

```java
Future future = executorService.submit(new Runnable() {
    public void run() {
        System.out.println("Asynchronous task");
    }
});

future.get();  //returns null if the task has finished correctly.
```



### **`submit(Callable<T> task)`**:

* Submits a `Callable` task for execution and returns a `Future` representing the task’s result.&#x20;

Example:

```java
Future<Integer> future = fixedThreadPool.submit(() -> {
    return 42;
})
```

### **`invokeAll(Collection<? extends Callable<T>> tasks)`**:

* Executes a collection of `Callable` tasks and returns a list of `Future` objects.
* The `invokeAll()` method invokes all of the `Callable` objects passed to it in the collection passed as parameter. The `invokeAll()` returns a list of `Future` objects via which we can obtain the results of the executions of each `Callable`. A task might finish due to an exception, so it may not have succeeded. There is no way on a `Future`to tell the difference.
* If an exception occurs during the execution of one of the `Callable` tasks, that exception will be captured and stored within the corresponding `Future` object.

Example:

```java
List<Callable<String>> tasks = Arrays.asList(
    () -> "Task 1",
    () -> "Task 2",
    () -> "Task 3"
);
List<Future<String>> futures = fixedThreadPool.invokeAll(tasks);
```

**Exception During Task Execution**:

* If an exception occurs during the execution of one of the `Callable` tasks, that exception will be captured and stored within the corresponding `Future` object.
*   The `invokeAll()` method itself will not throw an exception in this case. Instead, you will need to check each `Future` for exceptions by calling `future.get()` on them.

    ```java
    try {
        List<Future<String>> futures = fixedThreadPool.invokeAll(tasks);
        for (Future<String> future : futures) {
            try {
                String result = future.get();  // Retrieves the result or throws an ExecutionException
                System.out.println(result);
            } catch (ExecutionException e) {
                System.err.println("Task failed: " + e.getCause());
            }
        }
    } catch (InterruptedException e) {
        System.err.println("Task execution was interrupted: " + e.getMessage());
    }
    ```

**InterruptedException**:

* The `invokeAll()` method may throw an `InterruptedException` if the calling thread is interrupted while waiting for the tasks to complete.
*   This exception needs to be handled explicitly. When this happens, none of the results will be available, and the thread's interrupted status will be set.

    ```java
    try {
        List<Future<String>> futures = fixedThreadPool.invokeAll(tasks);
        // Process futures
    } catch (InterruptedException e) {
        // Handle the interruption
        Thread.currentThread().interrupt();  // Preserve interrupt status
        System.err.println("Task execution was interrupted: " + e.getMessage());
    }
    ```

**Rejection During Task Submission**:

* `invokeAll()` will not submit tasks one by one; it submits all tasks as a batch. If the `ExecutorService` is shutting down or if its task queue is full, it will reject all tasks and throw a `RejectedExecutionException`. However, `invokeAll()` is designed to handle such situations internally, and this is generally not a concern unless we are dealing with a custom implementation.

### **`invokeAny(Collection<? extends Callable<T>> tasks)`**:

* Executes the given tasks and returns the result of one that successfully completes (or throws an exception if none complete).
* The `invokeAny()` method takes a collection of `Callable` objects, or subinterfaces of `Callable`. Invoking this method does not return a `Future`, but returns the result of one of the `Callable` objects. We have no guarantee about which of the `Callable`'s results we will get. Just one of the ones that finish. If one Callable finishes, so that a result is returned from `invokeAny()`, then the rest of the Callable instances are cancelled. If one of the tasks complete (or throws an exception), the rest of the `Callable`'s are cancelled.

Example:

```java
List<Callable<String>> tasks = Arrays.asList(
    () -> "Task 1",
    () -> "Task 2",
    () -> "Task 3"
);
String result = fixedThreadPool.invokeAny(tasks);
```

```java
ExecutorService executorService = Executors.newSingleThreadExecutor();

Set<Callable<String>> callables = new HashSet<Callable<String>>();

callables.add(new Callable<String>() {
    public String call() throws Exception {
        return "Task 1";
    }
});
callables.add(new Callable<String>() {
    public String call() throws Exception {
        return "Task 2";
    }
});
callables.add(new Callable<String>() {
    public String call() throws Exception {
        return "Task 3";
    }
});

String result = executorService.invokeAny(callables);

System.out.println("result = " + result);

executorService.shutdown();
```

### `cancel()`

We can cancel a task (`Runnable` or `Callable`) submitted to a Java `ExecutorService` by calling the `cancel()` method on the `Future` returned when the task is submitted. Cancelling the task is only possible if the task has not yet started executing.&#x20;

```java
future.cancel();
```

## **Managing ExecutorService Lifecycle**

### **Shutting Down**:

* It’s essential to shut down the `ExecutorService` to free resources when tasks are no longer needed.
* **`shutdown()`**: Initiates an orderly shutdown where previously submitted tasks are executed, but no new tasks will be accepted.
* **`shutdownNow()`**: Attempts to stop all actively executing tasks and halts the processing of waiting tasks.

Example:

```java
fixedThreadPool.shutdown();  // Initiates shutdown
fixedThreadPool.awaitTermination(60, TimeUnit.SECONDS);  // Waits for termination
```

### **Checking for Termination**:

* **`isShutdown()`**: Returns `true` if the `ExecutorService` has been shut down.
* **`isTerminated()`**: Returns `true` if all tasks have completed following shutdown.

Example:

```java
if (fixedThreadPool.isTerminated()) {
    System.out.println("All tasks completed");
}
```

## Others Details

### Runnable vs Callable

In Java, both `Runnable` and `Callable` interfaces are used to represent tasks that are intended to be executed by another thread, typically within the context of an `ExecutorService`

#### **1. Runnable Interface**

* **Definition**: The `Runnable` interface is a functional interface that represents a task that can be run by a thread. It contains a single abstract method `run()` that does not return any result and cannot throw checked exceptions.
*   **Signature**:

    ```java
    @FunctionalInterface
    public interface Runnable {
        void run();
    }
    ```
* **Characteristics**:
  * **No Return Value**: The `run()` method does not return any value. It is suitable for tasks that perform an action but do not need to return a result.
  * **No Checked Exceptions**: The `run()` method cannot throw checked exceptions, only runtime exceptions are allowed.
  * **Common Usage**: Typically used for tasks where the result is not required, such as background tasks or side effects like logging.
*   **Example**:

    ```java
    Runnable task = () -> System.out.println("Task is running");
    Thread thread = new Thread(task);
    thread.start();
    ```

#### **2. Callable Interface**

* **Definition**: The `Callable` interface is a functional interface that represents a task that returns a result and may throw a checked exception. It contains a single abstract method `call()`.
*   **Signature**:

    ```java
    @FunctionalInterface
    public interface Callable<V> {
        V call() throws Exception;
    }
    ```
* **Characteristics**:
  * **Return Value**: The `call()` method returns a result of type `V`. This makes `Callable` more powerful when you need to return a result after the task's execution.
  * **Checked Exceptions**: The `call()` method can throw checked exceptions, making it more flexible for tasks that might encounter errors during execution.
  * **Common Usage**: Used when you need to perform a task that returns a result, such as computing a value, processing data, or any operation where the outcome needs to be captured.
*   **Example**:

    ```java
    Callable<Integer> task = () -> {
        return 42;
    };
    ExecutorService executor = Executors.newFixedThreadPool(1);
    Future<Integer> future = executor.submit(task);
    Integer result = future.get(); // Returns 42
    ```



<table data-full-width="true"><thead><tr><th width="211">Aspect</th><th>Runnable</th><th>Callable</th></tr></thead><tbody><tr><td><strong>Return Type</strong></td><td><code>void</code></td><td>Generic type <code>V</code></td></tr><tr><td><strong>Method</strong></td><td><code>run()</code></td><td><code>call()</code></td></tr><tr><td><strong>Checked Exceptions</strong></td><td>Cannot throw checked exceptions</td><td>Can throw checked exceptions</td></tr><tr><td><strong>Use Case</strong></td><td>Tasks that don't require a result</td><td>Tasks that need to return a result</td></tr><tr><td><strong>Integration with ExecutorService</strong></td><td>Submitted using <code>execute(Runnable)</code> or <code>submit(Runnable)</code></td><td>Submitted using <code>submit(Callable&#x3C;V>)</code></td></tr></tbody></table>



