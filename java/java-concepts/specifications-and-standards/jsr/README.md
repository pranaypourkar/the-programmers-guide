# JSR

## About

A **Java Specification Request (JSR)** is a formal proposal submitted to define a new standard or enhancement to the Java platform. It is part of the **Java Community Process (JCP)** — the official process by which the Java language, libraries, and technologies evolve.

Each JSR is a document that describes proposed specifications, APIs, or features intended to be incorporated into the Java platform. A JSR can range from a minor library enhancement to the definition of an entirely new Java technology.

## Why JSRs Exist ?

* **Standardization**: JSRs ensure that Java APIs and technologies evolve in a **consistent, predictable, and open** manner.
* **Interoperability**: By following standardized specifications, Java applications and libraries are more likely to be interoperable across vendors and platforms.
* **Community Collaboration**: JSRs allow the **global Java community** (including developers, vendors, and academia) to contribute to the growth of the platform through expert input.
* **Backward Compatibility**: JSRs often include guidelines to maintain compatibility with older versions of Java, helping the ecosystem stay stable.

## Who Manages JSRs?

JSRs are managed by the **Java Community Process (JCP)**, a formalized mechanism introduced by Sun Microsystems (now part of Oracle).

* The **JCP Executive Committee** oversees the process.
* Each JSR is led by one or more **Spec Leads**, often from large Java-centric organizations (e.g., Oracle, Red Hat, IBM).
* **Expert Groups** are formed to collaboratively draft and refine the specifications.

## Structure of a JSR

A JSR typically contains:

* **Specification Document**: The formal written standard describing the API, behavior, and semantics.
* **Reference Implementation (RI)**: A working implementation that conforms to the specification, demonstrating its viability.
* **Technology Compatibility Kit (TCK)**: A suite of tests that verifies whether an implementation adheres to the specification.

Every JSR must provide both the RI and TCK to be considered complete.

## JSR Lifecycle

1. **JSR Submission**\
   A spec lead submits a proposal to the JCP Executive Committee.
2. **Review Period**\
   The proposal undergoes community review for comments and feedback.
3. **Expert Group Formation**\
   Approved JSRs form an expert group composed of members from the Java community.
4. **Early Draft Review**\
   A preliminary draft is shared with the public for comments.
5. **Public Review and Ballots**\
   The specification is reviewed multiple times and voted on by the Executive Committee.
6. **Proposed Final Draft**\
   The final draft is created, including the RI and TCK.
7. **Final Approval Ballot**\
   The final JSR is voted on. Upon approval, it becomes an official part of the Java platform.
8. **Maintenance and Revisions**\
   JSRs can be updated via Maintenance Releases to fix issues or make enhancements.

## Categories of JSRs

JSRs can apply to various editions of the Java platform:

* **Java SE (Standard Edition)**: Core Java libraries, language enhancements, and JVM improvements.
* **Java EE (Enterprise Edition)**: APIs for enterprise-level applications like Servlets, JPA, JMS, etc.
* **Java ME (Micro Edition)**: Specifications for embedded and mobile devices.
* **JavaFX** (discontinued under JSR but once defined UI components and behavior for rich clients).

#### **Examples of Important JSRs**

Here are some widely adopted and influential JSRs:

### **Java SE (Core)**

* **JSR 269** – _Pluggable Annotation Processing API_\
  Defines how annotation processors are invoked during compilation.
* **JSR 292** – _Supporting Dynamically Typed Languages on the JVM_\
  Introduced the `invokedynamic` instruction, aiding performance for dynamic languages like Groovy and Kotlin.
* **JSR 335** – _Lambda Expressions for the Java Programming Language_\
  Introduced lambdas and the Stream API in Java 8.

### **Java EE (Enterprise)**

* **JSR 315** – _Java Servlet 3.0 Specification_\
  Modernized Servlets to support asynchronous processing.
* **JSR 338** – _Java Persistence API (JPA) 2.1_\
  Standardized object-relational mapping (ORM) in Java.
* **JSR 370** – _JAX-RS 2.1: The Java API for RESTful Web Services_\
  Defined standard APIs for building RESTful services.

### **Recent Platform-wide Specifications**

* **JSR 376** – _Java Platform Module System (JPMS)_\
  Introduced modularity to the Java platform in Java 9.
* **JSR 388** – _Java SE 13 Platform Specification_\
  Updated the Java SE platform with new features and APIs.

## How JSRs Impact Developers and the Industry ?

### Benefits for Developers

* **Reliable APIs**: Developers can depend on consistent, tested APIs.
* **Ecosystem Compatibility**: Applications and libraries that implement or use JSR-compliant components are likely to be interoperable.
* **Future-Proofing**: Since JSRs often evolve with backward compatibility, software built on JSRs remains relevant across multiple Java versions.

### Benefits for Vendors

* **Certification**: Vendors can build tools and environments (e.g., application servers) that are JSR-compliant, giving assurance to clients.
* **Credibility**: Following a recognized standard ensures higher market trust.

## How JSRs Differ from Other Standards (Like ISO) ?

<table data-full-width="true"><thead><tr><th width="162.30859375">Aspect</th><th>JSR</th><th>ISO</th></tr></thead><tbody><tr><td>Scope</td><td>Java Platform (language, libraries, APIs)</td><td>Broad (global standards across industries)</td></tr><tr><td>Governing Body</td><td>Java Community Process (JCP)</td><td>International Organization for Standardization</td></tr><tr><td>Participation</td><td>Open to Java community (experts, vendors, developers)</td><td>Representatives from national standards bodies</td></tr><tr><td>Focus</td><td>Language-specific innovations and consistency</td><td>Industry-wide best practices and protocols</td></tr><tr><td>Implementation</td><td>Reference Implementation + TCK mandatory</td><td>May or may not require implementation</td></tr></tbody></table>

