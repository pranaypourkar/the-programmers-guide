# Future v/s CompletableFuture

## About

`Future` and `CompletableFuture` are both used in Java for handling asynchronous tasks, but they have differences in terms of functionality, ease of use, and features.

**`Future`**:

* Introduced in Java 5 as part of the `java.util.concurrent` package.
* Represents the result of an asynchronous computation. You can check if the computation is complete, retrieve the result, and cancel the computation.
* `Future` is essentially a placeholder for a result that may not be available yet.

**`CompletableFuture`**:

* Introduced in Java 8 as part of the `java.util.concurrent` package.
* A more advanced version of `Future` that supports non-blocking operations, chaining, combining multiple futures, and more complex asynchronous computations.
* `CompletableFuture` implements both `Future` and `CompletionStage`, providing a comprehensive API for working with asynchronous tasks.

## **Blocking vs Non-Blocking**

**`Future`**:

* **Blocking**: The `get()` method is blocking, meaning the calling thread will wait until the task is completed or an exception occurs.
* No easy way to compose multiple `Future` objects or handle results without blocking the thread.

**`CompletableFuture`**:

* **Non-Blocking**: Supports non-blocking operations through methods like `thenApply()`, `thenAccept()`, `thenRun()`, and `thenCompose()`.
* Allows chaining of tasks and provides a more fluent API for asynchronous programming without blocking the main thread.

{% hint style="info" %}
In traditional blocking code, when we call a method like `get()` on a `Future`, the calling thread waits (or blocks) until the task completes. This can lead to inefficient use of resources, especially if the task is I/O-bound or long-running. Non-blocking code, on the other hand, allows the calling thread to continue executing other tasks while the asynchronous task runs in the background.

`CompletableFuture` allows to attach callback functions (continuations) that are automatically executed when the future completes. These callbacks are non-blocking because they are executed asynchronously, meaning the calling thread is not blocked waiting for the future to complete.

Eg.

```java
CompletableFuture<String> future = CompletableFuture.supplyAsync(() -> {
    return "Hello";
});

CompletableFuture<String> transformedFuture = future.thenApply(result -> {
    return result + " World";
});

transformedFuture.thenAccept(System.out::println); // Output: Hello World
```
{% endhint %}

## **Ease of Use**

**`Future`**:

* Requires an `ExecutorService` to submit tasks.
* Limited API with only basic operations like `get()`, `cancel()`, `isDone()`, and `isCancelled()`.
* Complex to manage multiple futures and combine their results.

**`CompletableFuture`**:

* More intuitive and feature-rich API.
* Can be created and completed manually (`CompletableFuture.supplyAsync()`, `CompletableFuture.runAsync()`).
* Provides a variety of methods for composing and combining multiple futures (`thenCombine()`, `thenAcceptBoth()`, `allOf()`, `anyOf()`).

## **Exception Handling**

**`Future`**:

* Handles exceptions through the `ExecutionException` thrown by `get()`.
* No built-in support for handling exceptions as part of the future’s lifecycle.

**`CompletableFuture`**:

* Built-in methods for exception handling (`handle()`, `exceptionally()`, `whenComplete()`).
* Allows to recover from exceptions, chain error-handling code, and maintain clean and readable code.

## **Completion**

**`Future`**:

* Once the task is submitted, you can only wait for its completion or cancel it. There is no way to manually complete a `Future`.

**`CompletableFuture`**:

* Can be manually completed using methods like `complete()`, `completeExceptionally()`, and `obtrudeValue()`.
* Allows to programmatically set the result or handle errors without relying on an asynchronous task's completion.

## **Combining Multiple Futures**

**`Future`**:

* No direct support for combining results from multiple `Future` instances.
* Requires custom logic or external libraries to handle complex scenarios like waiting for multiple futures to complete.

**`CompletableFuture`**:

* Provides powerful methods like `thenCombine()`, `allOf()`, and `anyOf()` to combine multiple `CompletableFuture` instances.
* Simplifies scenarios where multiple asynchronous tasks need to be coordinated or combined.

## **Asynchronous Execution**

**`Future`**:

* Task submission and execution are typically managed through an `ExecutorService`, and once submitted, you wait for the result.
* No built-in support for starting tasks asynchronously without an `ExecutorService`.

**`CompletableFuture`**:

* Supports asynchronous execution directly through methods like `supplyAsync()` and `runAsync()`, which accept an `Executor` or use the common fork-join pool by default.
* Ideal for writing non-blocking, asynchronous code that can be easily scaled and managed.

## Example

**`Future` Example**:

```java
ExecutorService executor = Executors.newSingleThreadExecutor();
Future<String> future = executor.submit(() -> {
    Thread.sleep(2000);
    return "Task Result";
});

try {
    String result = future.get();  // Blocking call
    System.out.println(result);
} catch (InterruptedException | ExecutionException e) {
    e.printStackTrace();
} finally {
    executor.shutdown();
}
```

**`CompletableFuture` Example**:

```java
CompletableFuture<String> future = CompletableFuture.supplyAsync(() -> {
    try {
        Thread.sleep(2000);
    } catch (InterruptedException e) {
        throw new IllegalStateException(e);
    }
    return "Task Result";
});

future.thenAccept(result -> System.out.println("Result: " + result))
      .exceptionally(ex -> {
          System.out.println("Exception: " + ex.getMessage());
          return null;
      });
```

## **When to Use Which?**

**`Future`**:

* Use `Future` when we need a simple mechanism to get the result of a single asynchronous task, and don’t require complex composition or non-blocking behavior.

**`CompletableFuture`**:

* Use `CompletableFuture` when we need advanced asynchronous programming features, such as chaining, combining multiple futures, non-blocking calls, and more complex error handling. It’s the preferred choice for modern Java asynchronous programming.
