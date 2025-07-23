# Java SE

## About

Java SE (Standard Edition) is the foundational platform of the Java ecosystem. It provides the core functionality required for developing and running Java applications on desktops, servers, and embedded environments.

* **Purpose**: Java SE provides the standard APIs and tools to write and run general-purpose applications in Java.
* **Base for**: Java EE (Jakarta EE), JavaFX, Android (indirectly), and many frameworks like Spring and Hibernate.
* **Released by**: Originally by Sun Microsystems, now maintained by Oracle and OpenJDK community.

## Java SE Versions Timeline

<table data-header-hidden><thead><tr><th width="128.71484375"></th><th width="154.9375"></th><th></th></tr></thead><tbody><tr><td>Version</td><td>Release Date</td><td>Notable Feature(s)</td></tr><tr><td>Java 1.0</td><td>1996</td><td>First public release</td></tr><tr><td>Java 1.2</td><td>1998</td><td>Collections Framework</td></tr><tr><td>Java 5</td><td>2004</td><td>Generics, Annotations, Enums</td></tr><tr><td>Java 8</td><td>2014</td><td>Lambdas, Streams, Date/Time</td></tr><tr><td>Java 11</td><td>2018</td><td>LTS, modern APIs</td></tr><tr><td>Java 17</td><td>2021</td><td>LTS, Sealed classes, Records</td></tr><tr><td>Java 21</td><td>2023</td><td>Virtual threads (LTS)</td></tr></tbody></table>

## Core Components

### Java Development Kit (JDK)

* **Includes**:
  * `javac`: Java compiler
  * `java`: JVM launcher
  * `javadoc`: Documentation generator
  * `jdb`: Debugger
  * `jshell`: REPL (since Java 9)
  * Other tools: `jar`, `jarsigner`, `jlink`, `jdeps`, `jmod`, etc.

### Java Runtime Environment (JRE)

* A subset of JDK
* Includes JVM and standard class libraries
* **Note**: JRE is no longer distributed separately from Java 11 onward.

### Java Virtual Machine (JVM)

* Executes Java bytecode (.class files)
* Handles memory management, garbage collection, JIT compilation, and runtime optimizations
* Platform-specific implementation with consistent bytecode interpretation

## Core Libraries (Packages)

#### Key Packages:

* `java.lang`: Fundamental classes (String, Math, Object, System, Thread, etc.)
* `java.util`: Collections, Date/Time, Random, Optional, etc.
* `java.io` / `java.nio`: Input/Output APIs (stream-based and buffer-based)
* `java.net`: Networking (sockets, HTTP clients, URLs)
* `java.sql`: JDBC APIs for database connectivity
* `java.time`: Date/Time API (since Java 8)
* `java.math`: BigDecimal, BigInteger
* `java.util.concurrent`: Concurrency utilities (Executors, Future, Locks)
* `java.security`: Cryptographic and permission APIs
* `java.lang.reflect`: Reflection support
* `javax.*`: Legacy APIs included in SE (e.g., `javax.crypto`, `javax.net.ssl`, `javax.naming`) — before being moved or deprecated

## Licensing

* Oracle JDK (Post-Java 8): Commercial use restrictions unless using LTS with proper license
* OpenJDK: GPLv2 with Classpath Exception
* Alternative builds:
  * Amazon Corretto
  * Azul Zulu
  * Eclipse Temurin (Adoptium)
  * Red Hat OpenJDK

## Development Environments

* Popular IDEs: IntelliJ IDEA, Eclipse, NetBeans, VS Code (with extensions)
* Build Tools:
  * Maven
  * Gradle
  * Ant (legacy)

## Deployment Methods

* JAR Files (`.jar`)
* Native images (via GraalVM)
* Platform-specific installers (JPackage)

## Use Cases

* Desktop applications (Swing, JavaFX)
* Command-line tools
* Server-side components
* Embedded software (with constrained environments)
* Backend microservices (Spring Boot, Quarkus, Micronaut)
