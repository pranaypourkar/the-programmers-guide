# JVM Overview

## About

The **Java Virtual Machine (JVM)** is the core runtime environment that enables Java applications to run on different platforms. It abstracts hardware details and provides **memory management, execution, and security features**.

## **Key Components of JVM**

1. **ClassLoader** – Loads class files into memory.
2. **Runtime Memory Areas** – Includes Heap, Stack, Metaspace, and Method Area for managing objects, methods, and execution data.
3. **Execution Engine** – Converts bytecode into machine code using an **Interpreter** and **JIT Compiler**.
4. **Garbage Collector (GC)** – Manages memory automatically by reclaiming unused objects.
5. **Native Interface (JNI)** – Enables interaction with native code (C/C++).

## **JVM Lifecycle**

1. **Loading & Linking** – Classes are loaded, verified, and prepared.
2. **Runtime Execution** – The application runs with memory management, JIT compilation, and threading.
3. **Shutdown** – JVM performs cleanup and releases resources.

The JVM ensures **platform independence, optimized execution, and security**, making Java highly portable and reliable.
