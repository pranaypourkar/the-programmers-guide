# Why is Synchronization Needed?

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
