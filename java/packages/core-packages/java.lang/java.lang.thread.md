# java.lang.Thread

## About

The `java.lang.Thread` class is the foundation for multithreading in Java. It represents an individual thread of execution and provides methods for managing thread behaviour, controlling execution, and retrieving thread information.&#x20;

{% hint style="success" %}
Thread is a **concrete class** defined in `java.lang` package
{% endhint %}

The `Thread` class allows:

* **Creating and controlling threads**
* **Managing thread lifecycle** (start, sleep, join, etc.)
* **Setting thread properties** (priority, daemon, etc.)
* **Handling exceptions within threads**

### **Declaration**

```java
public class Thread implements Runnable
```

* The `Thread` class **implements the `Runnable` interface**, allowing it to execute tasks.

### **Why Is `Thread` Not Abstract?**

Although `Thread` is often subclassed, Java does not enforce it as an abstract class because:

1.  **Direct Instantiation**: Java allows us to create a `Thread` instance with a `Runnable` directly.

    ```java
    Thread t = new Thread(() -> System.out.println("Running"));
    t.start();
    ```
2.  **Default Implementation of `run()`**: `Thread` provides a default empty implementation of `run()`:

    ```java
    public void run() { }
    ```

    If `Thread` were abstract, every subclass would be **forced** to implement `run()`, which is not always necessary.

## **Constructors**

The `Thread` class provides multiple constructors to create threads.

<table data-header-hidden data-full-width="true"><thead><tr><th width="536"></th><th></th></tr></thead><tbody><tr><td><strong>Constructor</strong></td><td><strong>Description</strong></td></tr><tr><td><code>Thread()</code></td><td>Creates a new thread with a default name.</td></tr><tr><td><code>Thread(Runnable target)</code></td><td>Creates a thread that executes a <code>Runnable</code> task.</td></tr><tr><td><code>Thread(Runnable target, String name)</code></td><td>Creates a thread with a specific name.</td></tr><tr><td><code>Thread(String name)</code></td><td>Creates a thread with a given name.</td></tr><tr><td><code>Thread(ThreadGroup group, Runnable target)</code></td><td>Creates a thread in a specific thread group.</td></tr><tr><td><code>Thread(ThreadGroup group, Runnable target, String name)</code></td><td>Creates a named thread in a given thread group.</td></tr><tr><td><code>Thread(ThreadGroup group, String name)</code></td><td>Creates a named thread in a given thread group.</td></tr></tbody></table>

### **Example: Creating a Thread Using Different Constructors**

```java
public class MyTask implements Runnable {
    public void run() {
        System.out.println("Thread running: " + Thread.currentThread().getName());
    }
}

public class ThreadDemo {
    public static void main(String[] args) {
        Thread t1 = new Thread(); // Default thread
        Thread t2 = new Thread(new MyTask()); // Runnable target
        Thread t3 = new Thread(new MyTask(), "Worker Thread"); // Runnable with name

        t1.start();
        t2.start();
        t3.start();
    }
}
```

## **Thread Control Methods**

The `Thread` class provides several methods for controlling execution.

<table data-header-hidden><thead><tr><th width="348"></th><th></th></tr></thead><tbody><tr><td><strong>Method</strong></td><td><strong>Description</strong></td></tr><tr><td><code>void start()</code></td><td>Starts the thread and calls <code>run()</code> method.</td></tr><tr><td><code>void run()</code></td><td>Defines the task executed by the thread.</td></tr><tr><td><code>static void sleep(long millis)</code></td><td>Makes the current thread sleep for a given time.</td></tr><tr><td><code>void join()</code></td><td>Waits for the thread to finish execution.</td></tr><tr><td><code>void interrupt()</code></td><td>Interrupts a sleeping/waiting thread.</td></tr><tr><td><code>boolean isAlive()</code></td><td>Checks if the thread is still running.</td></tr></tbody></table>

**Example**

### **1. `start()` and `run()`**

* `start()`: Creates a new thread and invokes `run()` on that thread.
* `run()`: Executes in the **current thread** (not a new one).

```java
public class MyThread extends Thread {
    public void run() {
        System.out.println("Running in thread: " + Thread.currentThread().getName());
    }
}

public class StartVsRunExample {
    public static void main(String[] args) {
        MyThread t1 = new MyThread();
        
        // Using start() -> Runs in a new thread
        t1.start();

        // Using run() -> Runs in the main thread
        t1.run(); 

        System.out.println("Main thread finished: " + Thread.currentThread().getName());
        /* 
        Running in thread: Thread-0
        Running in thread: main
        Main thread finished: main
        */
    }
}
```

### **2. `sleep()` – Pause Execution**

* `sleep(time)` pauses the thread for the given **milliseconds**.

```java
public class SleepExample extends Thread {
    public void run() {
        for (int i = 1; i <= 3; i++) {
            try {
                System.out.println("Sleeping for 1 second...");
                Thread.sleep(1000); // Sleep for 1 second
            } catch (InterruptedException e) {
                System.out.println("Thread interrupted!");
            }
            System.out.println("Thread running: " + i);
        }
    }
}

public class SleepDemo {
    public static void main(String[] args) {
        SleepExample t1 = new SleepExample();
        t1.start();
        /*
        Sleeping for 1 second...
        Thread running: 1
        Sleeping for 1 second...
        Thread running: 2
        Sleeping for 1 second...
        Thread running: 3
        */
    }
}
```

### **3. `join()` – Wait for Another Thread to Finish**

* `join()` makes the calling thread wait until the specified thread **finishes execution**.

```java
public class JoinExample extends Thread {
    public void run() {
        for (int i = 1; i <= 5; i++) {
            System.out.println("Thread running: " + i);
            try {
                Thread.sleep(500); // Sleep for 500ms
            } catch (InterruptedException e) {
                System.out.println("Thread interrupted!");
            }
        }
    }
}

public class JoinDemo {
    public static void main(String[] args) {
        JoinExample t1 = new JoinExample();
        JoinExample t2 = new JoinExample();

        t1.start();
        try {
            t1.join();  // Main thread waits for t1 to finish
        } catch (InterruptedException e) {
            System.out.println("Main thread interrupted!");
        }

        t2.start(); // t2 starts only after t1 is done
        
        /*
        Thread running: 1
        Thread running: 2
        Thread running: 3
        Thread running: 4
        Thread running: 5
        Thread running: 1
        Thread running: 2
        Thread running: 3
        Thread running: 4
        Thread running: 5
        */
    }
}
```

### **4. `interrupt()` – Stop a Sleeping/Waiting Thread**

* `interrupt()` signals a thread to **stop execution** if it is sleeping or waiting.

```java
public class InterruptExample extends Thread {
    public void run() {
        try {
            System.out.println("Thread going to sleep...");
            Thread.sleep(5000); // Sleep for 5 seconds
            System.out.println("Thread woke up!");
        } catch (InterruptedException e) {
            System.out.println("Thread interrupted while sleeping!");
        }
    }
}

public class InterruptDemo {
    public static void main(String[] args) {
        InterruptExample t1 = new InterruptExample();
        t1.start();
        
        try {
            Thread.sleep(2000); // Let thread run for 2 seconds
        } catch (InterruptedException e) {
            System.out.println("Main thread interrupted!");
        }

        t1.interrupt(); // Interrupt t1 while sleeping
        
        /*
        Thread going to sleep...
        Thread interrupted while sleeping!
        */
    }
}
```

### **5. `isAlive()` – Check if Thread is Running**

* `isAlive()` returns `true` if the thread is still running, else `false`.

```java
public class AliveExample extends Thread {
    public void run() {
        try {
            Thread.sleep(1000); // Sleep for 1 second
        } catch (InterruptedException e) {
            System.out.println("Thread interrupted!");
        }
        System.out.println("Thread finished execution.");
    }
}

public class IsAliveDemo {
    public static void main(String[] args) {
        AliveExample t1 = new AliveExample();
        System.out.println("Before start: " + t1.isAlive()); // false

        t1.start();
        System.out.println("After start: " + t1.isAlive()); // true

        try {
            t1.join(); // Wait for t1 to finish
        } catch (InterruptedException e) {
            System.out.println("Main thread interrupted!");
        }

        System.out.println("After join: " + t1.isAlive()); // false
        
        /*
        Before start: false
        After start: true
        Thread finished execution.
        After join: false
        */
    }
}
```

## **Thread Property Methods**

The `Thread` class provides several methods for thread properties.

| **Method**                       | **Description**                       |
| -------------------------------- | ------------------------------------- |
| set`void setName(String name)`   | Sets the thread’s name.               |
| `String getName()`               | Returns the thread’s name.            |
| `void setPriority(int priority)` | Sets thread priority (1-10).          |
| `int getPriority()`              | Gets thread priority.                 |
| `static Thread currentThread()`  | Returns the currently running thread. |
| `void setDaemon(boolean status)` | Marks a thread as daemon.             |
| `boolean isDaemon()`             | Checks if the thread is daemon.       |

```java
public class MyThread extends Thread {
    public void run() {
        System.out.println("Thread Name: " + getName());
        System.out.println("Thread Priority: " + getPriority());
        System.out.println("Is Daemon: " + isDaemon());
    }
}

public class ThreadPropertiesExample {
    public static void main(String[] args) {
        // Creating threads
        MyThread t1 = new MyThread();
        MyThread t2 = new MyThread();
        MyThread daemonThread = new MyThread();

        // Setting names
        t1.setName("Worker-1");
        t2.setName("Worker-2");
        daemonThread.setName("BackgroundDaemon");

        // Setting priorities
        t1.setPriority(Thread.MIN_PRIORITY); // Priority = 1
        t2.setPriority(Thread.MAX_PRIORITY); // Priority = 10

        // Setting daemon thread
        daemonThread.setDaemon(true); // Making daemon thread

        // Starting threads
        t1.start();
        t2.start();
        daemonThread.start();
        
        /*
        Thread Name: Worker-1
        Thread Priority: 1
        Is Daemon: false
        Thread Name: Worker-2
        Thread Priority: 10
        Is Daemon: false
        Thread Name: BackgroundDaemon
        Thread Priority: 5
        Is Daemon: true
        */
    }
}
```

## **Thread State Methods**

The `Thread` class provides several methods for state management.

<table data-header-hidden><thead><tr><th width="290"></th><th></th></tr></thead><tbody><tr><td><strong>Method</strong></td><td><strong>Description</strong></td></tr><tr><td><code>Thread.State getState()</code></td><td>Returns the thread’s state.</td></tr><tr><td><code>void yield()</code></td><td>Suggests the scheduler to allow other threads to execute.</td></tr></tbody></table>

```java
public class MyThread extends Thread {
    public void run() {
        System.out.println(getName() + " - State: " + getState()); // Running State

        for (int i = 1; i <= 3; i++) {
            System.out.println(getName() + " is running: " + i);
            Thread.yield(); // Giving chance to other threads
        }

        System.out.println(getName() + " - State After Completion: " + getState());
    }
}

public class ThreadStateYieldExample {
    public static void main(String[] args) {
        MyThread t1 = new MyThread();
        MyThread t2 = new MyThread();

        System.out.println(t1.getName() + " - Initial State: " + t1.getState()); // NEW

        t1.start();
        t2.start();

        System.out.println(t1.getName() + " - State After Start: " + t1.getState()); // RUNNABLE
        System.out.println(t2.getName() + " - State After Start: " + t2.getState());

        try {
            t1.join(); // Waiting for t1 to finish
            t2.join(); // Waiting for t2 to finish
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        System.out.println(t1.getName() + " - Final State: " + t1.getState()); // TERMINATED
        System.out.println(t2.getName() + " - Final State: " + t2.getState()); // TERMINATED
        
        /*
        Thread-0 - Initial State: NEW
        Thread-0 - State After Start: RUNNABLE
        Thread-1 - State After Start: RUNNABLE
        Thread-0 - State: RUNNABLE
        Thread-0 is running: 1
        Thread-1 - State: RUNNABLE
        Thread-1 is running: 1
        Thread-0 is running: 2
        Thread-1 is running: 2
        Thread-0 is running: 3
        Thread-1 is running: 3
        Thread-0 - State After Completion: RUNNABLE
        Thread-1 - State After Completion: RUNNABLE
        Thread-0 - Final State: TERMINATED
        Thread-1 - Final State: TERMINATED
        */ 
    }
}
```

## **Thread Interruption Methods**

<table data-header-hidden><thead><tr><th width="326"></th><th></th></tr></thead><tbody><tr><td><strong>Method</strong></td><td><strong>Description</strong></td></tr><tr><td><code>void interrupt()</code></td><td>Interrupts a thread.</td></tr><tr><td><code>boolean isInterrupted()</code></td><td>Checks if a thread is interrupted.</td></tr><tr><td><code>static boolean interrupted()</code></td><td>Checks and clears the interrupt status of the current thread.</td></tr></tbody></table>

```java
class MyThread extends Thread {
    public void run() {
        System.out.println(getName() + " started.");

        // Checking interrupted status in a loop
        for (int i = 1; i <= 5; i++) {
            if (isInterrupted()) { // Checks if thread is interrupted
                System.out.println(getName() + " was interrupted. Exiting...");
                return; // Exit if interrupted
            }
            System.out.println(getName() + " is working: " + i);
            try {
                Thread.sleep(1000); // Simulating work
            } catch (InterruptedException e) {
                System.out.println(getName() + " caught InterruptedException.");
                return; // Exit after catching InterruptedException
            }
        }
        System.out.println(getName() + " completed.");
    }
}

public class InterruptExample {
    public static void main(String[] args) {
        MyThread t1 = new MyThread();
        t1.start();

        try {
            Thread.sleep(2500); // Let the thread run for a while
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        System.out.println("Main thread is interrupting " + t1.getName());
        t1.interrupt(); // Interrupt the thread
        
        /*
        Thread-0 started.
        Thread-0 is working: 1
        Thread-0 is working: 2
        Main thread is interrupting Thread-0
        Thread-0 caught InterruptedException.  
        */
    }
}
```

## **Thread Synchronization**

When multiple threads access shared resources, synchronization is needed.

<table data-header-hidden><thead><tr><th width="208"></th><th></th></tr></thead><tbody><tr><td><strong>Technique</strong></td><td><strong>Description</strong></td></tr><tr><td><code>synchronized</code></td><td>Prevents multiple threads from accessing critical sections.</td></tr><tr><td><code>lock</code></td><td>Uses <code>Lock</code> interface (<code>ReentrantLock</code>).</td></tr><tr><td><code>volatile</code></td><td>Ensures visibility of changes to variables across threads.</td></tr><tr><td><code>atomic</code></td><td>Uses classes like <code>AtomicInteger</code> to prevent race conditions.</td></tr></tbody></table>

**Example: Synchronized Block**

```java
class SharedResource {
    synchronized void printNumbers() {
        for (int i = 1; i <= 5; i++) {
            System.out.println(i);
        }
    }
}

public class SyncDemo {
    public static void main(String[] args) {
        SharedResource obj = new SharedResource();
        new Thread(obj::printNumbers).start();
        new Thread(obj::printNumbers).start();
    }
}
```

