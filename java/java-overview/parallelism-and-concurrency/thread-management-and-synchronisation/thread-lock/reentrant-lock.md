# Reentrant Lock

## About

A **Reentrant Lock** is an **explicit locking mechanism** provided by `java.util.concurrent.locks.ReentrantLock`. Unlike the **intrinsic locks** (monitor locks) obtained via the `synchronized` keyword, **ReentrantLock provides more flexibility and advanced control over thread synchronization**.

A **Reentrant Lock** is a type of **mutual exclusion (mutex) lock** that allows **the same thread** to acquire the lock **multiple times** without causing itself to block. The lock maintains a hold count, increasing when the thread re-acquires it and decreasing when it releases it. When the count reaches zero, the lock is fully released.

This behavior is useful in **recursive method calls** where a thread that already holds the lock **can re-enter the same locked section without deadlocking itself.**

## **Why Use Reentrant Locks?**

1. **Provides More Control** – Unlike `synchronized`, you can manually lock/unlock.
2. **Supports Fairness Policy** – You can choose a fair lock that grants access in a FIFO order.
3. **Interruptible Locking** – A thread can be interrupted while waiting for the lock.
4. **Timeout Support** – The lock can be acquired with a timeout to prevent indefinite blocking.
5. **Multiple Condition Variables** – Supports advanced wait-notify mechanisms via `Condition` objects.

## **How to Use Reentrant Lock?**

### **Basic Locking and Unlocking**

{% hint style="success" %}
In this example,

* The lock is **explicitly acquired and released**.
* The `finally` block **ensures the lock is always released** to prevent deadlocks.
* Unlike `synchronized`, we can handle situations where the lock is unavailable.
{% endhint %}

```java
import java.util.concurrent.locks.ReentrantLock;

public class ReentrantLockExample {
    private final ReentrantLock lock = new ReentrantLock();

    public void criticalSection() {
        lock.lock();  // Acquiring the lock
        try {
            System.out.println(Thread.currentThread().getName() + " is executing critical section");
        } finally {
            lock.unlock();  // Always release the lock in finally
        }
    }

    public static void main(String[] args) {
        ReentrantLockExample example = new ReentrantLockExample();

        Runnable task = example::criticalSection;

        Thread t1 = new Thread(task, "Thread 1");
        Thread t2 = new Thread(task, "Thread 2");

        t1.start();
        t2.start();
    }
}
```

### **Reentrant Behavior**

A thread can acquire the lock multiple times without blocking itself.

{% hint style="success" %}
In this example,

* **Same thread** can re-enter a locked section without deadlocking itself.
* The **hold count** increases with every re-entry and decreases when unlocking.
{% endhint %}

```java
import java.util.concurrent.locks.ReentrantLock;

public class ReentrantLockDemo {
    private final ReentrantLock lock = new ReentrantLock();

    public void recursiveMethod(int count) {
        lock.lock();
        try {
            System.out.println("Reentrant Lock acquired: " + count);
            if (count > 0) {
                recursiveMethod(count - 1);  // Recursive call
            }
        } finally {
            lock.unlock();
        }
    }

    public static void main(String[] args) {
        ReentrantLockDemo demo = new ReentrantLockDemo();
        demo.recursiveMethod(3);
    }
}
```

### **Try Locking with Timeout**

To avoid **indefinite blocking**, a thread can attempt to acquire a lock with a **timeout**.

{% hint style="info" %}
In this example,

* If the lock isn’t available within `2` seconds, the thread does not block indefinitely.
* Helps in preventing deadlocks.
{% endhint %}

```java
import java.util.concurrent.locks.ReentrantLock;
import java.util.concurrent.TimeUnit;

public class TryLockExample {
    private final ReentrantLock lock = new ReentrantLock();

    public void performTask() {
        try {
            if (lock.tryLock(2, TimeUnit.SECONDS)) { // Wait for 2 seconds
                try {
                    System.out.println(Thread.currentThread().getName() + " acquired lock");
                    Thread.sleep(1000);
                } finally {
                    lock.unlock();
                }
            } else {
                System.out.println(Thread.currentThread().getName() + " could not acquire lock");
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        TryLockExample example = new TryLockExample();

        Runnable task = example::performTask;
        Thread t1 = new Thread(task, "Thread 1");
        Thread t2 = new Thread(task, "Thread 2");

        t1.start();
        t2.start();
    }
}
```

### **Interruptible Locking**

A thread waiting for a lock **can be interrupted**.

{% hint style="success" %}
* If `lockInterruptibly()` is used, the waiting thread **can be interrupted**.
* Useful in applications where **cancellation of tasks is required**.
* If `lockInterruptibly()` is **not used**, and instead `lock()` is used, then **the waiting thread cannot be interrupted** while it is blocked, meaning it will remain in the waiting state indefinitely until it acquires the lock.
{% endhint %}

```java
import java.util.concurrent.locks.ReentrantLock;

public class InterruptibleLockExample {
    private final ReentrantLock lock = new ReentrantLock();

    public void performTask() {
        try {
            lock.lockInterruptibly();
            try {
                System.out.println(Thread.currentThread().getName() + " acquired lock");
                Thread.sleep(3000);
            } finally {
                lock.unlock();
            }
        } catch (InterruptedException e) {
            System.out.println(Thread.currentThread().getName() + " was interrupted while waiting for lock");
        }
    }

    public static void main(String[] args) {
        InterruptibleLockExample example = new InterruptibleLockExample();
        Thread t1 = new Thread(example::performTask, "Thread 1");
        Thread t2 = new Thread(example::performTask, "Thread 2");

        t1.start();
        t2.start();

        try {
            Thread.sleep(1000);
            t2.interrupt();  // Interrupting Thread 2 while it's waiting
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
```

## **Fair vs. Non-Fair Locks**

By default, **ReentrantLock is unfair**, meaning the lock is **not granted in a strict queue order**. This can lead to **starvation**.

### **Fair Lock Example (FIFO Order)**

```java
ReentrantLock fairLock = new ReentrantLock(true);  // Fair lock
```

* **Ensures FIFO order** – The longest waiting thread gets the lock next.
* **Can reduce performance** due to increased context switching.

### **Unfair Lock Example (Default)**

```java
ReentrantLock unfairLock = new ReentrantLock();  // Default is false (unfair)
```

* **Threads may not get the lock in order**.
* **Higher throughput** but risk of starvation.

## **ReentrantLock vs. Synchronized**

<table data-full-width="true"><thead><tr><th width="230">Feature</th><th width="365">ReentrantLock</th><th>synchronized</th></tr></thead><tbody><tr><td><strong>Locking &#x26; Unlocking</strong></td><td>Manual (<code>lock()</code> and <code>unlock()</code>)</td><td>Automatic</td></tr><tr><td><strong>Fairness</strong></td><td>Supports fair locking</td><td>Always unfair</td></tr><tr><td><strong>Interruptibility</strong></td><td>Can be interrupted</td><td>Cannot be interrupted</td></tr><tr><td><strong>Timeout Support</strong></td><td><code>tryLock()</code> prevents indefinite blocking</td><td>No timeout support</td></tr><tr><td><strong>Multiple Conditions</strong></td><td>Uses <code>Condition</code> objects</td><td>Uses <code>wait()/notify()</code></td></tr></tbody></table>

