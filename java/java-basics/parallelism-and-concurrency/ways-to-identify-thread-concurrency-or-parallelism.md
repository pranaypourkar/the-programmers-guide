# Identify Thread Concurrency or Parallelism

## About

We can identify whether threads are running **concurrently** or **truly in parallel** by checking how they utilize CPU cores.

## 1. Check available CPU Cores

If our system has **only one CPU core**, then **all threads will execute concurrently (not parallelly)**. If there are multiple cores, they **may run in parallel** (depending on OS scheduling).

```java
public class CheckParallelism {
    public static void main(String[] args) {
        int cores = Runtime.getRuntime().availableProcessors();
        System.out.println("Available CPU Cores: " + cores);
    }
}
```

* **If output is `1`**, threads are only **concurrent**, never parallel.
* **If `>1`**, threads **can run in parallel**, but JVM/OS decides if they actually do.

## **2. Using Thread IDs and Time Logs**

Print the CPU core each thread is executing on.\
If **multiple threads have overlapping timestamps**, they might be running **in parallel**.

{% hint style="success" %}
* If thread start times overlap, they are likely running in parallel.
* If one starts after another ends, they are concurrent (time-shared execution).
{% endhint %}

```java
import java.util.stream.IntStream;

public class ParallelCheck {
    public static void main(String[] args) {
        Runnable task = () -> {
            long startTime = System.nanoTime();
            String threadName = Thread.currentThread().getName();
            System.out.println(threadName + " started at " + startTime);

            // Simulate work
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }

            long endTime = System.nanoTime();
            System.out.println(threadName + " ended at " + endTime);
        };

        // Running multiple threads
        IntStream.range(0, 4).forEach(i -> new Thread(task, "Thread-" + i).start());
        
        /* Output
        Thread-2 started at 319522341525708
        Thread-1 started at 319522341461416
        Thread-0 started at 319522341395291
        Thread-3 started at 319522341572875
        Thread-0 ended at 319523351164333
        Thread-1 ended at 319523353535916
        Thread-2 ended at 319523353920583
        Thread-3 ended at 319523353978083
        */
    }
}
```

## **3. Using `ForkJoinPool` for True Parallelism**

Java's **ForkJoinPool** allows us to enforce **parallel execution** by utilizing multiple CPU cores.

{% hint style="success" %}
If a system has only **one core**, then even when using **ForkJoinPool** or **parallel streams**, execution will still be **concurrent** and not truly **parallel**.
{% endhint %}

```java
import java.util.concurrent.ForkJoinPool;

public class ForkJoinParallelTest {
    public static void main(String[] args) {
        ForkJoinPool pool = new ForkJoinPool();  // Default uses all available cores
        
        // This prints the number of parallel worker threads the JVM is using.
        System.out.println("Parallelism Level: " + pool.getParallelism());
    }
}
```

## **4. Checking CPU Core Usage (OS Level)**

If we want a **real-time** check, run our Java program and **monitor CPU usage**:

* **Linux/macOS:** Run `htop` or `top` to see CPU usage per core.
* **Windows:** Open **Task Manager → Performance → CPU** and check core utilization.

{% hint style="success" %}
- If only one core is being used, it's just concurrent execution.
- If multiple cores are used, then true parallel execution is happening.
{% endhint %}

## **5. Using `jstack` to Capture Thread Dumps**

The `jstack` command can be used to capture a **thread dump** while our Java application is running. If multiple threads are in a **RUNNABLE** state at the same time, it indicates **potential parallel execution**.

{% hint style="success" %}
If multiple threads show **"RUNNABLE"**, they may be executing **in parallel**.
{% endhint %}

**Steps to Use**

1. Start our Java program with multiple threads.
2. Find the **Process ID (PID)**:
   * Linux/macOS: `ps -ef | grep java`
   * Windows: Use Task Manager or `jps`
3.  Run:

    ```sh
    jstack <PID> > thread_dump.txt
    ```
4. Open `thread_dump.txt` and look for multiple threads in **RUNNABLE** state.

## **6. Using `VisualVM` to Monitor Threads**

**VisualVM** is a profiling tool that can track thread states **visually** in real time.

**Steps to Use:**

1. Run `jvisualvm` (part of JDK).
2. Attach it to your running Java process.
3. Go to **"Threads" tab**.
4. Observe:
   * If multiple threads are active **at the same time**, they are likely **parallel**.
   * If only one thread runs while others wait, execution is **concurrent**.



