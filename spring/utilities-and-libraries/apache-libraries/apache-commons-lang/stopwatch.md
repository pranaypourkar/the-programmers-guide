# StopWatch

## About

The **`StopWatch`** class in Apache Commons Lang (`org.apache.commons.lang3.time.StopWatch`) is a utility designed to measure elapsed time in a precise and convenient manner. It is particularly useful in scenarios such as performance testing, benchmarking, profiling sections of code, or monitoring the execution duration of critical operations. Unlike manually recording system timestamps (`System.currentTimeMillis()` or `System.nanoTime()`), `StopWatch` abstracts away the boilerplate code and provides a clean API for starting, stopping, suspending, resuming, and querying elapsed times.

## Features

1. **Start/Stop Timing**
   * We can start the stopwatch at a given point in our code and stop it after execution.
   * The elapsed time between these points is recorded.
2. **Suspend/Resume Support**
   * The stopwatch can be temporarily suspended and later resumed.
   * This is useful when we want to exclude certain operations from timing.
3. **Split and Unsplit**
   * Allows capturing an intermediate time (split) without stopping the stopwatch.
   * Splits are useful when monitoring progress in long-running tasks.
4. **Multiple Time Units**
   * Elapsed time can be retrieved in various units: **nanoseconds, milliseconds, seconds, minutes, hours, or days**.
   * This provides flexibility for both fine-grained benchmarking and high-level reporting.
5. **Thread Safety**
   * The basic `StopWatch` implementation is **not thread-safe**.
   * For concurrent environments, external synchronization or per-thread instances should be used.
6. **Readable Formatting**
   * Supports string formatting of elapsed time in a human-readable style (e.g., `00:01:23.456`).
   * Useful for logging and reporting.

## Method Reference

<table data-header-hidden data-full-width="true"><thead><tr><th width="169.22265625"></th><th></th></tr></thead><tbody><tr><td><strong>Method</strong></td><td><strong>Action / Meaning</strong></td></tr><tr><td><strong>Constructor</strong></td><td></td></tr><tr><td><code>StopWatch()</code></td><td>Creates a new stopwatch (initial state: <strong>unstarted</strong>).</td></tr><tr><td><strong>Core Controls</strong></td><td></td></tr><tr><td><code>start()</code></td><td>Starts the stopwatch. Throws <code>IllegalStateException</code> if already started.</td></tr><tr><td><code>stop()</code></td><td>Stops the stopwatch. No more time accumulates until reset.</td></tr><tr><td><code>reset()</code></td><td>Resets stopwatch to the <strong>unstarted</strong> state (time = 0). Must be called before reusing.</td></tr><tr><td><code>split()</code></td><td>Records the current elapsed time as a <strong>split point</strong> (does not stop the watch).</td></tr><tr><td><code>unsplit()</code></td><td>Clears the last split. Needed before making another split.</td></tr><tr><td><code>suspend()</code></td><td>Pauses the stopwatch (time is frozen).</td></tr><tr><td><code>resume()</code></td><td>Resumes from a suspended state.</td></tr><tr><td><strong>Time Retrieval</strong></td><td></td></tr><tr><td><code>getTime()</code></td><td>Returns total elapsed time (in <strong>milliseconds</strong>) between start and now (or stop).</td></tr><tr><td><code>getNanoTime()</code></td><td>Returns total elapsed time (in <strong>nanoseconds</strong>) for higher precision.</td></tr><tr><td><code>getSplitTime()</code></td><td>Returns elapsed time (in ms) at the point of the last <strong>split</strong>.</td></tr><tr><td><code>getSplitNanoTime()</code></td><td>Returns elapsed time (in ns) at the last <strong>split</strong>.</td></tr><tr><td><strong>String Output</strong></td><td></td></tr><tr><td><code>toString()</code></td><td>Returns formatted elapsed time as <code>HH:mm:ss.SSS</code> (human-readable).</td></tr><tr><td><code>toSplitString()</code></td><td>Returns formatted split time as <code>HH:mm:ss.SSS</code>.</td></tr><tr><td><strong>State Inspection</strong></td><td></td></tr><tr><td><code>isStarted()</code></td><td>Returns <code>true</code> if stopwatch has been started.</td></tr><tr><td><code>isStopped()</code></td><td>Returns <code>true</code> if stopwatch has been stopped.</td></tr><tr><td><code>isSuspended()</code></td><td>Returns <code>true</code> if stopwatch is currently suspended.</td></tr><tr><td><code>isStarted()</code></td><td>Returns <code>true</code> if stopwatch has been started (but not necessarily running).</td></tr><tr><td><strong>Static Factory (Commons Lang 3.6+)</strong></td><td></td></tr><tr><td><code>StopWatch.createStarted()</code></td><td>Creates and starts a new stopwatch in one call.</td></tr><tr><td><code>StopWatch.create()</code></td><td>Creates a new stopwatch in the <strong>unstarted</strong> state.</td></tr></tbody></table>

## Use Cases

* **Performance Testing** – Measure the execution time of a method or algorithm to identify bottlenecks.
* **Benchmarking** – Compare the performance of multiple implementations of the same logic.
* **Profiling** – Track elapsed times for different stages of a workflow using splits.
* **Monitoring** – Record execution times for API calls, database queries, or batch processes.
* **Operational Logging** – Add duration details in logs for observability and debugging.

## Usage Examples

### 1. Basic Start and Stop

The simplest use case is measuring elapsed time for a block of code.

```java
import org.apache.commons.lang3.time.StopWatch;

public class StopWatchExample {
    public static void main(String[] args) throws InterruptedException {
        StopWatch watch = new StopWatch();

        watch.start(); // Start timing
        Thread.sleep(2000); // Simulated task (2 seconds)
        watch.stop(); // Stop timing

        System.out.println("Elapsed Time in ms: " + watch.getTime()); 
        // Elapsed Time in ms: 2005
    }
}
```

### 2. Restart for Multiple Measurements

If we want to reuse the same stopwatch for different measurements, use `reset()` and `start()` again.

```java
StopWatch watch = new StopWatch();

watch.start();
Thread.sleep(1000);
watch.stop();
System.out.println("Task 1 time (ms): " + watch.getTime());
// Task 1 time (ms): 1005

watch.reset();
watch.start();
Thread.sleep(1500);
watch.stop();
System.out.println("Task 2 time (ms): " + watch.getTime());
// Task 2 time (ms): 1505
```

### 3. Split and Unsplit (Intermediate Checkpoints)

Splits let us measure checkpoints without stopping the stopwatch.

```java
StopWatch watch = new StopWatch();

watch.start();
Thread.sleep(1000);
watch.split();
System.out.println("Split 1 (ms): " + watch.getSplitTime());
// Split 1 (ms): 1004

Thread.sleep(2000);
watch.split();
System.out.println("Split 2 (ms): " + watch.getSplitTime());
// Split 2 (ms): 3010

watch.unsplit(); // Clear split state
watch.stop();
System.out.println("Total time (ms): " + watch.getTime());
// Total time (ms): 3010
```

```java
StopWatch sw = new StopWatch();
sw.start();

// Step 1: Data Extraction
Thread.sleep(1000); // simulate 1s
sw.split();
System.out.println("After Extraction: " + sw.toSplitString()); 
// After Extraction: 00:00:01.006

// Clear split so we can reuse it
sw.unsplit();

// Step 2: Data Transformation
Thread.sleep(2000); // simulate 2s
sw.split();
System.out.println("After Transformation: " + sw.toSplitString()); 
// After Transformation: 00:00:03.033

// Again clear split
sw.unsplit();

// Step 3: Data Load
Thread.sleep(1500); // simulate 1.5s
sw.split();
System.out.println("After Loading: " + sw.toSplitString()); 
// After Loading: 00:00:04.537

sw.stop();
System.out.println("Total Time: " + sw.toString()); 
// Total Time: 00:00:04.537
```

### 4. Suspend and Resume

When certain parts of code shouldn’t be included in measurement, use suspend/resume.

```java
StopWatch watch = new StopWatch();

watch.start();
Thread.sleep(1000);

watch.suspend();  // Pause timing
Thread.sleep(2000); // Excluded from timing
watch.resume();   // Resume timing

Thread.sleep(1000);
watch.stop();

System.out.println("Elapsed Time (ms, excluding suspend): " + watch.getTime());
// Elapsed Time (ms, excluding suspend): 2005
```

**Output:** Approximately 2000 ms (1 sec before + 1 sec after, 2 sec suspended excluded).

### 5. Measuring in Different Time Units

StopWatch provides elapsed time in multiple units.

```java
StopWatch watch = new StopWatch();

watch.start();
Thread.sleep(1234);
watch.stop();

System.out.println("Elapsed Time in ns: " + watch.getNanoTime());
// Elapsed Time in ns: 1239132292
System.out.println("Elapsed Time in ms: " + watch.getTime());
// Elapsed Time in ms: 1239
```

### 6. Logging with Human Readable Format

The stopwatch can output a nicely formatted string (`HH:mm:ss.SSS`).

```java
StopWatch watch = new StopWatch();

watch.start();
Thread.sleep(3750); // 3.75 seconds
watch.stop();

System.out.println("Formatted time: " + watch.toString());
// Formatted time: 00:00:03.752
```

### 7. Benchmarking Multiple Algorithms

We can measure and compare performance of different implementations.

```java
StopWatch watch = new StopWatch();

// Algorithm A
watch.start();
runAlgorithmA();
watch.stop();
System.out.println("Algorithm A took: " + watch.getTime() + " ms");

watch.reset();

// Algorithm B
watch.start();
runAlgorithmB();
watch.stop();
System.out.println("Algorithm B took: " + watch.getTime() + " ms");
```

### 8. Profiling Stages in a Workflow

Using splits for stage-wise profiling.

```java
StopWatch watch = new StopWatch();

watch.start();

loadData();
watch.split();
System.out.println("Load Data: " + watch.getSplitTime() + " ms");

processData();
watch.split();
System.out.println("Process Data: " + watch.getSplitTime() + " ms");

saveResults();
watch.stop();
System.out.println("Save Results: " + watch.getTime() + " ms");
```

### 9. Integrating with Logging Framework

Often used with SLF4J for structured logs.

```java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class LoggingExample {
    private static final Logger log = LoggerFactory.getLogger(LoggingExample.class);

    public static void main(String[] args) throws InterruptedException {
        StopWatch watch = new StopWatch();

        watch.start();
        Thread.sleep(1500);
        watch.stop();

        log.info("Task execution completed in {}", watch.toString());
        // Task execution completed in 00:00:01.505
    }
}
```

## Best Practices

#### 1. Always Stop Before Reuse

* **Best Practice**: A `StopWatch` must be stopped before calling `reset()` or starting again.
* **Pitfall**: Forgetting to stop and directly calling `start()` will throw an `IllegalStateException`.

#### 2. Use Reset for Multiple Measurements

* **Best Practice**: Call `reset()` before starting a new measurement cycle.
* **Pitfall**: Without reset, elapsed times accumulate across runs, leading to misleading results.

#### 3. Use Suspend/Resume Carefully

* **Best Practice**: Suspend timing when executing operations that should not count (like sleeping, waiting for external systems).
* **Pitfall**: Forgetting to call `resume()` will lead to under-reporting elapsed time.

#### 4. Prefer `toString()` for Logging

* **Best Practice**: Use `toString()` for human-readable log output (`HH:mm:ss.SSS`).
* **Pitfall**: Printing `getTime()` (ms only) is less meaningful for long-running tasks.

#### 5. Benchmark with Warmup

* **Best Practice**: For performance benchmarking (e.g., comparing algorithms), always do a **warm-up run** (JVM JIT optimization may skew first measurements).
* **Pitfall**: Running StopWatch only once and assuming results are representative of real performance.

#### 6. Avoid Multi-Threaded Sharing

* **Best Practice**: Each thread should have its own `StopWatch` instance.
* **Pitfall**: Sharing a single `StopWatch` across threads is **not thread-safe** and leads to corrupted timings.

#### 7. Measure Specific Sections with Splits

* **Best Practice**: Use `split()` to capture intermediate milestones without stopping the clock.
* **Pitfall**: Forgetting to call `unsplit()` before using some operations (like another split) may throw exceptions.

#### 8. Choose the Right Time Unit

* **Best Practice**: Use `getNanoTime()` for precise measurement (e.g., micro-benchmarking).
* **Pitfall**: Using only `getTime()` (ms precision) may lose accuracy in very fast-running tasks.

#### 9. Do Not Mix StopWatch with System.currentTimeMillis()

* **Best Practice**: Stick to one timing approach (StopWatch provides consistent, encapsulated API).
* **Pitfall**: Mixing with manual timestamp differences may lead to confusion.

#### 10. Clean Logging

* **Best Practice**: Wrap StopWatch usage inside try/finally for guaranteed stop and log output.
* **Pitfall**: Forgetting to stop a stopwatch in case of exceptions can leave it in an invalid state.

```java
StopWatch watch = new StopWatch();
try {
    watch.start();
    // business logic
} finally {
    watch.stop();
    log.info("Execution completed in {}", watch);
}
```
