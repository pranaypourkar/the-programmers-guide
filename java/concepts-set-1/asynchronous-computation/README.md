# Asynchronous Computation

## About

Asynchronous computation refers to the execution of tasks or operations independently of the main program flow. In synchronous programming, tasks are executed one after the other, and the program waits for each task to complete before moving on to the next one. However, in asynchronous programming, tasks can be executed concurrently, and the program does not wait for each task to finish before proceeding.

<figure><img src="../../../.gitbook/assets/image (33).png" alt=""><figcaption></figcaption></figure>

## Parallelism and Concurrency

Parallelism and concurrency are both important concepts in asynchronous computation, but they are distinct and address different aspects of task execution.

### **Concurrency in Async Computation**

* **Definition:** Concurrency in the context of async computation refers to the ability to handle multiple tasks in overlapping time periods. This doesn't necessarily mean that the tasks are being executed simultaneously (in parallel); rather, they are interleaved in such a way that they make progress over time without waiting for other tasks to complete.
* **In Async Computation:** When we use asynchronous programming (e.g., `@Async` in Spring), we allow tasks to be handled concurrently. For example, a web server might handle multiple incoming HTTP requests concurrently, ensuring that no single request blocks others.

### **Parallelism in Async Computation**

* **Definition:** Parallelism is the simultaneous execution of multiple tasks, typically on multiple cores or processors. Parallelism can be seen as a subset of concurrency, but it specifically involves tasks running at the same time on different processing units.
* **In Async Computation:** When asynchronous tasks are executed on a multi-core processor, and each task is running on a separate core, that's parallelism. For instance, multiple computationally intensive tasks can be run in parallel using a thread pool, where each thread is potentially handled by a different core.

### **How They Relate to Async Computation**

* **Concurrency:** Asynchronous programming is fundamentally about concurrency. It allows tasks to be non-blocking, so the system can manage and schedule multiple tasks that are waiting for resources, I/O, or other tasks to complete. For instance, an async method might fetch data from a remote server while other parts of the application continue to run.
* **Parallelism:** While async computation often involves concurrency, parallelism can be an optimization where tasks are truly executed simultaneously. If the asynchronous tasks are CPU-bound and your system has multiple cores, they can be processed in parallel, leading to performance gains.
