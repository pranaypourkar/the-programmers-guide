---
description: >-
  List of notable Java features by version, starting from the latest version and
  going backward. It highlights the significant features introduced in each
  version of Java, focusing on the most impact.
---

# Java Versions

## Java 22 (March 2024)

### **Scoped Values (Second Preview)**

Simplifies sharing of immutable data within and across threads.&#x20;

### **Stream Gatherers (Preview)**&#x20;

Enhances the Stream API for more flexible data aggregation.

### **String Templates (Second Preview)**&#x20;

Improves handling of dynamic string content.

### **Unnamed Variables and Patterns (Preview)**&#x20;

Makes the code cleaner and more readable.

### **Foreign Function & Memory API (Final)**&#x20;

Facilitates interaction with native code and memory.

### **Multi-File Program Execution**&#x20;

Allows simpler execution of multi-file programs.



## Java 21 (September 2023)

### Virtual Threads (Preview)

Lightweight threads for high-concurrency applications.

### Pattern Matching for switch (Third Preview)

Enhances switch statements for complex data

### Sequenced Collections

Adds new collection interfaces.

### Unnamed Patterns and Variables (Preview)

Simplifies handling of unused variables.

### Record Patterns (Second Preview)

Allows pattern matching in records.

### Scoped Values (Preview)

Improves handling of scoped values in concurrent applications.

### String Templates (Preview)

Simplifies dynamic string generation.

### Generational ZGC (Preview)

Enhances Z Garbage Collector.



## Java 20 (March 2023)

### **Pattern Matching for switch (Second Preview)**

Refines switch pattern matching.

### **Scoped Values (Incubator)**

Initial introduction of scoped values.

### **Record Patterns (First Preview)**

Introduces pattern matching in records.

### **Foreign Function & Memory API (Second Preview)**

Enhances interaction with native code and memory.

### **Virtual Threads (Second Preview)**

Refines virtual threads.



## Java 19 (September 2022)

### **Virtual Threads (Preview)**

Introduces lightweight threads.

### **Structured Concurrency (Incubator)**

Simplifies concurrent programming.

### **Pattern Matching for switch (Preview)**

Adds pattern matching to switch.

### **Foreign Function & Memory API (Preview)**

Facilitates native code interaction.

### **Vector API (Fourth Incubator)**

Enhances SIMD programming.

{% hint style="info" %}
SIMD is short for Single Instruction/Multiple Data, while the term SIMD operations refers to a computing method that enables processing of multiple data with a single instruction.
{% endhint %}



## Java 18 (March 2022)

### **Simple Web Server**

Lightweight web server for testing.

### **UTF-8 by Default**

Sets UTF-8 as the default charset.

### **Vector API (Third Incubator)**

Further SIMD enhancements.

### **Code Snippets in Java API Documentation**

Adds code snippet support.

### **Foreign Function & Memory API (Second Incubator)**

Further refinements for native code interaction.

### **Deprecate Finalization for Removal**

Moves toward removing finalization.

### **Internet-Address Resolution SPI**

Improves address resolution.



## Java 17 (September 2021, LTS)

### **Pattern Matching for switch (Preview)**

Improves switch statements.

### **Sealed Classes**

Restricts class hierarchies.

### **Enhanced Pseudo-Random Number Generators**

Improves random number generation

### **New macOS Rendering Pipeline**

Enhances macOS graphics.

### **Foreign Function & Memory API (Incubator)**

Initial introduction for native code interaction.

### **Context-Specific Deserialization Filters**

Enhances security for deserialization.

### **Remove the Experimental AOT and JIT Compiler**

Removes GraalVM-based compiler.

### **Deprecate the Applet API for Removal**

Moves toward removing applets.

### **Strongly Encapsulate JDK Internals**

Increases encapsulation of internal APIs.



## Java 16 (March 2021)

### **Records**

Simplifies data classes.

### **Pattern Matching for instanceof**

Simplifies type checks.

### **Sealed Classes (Second Preview)**

Further restricts class hierarchies.

### **Strongly Encapsulate JDK Internals by Default**

Increases encapsulation of internal APIs.

### **Foreign-Memory Access API (Third Incubator)**

Enhances foreign memory access.

### **Vector API (Second Incubator)**

Further SIMD enhancements.



## Java 15 (September 2020)

### **Sealed Classes (Preview)**

Restricts class hierarchies.

### **Hidden Classes**

Supports dynamically generated classes.

### **Text Blocks (Second Preview)**

Enhances multi-line strings.

### **Foreign-Memory Access API (Second Incubator)**

Enhances foreign memory access.

### **Pattern Matching for instanceof (Second Preview)**

Refines type checks.

### **ZGC: A Scalable Low-Latency Garbage Collector**

Enhances garbage collection.



## Java 14 (March 2020)

### **Switch Expressions (Standard)**

Enhances switch statements.

### **Text Blocks (Preview)**

Adds multi-line string literals.

### **Records (Preview)**

Simplifies data classes.

### **Pattern Matching for instanceof (Preview)**

Adds pattern matching.

### **Helpful NullPointerExceptions**

Improves exception messages.

### **Packaging Tool (Incubator)**

Adds packaging tool.

### **Foreign-Memory Access API (Incubator)**

Initial introduction for foreign memory access.

### **NUMA-Aware Memory Allocation for G1**

Enhances G1 GC performance.



## Java 13 (September 2019)

**Text Blocks (Preview)**

Introduces multi-line string literals.

**Switch Expressions (Preview)**

Enhances switch statements.

**Reimplement the Legacy Socket API**

Improves socket API implementation.



## Java 12 (March 2019)

### **Switch Expressions (Preview)**

Adds new switch syntax.

### **JVM Constants API**

Enhances access to JVM constants.

### **One AArch64 Port, Not Two**

Simplifies ARM 64-bit support.



## Java 11 (September 2018, LTS)

### **Dynamic Class-File Constants**

Supports new constant-pool entries.

### **Epsilon: A No-Op Garbage Collector**

Adds a no-op GC.

### **Flight Recorder**

Adds lightweight profiling.

### **HTTP Client (Standard)**

Standardizes HTTP client API.

### **Local-Variable Syntax for Lambda Parameters**

Enhances lambda syntax.

### **Nest-Based Access Control**

Improves nested class access.

### **Pattern Matching for instanceof (Preview)**

Adds pattern matching.

### **Remove the Java EE and CORBA Modules**

Removes outdated modules.

### **Launch Single-File Source-Code Programs**

Simplifies single-file program execution.



## Java 10 (March 2018)

### **Local-Variable Type Inference**

Adds `var` for local variables.

### **Parallel Full GC for G1**

Enhances G1 garbage collection.

### **Application Class-Data Sharing**

Improves startup and memory footprint.

### **Time-Based Release Versioning**

Introduces new versioning scheme.



## Java 9 (September 2017)

### **Module System (Project Jigsaw)**

Introduces modularity.

### **JShell (Interactive Java REPL)**

Adds a read-eval-print loop.

### **Multi-Release JAR Files**

Supports multi-version JARs.

### **Variable Handles**

Adds atomic access to variables.

### **Reactive Streams**

Supports reactive programming.

### **Enhanced Deprecation**

Improves deprecation mechanism.

### **Platform Logging API and Service**

Enhances logging support.



## Java 8 (March 2014, LTS)

### **Lambda Expressions**

Adds functional programming constructs.

### **Stream API**

Introduces streams for data processing.

### **Default Methods**

Allows default methods in interfaces.

### **Date and Time API**

Adds new date/time API.

### **Nashorn JavaScript Engine**

Adds a new JavaScript engine.

### **Type Annotations**

Enhances annotation support.

### **Repeating Annotations**

Allows repeating annotations.



## Java 7 (July 2011)

### **Project Coin (Small Language Enhancements)**

Adds small language improvements.

### **InvokeDynamic**

Improves dynamic language support.

### **Fork/Join Framework**

Adds parallel processing framework.

### **NIO.2 (New I/O)**

Enhances I/O capabilities.

### **Timsort for Arrays**

Improves array sorting.

### **String in Switch Statements**

Allows strings in switch.

### **Automatic Resource Management (ARM) Blocks**

Adds try-with-resources.



## Java 6 (December 2006)

### **Scripting Language Support**

Adds scripting engine API.

### **Compiler API**

Provides access to Java compiler.

### **Pluggable Annotations Processing API**

Enhances annotation processing.

### **JDBC 4.0**

Enhances database connectivity.

### **Java Compiler API**

Adds programmatic access to compiler.

### **Web Services Enhancements**

Improves web service support.



## Java 5 (September 2004)

### **Generics**

Adds generic types

### **Metadata (Annotations)**

Introduces annotations

### **Autoboxing/Unboxing**

Simplifies primitive/wrapper conversions.

### **Enumerated Types (Enums)**

Adds enums.

### **Varargs**

Supports variable-length arguments.

### **Enhanced for Loop**

Adds for-each loop.

### **Concurrency Utilities**

Enhances concurrency support.



## Java 4 (February 2002)

**Assertions**

Adds assertion capability.



## Java 3 and earlier

Java 2 (December 1998): Introduction of Swing, Collections Framework

JDK 1.1 (February 1997): Inner classes, JavaBeans, JDBC

JDK 1.0 (January 1996): Initial release
