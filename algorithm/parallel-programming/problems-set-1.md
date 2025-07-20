# Problems - Set 1

## Factorial of a number

Approach using parallel programming with the Fork/Join Framework to calculate the factorial of a number. This approach divides the factorial computation into smaller tasks that can be executed concurrently, leveraging the power of multi-core CPUs.

```java
import java.math.BigInteger;
import java.util.concurrent.RecursiveTask;
import java.util.concurrent.ForkJoinPool;

public class ParallelFactorial extends RecursiveTask<BigInteger> {
    private final int start, end;
    private static final int THRESHOLD = 10; // Determines the granularity of the tasks.

    // Constructor
    public ParallelFactorial(int start, int end) {
        this.start = start;
        this.end = end;
    }

    @Override
    protected BigInteger compute() {
        // If the range is small enough, calculate directly.
        if ((end - start) <= THRESHOLD) {
            return calculateFactorialRange(start, end);
        } else {
            // Split the task into two subtasks.
            int mid = (start + end) / 2;
            ParallelFactorial leftTask = new ParallelFactorial(start, mid);
            ParallelFactorial rightTask = new ParallelFactorial(mid + 1, end);

            // Fork the left task and compute the right task.
            leftTask.fork();
            BigInteger rightResult = rightTask.compute();
            BigInteger leftResult = leftTask.join();

            // Combine results.
            return leftResult.multiply(rightResult);
        }
    }

    // Helper method to calculate factorial for a range.
    private BigInteger calculateFactorialRange(int start, int end) {
        BigInteger result = BigInteger.ONE;
        for (int i = start; i <= end; i++) {
            result = result.multiply(BigInteger.valueOf(i));
        }
        return result;
    }

    // Main method to compute the factorial.
    public static BigInteger computeFactorial(int n) {
        ForkJoinPool pool = ForkJoinPool.commonPool(); // Use the common ForkJoinPool.
        return pool.invoke(new ParallelFactorial(1, n));
    }

    public static void main(String[] args) {
        int number = 100; // Change this number as needed.
        BigInteger factorial = computeFactorial(number);
        System.out.println("Factorial of " + number + " is: " + factorial);
    }
}
```

{% hint style="info" %}
* **RecursiveTask**:
  * Extends `RecursiveTask<BigInteger>` for tasks that return a value.
  * The `compute()` method recursively splits the task until the range is smaller than the threshold.
* **Threshold**:
  * Determines when the task is small enough to compute sequentially.
  * A smaller threshold increases parallelism but adds overhead for task creation.
* **Fork/Join**:
  * `fork()`: Starts the left subtask asynchronously.
  * `compute()`: Computes the right subtask synchronously.
  * `join()`: Waits for the left subtask to complete and retrieves its result.
* **Range Calculation**:
  * The range of numbers is divided and processed independently.
* **ForkJoinPool**:
  * Manages and executes tasks across multiple threads.
{% endhint %}





