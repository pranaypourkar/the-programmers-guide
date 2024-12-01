# Java Internals - TBU

* **Overview**
  * Brief introduction to the inner workings of Java.
  * Relationship between the JVM, memory management, and core features.
* **JVM (Java Virtual Machine)**
  * Architecture of the JVM
    * Classloader
    * Runtime Data Areas (Method Area, Heap, Stack, etc.)
    * Execution Engine (Interpreter, JIT Compiler, etc.)
  * Lifecycle of a Java Program
  * Bytecode and Class File Structure
* **Memory Management**
  * Stack and Heap Memory
  * Garbage Collection (GC) and its algorithms (e.g., G1, CMS)
  * Native Method Stack and Method Area
  * Common memory-related issues (OutOfMemoryError, StackOverflowError)
* **Variables**
  * Definition and Types (Local, Instance, Static)
  * Memory Allocation for Variables
  * Variable Scope, Lifetime, and Initialization
  * Behind-the-scenes working of variables in the JVM
* **Classloading Mechanism**
  * Phases of Class Loading (Loading, Linking, Initialization)
  * Classloaders (Bootstrap, Extension, Application)
* **Execution Engine**
  * How the JVM executes bytecode
  * Role of JIT Compiler and HotSpot optimizations
* **Threading and Synchronization**
  * Java Thread Model
  * Thread lifecycle and scheduling in JVM
  * Monitor, Locks, and Deadlocks
* **Exception Handling**
  * How JVM handles exceptions
  * Structure of try-catch-finally blocks in bytecode
* **Java Security**
  * ClassLoader Security
  * Bytecode Verification
  * Sandboxing in the JVM
