# Future

## About

The `Future` interface in Java, introduced in Java 5, is part of the `java.util.concurrent` package and represents the result of an asynchronous computation. It provides methods to check if the computation is complete, to wait for its completion, and to retrieve the result of the computation. If necessary, the computation can also be canceled using the `Future` interface.

## **Asynchronous Computation**

* `Future` represents the result of a computation that may not have completed yet.
* This allows to start a task in a separate thread and continue executing other code while the task runs.

## **Methods in `Future` Interface**

**`get()`**:

* Retrieves the result of the computation, blocking if necessary until the computation is complete.
* If the computation completed successfully, `get()` returns the result.
* If the computation threw an exception, `get()` throws an `ExecutionException`, which wraps the original exception.
* If the thread is interrupted while waiting, `get()` throws an `InterruptedException`.

**`get(long timeout, TimeUnit unit)`**:

* Retrieves the result, but only waits for the specified timeout.
* If the computation is not complete within the timeout, it throws a `TimeoutException`.

**`cancel(boolean mayInterruptIfRunning)`**:

* Attempts to cancel the execution of the task.
* The parameter `mayInterruptIfRunning` determines whether the thread executing the task should be interrupted.
* Returns `true` if the task was canceled before it completed, `false` if it could not be canceled (e.g., because it had already completed).

**`isCancelled()`**:

* Returns `true` if the task was canceled before it completed normally.

**`isDone()`**:

* Returns `true` if the task has completed (either successfully, with an exception, or via cancellation).

## Example

```java
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

public class FutureExample {

    public static void main(String[] args) {
        ExecutorService executor = Executors.newSingleThreadExecutor();

        Callable<String> callableTask = () -> {
            Thread.sleep(2000);
            return "Task's Execution";
        };

        Future<String> future = executor.submit(callableTask);

        // Perform some other operations

        try {
            // Blocking call to get the result
            String result = future.get();
            System.out.println("Result: " + result);
        } catch (InterruptedException | ExecutionException e) {
            e.printStackTrace();
        } finally {
            executor.shutdown();
        }
    }
}
```
