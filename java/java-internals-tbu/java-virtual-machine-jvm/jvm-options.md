# JVM Options

## About

JVM (Java Virtual Machine) **options** are command-line arguments that modify the behavior of the JVM at runtime. They control memory management, garbage collection, performance tuning, debugging, and container-aware settings.

JVM options are passed when starting a Java application like this:

```sh
java [JVM_OPTIONS] -jar myapp.jar
```

For example:

```sh
java -Xms512m -Xmx1024m -XX:+UseG1GC -jar myapp.jar
```



**Types of JVM Options**

JVM options are classified into following categories:

## **1. Standard Options (`-option`)**

These Options are supported across all Java versions. They are mostly for general settings like classpath and debugging.

| **Option**            | **Description**                          |
| --------------------- | ---------------------------------------- |
| `-version`            | Prints Java version and exits.           |
| `-classpath` or `-cp` | Specifies where to look for class files. |
| `-Dproperty=value`    | Sets system properties.                  |
| `-jar myapp.jar`      | Runs a JAR file.                         |
| `-verbose`            | Prints debugging information.            |

**Example:**

```sh
java -Denv=production -jar myapp.jar
```

This sets a system property `env=production` that can be accessed in Java via:

```java
System.getProperty("env");
```

## **2. Non-Standard Options (`-Xoption`)**

Non-standard JVM options (`-X` options) are JVM-specific and may vary across different Java versions and JVM implementations (e.g., Oracle HotSpot, OpenJDK, GraalVM). These options are **not guaranteed** to remain consistent across JVM versions.

### **2.1 Memory Management Options**

These options control the **heap, stack, and garbage collection memory allocation**.

<table data-header-hidden data-full-width="true"><thead><tr><th width="162"></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Option</strong></td><td><strong>Description</strong></td><td><strong>Examples</strong></td></tr><tr><td><code>-Xms&#x3C;size></code></td><td>Sets the <strong>initial heap size</strong> when JVM starts.</td><td><code>-Xms512m</code> → 512MB initial heap. <br><code>-Xms1g</code> → 1GB initial heap.</td></tr><tr><td><code>-Xmx&#x3C;size></code></td><td>Sets the <strong>maximum heap size</strong> that JVM can use.</td><td><code>-Xmx2g</code> → Max heap = 2GB. <br><code>-Xmx4g</code> → Max heap = 4GB.</td></tr><tr><td><code>-Xmn&#x3C;size></code></td><td>Sets <strong>Young Generation (Eden + Survivor spaces)</strong> size.</td><td><code>-Xmn512m</code> → 512MB for Young Gen. <br><code>-Xmn2g</code> → 2GB for Young Gen.</td></tr><tr><td><code>-Xss&#x3C;size></code></td><td>Sets <strong>stack size per thread</strong>, affecting recursion depth.</td><td><code>-Xss256k</code> → 256KB per thread. <br><code>-Xss1m</code> → 1MB per thread.</td></tr><tr><td><code>-Xnoclassgc</code></td><td><strong>Disables class unloading</strong>, preventing JVM from reclaiming memory from unused classes.</td><td><code>-Xnoclassgc</code> (Prevents unloading classes, useful for long-running apps).</td></tr></tbody></table>

#### **Use Cases:**

* **High-performance apps** → Use `-Xms` = `-Xmx` to prevent heap resizing overhead.
* **Deep recursion (e.g., parsers, AI algorithms)** → Increase `-Xss` to avoid `StackOverflowError`.
* **Memory-intensive workloads** → Tune `-Xmn` for GC efficiency.

### **2.2 Garbage Collection (GC) Tuning Options**

These options optimize **garbage collection algorithms and behavior**.

<table data-header-hidden data-full-width="true"><thead><tr><th width="278"></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Option</strong></td><td><strong>Description</strong></td><td><strong>Examples</strong></td></tr><tr><td><code>-Xloggc:&#x3C;file></code></td><td>Logs <strong>GC events and pauses</strong> to a file.</td><td><code>-Xloggc:/var/logs/gc.log</code></td></tr><tr><td><code>-XX:+PrintGC</code></td><td>Prints <strong>basic GC info</strong> to console.</td><td><code>-XX:+PrintGC</code> (Shows minor/major GC events).</td></tr><tr><td><code>-XX:+PrintGCDetails</code></td><td>Prints <strong>detailed GC logs</strong>, including memory usage before/after collection.</td><td><code>-XX:+PrintGCDetails</code></td></tr><tr><td><code>-XX:+PrintGCTimeStamps</code></td><td>Adds <strong>timestamps</strong> to GC logs.</td><td><code>-XX:+PrintGCTimeStamps</code></td></tr><tr><td><code>-XX:+UseG1GC</code></td><td>Uses <strong>G1 Garbage Collector</strong> (default in Java 9+).</td><td><code>-XX:+UseG1GC</code></td></tr><tr><td><code>-XX:+UseParallelGC</code></td><td>Enables <strong>Parallel GC</strong>, useful for <strong>multi-core CPUs</strong>.</td><td><code>-XX:+UseParallelGC</code></td></tr><tr><td><code>-XX:+UseShenandoahGC</code></td><td>Enables <strong>Shenandoah GC</strong>, a low-pause GC.</td><td><code>-XX:+UseShenandoahGC</code></td></tr></tbody></table>

#### **Use Cases:**

* **Large memory apps** (4GB+) → Use `-XX:+UseG1GC` for predictable pause times.
* **Multi-threaded apps** → Use `-XX:+UseParallelGC` to leverage CPU cores.
* **Low-latency apps** (e.g., trading systems) → Use `-XX:+UseShenandoahGC`.

### **2.3 Class Loading & Verification**

These options affect **how Java loads and verifies classes**.

<table data-header-hidden data-full-width="true"><thead><tr><th width="207"></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Option</strong></td><td><strong>Description</strong></td><td><strong>Examples</strong></td></tr><tr><td><code>-Xverify:none</code></td><td>Disables <strong>bytecode verification</strong>, reducing startup time.</td><td><code>-Xverify:none</code> (Skips class verification, useful for trusted codebases).</td></tr><tr><td><code>-Xnoclassgc</code></td><td>Prevents <strong>class unloading</strong> from memory.</td><td><code>-Xnoclassgc</code> (Useful for <strong>long-lived apps</strong>).</td></tr><tr><td><code>-Xbootclasspath:&#x3C;path></code></td><td>Specifies <strong>bootstrap classpath</strong> (higher priority than app classpath).</td><td><code>-Xbootclasspath:/libs/custom.jar</code></td></tr><tr><td><code>-Xfuture</code></td><td>Enables <strong>strict bytecode verification</strong>.</td><td><code>-Xfuture</code> (Forcing strict checks on old bytecode).</td></tr></tbody></table>

#### **Use Cases:**

* **Faster startup** → `-Xverify:none` is useful for microservices.
* **Custom JVM environments** → `-Xbootclasspath` for overriding standard libraries.

### **2.4 Performance & Compilation Options**

These options optimize **Just-In-Time (JIT) compilation and execution speed**.

<table data-header-hidden data-full-width="true"><thead><tr><th width="163"></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Option</strong></td><td><strong>Description</strong></td><td><strong>Examples</strong></td></tr><tr><td><code>-Xbatch</code></td><td>Forces <strong>compilation in the foreground</strong> (instead of background).</td><td><code>-Xbatch</code> (Useful for benchmarking).</td></tr><tr><td><code>-Xcomp</code></td><td><strong>Compiles all methods</strong> at startup using JIT.</td><td><code>-Xcomp</code> (May increase startup time but speeds up execution).</td></tr><tr><td><code>-Xint</code></td><td>Runs in <strong>interpreter-only mode</strong>, disabling JIT.</td><td><code>-Xint</code> (Slower execution, useful for debugging).</td></tr><tr><td><code>-Xmixed</code></td><td>Uses <strong>both interpreted and JIT</strong> execution (default mode).</td><td><code>-Xmixed</code> (Balances startup and execution speed).</td></tr></tbody></table>

#### **Use Cases:**

* **JIT tuning** → Use `-Xcomp` for optimizing CPU-bound applications.
* **Debugging** → `-Xint` ensures **consistent behavior** without optimizations.

### **2.5 Debugging & Troubleshooting**

These options help diagnose **JVM crashes, memory leaks, and performance issues**.

<table data-header-hidden data-full-width="true"><thead><tr><th width="279"></th><th width="276"></th><th></th></tr></thead><tbody><tr><td><strong>Option</strong></td><td><strong>Description</strong></td><td><strong>Examples</strong></td></tr><tr><td><code>-Xdebug</code></td><td>Enables <strong>debugging mode</strong>(deprecated in Java 9+).</td><td><code>-Xdebug</code></td></tr><tr><td><code>-Xrunjdwp:&#x3C;options></code></td><td>Enables <strong>remote debugging</strong>via JDWP.</td><td><code>-Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005</code></td></tr><tr><td><code>-XX:+HeapDumpOnOutOfMemoryError</code></td><td>Dumps heap to analyze <strong>memory leaks</strong>.</td><td><code>-XX:+HeapDumpOnOutOfMemoryError</code></td></tr><tr><td><code>-XX:HeapDumpPath=&#x3C;file></code></td><td>Specifies <strong>heap dump file location</strong>.</td><td><code>-XX:HeapDumpPath=/var/dumps/heap.hprof</code></td></tr></tbody></table>

#### **Use Cases:**

* **Remote debugging** → Use `-Xrunjdwp` to attach debuggers like **IntelliJ or Eclipse**.
* **Memory analysis** → Use `-XX:+HeapDumpOnOutOfMemoryError` with tools like **Eclipse MAT**.

### **2.6 Container-Specific Options**

These JVM options are **critical** when running Java applications inside **containers** (Docker, Kubernetes, OpenShift). By default, JVM is **not aware** of container limits and may consume more memory or CPU than allowed, leading to **OutOfMemoryErrors (OOMs)** or performance issues.

<table data-header-hidden data-full-width="true"><thead><tr><th width="230"></th><th width="262"></th><th width="272"></th><th></th></tr></thead><tbody><tr><td><strong>Option</strong></td><td><strong>Description</strong></td><td><strong>Examples</strong></td><td><strong>Use Cases</strong></td></tr><tr><td><code>-XX:+UseContainerSupport</code> <em>(Java 10+)</em></td><td>Enables <strong>container awareness</strong>, making JVM respect cgroups limits for CPU and memory. <em>(Enabled by default in Java 11+)</em></td><td><code>-XX:+UseContainerSupport</code></td><td><strong>Essential for all containerized apps</strong> to prevent JVM from exceeding allocated memory.</td></tr><tr><td><code>-XX:MaxRAMPercentage=&#x3C;value></code> <em>(Java 11+)</em></td><td>JVM sets <strong>heap memory</strong> as a <strong>percentage of total container memory</strong> instead of using fixed <code>-Xmx</code> values.</td><td><code>-XX:MaxRAMPercentage=75.0</code> → Uses <strong>75%</strong> of container memory for heap.</td><td><strong>Kubernetes/OpenShift apps</strong> → Automatically adjust heap based on container limits. <br><strong>Dynamic workloads</strong> → Adjust heap for autoscaling environments.</td></tr><tr><td><code>-XX:InitialRAMPercentage=&#x3C;value></code><em>(Java 11+)</em></td><td>Sets <strong>initial heap size</strong>(<code>-Xms</code>) as a <strong>percentage</strong> of total container memory.</td><td><code>-XX:InitialRAMPercentage=50.0</code> → Allocates <strong>50%</strong> of container memory at startup.</td><td><strong>Cloud-native apps</strong>→ Ensures JVM starts with a reasonable heap size.</td></tr><tr><td><code>-XX:MinRAMPercentage=&#x3C;value></code> <em>(Java 11+)</em></td><td>Specifies the <strong>minimum heap allocation</strong> as a percentage of total RAM.</td><td><code>-XX:MinRAMPercentage=30.0</code> → Ensures at least <strong>30%</strong> of RAM is used for heap.</td><td><strong>Memory-sensitive apps</strong> → Ensures JVM doesn’t start with too little memory.</td></tr><tr><td><code>-XX:ActiveProcessorCount=&#x3C;N></code> <em>(Java 8+)</em></td><td>Manually sets the <strong>number of CPU cores</strong>the JVM should use, overriding cgroups detection.</td><td><code>-XX:ActiveProcessorCount=2</code> → Restricts JVM to <strong>2 CPU cores</strong>.</td><td><strong>Multi-threaded apps</strong> → Ensures correct thread pool size inside containers.</td></tr><tr><td><code>-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap</code><em>(Java 8 Update 191-251)</em></td><td><strong>(Deprecated in Java 11+)</strong> Makes JVM <strong>respect container memory limits</strong> for heap calculations. <em>(Replaced by <code>-XX:MaxRAMPercentage</code>in Java 11)</em></td><td><code>-XX:+UseCGroupMemoryLimitForHeap</code></td><td><strong>For Java 8 users in containers</strong> who cannot upgrade to Java 11+.</td></tr><tr><td><code>-XX:+ExitOnOutOfMemoryError</code></td><td><strong>Immediately terminates</strong> JVM when an <code>OutOfMemoryError</code>occurs (instead of continuing execution with errors).</td><td><code>-XX:+ExitOnOutOfMemoryError</code></td><td><strong>Kubernetes/OpenShift</strong>→ Ensures the pod restarts when JVM runs out of memory instead of becoming unresponsive.</td></tr><tr><td><code>-XX:+CrashOnOutOfMemoryError</code></td><td><strong>Generates a core dump</strong> and crashes the JVM when an <code>OutOfMemoryError</code>occurs.</td><td><code>-XX:+CrashOnOutOfMemoryError</code></td><td><strong>Forensic analysis</strong>→ Useful for debugging memory leaks in production.</td></tr><tr><td><code>-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=&#x3C;path></code></td><td>Dumps <strong>heap memory</strong>to a file when JVM runs out of memory.</td><td><code>-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/var/dumps/heap.hprof</code></td><td><strong>Post-mortem debugging</strong> → Analyze memory leaks using <strong>Eclipse MAT</strong> or <strong>VisualVM</strong>.</td></tr><tr><td><code>-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=&#x3C;port></code></td><td>Enables <strong>JMX monitoring</strong> for containers.</td><td><code>-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9010</code></td><td><strong>Monitor JVM metrics inside Kubernetes/OpenShift</strong>via Prometheus/Grafana.</td></tr><tr><td><code>-XX:+AlwaysPreTouch</code></td><td>JVM pre-allocates heap memory upfront, reducing page faults.</td><td><code>-XX:+AlwaysPreTouch</code></td><td><strong>High-performance apps</strong> → Reduces startup latency.</td></tr></tbody></table>

