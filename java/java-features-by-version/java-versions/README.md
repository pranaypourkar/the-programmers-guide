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

### Structured Concurrency **(Second Preview)**

Simplifies concurrent programming.

### **Stream Gatherers (Preview)**&#x20;

Enhances the Stream API for more flexible data aggregation.

### **String Templates (Second Preview)**&#x20;

Improves handling of dynamic string content.

### **Unnamed Variables and Patterns (Preview)**&#x20;

Makes the code cleaner and more readable.

### **Foreign Function & Memory API**

Facilitates interaction with native code and memory.

### **Multi-File Program Execution**&#x20;

Allows simpler execution of multi-file programs.

### Region Pinning for G1

Improves garbage collection efficiency by allowing certain regions to be pinned, preventing them from being moved or collected during garbage collection cycles.

### Statements before super(…) (Preview)

Allows statements to execute before a call to `super(…)` in a constructor, enhancing initialization flexibility.

### Class-File API (Preview)

Provides a standardized way to read, write, and transform Java class files programmatically.

### Vector API (Seventh Incubator)

Offers advanced SIMD (Single Instruction, Multiple Data) operations for higher performance computing.

### Implicitly Declared Classes and Instance Main Methods (Second Preview)

Simplifies Java programs by allowing the omission of explicit class declarations and enabling shorter syntax for `main`methods.



## Java 21 (September 2023)

### Virtual Threads

Lightweight threads for high-concurrency applications.

### Pattern Matching for switch

Enhances switch statements for complex data

### Sequenced Collections

Adds new collection interfaces.

### Unnamed Patterns and Variables (Preview)

Simplifies handling of unused variables.

### Record Patterns

Allows pattern matching in records.

### Scoped Values (Preview)

Improves handling of scoped values in concurrent applications.

### String Templates (Preview)

Simplifies dynamic string generation.

### Generational ZGC&#x20;

Enhances Z Garbage Collector.

### Structured Concurrency **(Preview)**

Simplifies concurrent programming.

### Foreign Function & Memory API (Third Preview)

Provides mechanisms to call native code and safely access native memory from Java.

### Deprecate the Windows 32-bit x86 Port for Removal

Marks the Windows 32-bit x86 port for potential future removal, focusing support on more modern platforms.

### Prepare to Disallow the Dynamic Loading of Agents

Prepares the JVM to disallow dynamically loading Java agents into running applications for improved security and stability.

### Key Encapsulation Mechanism API

Introduces an API for key encapsulation mechanisms to simplify and secure cryptographic key exchange operations.

### Implicitly Declared Classes and Instance Main Methods (Preview)

Simplifies Java programs by allowing the omission of explicit class declarations and enabling shorter syntax for `main`methods.

### Vector API (Sixth Incubator)

Offers advanced SIMD (Single Instruction, Multiple Data) operations for higher performance computing.



## Java 20 (March 2023)

### **Pattern Matching for switch (**Fourth **Preview)**

Refines switch pattern matching.

### **Scoped Values (Incubator)**

Initial introduction of scoped values.

### **Record Patterns** (Second Preview)

Introduces pattern matching in records.

### **Foreign Function & Memory API (Second Preview)**

Enhances interaction with native code and memory.

### **Virtual Threads (Second Preview)**

Refines virtual threads.

### Structured Concurrency (Second Incubator)

Simplifies concurrent programming by managing multiple tasks in a structured manner, improving readability and reliability of concurrent code.

### Vector API (Fifth Incubator)

Provides advanced SIMD (Single Instruction, Multiple Data) operations, allowing for more efficient data processing and higher performance computing through parallelism.



## Java 19 (September 2022)

### **Virtual Threads (Preview)**

Introduces lightweight threads.

### **Structured Concurrency (Incubator)**

Simplifies concurrent programming.

### **Pattern Matching for switch (Third Preview)**

Adds pattern matching to switch.

### **Foreign Function & Memory API (Preview)**

Facilitates native code interaction.

### Record Patterns (Preview)

Enhances pattern matching by allowing deconstruction of record types directly in pattern matching constructs, improving code readability and conciseness.

### Linux/RISC-V Port

Adds support for the RISC-V instruction set architecture on the Linux operating system, expanding Java's reach to new hardware platforms.

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

### Pattern Matching for _switch_ (Second Preview)

Enhances switch statements by allowing patterns to be used directly within the switch, enabling more powerful data-driven logic and reducing boilerplate code.



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

### Restore Always-Strict Floating-Point Semantics

Ensures that floating-point operations always adhere to strict IEEE 754 standards, enhancing consistency and predictability.

### Remove RMI Activation

Eliminates the Remote Method Invocation (RMI) Activation mechanism, simplifying the RMI API and reducing maintenance.

### Deprecate the Security Manager for Removal

Marks the Security Manager for future removal, steering developers towards modern security practices.

### Vector API (Second Incubator)

Introduces SIMD (Single Instruction, Multiple Data) operations, enabling high-performance data processing through vectorized computations.

### macOS/AArch64 Port

Adds support for the Apple Silicon (AArch64) architecture on macOS, enabling Java to run natively on Apple's ARM-based devices, improving performance and compatibility.



## Java 16 (March 2021)

### **Vector API (Incubator)**

Introduces SIMD operations for efficient data processing.

### **Enable C++14 Language Features**

Enables the use of C++14 language features in JDK C++ code.

### **Migrate from Mercurial to Git**

Moves the OpenJDK source code repository from Mercurial to Git.

### **Migrate to GitHub**

Transfers the OpenJDK project to GitHub for better collaboration.

### **ZGC: Concurrent Thread-Stack Processing**:&#x20;

Enhances the Z Garbage Collector with concurrent thread-stack processing.

### **Unix-Domain Socket Channels**

Adds support for Unix-domain socket channels.

### **Alpine Linux Port**

Ports the JDK to Alpine Linux, a lightweight Linux distribution.

### **Elastic Metaspace**&#x20;

Improves memory management in the Metaspace area.

### **Windows/AArch64 Port**

Adds support for the Windows operating system on AArch64 architecture.

### **Foreign Linker API (Incubator)**

Provides an API to call native code from Java.

### **Warnings for Value-Based Classes**

Issues warnings when value-based classes are misused.

### **Packaging Tool**

Introduces a tool for packaging Java applications.

### **Foreign-Memory Access API (Third Incubator)**

Enhances the API for accessing foreign memory.

### **Pattern Matching for `instanceof`**

Simplifies type checks by introducing pattern matching.

### **Records**

Introduces a concise syntax for immutable data classes.

### **Strongly Encapsulate JDK Internals by Default**

Increases encapsulation of internal APIs to enhance security.

### **Sealed Classes (Second Preview)**

Restricts which classes can extend or implement a class or interface.



## Java 15 (September 2020)

### **Sealed Classes (Preview)**

Restricts class hierarchies.

### **Hidden Classes**

Supports dynamically generated classes.

### **Text Blocks**

Enhances multi-line strings.

### **Foreign-Memory Access API (Second Incubator)**

Enhances foreign memory access.

### **Pattern Matching for instanceof (Second Preview)**

Refines type checks.

### EdDSA Algorithm&#x20;

A modern digital signature scheme offering efficient performance and strong security.

### Removed Nashorn JavaScript Engine&#x20;

Deprecated JavaScript engine removed from Java, encouraging alternative implementations.

### Reimplement the Legacy DatagramSocket API&#x20;

Refactored implementation enhancing reliability and performance for network communication.

### Records (Second Preview)

Simplified data-centric classes improving code readability and maintainability in Java.



## Java 14 (March 2020)

### **Switch Expressions (Standard)**

Enhances switch statements.

### **Text Blocks (Second Preview)**

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

### JFR Event Streaming

Enables continuous monitoring and analysis of Java Flight Recorder data in real-time.

### Non-Volatile Mapped Byte Buffers

Allows direct access to non-volatile memory, ensuring data persistence across program runs.

### Remove the Concurrent Mark Sweep (CMS) Garbage Collector

Discontinued CMS to streamline and enhance the performance of Java's garbage collection.

### Remove the Pack200 Tools and API

Eliminated outdated compression tools and API, simplifying Java's class file handling.



## Java 13 (September 2019)

### **Text Blocks (Preview)**

Introduces multi-line string literals.

### **Switch Expressions (Preview)**

Enhances switch statements.

### **Reimplement the Legacy Socket API**

Improves socket API implementation.

### Dynamic CDS Archive

Creates and updates class-data sharing archives dynamically at runtime to improve startup performance.

### ZGC: Uncommit Unused Memory

Enhances the Z Garbage Collector to automatically release unused memory back to the operating system.

### FileSystems.newFileSystem() Method

Allows creation of a new file system from a given path or URI, enabling advanced file manipulation.

### DOM and SAX Factories with Namespace Support

Ensures DOM and SAX parser factories fully support XML namespaces, improving XML processing capabilities.



## Java 12 (March 2019)

### **Switch Expressions (Preview)**

Adds new switch syntax.

### **JVM Constants API**

Enhances access to JVM constants.

### **One AArch64 Port, Not Two**

Simplifies ARM 64-bit support.

### Collectors.teeing() in Stream API&#x20;

Combines two collectors to process the same elements in a stream and merge their results.

### String API Changes&#x20;

Introduces new methods for string manipulation

### Files.mismatch(Path, Path)&#x20;

Identifies the first differing byte position between two files, aiding file comparison.

### Compact Number Formatting&#x20;

Formats numbers in a human-readable, concise way based on locale, such as "1K" instead of "1,000".

### Support for Unicode 11

Adds support for the latest Unicode standard, enhancing character and emoji handling.



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

### **Launch Single-File Source-Code Programs** Without Compilation

Simplifies single-file program execution.

### String API Changes

Introduces new methods for string manipulation.

### Collection.toArray(IntFunction)

Provides a streamlined way to convert collections to arrays, specifying the array type.

### Files.readString() and Files.writeString()

Simplifies reading from and writing to files as strings, enhancing file I/O operations.

### Optional.isEmpty()

Adds a method to check if an `Optional` is empty, improving code readability and null handling.



## Java 10 (March 2018)

### Local Variable Type Inference&#x20;

Introduces the `var` keyword, allowing local variable types to be inferred by the compiler.

### Time-Based Release Versioning&#x20;

Implements a predictable release cycle with version numbers based on the release date.

### Garbage-Collector Interface&#x20;

Provides a common interface for different garbage collectors, simplifying integration and management.

### Parallel Full GC for G1&#x20;

Enhances the G1 garbage collector with parallel processing for full garbage collection, improving performance.

### Heap Allocation on Alternative Memory Devices&#x20;

Supports allocating Java heap on non-volatile memory devices, enhancing flexibility.

### Consolidate the JDK Forest into a Single Repository&#x20;

Merges multiple repositories into a single one to streamline development and reduce complexity.

### Application Class-Data Sharing&#x20;

Enables sharing of class data among applications to reduce startup time and memory footprint.

### Additional Unicode Language-Tag Extensions&#x20;

Supports more language-tag extensions for better internationalization and localization.

### Root Certificates&#x20;

Provides a default set of root certificates for improved security and trust management.

### Experimental Java-Based JIT Compiler&#x20;

Introduces a Just-In-Time compiler written in Java, known as Graal, for experimental use.

### Thread-Local Handshakes

Allows executing a callback on a specific thread without global synchronization, improving thread management.

### Remove the Native-Header Generation Tool&#x20;

Eliminates the `javah` tool, as its functionality is integrated into `javac`.

### New Added APIs and Options&#x20;

Introduces new APIs and command-line options to enhance functionality and usability.

### Removed APIs and Options

Deprecates and removes obsolete APIs and options to simplify the codebase and encourage modern practices.



## [Java 9](https://openjdk.org/projects/jdk9/) (September 2017)

### Java Platform Module System&#x20;

Introduces a module system to improve application modularization, encapsulation, and dependency management.&#x20;

### Interface Private Methods&#x20;

Allows private methods within interfaces to share common code among default and static methods.&#x20;

### HTTP 2 Client&#x20;

Provides a modern HTTP client API supporting HTTP/2 and WebSocket, replacing the legacy HttpURLConnection.&#x20;

### JShell – REPL Tool&#x20;

Offers an interactive Read-Eval-Print Loop (REPL) tool for quickly testing and prototyping Java code.&#x20;

### Platform and JVM Logging&#x20;

Enhances logging capabilities across the platform and JVM, providing more detailed and configurable logging.&#x20;

### Process API Updates&#x20;

Adds new methods to the Process API for better control and management of operating system processes.&#x20;

### Collection API Updates&#x20;

Introduces new utility methods for collections.&#x20;

### Improvements in Stream API&#x20;

Adds new methods for more versatile stream processing.&#x20;

### Multi-Release JAR Files&#x20;

Enables JAR files to contain version-specific class files, allowing better compatibility with different Java versions.&#x20;

### @Deprecated Tag Changes&#x20;

Enhances the @Deprecated annotation to include information about the deprecation reason and replacement.&#x20;

### Stack Walking&#x20;

Introduces a stack-walking API for more efficient and flexible stack frame traversal and inspection.&#x20;

### Java Docs Updates&#x20;

Improves Javadoc tool with HTML5 support, search capability, and better overall documentation generation.&#x20;

### Miscellaneous Other Features&#x20;

Includes various minor enhancements and performance improvements across the Java platform.



## Java 8 (March 2014, LTS)

### **Lambda Expressions**

Adds functional programming constructs.

### **Stream API**

Introduces streams for data processing.

### **Date and Time API**

Adds new date/time API.

### **Nashorn JavaScript Engine**

Adds a new JavaScript engine.

### **Type Annotations**

Enhances annotation support on Java Types.

### **Repeating Annotations**

Allows repeating annotations.

### Functional interface and default methods

Introduces functional interfaces with a single abstract method, and default methods in interfaces, allowing method implementations within interfaces.

### Optionals

Provides the `Optional` class to represent potentially absent values, reducing the need for null checks and improving code readability.

### Unsigned Integer Arithmetic

Adds support for unsigned integer operations, enabling arithmetic without negative numbers for certain use cases.

### Statically-linked JNI libraries

Allows JNI libraries to be statically linked with the JVM, improving performance and deployment simplicity.

### Launch JavaFX applications from jar files

Enables direct launching of JavaFX applications packaged in JAR files, simplifying application deployment.

### Remove the permanent generation from GC

Eliminates the permanent generation space in the HotSpot garbage collector, replacing it with the metaspace, for better memory management and performance.



## Java 7 (July 2011)

### **Project Coin (Small Language Enhancements)**

Adds small language improvements.

### **Fork/Join Framework**

Adds parallel processing framework.

### **NIO.2 (New I/O)**

Enhances I/O capabilities.

### **String in Switch Statements**

Allows strings in switch.

### **Automatic Resource Management (ARM) Blocks**

Adds try-with-resources.

### JVM support for dynamic languages

Enhances the JVM with the `invokedynamic` instruction to better support dynamic languages like Groovy, Scala, and JRuby.

### Compressed 64-bit pointers

Introduces compressed object pointers (oops) in 64-bit JVMs to reduce memory footprint and improve performance.

### The diamond operator

Simplifies generic instance creation by inferring type parameters from the context, reducing boilerplate code.

### Simplified varargs method declaration

Improves varargs method declarations to avoid unchecked warnings and enhance type safety.

### Binary integer literals

Allows binary integer literals using the `0b` prefix for better readability of binary values in code.

### Underscores in numeric literals&#x20;

Permits underscores in numeric literals for improved readability of large numbers.

### Improved exception handling

Adds multi-catch and final rethrow to handle multiple exceptions in a single catch block and rethrow exceptions with more type safety.

### WatchService

Provides a file system change notification API to monitor and respond to file system events like creation, modification, and deletion.

### Timsort is used to sort collections and arrays of objects instead of merge sort&#x20;

Adopts Timsort for sorting collections and arrays of objects, offering better performance in many scenarios.

### APIs for the graphics features&#x20;

Introduces new APIs and enhances existing ones to support advanced graphics features and capabilities.

### Support for new network protocols, including SCTP and Sockets Direct Protocol

Adds support for the Stream Control Transmission Protocol (SCTP) and Sockets Direct Protocol (SDP) to expand networking capabilities.



## Java 6 (December 2006)

### **Scripting Language Support**

Adds scripting engine API.

### **Compiler API**

Provides access to Java compiler.

### **Pluggable Annotations Processing API**

Enhances annotation processing.

### **JDBC 4.0**

Enhances database connectivity.

### **Web Services Enhancements**

Improves web service support.

### JAX-WS&#x20;

Provides a framework for building web services and clients using Java, supporting SOAP and WSDL.

### JAXB 2.0 and StAX parser&#x20;

AXB 2.0 offers a framework for converting Java objects to XML and vice versa, while the StAX parser provides a streaming API for XML processing, enabling efficient, low-level XML reading and writing.

### New GC algorithms

Introduces new garbage collection algorithms to improve performance, scalability, and pause-time predictability in memory management.



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

### **Concurrency Utilities** in `java.util.concurrent`

Enhances concurrency support.

### Static Imports

Allows importing static members (fields and methods) of classes, enabling their direct use without class qualification, thus improving code readability and conciseness.



## Java 4  (1.4) (February 2002)

**Assertions**

Adds assertion capability.



## Java 3 and earlier

Java 2 (December 1998): Introduction of Swing, Collections Framework

JDK 1.1 (February 1997): Inner classes, JavaBeans, JDBC

JDK 1.0 (January 1996): Initial release
