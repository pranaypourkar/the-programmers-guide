# Thread Contention

## About

Thread contention occurs when **multiple threads compete for the same shared resource**, leading to **delays, reduced performance, and potential deadlocks**. When multiple threads try to access a synchronized block, lock, or shared resource at the same time, only one can proceed while others **wait, block, or get suspended**.

High contention degrades performance as threads spend more time **waiting** rather than executing useful work.

{% hint style="success" %}
Contention means **competition for a shared resource**.

Imagine a **single restroom in an office**:

* If only one person (thread) needs it, there’s no issue.
* If multiple people (threads) want to use it at the same time, they must **wait** for their turn. This waiting and competition for access is called **contention**
{% endhint %}

## **Why Does Thread Contention Happen?**

1. **Too Many Threads Competing for a Resource:** Example: Multiple threads trying to write to the same file, database, or shared data structure.
2. **Use of Synchronized Methods or Blocks:** If many threads try to execute a `synchronized` method or block, only one can proceed while others wait.
3. **Lock-Based Synchronization (Intrinsic Locks, ReentrantLocks, etc.):** Locks ensure **mutual exclusion**, but they can also create bottlenecks if too many threads are trying to acquire them.
4. **Resource Limitations:** Limited **CPU cores**, **database connections**, or **network bandwidth** can cause contention when multiple threads demand the same resource.
5. **Long-Held Locks:** A thread that holds a lock for too long **prevents others from progressing**, increasing contention.
6. **Inefficient Thread Scheduling:** If the JVM or OS **does not allocate CPU time properly**, threads may stay in waiting states longer than necessary.

## **Effects of Thread Contention**

1. **Increased Waiting Time:** Threads spend **more time in the blocked state** instead of executing tasks.
2. **Performance Degradation:** High contention increases **context switching** and reduces **CPU efficiency**.
3. **Deadlocks:** If multiple threads wait indefinitely for resources held by each other, the system can enter a **deadlock** state.
4. **Starvation:** Lower-priority threads may never get a chance to execute if high-priority threads hold locks continuously.
5. **Scalability Issues:** When multiple threads compete for a resource, adding more threads may **not improve performance** and could make it worse.

### **Example of Thread Contention in Java**

#### **Scenario: Multiple Threads Contending for a Synchronized Resource**

{% hint style="info" %}
* **Only one thread accesses the synchronized method at a time.**
* **Other threads are blocked, leading to contention.**
* **Total execution time is much higher due to waiting.**
{% endhint %}

```java
class SharedResource {
    synchronized void accessResource() {
        System.out.println(Thread.currentThread().getName() + " accessing resource...");
        try {
            Thread.sleep(2000); // Simulate a long operation
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println(Thread.currentThread().getName() + " finished.");
    }
}

public class ContentionExample {
    public static void main(String[] args) {
        SharedResource resource = new SharedResource();

        Runnable task = () -> resource.accessResource();

        Thread t1 = new Thread(task);
        Thread t2 = new Thread(task);
        Thread t3 = new Thread(task);

        t1.start();
        t2.start();
        t3.start();
        
        /*
        Thread-0 accessing resource...
        (Thread-1 and Thread-2 are waiting)
        Thread-0 finished.
        Thread-1 accessing resource...
        (Thread-2 is still waiting)
        Thread-1 finished.
        Thread-2 accessing resource...
        Thread-2 finished.
        */
    }
}
```

## **How to Reduce Thread Contention in Java**

### **1. Minimize Synchronized Blocks**

* Instead of synchronizing an entire method, synchronize only the **critical section** to reduce contention.

```java
class SharedResourceOptimized {
    void accessResource() {
        System.out.println(Thread.currentThread().getName() + " doing non-critical work...");
        
        synchronized (this) {
            System.out.println(Thread.currentThread().getName() + " accessing critical section...");
            try {
                Thread.sleep(2000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }

        System.out.println(Thread.currentThread().getName() + " finished.");
    }
}
```

**Why is this better?**

* Only the **critical section** is synchronized.
* Threads can still execute **non-critical work** in parallel.

### **2. Use ReentrantLock Instead of Synchronized**

* `ReentrantLock` gives **more control** and **better performance** by allowing fair locking, try-lock mechanisms, and interruptible locking.

```java
import java.util.concurrent.locks.ReentrantLock;

class SharedResourceWithLock {
    private final ReentrantLock lock = new ReentrantLock();

    void accessResource() {
        if (lock.tryLock()) { // Non-blocking attempt to acquire lock
            try {
                System.out.println(Thread.currentThread().getName() + " acquired lock.");
                Thread.sleep(2000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            } finally {
                lock.unlock();
                System.out.println(Thread.currentThread().getName() + " released lock.");
            }
        } else {
            System.out.println(Thread.currentThread().getName() + " could not acquire lock.");
        }
    }
}
```

**Benefits**

* **Avoids unnecessary waiting** if the lock is unavailable.
* **More flexible than `synchronized`**, allowing timeouts and interruptible locks.

### **3. Use Read-Write Locks for Shared Data**

* If multiple threads **only read** data, they should not block each other.
* `ReentrantReadWriteLock` allows **multiple readers but only one writer** at a time.

```java
import java.util.concurrent.locks.ReentrantReadWriteLock;

class SharedData {
    private final ReentrantReadWriteLock lock = new ReentrantReadWriteLock();
    private int value = 0;

    void readData() {
        lock.readLock().lock();
        try {
            System.out.println(Thread.currentThread().getName() + " reading value: " + value);
        } finally {
            lock.readLock().unlock();
        }
    }

    void writeData(int newValue) {
        lock.writeLock().lock();
        try {
            System.out.println(Thread.currentThread().getName() + " writing value: " + newValue);
            value = newValue;
        } finally {
            lock.writeLock().unlock();
        }
    }
}
```

**Benefits**

* **Multiple threads can read simultaneously** (reduces contention).
* **Write operations still ensure exclusive access**.

### **4. Use Concurrent Collections**

* Instead of `synchronized List`, use `CopyOnWriteArrayList`, `ConcurrentHashMap`, or `ConcurrentLinkedQueue`.
* They are **designed to reduce contention** while maintaining thread safety.

```java
import java.util.concurrent.ConcurrentHashMap;

public class ConcurrentMapExample {
    public static void main(String[] args) {
        ConcurrentHashMap<Integer, String> map = new ConcurrentHashMap<>();
        map.put(1, "Java");
        map.put(2, "Multithreading");
    }
}
```

**Why is this better?**

* No explicit locking required.
* **Better performance in multi-threaded environments**.

### **5. Reduce Number of Threads (Thread Pooling)**

* Too many threads can cause **high contention**.
* Using **thread pools** (`ExecutorService`) ensures optimal thread usage.

```java
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class ThreadPoolExample {
    public static void main(String[] args) {
        ExecutorService executor = Executors.newFixedThreadPool(3);
        for (int i = 0; i < 5; i++) {
            executor.execute(() -> System.out.println(Thread.currentThread().getName() + " executing task."));
        }
        executor.shutdown();
    }
}
```

**Benefits**

* Limits the number of active threads, **reducing contention**.
* JVM can **manage threads efficiently**.
