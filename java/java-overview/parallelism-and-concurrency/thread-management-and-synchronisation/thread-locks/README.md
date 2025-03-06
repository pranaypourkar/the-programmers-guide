# Thread Locks

## About

A **lock** is a synchronization mechanism that controls access to shared resources in a **multithreaded environment**. Locks ensure that only **one thread** can access a critical section at a time, preventing **race conditions, data inconsistency, and thread interference**.

## **Why Are Locks Needed?**

In Java, multiple threads can execute concurrently, which can lead to **unexpected behavior** when accessing shared resources. Locks are required to:

1. **Prevent Data Corruption** – Ensures that two threads don’t modify shared data simultaneously.
2. **Maintain Data Consistency** – Prevents inconsistent reads and writes.
3. **Avoid Race Conditions** – Ensures proper sequencing of operations.
4. **Ensure Thread Safety** – Provides a controlled environment for resource access.
5. **Control Execution Order** – Ensures critical sections execute in the correct order.

## **Types of Locks in Java**

Locks can be classified based on **their behavior, scope, and implementation**. Below are the major categories:

### **1. Intrinsic Locks (Monitor Locks)**

* Implicitly used by `synchronized` methods and blocks.
* Each object in Java has a built-in **monitor lock**.
* Only **one thread** can acquire the lock at a time.

### **2. Explicit Locks**

* Provided by the `java.util.concurrent.locks` package.
* Require manual locking and unlocking.
* Examples:
  * `ReentrantLock`
  * `ReadWriteLock`
  * `StampedLock`

## **Lock Scopes**

* **Method-Level Lock** – Applied to an entire method using `synchronized`.
* **Block-Level Lock** – Applied to a specific block of code.
* **Object-Level Lock** – Applied to an instance of a class.
* **Class-Level Lock** – Applied to static members.

## **Locking Strategies**

* **Fair vs. Unfair Locks** – Determines the order in which threads acquire locks.
* **Reentrant Locks** – Allows the same thread to acquire the lock multiple times.
* **Spin Locks** – Actively wait for a lock instead of blocking.
* **Optimistic Locks** – Assume no conflicts and validate before committing changes.

## **Intrinsic vs. Explicit Locks**

<table data-full-width="true"><thead><tr><th width="211">Feature</th><th width="293">Intrinsic (Monitor) Lock</th><th>Explicit (ReentrantLock)</th></tr></thead><tbody><tr><td><strong>Implementation</strong></td><td><code>synchronized</code> keyword</td><td><code>ReentrantLock</code> class</td></tr><tr><td><strong>Locking &#x26; Unlocking</strong></td><td>Handled by JVM</td><td>Requires manual <code>lock()</code> and <code>unlock()</code></td></tr><tr><td><strong>Fairness</strong></td><td>Always unfair</td><td>Can be fair (<code>new ReentrantLock(true)</code>)</td></tr><tr><td><strong>Interruptibility</strong></td><td>Cannot be interrupted</td><td>Supports <code>lockInterruptibly()</code></td></tr><tr><td><strong>Condition Variables</strong></td><td>Uses <code>wait()/notify()</code></td><td>Supports <code>Condition</code> objects</td></tr><tr><td><strong>Performance</strong></td><td>Simpler but less flexible</td><td>More control, can be optimized</td></tr></tbody></table>

## **Problems With Locks**

Locks can introduce several issues if not managed properly:

1. **Deadlocks** – Occur when two or more threads wait indefinitely for each other’s locks.
2. **Starvation** – Low-priority threads may never get a chance to execute.
3. **Livelocks** – Threads keep changing states without making progress.
4. **Performance Overhead** – Excessive locking can reduce concurrency.
