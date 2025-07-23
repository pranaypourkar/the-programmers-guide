# Thread Context Switching

## About

Context Switching is the process where the CPU switches from executing one thread (or process) to another. It involves **saving the current state** of the running thread and **loading the state** of the next thread.

In Java, context switching is a fundamental part of multithreading and concurrency, allowing multiple threads to **share CPU time efficiently**. However, excessive switching can introduce overhead, reducing performance.

## **How Context Switching Works ?**

When the CPU switches from one thread to another, it performs these steps:

1. **Save the execution state** of the current thread (Program Counter, Registers, Stack Pointer).
2. **Load the saved state** of the new thread that is to be executed.
3. **Resume execution** of the newly loaded thread from where it left off.

The entire process happens very fast (in milliseconds or microseconds), but it still introduces some overhead.

## **Why Does Context Switching Occur ?**

### **1. Preemptive Multitasking (Time-Slicing)**

* Java follows **preemptive scheduling**, meaning that the JVM scheduler **allocates a fixed time slice** for each thread.
* Once the time slice is over, the CPU switches to another thread, even if the previous one has not finished execution.

### **2. Thread Priority-Based Switching**

* The **JVM scheduler prioritizes high-priority threads**, causing context switching when a higher-priority thread becomes available.
* However, **thread priorities are not guaranteed** and depend on the OS-level thread scheduling policy.

### **3. Blocking Operations**

* If a thread **performs an I/O operation (file read, network call, database access, etc.)**, the OS may **pause it** and switch to another thread while waiting for the operation to complete.

### **4. Synchronization & Locks**

* When a thread **waits for a lock**, it is put in a **waiting state**, and the CPU switches to another thread that is ready to execute.

### **5. Manual Thread Sleep or Yield**

* Calling `Thread.sleep(time)` or `Thread.yield()` **forces the CPU to switch** to another thread voluntarily.

## **Example of Context Switching**

{% hint style="info" %}
* The output **does not follow a strict order** because of **context switching**.
* Each thread **runs independently**, and the JVM scheduler **decides when to switch threads**.
{% endhint %}

```java
class Task extends Thread {
    public void run() {
        for (int i = 1; i <= 5; i++) {
            System.out.println(Thread.currentThread().getName() + " is executing: " + i);
            try {
                Thread.sleep(100); // Simulate some work
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}

public class ContextSwitchingExample {
    public static void main(String[] args) {
        Thread t1 = new Task();
        Thread t2 = new Task();
        Thread t3 = new Task();

        t1.start();
        t2.start();
        t3.start();
        
        /* Output may vary
        Thread-0 is executing: 1
        Thread-1 is executing: 1
        Thread-2 is executing: 1
        Thread-0 is executing: 2
        Thread-1 is executing: 2
        Thread-2 is executing: 2
        ...
        */
    }
}
```

## **Types of Context Switching**

### **1. Process Context Switching**

* Happens when the OS switches between processes.
* **More expensive** due to separate memory space management.

### **2. Thread Context Switching**

* Happens when switching between threads of the **same process**.
* **Less expensive** than process switching, as threads share memory.

## **Performance Overhead of Context Switching**

Context switching is necessary for multitasking but introduces **performance costs**:

1. **CPU Overhead** – Saving and restoring registers, stack, and program counters.
2. **Cache Invalidation** – CPU cache may need to be reloaded when switching between threads.
3. **Locking Issues** – If multiple threads compete for locks, frequent switching may lead to **higher contention**.

## **Ways to Reduce Context Switching in Java**

### **1. Use Fewer Threads if Possible**

* Too many threads increase **CPU switching overhead**.
* Use **Thread Pools (`ExecutorService`)** to manage thread allocation efficiently.

```java
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class ThreadPoolExample {
    public static void main(String[] args) {
        ExecutorService executor = Executors.newFixedThreadPool(3); // Fixed thread pool of 3
        for (int i = 0; i < 5; i++) {
            executor.execute(new Task());
        }
        executor.shutdown();
    }
}
```

### **2. Use `Lock-Free` Data Structures**

* Avoid synchronized blocks when possible, as they increase thread waiting and switching.
* Use **concurrent collections** like `ConcurrentHashMap` instead of `synchronized Map`.

```java
import java.util.concurrent.ConcurrentHashMap;

public class ConcurrentExample {
    public static void main(String[] args) {
        ConcurrentHashMap<Integer, String> map = new ConcurrentHashMap<>();
        map.put(1, "Thread Safe");
    }
}
```

### **3. Use `Thread.yield()` Wisely**

* `Thread.yield()` allows the JVM to switch to another thread **but does not guarantee switching**.

```java
class YieldExample extends Thread {
    public void run() {
        for (int i = 1; i <= 3; i++) {
            System.out.println(Thread.currentThread().getName() + " running");
            Thread.yield();
        }
    }
}

public class YieldDemo {
    public static void main(String[] args) {
        YieldExample t1 = new YieldExample();
        YieldExample t2 = new YieldExample();

        t1.start();
        t2.start();
    }
}
```

### **4. Prefer `ReentrantLock` Over `synchronized`**

* `ReentrantLock` provides better control over locking mechanisms and can **reduce unnecessary context switching**.

```java
import java.util.concurrent.locks.ReentrantLock;

class ReentrantExample {
    private final ReentrantLock lock = new ReentrantLock();

    public void doWork() {
        lock.lock();
        try {
            System.out.println(Thread.currentThread().getName() + " acquired lock.");
        } finally {
            lock.unlock();
        }
    }
}

public class ReentrantLockDemo {
    public static void main(String[] args) {
        ReentrantExample example = new ReentrantExample();
        Thread t1 = new Thread(example::doWork);
        Thread t2 = new Thread(example::doWork);
        t1.start();
        t2.start();
    }
}
```
