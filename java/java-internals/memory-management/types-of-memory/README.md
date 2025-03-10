# Types of Memory

## About

The Java Virtual Machine (JVM) memory structure plays a crucial role in the performance and execution of Java applications. JVM memory is divided into different regions, each serving a specific purpose. Understanding these memory areas is essential for debugging memory leaks, optimizing performance, and configuring JVM memory settings effectively.

JVM memory is broadly categorized into two types:

1. **Heap Memory** → Stores objects and class instances.
2. **Non-Heap Memory** → Stores metadata, method area, and thread-related structures.

Each of these is further divided into sub-regions. Here’s a high-level breakdown:

<table><thead><tr><th width="189">Memory Type</th><th>Purpose</th></tr></thead><tbody><tr><td><strong>Heap Memory</strong></td><td>Stores Java objects and dynamically allocated data</td></tr><tr><td><strong>Stack Memory</strong></td><td>Stores method call frames, local variables, and execution state</td></tr><tr><td><strong>Metaspace</strong></td><td>Stores class metadata and method definitions (Java 8+)</td></tr><tr><td><strong>Code Cache</strong></td><td>Stores JIT-compiled code for optimized execution</td></tr><tr><td><strong>Native Memory</strong></td><td>Memory allocated outside JVM, used by OS, JNI, and threads</td></tr></tbody></table>

## **1. Heap Memory**

* The largest memory area in JVM, used for storing objects and class instances.
* Divided into Young Generation (Eden, Survivor Spaces) and Old Generation (Tenured Space).
* Garbage Collection (GC) periodically removes unused objects.
* Objects with longer lifetimes eventually move to the Old Generation.
* Memory issues like OutOfMemoryError: Java heap space occur if the heap is exhausted.

### **2. Stack Memory**

* Stores method call stack frames, including local variables and method execution data.
* Each thread has its own stack, ensuring thread isolation.
* Memory is allocated and deallocated automatically as methods are called and return.
* Limited in size, causing StackOverflowError when exceeded (e.g., deep recursion).

### **3. Metaspace** (Replaced PermGen in Java 8)

* Stores class metadata, method definitions, and runtime constant pools.
* Unlike PermGen, Metaspace resides in native memory and can dynamically grow.
* Memory issues may result in OutOfMemoryError: Metaspace if it reaches the system limit.
* Controlled using `-XX:MetaspaceSize` and `-XX:MaxMetaspaceSize` JVM flags.

### **4. Code Cache**

* Stores JIT-compiled native code to improve execution performance.
* Reduces the need to repeatedly interpret Java bytecode.
* Optimized by JVM to ensure efficient execution of frequently used code paths.

### **5. Native Memory**

* Memory allocated outside the JVM heap, used by JNI (Java Native Interface) and direct byte buffers.
* Managed by the operating system rather than the JVM.
* Excessive native memory usage can lead to system-level OutOfMemoryError.

## Percentage Allocation of JVM Memory Types

The percentage of total memory allocated to each JVM memory type depends on the JVM implementation, configuration, and runtime workload. However, typical allocations follow these general guidelines.

<table data-full-width="true"><thead><tr><th width="168">Memory Type</th><th width="163">Approximate Allocation (%)</th><th>Description</th></tr></thead><tbody><tr><td><strong>Heap Memory</strong></td><td><strong>50% - 80%</strong></td><td>The largest portion of JVM memory. Used for object storage and garbage collection. The exact size is controlled using <code>-Xms</code> (initial size) and <code>-Xmx</code> (maximum size).</td></tr><tr><td><strong>Stack Memory</strong></td><td><strong>1% - 10%</strong> per thread</td><td>Small but critical. Stores method call stacks, local variables, and function execution details. Size can be adjusted using <code>-Xss</code>.</td></tr><tr><td><strong>Metaspace</strong></td><td><strong>5% - 20%</strong></td><td>Stores class metadata, method data, and runtime constant pools. Unlike the old PermGen, it grows dynamically. Controlled with <code>-XX:MetaspaceSize</code> and <code>-XX:MaxMetaspaceSize</code>.</td></tr><tr><td><strong>Code Cache</strong></td><td><strong>5% - 15%</strong></td><td>Stores compiled JIT code for optimized execution. Can be tuned using <code>-XX:ReservedCodeCacheSize</code>.</td></tr><tr><td><strong>Native Memory</strong></td><td><strong>Varies (10% - 30%)</strong></td><td>Used by JNI, direct buffers, thread stacks, and OS-level memory allocations. Typically not directly managed by JVM but can impact overall system performance.</td></tr></tbody></table>

* The heap takes the **largest** portion as it stores most runtime objects.
* The stack is relatively **small per thread** but scales with the number of active threads.
* Metaspace usage depends on the **number of loaded classes** and can grow dynamically.
* Code Cache benefits **JIT-compiled** code and varies based on execution patterns.
* Native Memory usage depends on **external libraries, threads, and OS interactions**.

These allocations can be adjusted using JVM options to optimize performance based on the application's needs.

## **JVM Memory Allocation in a Spring Boot Service**

Let's consider a Spring Boot microservice running in an OpenShift pod with the following JVM memory configuration -

* **Total available memory for the container:** `2 GB`
* **JVM Heap Size (`-Xmx`):** `1 GB`
* **JVM Initial Heap Size (`-Xms`):** `512 MB`
* **Stack Size (`-Xss`):** `512 KB per thread`
* **Metaspace Size (`-XX:MaxMetaspaceSize`):** `256 MB`
* **Code Cache Size (`-XX:ReservedCodeCacheSize`):** `128 MB`

**Estimated Memory Breakdown**

<table data-header-hidden><thead><tr><th width="176"></th><th width="489"></th><th></th></tr></thead><tbody><tr><td><strong>Memory Type</strong></td><td><strong>Size Allocation</strong></td><td><strong>Percentage (%)</strong></td></tr><tr><td><strong>Heap Memory</strong></td><td><code>1024 MB (1 GB)</code></td><td><strong>50%</strong></td></tr><tr><td><strong>Stack Memory</strong></td><td><code>128 MB (for ~256 threads)</code></td><td><strong>6%</strong></td></tr><tr><td><strong>Metaspace</strong></td><td><code>256 MB</code></td><td><strong>12%</strong></td></tr><tr><td><strong>Code Cache</strong></td><td><code>128 MB</code></td><td><strong>6%</strong></td></tr><tr><td><strong>Native Memory</strong></td><td><code>512 MB (remaining for OS, buffers, JNI, etc.)</code></td><td><strong>25%</strong></td></tr></tbody></table>

1. **Heap Memory (`1 GB`)**
   * Used for storing objects created by the Spring Boot application, such as controllers, service beans, repository objects, and caches.
   * Garbage Collection (GC) will periodically reclaim unused objects.
2. **Stack Memory (`~128 MB` for multiple threads)**
   * Each thread gets a **fixed** stack size (`512 KB` per thread).
   * A Spring Boot app handling concurrent requests may spawn **\~256 threads**, requiring around `128 MB` total.
   * More threads can increase stack memory usage, potentially leading to **OutOfMemoryError: unable to create new native thread**.
3. **Metaspace (`256 MB`)**
   * Stores class metadata, including Spring Boot's dynamic class generation (Proxies, Hibernate entities, etc.).
   * Since Spring Boot loads many classes dynamically, a larger **Metaspace** allocation helps avoid `OutOfMemoryError: Metaspace`.
4. **Code Cache (`128 MB`)**
   * Stores **JIT-compiled methods** to speed up execution.
   * If insufficient, JIT optimizations may suffer, leading to **slower application performance**.
5. **Native Memory (`512 MB`)**
   * Required for OS-level functions, **thread management, buffers, socket connections, and JNI (e.g., database drivers, native libraries like Netty for networking)**.
   * If the pod runs multiple services or threads, native memory usage will be higher.

**Considerations for OpenShift Perspective**

* OpenShift enforces **memory limits** at the container level. If the JVM exceeds the limit, **OOMKilled** events occur.
* Tuning **Garbage Collection (G1GC, ZGC)** can help balance heap allocation and GC overhead.
* Kubernetes/OpenShift **resource requests and limits** should be properly defined (`requests.memory`, `limits.memory`).
* Using **`-XX:MaxRAMPercentage=75`** allows the JVM to adapt heap size dynamically based on available pod memory.

## Commonly Configured JVM Memory Parameters

In a containerized environment like OpenShift, not all JVM memory settings are explicitly configured. Many are left to default values or dynamically managed based on the container's available memory. However, some key parameters are frequently set to control memory usage and avoid OutOfMemoryError (OOM) or excessive garbage collection.

### **1. Commonly Configured JVM Memory Parameters**

<table data-header-hidden data-full-width="true"><thead><tr><th width="248"></th><th width="286"></th><th></th></tr></thead><tbody><tr><td><strong>Parameter</strong></td><td><strong>Description</strong></td><td><strong>Common Usage in OpenShift</strong></td></tr><tr><td><code>-Xmx</code> (Max Heap)</td><td>Defines the <strong>maximum</strong> heap size</td><td>Set to <strong>50-75%</strong> of the container’s memory (<code>-Xmx512m</code>for 1GB pod)</td></tr><tr><td><code>-Xms</code> (Initial Heap)</td><td>Defines the <strong>initial</strong> heap size</td><td>Usually <strong>same as <code>-Xmx</code></strong> to avoid heap resizing overhead</td></tr><tr><td><code>-Xss</code> (Thread Stack Size)</td><td>Defines the memory per thread stack</td><td>Typically <strong>512 KB - 1 MB</strong> per thread (<code>-Xss512k</code>)</td></tr><tr><td><code>-XX:MetaspaceSize</code></td><td>Initial size for Metaspace</td><td>Usually <strong>128MB - 256MB</strong>, auto-expands if needed</td></tr><tr><td><code>-XX:MaxMetaspaceSize</code></td><td>Maximum Metaspace limit</td><td><strong>Not always set</strong>, but useful to prevent unbounded growth</td></tr><tr><td><code>-XX:ReservedCodeCacheSize</code></td><td>JIT Code Cache Size</td><td>Defaults to <strong>240MB</strong>, may be tuned for high-performance apps</td></tr><tr><td><code>-XX:MaxRAMPercentage</code></td><td>Allows JVM to allocate heap as a % of container memory</td><td><strong>Preferred over <code>-Xmx</code></strong> in containers (e.g., <code>-XX:MaxRAMPercentage=75</code>)</td></tr><tr><td><code>-XX:+UseContainerSupport</code></td><td>Enables JVM to respect container limits</td><td><strong>Enabled by default in Java 10+</strong> (No need to set manually)</td></tr><tr><td><code>-XX:+HeapDumpOnOutOfMemoryError</code></td><td>Dumps heap memory on OOM for debugging</td><td>Often enabled for production (<code>-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/tmp/dump.hprof</code>)</td></tr><tr><td><code>-Duser.timezone=UTC</code></td><td>Ensures timezone consistency across containers</td><td>Common for global deployments</td></tr></tbody></table>

### **2. Less Commonly Set (But Useful in Specific Cases)**

<table data-header-hidden data-full-width="true"><thead><tr><th width="388"></th><th></th></tr></thead><tbody><tr><td><strong>Parameter</strong></td><td><strong>When to Use It?</strong></td></tr><tr><td><code>-XX:+UseG1GC</code></td><td>Default GC for Java 9+, good for moderate heap sizes (1GB-4GB)</td></tr><tr><td><code>-XX:+UseZGC</code></td><td>For <strong>low-latency applications</strong>, needs Java 11+</td></tr><tr><td><code>-XX:NewRatio=2</code></td><td>Controls Eden:Old ratio (useful for tuning young gen collection)</td></tr><tr><td><code>-XX:SurvivorRatio=8</code></td><td>Fine-tunes object survival rate before promotion to Old Gen</td></tr><tr><td><code>-XX:+ExitOnOutOfMemoryError</code></td><td>Ensures pod restart on OOM, instead of getting stuck</td></tr><tr><td><code>-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap</code></td><td><strong>Java 8</strong> workaround to respect container memory limits</td></tr></tbody></table>

### **3. Which Parameters Are Typically Left as Default?**

* **Code Cache (`-XX:ReservedCodeCacheSize`)** → JVM manages it well unless JIT optimizations are required
* **Native Memory (OS-level allocations)** → JVM handles it dynamically
* **Garbage Collector (`-XX:+UseG1GC` or default GC)** → Unless tuning for low-latency, JVM defaults are good

### **4. Example Configuration for OpenShift (1GB Memory Pod)**

{% code overflow="wrap" %}
```sh
JAVA_OPTS="-XX:MaxRAMPercentage=75 -XX:MetaspaceSize=128m -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/tmp/dump.hprof -Duser.timezone=UTC"
```
{% endcode %}

or

{% code overflow="wrap" %}
```sh
JAVA_OPTS="-Xms512m -Xmx750m -Xss512k -XX:+UseG1GC -XX:MetaspaceSize=128m -XX:+HeapDumpOnOutOfMemoryError"
```
{% endcode %}





