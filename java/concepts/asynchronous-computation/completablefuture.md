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

* `thenApply`

`thenApply(Function<? super T,? extends U> fn)`: This method specifies a function to be applied to the result of the current `CompletableFuture` when it completes. It returns a new `CompletableFuture` that holds the result of the function.

* `thenAccept`

`thenAccept(Consumer<? super T> action)`: Similar to `thenApply()`, but for cases where you want to perform an action (such as printing or logging) on the result without returning a value. It accepts a `Consumer` that takes the result as input.

* `thenCombine`

`thenCombine(CompletionStage<? extends U> other, BiFunction<? super T,? super U,? extends V> fn)`: This method combines the result of the current `CompletableFuture` with the result of another `CompletionStage` when both are complete. It applies the specified function to the results of both stages and returns a new `CompletableFuture` holding the combined result.

* `thenCompose`

`thenCompose(Function<? super T,? extends CompletionStage<U>> fn)`: This method applies a function to the result of the current `CompletableFuture` and returns a new `CompletionStage`. It's useful for chaining dependent asynchronous tasks where the result of one task determines the execution of another

* `exceptionally`

`exceptionally(Function<Throwable,? extends T> fn)`: This method handles exceptions that occur during the execution of the current `CompletableFuture`. It applies the specified function to the exception and returns a new `CompletableFuture` with the result of the function, effectively recovering from the exception.

* `handle`

`handle(BiFunction<? super T,Throwable,? extends U> fn)`: Similar to `exceptionally()`, but the function provided can handle both the result and any exception that occurs during the execution of the current `CompletableFuture`

* `allOf`

`allOf(CompletableFuture<?>... cfs)`: This method waits for all of the provided `CompletableFutures` to complete. It returns a new `CompletableFuture` that completes when all of the provided `CompletableFutures` are done, regardless of their individual results.

* `anyOf`

`anyOf(CompletableFuture<?>... cfs)`: This method waits for any of the provided `CompletableFutures` to complete. It returns a new `CompletableFuture` that completes when any of the provided `CompletableFutures` completes, with the result of the first completed `CompletableFuture`.

* `completeOnTimeout`

`completeOnTimeout(T value, long timeout, TimeUnit unit)`: This method completes the current `CompletableFuture` with the specified value if it does not complete within the specified timeout period.

* `cancel`

`cancel(boolean mayInterruptIfRunning)`: This method cancels the computation associated with the current `CompletableFuture`, if possible.

* `join`

`join()`: This method waits for the completion of the current `CompletableFuture` and returns its result, blocking if necessary until the result is available.

* `get`

`get()`: This method is similar to `join()`, but it can throw checked exceptions. It waits for the completion of the current `CompletableFuture` and returns its result, but it also throws any exception that occurred during the computation, wrapped in a `ExecutionException`.

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

3. Creating a single CompletableFuture using `runAsync`**.**





### Use Cases:

#### When we have a list of account IDs and want to fetch the balance with the help of those IDs by calling external API parallely.

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









