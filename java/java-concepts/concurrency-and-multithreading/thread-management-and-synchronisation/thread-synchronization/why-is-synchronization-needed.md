# Why is Synchronization Needed ?

## About

Synchronization is essential in multithreaded programming to ensure data integrity, consistency, and predictable execution. Without proper synchronization, concurrent access to shared resources can lead to race conditions, inconsistent data, deadlocks, and other critical issues. Below are the key reasons why synchronization is necessary, along with examples.

## 1. **Avoid Race Conditions**

### **What is a Race Condition?**

A race condition occurs when multiple threads try to access and modify the same resource at the same time, leading to unpredictable results. The final outcome depends on the exact timing of thread execution, making the program behavior inconsistent.

### **Example Without Synchronization (Race Condition)**

```java
class Counter {
    private int count = 0;

    void increment() {
        count++;  // Not atomic, can cause issues
    }

    int getCount() {
        return count;
    }
}

public class RaceConditionExample {
    public static void main(String[] args) throws InterruptedException {
        Counter counter = new Counter();

        Thread t1 = new Thread(() -> {
            for (int i = 0; i < 10000; i++) {
                counter.increment();
            }
        });

        Thread t2 = new Thread(() -> {
            for (int i = 0; i < 10000; i++) {
                counter.increment();
            }
        });

        t1.start();
        t2.start();
        t1.join();
        t2.join();

        System.out.println("Final Count: " + counter.getCount());  // Expected: 20000, but might be less!
    }
}
```

#### **Problem**

* Multiple threads update `count` simultaneously.
* Due to context switching, some increments are lost.
* The final count is inconsistent and unpredictable.

### **Fix Using Synchronization**

```java
class Counter {
    private int count = 0;

    synchronized void increment() { // Only one thread can execute at a time
        count++;
    }

    int getCount() {
        return count;
    }
}
```

Now, `increment()` is synchronized, preventing data corruption.

## 2. **Ensure Data Consistency**

### **What is Data Inconsistency?**

When multiple threads modify shared data without proper synchronization, it may lead to an inconsistent state where values become invalid or out of sync.

#### **Example Without Synchronization (Inconsistent Data)**

```java
class SharedData {
    int x = 0, y = 0;

    void updateValues() {
        x = 10;
        y = x * 2; // Expected y = 20
    }

    void printValues() {
        System.out.println("x: " + x + ", y: " + y); // Can print invalid values
    }
}

public class InconsistentDataExample {
    public static void main(String[] args) {
        SharedData data = new SharedData();

        Thread t1 = new Thread(data::updateValues);
        Thread t2 = new Thread(data::printValues);

        t1.start();
        t2.start();
    }
}
```

#### **Problem**

* `printValues()` may execute before `updateValues()` finishes, leading to invalid output like `x: 10, y: 0`.

### **Fix Using Synchronization**

{% hint style="success" %}
The synchronized keyword ensures that only one thread can execute a synchronized method of an object at a time. This means that if one thread is executing a synchronized method, other threads that try to execute any synchronized method of the same object will be blocked until the first thread releases the lock.

In this code, t2 will wait until t1 finishes executing updateValues before it can execute printValues, ensuring data consistency.
{% endhint %}

```java
class SharedData {
    private int x = 0, y = 0;

    synchronized void updateValues() {
        x = 10;
        y = x * 2;
    }

    synchronized void printValues() {
        System.out.println("x: " + x + ", y: " + y);
    }
}
```

Now, `updateValues()` and `printValues()` execute sequentially, ensuring data consistency.

## 3. **Maintain Order of Execution**

### **What is Execution Order Issue?**

In a multithreaded environment, operations may execute out of order, leading to unintended behavior.

### **Example Without Synchronization (Out-of-Order Execution)**

```java
class SharedObject {
    boolean flag = false;

    void setFlag() {
        flag = true;
    }

    void checkFlag() {
        if (flag) {
            System.out.println("Flag is set!");
        } else {
            System.out.println("Flag is not set!"); // May execute before flag is set
        }
    }
}

public class ExecutionOrderExample {
    public static void main(String[] args) {
        SharedObject obj = new SharedObject();

        Thread t1 = new Thread(obj::setFlag);
        Thread t2 = new Thread(obj::checkFlag);

        t2.start(); // Might execute before t1
        t1.start();
    }
}
```

#### **Problem**

* `checkFlag()` may execute before `setFlag()`, printing `"Flag is not set!"`, which is incorrect.

### **Fix Using Synchronization**

```java
class SharedObject {
    private boolean flag = false;

    synchronized void setFlag() {
        flag = true;
    }

    synchronized void checkFlag() {
        if (flag) {
            System.out.println("Flag is set!");
        } else {
            System.out.println("Flag is not set!");
        }
    }
}
```

Now, thread execution order is controlled.

### 4. **Prevent Deadlocks and Starvation**

### **Deadlock**

Occurs when two or more threads wait indefinitely for each other's locks.

### **Example of Deadlock**

{% hint style="info" %}
In this example, the deadlock occurs because each thread is holding a lock that the other thread needs, and neither thread can proceed until the other thread releases its lock
{% endhint %}

```java
class Resource {
    void methodA(Resource r) {
        synchronized (this) {
            System.out.println(Thread.currentThread().getName() + " locked methodA");
            synchronized (r) { // Second lock
                System.out.println(Thread.currentThread().getName() + " locked methodB");
            }
        }
    }
}

public class DeadlockExample {
    public static void main(String[] args) {
        Resource r1 = new Resource();
        Resource r2 = new Resource();

        Thread t1 = new Thread(() -> r1.methodA(r2), "Thread-1");
        Thread t2 = new Thread(() -> r2.methodA(r1), "Thread-2");

        t1.start();
        t2.start();
    }
}
```

#### **Problem**

* **Resource Class**: The Resource class has a method methodA that takes another Resource object as a parameter. Inside methodA, it first acquires a lock on the current Resource object (this) and then tries to acquire a lock on the passed Resource object (r).
* **DeadlockExample Class**: In the main method, two Resource objects (r1 and r2) are created. Two threads (t1 and t2) are started:
  * t1 calls r1.methodA(r2), which means t1 will first lock r1 and then try to lock r2.&#x20;
  * t2 calls r2.methodA(r1), which means t2 will first lock r2 and then try to lock r1.
* **Potential Deadlock:** If t1 locks r1 and t2 locks r2 at the same time, t1 will be waiting for r2 to be unlocked, and t2 will be waiting for r1 to be unlocked. This situation causes a deadlock because both threads are waiting for each other to release the locks, and neither can proceed.

### **Fix: Avoid Nested Locks & Use Try-Lock**

To avoid potential deadlocks, we can use tryLock with a timeout. This way, if a thread cannot acquire the lock within the specified time, it will give up and avoid deadlock.

```java
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import java.util.concurrent.TimeUnit;

public class Resource {
    private final Lock lock = new ReentrantLock();

    void methodA(Resource r) {
        try {
            if (lock.tryLock(1, TimeUnit.SECONDS)) {
                try {
                    System.out.println(Thread.currentThread().getName() + " locked methodA");
                    Thread.sleep(100); // Simulate work
                    if (r.lock.tryLock(1, TimeUnit.SECONDS)) {
                        try {
                            System.out.println(Thread.currentThread().getName() + " locked methodB");
                        } finally {
                            r.lock.unlock();
                        }
                    } else {
                        System.out.println(Thread.currentThread().getName() + " could not lock methodB");
                    }
                } finally {
                    lock.unlock();
                }
            } else {
                System.out.println(Thread.currentThread().getName() + " could not lock methodA");
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
```

Using `tryLock()`, a thread will **not wait indefinitely** for a lock.

* **Lock Initialization**: Each Resource object has its own ReentrantLock instance.&#x20;
* **Method methodA:** The method attempts to acquire a lock on the current Resource object (this) using tryLock with a timeout of 1 second. If the lock is acquired within the timeout, it proceeds to the next steps; otherwise, it prints a message and exits.&#x20;
* **Simulate Work**: Once the lock on the current Resource is acquired, it simulates some work by calling Thread.sleep(100).&#x20;
* **Nested Lock Attempt**: The method then attempts to acquire a lock on the passed Resource object (r) using tryLock with a timeout of 1 second. If the lock is acquired, it prints a message and releases the lock in the finally block. If the lock is not acquired within the timeout, it prints a message indicating the failure to lock the second resource.&#x20;
* **Exception Handling**: The method catches and handles InterruptedException that might be thrown by Thread.sleep.

