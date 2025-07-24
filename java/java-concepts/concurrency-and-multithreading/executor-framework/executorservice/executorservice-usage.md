# ExecutorService Usage

The `ExecutorService` in Java is a higher-level replacement for managing threads and tasks, providing a framework for concurrent task execution. It abstracts away the complexities of creating and managing threads directly. There are a several ways to delegate tasks for execution to an `ExecutorService.`

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

* The Java `ExecutorService` `submit(Runnable)` method also takes a `Runnable` implementation, but returns a `Future` object. This `Future` object can be used to check if the `Runnable` has finished executing.

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

* Submits a `Callable` task for execution and returns a `Future` representing the task’s result.

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

We can cancel a task (`Runnable` or `Callable`) submitted to a Java `ExecutorService` by calling the `cancel()` method on the `Future` returned when the task is submitted. Cancelling the task is only possible if the task has not yet started executing.

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
