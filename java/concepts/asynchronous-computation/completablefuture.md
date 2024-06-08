# CompletableFuture

Java **CompletableFuture** is a class introduced in Java 8 as part of the _**java.util.concurrent**_ package that implements the **Future** and **CompletionStage** Interface. It represents a future result of an asynchronous computation that might not be available immediately. It acts like a placeholder for the eventual outcome of an operation that's being executed concurrently by different thread. It provides a way to write asynchronous, non-blocking code in Java, especially when dealing with tasks that might take a long time to complete, such as network requests or database queries.

### Advantages:

* **Asynchronous Programming**: CompletableFuture enables you to execute long-running task/tasks without blocking the current thread. This allows the application to remain responsive and handle other requests while the asynchronous operations are in progress.&#x20;
* **Composable Operations**: CompletableFuture provides a vast set of methods to chain together multiple asynchronous operations, forming complex workflows. We can define what happens after a computation finishes successfully (**thenApply**, **thenAccept**), what to do if it encounters an exception (**exceptionally**), and how to combine results from multiple CompletableFutures (**allOf**, **anyOf**).&#x20;
* **Improved Error Handling**: CompletableFuture offers more complex mechanisms for handling exceptions that arise during asynchronous computations. We can define fallback actions using **exceptionally** and propagate or chain exceptions using methods like handle.



### Some Key Points:

* `supplyAsync`

`supplyAsync(Supplier<U> supplier, Executor executor)`: This method initiates an asynchronous task that returns a value of type `U`. The provided `Supplier` is executed asynchronously, and the result is wrapped in a `CompletableFuture`. An optional `Executor` can be provided to specify the thread pool where the computation will be executed.

* `runAsync`

`runAsync(Runnable runnable, Executor executor)`: Similar to `supplyAsync()`, but for tasks that do not return a value. The provided `Runnable` is executed asynchronously, and the resulting `CompletableFuture` completes when the task finishes.



{% hint style="info" %}
The `executor` parameter is an optional `Executor` that specifies where the async computation will be executed. If provided, the async computation will be executed on the specified `Executor`. If not provided, the async computation will be executed on the default `ForkJoinPool.commonPool()`

Specifying an `Executor` allows to control the execution context of the async computation. We can use a custom `Executor` to control factors such as the number of threads, thread priority, or even to execute tasks on a specific thread, providing more control over concurrency and resource utilization in the application.

**Example**:

```java
// Create a fixed-size thread pool with 5 threads
Executor executor = Executors.newFixedThreadPool(5);

CompletableFuture<String> completableFuture = CompletableFuture.supplyAsync(() -> {
   // Perform async computation
   return "Result";
}, executor); // Execute the async computation on the custom Executor
// Continue with other tasks...
```
{% endhint %}



* `thenApply`

`thenApply(Function<? super T,? extends U> fn)`: This method specifies a function to be applied to the result of the current `CompletableFuture` when it completes. It returns a new `CompletableFuture` that holds the result of the function.

* `thenAccept`

`thenAccept(Consumer<? super T> action)`: Similar to `thenApply()`, but for cases where you want to perform an action (such as printing or logging) on the result without returning a value. It accepts a `Consumer` that takes the result as input.

* `thenCombine`

`thenCombine(CompletionStage<? extends U> other, BiFunction<? super T,? super U,? extends V> fn)`: This method combines the result of the current `CompletableFuture` with the result of another `CompletionStage` when both are complete. It applies the specified function to the results of both stages and returns a new `CompletableFuture` holding the combined result.

* `thenCompose`

`thenCompose(Function<? super T,? extends CompletionStage<U>> fn)`: This method applies a function to the result of the current `CompletableFuture` and returns a new `CompletionStage`. It's useful for chaining dependent asynchronous tasks where the result of one task determines the execution of another.

{% hint style="info" %}
**What it Does is it -**&#x20;

* **Waits for Completion:**`thenCompose` waits for the current `CompletableFuture` to complete.
* **Applies Function:** Once the current `CompletableFuture` finishes, `thenCompose` applies the provided function (`fn`) to its result (of type `T`).
* **Chains Another Operation:** The function (`fn`) is expected to return a new `CompletionStage<U>`. This creates a new asynchronous operation that will be executed after the current one finishes.
* **Returns New CompletableFuture:** `thenCompose` returns a new `CompletableFuture<U>` that represents the result of the chained operation.
{% endhint %}

* `exceptionally`

`exceptionally(Function<Throwable,? extends T> fn)`: This method handles exceptions that occur during the execution of the current `CompletableFuture`. It applies the specified function to the exception and returns a new `CompletableFuture` with the result of the function, effectively recovering from the exception.

* `exceptionallyAsync`

`exceptionallyAsync(Function<Throwable, ? extends T> fn)`: This method is also used for handling exceptions that may occur during the execution of the asynchronous computation. However, it differs from `exceptionally`  in how it handle the execution context (thread) in which the exception handling function is invoked.

{% hint style="info" %}
`exceptionally(Function<Throwable, ? extends T> fn)`:

* This method is synchronous, meaning the provided exception handling function (`Function`) is executed in the same thread where the exception occurred.
* It's suitable for simple exception handling scenarios where the recovery logic is not computationally intensive and does not involve blocking operations.
* The computation of the fallback value happens synchronously, potentially blocking the thread until the recovery logic completes.

`exceptionallyAsync(Function<Throwable, ? extends T> fn)`:

* This method is asynchronous, meaning the provided exception handling function (`Function`) is executed in a separate thread from the one where the exception occurred.
* It's suitable for complex exception handling scenarios where the recovery logic might involve heavy computation or blocking operations.
* The computation of the fallback value happens asynchronously, allowing the main program to continue executing other tasks while the recovery logic runs concurrently.
{% endhint %}

* `handle`

`handle(BiFunction<? super T,Throwable,? extends U> fn)`: Similar to `exceptionally()`, but the function provided can handle both the result and any exception that occurs during the execution of the current `CompletableFuture.` If an exception occurs during the execution, the `handle()` function receives the exception object and if no exception occurs, the `handle()` function receives the result, and we modify it.

* `allOf`

`allOf(CompletableFuture<?>... cfs)`: This method waits for all of the provided `CompletableFutures` to complete. It returns a new `CompletableFuture` that completes when all of the provided `CompletableFutures` are done, regardless of their individual results.

* `anyOf`

`anyOf(CompletableFuture<?>... cfs)`: This method waits for any of the provided `CompletableFutures` to complete. It returns a new `CompletableFuture` that completes when any of the provided `CompletableFutures` completes, with the result of the first completed `CompletableFuture`.

* `orTimeout`

`orTimeout(long timeout, TimeUnit unit):`This method sets a timeout for the completion of the future. If the future does not complete within the specified timeout duration, it completes exceptionally with a `TimeoutException`. It's useful when you want to handle the timeout by throwing an exception. The timeout is set on the original CompletableFuture, and if the timeout occurs, the CompletableFuture itself is completed exceptionally.

* `completeOnTimeout`

`completeOnTimeout(T value, long timeout, TimeUnit unit)`: This method sets a timeout for the completion of the future. If the future does not complete within the specified timeout duration, it completes with the provided value. It's useful when you want to **handle the timeout by providing a fallback value instead of throwing an exception**. The timeout is set on a new CompletableFuture derived from the original CompletableFuture, and if the timeout occurs, the new CompletableFuture is completed with the specified value, while the original CompletableFuture remains incomplete.

* `cancel`

`cancel(boolean mayInterruptIfRunning)`: This method cancels the computation associated with the current `CompletableFuture`, if possible.

* `join`

`join()`: This method waits for the completion of the current `CompletableFuture` and returns its result, blocking if necessary until the result is available.

* `get`

`get()`: This method is similar to `join()` i.e. wait (block) the current thread until the `CompletableFuture` finishes its execution, but it can throw checked exceptions. It waits for the completion of the current `CompletableFuture` and returns its result, but it also throws any exception that occurred during the computation, wrapped in a `ExecutionException`.

{% hint style="info" %}
&#x20;_**get vs join ?**_

**Exception Handling:**

* **`get()`:** Throws two types of checked exceptions:
  * `ExecutionException`: If the asynchronous computation running within the `CompletableFuture` throws an exception.
  * `InterruptedException`: If the current thread is interrupted while waiting for the `CompletableFuture` to complete.
* **`join()`:** Throws a single unchecked exception:
  * `CompletionException`: Wraps the original exception that occurred during the asynchronous computation.

**Usability in Streams:**

* **`get()`:** Cannot be used directly within streams due to the checked exceptions it throws. Additional exception handling is required.
* **`join()`:** Can be used within streams using method references because it throws an unchecked exception. This makes it more convenient for concise stream operations.
{% endhint %}



### Example:

1. Creating a single CompletableFuture using **`supplyAsync`.**

```java
package org.example;

import lombok.extern.slf4j.Slf4j;

import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;

@Slf4j
public class MainApplication {
    public static void main(String[] args) throws ExecutionException, InterruptedException {

        // supplyAsync method takes a Supplier<U> function
        CompletableFuture<String> completableFuture = CompletableFuture.supplyAsync(() -> {
            // Perform some async computation
            log.info("Performing some async computation");
            return "Returning the result";
        });

        log.info("Continuing with main process");
        // get method waits if necessary for the future to complete, and then returns its result
        log.info(completableFuture.get());
    }
}
```

<figure><img src="../../../.gitbook/assets/image (34).png" alt=""><figcaption></figcaption></figure>

2. Multiple asynchronous operations using **`supplyAsync`.**

```java
package org.example;

import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;

import java.util.concurrent.CompletableFuture;

@Slf4j
public class MainApplication {

    @SneakyThrows
    public static void main(String[] args)  {

        CompletableFuture<String> completableFuture_1 = CompletableFuture.supplyAsync(() -> {
            log.info("Performing some async computation with completableFuture_1");
            return "Returning the result with completableFuture_1";
        });

        CompletableFuture<String> completableFuture_2 = CompletableFuture.supplyAsync(() -> {
            log.info("Performing some async computation with completableFuture_2");
            return "Returning the result with completableFuture_2";
        });

        CompletableFuture<String> completableFuture_3 = CompletableFuture.supplyAsync(() -> {
            log.info("Performing some async computation with completableFuture_3");
            return "Returning the result with completableFuture_3";
        });

        log.info("Continuing with main process");
        CompletableFuture<Void> combinedFuture = CompletableFuture.allOf(completableFuture_1, completableFuture_2, completableFuture_3);
        combinedFuture.get();

        log.info("completableFuture_1 Result: {}", completableFuture_1.get());
        log.info("completableFuture_2 Result: {}", completableFuture_2.get());
        log.info("completableFuture_3 Result: {}", completableFuture_3.get());
    }
}
```

<figure><img src="../../../.gitbook/assets/image (35).png" alt=""><figcaption></figcaption></figure>

3. Creating a single CompletableFuture using **`runAsync`.**

```java
// runAsync method takes a Runnable function
CompletableFuture<Void> completableFuture = CompletableFuture.runAsync(() -> {
    // Perform some async computation
    log.info("Performing some async computation");
});

// Main process continues
log.info("Continuing with main process");

// get method waits if necessary for the future to complete
// Since the computation doesn't return a value, we just wait for it to complete
completableFuture.get();
```

<figure><img src="../../../.gitbook/assets/image (38).png" alt=""><figcaption></figcaption></figure>

4. Example using **`thenApply`.**

```java
CompletableFuture<String> completableFuture = CompletableFuture.supplyAsync(() -> {
    // Perform some async computation
    return "Hello";
});

// thenApply method applies a function to the result of the CompletableFuture
CompletableFuture<String> futureResult = completableFuture.thenApply(result -> result + " World");

log.info("Continuing with main process");
log.info(futureResult.get());
```

<figure><img src="../../../.gitbook/assets/image (39).png" alt=""><figcaption></figcaption></figure>

5. Example using **`thenAccept`**.

```java
CompletableFuture<String> completableFuture = CompletableFuture.supplyAsync(() -> {
    // Perform some async computation
    return "Hello";
});

// thenAccept method performs an action on the result without returning a value
CompletableFuture<Void> futureResult = completableFuture.thenAccept(result -> log.info(result + " World"));

// Waits for the action to complete
futureResult.get();
```

<figure><img src="../../../.gitbook/assets/image (40).png" alt=""><figcaption></figcaption></figure>

6. Example using **`thenCombine`**.

```java
CompletableFuture<String> completableFuture1 = CompletableFuture.supplyAsync(() -> "Hello");
CompletableFuture<String> completableFuture2 = CompletableFuture.supplyAsync(() -> "World");

// thenCombine method combines the results of two CompletableFutures
CompletableFuture<String> futureResult = completableFuture1
        .thenCombine(completableFuture2, (result1, result2) -> result1 + " " + result2);

log.info(futureResult.get()); // Prints "Hello World"
```

<figure><img src="../../../.gitbook/assets/image (41).png" alt=""><figcaption></figcaption></figure>

7. Example using **`thenCompose`** .

```java
CompletableFuture<String> completableFuture1 = CompletableFuture.supplyAsync(() -> "Hello");

// thenCompose method applies a function that returns a new CompletionStage
CompletableFuture<String> futureResult = completableFuture1
        .thenCompose(result -> CompletableFuture.supplyAsync(() -> result + " World"));

log.info(futureResult.get()); // Prints "Hello World"
```

<figure><img src="../../../.gitbook/assets/image (42).png" alt=""><figcaption></figcaption></figure>

8. Example using **`orTimeout`** and **`exceptionallyAsync`**

```java
package org.example;

import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;

import java.util.concurrent.CompletableFuture;
import java.util.concurrent.TimeUnit;

@Slf4j
public class MainApplication {

    @SneakyThrows
    public static void main(String[] args)  {
        CompletableFuture<String> completableFuture = CompletableFuture.supplyAsync(() -> getSomeDataFromExternalService())
                .orTimeout(7, TimeUnit.SECONDS)
                .exceptionallyAsync(ex -> {
                    log.error("Some error occurred");
                    return "Some fallback value";
                });
        // exceptionallyAsync method handles the exception and provides a fallback value
        log.info("Response: {}", completableFuture.get());
    }

    static String getSomeDataFromExternalService() {
        log.info("Fetching data from external service");

        throw new RuntimeException("Got some exception");
    }
}
```

<figure><img src="../../../.gitbook/assets/image (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

9. Example using **`exceptionally`**.

```java
@SneakyThrows
public static void main(String[] args)  {
    CompletableFuture<String> completableFuture = CompletableFuture.supplyAsync(MainApplication::getSomeDataFromExternalService)
            .exceptionally(ex -> {
                log.error("Some error occurred");
                return "Some fallback value";
            });
    // exceptionally method handles the exception and provides a fallback value
    log.info("Response: {}", completableFuture.get());
}

static String getSomeDataFromExternalService() {
    log.info("Fetching data from external service");
    throw new RuntimeException("Got some exception");
}
```

<figure><img src="../../../.gitbook/assets/image (2) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

10. Example using **`orTimeout`**.

```java
CompletableFuture<String> completableFuture = CompletableFuture.supplyAsync(() -> {
    try {
        Thread.sleep(5000); // Simulate a long-running computation
        return "Result";
    } catch (InterruptedException e) {
        return "Interrupted";
    }
}).orTimeout(2000, TimeUnit.MILLISECONDS);

try {
    log.info("orTimeout result: {}", completableFuture.get());
} catch (Exception e) {
    log.info("orTimeout exception: {}", e.getMessage()); // Will throw a TimeoutException
}
```

<figure><img src="../../../.gitbook/assets/image (3) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

11. Example using **`completeOnTimeout`**.

```java
CompletableFuture<String> completableFuture = CompletableFuture.supplyAsync(() -> {
    try {
        Thread.sleep(5000); // Simulate a long-running computation
        return "Result";
    } catch (InterruptedException e) {
        return "Interrupted";
    }
}).completeOnTimeout("Fallback Value", 2000, TimeUnit.MILLISECONDS);

try {
    log.info("completeOnTimeout result: {}", completableFuture.get());
} catch (Exception e) {
    log.info("completeOnTimeout exception: {}", e.getMessage()); // Will print "Fallback Value"
}
```

<figure><img src="../../../.gitbook/assets/image (4) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

12. Example using **`handle`**.

```java
// Example CompletableFuture that can throw an exception
CompletableFuture<Integer> completableFuture = CompletableFuture.supplyAsync(() -> {
    // Simulate an exception
    throw new RuntimeException("Exception occurred");
}).handle((result, exception) -> {
    if (exception != null) {
        log.info("Exception occurred: {}", exception.getMessage());
        return 0; // Fallback value in case of exception
    } else {
        return (Integer) result * 2; // Modify the result
    }
});

log.info("Result: {}", completableFuture.get()); // Prints "Result: 0" because of the exception
```

<figure><img src="../../../.gitbook/assets/image (5) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

13. Example using **`allOf`**`.`

```java
CompletableFuture<String> future1 = CompletableFuture.supplyAsync(() -> "Result 1");
CompletableFuture<String> future2 = CompletableFuture.supplyAsync(() -> "Result 2");
CompletableFuture<String> future3 = CompletableFuture.supplyAsync(() -> "Result 3");

CompletableFuture<Void> allFutures = CompletableFuture.allOf(future1, future2, future3);

allFutures.get(); // Waits for all futures to complete

log.info("All futures completed successfully");
```

<figure><img src="../../../.gitbook/assets/image (6) (1) (1) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

14. Example using **`anyOf`**`.`

```java
CompletableFuture<String> future1 = CompletableFuture.supplyAsync(() -> {
    try {
        Thread.sleep(2000);
    } catch (InterruptedException e) {
        e.printStackTrace();
    }
    return "Result 1";
});

CompletableFuture<String> future2 = CompletableFuture.supplyAsync(() -> {
    try {
        Thread.sleep(1000);
    } catch (InterruptedException e) {
        e.printStackTrace();
    }
    return "Result 2";
});

CompletableFuture<Object> anyFuture = CompletableFuture.anyOf(future1, future2);

log.info("First future completed: {}", anyFuture.get()); // Waits for any future to complete
```

<figure><img src="../../../.gitbook/assets/image (7) (1) (1).png" alt=""><figcaption></figcaption></figure>

15. Example using **`cancel`**.

```java
CompletableFuture<String> completableFuture = CompletableFuture.supplyAsync(() -> {
    try {
        log.info("Started Processing something");
        Thread.sleep(3000);
        log.info("Processing completed");
        return "Result";
    } catch (InterruptedException e) {
        return "Exception occurred";
    }
});

// Attempt to cancel the computation
// true indicates that interrupt should be sent to the thread if it's running
boolean cancelled = completableFuture.cancel(true);

log.info("Computation cancelled: {}", cancelled);
// Check if the computation was successfully cancelled before retrieving the result
if (!cancelled) {
    log.info("Result: {}", completableFuture.get()); // Prints "Result" if not cancelled
} else {
    log.info("Computation was cancelled, no result available");
}
```

<figure><img src="../../../.gitbook/assets/image (8) (1) (1).png" alt=""><figcaption></figcaption></figure>

16. Example using **`get`** and **`join`**.

```java
CompletableFuture<String> completableFuture = CompletableFuture.supplyAsync(() -> {
    throw new ArithmeticException();
});

// Using get()
try {
    String result = completableFuture.get(); // Throws checked exceptions (InterruptedException, ExecutionException)
    log.info("Result using get(): {}", result); // Will not be printed
} catch (ExecutionException e) {
    log.info("Exception occurred: {}", e.getMessage());
}

// Using join()
try {
    String result = completableFuture.join(); // Throws unchecked exceptions (CompletionException)
    log.info("Result using get(): {}", result); // Will not be printed
} catch (CompletionException e) {
    log.info("Exception occurred: {}", e.getMessage());
}
```

<figure><img src="../../../.gitbook/assets/image (43).png" alt=""><figcaption></figcaption></figure>



### Use Cases:

#### When we have a list of account IDs and want to fetch the balance with the help of those IDs by calling external API parallelly.

```java
package org.example;

import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;

import java.util.List;
import java.util.concurrent.CompletableFuture;

@Slf4j
public class MainApplication {

    @SneakyThrows
    public static void main(String[] args)  {

        List<String> accountIdList = List.of("Account1", "Account2", "Account3", "Account4", "Account5");
        var balanceTask = accountIdList
                .stream()
                .map(MainApplication::getBalance)
                .toList();

        log.info("Main process continues");
        CompletableFuture.allOf(balanceTask.toArray(new CompletableFuture[balanceTask.size()])).get();

        for (CompletableFuture<String> balance : balanceTask) {
            log.info("Balance: {}", balance.get());
        }
    }

    static CompletableFuture<String> getBalance(String accountId) {
        // Fetch the balance by calling some external api
        return CompletableFuture.supplyAsync(() -> {
            log.info("Calling some External API to fetch balance for {}", accountId);
            return "BalanceFor" + accountId;
        });
    }
}
```

<figure><img src="../../../.gitbook/assets/image (36).png" alt=""><figcaption></figcaption></figure>









