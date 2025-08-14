# Spring Boot Microservice with Hexagonal Architecture

## **About**

**Spring Boot Microservice with Hexagonal Architecture (Ports & Adapters)** marries a **cloud-ready runtime** (Spring Boot) with a **domain-centric internal structure** (Hexagonal). The result is a service that is **independently deployable** (microservices at the system level) and **technology-agnostic inside** (hexagonal at the application level).

## Why Spring Boot ?

* **Production-ready plumbing:** Actuator, health checks, metrics, observability.
* **Rapid delivery:** Auto-config, embedded server, opinionated starters.
* **Cloud native:** Easy containerization, smooth K8s integration, config via env/profiles.

## Why Hexagonal (Ports & Adapters) inside a microservice ?

* **Pure core:** Business logic sits at the center, unaware of frameworks, databases, or transport.
* **Stable boundaries:** Interactions with the outside world happen via **ports** (interfaces) and **adapters** (implementations).
* **Swapability:** We can replace infrastructure (e.g., REST → gRPC, Postgres → Mongo, Kafka → SQS) without changing the core.
* **Testability:** Core logic is trivial to unit-test; adapters are tested separately.

## How the pieces fit ?

* **System level:** Each Spring Boot service is a bounded context with its own database and API/event interfaces.
* **Application level:** Inside that service, hexagonal ensures strict separation:
  * **Core/domain** (use cases, domain model) depends on **ports**.
  * **Adapters** implement those ports for persistence, messaging, and delivery (HTTP, gRPC, CLI, schedulers).

## When teams choose this combo ?

* The domain is expected to **evolve** while infra choices may change.
* The service integrates with **multiple external systems** or protocols.
* There’s a need for **high test coverage** and **fast feedback** without heavy integration setups.

## Core Principles

#### 1) Domain at the Center (Independence from Frameworks)

* **Idea:** Business rules (entities, value objects, domain services, use cases) are pure code with **no Spring/JPA/Web** dependencies.
* **Why:** Keeps the core stable as frameworks, transports, and databases change.
* **Result:** We can switch REST→gRPC or JPA→Mongo with minimal domain edits (ideally none).

#### 2) Ports Define Capabilities, Not Technologies

* **Inbound Ports (Driving):** Interfaces that express **use cases** (e.g., `PlaceOrder`, `GetOrderStatus`).
* **Outbound Ports (Driven):** Interfaces the core **needs** from the outside (e.g., `OrderRepository`, `PaymentGateway`, `EventPublisher`).
* **Why:** Ports capture _business-facing_ contracts; tech choices are hidden behind adapters.

#### 3) Adapters Implement Ports for Specific Technologies

* **Primary (Inbound) Adapters:** REST controllers, gRPC services, message listeners, CLI/schedulers. They translate external requests → **inbound port calls**.
* **Secondary (Outbound) Adapters:** JPA repositories, Kafka producers/consumers, HTTP clients. They implement **outbound ports** required by the core.
* **Why:** Each adapter is replaceable (e.g., REST adapter → gRPC adapter) without touching use cases.

#### 4) Strict Dependency Direction (Inward Only)

* **Rule:** `Adapters → Ports → Core`.\
  The **core** depends only on **ports**; **adapters** depend on the **ports/core**, never the reverse.
* **Enforcement:** Package/module boundaries, CI checks (e.g., ArchUnit), code reviews.

#### 5) Clear Application Boundary and Ubiquitous Language

* **Boundary:** Everything that crosses the service boundary is **translated** at adapters (DTOs, mapping).
* **Language:** Inside the core, use domain language (DDD). Outside, speak protocol language (HTTP, Protobuf, Avro).
* **Why:** Prevents leaking HTTP/JPA/Avro types into domain; keeps domain expressive and stable.

#### 6) Orchestration vs. Rules (Use Cases vs. Domain)

* **Use Cases (Application core):** Sequence steps, call ports, manage transactions, emit domain events.
* **Domain Services/Entities:** Hold **business invariants** and calculations.
* **Why:** Separates workflow (use case) from rules (domain), improving readability and testability.

#### 7) Transaction & Consistency Boundaries at Use Cases

* **Pattern:** Start/commit transactions at **use-case level** (through a small transactional boundary), not in controllers/entities.
* **Why:** Keeps consistency concerns central, avoids scattering `@Transactional` across adapters.

#### 8) Event-First Mindset (Optional but Natural)

* **Domain Events:** Core raises events (e.g., `OrderPlaced`), captured and published by an **outbound adapter** (often via an **Outbox**).
* **Why:** Enables reliable async flows and decoupling from downstream services.

#### 9) Testing Strategy Aligned to Boundaries

* **Core tests:** Pure unit tests on use cases and domain; no Spring context.
* **Adapter tests:** Slice/integration tests for JPA, Web, messaging adapters.
* **Contract tests:** API/schema compatibility (OpenAPI, protobuf, Pact).
* **Why:** Fast feedback loops for logic; targeted integration confidence for technology edges.

#### 10) Spring Boot as Composition, Not a Crutch

* **Use Spring for:** DI, configuration, actuator, http endpoints, data/messaging starters.
* **Avoid:** Letting Spring annotations/types leak into core. Keep them at adapters/config only.
* **Why:** Retains the swapability promise of hexagonal.

#### 11) Private Data, Public Contracts

* **Data:** Each microservice owns its DB (no shared tables).
* **Contracts:** Interact via APIs/events; version them carefully.
* **Why:** Preserves service autonomy and supports independent evolution.

#### 12) Observability at the Edges

* **Where:** Controllers, message listeners, and outbound clients log/trace/metric at the boundary.
* **Why:** We see latency/errors where they occur without polluting the domain with operational concerns.

## **Key Components**

#### 1) **Domain Layer (Core)**

* **Purpose:** Represents pure business logic and rules, independent of frameworks and external tech.
* **Contents:**
  * **Entities:** Rich domain objects with business invariants (e.g., `Order`, `Customer`).
  * **Value Objects:** Immutable objects representing concepts with equality by value (e.g., `Money`, `Email`).
  * **Domain Services:** Encapsulate business logic spanning multiple entities (e.g., `PaymentCalculator`).
  * **Domain Events:** Immutable events indicating something meaningful happened (`OrderPlaced`).
* **Spring Boot Note:** No Spring annotations; pure Java/Kotlin classes.

#### 2) **Application Layer (Use Cases)**

* **Purpose:** Orchestrates domain logic, coordinates between ports, enforces transaction boundaries.
* **Contents:**
  * **Inbound Port Interfaces:** Define service-level operations (e.g., `PlaceOrderUseCase`).
  * **Use Case Implementations:** Contain orchestration (e.g., call repository port, publish event).
  * **Transaction Handling:** Often annotated with `@Transactional` here.
* **Spring Boot Note:** Minimal Spring usage; may use `@Service` for DI convenience, but still tech-agnostic.

#### 3) **Inbound Adapters (Primary)**

* **Purpose:** Receive input from external actors and translate into **inbound port calls**.
* **Examples:**
  * **REST Controller:** Accepts HTTP requests, maps DTO → domain commands, calls use case.
  * **gRPC Service:** Maps Protobuf request → domain request.
  * **Message Listener:** Consumes Kafka/RabbitMQ events, maps payload to command.
  * **CLI/Scheduled Job:** Triggers internal operations.
* **Spring Boot Note:** Uses `@RestController`, `@MessageListener`, `@Scheduled`, etc.

#### 4) **Outbound Adapters (Secondary)**

* **Purpose:** Implement outbound ports to interact with external systems.
* **Examples:**
  * **Persistence Adapter:** Implements `OrderRepositoryPort` using JPA/Hibernate/MyBatis.
  * **Messaging Adapter:** Publishes domain events to Kafka/RabbitMQ.
  * **External API Adapter:** Calls payment service via HTTP.
  * **File Storage Adapter:** Writes/reads from S3 or local FS.
* **Spring Boot Note:** Uses `@Repository`, `RestTemplate/WebClient`, Spring Cloud Stream binders, etc.

#### 5) **Ports**

* **Inbound Ports (Driving):**
  * Interfaces defining **what** the service can do from a business perspective.
  *   Example:

      ```java
      public interface PlaceOrderUseCase {
          OrderResponse placeOrder(OrderCommand command);
      }
      ```
* **Outbound Ports (Driven):**
  * Interfaces defining **what** the service needs from infrastructure.
  *   Example:

      ```java
      public interface OrderRepositoryPort {
          Order save(Order order);
          Optional<Order> findById(OrderId id);
      }
      ```

#### 6) **Configuration Layer**

* **Purpose:** Wires everything together using Spring Boot’s DI and configuration management.
* **Contents:**
  * Bean definitions linking ports to adapters.
  * Property-based configuration for DB, message broker, API clients.
  * Conditional beans for environment-specific wiring.
* **Spring Boot Note:** Use `@Configuration` classes; avoid putting wiring logic in business code.

#### 7) **Cross-Cutting Concerns**

* **Logging & Observability:** Implemented at adapters (inbound & outbound) - use `@ControllerAdvice`, interceptors, or filters.
* **Security:** Handled at inbound adapters (Spring Security filters/controllers).
* **Validation:** At the edges (DTO validation via `@Valid`), domain invariants enforced inside core.
* **Error Handling:** Map domain errors to HTTP status codes or error events at adapters.

#### 8) **Database & Messaging Boundaries**

* **Pattern:** Each microservice owns its own persistence and messaging contracts.
* **Spring Boot Note:** Use separate schemas or databases; never share entity classes across services.

#### 9) **Testing Components**

* **Unit Tests:** Core domain and use cases (no Spring context).
* **Integration Tests:** Adapters with actual DB or broker (using Testcontainers).
* **Contract Tests:** Ensure external-facing APIs and events remain backward-compatible.

#### 10) **Package Structure Example**

```
com.example.orders
 ├── application
 │    ├── port
 │    │    ├── inbound
 │    │    └── outbound
 │    └── service
 ├── domain
 │    ├── model
 │    ├── event
 │    └── service
 ├── adapter
 │    ├── inbound
 │    │    ├── rest
 │    │    ├── messaging
 │    │    └── scheduler
 │    └── outbound
 │         ├── persistence
 │         ├── messaging
 │         └── external
 └── config
```

## Execution Flow (Framework-Agnostic Core, Spring Boot Outer Shell)

The execution in this setup follows the **Hexagonal Architecture principle**: the _core logic_ is **pure Java**, while Spring Boot lives only in the **outer adapters**. This allows the service to run with any framework in the future - Spring Boot today, Micronaut or Quarkus tomorrow - without rewriting the core.

#### 1. **Request Entry (Inbound Adapter)**

* **Who:** Spring Boot REST controller (`@RestController`) or gRPC endpoint.
* **Role:** Translates external request format (HTTP JSON, gRPC binary) into domain-level input.
* **Note:** This is _the only place_ where HTTP annotations, request mappings, or framework-specific code appears.
*   **Flow:**

    ```
    HTTP Request → REST Controller → Inbound Port (interface in core)
    ```

#### 2. **Application Layer (Inside Core – Framework-Free)**

* **Who:** Application service (implements a **use case**) defined by the inbound port.
* **Role:** Coordinates the request, applies business rules, calls domain services/entities, and triggers outbound ports if needed.
* **Note:**
  * No `@Service`, `@Transactional`, or Spring imports here.
  * This layer depends **only** on interfaces (ports) - no technology-specific details.

#### 3. **Domain Layer (Inside Core – Framework-Free)**

* **Who:** Entities, value objects, domain services.
* **Role:** Encapsulates business rules and domain logic.
* **Note:**
  * Absolutely no dependency on Spring Boot or any external libraries.
  * Fully unit-testable without a Spring context.

#### 4. **Outbound Port Invocation (Interface in Core)**

* **Who:** Outbound port (interface) defined in the application layer.
* **Role:** Describes what needs to be done (e.g., "persist order", "publish event") without saying _how_.
* **Note:** Implementation comes from an outbound adapter in the outer shell.

#### 5. **Outbound Adapter (Framework-Dependent)**

* **Who:** Spring Data JPA repository, Kafka producer, external API client, etc.
* **Role:** Implements the outbound port using a specific technology.
* **Note:**
  * This is where Spring Boot, JPA, JDBC, WebClient, or Kafka APIs are used.
  * Swapping persistence from PostgreSQL to MongoDB affects _only_ this layer.

#### 6. **Response Assembly (Inbound Adapter)**

* **Who:** The same Spring Boot controller that handled the request.
* **Role:** Converts domain-level output into an external format (JSON, XML, Protobuf).
*   **Flow:**

    ```
    Outbound Result → Application Layer → Controller → HTTP Response
    ```

## **Hexagonal vs. Clean Architecture in Spring Boot**

While both Hexagonal Architecture and Clean Architecture share the goal of separating business logic from infrastructure, there are **practical differences** in a Spring Boot implementation:

1. **Dependency Flow**
   * **Hexagonal:** Emphasizes _direction of dependencies_ through _ports and adapters_. Spring Boot is confined to the adapters (controllers, repositories, message listeners).
   * **Clean Architecture:** Organizes code in concentric layers, but in a Spring Boot setup, it’s common for framework annotations like `@Service`, `@Repository`, or `@Configuration` to appear deeper in the core, sometimes leaking framework dependencies inward.
2. **Framework Coupling**
   * **Hexagonal:** Core domain and application layers remain **100% Spring-agnostic**. We could literally copy the `core` package into a non-Spring project and it would compile.
   * **Clean Architecture:** While theoretically framework-independent, in practice with Spring Boot, beans and annotations often exist in the use case layer for convenience (e.g., transaction management via `@Transactional`).
3. **Testing Approach**
   * **Hexagonal:** We can run all core unit tests without starting the Spring context because the core doesn’t depend on Spring. Adapters are tested separately with Spring Boot Test slices.
   * **Clean Architecture:** If annotations and beans are in the core, some “unit” tests may require Spring context, making them heavier.
4. **Service Wiring**
   * **Hexagonal:** In Spring Boot, adapters are injected into ports at application startup, often via configuration classes or direct constructor injection in the adapter layer.
   * **Clean Architecture:** Dependency injection happens more freely between layers, and the framework might manage the wiring throughout all layers, not just the edges.

{% hint style="warning" %}
Hexagonal architecture in Spring Boot enforces a _stricter outer-shell-only Spring usage_, while Clean Architecture may be more lenient, sometimes letting Spring features leak into inner layers for convenience.
{% endhint %}
