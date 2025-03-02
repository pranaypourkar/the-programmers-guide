---
hidden: true
---

# Thread Basics

A **thread** is the smallest unit of execution in a program. In Java, every program runs on at least one thread, known as the **main thread**.

## **1. What is a Thread?**

* A **thread** is a lightweight process that runs independently.
* Java supports **multithreading**, meaning multiple threads can run simultaneously.
* Each thread has its own **execution path** but shares resources with other threads in the same process.

### **Analogy**

Imagine a **thread** as a train running on a track.

* **A single-threaded program** is like one train running on a single track, completing one task at a time.
* **A multi-threaded program** is like multiple trains running on parallel tracks, performing tasks simultaneously.

Here’s a visual representation of threads:

```
Main Thread  -----> Task 1 -----> Task 2 -----> Task 3  (Sequential Execution)

Multi-Threading:
Thread 1  -----> Task A -----> Task B  
Thread 2  -----> Task X -----> Task Y  
(Thread 1 and Thread 2 run in parallel)
```

### **Java Thread Package**

Threads in Java are part of the `java.lang` package, primarily using the following classes and interfaces:

* `java.lang.Thread` → The main class for creating and managing threads.
* `java.lang.Runnable` → Functional interface for defining thread tasks.
* `java.util.concurrent` package → Provides higher-level concurrency utilities.

## **2. Why Use Threads?**

* Improves application performance by utilizing **multiple CPU cores**.
* Allows multiple tasks to execute **simultaneously** (e.g., UI responsiveness, background tasks).
* Enables **parallel execution** for tasks like data processing, computations, and network requests.

## **3. Thread Lifecycle**

A thread goes through multiple states:

1. **New** → Thread is created but not started.
2. **Runnable** → Ready to run but waiting for CPU.
3. **Running** → Actively executing.
4. **Blocked/Waiting** → Paused, waiting for a resource.
5. **Terminated** → Execution is completed or stopped.

## **4. Thread Priorities**

Each thread in Java has a priority (range **1 to 10**). Default priority is `5 (NORM_PRIORITY)`.

* `Thread.MIN_PRIORITY` → 1
* `Thread.NORM_PRIORITY` → 5
* `Thread.MAX_PRIORITY` → 10

## **5. Daemon vs User Threads**

* **User Threads** → Standard application threads.
* **Daemon Threads** → Background threads that terminate when no user thread is running.

\
