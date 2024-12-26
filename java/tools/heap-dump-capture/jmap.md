# jmap

## About

`jmap` is a JDK utility used to generate heap dumps or analyze memory usage in a Java application. A heap dump is a snapshot of the JVM's memory, including all objects and references at a specific point in time. It is essential for diagnosing memory leaks, `OutOfMemoryError`, or high memory usage.

## **Key Use Cases**

* Diagnosing memory leaks by analyzing objects and their references.
* Understanding the distribution of objects in memory.
* Debugging `OutOfMemoryError` issues.

## **Steps to Use jmap on Mac**

### **1. Find the Process ID (PID):**

* Use the `jps` command to locate your Spring Boot app’s PID:

```bash
jps
```

Output example:

<figure><img src="../../../.gitbook/assets/jstack-1.png" alt="" width="369"><figcaption></figcaption></figure>

Start the Java Application (here it is sample-print-service maven springboot application)

<figure><img src="../../../.gitbook/assets/jstack-2.png" alt="" width="563"><figcaption></figcaption></figure>

`jps` command output is below

<figure><img src="../../../.gitbook/assets/jstack-3.png" alt="" width="375"><figcaption></figcaption></figure>

Here, `83322` is the PID of our Springboot app.

### **2. Capture a Heap Dump:**

* Run the following `jmap` command to generate a heap dump:

```bash
jmap -dump:format=b,file=heap-dump.hprof 83322
```

* `format=b`: Specifies the binary format for the dump file.
* `file=heap-dump.hprof`: Specifies the file name for the heap dump.
* The `heap-dump.hprof` file will be saved in the current directory.

<figure><img src="../../../.gitbook/assets/jmap-2.png" alt="" width="563"><figcaption></figcaption></figure>

{% file src="../../../.gitbook/assets/heap-dump.hprof" %}

### **3. Analyze the Heap Dump:**

* Use tools like **Eclipse MAT (Memory Analyzer Tool)** or **VisualVM** to open and analyze the `heap-dump.hprof` file.
  * Look for objects with high retention, large collections, or unreferenced objects.
  * Detect memory leaks by identifying objects that cannot be garbage collected.

{% hint style="info" %}
&#x20;We can get a summary of memory usage without creating a heap dump with jmap supported options
{% endhint %}
