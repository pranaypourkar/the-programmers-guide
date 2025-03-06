# Semaphore

## About

A **Semaphore** is a **concurrency control mechanism** used to restrict the number of threads that can access a shared resource **simultaneously**. It is part of the `java.util.concurrent` package and is particularly useful when controlling access to a limited resource such as **database connections, file systems, network sockets, or thread pools**.

A **Semaphore** is a **counter-based synchronization construct** that allows a maximum number of threads to access a resource **at the same time**.

* A semaphore **maintains a set of permits**.
* A thread **must acquire a permit before proceeding**.
* If no permits are available, the thread **blocks** until one is released.
* A thread **must release a permit after finishing its task**

## **Why Use a Semaphore?**

1. **Control Concurrent Access** – Limit the number of threads accessing a resource.
2. **Prevent Overloading** – Avoid exhausting system resources like database connections.
3. **Fair Resource Allocation** – Ensure fair access to shared resources.
4. **Thread Pooling** – Manage worker threads efficiently.
5. **Avoiding Deadlocks & Starvation** – Prevent resource starvation and improve concurrency control.

## **Types of Semaphores**

### **1. Counting Semaphore**

A **Counting Semaphore** is a semaphore that allows multiple permits, where each permit represents **one unit of a shared resource**. The number of available permits defines how many threads can access the resource at the same time.

#### **How It Works?**

* When a thread wants to access the shared resource, it **acquires** a permit using `acquire()`.
* If all permits are taken, the thread **blocks** until a permit is available.
* Once the thread is done using the resource, it **releases** the permit using `release()`, making it available for another thread.

#### **Use Cases**

* **Resource Pooling:** Database connection pools, file system access, network socket management.
* **Rate Limiting:** Controlling API requests or access to limited resources.
* **Thread Synchronization:** Ensuring that only a specific number of threads execute a particular section of code.

#### Example Implementation

{% hint style="success" %}
* **Only 3 threads** can acquire a permit and proceed simultaneously.
* The **4th thread must wait** until one of the previous threads releases a permit.
* This is useful for **controlling concurrent access to limited resources**.
{% endhint %}

```java
import java.util.concurrent.Semaphore;

public class CountingSemaphoreExample {
    private static final int MAX_PERMITS = 3;
    private final Semaphore semaphore = new Semaphore(MAX_PERMITS); // Allows up to 3 threads

    public void accessResource() {
        try {
            semaphore.acquire();  // Acquire a permit
            System.out.println(Thread.currentThread().getName() + " acquired a permit.");
            Thread.sleep(2000);  // Simulating task execution
        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {
            semaphore.release();  // Release the permit
            System.out.println(Thread.currentThread().getName() + " released a permit.");
        }
    }

    public static void main(String[] args) {
        CountingSemaphoreExample example = new CountingSemaphoreExample();

        // Creating multiple threads to access the resource
        Runnable task = example::accessResource;

        Thread t1 = new Thread(task, "Thread 1");
        Thread t2 = new Thread(task, "Thread 2");
        Thread t3 = new Thread(task, "Thread 3");
        Thread t4 = new Thread(task, "Thread 4"); // This thread will wait

        t1.start();
        t2.start();
        t3.start();
        t4.start();
    }
}
```

### **2. Binary Semaphore (Mutex)**

A **Binary Semaphore**, also known as a **Mutex (Mutual Exclusion)**, is a semaphore with **only one permit** (`0` or `1`). This ensures that **only one thread can access the critical section at a time**.

#### **How It Works?**

* When a thread acquires the permit, the **semaphore count goes to 0**, preventing other threads from acquiring it.
* Once the thread releases the permit, the **count becomes 1**, allowing another thread to acquire it.
* Binary semaphores do not track ownership, meaning any thread can release a permit, which may lead to incorrect behavior.

#### **Use Cases**

* **Mutual Exclusion:** Ensuring that only one thread enters a critical section at a time.
* **Alternative to Locks:** Provides similar functionality to `synchronized` or `ReentrantLock`.
* **Thread Signaling:** Can be used for **thread coordination**, where one thread signals another to proceed.

#### **Example Implementation**

{% hint style="success" %}
* **Only one thread at a time** can enter the critical section.
* The **second thread must wait** until the first thread releases the permit.
* **Works similarly to `synchronized` and `ReentrantLock`** but does not provide **reentrancy**.
{% endhint %}

```java
import java.util.concurrent.Semaphore;

public class BinarySemaphoreExample {
    private final Semaphore mutex = new Semaphore(1); // Only 1 permit

    public void criticalSection() {
        try {
            mutex.acquire(); // Acquiring the only permit
            System.out.println(Thread.currentThread().getName() + " is in the critical section.");
            Thread.sleep(2000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {
            mutex.release(); // Releasing the permit
            System.out.println(Thread.currentThread().getName() + " exited the critical section.");
        }
    }

    public static void main(String[] args) {
        BinarySemaphoreExample example = new BinarySemaphoreExample();

        Thread t1 = new Thread(example::criticalSection, "Thread 1");
        Thread t2 = new Thread(example::criticalSection, "Thread 2");

        t1.start();
        t2.start();
    }
}
```

## **Fair vs. Unfair Semaphore**

### **Fair Semaphore (FIFO Order)**

By default, `Semaphore` is **unfair**, meaning threads **may not acquire permits in order**.\
If fairness is required, **pass `true` in the constructor** to enforce FIFO order.

```java
Semaphore fairSemaphore = new Semaphore(2, true); // Ensures first-come-first-serve order
```

* Fair semaphore prevents starvation but may reduce performance.

### **Unfair Semaphore (Default)**

```java
Semaphore unfairSemaphore = new Semaphore(2);  // Default is false (unfair)
```

* Threads may acquire permits out of order.
* Higher performance but possible starvation.

## **Releasing More Permits Than Acquired (Over-Release Issue)**

Unlike `ReentrantLock` or `synchronized`, **a semaphore does not track which thread acquired a permit**, meaning a thread can mistakenly release more permits than it acquired.

{% hint style="success" %}
* A **thread can release permits it never acquired**, **causing logical inconsistencies**.
* This makes semaphores **less strict than locks**.
{% endhint %}

```java
import java.util.concurrent.Semaphore;

public class OverReleaseExample {
    private final Semaphore semaphore = new Semaphore(2);

    public void releaseWithoutAcquire() {
        semaphore.release();  // Incorrect release
        System.out.println("Extra permit released!");
    }

    public static void main(String[] args) {
        OverReleaseExample example = new OverReleaseExample();
        example.releaseWithoutAcquire();
    }
}
```

## **Semaphore vs. ReentrantLock vs. Synchronized**

<table data-full-width="true"><thead><tr><th width="203">Feature</th><th width="318">Semaphore</th><th width="182">ReentrantLock</th><th>synchronized</th></tr></thead><tbody><tr><td><strong>Control</strong></td><td>Limits threads accessing a resource</td><td>Full thread control</td><td>Automatic</td></tr><tr><td><strong>Fairness</strong></td><td>FIFO (if enabled)</td><td>FIFO (if enabled)</td><td>Always unfair</td></tr><tr><td><strong>Interruptibility</strong></td><td>No</td><td>Yes</td><td>No</td></tr><tr><td><strong>Timeout Support</strong></td><td><code>tryAcquire()</code></td><td><code>tryLock()</code></td><td>No timeout</td></tr><tr><td><strong>Reentrancy</strong></td><td>No</td><td>Yes</td><td>Yes</td></tr><tr><td><strong>Condition Variables</strong></td><td>No</td><td><code>Condition</code></td><td><code>wait()/notify()</code></td></tr></tbody></table>

## **Best Practices**

1. **Use a semaphore for resource pooling** (e.g., database connections).
2. **Avoid over-releasing permits**, as it leads to incorrect behavior.
3. **Prefer `tryAcquire()` for non-blocking attempts**.
4. **Use fair semaphores when starvation must be avoided**.
5. **Use binary semaphores for simple mutual exclusion** instead of locks.
