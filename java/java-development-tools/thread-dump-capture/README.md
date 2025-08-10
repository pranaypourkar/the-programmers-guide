# Thread Dump Capture

## About

A **thread dump** is a snapshot of all the threads that are currently running in a Java Virtual Machine (JVM), along with their stack traces and states. It provides detailed information about what each thread is doing at the moment of capture whether it’s running, waiting, blocked, or sleeping.

Capturing a thread dump is one of the most effective ways to diagnose **performance bottlenecks, deadlocks, high CPU usage, and unexpected application hangs** in Java applications.

A thread dump is **read-only diagnostic data**, meaning it does not affect the running state of the application it simply reveals what’s happening internally at a given moment.

## Importance of Thread Dump Capture

* **Deadlock Detection**
  * Helps identify situations where threads are stuck waiting for each other, preventing further progress.
* **Performance Troubleshooting**
  * Pinpoints slow methods, blocking operations, and excessive synchronization.
* **High CPU Usage Investigation**
  * Shows which threads are consuming CPU cycles and what code they are executing.
* **Application Hang Analysis**
  * Identifies threads stuck in I/O operations, long waits, or infinite loops.
* **Baseline and Benchmarking**
  * Used to compare application behavior under different load conditions.

## When to Capture a Thread Dump ?

* The application becomes unresponsive.
* High CPU or memory usage is observed.
* Deadlocks or thread contention is suspected.
* During load testing to monitor concurrency issues.
* As part of routine diagnostics for production incidents.

## List of tools to help Capture Thread Dump

#### **1. JDK Command-Line Utilities**

* **jstack** – Captures a thread dump for a given JVM process ID.
* **jcmd** – More versatile; can capture thread dumps, heap info, GC data, etc.
* **jmap** – Primarily for heap dumps, but can sometimes provide thread-related info.
* **kill -3** _(Unix/Linux)_ – Sends `SIGQUIT` to the JVM to trigger a thread dump to stdout.
* **Ctrl + Break** _(Windows console)_ – Prints thread dump to console for console-launched apps.

#### **2. JDK GUI Tools**

* **JConsole** – Can connect to a JVM and generate thread dumps from the _Threads_ tab.
* **VisualVM** – Allows capturing and analyzing thread dumps interactively.

#### **3. Third-Party Profilers / Monitoring Tools**

* **YourKit Java Profiler** – Advanced dump capture and analysis features.
* **JProfiler** – Integrates with JVM to capture thread dumps on-demand.
* **Eclipse MAT (Memory Analyzer Tool)** – Primarily for heap dumps but can integrate with thread analysis.

#### **4. Cloud & Application Monitoring Platforms**

* **New Relic**, **AppDynamics**, **Dynatrace** – Offer remote JVM thread dump capture for monitored applications.
* **Spring Boot Actuator** (with `/threaddump` endpoint) – Exposes thread dump over HTTP for Spring Boot apps.

#### **5. Analysis-Focused Tools** _(for post-capture reading)_

* **TDA (Thread Dump Analyzer)** – Free tool for parsing and grouping threads by state.
* **fastThread.io** – Online tool for thread dump analysis with deadlock detection.
