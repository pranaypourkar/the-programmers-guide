# Types of Locks

## About

Locks in Java help **synchronize access** to shared resources in multithreaded environments. They prevent race conditions and ensure **data consistency**. There are multiple types of locks based on their **scope, usage, and implementation**.

## **1. Object-Level Lock**

An **object-level lock** is associated with a specific instance of a class. It ensures that only **one thread** can execute a synchronized method/block **on a given object** at a time.

#### **Example**

```java
class SharedResource {
    public synchronized void display() {  // Object-level lock
        System.out.println(Thread.currentThread().getName() + " executing...");
    }
}
```

* If two threads call `display()` **on the same object**, they will execute **one after another**.
* If two threads call `display()` **on different objects**, they will execute **independently**.

#### **Equivalent Using Explicit Lock**

```java
import java.util.concurrent.locks.ReentrantLock;

class SharedResource {
    private final ReentrantLock lock = new ReentrantLock();

    public void display() {
        lock.lock();
        try {
            System.out.println(Thread.currentThread().getName() + " executing...");
        } finally {
            lock.unlock();
        }
    }
}
```

## **2. Class-Level Lock (Static Synchronization)**

A **class-level lock** is used to synchronize **static methods or blocks**. It prevents multiple threads from executing **static methods of the same class** simultaneously.

* **Affects all instances** of the class.
* Only **one thread** can execute any synchronized static method **at a time**.

#### **Example**

```java
class SharedResource {
    public static synchronized void display() {  // Class-level lock
        System.out.println(Thread.currentThread().getName() + " executing...");
    }
}
```

#### **Equivalent Using Explicit Lock**

```java
import java.util.concurrent.locks.ReentrantLock;

class SharedResource {
    private static final ReentrantLock lock = new ReentrantLock();

    public static void display() {
        lock.lock();
        try {
            System.out.println(Thread.currentThread().getName() + " executing...");
        } finally {
            lock.unlock();
        }
    }
}
```

## **3. Method-Level Lock**

A **method-level lock** is applied by synchronizing an entire method. It applies **object-level or class-level locking**, depending on whether the method is **instance** or **static**.

#### **Example (Instance Method)**

```java
class SharedResource {
    public synchronized void display() {  // Implicit object-level lock
        System.out.println(Thread.currentThread().getName() + " executing...");
    }
}
```

{% hint style="info" %}
Equivalent to `synchronized(this) {}` inside the method.
{% endhint %}

#### **Example (Static Method)**

```java
class SharedResource {
    public static synchronized void display() {  // Implicit class-level lock
        System.out.println(Thread.currentThread().getName() + " executing...");
    }
}
```

{% hint style="info" %}
Equivalent to `synchronized(SharedResource.class) {}` inside the method.
{% endhint %}

## **4. Block-Level Lock**

A **block-level lock** restricts synchronization to a specific block **inside a method** instead of locking the entire method.

#### **Example (Object-Level)**

```java
class SharedResource {
    public void display() {
        synchronized (this) {  // Locking only this block
            System.out.println(Thread.currentThread().getName() + " executing...");
        }
    }
}
```

{% hint style="info" %}
Other methods **can still run** while this block is locked.
{% endhint %}

#### **Example (Class-Level)**

```java
class SharedResource {
    public void display() {
        synchronized (SharedResource.class) {  // Locking the entire class
            System.out.println(Thread.currentThread().getName() + " executing...");
        }
    }
}
```

{% hint style="info" %}
Synchronization affects **all threads calling static methods**
{% endhint %}

## **5. Reentrant Lock**

A **Reentrant Lock** allows the same thread to **acquire the same lock multiple times** without causing a deadlock.

#### **Example**

```java
import java.util.concurrent.locks.ReentrantLock;

class SharedResource {
    private final ReentrantLock lock = new ReentrantLock();

    public void display() {
        lock.lock();
        try {
            System.out.println(Thread.currentThread().getName() + " executing...");
        } finally {
            lock.unlock();
        }
    }
}
```

* Unlike `synchronized`, `ReentrantLock` provides:
  * **Try Locking** (`tryLock()`)
  * **Interruptible Locking** (`lockInterruptibly()`)
  * **Fair Locking** (`new ReentrantLock(true)`)

## **6. Fair and Unfair Locks**

* **Fair Lock**: Threads are scheduled **in the order they requested the lock**.
* **Unfair Lock** (default): The lock **may not follow strict ordering**.

#### **Example**

```java
ReentrantLock fairLock = new ReentrantLock(true);  // Enables fairness
```

* Fair locks **prevent thread starvation**, but can reduce performance.

## **7. Read-Write Lock**

A **ReadWriteLock** allows:

* **Multiple readers** to access a resource **concurrently**.
* **Only one writer** to access the resource **exclusively**.
* **Useful for caching** and **database operations**.

#### **Example**

```java
import java.util.concurrent.locks.ReentrantReadWriteLock;

class SharedResource {
    private final ReentrantReadWriteLock rwLock = new ReentrantReadWriteLock();

    public void read() {
        rwLock.readLock().lock();
        try {
            System.out.println(Thread.currentThread().getName() + " reading...");
        } finally {
            rwLock.readLock().unlock();
        }
    }

    public void write() {
        rwLock.writeLock().lock();
        try {
            System.out.println(Thread.currentThread().getName() + " writing...");
        } finally {
            rwLock.writeLock().unlock();
        }
    }
}
```

## **8. Stamped Lock**

A **StampedLock** improves upon `ReadWriteLock` by:

* **Optimistic Reads** (reading without blocking writes).
* **Explicit stamp validation**.
* Provides **better performance** than `ReadWriteLock`

#### **Example**

```java
import java.util.concurrent.locks.StampedLock;

class SharedResource {
    private final StampedLock lock = new StampedLock();

    public void read() {
        long stamp = lock.tryOptimisticRead();
        System.out.println(Thread.currentThread().getName() + " reading optimistically...");
        if (!lock.validate(stamp)) {  // Check if a write happened
            stamp = lock.readLock();
            try {
                System.out.println(Thread.currentThread().getName() + " reading after acquiring lock...");
            } finally {
                lock.unlockRead(stamp);
            }
        }
    }

    public void write() {
        long stamp = lock.writeLock();
        try {
            System.out.println(Thread.currentThread().getName() + " writing...");
        } finally {
            lock.unlockWrite(stamp);
        }
    }
}.
```

## **9. Spin Lock**

A **Spin Lock** makes threads **actively wait** (busy-waiting) instead of blocking.

* **Used in low-latency applications** but **wastes CPU cycles**.

#### **Example**

```java
import java.util.concurrent.atomic.AtomicBoolean;

class SpinLock {
    private AtomicBoolean lock = new AtomicBoolean(false);

    public void lock() {
        while (!lock.compareAndSet(false, true)) {
            // Busy-wait
        }
    }

    public void unlock() {
        lock.set(false);
    }
}
```

## Comparison

<table data-full-width="true"><thead><tr><th width="164">Lock Type</th><th width="158">Scope</th><th width="283">Use Case</th><th>Pros</th><th>Cons</th></tr></thead><tbody><tr><td><strong>Object-Level</strong></td><td>Instance</td><td>Prevent multiple threads from modifying an object</td><td>Simple</td><td>Blocks entire method</td></tr><tr><td><strong>Class-Level</strong></td><td>Static Methods</td><td>Synchronize across all instances</td><td>Ensures global lock</td><td>Affects all threads</td></tr><tr><td><strong>Method-Level</strong></td><td>Entire Method</td><td>Prevent concurrent execution of a method</td><td>Easy to use</td><td>Can be inefficient</td></tr><tr><td><strong>Block-Level</strong></td><td>Inside a Method</td><td>Synchronize specific part of a method</td><td>More efficient</td><td>Requires careful implementation</td></tr><tr><td><strong>ReentrantLock</strong></td><td>Custom</td><td>More control over locking</td><td>Advanced features</td><td>Requires manual unlocking</td></tr><tr><td><strong>ReadWriteLock</strong></td><td>Read-Write</td><td>Allows concurrent reads</td><td>Faster reads</td><td>Complexity</td></tr><tr><td><strong>StampedLock</strong></td><td>Read-Write</td><td>Optimistic reads for performance</td><td>High efficiency</td><td>Difficult to implement</td></tr><tr><td><strong>Spin Lock</strong></td><td>CPU-bound</td><td>High-performance, low-latency apps</td><td>No context switching</td><td>Wastes CPU</td></tr></tbody></table>
