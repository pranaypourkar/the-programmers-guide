# How System-Level and Application-Level Work Together ?

## About

In real-world software systems, **System-Level** and **Application-Level** architectures are **not competing choices** - they operate at **different layers of decision-making** and complement each other.

Think of it like **city planning vs. building architecture**:

* **System-Level Architecture** is the **city plan** - it decides how different buildings (applications/services) are laid out, connected, and scaled.
* **Application-Level Architecture** is the **building design** - it defines how each building (application) is structured internally to meet its purpose.

{% hint style="success" %}
**System-level architecture** decides the _shape of the system_: how many deployable units exist, how they communicate (HTTP, gRPC, events), how they scale, and how they’re operated (deployments, observability, resilience).

**Application-level architecture** decides the _shape of each unit_: how its code is organized, where business rules live, and how the unit keeps infrastructure concerns at arm’s length.
{% endhint %}

## **System-Level Focus**

* **Scope**: Entire distributed system or product suite.
* **Decisions Involve**:
  * Service boundaries (Monolith vs Microservices)
  * Deployment model (Serverless vs Containerized)
  * Communication style (REST, messaging, event-driven)
  * Scaling approach (horizontal/vertical)
* **Analogy**: Deciding whether the “city” will have a single skyscraper (Monolith) or multiple smaller buildings connected by roads (Microservices).

## **Application-Level Focus**

* **Scope**: The internal structure of a single application or service.
* **Decisions Involve**:
  * Code organization (Layered, Hexagonal, Clean, etc.)
  * Dependency flow and boundaries
  * Testing strategy and maintainability
  * Technology independence
* **Analogy**: Deciding how rooms, wiring, and plumbing are arranged **inside** a building to make it functional and maintainable.

## **How They Interact in Practice ?**

1. **Choose System-Level Style First**
   * Start by defining how the overall system will be composed and deployed.
   * Example: Decide between Monolith, Microservices, Serverless, or Event-Driven.
2. **Apply Application-Level Style Within Each Unit**
   * Once the system-level unit is decided, design **each application** using an appropriate internal architecture.
   * Example:
     * Microservice → Use Hexagonal Architecture to isolate core logic.
     * Monolith → Use Modular Monolith with Clean Architecture principles.
3. **Consistency vs. Flexibility**
   * You can use **different application-level styles** for different components of the same system.
   * Example:
     * A reporting service might use Layered Architecture (simple).
     * A payment service might use Hexagonal Architecture (complex integrations).
4. **Evolution Over Time**
   * The **System-Level style can evolve** (Monolith → Microservices) while keeping **Application-Level architecture consistent** within services to ease migration.

## **Example Mapping Table**

<table><thead><tr><th width="226.05859375">System-Level Style</th><th>Typical Application-Level Styles Used Inside</th></tr></thead><tbody><tr><td>Monolith</td><td>Layered, Modular Monolith, Clean</td></tr><tr><td>Microservices</td><td>Hexagonal, Clean, Onion</td></tr><tr><td>Serverless</td><td>Hexagonal (for function orchestration), Lightweight Layered</td></tr><tr><td>Event-Driven</td><td>Hexagonal, Modular Monolith, Microkernel</td></tr></tbody></table>
