# Trends in Practice

## About

In theory, architectural styles are often taught as **distinct, isolated patterns** - each with its own definitions, boundaries, and rules.\
In practice, however, **real-world software rarely follows a single style in its purest form**. Modern systems blend **System-Level** and **Application-Level** styles, adapt patterns to fit business goals, and evolve organically as requirements change.

The reality is shaped by:

* **Business Constraints** – Deadlines, budgets, and changing priorities often dictate which patterns can be applied.
* **Team Capabilities** – Smaller teams may avoid over-engineering, while larger organizations may favor patterns that promote maintainability and scale.
* **Technology Ecosystem** – Frameworks like **Spring Boot**, **.NET Core**, or **Node.js** may nudge developers toward certain styles through built-in conventions.
* **Deployment Environment** – Cloud-native platforms, container orchestration (Kubernetes), and serverless offerings influence both system-level and application-level choices.

This results in **hybrid architectures** - where a single system might use:

* **Microservices** (system-level) with **Clean Architecture** or **Hexagonal Architecture** inside each service.
* A **Monolith** (system-level) organized using **Layered Architecture** or **Modular Monolith** patterns.
* **Event-Driven** systems with **Hexagonal** components for message handling.

Understanding these trends is essential because:

* It reflects **how architecture actually works in production**, not just in textbooks.
* It helps teams choose patterns that are **practical and adaptable**, rather than chasing “pure” architectures that don’t align with constraints.
* It offers insight into **trade-offs and evolution paths** — knowing what works today and how it might scale tomorrow.

## **Common Combinations in Real World**

Most production systems combine a **System-Level** style with an **Application-Level** style.\
The **System-Level** choice determines **how the system is deployed, scaled, and interacts between components**, while the **Application-Level** choice defines **how code is structured inside each component**.

#### **Table: Common Real-World Style Combinations**

<table data-header-hidden data-full-width="true"><thead><tr><th width="138.703125"></th><th width="236.046875"></th><th></th></tr></thead><tbody><tr><td><strong>System-Level Style</strong></td><td><strong>Common Application-Level Pairings</strong></td><td><strong>Example Scenario</strong></td></tr><tr><td><strong>Monolith</strong></td><td>Layered Architecture, Modular Monolith, Clean Architecture</td><td>Enterprise ERP system in a single deployable unit with well-separated layers for UI, business, and persistence.</td></tr><tr><td><strong>Microservices</strong></td><td>Clean Architecture, Hexagonal Architecture, Onion Architecture</td><td>Spring Boot microservices, each with domain-driven design principles and ports/adapters for external integrations.</td></tr><tr><td><strong>Serverless</strong></td><td>Event-Driven Architecture, Hexagonal Architecture</td><td>AWS Lambda functions processing events with clear separation between handler logic and domain rules.</td></tr><tr><td><strong>Event-Driven System</strong></td><td>Hexagonal Architecture, CQRS + Event Sourcing</td><td>Real-time stock trading system using Kafka events with ports/adapters for producers and consumers.</td></tr></tbody></table>

#### **Why These Combinations Happen ?**

* **Microservices + Clean/Hexagonal** → Each service needs **independence and testability**, so clear boundaries between core logic and external interfaces are critical.
* **Monolith + Layered** → Simpler to implement, especially for smaller teams, while still enforcing logical separation.
* **Serverless + Event-Driven** → Naturally fits the stateless, trigger-based execution model.
* **Event-Driven + Hexagonal** → Encourages pluggable event handlers and separation from infrastructure code.

## **Why These Combinations Happen ?**

In practice, architecture decisions are rarely made in isolation. The combinations we see most often in real systems emerge from a mix of **technical constraints**, **organizational factors**, and **operational realities**.

#### **1. Microservices + Clean Architecture / Hexagonal Architecture**

* **Reason**: Microservices demand **independent deployability, scalability, and maintainability**. Clean and Hexagonal architectures enforce **clear separation between domain logic and infrastructure**, making each service easier to evolve without breaking contracts.
* **Example**: A Spring Boot–based order service that uses Hexagonal Architecture - the domain layer is insulated from REST controllers, message consumers, and database adapters.
* **Benefit**: Services can be replaced, rewritten, or scaled independently with minimal ripple effects.

#### **2. Monolith + Layered / Modular Monolith**

* **Reason**: Many applications don’t need distributed complexity early on. A layered or modular monolith allows teams to maintain **logical separation of concerns** within a single deployment unit.
* **Example**: An internal HR management system where UI, business logic, and persistence layers are separated but deployed together.
* **Benefit**: Lower operational overhead while preserving structure for potential future decomposition into services.

#### **3. Serverless + Event-Driven / Hexagonal**

* **Reason**: Serverless functions are inherently **trigger-based and stateless**. Pairing them with Event-Driven or Hexagonal styles allows clean input/output boundaries and easy integration with multiple event sources.
* **Example**: AWS Lambda processing S3 file upload events, using a Hexagonal pattern to decouple core processing logic from S3 SDK code.
* **Benefit**: Scalability on demand, minimal infrastructure management, and clean maintainable code.

#### **4. Event-Driven Systems + Hexagonal / CQRS**

* **Reason**: Event-driven architectures benefit from **decoupling producers and consumers**. Hexagonal ensures message handling logic is independent of transport or broker implementation; CQRS helps separate read and write workloads for scalability.
* **Example**: A stock trading platform where orders are written to an event store and projected asynchronously for read queries.
* **Benefit**: High scalability, resilience, and flexibility in swapping infrastructure components.

## **Industry Trends**

The evolution of architectural styles over the last two decades has been driven by **changes in business demands, technology ecosystems, and operational tooling**.\
What was once a purely academic choice is now influenced by **cloud-native platforms, DevOps culture, and rapid product iteration needs**.

#### **1. Pre-2010: Monolith Dominance**

* **Typical Choice**: Monolith + Layered Architecture
* **Reason**:
  * Infrastructure was expensive, and scaling horizontally was not trivial.
  * Deployment pipelines were slower, making single deployable units easier to manage.
* **Example**:
  * Java EE enterprise applications with strict UI → Service → DAO layers.

#### **2. 2010–2015: Rise of Microservices**

* **Catalysts**:
  * Amazon, Netflix, and other internet-scale companies publicly shared their microservices success stories.
  * Containerization (Docker, 2013) made independent service packaging easier.
* **Typical Pairing**: Microservices + Clean Architecture or Hexagonal Architecture.
* **Effect**:
  * Allowed scaling different parts of the system independently.
  * Introduced operational complexity (service discovery, distributed tracing).

#### **3. 2015–2020: Serverless and Event-Driven Growth**

* **Catalysts**:
  * AWS Lambda (2014) and other Function-as-a-Service platforms.
  * Popularity of Kafka, Kinesis, and other event streaming platforms.
* **Typical Pairing**: Serverless + Event-Driven Architecture, or Microservices + Event-Driven backbone.
* **Effect**:
  * Enabled fine-grained scaling and cost optimization.
  * Encouraged more asynchronous and decoupled workflows.

#### **4. 2020–Present: Hybrid & Polyglot Architectures**

* **Trends**:
  * Companies mix styles: e.g., **Microservices for core business domains**, **Serverless for auxiliary tasks**, **Monolith for legacy modules**.
  * Polyglot persistence (using different databases per service) is common.
* **Application-Level Patterns**:
  * Clean Architecture and Hexagonal dominate in modern service design.
  * Domain-Driven Design principles increasingly applied.

#### **5. The Current Shift**

* **Simplification Movement**:
  * Teams burned by microservices complexity are moving towards **Modular Monoliths** for certain products.
  * Event-driven architectures are becoming the backbone of even monolithic deployments for scalability.
* **Cloud-Native Tooling**:
  * Kubernetes, Service Meshes (Istio/Linkerd), and managed event brokers reduce operational friction.
