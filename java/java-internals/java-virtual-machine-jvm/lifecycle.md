# Lifecycle

## About

The **Java Virtual Machine (JVM) lifecycle** represents the various stages that JVM undergoes, from initialization to termination. Understanding this lifecycle is crucial for Java developers, as it helps in debugging, optimizing memory management, and handling performance issues.

The lifecycle of JVM follows these major stages:

1. **JVM Startup** → Bootstrapping the JVM and loading essential components.
2. **Class Loading & Linking** → Loading, verifying, and preparing bytecode for execution.
3. **Runtime Execution** → Running the Java application, managing threads, and handling memory.
4. **Garbage Collection** → Reclaiming unused memory.
5. **JVM Shutdown** → Cleaning up resources and terminating the JVM.

Each of these phases consists of multiple internal processes that contribute to JVM's stability and efficiency.

## Stage 1: JVM Startup (Initialization Phase)

The startup process involves multiple steps that initialize the JVM and load the required components.

**2.1. Steps in JVM Startup:**

### **1. JVM Invocation**

* When a Java program is executed (`java MyProgram`), the JVM process starts.
* The **Java Launcher** (`java` command) invokes the JVM, and it determines the classpath, JVM options, and system properties.

### **2. Bootstrap ClassLoader Activation**

* The **Bootstrap ClassLoader** loads fundamental classes (e.g., `java.lang.Object`, `java.lang.String`).
* It sets up the standard Java libraries (`rt.jar` in older versions, `modules` in Java 9+).

### **3. Application Class Loading**

* The user-defined class (e.g., `MyProgram.class`) is loaded via the **Application ClassLoader**.

### **4. Main Method Execution**

* JVM searches for the `public static void main(String[] args)` method.
* If found, it starts execution; otherwise, an error occurs (`NoSuchMethodError`).

## **Stage 2: Class Loading & Linking (Bytecode Preparation Phase)**

Before execution, JVM processes the class files through **Class Loading, Linking, and Initialization**.

### **1. Class Loading (Dynamic Class Resolution)**

* The **ClassLoader Subsystem** dynamically loads class files into JVM memory.
* Three types of Class Loaders:
  1. **Bootstrap ClassLoader** → Loads core Java classes (`java.lang.*`).
  2. **Extension ClassLoader** → Loads classes from `ext` directory (`javax.*`).
  3. **Application ClassLoader** → Loads user-defined classes from the classpath.

### **2. Linking (Bytecode Verification & Preparation)**

* **Verification:** Ensures the bytecode follows Java security rules (e.g., no illegal memory access).
* **Preparation:** Assigns default values to static variables.
* **Resolution:** Converts symbolic references into direct memory references.

### **3. Initialization (Execution of Static Blocks)**

* Static initializers (`static {}` blocks) and static variable assignments are executed.
*   Example:

    ```java
    class Example {
        static int x = 10;
        static { System.out.println("Static Block Executed"); }
    }
    ```
* Output: `"Static Block Executed"` before `main()` starts.

## **Stage 3: Runtime Execution (Code Execution & Thread Management)**

Once class loading is complete, the JVM enters the **execution phase**.

### **1. Execution Engine**

* The **Execution Engine** is responsible for running Java bytecode.
* It consists of:
  1. **Interpreter** → Executes bytecode line by line (slow but quick to start).
  2. **JIT Compiler** → Converts hot code paths into native machine code for performance optimization.
  3. **Garbage Collector (GC)** → Manages memory and cleans up unused objects.

{% hint style="success" %}
#### **HotSpot JVM vs Other JVMs**

* **HotSpot JVM** (Oracle's JVM) uses **Just-In-Time (JIT) Compilation** for performance.
* **OpenJ9** (IBM’s JVM) focuses on memory efficiency.
* **GraalVM** allows **ahead-of-time (AOT) compilation**.
{% endhint %}

### **2. Thread Management**

* Java uses **multithreading** to run multiple tasks in parallel.
* The JVM manages **Daemon Threads** (e.g., Garbage Collector thread) and **User Threads**.
* **Thread Lifecycle:**
  * `NEW` → `RUNNABLE` → `BLOCKED` → `WAITING` → `TERMINATED`.

### **3. Memory Management (Heap & Stack)**

* The JVM divides memory into **Heap (object storage)** and **Stack (method execution)**.
* **Heap Memory:**
  * Divided into **Young Generation**, **Old Generation**, and **Metaspace**.
* **Stack Memory:**
  * Stores method call frames, local variables, and function parameters.

## **Stage 4: Garbage Collection (Automatic Memory Management)**

JVM reclaims memory through **Garbage Collection (GC)** to avoid memory leaks.

### **1. Garbage Collection Process**

1. **Mark Phase** → Identifies unused objects.
2. **Sweep Phase** → Removes garbage objects.
3. **Compact Phase** → Defragments memory for efficient allocation.

### **2. Garbage Collection Algorithms**

* **Serial GC** → Single-threaded, suitable for small applications.
* **Parallel GC** → Uses multiple threads for faster collection.
* **G1 GC (Garbage First)** → Optimized for low latency.
* **ZGC (Z Garbage Collector)** → Ultra-low pause times for large heaps (Java 11+).

## **Stage 5: JVM Shutdown (Termination Phase)**

When the application completes execution, JVM enters the shutdown phase.

### **1. JVM Shutdown Triggers**

* **Normal Termination** → `System.exit(0)` or program end.
* **Abnormal Termination** → Fatal error, OutOfMemoryError, or force kill (`kill -9 <pid>`).
*   **User-Initiated Shutdown Hooks** → JVM allows cleanup tasks before exit.

    ```java
    Runtime.getRuntime().addShutdownHook(new Thread(() -> System.out.println("Cleanup before JVM Exit")));
    ```

### **2. JVM Shutdown Process**

* **Garbage Collection Execution** → Final GC cycle before JVM exits.
* **Finalization Phase** → Calls `finalize()` on objects (deprecated in Java 9+).
* **Thread Termination** → Closes all non-daemon threads.
* **JVM Exit Call** → Releases system resources.











