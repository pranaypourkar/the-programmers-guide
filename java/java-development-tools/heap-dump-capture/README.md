# Heap Dump Capture

## About

A **heap dump** is a snapshot of a Java Virtual Machine's (JVM) heap memory at a given point in time.\
It contains all the live objects, their references, and memory usage details, enabling developers to analyze memory consumption patterns and pinpoint issues such as memory leaks, excessive object retention, and suboptimal data structures.\
Heap dumps are binary files and are typically analyzed using specialized tools to gain insight into the memory state of an application without affecting its normal operation too much.

## Importance of Heap Dump Capture

* **Memory Leak Detection**
  * Helps identify objects that are no longer needed but remain referenced, preventing garbage collection.
* **Analyzing Memory Consumption**
  * Breaks down memory usage by object type and instance count to find memory-hungry components.
* **Troubleshooting OutOfMemoryError**
  * Capturing a heap dump at the moment of failure reveals the root cause of excessive memory usage.
* **Performance Optimization**
  * Provides insights into object lifecycle and data structures to improve memory efficiency.
* **Post-Mortem Debugging**
  * Can be captured and analyzed after a crash to investigate the memory state at failure time.
* **Capacity Planning**
  * Assists in estimating required heap sizes and optimizing garbage collection tuning.

## When to Capture a Heap Dump ?

* **On OutOfMemoryError (OOM)**
  * The most common and critical moment to capture a heap dump.
  *   Configure the JVM with

      ```
      -XX:+HeapDumpOnOutOfMemoryError
      -XX:HeapDumpPath=<file-path>
      ```

      so the dump is generated automatically when memory runs out.
* **During Memory Leak Investigation**
  * Capture multiple heap dumps at intervals to compare and identify growing object sets that should have been garbage collected.
* **Before and After a High-Load Event**
  * Take a baseline heap dump before a load test and another after it to measure how memory usage changes.
* **When Memory Usage Appears Abnormally High**
  * If monitoring tools show heap usage staying near maximum for prolonged periods, a dump can help reveal why.
* **Post-Crash Analysis**
  * If an application crashes due to memory issues, capturing a heap dump right before or as it restarts can provide valuable state data.
* **While Debugging in Development**
  * Useful for validating object lifecycle, memory allocation patterns, and garbage collection behaviour during development.

## List of tools to help Capture Heap Dump

#### **1. JDK Command-Line Tools**

* **`jmap`** – Captures live heap dumps from a running JVM.
*   **`jcmd`** – More modern and flexible than `jmap`; supports heap dump generation with commands like:

    ```
    jcmd <pid> GC.heap_dump <file-path>
    ```

#### **2. Automatic JVM Options**

* **`-XX:+HeapDumpOnOutOfMemoryError`** – Automatically generates a heap dump when an `OutOfMemoryError` occurs.
* **`-XX:HeapDumpPath`** – Specifies where the dump file is stored.

#### **3. Visual & Interactive Tools**

* **JVisualVM** – GUI-based, supports triggering heap dumps remotely or locally.
* **Eclipse Memory Analyzer Tool (MAT)** – Primarily for analysis, but can also trigger dumps in some setups.
* **JConsole** – Provides a simple interface to request heap dumps via JMX.

#### **4. Application Performance Monitoring (APM) Tools**

* **YourKit**, **JProfiler**, **Java Flight Recorder (JFR)** – Allow live heap dump capture during profiling sessions.

#### **5. OS-Level / Cloud Platform Integration**

* **Kubernetes Debugging** – Using `kubectl exec` with `jmap` inside containers.
* **Cloud Vendor Tools** – AWS Elastic Beanstalk, GCP Operations, and Azure App Service often have built-in heap dump triggers.
