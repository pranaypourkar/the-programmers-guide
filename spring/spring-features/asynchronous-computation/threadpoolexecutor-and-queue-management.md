# ThreadPoolExecutor and Queue Management

## 1. Bulk Processing with a ThreadPoolExecutor

### Context

We are building a Spring Boot service that processes bulk data (e.g., uploading and processing customer records). We divide incoming data into batches and submit each batch as a task to an `ExecutorService` backed by a `ThreadPoolExecutor`.

We configure:

* A thread pool with `corePoolSize = 10`, `maxPoolSize = 50`
* An **unbounded queue** (`LinkedBlockingQueue`)
* Each task processes a batch of 200 records
* You process 10,000 records total

The tasks perform database operations or external API calls. You want to ensure queue memory is handled safely and avoid system overload.

This scenario highlights common challenges and behavior related to queue management when using `ThreadPoolExecutor`.

### Why a Queue is Used in ThreadPoolExecutor

The queue acts as a buffer between task submission and task execution.

* If all threads are busy, submitted tasks are added to the queue.
* As threads become free, they pull tasks from the queue.
* This helps absorb sudden spikes in workload and prevents rejection (unless configured to reject).

### Types of Queues and Their Behavior

#### a. Unbounded Queue (`LinkedBlockingQueue`)

* Tasks are never rejected.
* Queue size grows as needed.
* Good for bursty loads **only if the processing rate can catch up**.
* Risk: uncontrolled memory usage.

#### b. Bounded Queue (`ArrayBlockingQueue`, `LinkedBlockingQueue(capacity)`)

* Caps the number of waiting tasks.
* Helps control memory usage.
* When full, new task submissions can be rejected or handled based on the `RejectedExecutionHandler`.

### Memory Usage Estimation for Unbounded Queues

Each submitted task (e.g., a lambda or `Runnable`) holds:

* The batch data (e.g., 200 strings)
* References to variables from enclosing scope (closures)
* Overhead from internal wrapping by the executor

#### Example Estimate:

* 200 strings × \~60 bytes = 12,000 bytes (\~12 KB)
* Lambda, CompletableFuture, and Runnable overhead: \~3–5 KB
* Total memory per task ≈ 15–20 KB

| Queue Size (Tasks) | Estimated Memory Usage |
| ------------------ | ---------------------- |
| 100 tasks          | \~1.5–2 MB             |
| 1,000 tasks        | \~15–20 MB             |
| 10,000 tasks       | \~150–200 MB           |
| 100,000 tasks      | \~1.5–2 GB             |

If task submission greatly exceeds task execution rate, the queue size can grow rapidly, consuming large amounts of heap memory.

### What Happens When Threads Pick Up Tasks

* When a thread becomes free, it dequeues the next task.
* Once dequeued, the task is removed from the queue.
* After execution, the task and any batch data it holds become eligible for garbage collection, assuming no other references exist.

So, **yes — the queue size decreases** as tasks are picked up and executed.

### Submission Rate vs Execution Rate

The queue size is directly influenced by this ratio:

* If submission rate > execution rate → queue grows
* If execution rate ≥ submission rate → queue drains or stays stable

Unbounded queues **do not apply backpressure**, so if our producer code is fast, we can accidentally create memory pressure or even out-of-memory errors.

### Monitoring and Observability

We can track queue size during runtime:

```java
int queueSize = ((ThreadPoolExecutor) executorService).getQueue().size();
log.info("Current task queue size: {}", queueSize);
```

Consider logging this periodically or exposing it via an actuator endpoint or Prometheus metrics.

### Alternative Backpressure Techniques Without a Bounded Queue

If you must use an unbounded queue but want to avoid overload:

* Use a `Semaphore` to limit the number of concurrent in-flight tasks.
* Use `RateLimiter` (e.g., Guava or Bucket4j) to throttle task submission.
* Divide task submission into "waves" and wait for one wave to complete before submitting more.

Example using `Semaphore`:

```java
Semaphore semaphore = new Semaphore(10);

for (...) {
    semaphore.acquire();

    CompletableFuture.runAsync(() -> {
        try {
            doWork();
        } finally {
            semaphore.release();
        }
    }, executor);
}
```

### Best Practices for Queue Management

1. **Avoid unbounded queues in high-throughput systems** unless:
   * You control the number of submitted tasks
   * The system load is predictable
2. **Estimate memory impact** based on batch size and task data.
3. **Monitor queue size and thread utilization** regularly.
4. **Limit concurrency via thread count or a semaphore**, especially if queue must remain unbounded.
5. **Use `CallerRunsPolicy` or custom rejection logic** if using a bounded queue to safely handle overload.
6. **Do not assume GC will save you** — heap pressure from queue growth can lead to longer GC pauses or OOMs.

### When to Prefer Unbounded vs Bounded Queues

<table data-full-width="true"><thead><tr><th>Use Case</th><th>Queue Type</th><th>Notes</th></tr></thead><tbody><tr><td>Controlled batch jobs</td><td>Unbounded</td><td>Safe if submission is throttled</td></tr><tr><td>Real-time APIs with limited latency</td><td>Bounded</td><td>Prevents queue overload</td></tr><tr><td>Resource-intensive processing</td><td>Bounded + Rejection</td><td>Controls memory and CPU usage</td></tr><tr><td>You want to avoid task rejection</td><td>Unbounded + Semaphore</td><td>Use a concurrency limiter to backpressure</td></tr></tbody></table>
