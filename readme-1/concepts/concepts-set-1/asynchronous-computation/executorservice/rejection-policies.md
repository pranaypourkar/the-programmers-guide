# Rejection Policies

## About

Rejection policies in Java ExecutorService determine how the executor handles new tasks when it cannot accept them, either because the work queue is full or the executor has been shut down. These policies are essential for managing task overloads and ensuring the application handles such scenarios gracefully.

## **Reasons for Task Rejection**

1. **Work Queue is Full**: When using a bounded queue, if all threads are busy and the queue is at its maximum capacity, new tasks cannot be accepted until there is space in the queue.
2. **Executor Shutdown**: When the executor service is shutting down or has already shut down, it will not accept new tasks.

## Built-in Rejection Policies

Java provides several built-in rejection policies implemented in the `RejectedExecutionHandler` interface within the `java.util.concurrent` package. These are:

1. **AbortPolicy**
2. **CallerRunsPolicy**
3. **DiscardPolicy**
4. **DiscardOldestPolicy**

### **1. AbortPolicy**

**Description**:

* This is the default rejection policy.
* It throws a `RejectedExecutionException` when a task cannot be accepted for execution.

**Usage Scenario**:

* Suitable for scenarios where it is critical to know if a task was rejected, and appropriate measures need to be taken, such as logging or triggering alerts.

**Example**:

```java
ExecutorService executor = new ThreadPoolExecutor(
    5, 
    10, 
    60L, 
    TimeUnit.SECONDS, 
    new ArrayBlockingQueue<>(100), 
    new ThreadPoolExecutor.AbortPolicy()
);
```

### **2. CallerRunsPolicy**

**Description**:

* The calling thread executes the rejected task directly.
* This provides a simple feedback mechanism to throttle the rate of task submission.

**Usage Scenario**:

* Useful when the system should never drop tasks, and you want to slow down the task producer when the executor is overloaded.

**Example**:

```java
ExecutorService executor = new ThreadPoolExecutor(
    5, 
    10, 
    60L, 
    TimeUnit.SECONDS, 
    new ArrayBlockingQueue<>(100), 
    new ThreadPoolExecutor.CallerRunsPolicy()
);
```

### **3. DiscardPolicy**

**Description**:

* Silently discards the rejected task without any notification.

**Usage Scenario**:

* Suitable for scenarios where dropping tasks is acceptable, such as when the tasks are non-critical or can be retried later without significant impact.

**Example**:

```java
ExecutorService executor = new ThreadPoolExecutor(
    5, 
    10, 
    60L, 
    TimeUnit.SECONDS, 
    new ArrayBlockingQueue<>(100), 
    new ThreadPoolExecutor.DiscardPolicy()
);
```

### **4. DiscardOldestPolicy**

**Description**:

* Discards the oldest unhandled task in the queue and retries the rejected task.

**Usage Scenario**:

* Suitable when the most recent tasks are more important than older ones, ensuring the system keeps processing newer tasks.

**Example**:

```java
ExecutorService executor = new ThreadPoolExecutor(
    5, 
    10, 
    60L, 
    TimeUnit.SECONDS, 
    new ArrayBlockingQueue<>(100), 
    new ThreadPoolExecutor.DiscardOldestPolicy()
);
```

### Custom Rejection Policies

If the built-in policies do not meet specific requirements, we can implement a custom `RejectedExecutionHandler`. This allows to define custom behavior when a task is rejected.

**Example**:

```java
public class CustomRejectionPolicy implements RejectedExecutionHandler {

    @Override
    public void rejectedExecution(Runnable r, ThreadPoolExecutor executor) {
        // Custom handling logic, such as logging or saving the task for later execution
        System.out.println("Task rejected: " + r.toString());
        // Optionally requeue or handle the task differently
    }
}

ExecutorService executor = new ThreadPoolExecutor(
    5, 
    10, 
    60L, 
    TimeUnit.SECONDS, 
    new ArrayBlockingQueue<>(100), 
    new CustomRejectionPolicy()
);
```



