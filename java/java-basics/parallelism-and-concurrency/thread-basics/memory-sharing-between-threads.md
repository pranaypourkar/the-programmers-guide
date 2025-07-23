# Memory Sharing Between Threads

## About

In Java (and most modern programming languages), when we create multiple threads within the same process, they share a common memory space. This shared memory model allows threads to **communicate and coordinate** their actions by reading from and writing to shared variables or objects.

While this is powerful and efficient, it introduces complexity in terms of **thread safety**, **data consistency**, and **visibility of changes**. Understanding how memory is shared and managed across threads is essential for writing correct and performant multithreaded applications.

## **Why Threads Share Memory**

All threads in a Java application run in the same **process**. A process is the operating system abstraction that provides memory, file handles, and other resources.

Since Java threads are lightweight and managed by the **Java Virtual Machine (JVM)**, they:

* Run within the same memory space (same heap).
* Can reference the same objects.
* Use their own execution stacks (method calls, local variables, etc.)

This design enables **efficient communication** between threads, unlike in multi-process architectures where communication requires IPC (Inter-Process Communication) mechanisms like sockets or pipes.

## **What’s Shared and What’s Not**

<table data-full-width="true"><thead><tr><th width="211.74993896484375">Category</th><th width="183.2742919921875">Shared Between Threads?</th><th>Description</th></tr></thead><tbody><tr><td>Heap Memory</td><td>Yes</td><td>Includes all objects and class variables. Threads can read/write shared objects.</td></tr><tr><td>Stack Memory</td><td>No</td><td>Each thread has its own stack for local method variables. Not visible to other threads.</td></tr><tr><td>Static Variables</td><td>Yes</td><td>Belong to the class, not the instance, hence shared among all threads.</td></tr><tr><td>Instance Variables</td><td>Conditional</td><td>Shared <strong>only if</strong> multiple threads share a reference to the same object.</td></tr><tr><td>ThreadLocal Values</td><td>No</td><td>Each thread has its own isolated copy via <code>ThreadLocal</code>.</td></tr><tr><td>CPU Registers &#x26; Caches</td><td>No (by default)</td><td>Each CPU core/thread may cache values and not reflect them in main memory unless synchronized.</td></tr></tbody></table>

## **Dangers of Shared Memory**

### 1. **Race Condition**

A **race condition** occurs when two or more threads access shared data and try to change it at the same time. The final outcome depends on the unpredictable timing of thread execution.

* Threads “race” against each other to access or modify the same variable.
* The program may produce different results on different runs even with the same input.
* Happens due to lack of synchronization.

**Example Scenario:**

Two threads incrementing a shared counter simultaneously without locking it. One increment might get lost.

```java
public class RaceConditionExample {
    private static int counter = 0;

    public static void main(String[] args) {
        Runnable task = () -> {
            for (int i = 0; i < 1000; i++) {
                counter++; // Not atomic, causes race condition
            }
        };

        Thread t1 = new Thread(task);
        Thread t2 = new Thread(task);
        t1.start();
        t2.start();

        try {
            t1.join(); 
            t2.join();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        System.out.println("Final counter value: " + counter); // Might not be 2000
    }
}
```

### 2. **Lost Update**

This is a specific type of race condition where an update to a shared variable by one thread is overwritten or ignored because another thread wrote to it just before or after.

* Multiple threads read the same value, update it, and write it back.
* Since both used the same original value, one update "loses" the effect of the other.
* The final result reflects only one update.

**Example Scenario:**

Both threads read a counter as 5, increment it to 6, and save it. Final value remains 6 instead of 7.

```java
public class LostUpdateExample {
    private static int balance = 100;

    public static void main(String[] args) {
        Runnable withdraw = () -> {
            int temp = balance; // Thread reads balance
            temp = temp - 50;   // Deducts 50
            balance = temp;     // Writes back new balance
        };

        Thread t1 = new Thread(withdraw);
        Thread t2 = new Thread(withdraw);
        t1.start();
        t2.start();

        try {
            t1.join(); 
            t2.join();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        System.out.println("Final balance: " + balance); // May be 50 instead of 0
    }
}
```

### 3. **Visibility Problem**

Even if operations happen in order, one thread might not **see the updated value** of a shared variable written by another thread due to CPU caching or compiler optimization.

* Java threads may cache variables locally.
* Changes in one thread might not be visible to others unless synchronization or `volatile` is used.
* The result: a thread acts on stale data.

**Example Scenario:**

Thread A updates a `flag` to `true`, but Thread B keeps seeing it as `false` because it's using a cached copy.

```java
public class VisibilityProblemExample {
    private static boolean flag = false;

    public static void main(String[] args) {
        Thread writer = new Thread(() -> {
            try { Thread.sleep(100); } catch (InterruptedException ignored) {}
            flag = true; // Update might not be visible to other thread
        });

        Thread reader = new Thread(() -> {
            while (!flag) {
                // May loop forever if flag is not visible
            }
            System.out.println("Flag is true");
        });

        writer.start();
        reader.start();
    }
}
```

### 4. **Atomicity Violation**

Even reading and writing a primitive (like `int`) isn't always safe if combined operations are involved.

Occurs when compound operations (like read-modify-write) are not performed atomically, i.e., they are interrupted between steps by other threads.

* Even if visibility is fine, operations like `x++` are not atomic.
* They break down into read → compute → write.
* Without synchronization, another thread might interleave between steps.

**Example Scenario:**

Multiple threads increment a value concurrently without locking. Final value is lower than expected due to lost increments.

```java
public class AtomicityViolationExample {
    private static int shared = 0;

    public static void main(String[] args) {
        Runnable increment = () -> {
            for (int i = 0; i < 1000; i++) {
                shared = shared + 1; // Not atomic: read, modify, write
            }
        };

        Thread t1 = new Thread(increment);
        Thread t2 = new Thread(increment);
        t1.start(); t2.start();

        try {
            t1.join(); t2.join();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        System.out.println("Shared value: " + shared); // May not be 2000
    }
}
```

### 5. **Data Corruption**

Multiple threads mutate a data structure without proper synchronization, causing inconsistent state.

This is the most severe outcome. When multiple threads modify shared data in an uncoordinated way, it may lead to **inconsistent, invalid, or broken data**.

* Happens when updates are partially completed.
* Can lead to invalid program state, crashes, or security vulnerabilities.
* Common in data structures not designed for concurrency.

**Example Scenario:**

Two threads modify a shared list at the same time. One adds and the other removes, leading to a corrupted internal state or `ConcurrentModificationException`

```java
import java.util.ArrayList;
import java.util.List;

public class DataCorruptionExample {
    private static List<Integer> list = new ArrayList<>();

    public static void main(String[] args) {
        Runnable task = () -> {
            for (int i = 0; i < 1000; i++) {
                list.add(i); // ArrayList is not thread-safe
            }
        };

        Thread t1 = new Thread(task);
        Thread t2 = new Thread(task);
        t1.start(); t2.start();

        try {
            t1.join(); t2.join();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        System.out.println("List size: " + list.size()); // May throw exception or size < 2000
    }
}
```

## What is Memory Visibility?

In a multithreaded Java program, **memory visibility** refers to **whether a change made by one thread is visible to another thread**.

* Java threads do **not always see the most updated value** of a shared variable.
* This happens because threads can **cache variables locally** (e.g., in registers or CPU caches), and those cached values may not be in sync with main memory.
* So, even if Thread A updates a variable, **Thread B might continue to see an old value**.

### Example of Memory Visibility Problem

```java
public class VisibilityProblem {
    private static boolean flag = false;

    public static void main(String[] args) {
        new Thread(() -> {
            while (!flag) {
                // Might run forever if flag update is not visible
            }
            System.out.println("Flag changed!");
        }).start();

        try {
            Thread.sleep(100);
        } catch (InterruptedException e) {}

        flag = true; // This change may not be visible to other thread
    }
}
```

In this code:

* The writer thread sets `flag = true`.
* But the reader thread **may not see the update** because the value of `flag` might be cached.

{% hint style="success" %}
### How to Fix It?

We can use:

* The `volatile` keyword.
* Proper synchronization (`synchronized` blocks or locks).
* Classes from `java.util.concurrent` package.

```java
private static volatile boolean flag = false;
```

Declaring `flag` as `volatile` **ensures visibility** — changes to `flag` by one thread are **immediately visible** to others.
{% endhint %}

## What is the Java Memory Model (JMM)?

The Java Memory Model is the formal set of rules that:

* Define how threads interact with memory.
* Specify when changes to variables made by one thread become visible to others.
* Define synchronization rules to prevent race conditions, visibility problems, and instruction reordering issues.

It governs:

* Reads and writes of variables.
* Synchronization actions (`volatile`, `synchronized`, `locks`, `atomic` operations).
* Thread safety and ordering guarantees.

{% hint style="warning" %}
Without JMM:

* The behavior of multithreaded code would be **undefined or inconsistent** across JVMs and hardware architectures.
* CPUs and compilers can **reorder instructions** for optimization.
* Without a memory model, there is **no way to reason** about correct synchronization.

JMM gives developers a **well-defined contract** for writing concurrent code.
{% endhint %}
