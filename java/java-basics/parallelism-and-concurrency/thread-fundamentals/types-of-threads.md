# Types of Threads

## About

Threads in Java can be broadly classified based on their behavior, execution priority, and use cases. Below is a comprehensive breakdown of the different types of threads, ranging from basic to advanced, along with examples.

## **Classification of Threads in Java**

Threads can be categorized as:

<table data-header-hidden data-full-width="true"><thead><tr><th width="303"></th><th></th></tr></thead><tbody><tr><td><strong>Thread Type</strong></td><td><strong>Description</strong></td></tr><tr><td><strong>User Thread</strong></td><td>Created explicitly by the developer and runs independently.</td></tr><tr><td><strong>Daemon Thread</strong></td><td>Background thread that supports user threads (e.g., Garbage Collector).</td></tr><tr><td><strong>Main Thread</strong></td><td>The primary thread that starts execution in a Java program.</td></tr><tr><td><strong>Single-threaded Execution</strong></td><td>Only one thread runs at a time.</td></tr><tr><td><strong>Multi-threaded Execution</strong></td><td>Multiple threads execute concurrently.</td></tr><tr><td><strong>Worker Thread</strong></td><td>Thread used for background tasks, often in thread pools.</td></tr><tr><td><strong>Event Dispatch Thread (EDT)</strong></td><td>Special thread in GUI applications like Swing for handling UI updates.</td></tr><tr><td><strong>Virtual Threads (JDK 19+)</strong></td><td>Lightweight threads (Project Loom) for high concurrency.</td></tr></tbody></table>

## **User Threads**

* These are **regular** threads created explicitly by the programmer.
* They **keep the JVM running** until all user threads finish execution.

```java
class UserThreadDemo extends Thread {
    public void run() {
        System.out.println("User Thread running: " + Thread.currentThread().getName());
    }

    public static void main(String[] args) {
        Thread t1 = new UserThreadDemo();
        t1.start();
    }
}
```

## **Daemon Threads**

* **Background** threads that serve other threads.
* JVM **terminates daemon threads** when all user threads complete.
* Example: **Garbage Collector, Timer threads, etc.**

```java
class DaemonThreadDemo extends Thread {
    public void run() {
        while (true) {
            System.out.println("Daemon thread running...");
            try { Thread.sleep(1000); } catch (InterruptedException ignored) {}
        }
    }

    public static void main(String[] args) throws InterruptedException {
        Thread daemon = new DaemonThreadDemo();
        daemon.setDaemon(true); // Must be set before start()
        daemon.start();
        Thread.sleep(3000); // Main thread sleeps, then exits
        System.out.println("Main thread exiting...");
    }
}
```

## **Main Thread**

* Every Java program starts with a **main thread**.
* The JVM automatically creates it and executes the `main()` method.

```java
public class MainThreadDemo {
    public static void main(String[] args) {
        System.out.println("Main thread name: " + Thread.currentThread().getName());
    }
}
```

## **Single-Threaded**

* One thread executes the entire program.
* Blocking calls (e.g., `Thread.sleep()`) halt execution.

```java
class SingleThreadDemo {
    public static void main(String[] args) {
        System.out.println("Task 1");
        System.out.println("Task 2");
    }
}
```

## **Multi-Threaded**

* Multiple threads execute simultaneously, reducing blocking.

```java
class MultiThreadDemo extends Thread {
    public void run() {
        System.out.println("Thread running: " + Thread.currentThread().getName());
    }

    public static void main(String[] args) {
        Thread t1 = new MultiThreadDemo();
        Thread t2 = new MultiThreadDemo();
        t1.start();
        t2.start();
    }
}
```

## **Worker Threads**

* Used in **thread pools** to perform background tasks.
* **Example:** Handling HTTP requests in a web server.

```java
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

class WorkerThread implements Runnable {
    private final int taskId;

    WorkerThread(int id) { this.taskId = id; }

    public void run() {
        System.out.println("Executing Task " + taskId + " on " + Thread.currentThread().getName());
    }
}

public class WorkerThreadDemo {
    public static void main(String[] args) {
        ExecutorService executor = Executors.newFixedThreadPool(2);
        for (int i = 1; i <= 5; i++) {
            executor.execute(new WorkerThread(i));
        }
        executor.shutdown();
    }
}
```

## **Event Dispatch Thread (EDT)**

* Used in **Swing GUI applications**.
* All UI updates must be performed on this thread.

```java
import javax.swing.*;

public class SwingDemo {
    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            JFrame frame = new JFrame("Swing UI");
            JButton button = new JButton("Click Me");
            frame.add(button);
            frame.setSize(200, 200);
            frame.setVisible(true);
        });
    }
}
```

## **Virtual Threads (JDK 19+)**

* Introduced in **Project Loom**.
* Unlike OS threads, they are **lightweight** and managed by the JVM.
* Used for **high-concurrency applications**.
* Virtual threads are **not tied to OS threads**.
* Provide **massive scalability** for applications

```java
Thread.startVirtualThread(() -> System.out.println("Virtual Thread running"));
```

