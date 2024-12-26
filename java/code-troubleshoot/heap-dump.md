# Heap Dump

## About

A **heap dump** is a snapshot of the heap memory of the JVM at a specific point in time. It contains information about:

* All objects in memory
* Their references and relationships
* Primitive values stored in those objects

## Why is it Useful?

* **Memory leaks**: Identify objects that are occupying excessive memory and are not being garbage collected.
* **OutOfMemoryError**: Helps debug what caused the application to run out of memory.
* **Object reference issues**: Analyze how objects are related to each other.

## When to Capture a Heap Dump?

* When the application experiences **OutOfMemoryError**.
* To analyze memory consumption trends.
* To identify **unreachable but still-referenced objects**.

## How to Generate a Heap Dump?

### **Automatically on OutOfMemoryError**&#x20;

Add this JVM option to enable heap dump generation on `OutOfMemoryError`:

```bash
-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=<path-to-save-dump>
```

### **Using JDK Tools**

`jmap -dump:live,format=b,file=<file-name>.hprof <pid>`: Generates a heap dump.

### **Using Tools**

Tools like Eclipse MAT (Memory Analyzer Tool), VisualVM, JConsole, or IntelliJ IDEA.

## Example Output

Heap dumps are binary files (e.g., `heapdump.hprof`) and cannot be read directly. We must use tools like Eclipse MAT or VisualVM to analyze them.

## How to Analyze a Heap Dump?

* **Look for retained memory**: Identify objects that consume the most memory.
* **Inspect object references**: Trace how objects reference each other.
* **Analyze garbage collection**: Check for objects that should have been collected but are not.
