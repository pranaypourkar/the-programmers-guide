# Thread vs Process

## About

A **Thread** and a **Process** are fundamental concepts in concurrent programming. While both are units of execution, they differ in how they operate, their memory management, and how they communicate with each other.

## What is a Process?

A **Process** is an **independent instance of a running program**. It has its **own memory space, resources, and execution context**.

* **Created by the OS** when a program starts.
* **Has its own memory and resources**, separate from other processes.
* **Inter-process communication (IPC)** is required to share data between processes.
* **Slower context switching** due to separate memory spaces.
* **Multiple threads can exist within a process**.

{% hint style="success" %}
We can say that **a process is a group of threads** because:

1. **Every process has at least one thread** (the main thread).
2. **A process can contain multiple threads** that run concurrently.
3. **All threads within a process share the same memory and resources** (heap, file handles, etc.).
4. **A process provides isolation**, whereas threads within the process share execution context.

#### **Analogy:**

Think of a **process as a house**, and **threads as people inside the house**. The house (process) provides **shared resources** like a kitchen, living room, and utilities (memory, files, network connections). Each person (thread) can independently perform tasks but uses the common resources of the house.
{% endhint %}

#### **Example of a Process**

Every time we open a new application (e.g., a web browser, text editor), the OS creates a new process.

**Creating a Process using `ProcessBuilder`**

Java provides the `ProcessBuilder` class to create and manage OS-level processes.

{% hint style="info" %}
* **Starts a new process (Notepad)** independent of the Java program.
* **Does not share memory** with the Java application.
* **Process runs separately** from the Java program.
{% endhint %}

```java
import java.io.IOException;

public class ProcessExample {
    public static void main(String[] args) {
        ProcessBuilder processBuilder = new ProcessBuilder("notepad.exe"); // Launches Notepad
        try {
            Process process = processBuilder.start();
            System.out.println("Notepad started with Process ID: " + process.pid());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

## What is a Thread?

A **Thread** is a **lightweight unit of execution within a process**.

* **Shares memory with other threads** of the same process.
* **Faster than processes** because threads share resources.
* **Used for parallel execution within a program**.
* **Context switching is faster** compared to processes.

#### **Example of a Thread**

A browser **process** can have multiple threads handling different tasks, such as:

* One thread for rendering web pages.
* Another thread for downloading files.
* Another thread for user interactions.

**Creating a Thread using `Thread` Class**

{% hint style="info" %}
* **Threads run in parallel** within the same Java process.
* **They share memory and resources**.
* **Lighter than creating a new process**.
{% endhint %}

```java
class MyThread extends Thread {
    public void run() {
        System.out.println("Thread " + Thread.currentThread().getId() + " is running.");
    }
}

public class ThreadExample {
    public static void main(String[] args) {
        MyThread t1 = new MyThread();
        MyThread t2 = new MyThread();

        t1.start();
        t2.start();
    }
}
```
