# ExecutorService Implementations

## About&#x20;

Java's `ExecutorService` provides a framework for managing a pool of threads to execute asynchronous tasks. The framework abstracts the creation, execution, and management of threads, making it easier to work with concurrent tasks. Various implementations of `ExecutorService` cater to different use cases and requirements. Below are some of the `ExecutorService` implementations in Java.

## 1. **ThreadPoolExecutor**

`ThreadPoolExecutor` is the commonly used and configurable implementation of `ExecutorService`. It allows for fine-grained control over thread management and task handling.

### **Key Characteristics**

* **Core Pool Size**: The minimum number of threads that are always kept alive, even if they are idle.
* **Maximum Pool Size**: The maximum number of threads allowed in the pool.
* **Keep-Alive Time**: The maximum time that excess idle threads will wait for new tasks before terminating.
* **Work Queue**: The queue used for holding tasks before they are executed. Can be `ArrayBlockingQueue`, `LinkedBlockingQueue`, `SynchronousQueue`, etc.
* **Rejected Execution Handler**: Defines the policy for handling tasks that cannot be executed (e.g., due to a full queue or pool shutdown). Options include `AbortPolicy`, `CallerRunsPolicy`, `DiscardPolicy`, and `DiscardOldestPolicy`.

### **Use Cases**

1. **Web Server Request Handling**
   * **Scenario**: A web server managing multiple client requests concurrently.
   * **Configuration**: Set a fixed number of threads based on server capacity. Use a bounded queue to prevent memory overflow and a rejection policy to handle overloads.
   * **Why**: Ensures efficient handling of concurrent requests without overloading the server resources.
2. **Background Job Processing**
   * **Scenario**: A system that processes background jobs such as generating reports, processing images, or sending emails.
   * **Configuration**: Use a fixed thread pool size with a large task queue to buffer tasks.
   * **Why**: Controls the number of concurrent jobs and prevents excessive resource usage.
3. **Data Pipeline Processing**
   * **Scenario**: A data pipeline that processes incoming data in stages, such as ETL (Extract, Transform, Load) processes.
   * **Configuration**: Configure a pool with a sufficient number of threads to handle data stages concurrently.
   * **Why**: Ensures smooth and efficient data flow through the pipeline.
4. **Monitoring and Alerting Systems**
   * **Scenario**: A system that periodically checks various metrics and triggers alerts based on conditions.
   * **Configuration**: Use a scheduled thread pool with periodic task scheduling.
   * **Why**: Automates monitoring and ensures timely alerts

### **Example**

```java
ExecutorService executor = new ThreadPoolExecutor(
    10, // core pool size
    20, // maximum pool size
    60L, // keep-alive time
    TimeUnit.SECONDS, // time unit
    new LinkedBlockingQueue<Runnable>(), // work queue
    new ThreadPoolExecutor.CallerRunsPolicy() // rejection policy
);
```

We can create a class with name ExecutorConfiguration and add a bean like below.

```java
package com.company.project.config;

import io.micrometer.context.ContextExecutorService;
import io.micrometer.context.ContextSnapshotFactory;
import java.util.concurrent.Executor;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.validation.annotation.Validated;

@Validated
@Configuration
public class ExecutorConfiguration {

    @Bean("myThreadPoolExecutor")
    public Executor executor(ExecutorConfigurationProperties properties) {
        var executorService = new ThreadPoolExecutor(
            properties.getCorePoolSize(),
            properties.getMaxPoolSize(),
            properties.getKeepAliveSeconds(),
            TimeUnit.SECONDS,
            new LinkedBlockingQueue<>(), // Using unbounded blocking queue to avoid rejection, if any
            new ThreadPoolExecutor.AbortPolicy()
        );
        var traceableExecutor = ContextExecutorService.wrap(executorService,
            ContextSnapshotFactory.builder().build()::captureAll);

        return traceableExecutor;
    }
}


package com.company.project.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;
import org.springframework.util.unit.DataSize;
import org.springframework.validation.annotation.Validated;

@Data
@Validated
@Configuration
@ConfigurationProperties("executor.config")
public class ExecutorConfigurationProperties {
    // Thread pool properties
    private int corePoolSize;
    private int maxPoolSize;
    private int keepAliveSeconds;
}

```



## 2. **Custom ThreadPoolExecutor**

For specialized needs, we can extend `ThreadPoolExecutor` and override its methods to provide custom behaviors, such as logging, monitoring, or modifying task handling.

### **Key Characteristics**

* **Customization**: Full control over the executor's behavior, including thread creation, task execution, and termination policies.

### **Use Cases**

1. **Custom Logging and Monitoring**
   * **Scenario**: Tracking task execution times, number of active threads, and queue sizes.
   * **Customization**: Override methods like `beforeExecute()`, `afterExecute()`, and `terminated()` to add logging.
   * **Why**: Provides insights into the thread pool's performance and task handling.
2. **Custom Thread Creation**
   * **Scenario**: Setting custom thread names, priorities, or other properties.
   * **Customization**: Provide a custom `ThreadFactory` to set specific thread characteristics.
   * **Why**: Helps in debugging and monitoring by providing meaningful thread names.
3. **Custom Task Rejection Handling**
   * **Scenario**: Specific actions when tasks are rejected, such as logging, retrying, or notifying administrators.
   * **Customization**: Implement a custom `RejectedExecutionHandler` to define task rejection behavior.
   * **Why**: Allows graceful degradation and ensures important tasks are not silently dropped.
4. **Task Prioritization**
   * **Scenario**: Prioritizing certain tasks over others based on business logic.
   * **Customization**: Use a custom priority queue and comparator to manage task ordering.
   * **Why**: Ensures high-priority tasks are executed promptly.

### **Usage Example**

```java
class CustomThreadPoolExecutor extends ThreadPoolExecutor {
    public CustomThreadPoolExecutor(int corePoolSize, int maximumPoolSize, long keepAliveTime, TimeUnit unit, BlockingQueue<Runnable> workQueue) {
        super(corePoolSize, maximumPoolSize, keepAliveTime, unit, workQueue);
    }

    @Override
    protected void beforeExecute(Thread t, Runnable r) {
        super.beforeExecute(t, r);
        // Custom logic before task execution
    }

    @Override
    protected void afterExecute(Runnable r, Throwable t) {
        super.afterExecute(r, t);
        // Custom logic after task execution
    }

    @Override
    protected void terminated() {
        super.terminated();
        // Custom logic on termination
    }
}
```

Assuming, we are building an order processing system where each order goes through multiple steps like validation, payment processing, inventory update, and notification. Each step needs to be handled concurrently for efficiency.

```java
import java.util.concurrent.*;

public class CustomThreadPoolExecutor extends ThreadPoolExecutor {

    public CustomThreadPoolExecutor(int corePoolSize, int maximumPoolSize, long keepAliveTime, TimeUnit unit, BlockingQueue<Runnable> workQueue) {
        super(corePoolSize, maximumPoolSize, keepAliveTime, unit, workQueue);
    }

    @Override
    protected void beforeExecute(Thread t, Runnable r) {
        super.beforeExecute(t, r);
        System.out.println("Thread " + t.getName() + " is about to execute task: " + r);
        // Custom logic before task execution, e.g., logging, security checks, etc.
    }

    @Override
    protected void afterExecute(Runnable r, Throwable t) {
        super.afterExecute(r, t);
        if (t != null) {
            System.out.println("Exception occurred during execution: " + t.getMessage());
        }
        System.out.println("Task " + r + " has completed execution.");
        // Custom logic after task execution, e.g., collecting metrics, auditing, etc.
    }

    @Override
    protected void terminated() {
        super.terminated();
        System.out.println("ThreadPool is shutting down. Performing cleanup.");
        // Custom logic on termination, e.g., resource deallocation, final reporting, etc.
    }

    public static void main(String[] args) {
        // Configure the custom ThreadPoolExecutor
        CustomThreadPoolExecutor executor = new CustomThreadPoolExecutor(
                4, // corePoolSize
                8, // maximumPoolSize
                30, // keepAliveTime
                TimeUnit.SECONDS,
                new LinkedBlockingQueue<>(100) // workQueue with a capacity of 100
        );

        // Simulate processing orders
        for (int i = 1; i <= 10; i++) {
            int orderId = i;
            executor.submit(() -> processOrder(orderId));
        }

        // Shutdown the executor
        executor.shutdown();
    }

    private static void processOrder(int orderId) {
        System.out.println("Processing order: " + orderId + " in " + Thread.currentThread().getName());
        try {
            // Simulate different processing times for each order
            Thread.sleep((long) (Math.random() * 3000));
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        System.out.println("Order " + orderId + " processed.");
    }
}
```

## **3. ScheduledThreadPoolExecutor**

`ScheduledThreadPoolExecutor` is an implementation of `ExecutorService` that supports scheduling tasks with a delay or periodic execution. It extends `ThreadPoolExecutor`.

### **Key Characteristics**

* **Delay Scheduling**: Allows scheduling tasks to run after a specified delay.
* **Periodic Scheduling**: Allows scheduling tasks to run repeatedly with a fixed delay or at a fixed rate.

### Use Cases

1. **Periodic Data Backup**: Regularly backing up data to prevent data loss.
   * **Why**: Can schedule tasks to run at fixed intervals.
2. **Scheduled Report Generation**: Generating daily or weekly reports.
   * **Why**: Supports delayed and periodic execution of tasks.
3. **Monitoring and Alerts**: Checking system health and sending alerts if thresholds are crossed.
   * **Why**: Allows periodic checks and actions based on conditions.
4. **Refreshing Cache**: Periodically updating cache data from a database or external source.
   * **Why**: Can refresh cache entries at regular intervals

### **Usage Example**

```java
ScheduledExecutorService scheduledExecutor = Executors.newScheduledThreadPool(5);
scheduledExecutor.scheduleAtFixedRate(() -> {
    // Task to execute
}, 0, 10, TimeUnit.SECONDS);
```

Suppose we want to print the current time every 5 seconds

```java
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class ScheduledThreadPoolExample {
    public static void main(String[] args) {
        // Create a ScheduledThreadPoolExecutor with 2 threads
        ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(2);

        // Schedule a task to run every 5 seconds
        scheduler.scheduleAtFixedRate(() -> {
            System.out.println("Current time: " + System.currentTimeMillis());
        }, 0, 5, TimeUnit.SECONDS); // Initial delay: 0 seconds, Period: 5 seconds

        // Schedule another task to run after a delay of 10 seconds
        scheduler.schedule(() -> {
            System.out.println("Task executed after 10 seconds delay");
        }, 10, TimeUnit.SECONDS);

        // Optionally, schedule a shutdown after a certain period
        scheduler.schedule(() -> {
            System.out.println("Shutting down scheduler...");
            scheduler.shutdown();
        }, 30, TimeUnit.SECONDS); // Shutdown after 30 seconds
    }
}
```

## **4. ForkJoinPool**

`ForkJoinPool` is designed for work-stealing algorithms and is optimized for tasks that can be broken down into smaller pieces (fork) and then joined after completion.

### **Key Characteristics**

* **Work-Stealing**: Threads that finish processing their own tasks can "steal" tasks from other threads.
* **RecursiveTask and RecursiveAction**: Used to define tasks that return results (`RecursiveTask`) or do not return results (`RecursiveAction`).

### Use Cases

1. **Parallel Array Processing**: Performing operations like sorting, searching, or summing elements in large arrays.
   * **Why**: Optimized for tasks that can be recursively divided.
2. **Matrix Multiplication**: Breaking down large matrix operations into smaller tasks.
   * **Why**: Can handle computationally intensive tasks efficiently.
3. **Recursive Algorithms**: Implementing algorithms like the Fibonacci sequence, divide-and-conquer algorithms, etc.
   * **Why**: Supports recursive task splitting and joining.
4. **Data Analysis**: Analyzing large datasets by dividing the data and processing in parallel.
   * **Why**: Efficiently utilizes multiple cores for parallel processing.

### **Usage Example**

```java
ForkJoinPool forkJoinPool = new ForkJoinPool();
forkJoinPool.invoke(new RecursiveTaskExample());
```

Recursive Task to Calculate Sum of an Array

```java
import java.util.concurrent.RecursiveTask;
import java.util.concurrent.ForkJoinPool;

public class ForkJoinPoolExample {
    public static void main(String[] args) {
        // Sample data
        int[] array = new int[1000];
        for (int i = 0; i < array.length; i++) {
            array[i] = i + 1;
        }

        // Create a ForkJoinPool
        ForkJoinPool forkJoinPool = new ForkJoinPool();

        // Submit the task
        Long sum = forkJoinPool.invoke(new SumTask(array, 0, array.length));
        System.out.println("Sum: " + sum);
    }
}

// RecursiveTask to calculate the sum of an array segment
class SumTask extends RecursiveTask<Long> {
    private final int[] array;
    private final int start;
    private final int end;

    private static final int THRESHOLD = 100; // Threshold for splitting tasks

    public SumTask(int[] array, int start, int end) {
        this.array = array;
        this.start = start;
        this.end = end;
    }

    @Override
    protected Long compute() {
        // If the task is small enough, compute directly
        if (end - start <= THRESHOLD) {
            long sum = 0;
            for (int i = start; i < end; i++) {
                sum += array[i];
            }
            return sum;
        } else {
            // Split the task into two subtasks
            int mid = (start + end) / 2;
            SumTask leftTask = new SumTask(array, start, mid);
            SumTask rightTask = new SumTask(array, mid, end);

            // Fork the subtasks and join the results
            leftTask.fork();
            long rightResult = rightTask.compute();
            long leftResult = leftTask.join();
            return leftResult + rightResult;
        }
    }
}

```



## **5. SingleThreadExecutor**

`SingleThreadExecutor` ensures that tasks are executed sequentially in a single thread. It is useful for scenarios where thread safety is a concern, and tasks need to be executed in order.

### **Key Characteristics**

* **Single Thread**: Ensures that only one thread is active at any given time.
* **Queue**: Uses an unbounded queue to hold tasks.

### Use Cases

1. **Logging**: Ensuring logs are written sequentially to avoid data corruption.
   * **Why**: Guarantees that tasks are executed one at a time in the order they are submitted.
2. **Single-User Session Handling**: Managing stateful operations for a single user.
   * **Why**: Ensures that operations are processed in a predictable sequence.
3. **UI Task Execution**: Executing non-UI blocking background tasks in GUI applications.
   * **Why**: Prevents UI freezes by handling tasks in a separate thread.
4. **Transaction Management**: Managing transactions sequentially to avoid conflicts.
   * **Why**: Ensures consistent execution order and data integrity.

### **Usage Example**

```java
ExecutorService singleThreadExecutor = Executors.newSingleThreadExecutor();
singleThreadExecutor.submit(() -> {
    // Task to execute
});
```

Example of logging task

```java
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class SingleThreadExecutorExample {
    public static void main(String[] args) {
        // Create a SingleThreadExecutor
        ExecutorService executor = Executors.newSingleThreadExecutor();

        // Submit tasks
        for (int i = 0; i < 5; i++) {
            final int index = i;
            executor.submit(() -> {
                System.out.println("Executing task " + index + " by " + Thread.currentThread().getName());
                // Simulate some work
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                }
            });
        }

        // Shutdown the executor
        executor.shutdown();
    }
}
```

## **6. CachedThreadPool**

`CachedThreadPool` creates new threads as needed but will reuse previously constructed threads when available. It is suitable for executing many short-lived tasks.

### **Key Characteristics**

* **Thread Reuse**: Reuses threads that have become idle.
* **Unbounded Pool**: Creates new threads as needed but terminates idle threads after 60 seconds.

### **Use Cases**

1. **Handling Web Requests**: Managing a large number of short-lived HTTP requests.
   * **Why**: Dynamically creates new threads for incoming tasks and reuses idle ones.
2. **Asynchronous Processing**: Processing tasks asynchronously, such as sending emails or notifications.
   * **Why**: Suitable for tasks that may come in bursts but don't require long-running threads.
3. **Parallel Downloads**: Downloading multiple files simultaneously.
   * **Why**: Can spawn multiple threads to handle downloads concurrently.
4. **Batch Processing**: Processing large numbers of records in parallel.
   * **Why**: Adapts to the number of tasks, making it efficient for varying workloads.

### **Usage Example**

```java
ExecutorService cachedThreadPool = Executors.newCachedThreadPool();
cachedThreadPool.submit(() -> {
    // Task to execute
});
```

Handling Multiple Web Requests

```java
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class CachedThreadPoolExample {
    public static void main(String[] args) {
        // Create a CachedThreadPool
        ExecutorService executor = Executors.newCachedThreadPool();

        // Simulate handling multiple web requests
        for (int i = 0; i < 10; i++) {
            final int requestId = i;
            executor.submit(() -> {
                System.out.println("Handling request " + requestId + " by " + Thread.currentThread().getName());
                // Simulate request processing
                try {
                    Thread.sleep(2000);
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                }
            });
        }

        // Shutdown the executor
        executor.shutdown();
    }
}
```



## **7. Work-Stealing Pool (Java 8+)**

Introduced in Java 8, `Executors.newWorkStealingPool()` creates a `ForkJoinPool` that uses a work-stealing algorithm. It optimizes CPU utilization for tasks that can be broken into smaller pieces.

### **Key Characteristics**

* **Work-Stealing**: Similar to `ForkJoinPool`, tasks are distributed among worker threads, and idle threads can steal work from busy threads.
* **Parallelism Level**: The pool's parallelism level is typically set to the number of available processors.

### **Use Cases**

1. **Parallel Stream Processing**: Utilizing parallel streams in Java 8+ for bulk data operations.
   * **Why**: Optimizes thread usage and workload distribution.
2. **Real-Time Data Processing**: Handling real-time data feeds and processing events as they arrive.
   * **Why**: Balances the load dynamically, making it suitable for unpredictable workloads.
3. **Game Physics and AI**: Running parallel tasks for physics calculations or AI decision-making in games.
   * **Why**: Efficiently handles parallelism for complex, computationally intensive tasks.
4. **Task-Oriented Workloads**: Any scenario where the workload can be divided into independent tasks, such as web crawling, data scraping, or simulations.
   * **Why**: Work-stealing ensures that all available processing power is utilized, even with uneven task distributions.

### **Usage Example**

```java
ExecutorService workStealingPool = Executors.newWorkStealingPool();
workStealingPool.submit(() -> {
    // Task to execute
});
```





