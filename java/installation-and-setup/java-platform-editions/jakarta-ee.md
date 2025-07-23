# Jakarta EE

## About

Jakarta EE is the open-source successor to Java EE, managed by the Eclipse Foundation. It provides a robust platform for building modern, cloud-native, and enterprise-level Java applications. Jakarta EE builds upon Java EE, preserving its core APIs while modernizing the platform.

* **Formerly**: Java EE (donated by Oracle in 2017)
* **Governing Body**: Eclipse Foundation
* **Namespace Change**: `javax.*` → `jakarta.*` starting from Jakarta EE 9
* **Goal**: Enable vendor-neutral, cloud-native enterprise Java development
* **Foundation**: Built on Java SE

{% hint style="info" %}
Key objectives behind it

* Modernization of the platform
* Open governance and community-driven
* Cloud-native readiness
* Backward compatibility where possible
{% endhint %}

## Jakarta EE Versions

<table data-header-hidden><thead><tr><th width="165.05078125"></th><th width="150.19921875"></th><th></th></tr></thead><tbody><tr><td>Jakarta EE Version</td><td>Release Year</td><td>Key Highlights</td></tr><tr><td>Jakarta EE 8</td><td>2019</td><td>Identical to Java EE 8 but under Eclipse governance</td></tr><tr><td>Jakarta EE 9</td><td>2020</td><td>Big-bang namespace change: <code>javax.*</code> → <code>jakarta.*</code></td></tr><tr><td>Jakarta EE 9.1</td><td>2021</td><td>Java 11 support</td></tr><tr><td>Jakarta EE 10</td><td>2022</td><td>Major updates, new APIs, pruning of outdated tech</td></tr><tr><td>Jakarta EE 11</td><td>Expected 2024</td><td>Java 21 support, further modularization (planned)</td></tr></tbody></table>

## Major Specifications (APIs)

#### Web Tier

* Jakarta Servlet: HTTP request/response lifecycle
* Jakarta Server Pages (JSP)
* Jakarta Faces (JSF): Component-based UI framework
* Jakarta Expression Language (EL)

#### Business Logic Tier

* Jakarta CDI (Contexts and Dependency Injection)
* Jakarta EJB (Enterprise JavaBeans): Stateful/stateless services (minimized use today)

#### Persistence & Data Access

* Jakarta Persistence (JPA)
* Jakarta Transactions (JTA)

#### Messaging and Integration

* Jakarta Messaging (JMS): Queues and Topics
* Jakarta Connectors (JCA)
* Jakarta Mail

#### Web Services

* Jakarta RESTful Web Services (JAX-RS)
* Jakarta XML Web Services (JAX-WS)

#### Other APIs

* Jakarta Bean Validation: Validation constraints (formerly `javax.validation`)
* Jakarta JSON Processing (JSON-P)
* Jakarta JSON Binding (JSON-B)
* Jakarta Security
* Jakarta Batch

## Deployment Models

* **WAR**: Web Applications
* **EAR**: Enterprise Applications
* **Microservices**: Via runtime optimizations and MicroProfile integration

## Application Servers Supporting Jakarta EE

* **GlassFish**: Reference implementation
* **Payara Server**: Production-ready fork of GlassFish
* **WildFly / JBoss EAP**
* **Open Liberty (IBM)**
* **Apache TomEE**
* **WebLogic**: Partial support through Jakarta EE compatibility

## Tooling & Development Ecosystem

* **IDEs**: Eclipse, IntelliJ IDEA Ultimate, NetBeans
* **Build Tools**: Maven, Gradle
* **Testing**:
  * Arquillian
  * JUnit, TestNG
  * Integration testing using Testcontainers

## Advantages Over Java EE

* Open governance (Eclipse Foundation)
* Faster release cycles
* Designed for cloud-native and Kubernetes environments
* Removal of deprecated/legacy components
* Improved modularity
* New APIs and enhancements

## Compatibility

* Jakarta EE 8 apps can run on Jakarta EE 9 servers via compatibility mode
* Java SE version alignment:
  * Jakarta EE 8 → Java 8
  * Jakarta EE 9.1 → Java 11
  * Jakarta EE 10+ → Java 17 / 21
