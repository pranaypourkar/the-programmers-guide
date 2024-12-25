# Thread Dump

## About

A **thread dump** is a snapshot of all the threads running in a Java Virtual Machine (JVM) at a specific point in time. It provides details about each thread, including:

* Thread state (e.g., RUNNABLE, BLOCKED, WAITING, TIMED\_WAITING)
* Stack traces of what the threads are currently executing
* Synchronization locks held by threads (if any)

## Why is it Useful?

* **Performance bottlenecks**: Helps in diagnosing high CPU usage or thread contention issues.
* **Deadlocks**: Identifies if any threads are stuck waiting for locks.
* **Thread states**: Understand the distribution of thread states and their current activities.

## When to Capture a Thread Dump?

* When the application is **not responding** (e.g., "hanging").
* During high CPU usage.
* When investigating **concurrent programming issues** like deadlocks.

## How to Generate a Thread Dump?

### **Using JDK Tools:**

* `jstack <pid>`: Captures a thread dump of the application.
* `jcmd <pid> Thread.print`: Another way to generate a thread dump.

### **Using IDEs or Tools:**

* Tools like VisualVM, JConsole, or IntelliJ IDEA can capture thread dumps.

### **Command Line Signal (Linux/Unix):**

* `kill -3 <pid>`: Sends a `SIGQUIT` signal to generate a thread dump, which will appear in the standard output (e.g., logs).

## Example Output (Snippet):

```plaintext
"main" #1 prio=5 os_prio=0 tid=0x00007f93c4008000 nid=0x1 waiting on condition [0x00007f93c4a4f000]
   java.lang.Thread.State: WAITING (on object monitor)
        at java.lang.Object.wait(Native Method)
        at java.lang.Thread.join(Thread.java:1252)
        - locked <0x00000000c1020000> (a java.lang.Thread)
```

## How to Analyze a Thread Dump?

* Look for **threads in BLOCKED state**: These are waiting for locks and might indicate contention.
* Look for **deadlocks**: Deadlocks will be explicitly identified in most thread dumps.
* Analyze thread states: A high number of threads in `WAITING` or `BLOCKED` states may indicate issues.
