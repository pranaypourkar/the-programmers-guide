# Synchronized Blocks & Methods

## About

In Java, synchronization ensures that multiple threads do not interfere with each other while accessing **shared resources**. The `synchronized` keyword is used to **prevent race conditions, ensure atomicity, and maintain data consistency** in multi-threaded applications.

## **Why is Synchronization Needed?**

When multiple threads operate on **shared data**, race conditions can occur. This leads to **inconsistent, corrupted, or unpredictable results**. Synchronization ensures that only **one thread at a time** can access a critical section.

#### **Example Without Synchronization (Race Condition)**

```java
class SharedResource {
    private int count = 0;

    void increment() { // Not synchronized
        count++;
    }

    int getCount() {
        return count;
    }
}

public class RaceConditionExample {
    public static void main(String[] args) throws InterruptedException {
        SharedResource resource = new SharedResource();

        Thread t1 = new Thread(() -> {
            for (int i = 0; i < 1000; i++) {
                resource.increment();
            }
        });

        Thread t2 = new Thread(() -> {
            for (int i = 0; i < 1000; i++) {
                resource.increment();
            }
        });

        t1.start();
        t2.start();
        t1.join();
        t2.join();

        System.out.println("Final Count: " + resource.getCount()); // Expected: 2000, but may be incorrect due to race condition
    }
}
```

#### **Output (Inconsistent Results)**

```
Final Count: 1892  // (May vary)
```

Here, multiple threads modify `count` simultaneously, leading to **data corruption**.

## **Synchronized Methods**

A **synchronized method** ensures that **only one thread at a time** can execute the method on an instance of the class.

* When a thread enters a synchronized method, it **acquires an intrinsic lock** (also known as **monitor lock**) on the object.
* If another thread attempts to call **any other synchronized method** on the same object, it will be **blocked** until the first thread releases the lock.
* This prevents **race conditions** but introduces **performance overhead** due to blocking.

### **Syntax**

```java
synchronized returnType methodName(parameters) {
    // Critical section
}
```

### **Example of Synchronized Method**

```java
class SharedCounter {
    private int count = 0;

    public synchronized void increment() { // Only one thread can access this method at a time
        count++;
    }

    public synchronized int getCount() {
        return count;
    }
}

public class SynchronizedMethodExample {
    public static void main(String[] args) throws InterruptedException {
        SharedCounter counter = new SharedCounter();

        Thread t1 = new Thread(() -> {
            for (int i = 0; i < 1000; i++) counter.increment();
        });

        Thread t2 = new Thread(() -> {
            for (int i = 0; i < 1000; i++) counter.increment();
        });

        t1.start();
        t2.start();
        t1.join();
        t2.join();

        System.out.println("Final Count: " + counter.getCount()); // Always 2000
    }
}
```

#### **Output (Always Correct)**

```
Final Count: 2000
```

### **How It Works?**

* The method is synchronized using `synchronized` keyword.
* Java uses an **intrinsic lock (monitor)** on the instance (`this`).
* If one thread enters the method, other threads must **wait** until it exits.

### **When to Use?**

* When the **entire method** needs to be **protected**.
* When a class method modifies **instance variables** shared between threads.
* When a method is small and does **not require fine-grained locking**.

## **Synchronized Blocks**

Instead of locking an **entire method**, a **synchronized block** locks **only a specific critical section** inside a method.

* This allows other **non-critical** code to execute **without blocking**.
* Instead of locking the **entire object (`this`)**, it can use a **custom lock object**, allowing more **flexibility**.

### **Syntax**

```java
synchronized(lockObject) {
    // Critical section
}
```

### **Example 1**

```java
class SharedCounter {
    private int count = 0;
    private final Object lock = new Object(); // Custom lock object

    public void increment() {
        synchronized (lock) { // Synchronizing only this block
            count++;
        }
    }

    public int getCount() {
        return count;
    }
}

public class SynchronizedBlockExample {
    public static void main(String[] args) throws InterruptedException {
        SharedCounter counter = new SharedCounter();

        Thread t1 = new Thread(() -> {
            for (int i = 0; i < 1000; i++) counter.increment();
        });

        Thread t2 = new Thread(() -> {
            for (int i = 0; i < 1000; i++) counter.increment();
        });

        t1.start();
        t2.start();
        t1.join();
        t2.join();

        System.out.println("Final Count: " + counter.getCount()); // Always 2000
    }
}
```

### **Example 2**

**Synchronized block locking entire object** (also called **intrinsic locking on `this`**)

```java
public class SharedPrinter {

    public void printMessages(String threadName) {
        synchronized (this) { // Locks the entire object
            System.out.println(threadName + " started printing...");

            try {
                Thread.sleep(1000); // Simulate time-consuming task
            } catch (InterruptedException e) {
                e.printStackTrace();
            }

            System.out.println(threadName + " finished printing.");
        }
    }

    public static void main(String[] args) {
        SharedPrinter printer = new SharedPrinter();

        Runnable task1 = () -> printer.printMessages("Thread 1");
        Runnable task2 = () -> printer.printMessages("Thread 2");

        Thread t1 = new Thread(task1);
        Thread t2 = new Thread(task2);

        t1.start();
        t2.start();
    }
}

/* Sample Output
Thread 1 started printing...
Thread 1 finished printing.
Thread 2 started printing...
Thread 2 finished printing.
 */
```

* `synchronized (this)` locks the **entire object** (`SharedPrinter` in this case).
* Only **one thread at a time** can enter the `synchronized` block for that object.
* If another thread tries to enter the `synchronized` block, it has to **wait** until the lock is released.
* This ensures thread-safe access to critical sections that depend on the shared object state.

```
Note: The threads do not run in parallel inside the synchronized (this) block. 
They are serialized because the entire object is locked.
```

### **How It Works?**

* The lock is applied **only on the necessary code block**.
* Other parts of the method can execute **without blocking**.
* This increases **efficiency** compared to synchronizing the whole method.

### **When to Use?**

* When **only a part** of the method needs protection.
* When performance is a concern, and unnecessary locking is avoided.
* When **multiple locks** are required for different data elements.

## **Class-Level Synchronization (Static Methods)**

Class-level synchronization ensures that only **one thread at a time** can execute a **synchronized static method**, across all instances of the class.

* The **lock is on the Class object (`Class<T>`)** instead of an instance.
* Even if multiple objects of the class exist, they **share the same class-level lock**.

### **Example**

```java
class SharedCounter {
    private static int count = 0;

    public static synchronized void increment() { // Class-level lock
        count++;
    }

    public static synchronized int getCount() {
        return count;
    }
}
```

### **When to Use?**

* When modifying **static variables** shared across multiple instances.

### **Class-Level Lock vs. Instance-Level Lock**

<table data-header-hidden data-full-width="true"><thead><tr><th width="148"></th><th width="321"></th><th></th></tr></thead><tbody><tr><td><strong>Aspect</strong></td><td><strong>Instance-Level Lock</strong></td><td><strong>Class-Level Lock</strong></td></tr><tr><td><strong>Scope</strong></td><td>Applied to a single object</td><td>Applied to the entire class</td></tr><tr><td><strong>Effect</strong></td><td>Only one thread per object can enter</td><td>Only one thread across all instances can enter</td></tr><tr><td><strong>Use Case</strong></td><td>When dealing with instance-specific data</td><td>When dealing with shared static data</td></tr></tbody></table>

## **Comparison Table**

<table data-header-hidden data-full-width="true"><thead><tr><th width="162"></th><th></th><th></th><th></th></tr></thead><tbody><tr><td>Feature</td><td><strong>Synchronized Method</strong></td><td><strong>Synchronized Block</strong></td><td><strong>Class-Level Synchronization</strong></td></tr><tr><td><strong>Lock Type</strong></td><td>Intrinsic lock on <code>this</code> (object)</td><td>Lock on a specific section</td><td>Lock on <code>Class&#x3C;T></code></td></tr><tr><td><strong>Performance</strong></td><td>Low (entire method is locked)</td><td>High (only necessary section locked)</td><td>Moderate (static method locks entire class)</td></tr><tr><td><strong>Flexibility</strong></td><td>Low (locks entire method)</td><td>High (can use custom lock objects)</td><td>Medium (locks entire static method)</td></tr><tr><td><strong>Use Case</strong></td><td>When <strong>entire method</strong> needs synchronization</td><td>When <strong>part of a method</strong> needs synchronization</td><td>When <strong>static shared data</strong> needs synchronization</td></tr></tbody></table>
