# Best Practices for Avoiding Thread Issues

## About

Multi-threading is essential for building high-performance applications, but incorrect thread management can lead to **deadlocks, race conditions, starvation, and performance bottlenecks**. Below are the best practices for writing safe and efficient multi-threaded Java applications.

## **1. Use High-Level Concurrency Utilities**

Java provides built-in concurrency utilities in the `java.util.concurrent` package, which are safer and more efficient than manually handling threads.

### **Why?**

* Avoids direct thread manipulation
* Prevents low-level synchronization issues
* Provides thread-safe collections

### **How?**

Use **Executors** instead of manually creating threads.

{% hint style="warning" %}
**Avoid** using `new Thread().start()` directly.
{% endhint %}

```java
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class ExecutorExample {
    public static void main(String[] args) {
        ExecutorService executor = Executors.newFixedThreadPool(3);

        Runnable task = () -> System.out.println(Thread.currentThread().getName() + " executing task");

        for (int i = 0; i < 5; i++) {
            executor.execute(task);
        }

        executor.shutdown();
    }
}
```

## **2. Use Synchronization Properly**

### **Why?**

Improper synchronization can lead to race conditions, data inconsistency, and deadlocks.

### **How?**

Use **synchronized** blocks instead of methods when possible.

{% hint style="warning" %}
**Avoid** synchronizing entire methods unnecessarily—it reduces performance.
{% endhint %}

```java
class SharedResource {
    private int count = 0;

    void increment() {
        synchronized (this) { // Lock only this part
            count++;
        }
    }
}
```

Use **ReentrantLock** for finer control over synchronization.

{% hint style="warning" %}
**Avoid** using `synchronized` when `ReentrantLock` provides better flexibility (e.g., tryLock, fairness).
{% endhint %}

```java
import java.util.concurrent.locks.ReentrantLock;

class Counter {
    private int count = 0;
    private final ReentrantLock lock = new ReentrantLock();

    void increment() {
        lock.lock();
        try {
            count++;
        } finally {
            lock.unlock();
        }
    }
}
```

## **3. Prevent Deadlocks**

### **Why?**

Deadlocks occur when multiple threads wait indefinitely for resources held by each other.

### **How?**

Always acquire locks in a fixed order.

{% hint style="warning" %}
**Avoid** acquiring locks in **inconsistent order** across multiple threads.
{% endhint %}

```java
class SafeLock {
    private final Object lock1 = new Object();
    private final Object lock2 = new Object();

    void method1() {
        synchronized (lock1) {
            synchronized (lock2) {
                System.out.println("Method1 executed");
            }
        }
    }

    void method2() {
        synchronized (lock1) { // Lock order is consistent
            synchronized (lock2) {
                System.out.println("Method2 executed");
            }
        }
    }
}
```

**Use tryLock() with timeouts**

{% hint style="warning" %}
**Avoid** using nested locks without ordering or timeouts.
{% endhint %}

```java
import java.util.concurrent.locks.ReentrantLock;
import java.util.concurrent.TimeUnit;

class TryLockExample {
    private final ReentrantLock lockA = new ReentrantLock();
    private final ReentrantLock lockB = new ReentrantLock();

    void safeMethod() {
        try {
            if (lockA.tryLock(1, TimeUnit.SECONDS) && lockB.tryLock(1, TimeUnit.SECONDS)) {
                try {
                    System.out.println(Thread.currentThread().getName() + " acquired both locks.");
                } finally {
                    lockA.unlock();
                    lockB.unlock();
                }
            } else {
                System.out.println(Thread.currentThread().getName() + " could not acquire locks.");
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
```

## **4. Minimize Shared State & Use Thread-Safe Collections**

### **Why?**

* Reducing shared state minimizes synchronization overhead.
* Using thread-safe collections prevents **race conditions** and **concurrent modification exceptions**.

### **How?**

Use **immutable objects**

```java
record ImmutableData(int value) {} // Java 14+
```

Use **thread-safe collections**

{% hint style="warning" %}
**Avoid** using `ArrayList` or `HashMap` in multi-threaded environments without synchronization.
{% endhint %}

```java
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;

ConcurrentHashMap<Integer, String> map = new ConcurrentHashMap<>();
CopyOnWriteArrayList<String> list = new CopyOnWriteArrayList<>();
```

## &#x20;**5. Use Atomic Variables for Simple Operations**

### **Why?**

Atomic variables are **lock-free** and avoid synchronization overhead for basic operations.

### **How?**

Use **AtomicInteger** instead of `synchronized int`

{% hint style="warning" %}
**Avoid** using `synchronized` for simple **increment/decrement operations**.
{% endhint %}

```java
import java.util.concurrent.atomic.AtomicInteger;

class Counter {
    private final AtomicInteger count = new AtomicInteger(0);

    void increment() {
        count.incrementAndGet();
    }
}
```

## **6. Avoid Thread Starvation & Resource Hogging**

#### **Why?**

If some threads **never get CPU time** due to priority imbalance, it leads to **starvation**.

#### **How?**

Use **fair locks**

```java
ReentrantLock fairLock = new ReentrantLock(true); // Enable fairness
```

**Balance thread priorities**

{% hint style="warning" %}
**Avoid** setting **all threads to high priority**.
{% endhint %}

```java
thread1.setPriority(Thread.MIN_PRIORITY);
thread2.setPriority(Thread.MAX_PRIORITY);
```

## **7. Properly Handle Thread Interruption**

### **Why?**

If a thread is interrupted, it should **gracefully exit** instead of ignoring the signal.

### **How?**

Check and respond to interruptions.

{% hint style="warning" %}
**Avoid** catching `InterruptedException` without handling it.
{% endhint %}

```java
class Task implements Runnable {
    public void run() {
        while (!Thread.currentThread().isInterrupted()) {
            System.out.println("Thread running...");
        }
        System.out.println("Thread exiting...");
    }
}
```

## **8. Use Thread Pooling Instead of Creating Too Many Threads**

### **Why?**

* Creating new threads repeatedly wastes resources.
* Thread pooling reuses threads, reducing overhead.

### **How?**

Use **CachedThreadPool** for short-lived tasks

```java
ExecutorService executor = Executors.newCachedThreadPool();
```

Use **FixedThreadPool** for controlled concurrency

```java
ExecutorService executor = Executors.newFixedThreadPool(5);
```

## **9. Use Volatile for Visibility, But Not for Atomicity**

### **Why?**

* `volatile` ensures that all threads **see the latest value** of a variable.
* However, it **does not guarantee atomicity** for compound actions.

### **How?**

Use `volatile` for **visibility**

{% hint style="warning" %}
**Avoid** using `volatile` for **compound operations**
{% endhint %}

```java
volatile boolean flag = true;
```

```java
volatile int counter = 0; // Not atomic
```

Instead, use **Atomic variables**

```java
AtomicInteger counter = new AtomicInteger(0);
```
