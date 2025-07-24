# Thread Deadlock

## About

Deadlock is a situation in multithreaded programming where **two or more threads are waiting for each other's resources indefinitely**, preventing any of them from proceeding. This results in a complete **halt of execution** for those threads.

## **Causes of Deadlock**

{% hint style="info" %}
These four conditions are known as the **Coffman Conditions**, and **all must be true simultaneously** for a deadlock to occur.
{% endhint %}

### **1. Circular Waiting**

A set of threads are waiting on resources in a circular chain, where each thread holds a resource and waits for another that is held by the next thread in the chain.

**Example:**

* **Thread-1** holds `Resource-A` and waits for `Resource-B`.
* **Thread-2** holds `Resource-B` and waits for `Resource-C`.
* **Thread-3** holds `Resource-C` and waits for `Resource-A`.

**Illustration of Circular Waiting:**

```
Thread-1 → needs Resource-B → held by Thread-2
Thread-2 → needs Resource-C → held by Thread-3
Thread-3 → needs Resource-A → held by Thread-1
```

* No thread can proceed, resulting in **deadlock**.

**Solution:**

* Break the circular chain by acquiring locks in a specific order.
* Example: Always acquire `Resource-A` before `Resource-B`.

### **2. Hold and Wait**

A thread holds a resource and **waits indefinitely** for another resource, which may be held by another thread.

**Example:**

* **Thread-1** locks `Resource-A` and needs `Resource-B`.
* **Thread-2** locks `Resource-B` and needs `Resource-A`.
* Neither thread can proceed, leading to **deadlock**.

```java
class Resource {
    void action(String msg) {
        System.out.println(Thread.currentThread().getName() + ": " + msg);
    }
}

public class HoldAndWaitExample {
    public static void main(String[] args) {
        final Resource lockA = new Resource();
        final Resource lockB = new Resource();

        Thread t1 = new Thread(() -> {
            synchronized (lockA) {
                lockA.action("Locked Resource A, waiting for B...");
                try { Thread.sleep(100); } catch (InterruptedException e) {}
                synchronized (lockB) {
                    lockB.action("Acquired both A and B");
                }
            }
        }, "Thread-1");

        Thread t2 = new Thread(() -> {
            synchronized (lockB) {
                lockB.action("Locked Resource B, waiting for A...");
                try { Thread.sleep(100); } catch (InterruptedException e) {}
                synchronized (lockA) {
                    lockA.action("Acquired both B and A");
                }
            }
        }, "Thread-2");

        t1.start();
        t2.start();
    }
}
```

**Solution:**

* Avoid holding resources while waiting.
* Use **tryLock()** instead of synchronization.

```java
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class TryLockExample {
    private final Lock lockA = new ReentrantLock();
    private final Lock lockB = new ReentrantLock();

    void safeMethod() {
        while (true) {
            boolean gotA = lockA.tryLock();
            boolean gotB = lockB.tryLock();

            if (gotA && gotB) {
                try {
                    System.out.println(Thread.currentThread().getName() + " acquired both locks.");
                    break; // Successfully acquired both locks, exit loop
                } finally {
                    lockA.unlock();
                    lockB.unlock();
                }
            }

            if (gotA) lockA.unlock();
            if (gotB) lockB.unlock();

            try {
                Thread.sleep(100); // Prevents tight loop
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    public static void main(String[] args) {
        TryLockExample resource = new TryLockExample();
        
        Thread t1 = new Thread(resource::safeMethod, "Thread-1");
        Thread t2 = new Thread(resource::safeMethod, "Thread-2");

        t1.start();
        t2.start();
    }
}
```

* If **both locks cannot be acquired**, the thread **releases any held lock** and **tries again**, preventing deadlock.

### **3. No Preemption**

A resource **cannot be forcefully taken** from a thread. A thread must release it voluntarily.

**Example:**

* **Thread-1** holds `Resource-A` and needs `Resource-B`.
* **Thread-2** holds `Resource-B` and needs `Resource-A`.
* Neither can release resources, leading to **deadlock**.

**Solution:**

* **Use a timeout mechanism** (`tryLock()` with timeout).
* If a thread cannot get the required resource within a certain time, it **releases** the held resources and retries.

```java
import java.util.concurrent.TimeUnit;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class TimeoutLockExample {
    private final Lock lock = new ReentrantLock();

    void safeMethod() {
        try {
            if (lock.tryLock(2, TimeUnit.SECONDS)) { // Wait max 2 seconds
                try {
                    System.out.println(Thread.currentThread().getName() + " acquired the lock.");
                    Thread.sleep(1000);
                } finally {
                    lock.unlock();
                }
            } else {
                System.out.println(Thread.currentThread().getName() + " could not acquire the lock, moving on.");
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        TimeoutLockExample resource = new TimeoutLockExample();
        new Thread(resource::safeMethod, "Thread-1").start();
        new Thread(resource::safeMethod, "Thread-2").start();
    }
}
```

* If a thread cannot acquire a lock within 2 seconds, it moves on instead of waiting indefinitely.

### **4. Mutual Exclusion**

A resource **can only be used by one thread at a time**. If another thread needs it, it **must wait**.

**Example:**

```java
class SharedResource {
    synchronized void accessResource() {
        System.out.println(Thread.currentThread().getName() + " is accessing the resource.");
        try { Thread.sleep(2000); } catch (InterruptedException e) {}
        System.out.println(Thread.currentThread().getName() + " finished.");
    }
}

public class MutualExclusionExample {
    public static void main(String[] args) {
        SharedResource resource = new SharedResource();
        
        Thread t1 = new Thread(resource::accessResource, "Thread-1");
        Thread t2 = new Thread(resource::accessResource, "Thread-2");
        
        t1.start();
        t2.start();
    }
}
```

* **Only one thread can access the method at a time**, causing potential **delays and deadlock risk**.

**Solution:**

* Minimize **resource locking**.
* Use **lock-free data structures** (e.g., `ConcurrentHashMap`).
* Implement **fine-grained locking** (lock only the required part of data).

### **Comparison of the Four Deadlock Conditions**

<table data-full-width="true"><thead><tr><th width="186">Condition</th><th>Definition</th><th width="232">Example</th><th>Solution</th></tr></thead><tbody><tr><td>Circular Waiting</td><td>Threads wait in a cycle</td><td>A → B → C → A</td><td>Acquire locks in a fixed order</td></tr><tr><td>Hold and Wait</td><td>Holding resources while waiting for more</td><td>T1 locks A, waits for B</td><td>Use <code>tryLock()</code>, acquire all locks at once</td></tr><tr><td>No Preemption</td><td>Resources can't be forcefully taken</td><td>A locked by T1, B by T2</td><td>Use timeouts (<code>tryLock(2, TimeUnit.SECONDS)</code>)</td></tr><tr><td>Mutual Exclusion</td><td>Only one thread can use a resource at a time</td><td><code>synchronized</code>methods</td><td>Use lock-free data structures (<code>ConcurrentHashMap</code>)</td></tr></tbody></table>







