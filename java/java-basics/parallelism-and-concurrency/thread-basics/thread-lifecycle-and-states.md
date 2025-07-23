# Thread Lifecycle & States

## About

Threads in Java go through several states during their lifecycle. These states are defined in the `Thread.State` enum and managed by the Java Virtual Machine (JVM). Below is a detailed breakdown of all possible states, transitions, and in-depth concepts related to thread lifecycle management.

## **Thread States**

A thread in Java can be in one of the following states at any given time.

<table data-header-hidden><thead><tr><th width="204"></th><th></th></tr></thead><tbody><tr><td><strong>State</strong></td><td><strong>Description</strong></td></tr><tr><td><strong>NEW</strong></td><td>Thread is created but not yet started.</td></tr><tr><td><strong>RUNNABLE</strong></td><td>Thread is ready to run and waiting for CPU time.</td></tr><tr><td><strong>BLOCKED</strong></td><td>Thread is waiting for a monitor lock (due to synchronization).</td></tr><tr><td><strong>WAITING</strong></td><td>Thread is waiting indefinitely for another thread's signal.</td></tr><tr><td><strong>TIMED_WAITING</strong></td><td>Thread is waiting for a specified time before resuming.</td></tr><tr><td><strong>TERMINATED</strong></td><td>Thread has completed execution or was stopped abnormally.</td></tr></tbody></table>

## **State Transitions & Lifecycle**

A Java thread transitions between states as follows:

### **1. New (Unstarted)**

* When a thread is created using `new Thread()`, it remains in the **NEW** state.
* The thread has not started yet and is simply an object in memory.

```java
Thread t = new Thread(() -> System.out.println("Thread running"));
System.out.println(t.getState()); // Output: NEW
```

### **2. Runnable (Ready to Run)**

* When `start()` is called, the thread moves to the **RUNNABLE** state.
* It is waiting for CPU time and may be scheduled for execution at any moment.

```java
t.start();
System.out.println(t.getState()); // Output: RUNNABLE
```

### **3. Blocked (Waiting for a Lock)**

* If a thread tries to enter a synchronized block but another thread holds the lock, it moves to the **BLOCKED** state.
* It remains blocked until the lock is released.

```java
public class SharedResource {
    synchronized void access() {
        System.out.println(Thread.currentThread().getName() + " is inside.");
        try { Thread.sleep(1000); } catch (InterruptedException ignored) {}
    }
}

SharedResource resource = new SharedResource();

Thread t1 = new Thread(() -> resource.access());
Thread t2 = new Thread(() -> resource.access());

t1.start();
t2.start();

Thread.sleep(100); // Allow t1 to acquire lock
System.out.println(t2.getState()); // Output: BLOCKED
```

### **4. Waiting (Indefinitely Waiting)**

* A thread enters the **WAITING** state when it calls `Object.wait()` or `Thread.join()` **without a timeout**.
* It remains in this state until another thread calls `notify()` or `notifyAll()`.

```java
public class WaitingDemo {
    synchronized void waitForSignal() throws InterruptedException {
        System.out.println("Waiting...");
        wait();  // Moves to WAITING state
        System.out.println("Resumed.");
    }
}

WaitingDemo obj = new WaitingDemo();
Thread t = new Thread(() -> {
    try { obj.waitForSignal(); } catch (InterruptedException ignored) {}
});
t.start();

Thread.sleep(100); // Allow thread to enter WAITING state
System.out.println(t.getState()); // Output: WAITING
```

### **5. Timed Waiting (Waiting for a Limited Time)**

* A thread enters **TIMED\_WAITING** when it calls:
  * `Thread.sleep()`
  * `join(timeout)`
  * `wait(timeout)`
  * `LockSupport.parkNanos()` or `parkUntil()`

```java
Thread t = new Thread(() -> {
    try { Thread.sleep(2000); } catch (InterruptedException ignored) {}
});
t.start();

Thread.sleep(100); // Allow thread to enter TIMED_WAITING
System.out.println(t.getState()); // Output: TIMED_WAITING
```

### **6. Terminated (Completed or Stopped)**

* When a thread finishes execution or is forcibly stopped, it moves to **TERMINATED** state.
* A thread in this state **cannot be restarted**.

```java
Thread t = new Thread(() -> System.out.println("Thread executing"));
t.start();

Thread.sleep(100);
System.out.println(t.getState()); // Output: TERMINATED
```

### **7. Interrupting a Thread**

* A thread can be interrupted while it's in **RUNNABLE**, **WAITING**, or **TIMED\_WAITING** states.
* If a thread is in **WAITING** or **TIMED\_WAITING**, it throws `InterruptedException`.

```java
Thread t = new Thread(() -> {
    try { Thread.sleep(5000); } catch (InterruptedException e) {
        System.out.println("Thread was interrupted.");
    }
});

t.start();
Thread.sleep(100);
t.interrupt(); // Interrupts the sleeping thread
```

## **Comparison Between Thread States**

<table data-header-hidden data-full-width="true"><thead><tr><th width="193"></th><th width="199"></th><th></th></tr></thead><tbody><tr><td><strong>State</strong></td><td><strong>Can Execute Code?</strong></td><td><strong>Moves To?</strong></td></tr><tr><td><strong>NEW</strong></td><td>No</td><td>RUNNABLE (on <code>start()</code>)</td></tr><tr><td><strong>RUNNABLE</strong></td><td>Yes</td><td>BLOCKED, WAITING, TIMED_WAITING, TERMINATED</td></tr><tr><td><strong>BLOCKED</strong></td><td>No</td><td>RUNNABLE (once lock is released)</td></tr><tr><td><strong>WAITING</strong></td><td>No</td><td>RUNNABLE (on <code>notify()</code>, <code>interrupt()</code>, or <code>join()</code> completion)</td></tr><tr><td><strong>TIMED_WAITING</strong></td><td>No</td><td>RUNNABLE (on timeout or <code>interrupt()</code>)</td></tr><tr><td><strong>TERMINATED</strong></td><td>No</td><td>(Cannot restart)</td></tr></tbody></table>

## **Best Practices for Thread Management**

* **Avoid blocking threads unnecessarily** → Prefer non-blocking APIs like `CompletableFuture`.
* **Use thread pools instead of manually creating threads** → `Executors.newFixedThreadPool(n)`.
* **Interrupt threads properly** → Always check `Thread.interrupted()` inside loops.
* **Synchronize shared resources properly** → Use `synchronized`, `ReentrantLock`, or atomic variables.
