# Memory Management

## About

Memory management in the JVM is a critical aspect that ensures efficient allocation, usage, and reclamation of memory resources. The JVM provides an automatic memory management system through **Garbage Collection (GC)**, optimising application performance and preventing memory leaks.

1. **Memory Areas** → The JVM divides memory into different regions for efficient execution.
2. **Heap & Non-Heap Memory** → Objects are stored in the **Heap**, while metadata and code are in **Non-Heap**.
3. **Garbage Collection** → JVM automatically removes unused objects to free up memory.
4. **Stack & Thread Memory** → Manages method calls, local variables, and thread execution.
5. **Performance Optimization** → JVM tuning parameters (`-Xms`, `-Xmx`, `-XX:GC`) help optimize memory usage.
