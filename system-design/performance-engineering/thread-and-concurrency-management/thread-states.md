# Thread States

## About

Thread states describe the current status of a thread in a Java Virtual Machine (JVM). These states help understand how the application is using threads — whether they are actively working, waiting, blocked, or idle.

Tracking thread states is important in production systems to:

* Diagnose performance bottlenecks
* Detect thread leaks
* Understand concurrency behavior
* Optimize thread pool configuration

## **1. NEW**

A thread is in the `NEW` state when it has been created, but its `start()` method has **not been called yet**. It is like a plan to start work, but not started.

#### Technical Characteristics:

* Exists as a `Thread` object in memory.
* It has not been scheduled by the thread scheduler.
* It consumes almost no system resources (no stack, no OS thread).

#### Real-World Insight:

In production systems, we rarely observe threads stuck in the NEW state unless:

* There’s a bug where threads are created but never started.
* Some code dynamically creates threads but defers their execution (bad practice if overused).

> **Example:** In a job-processing system, creating 100 threads and only starting a few could lead to wasted memory and design flaws.

## **2. RUNNABLE**

This state means the thread is **ready to run** or is **actively running** on a CPU. It is under the control of the **OS thread scheduler**.

#### Technical Characteristics:

* The thread may be executing Java bytecode or may be waiting for CPU time.
* It’s considered “alive” and consuming CPU cycles.

#### Real-World Insight:

* Most active business logic runs in this state.
* High CPU usage is typically due to too many threads in RUNNABLE state.
* If all threads are RUNNABLE but the system is slow, it might indicate **CPU starvation**.

> **Example:** A backend service that handles thousands of requests per second will have many threads in the RUNNABLE state doing JSON parsing, DB calls, or business logic.

## **3. BLOCKED**

A thread is BLOCKED when it wants to enter a `synchronized` block or method, but **another thread already holds the lock**.

#### Technical Characteristics:

* Only one thread can hold a lock on an object at a time.
* BLOCKED threads are waiting for the lock to be released.

#### Real-World Insight:

* This is a sign of **thread contention**.
* If many threads are BLOCKED, it can create a bottleneck, reduce throughput, and eventually cause deadlocks or timeouts.
* This often shows up in thread dumps during production issues.

> **Example:** Two API requests trying to update the same shared cache key at the same time. Only one can hold the lock — others will be BLOCKED, causing latency.

## **4. WAITING**

The thread is **waiting indefinitely** for **another thread to perform an action**. Unlike BLOCKED, it’s not trying to acquire a lock; it’s waiting to be notified.

#### Technical Characteristics:

* Happens when a thread calls `wait()`, `join()`, or `LockSupport.park()` without timeout.
* It will remain in this state until explicitly woken up.

#### Real-World Insight:

* Used for thread coordination — for example, producer-consumer models.
* Risk: If the signal (like `notify()`) is missed, the thread may wait forever — leading to a **hung application**.

> **Example:** In a workflow engine, a processing thread may WAIT for another thread to complete a prerequisite task. If the upstream thread crashes, the WAITING thread gets stuck forever.

## **5. TIMED\_WAITING**

The thread is waiting, **but only for a fixed time**. After that, it will automatically wake up and continue.

#### Technical Characteristics:

* Happens when a thread calls:
  * `Thread.sleep(timeout)`
  * `wait(timeout)`
  * `join(timeout)`
  * `LockSupport.parkNanos()`
* It’s a **passive** wait: the thread isn’t using CPU while waiting.

#### Real-World Insight:

* Very common in retry logic, timeouts, backoff strategies, and scheduled jobs.
* Too many threads stuck in TIMED\_WAITING may indicate:
  * Too long of a timeout
  * Poor retry/backoff configuration
  * Slow downstream dependencies

> **Example:** A Spring Boot app calls a third-party payment service with `RestTemplate` + 5s timeout. If the service is slow, the calling thread sits in TIMED\_WAITING for 5 seconds — then either continues or fails.

## **6. TERMINATED**

The thread has **finished execution** — either completed its task or died due to an unhandled exception.

#### Technical Characteristics:

* It cannot be restarted.
* Memory/resources used by the thread will be released by the JVM.

#### Real-World Insight:

* Normally expected after task completion.
* But if we observe **hundreds or thousands of TERMINATED threads**, it may indicate:
  * Thread objects are not being garbage collected
  * New threads are being created repeatedly instead of being reused (common bug)

> **Example:** A misconfigured `@Async` method in Spring that creates a new thread per call without using a thread pool may result in memory pressure and performance degradation, even though threads are TERMINATED.

## **How to See Thread States in Real Apps**

* Use `jstack` or a Java profiler to get a thread dump
* Use Prometheus and Micrometer to monitor thread states over time
* In Spring Boot, these are often exposed as metrics like:

```promql
jvm_threads_states_threads{state="BLOCKED"}
```

## What to Look For ?

<table data-full-width="true"><thead><tr><th width="241.84375">Symptom</th><th>Possible Thread State Issue</th><th>Diagnosis Strategy</th></tr></thead><tbody><tr><td>High CPU usage</td><td>Many threads in RUNNABLE</td><td>Check Prometheus / thread dump</td></tr><tr><td>Slowness, latency spikes</td><td>Many threads BLOCKED</td><td>Investigate shared locks / synchronized</td></tr><tr><td>Hanging application</td><td>Threads WAITING indefinitely</td><td>Check for missed signals or deadlocks</td></tr><tr><td>Long retry/wait patterns</td><td>Excess TIMED_WAITING threads</td><td>Review timeouts, network retries</td></tr><tr><td>OutOfMemoryError or crash</td><td>Growing TERMINATED threads</td><td>Ensure thread reuse / thread pool usage</td></tr></tbody></table>

## Thread State in System Design Perspective

Thread states affect:

* **Throughput**: How many requests can be handled per second
* **Latency**: How fast responses are returned
* **Stability**: How resilient our app is under load

That’s why system designers must:

* Tune thread pools properly
* Avoid shared locks in high-concurrency paths
* Choose async patterns when appropriate (e.g., `@Async`, reactive programming)
* Use observability tools (e.g., Prometheus, Grafana) to track thread state trends

## **Tips**

* **BLOCKED** threads should be investigated first — often signal thread contention or deadlocks.
* A healthy system typically has a small number of **RUNNABLE** threads and some **TIMED\_WAITING** or **WAITING** threads depending on workload.
* Avoid unbounded thread creation — use thread pools with limits.
* Sudden spike in any specific thread state could indicate a new issue in code, deployment, or external dependencies.

## **Scenarios in Spring Boot**

### **WAITING Thread State**

<table data-header-hidden data-full-width="true"><thead><tr><th></th><th></th><th width="148.123291015625"></th><th></th></tr></thead><tbody><tr><td><strong>Scenario</strong></td><td><strong>Why WAITING Happens</strong></td><td><strong>Healthy Count</strong></td><td><strong>If High, It Might Indicate</strong></td></tr><tr><td><code>@Async</code> method waiting for another async task (<code>Future.get()</code>)</td><td>Main thread waits for result of background task</td><td>Low to moderate</td><td>Async task not completing, stuck thread, deadlock</td></tr><tr><td>Using <code>Thread.join()</code></td><td>One thread waits for another to finish</td><td>Very low</td><td>Long-running threads, improper coordination</td></tr><tr><td>Java's <code>wait()</code> (e.g., custom lock or queue usage)</td><td>Waiting for notify/notifyAll on an object</td><td>Low</td><td>Missing notify call, misused wait-notify pattern</td></tr><tr><td>ExecutorService <code>.awaitTermination()</code></td><td>Thread waiting for pool shutdown</td><td>Very low</td><td>App is shutting down or hanging on shutdown</td></tr><tr><td>Message listener containers (like Kafka or RabbitMQ)</td><td>Listener thread may WAIT when idle, waiting for messages</td><td>Low to moderate</td><td>Normal unless message queue is stuck</td></tr><tr><td>Servlet container thread waiting for a response (e.g., HTTP client)</td><td>Threads calling a blocking HTTP service and internally using a wait mechanism</td><td>Low</td><td>Slow downstream service, lack of timeouts</td></tr><tr><td>Reactive Spring + non-reactive fallback logic</td><td>Sometimes internal blocking code is used for fallback (bad practice in reactive systems)</td><td>Should be near zero</td><td>Violation of reactive principles — mixing blocking + non-blocking</td></tr></tbody></table>
