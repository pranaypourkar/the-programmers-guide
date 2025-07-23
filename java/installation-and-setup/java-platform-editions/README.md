# Java Platform Editions

## About

Java is not a single monolithic platform — it consists of multiple editions, each tailored for different use cases.

## Java Platform Edition Timeline

<table data-header-hidden><thead><tr><th width="88.66796875"></th><th></th></tr></thead><tbody><tr><td>Year</td><td>Event</td></tr><tr><td>1996</td><td>Java SE 1.0 released</td></tr><tr><td>1999</td><td>Java EE (J2EE) introduced</td></tr><tr><td>2000</td><td>Java ME introduced for embedded/mobile</td></tr><tr><td>2004</td><td>Java EE 5 brings annotations, EJB 3.0</td></tr><tr><td>2008</td><td>JavaFX announced by Sun</td></tr><tr><td>2011</td><td>Oracle acquires Sun; continues Java stewardship</td></tr><tr><td>2017</td><td>Java EE 8 released (last under Oracle)</td></tr><tr><td>2018</td><td>Java EE donated to Eclipse Foundation</td></tr><tr><td>2019</td><td>Jakarta EE 8 (javax namespace, Eclipse maintained)</td></tr><tr><td>2020</td><td>Jakarta EE 9 (migration to <code>jakarta.*</code>)</td></tr><tr><td>2022</td><td>Jakarta EE 10 with new features</td></tr><tr><td>2023</td><td>Jakarta EE 11 development with Java 17 base</td></tr></tbody></table>

## 1. Java SE (Standard Edition)

### Overview

* **Purpose**: Provides the core functionality and foundation for all other Java editions.
* **Components**:
  * JVM (Java Virtual Machine)
  * JDK (Java Development Kit)
  * Core Libraries (`java.lang`, `java.util`, `java.io`, `java.net`, etc.)
  * Development tools (`javac`, `java`, `javadoc`, `jdb`, etc.)

### Use Cases

* General-purpose applications
* Desktop applications
* Server-side applications (when not using full EE stack)
* Library development

### Key APIs and Features

* Collections Framework
* Concurrency Utilities
* Streams API
* Lambda Expressions
* Generics
* I/O and NIO
* Exception Handling
* Memory Management (Garbage Collector)

### Versioning and Updates

* Released every 6 months (March and September)
* Long-Term Support (LTS) versions: Java 8, 11, 17, 21

### Licensing

* Oracle JDK: Commercial and free usage restrictions
* OpenJDK: Open-source alternative with the same features

## 2. Java EE (Enterprise Edition)

### Overview

* **Purpose**: For building large-scale, distributed, multi-tiered enterprise applications.
* **Builds On**: Java SE

### Key Components (javax.\* namespace)

* Servlet, JSP, JSF (Web Layer)
* EJB (Business Layer)
* JPA (Persistence)
* JAX-RS, JAX-WS (Web Services)
* JMS (Messaging)
* CDI (Dependency Injection)
* Bean Validation (javax.validation)
* Security, Transactions, Interceptors

### Application Servers

* GlassFish
* WebLogic
* WebSphere
* JBoss / WildFly

### Lifecycle

* Java EE 5 (2006): Major revamp with annotations, EJB 3.0
* Java EE 6 (2009): CDI, Servlet 3.0, REST API support
* Java EE 7 (2013): WebSocket, JSON-P, Batch API
* Java EE 8 (2017): Bean Validation 2.0, JSON-B

#### Final Release: Java EE 8 (2017)

## 3. Jakarta EE (Successor of Java EE)

### Overview

* **Governance**: Managed by the Eclipse Foundation
* **Purpose**: Continue evolving enterprise Java under open governance
* **Key Change**: Namespace transition from `javax.*` to `jakarta.*`

### Versions and Features

* **Jakarta EE 8 (2019)**:
  * Identical to Java EE 8 but under Eclipse governance
* **Jakarta EE 9 (2020)**:
  * Complete namespace change to `jakarta.*`
  * No new features
* **Jakarta EE 10 (2022)**:
  * New features in Servlet, CDI, REST, Faces
  * Java SE 11+ required
* **Jakarta EE 11 (2024)**:
  * Introduced modularity and better container integration

### Compatibility

* Requires Java SE 11+ (depending on version)
* Works with modern containers and cloud-native platforms

### Modern Application Servers

* Payara
* WildFly
* Open Liberty
* TomEE

## 4. Java ME (Micro Edition)

### Overview

* **Purpose**: Platform for embedded systems and mobile devices with limited resources
* **Builds On**: Java SE (subset)

### Configurations and Profiles

* CLDC (Connected Limited Device Configuration)
* CDC (Connected Device Configuration)
* MIDP (Mobile Information Device Profile)

### APIs

* javax.microedition.\*
* Lightweight UI Toolkit (LWUIT)

### Use Cases

* Set-top boxes
* Smart cards
* Older mobile devices (pre-smartphone era)

### Decline

* Replaced by Android and other IoT technologies

## 5. JavaFX

### Overview

* **Purpose**: Rich client application development
* **Replacement For**: AWT, Swing

### Features

* Scene Graph-based UI framework
* FXML (XML-based UI markup)
* CSS Styling
* Media & WebView
* 2D/3D Graphics

### Status

* Bundled until Java 11, now maintained separately as OpenJFX

### Usage

* Standalone desktop apps
* UI for embedded devices

