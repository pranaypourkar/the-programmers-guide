# Thread Priority

## About

Thread priority in Java determines the order in which threads are scheduled for execution. However, it **does not guarantee exact execution sequence**—it is just a hint to the thread scheduler.

{% hint style="info" %}
* **High-priority threads** might execute **before low-priority threads**, but **not always guaranteed**.
* **OS-dependent behavior**: Some JVMs may completely ignore priority settings.
{% endhint %}

## **Thread Priority Levels**

Java defines **three standard priority constants** in the `Thread` class:

| **Constant**           | **Value** | **Description**  |
| ---------------------- | --------- | ---------------- |
| `Thread.MIN_PRIORITY`  | `1`       | Lowest priority  |
| `Thread.NORM_PRIORITY` | `5`       | Default priority |
| `Thread.MAX_PRIORITY`  | `10`      | Highest priority |

## **Thread Priority Effects**

<table data-header-hidden><thead><tr><th width="229"></th><th></th></tr></thead><tbody><tr><td><strong>Priority Level</strong></td><td><strong>Effect</strong></td></tr><tr><td><strong>Low (1-4)</strong></td><td>Less CPU time, runs after high-priority threads.</td></tr><tr><td><strong>Normal (5-9)</strong></td><td>Balanced execution.</td></tr><tr><td><strong>High (10)</strong></td><td>May get more CPU time, but not guaranteed.</td></tr></tbody></table>

## **Setting Thread Priority**

We can set a thread's priority using:

```java
thread.setPriority(somePriorityValue);
```

And retrieve it using:

```java
int p = thread.getPriority();
```

## **Default Thread Priority**

* The **main thread** has a default priority of `5` (`NORM_PRIORITY`).
* A newly created thread **inherits the priority** of the thread that created it.

```java
public class DefaultPriorityDemo {
    public static void main(String[] args) {
        System.out.println("Main thread priority: " + Thread.currentThread().getPriority());

        Thread t = new Thread(() -> System.out.println("New thread priority: " + Thread.currentThread().getPriority()));
        t.start();
    }
}
```

**Output (default JVM behavior):**

```
Main thread priority: 5
New thread priority: 5
```

## **Setting and Getting Thread Priority**

```java
class PriorityDemo extends Thread {
    public void run() {
        System.out.println("Thread Name: " + Thread.currentThread().getName() +
                ", Priority: " + Thread.currentThread().getPriority());
    }

    public static void main(String[] args) {
        PriorityDemo t1 = new PriorityDemo();
        PriorityDemo t2 = new PriorityDemo();
        PriorityDemo t3 = new PriorityDemo();

        t1.setPriority(Thread.MIN_PRIORITY);  // 1
        t2.setPriority(Thread.NORM_PRIORITY); // 5 (default)
        t3.setPriority(Thread.MAX_PRIORITY);  // 10

        t1.start();
        t2.start();
        t3.start();
    }
}
```

**Possible Output (varies based on OS & JVM scheduler):**

```
Thread Name: Thread-2, Priority: 10
Thread Name: Thread-1, Priority: 5
Thread Name: Thread-0, Priority: 1
```

## **Priority May Not Always Work**

Even if a thread has `MAX_PRIORITY`, the JVM **does not guarantee** execution order.

```java
for (int i = 0; i < 5; i++) {
    Thread high = new Thread(() -> System.out.println("High Priority"));
    Thread low = new Thread(() -> System.out.println("Low Priority"));

    high.setPriority(Thread.MAX_PRIORITY);
    low.setPriority(Thread.MIN_PRIORITY);

    low.start();
    high.start();
}
```

**Expected vs. Actual Output**

```
High Priority
Low Priority
Low Priority
High Priority
High Priority
Low Priority
Low Priority
High Priority
```

Threads do **not always** run in expected order.

## Usage of Thread Priorities

A payment processing thread gets higher priority than a logging thread.
