# StopWatch

## About

Spring’s `StopWatch` is a simple but powerful utility for **measuring execution time of tasks** in an application. Unlike Apache Commons’ `StopWatch`, which is designed for low-level timing with methods like `start()`, `split()`, and `suspend()`, the Spring version is **task-oriented**.\
It allows us to record **multiple tasks**, name them, and get a **summary report** of how long each task took, along with percentages relative to the total execution time.

This makes Spring’s StopWatch particularly useful in profiling, benchmarking, and performance monitoring of **business logic or method calls**.

## Features

1. **Task-Oriented Design**
   * Instead of just measuring elapsed time, Spring StopWatch is built around the concept of _tasks_.
   * Each task can be given a **name** (e.g., "Database Query", "REST Call"), making the timing results meaningful.
2. **Multiple Task Support**
   * We can start and stop the StopWatch multiple times to measure **different sequential tasks** in one run.
   * Each task is recorded separately for later analysis.
3. **Summary Reporting**
   * Provides a **`prettyPrint()`** method to generate a table of tasks with execution times and percentages of total runtime.
   * Useful for profiling performance bottlenecks without external tools.
4. **Lightweight & Built-in**
   * Part of **`org.springframework.util`** package in Spring Core.
   * No additional dependencies required.
5. **Total Time Calculation**
   * Offers convenient methods like `getTotalTimeMillis()` and `getTotalTimeSeconds()` to get the **overall runtime** across all tasks.
6. **Last Task Tracking**
   * Provides methods to quickly check the **last executed task**:
     * `getLastTaskName()`
     * `getLastTaskTimeMillis()`
7. **Detailed Task Information**
   * Exposes **`TaskInfo[] getTaskInfo()`** to access detailed timing for each task programmatically.
   * Each `TaskInfo` includes task name, time in milliseconds, and percentage of total time.
8. **Human-Readable Output**
   * `prettyPrint()` automatically formats timing results into a readable report (tabular structure).
9. **Simple API**
   * Uses just `start("taskName")` and `stop()` methods.
   * Easy to integrate without learning a complex profiling tool.
10. **Thread-Safe (per instance)**
    * Each StopWatch instance is independent, meaning it can be safely used across different parts of code without interference.

## Method Reference

<table><thead><tr><th width="230.16015625">Method</th><th>Description / Action</th></tr></thead><tbody><tr><td><strong><code>start(String taskName)</code></strong></td><td>Starts timing a new task with the given name. Throws an exception if a task is already running.</td></tr><tr><td><strong><code>stop()</code></strong></td><td>Stops the currently running task. Throws an exception if no task is active.</td></tr><tr><td><strong><code>isRunning()</code></strong></td><td>Returns <code>true</code> if a task is currently running, otherwise <code>false</code>.</td></tr><tr><td><strong><code>getTotalTimeMillis()</code></strong></td><td>Returns the total time (in milliseconds) for all tasks combined.</td></tr><tr><td><strong><code>getTotalTimeSeconds()</code></strong></td><td>Returns the total time (in seconds) for all tasks combined.</td></tr><tr><td><strong><code>getTaskCount()</code></strong></td><td>Returns the total number of tasks that have been recorded.</td></tr><tr><td><strong><code>getLastTaskName()</code></strong></td><td>Returns the name of the last task executed (null if none).</td></tr><tr><td><strong><code>getLastTaskTimeMillis()</code></strong></td><td>Returns the execution time (in ms) of the last task executed.</td></tr><tr><td><strong><code>getLastTaskInfo()</code></strong></td><td>Returns a <code>TaskInfo</code> object with name and time for the last task.</td></tr><tr><td><strong><code>getTaskInfo()</code></strong></td><td>Returns an array of <code>TaskInfo</code> objects, each containing name and execution time of all tasks.</td></tr><tr><td><strong><code>shortSummary()</code></strong></td><td>Returns a one-line string summary of the total time and task count.</td></tr><tr><td><strong><code>prettyPrint()</code></strong></td><td>Returns a formatted string with timing details for all tasks, including percentage of total execution time.</td></tr><tr><td><strong><code>toString()</code></strong></td><td>Returns a string containing short summary + last task info.</td></tr></tbody></table>

## Use Cases

* **Measuring Execution Time of Multiple Tasks**
  * Useful when breaking down an operation into smaller tasks and measuring their time individually.
  * Example: measuring DB query time, service logic, and serialization separately.
* **Performance Benchmarking in Development**
  * Helps developers identify which part of the code consumes the most time.
  * Example: comparing two different implementations of the same algorithm.
* **Profiling Service Layer Methods**
  * Often used in Spring services to monitor execution time of methods without adding full-fledged monitoring tools.
  * Example: tracking execution time of a service call like `EmployeeService.getEmployeeDetails()`.
* **Analyzing Batch Jobs or Background Tasks**
  * Useful in ETL jobs, scheduled tasks, or long-running batch processes.
  * Example: measuring each step of a batch job (read → process → write).
* **Debugging and Optimizing Performance Bottlenecks**
  * Helps detect which parts of an application are slowing down under load.
  * Example: finding slow API endpoints by wrapping controller methods.
* **Logging Task Execution Details**
  * Can be integrated with application logs to output a summary of task execution times.
  * Example: `logger.info(stopWatch.prettyPrint());` to log timing breakdown in structured format.
* **Comparing Different Code Paths**
  * Used to compare execution times between two logic flows.
  * Example: measuring "cache-hit vs cache-miss" performance.
* **Unit Testing Performance**
  * Although not a replacement for JMH (Java Microbenchmark Harness), developers sometimes use `StopWatch` in unit tests to ensure execution stays under a threshold.
  * Example: assert that a method runs within `500ms`.

## Usage Examples

### 1. Basic Task Timing

```java
import org.springframework.util.StopWatch;

public class BasicStopWatchExample {
    public static void main(String[] args) throws InterruptedException {
        StopWatch stopWatch = new StopWatch();

        stopWatch.start("Task 1");
        Thread.sleep(500); // simulate work
        stopWatch.stop();

        stopWatch.start("Task 2");
        Thread.sleep(300); // simulate work
        stopWatch.stop();

        System.out.println(stopWatch.prettyPrint());
    }
}
```

```
StopWatch '': 0.8043835 seconds
----------------------------------------
Seconds       %       Task name
----------------------------------------
0.50109325    62%     Task 1
0.30329025    38%     Task 2
```

### 2. Measuring Execution of a Service Method

```java
import org.springframework.util.StopWatch;

public class EmployeeService {
    
    public void getEmployeeDetails() {
        StopWatch stopWatch = new StopWatch("EmployeeService");

        stopWatch.start("DB Query");
        simulateWork(400);
        stopWatch.stop();

        stopWatch.start("Business Logic");
        simulateWork(200);
        stopWatch.stop();

        stopWatch.start("DTO Mapping");
        simulateWork(100);
        stopWatch.stop();

        System.out.println(stopWatch.prettyPrint());
    }

    private void simulateWork(long millis) {
        try { Thread.sleep(millis); } catch (InterruptedException ignored) {}
    }
}
```

```
StopWatch 'EmployeeService': 0.711462793 seconds
------------------------------------------------
Seconds       %       Task name
------------------------------------------------
0.405122459   57%     DB Query
0.201277167   28%     Business Logic
0.105063167   15%     DTO Mapping
```

This helps **profile each step** in a service method.

### 3. Using StopWatch in a Spring Boot Controller

```java
import org.springframework.util.StopWatch;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class PerformanceController {

    @GetMapping("/performance")
    public String checkPerformance() {
        StopWatch stopWatch = new StopWatch("PerformanceAPI");

        stopWatch.start("DB call");
        simulateWork(300);
        stopWatch.stop();

        stopWatch.start("External API");
        simulateWork(500);
        stopWatch.stop();

        stopWatch.start("Response Serialization");
        simulateWork(200);
        stopWatch.stop();

        return stopWatch.prettyPrint();
    }

    private void simulateWork(long millis) {
        try { Thread.sleep(millis); } catch (InterruptedException ignored) {}
    }
}
```

```
StopWatch 'PerformanceAPI': 1.010389792 seconds
-----------------------------------------------
Seconds       %       Task name
-----------------------------------------------
0.30070725    30%     DB call
0.505770125   50%     External API
0.203912417   20%     Response Serialization
```

### 4. Logging Task Execution Details

```java
import org.springframework.util.StopWatch;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class LoggingExample {
    private static final Logger logger = LoggerFactory.getLogger(LoggingExample.class);

    public void processJob() {
        StopWatch stopWatch = new StopWatch("JobProcessor");

        stopWatch.start("Step 1");
        simulateWork(200);
        stopWatch.stop();

        stopWatch.start("Step 2");
        simulateWork(400);
        stopWatch.stop();

        logger.info("Execution time details: {}", stopWatch.prettyPrint());
    }

    private void simulateWork(long millis) {
        try { Thread.sleep(millis); } catch (InterruptedException ignored) {}
    }
}
```

```
Execution time details: StopWatch 'JobProcessor': 0.607882291 seconds
---------------------------------------------
Seconds       %       Task name
---------------------------------------------
0.205072583   34%     Step 1
0.402809708   66%     Step 2
```

Logs structured timing details instead of just total execution time.

### 5. Unit Test Performance Check

```java
import org.junit.jupiter.api.Test;
import org.springframework.util.StopWatch;

import static org.junit.jupiter.api.Assertions.assertTrue;

public class PerformanceTest {

    @Test
    void methodPerformanceShouldBeUnder1Second() {
        StopWatch stopWatch = new StopWatch();

        stopWatch.start("TestMethod");
        simulateWork(700);
        stopWatch.stop();

        long totalTimeMillis = stopWatch.getTotalTimeMillis();
        assertTrue(totalTimeMillis < 1000, "Method took too long!");
    }

    private void simulateWork(long millis) {
        try { Thread.sleep(millis); } catch (InterruptedException ignored) {}
    }
}
```

## Best Practices

1. **Name our Tasks Clearly**
   * Always give meaningful task names when starting (`stopWatch.start("DB Query")` instead of `"Task1"`).
   * This makes `prettyPrint()` outputs much easier to analyze.
2. **Use StopWatch in Development and Testing, Not Production**
   * It is primarily a **profiling utility**.
   * Avoid leaving it in production code for every request unless we are explicitly debugging performance.
3. **Wrap Around Critical Sections**
   * Use it for database queries, external API calls, or heavy computations.
   * Helps identify slow parts of the request-response lifecycle.
4. **Integrate with Logging**
   * After completing execution, log the result with `logger.info(stopWatch.prettyPrint())`.
   * Combine with tools like **Spring AOP** or **interceptors** to track method-level timings automatically.
5. **Use `getLastTaskTimeMillis()` for Specific Insights**
   * Instead of always analyzing the whole report, use methods like `getLastTaskTimeMillis()` or `getTotalTimeMillis()` when we only need **summary numbers**.
6. **Combine with Unit Tests for Performance Benchmarks**
   * In JUnit tests, wrap a method call with `StopWatch` and assert total execution time is under a threshold.
   * Helps prevent performance regressions.
7. **Prefer Programmatic Control Over Annotations for Profiling**
   * Since StopWatch is lightweight and code-driven, we can **turn it on/off easily** without changing Spring configurations.

## Common Pitfalls

1. **Forgetting to Call `stop()`**
   * If we call `start()` multiple times without `stop()`, it will throw `IllegalStateException`.
   * Always ensure `stop()` is called after each `start()`.
2. **Running Nested StopWatches in the Same Instance**
   * Spring’s StopWatch is **not designed for nested or parallel tasks** inside the same instance.
   * If we need nested measurements, create multiple `StopWatch` objects or use Apache Commons StopWatch.
3. **Overusing in Production**
   * Profiling every single method in production increases overhead and logging noise.
   * Use it selectively or via conditional flags.
4. **Not Resetting Between Runs**
   * If the same StopWatch instance is reused across multiple flows without `stopWatch = new StopWatch()` or `stopWatch.start()`, timings may overlap.
   * Always **use a fresh instance per request/process**.
5. **Confusing It with Apache Commons StopWatch**
   * Spring StopWatch supports **multiple tasks with names** and pretty printing.
   * Apache Commons StopWatch is simpler (start/stop only, single task). Use the right one depending on need.
6. **Ignoring Task Names in Reports**
   * If tasks are unnamed, the pretty print output loses meaning.
   *   Example:

       ```
       0500   62%   Task-1
       0300   38%   Task-2
       ```

       → not helpful compared to `DB Query`, `External API`.
