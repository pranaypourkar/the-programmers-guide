# Parallel Programming

## About

**Parallel Programming** is a programming model where **multiple tasks** are executed **simultaneously** to solve a problem more efficiently. The goal is to **divide a big problem into smaller subproblems**, run them at the same time (in parallel), and then combine the results.

It is often used to **improve performance** and **reduce the time** taken to complete a task, especially on machines with multiple processors or cores.

## **When Can We Use Parallel Programming?**

Parallel programming is not always the right solution. It works best in specific situations where **multiple tasks can be executed independently**. Below are the common cases when parallel programming is effective:

**1. Tasks Are Independent**

If the tasks in a program can run **without depending on the results or execution order** of other tasks, they can safely run in parallel.

**Example**: Processing multiple files, each independently (e.g., resizing images or converting files).

**2. Large Input Data**

If the program works on a **large amount of data**, you can split the data into chunks and process them simultaneously.

**Example**: Searching for a pattern in a large document or dataset.

**3. Same Operation Repeated**

If a program performs the **same operation on multiple pieces of data**, it's often a good candidate for parallel execution.

**Example**: Matrix operations, filtering data, applying transformations.

**4. High CPU Usage**

When a task takes a lot of CPU time (i.e., it’s **CPU-bound**), parallel programming can speed up execution by using multiple CPU cores.

**5. Batch Processing**

If your application needs to handle **many similar tasks repeatedly**, like handling web requests, analyzing logs, or generating reports, these can often be processed in parallel.

**6. Performance Bottleneck Identified**

Sometimes you already have a sequential solution, and **profiling** shows that one part is taking most of the time. If that part can be broken into smaller parts, parallelism can help.

## **How to Know If a Problem is Parallel-Safe?**

Not every problem can be solved using parallel programming. Before converting a sequential program into a parallel one, ask the following:

**1. Can the Work Be Split into Independent Tasks?**

If the tasks rely on each other’s results or share too much data, it may not be safe or beneficial to run them in parallel.

**Parallel-safe:** Each task has its own data.

**Not safe:** Tasks read and write to the same variable or depend on each other's output.

**2. Is There Shared State?**

If multiple tasks need to read and write to the same variable or data structure, it can cause problems like race conditions or deadlocks.

* If shared state is **read-only**, it's usually safe.
* If **writes** are involved, you need to use synchronization carefully.

**3. Are You Using Thread-Safe Data Structures?**

When tasks access shared data, use thread-safe collections or synchronization mechanisms (like locks, synchronized blocks, or atomic classes in Java).

**4. Is the Overhead Worth It?**

Creating threads, managing synchronization, and dividing tasks comes with some overhead. For small or quick tasks, this overhead might outweigh the performance benefit.

**5. Does It Give Consistent Results Every Time?**

A parallel-safe program should produce the **same result** regardless of the order in which tasks are executed. If the output changes across runs, it’s likely **not safe**.

**6. Can You Reproduce Bugs Easily?**

Parallel programs are harder to debug. If race conditions or deadlocks occur, they may not show up every time. If you can’t consistently reproduce issues, that’s a sign of unsafe parallel behavior.

## Use Case: Sum of Squares of a Large List of Integers

We are given a **large list of integers** (say, 100 million integers), and we want to compute the **sum of their squares**:

```
sum = x₁² + x₂² + x₃² + ... + xₙ²
```

This is a **CPU-bound**, **repetitive**, and **independent** operation — each square can be computed without needing the others.

### Single-threaded (Sequential) Approach

```java
public class SumOfSquaresSequential {
    public static long sumSquares(int[] nums) {
        long sum = 0;
        for (int num : nums) {
            sum += (long) num * num;
        }
        return sum;
    }

    public static void main(String[] args) {
        int[] data = new int[100_000_000];
        Arrays.fill(data, 2); // Simple data for demo

        long start = System.currentTimeMillis();
        long result = sumSquares(data);
        long end = System.currentTimeMillis();

        System.out.println("Sum: " + result);
        System.out.println("Time taken (Sequential): " + (end - start) + " ms");
    }
}
```

* Uses just **one thread**.
* Goes through the list one element at a time.
* Takes time **proportional to the size** of the list (`O(n)`).

### Parallel Approach (Using Java `ForkJoinPool` / `parallelStream`)

We can use Java 8’s **parallel streams**, which internally splits the task across available CPU cores.

```java
public class SumOfSquaresParallel {
    public static void main(String[] args) {
        int[] data = new int[100_000_000];
        Arrays.fill(data, 2); // All elements = 2

        long start = System.currentTimeMillis();
        long result = Arrays.stream(data)
                            .parallel()
                            .mapToLong(x -> (long) x * x)
                            .sum();
        long end = System.currentTimeMillis();

        System.out.println("Sum: " + result);
        System.out.println("Time taken (Parallel): " + (end - start) + " ms");
    }
}
```

* `.parallel()` splits work **across multiple threads/cores**.
* Each thread processes a chunk of the array **independently**.
* Final result is merged using **thread-safe reduction** (`sum()`).

#### Sample Performance (On 8-core CPU):

| Version    | Time (Approx.) |
| ---------- | -------------- |
| Sequential | 2500 ms        |
| Parallel   | 400–700 ms     |

\~**4x–6x improvement** depending on system load and CPU
