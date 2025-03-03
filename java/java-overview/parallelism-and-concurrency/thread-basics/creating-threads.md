# Creating Threads

## About

In Java, threads can be created and managed using multiple approaches. Each approach has its use cases and trade-offs. Some of the approaches are given below.

## **1. Extending the `Thread` Class**

* The simplest way to create a thread is by extending the `Thread` class.
* The `run()` method is overridden to define the thread's behavior.
* A new thread is started using the `start()` method.

**Example:**

```java
public class MyThread extends Thread {
    @Override
    public void run() {
        System.out.println(Thread.currentThread().getName() + " Thread is running...");
    }
}

public class SomeMain {
    public static void main(String[] args) {
        MyThread thread = new MyThread();
        thread.start(); // Start the thread
        
        // Thread-0 Thread is running...
    }
}
```

**Limitations:**

* Java **does not support multiple inheritance**, so extending `Thread` prevents extending other classes.
* Better to use the `Runnable` interface if we need more flexibility.

## **2. Implementing the `Runnable` Interface**

* Instead of extending `Thread`, the `Runnable` interface can be implemented.
* The `run()` method is implemented inside the class.
* The thread is started using `Thread` class.

**Example:**

```java
public class MyRunnable implements Runnable {
    @Override
    public void run() {
        System.out.println(Thread.currentThread().getName() + " Thread is running...");
    }
}

public class RunnableExample {
    public static void main(String[] args) {
        Thread thread = new Thread(new MyRunnable());
        thread.start();
        // Thread-0 Thread is running...
    }
}
```

**Advantages:**

* Allows the class to **extend other classes** (unlike extending `Thread`).
* Encouraged in **multi-threaded environments** where tasks can be separated from threads.

## 3. Using `Callable` and `Future` (Return Value from Thread)

* The `Callable<T>` interface (from `java.util.concurrent`) allows a thread to return a result.
* The `Future<T>` interface is used to retrieve the result of the thread execution.

**Example:**

```java
import java.util.concurrent.Callable;

public class MyCallable implements Callable<String> {

    /**
     * Computes a result, or throws an exception if unable to do so.
     *
     * @return computed result
     * @throws Exception if unable to compute a result
     */
    @Override
    public String call() throws Exception {
        return Thread.currentThread().getName() + " Thread executed!";
    }
}
```

```java
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

public class CallableExample {
    public static void main(String[] args) throws Exception {
        ExecutorService executor = Executors.newSingleThreadExecutor();
        Future<String> future = executor.submit(new MyCallable());

        System.out.println(future.get()); // Retrieves the result
        executor.shutdown();
        
        // pool-1-thread-1 Thread executed!
    }
}
```

**Advantages:**

* Unlike `Runnable`, `Callable` allows returning values and throwing exceptions.

## 4. Using Anonymous Class

* Instead of defining a separate class, threads can be created using an anonymous class.

**Example:**

```java
public class AnonymousExample {
    public static void main(String[] args) {
        Thread thread = new Thread(new Runnable() {
            @Override
            public void run() {
                System.out.println(Thread.currentThread().getName() + " Thread is running...");
            }
        });
        thread.start();
        // Thread-0 Thread is running...
    }
}
```

**Use Case:**

* Useful for quick thread creation without creating separate classes.

## **5. Using Lambda Expressions (Java 8+)**

* Java 8 introduced lambda expressions, making it even more concise to create threads.

```java
public class AnonymousExample {
    // Using lambda expression
    public static void main(String[] args) {
        Thread thread = new Thread(() -> System.out.println(Thread.currentThread().getName() + " Thread is running..."));
        
        System.out.println(Thread.currentThread().getName() + " Current Thread is running...");
        thread.start();
        
        /* Output
        main Current Thread is running...
        Thread-0 Thread is running...
        */
    }
}
```

**Advantages:**

* **Reduces boilerplate code** for single-method interfaces like `Runnable`.

## 6. Using `ThreadPoolExecutor` (Efficient Thread Management)

* Instead of creating a new thread every time, **thread pools** reuse existing threads.
* `ThreadPoolExecutor` is a low-level API for managing thread pools.

**Example:**

```java
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class ThreadPoolExample {
    public static void main(String[] args) {
        ExecutorService executor = Executors.newFixedThreadPool(3);
        for (int i = 1; i <= 5; i++) {
            executor.execute(() -> System.out.println(Thread.currentThread().getName() + " is running"));
        }
        executor.shutdown();
        
        /* Output
        pool-1-thread-1 is running
        pool-1-thread-2 is running
        pool-1-thread-3 is running
        pool-1-thread-2 is running
        pool-1-thread-1 is running
        */
    }
}
```

**Advantages:**

* **Reduces overhead** of creating/destroying threads frequently.
* **Better resource management** for high-load applications.

## **7. Using `ForkJoinPool` (Parallel Computing)**

* The **Fork-Join framework** is useful for parallel computing by dividing tasks into smaller subtasks.

**Example:**

```java
package practice;

import java.util.concurrent.RecursiveTask;

public class MyRecursiveTask extends RecursiveTask<Integer> {

    private int num;

    MyRecursiveTask(int num) {
        this.num = num;
    }

    protected Integer compute() {
        if (num <= 1) {
            return num;
        }
        MyRecursiveTask task1 = new MyRecursiveTask(num - 1);
        MyRecursiveTask task2 = new MyRecursiveTask(num - 2);
        task1.fork();
        return task2.compute() + task1.join();
    }
}
```

```java
import java.util.concurrent.ForkJoinPool;

public class ForkJoinExample {

    public static void main(String[] args) {
        ForkJoinPool pool = new ForkJoinPool();
        System.out.println(pool.invoke(new MyRecursiveTask(5))); // 5
    }
}
```

**Use Case:**

* Suitable for **divide-and-conquer algorithms** like **parallel recursion** and **large dataset processing**.

## **8. Using `Virtual Threads` (Java 19+)**

* **Virtual Threads** (introduced in Java 19) allow lightweight, high-performance thread execution.
* Unlike OS threads, millions of virtual threads can be created without performance issues.

**Example:**

```java
public class VirtualThreadExample {
    public static void main(String[] args) {
        Thread.startVirtualThread(() -> System.out.println("Virtual thread running..."));
    }
}
```

**Advantages:**

* Extremely lightweight, **highly scalable**, and does not consume OS resources like traditional threads.
* Ideal for handling **highly concurrent workloads** efficiently.

## **Comparison of Thread Creation Methods**

<table data-full-width="true"><thead><tr><th width="287">Approach</th><th width="105">Flexibility</th><th width="131">Can Return Value?</th><th width="306">Suitable For</th><th>Complexity</th></tr></thead><tbody><tr><td>Extending <code>Thread</code></td><td>Low</td><td>No</td><td>Simple tasks</td><td>Low</td></tr><tr><td>Implementing <code>Runnable</code></td><td>Medium</td><td>No</td><td>Basic concurrency</td><td>Low</td></tr><tr><td>Using <code>Callable</code> &#x26; <code>Future</code></td><td>Medium</td><td>Yes</td><td>Background tasks needing results</td><td>Medium</td></tr><tr><td>Using Anonymous Class</td><td>Medium</td><td>No</td><td>Quick thread execution</td><td>Low</td></tr><tr><td>Using Lambda Expressions</td><td>Medium</td><td>No</td><td>Shorter syntax</td><td>Low</td></tr><tr><td>Using <code>ThreadPoolExecutor</code></td><td>High</td><td>No</td><td>Managing large tasks efficiently</td><td>Medium</td></tr><tr><td>Using <code>ForkJoinPool</code></td><td>High</td><td>Yes</td><td>Parallel processing, recursion</td><td>High</td></tr><tr><td>Using <code>Virtual Threads</code></td><td>High</td><td>No</td><td>Highly scalable concurrency</td><td>Low</td></tr></tbody></table>



## **Main Thread and New Thread Running Parallelly**

After creating a new thread, the **main thread** continues to execute **concurrently** (parallelly) with the newly created thread.

```java
public class MyThread extends Thread {

    @Override
    public void run() {
        for (int i = 1; i <= 5; i++) {
            System.out.println("Child Thread: " + i);
            try {
                Thread.sleep(500);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        }
    }
}
```



