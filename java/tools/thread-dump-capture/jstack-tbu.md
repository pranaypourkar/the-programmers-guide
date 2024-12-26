# jstack - TBU

## About

`jstack` is a JDK utility used to generate thread dumps of a Java process. A thread dump contains a snapshot of all the threads running in the Java Virtual Machine (JVM) at a given time. It is useful for diagnosing issues like deadlocks, high CPU usage, thread contention, or long-running threads.

## **Key Use Cases**

* Identifying thread contention and deadlocks.
* Debugging threads stuck in infinite loops or blocking states.
* Understanding CPU-bound threads or hung processes.

## **Steps to Use jstack on Mac**

1. **Find the Process ID (PID):**
   *   Open the terminal and use the `jps` command to list all Java processes:

       ```bash
       bashCopy codejps
       ```

       Output example:

       ```
       Copy code23456 MySpringBootApp
       23457 Jps
       ```

       Here, `23456` is the PID of your Spring Boot app.
2. **Generate a Thread Dump:**
   *   Run the `jstack` command with the PID to generate a thread dump:

       ```bash
       bashCopy codejstack 23456 > thread-dump.txt
       ```

       This saves the thread dump to a file named `thread-dump.txt` in the current directory.
3. **Analyze the Thread Dump:**
   * Open the `thread-dump.txt` file and look for:
     * `BLOCKED` or `WAITING` states indicating thread contention.
     * Deadlock information, which is explicitly mentioned if detected.
     * Long-running threads consuming resources.
