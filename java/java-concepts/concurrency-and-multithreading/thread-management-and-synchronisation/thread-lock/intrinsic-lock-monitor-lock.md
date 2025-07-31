# Intrinsic Lock (Monitor Lock)

## About

In Java, every object has an associated **intrinsic lock (also known as a monitor lock)**, which is used for **synchronization**. The Java Virtual Machine (JVM) automatically associates a lock with **every object** to coordinate access among multiple threads.

When a thread enters a **synchronized block or method**, it must acquire the intrinsic lock of the associated object. Once acquired, other threads attempting to enter any synchronized section on the same object are **blocked** until the lock is released.

The intrinsic lock is also used in inter-thread communication via `wait()`, `notify()`, and `notifyAll()`.

* `wait()`: Releases the lock and **puts the thread in a waiting state**.
* `notify()`: Wakes up **one waiting thread**.
* `notifyAll()`: Wakes up **all waiting threads**.

## **Intrinsic Lock Acquisition Process**

1. **Thread Tries to Enter a Synchronized Block or Method**
   * If no other thread holds the object's lock, the thread **acquires the lock** and proceeds.
   * If another thread holds the lock, the current thread **waits** until the lock is released.
2. **Thread Executes the Critical Section**
   * The thread **performs operations** inside the synchronized block/method while **holding the lock**.
3. **Thread Releases the Lock**
   * After the synchronized block/method **completes execution**, the thread **releases the lock**, allowing other waiting threads to proceed.

## **Types of Intrinsic Lock Usage in Java**

### **1. Synchronized Methods and Intrinsic Lock**

When a method is declared as `synchronized`, the **intrinsic lock of the object (`this`)** is used.

#### **Example: Synchronization Using Intrinsic Lock on an Object**

```java
class SharedResource {
    public synchronized void displayMessage(String message) {
        System.out.println(Thread.currentThread().getName() + " is executing: " + message);
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println(Thread.currentThread().getName() + " finished execution.");
    }
}

public class SynchronizedMethodExample {
    public static void main(String[] args) {
        SharedResource resource = new SharedResource();

        // Two threads trying to access the synchronized method
        Thread t1 = new Thread(() -> resource.displayMessage("Hello from Thread-1"), "Thread-1");
        Thread t2 = new Thread(() -> resource.displayMessage("Hello from Thread-2"), "Thread-2");

        t1.start();
        t2.start();
    }
}
```

### **2. Synchronized Blocks and Intrinsic Lock**

Instead of locking an entire method, **synchronized blocks** allow locking of **specific code sections**, improving efficiency.

#### **Example: Synchronization Using an Intrinsic Lock on a Specific Object**

```java
class SharedResource {
    private final Object lock = new Object();

    public void displayMessage(String message) {
        System.out.println(Thread.currentThread().getName() + " is preparing to execute.");
        
        synchronized (lock) {  // Only this block is synchronized
            System.out.println(Thread.currentThread().getName() + " is executing: " + message);
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            System.out.println(Thread.currentThread().getName() + " finished execution.");
        }
    }
}

public class SynchronizedBlockExample {
    public static void main(String[] args) {
        SharedResource resource = new SharedResource();

        Thread t1 = new Thread(() -> resource.displayMessage("Hello from Thread-1"), "Thread-1");
        Thread t2 = new Thread(() -> resource.displayMessage("Hello from Thread-2"), "Thread-2");

        t1.start();
        t2.start();
    }
}
```

### **3. Class-Level Synchronization and Intrinsic Lock on `Class<T>`**

When a `static` method is synchronized, the **intrinsic lock is on the Class object** (`Class<T>`), ensuring that **only one thread** can execute any synchronized static method at a time.

#### **Example: Synchronization Using Class-Level Lock**

```java
class SharedResource {
    private static int counter = 0;

    public static synchronized void increment() {
        counter++;
        System.out.println(Thread.currentThread().getName() + " incremented counter to: " + counter);
    }
}

public class ClassLevelSyncExample {
    public static void main(String[] args) {
        Thread t1 = new Thread(SharedResource::increment, "Thread-1");
        Thread t2 = new Thread(SharedResource::increment, "Thread-2");

        t1.start();
        t2.start();
    }
}
```

## Is the Intrinsic Lock Implicit or Explicit?

The **intrinsic lock (monitor lock)** in Java is an **implicit lock**, meaning:

* It is **automatically associated** with every Java object.
* It does **not require explicit creation**—it is acquired and released automatically when using `synchronized`.
* The JVM **manages it internally**, unlike `ReentrantLock`, which must be explicitly created and controlled.

### **Intrinsic Lock = Implicit Lock**

When a thread enters a `synchronized` method or block, it **implicitly acquires** the intrinsic lock of the associated object **without needing manual intervention**.

**Example: Implicit Lock Using `synchronized`**

```java
class SharedResource {
    public synchronized void displayMessage(String message) {
        System.out.println(Thread.currentThread().getName() + " executing: " + message);
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println(Thread.currentThread().getName() + " finished.");
    }
}

public class IntrinsicLockExample {
    public static void main(String[] args) {
        SharedResource resource = new SharedResource();

        Thread t1 = new Thread(() -> resource.displayMessage("Hello from Thread-1"), "Thread-1");
        Thread t2 = new Thread(() -> resource.displayMessage("Hello from Thread-2"), "Thread-2");

        t1.start();
        t2.start();
    }
}
```

#### **Why Is It Implicit?**

* The lock is **automatically acquired** when `synchronized` is used.
* The lock is **automatically released** when the synchronized method/block completes execution.
* **No explicit lock handling** (e.g., `lock.lock()` and `lock.unlock()`) is required.

### **Explicit Locks: How They Differ from Intrinsic Locks**

Unlike **intrinsic locks**, explicit locks like `ReentrantLock` must be **manually controlled**.

**Example: Explicit Lock Using `ReentrantLock`**

```java
import java.util.concurrent.locks.ReentrantLock;

class SharedResource {
    private final ReentrantLock lock = new ReentrantLock();

    public void displayMessage(String message) {
        lock.lock();  // Explicitly acquiring the lock
        try {
            System.out.println(Thread.currentThread().getName() + " executing: " + message);
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {
            lock.unlock();  // Explicitly releasing the lock
        }
    }
}
```

## Equivalent Explicit Lock Code for Intrinsic Lock

### **1.1. Intrinsic Lock (Implicit) – Using `synchronized`**

```java
class SharedResource {
    // Implicitly using the intrinsic lock of 'this' object
    public synchronized void displayMessage(String message) {
        System.out.println(Thread.currentThread().getName() + " executing: " + message);
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println(Thread.currentThread().getName() + " finished.");
    }
}
```

### **1.2. Equivalent Explicit Lock – Using `ReentrantLock`**

```java
import java.util.concurrent.locks.ReentrantLock;

class SharedResource {
    private final ReentrantLock lock = new ReentrantLock(); // Explicit lock

    public void displayMessage(String message) {
        lock.lock();  // Manually acquiring the lock
        try {
            System.out.println(Thread.currentThread().getName() + " executing: " + message);
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {
            lock.unlock();  // Manually releasing the lock
        }
    }
}
```

### **2.1. Intrinsic Lock – Using `synchronized` Block**

```java
class SharedResource {
    public void displayMessage(String message) {
        synchronized (this) { // Explicitly locking 'this' instance
            System.out.println(Thread.currentThread().getName() + " executing: " + message);
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            System.out.println(Thread.currentThread().getName() + " finished.");
        }
    }
}
```

### **2.2. Equivalent Explicit Lock – Using `ReentrantLock` in a Block**

```java
import java.util.concurrent.locks.ReentrantLock;

class SharedResource {
    private final ReentrantLock lock = new ReentrantLock();

    public void displayMessage(String message) {
        if (lock.tryLock()) {  // Attempting to acquire the lock
            try {
                System.out.println(Thread.currentThread().getName() + " executing: " + message);
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            } finally {
                lock.unlock(); // Releasing the lock
            }
        } else {
            System.out.println(Thread.currentThread().getName() + " could not acquire lock.");
        }
    }
}
```
