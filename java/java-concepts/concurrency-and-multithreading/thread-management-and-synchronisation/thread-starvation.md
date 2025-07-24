# Thread Starvation

## About

Starvation is a condition in multithreaded programming where a thread is perpetually denied access to necessary resources because other higher-priority threads are constantly acquiring them. This can lead to situations where a thread **never gets a chance to execute**, despite being in a runnable state.

## **Causes of Starvation**

1. **Thread Priority Inversion**: If a high-priority thread keeps executing and the lower-priority thread never gets CPU time, the lower-priority thread starves.
2. **Unfair Lock Mechanisms**: When locks are not fairly assigned, certain threads may always acquire the lock before others.
3. **Resource Hoarding**: If a thread holds onto shared resources for an extended period, other threads may never get access.
4. **Frequent Context Switching**: If higher-priority threads frequently preempt a lower-priority thread, the lower-priority thread may not get enough execution time.

## **Example of Starvation**&#x20;

### **1. Due to High-Priority Threads**

If high-priority threads keep running, a low-priority thread might not execute at all.

{% hint style="info" %}
In this code:

* The main thread creates and starts five high-priority threads in a loop.&#x20;
* After the loop, the main thread creates and starts one low-priority thread.&#x20;
* The main thread will complete the loop and start the low-priority thread after starting all high-priority threads. However, the execution order of the threads is managed by the thread scheduler, which may prioritize the high-priority threads over the low-priority thread, potentially leading to thread starvation for the low-priority thread
{% endhint %}

```java
public class ThreadStarvationExample {
    public static void main(String[] args) {
        Runnable task = () -> {
            Thread currentThread = Thread.currentThread();
            System.out.println(currentThread.getName() + " is executing with priority " + currentThread.getPriority());
        };

        // Creating high-priority threads
        for (int i = 0; i < 5; i++) {
            Thread highPriorityThread = new Thread(task);
            highPriorityThread.setPriority(Thread.MAX_PRIORITY);
            highPriorityThread.start();
        }

        // Creating low-priority thread
        Thread lowPriorityThread = new Thread(task);
        lowPriorityThread.setPriority(Thread.MIN_PRIORITY);
        lowPriorityThread.start();
    }
}

/* Sample Possible Output
Thread-2 is executing with priority 10
Thread-0 is executing with priority 10
Thread-3 is executing with priority 10
Thread-5 is executing with priority 1
Thread-1 is executing with priority 10
Thread-4 is executing with priority 10
*/
```

#### **Problem in the Above Code**

* The low-priority thread may **never execute** if the high-priority threads keep running.
* The CPU scheduler keeps selecting high-priority threads, ignoring lower-priority threads.

### **2. Due to Synchronized Blocks**

If a thread monopolizes a synchronized block, other threads might starve.

#### **Example Without Fair Synchronization**

```java
class SharedResource {
    synchronized void access() {
        System.out.println(Thread.currentThread().getName() + " is executing.");
        try {
            Thread.sleep(2000); // Simulate long-running task
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}

public class StarvationSyncExample {
    public static void main(String[] args) {
        SharedResource resource = new SharedResource();

        // High-priority thread keeps acquiring lock
        for (int i = 0; i < 5; i++) {
            new Thread(resource::access, "HighPriorityThread-" + i).start();
        }

        // Low-priority thread may never get lock
        new Thread(resource::access, "LowPriorityThread").start();
    }
}
```

#### **Problem**

* The low-priority thread might **never acquire the lock** as high-priority threads keep executing.

## **Preventing Starvation**

### **1. Using Fair Locks (ReentrantLock)**

We can use a ReentrantLock with the fairness policy enabled. This ensures that threads acquire the lock in the order they requested it, thus preventing starvation.

```java
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class ThreadStarvationExample {
    private static final Lock lock = new ReentrantLock(true); // Fair lock

    public static void main(String[] args) {
        Runnable task = () -> {
            try {
                lock.lock();
                Thread currentThread = Thread.currentThread();
                System.out.println(currentThread.getName() + " is executing with priority " + currentThread.getPriority());
            } finally {
                lock.unlock();
            }
        };

        // Creating high-priority threads
        for (int i = 0; i < 5; i++) {
            Thread highPriorityThread = new Thread(task);
            highPriorityThread.setPriority(Thread.MAX_PRIORITY);
            highPriorityThread.start();
        }

        // Creating low-priority thread
        Thread lowPriorityThread = new Thread(task);
        lowPriorityThread.setPriority(Thread.MIN_PRIORITY);
        lowPriorityThread.start();
    }
}
```

#### **Solution**

* A **fair lock** ensures that threads are scheduled in FIFO order.
* No thread is left waiting indefinitely.
* The use of a fair ReentrantLock ensures that all threads, regardless of their priority, will eventually get a chance to execute, thus preventing any thread from being left waiting indefinitely.
* Thread priority is a hint to the thread scheduler, and it might not always be respected. The actual execution order of threads depends on the thread scheduler of the JVM and the underlying operating system. Using a fair ReentrantLock can help ensure that no thread is left waiting indefinitely, regardless of their priority.

### **2. Using `Thread.yield()`**

Calling `Thread.yield()` allows lower-priority threads to execute.

```java
class YieldExample {
    public static void main(String[] args) {
        Thread t1 = new Thread(() -> {
            for (int i = 0; i < 5; i++) {
                System.out.println(Thread.currentThread().getName() + " yielding.");
                Thread.yield(); // Hints scheduler to give CPU to another thread
            }
        });

        Thread t2 = new Thread(() -> {
            for (int i = 0; i < 5; i++) {
                System.out.println(Thread.currentThread().getName() + " executing.");
            }
        });

        t1.start();
        t2.start();
    }
}
```

#### **Solution**

* Calling `Thread.yield()` hints the scheduler to give CPU time to other waiting threads.

### **3. Using `wait()` and `notify()` for Cooperative Scheduling**

Instead of always grabbing CPU, threads can **release control** using `wait()`.

```java
class Shared {
    synchronized void doWork() {
        try {
            System.out.println(Thread.currentThread().getName() + " waiting.");
            wait();
            System.out.println(Thread.currentThread().getName() + " resumed.");
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    synchronized void release() {
        notify(); // Wakes up a waiting thread
    }
}

public class WaitNotifyExample {
    public static void main(String[] args) throws InterruptedException {
        Shared shared = new Shared();

        Thread t1 = new Thread(shared::doWork, "Thread-1");
        t1.start();

        Thread.sleep(2000);
        shared.release();
    }
}
```

#### **Solution**

* The **lower-priority thread voluntarily waits** instead of continuously trying to execute.
* `notify()` ensures that it gets a chance to run.

## **Starvation vs Deadlock**

<table><thead><tr><th width="138">Feature</th><th>Starvation</th><th>Deadlock</th></tr></thead><tbody><tr><td>Cause</td><td>High-priority threads blocking low-priority ones</td><td>Multiple threads waiting for each other indefinitely</td></tr><tr><td>Resolution</td><td>Use fair scheduling, locks, or <code>yield()</code></td><td>Avoid nested locks, use <code>tryLock()</code>, timeout mechanisms</td></tr><tr><td>Impact</td><td>Some threads may never execute</td><td>All threads involved are blocked</td></tr></tbody></table>
