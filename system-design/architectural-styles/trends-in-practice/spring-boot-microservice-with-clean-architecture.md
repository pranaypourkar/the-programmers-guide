# Spring Boot Microservice with Clean Architecture

## About

**System-Level Style** → **Microservices**:\
Each business capability is packaged as an independently deployable Spring Boot application, running as a separate service in a distributed environment.

**Application-Level Style** → **Clean Architecture**:\
Inside each microservice, the codebase is structured so that **business rules are at the center** and are independent of frameworks, databases, and external systems.

This pairing is widely adopted because it strikes a **balance between scalability and maintainability**.

## **Why Spring Boot for Microservices ?**

* **Rapid Development** → Auto-configuration, embedded Tomcat/Jetty, and minimal boilerplate let developers spin up services quickly.
* **Production-Ready Features** → Actuator endpoints, health checks, metrics, and built-in Spring Security integrations make operationalizing microservices easier.
* **Cloud & Container Friendly** → Spring Boot apps package neatly into JARs or Docker images, and integrate easily with Kubernetes, AWS ECS, or other orchestrators.

## **Why Clean Architecture Inside a Microservice ?**

* **Separation of Concerns** → Core business logic is insulated from infrastructure concerns like persistence, messaging, and APIs.
* **Testability** → Business rules can be tested without involving databases, message queues, or external services.
* **Flexibility** → Technology stack decisions (database type, REST vs. gRPC, etc.) can evolve without rewriting business rules.

## **Core Principles**

This approach blends **System-Level principles** from **Microservices** and **Application-Level principles** from **Clean Architecture** into a single cohesive model.

#### **1. Single Responsibility at Two Levels**

* **System-Level**:\
  Each microservice represents a **bounded context** in Domain-Driven Design (DDD), owning a single high-level business capability (e.g., Payment Service, Order Service).
* **Application-Level**:\
  Within a service, Clean Architecture enforces separation between **business logic**, **application orchestration**, and **infrastructure**.

**Benefit** → Teams can evolve services independently, while also keeping internal codebases clean and modular.

#### **2. Dependency Rule**

* **Clean Architecture Mandate**:\
  Code dependencies point **inward** toward the domain, never outward toward frameworks or databases.
* **In Spring Boot Terms**:\
  Controllers, repositories, and messaging adapters depend on **application services** and **domain models**, but **domain code never imports Spring or JPA packages**.

**Benefit** → The domain is framework-agnostic and can survive technology migrations.

#### **3. Loose Coupling Between Services**

* Microservices communicate via **REST, gRPC, or messaging**, and avoid **direct database sharing**.
* Any data sharing happens through **APIs or event streams**, not shared tables.

**Benefit** → Reduces integration complexity and avoids cascading failures.

#### **4. Port-and-Adapter (Hexagonal) Integration**

While Clean Architecture is not the same as Hexagonal, it **borrows the concept** of **ports** (interfaces) and **adapters** (implementations) for:

* Persistence (e.g., MySQL, MongoDB)
* Messaging (e.g., Kafka, RabbitMQ)
* External APIs

**Benefit** → Infrastructure can be swapped with minimal impact on the domain layer.

#### **5. Autonomous Deployability**

* Spring Boot’s **fat JAR** packaging and embedded web server enable each service to be deployed independently.
* The Clean Architecture inside ensures that deployment changes don’t require rewriting core logic.

**Benefit** → Enables **continuous delivery** without destabilizing unrelated parts of the system.

#### **6. Testability at All Layers**

* **Unit Tests** → Run against the domain layer without infrastructure.
* **Integration Tests** → Focus on adapters like persistence or API clients.
* **Contract Tests** → Ensure APIs match expectations between services.

**Benefit** → Higher confidence in deployments and easier refactoring.

## Key Components in the Setup

This stack combines **Spring Boot** (runtime + production plumbing) with **Clean Architecture** (internal code discipline). Think of the runtime as _how it runs_ and Clean as _how it’s shaped_.

#### 1) Domain Layer (Enterprise Business Rules)

* **What it is:** Pure business logic: entities, value objects, domain services, domain events, and invariants.
* **What it contains:**
  * `Customer`, `Order`, `Payment` (entities/value objects)
  * Domain policies/rules (e.g., pricing rules, credit limits)
  * Domain events: `OrderPlaced`, `PaymentCaptured`
* **What it depends on:** **Nothing framework-specific.** No Spring, no JPA, no HTTP.
* **Why it exists:** Keeps the core independent of technology so it survives UI/DB/messaging churn.

#### 2) Application Layer (Use Cases / Orchestration)

* **What it is:** Coordinates use cases; translates intent to domain actions.
* **What it contains:**
  * Use case services (e.g., `PlaceOrderHandler`, `CapturePaymentHandler`)
  * Input/Output models (DTOs specific to use cases)
  * Ports (interfaces) the domain/application need from the outside: `PaymentGateway`, `OrderRepository`, `EventPublisher`
* **What it depends on:** Domain layer only.
* **Why it exists:** Encapsulates workflows without leaking HTTP/JPA/Kafka details upward or into the domain.

#### 3) Interface Adapters (Infrastructure Implementations)

* **What it is:** Concrete adapters that fulfill ports using technologies.
* **What it contains:**
  * Persistence adapters: Spring Data JPA repositories implementing `OrderRepository`
  * Messaging adapters: Kafka producers/consumers implementing `EventPublisher` / handlers
  * External API clients: Feign/WebClient adapters implementing `PaymentGateway`
* **What it depends on:** Spring, JPA/Hibernate, Kafka/RabbitMQ clients, HTTP clients.
* **Why it exists:** Localizes framework-specific code so it can be swapped (e.g., Postgres → Mongo; REST → gRPC) without touching application/domain.

#### 4) Delivery Layer (Primary Adapters / Entry Points)

* **What it is:** How the outside world talks to the service.
* **What it contains:**
  * REST controllers (Spring MVC/WebFlux)
  * gRPC controllers (optional)
  * Messaging listeners (Kafka/RabbitMQ consumers)
  * CLI/Batch schedulers (Spring Scheduling)
* **What it depends on:** Application layer (calls use cases), model mappers.
* **Why it exists:** Converts transport-specific requests into use-case inputs and maps results to transport-specific responses.

#### 5) Configuration & Composition (Wiring)

* **What it is:** Assembles the app at runtime via dependency injection.
* **What it contains:**
  * Spring `@Configuration` classes creating beans for use cases and binding ports to adapters
  * Profiles for env-specific wiring (e.g., `local`, `prod`, `test`)
* **Why it exists:** Keeps wiring out of business code; enables swapping implementations per environment.

#### 6) Cross-Cutting Concerns

* **Observability:** Spring Boot Actuator, Micrometer metrics, logs/trace (OpenTelemetry).
* **Security:** Spring Security for authentication/authorization; method-level security at use cases when needed.
* **Validation:** Bean Validation (JSR-380) at edges (controllers) and domain invariants inside entities/value objects.
* **Transactions:** Declarative boundaries around use cases (`@Transactional` at application layer), not inside domain entities.
* **Error Handling:** Centralized exception mappers (e.g., `@ControllerAdvice`) that convert domain/application errors to HTTP/gRPC codes.
* **Idempotency:** Keys/tokens on write endpoints or message handlers to safely retry.

#### 7) Data & Schema Strategy

* **Private Database per Service:** Aligns with microservice autonomy; no shared tables.
* **Migrations:** Flyway/Liquibase for versioned schema changes.
* **Outbox Pattern (optional):** Persist domain events with state changes, then publish reliably to Kafka to avoid dual-write problems.

#### 8) API & Contract Strategy

* **API Definition:** OpenAPI/Swagger for REST; protobuf for gRPC.
* **Contract Testing:** Consumer-driven tests (Pact) to prevent breaking changes.
* **Backward Compatibility:** Version endpoints (`/v1`, `/v2`) or evolve schemas with tolerant readers.

#### 9) Packaging & Modules (typical layout)

* `domain/` (plain Java/Kotlin, no Spring)
* `application/` (use cases, ports, DTOs)
* `infrastructure/` (JPA, Kafka, HTTP clients, mappers)
* `delivery/` (controllers, listeners)
* `config/` (Spring configs, wiring)
* `bootstrap/` (main application class)

_(Whether we use separate Gradle/Maven modules or logical packages, keep the dependency direction enforced: outer depends on inner, never the reverse.)_

#### 10) Testing Pyramid

* **Domain unit tests:** Fast, pure, highest count.
* **Application tests:** Use mocks/fakes for ports.
* **Adapter tests:** Slice tests for JPA, HTTP clients, messaging.
* **Contract tests:** Verify inter-service compatibility.
* **End-to-end smoke tests:** Minimal set in CI/CD.

## Execution Flow: _Place Order_

#### 1) **Incoming Request**

* **Actor:** Customer sends `POST /orders` with JSON payload.
* **Layer:** **Delivery Layer** (REST Controller in `delivery` package).
* **Action:**
  1. Controller receives HTTP request.
  2. Maps JSON payload to a **Use Case Input DTO** (`PlaceOrderRequest`).
  3. Passes DTO to the **Application Layer**’s `PlaceOrderHandler`.

#### 2) **Application Layer - Use Case Execution**

* **Actor:** `PlaceOrderHandler` (application service).
* **Responsibilities:**
  1. Validate request data (basic business checks).
  2. Fetch customer & product data using **Ports** (`CustomerRepository`, `ProductRepository`).
  3. Apply use case rules (e.g., stock availability, pricing logic).
  4. Create a **Domain Entity** (`Order`) with its associated value objects.
  5. Persist order through `OrderRepository` port.
  6. Trigger **Domain Event**: `OrderPlaced`.

#### 3) **Domain Layer - Core Business Logic**

* **Actor:** `Order` Entity, `OrderService` domain service.
* **Responsibilities:**
  1. Enforce invariants (cannot place an order without items).
  2. Calculate totals, taxes, discounts.
  3. Record domain events for later publication.
* **Important:** This layer **does not** know about Spring, JPA, or HTTP.

#### 4) **Infrastructure Layer - Adapter Implementations**

* **Actor:** JPA-based `OrderRepositoryImpl`, Kafka-based `EventPublisherImpl`.
* **Responsibilities:**
  1. Map domain entities to JPA entities and persist in PostgreSQL.
  2. Store domain events in an **Outbox Table** for reliable async publishing.
  3. Optionally, use transactional event listeners to push events after DB commit.

#### 5) **Event Publication**

* **Actor:** Outbox processor or event publisher.
* **Responsibilities:**
  1. Pick up `OrderPlaced` events from outbox.
  2. Publish to Kafka topic `orders.placed`.
  3. Downstream services (Inventory, Payment) consume this event.

#### 6) **Response to Client**

* **Actor:** Delivery Layer.
* **Responsibilities:**
  1. Map domain/application result to HTTP response DTO.
  2. Return `201 Created` with `Location: /orders/{id}`.
  3. Include basic order details in response body.

#### 7) **Asynchronous Side Effects**

* **Payment Service:** Listens for `OrderPlaced`, reserves funds.
* **Inventory Service:** Listens for `OrderPlaced`, reserves stock.
* **Notification Service:** Sends email/SMS confirmation.

## Advantages

#### 1) **Strong Separation of Concerns**

* Clean Architecture enforces **layer boundaries** between **Domain**, **Application**, **Infrastructure**, and **Delivery**.
* In microservices, this separation prevents business logic from getting tangled with transport, persistence, or framework details.
* Example: We can change from REST to gRPC or from PostgreSQL to MongoDB without touching domain code.

#### 2) **High Testability**

* Domain and application layers are **pure Java** with no Spring dependencies, so they can be tested using **plain JUnit** without spinning up the Spring container.
* We can mock the ports to test use cases in isolation.
* This drastically reduces test execution time compared to integration tests.

#### 3) **Technology Independence**

* Since business logic doesn’t depend on frameworks, we can swap:
  * JPA → MyBatis or JDBC
  * Kafka → RabbitMQ
  * Spring MVC → WebFlux\
    …without rewriting the core logic.
* This is particularly useful in microservices, where individual services may evolve differently.

#### 4) **Better Maintainability for Long-Lived Services**

* Microservices often need **continuous feature changes** and **technology upgrades**.
* Clean Architecture ensures that changes in infrastructure (e.g., upgrading Spring Boot version, replacing a DB) don’t ripple into the business logic layer.
* This reduces the cost of change and risk of introducing defects.

#### 5) **Clear Contract Between Layers**

* Ports (interfaces) act as **contracts** between the application layer and infrastructure.
* Infrastructure teams and business logic developers can work **in parallel** by mocking or stubbing the contracts.
* This fits perfectly into **team-based microservice development**.

#### 6) **Domain-Centric Design**

* Keeps the **business rules as the central focus** of the service.
* Encourages proper modeling of **Entities**, **Value Objects**, and **Domain Events**.
* Aligns with DDD (Domain-Driven Design) practices often used in microservice-based systems.

#### 7) **Easy Onboarding for New Developers**

*   Code is structured predictably:

    ```
    com.example.orders
        ├── application
        ├── domain
        ├── infrastructure
        └── delivery
    ```
* New developers can navigate to the **domain layer** to understand business logic without being distracted by framework setup.

#### 8) **Reduced Risk of Framework Lock-in**

* If Spring Boot becomes unsuitable in the future, we can replace it with another Java framework (or even Kotlin/Quarkus) while keeping most of the domain code intact.
* This provides long-term strategic flexibility.

#### 9) **Better Fit for CI/CD**

* Unit tests for domain and application layers run **blazing fast**, making it easier to run them on every commit in a microservice CI/CD pipeline.
* Infrastructure-heavy integration tests can be run separately or less frequently.

## Challenges

#### 1) **Increased Initial Complexity**

* Clean Architecture introduces **multiple layers and interfaces**, even for simple services.
* For small microservices with minimal business logic, this can feel **over-engineered** and slow down initial development.
* Developers need discipline to follow the boundaries correctly - otherwise, the benefits are lost.

#### 2) **More Boilerplate Code**

* Every interaction between the domain/application and infrastructure layers requires **ports and adapters** (interfaces + implementations).
* Example: For a simple database save operation, we may need:
  * `OrderRepository` (port)
  * `OrderRepositoryImpl` (adapter)
  * Infrastructure configurations\
    This can add verbosity compared to a direct repository injection in Spring Boot.

#### 3) **Steeper Learning Curve**

* Not all developers are familiar with Clean Architecture principles.
* Understanding **dependency inversion**, **port-adapter patterns**, and **framework isolation** requires **training and practice**.
* New team members might take longer to become productive.

#### 4) **Performance Overhead in Some Cases**

* While the overhead is generally small, additional **abstraction layers** can introduce minor latency or memory usage.
* This is usually negligible for most microservices but may matter in **high-throughput, low-latency systems**.

#### 5) **Integration Testing Complexity**

* Since infrastructure is decoupled, integration tests must **wire up the adapters explicitly**.
* Testing end-to-end scenarios may require **more configuration** compared to tightly coupled architectures.

#### 6) **Misapplication for Simple Services**

* Applying Clean Architecture to a **CRUD-only microservice** with no complex business rules often results in **needless complexity**.
* In such cases, a **simpler layered approach** might be more appropriate.

#### 7) **Requires Strong Governance**

* Without **code reviews and architecture guidelines**, developers may accidentally bypass ports and directly access infrastructure from domain/application layers.
* This **erodes the architecture’s integrity** over time.

#### 8) **Dependency Management in Spring Boot**

* While Spring Boot works well with Clean Architecture, we must be careful with:
  * Bean scanning
  * Package structure
  * Avoiding circular dependencies\
    Misconfiguration can lead to **startup failures** or unwanted coupling.
