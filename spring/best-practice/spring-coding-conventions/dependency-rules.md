# Dependency Rules

## About

**Dependency Rules** define **which packages or layers are allowed to depend on others** in a Spring application. They ensure that **dependencies follow architectural guidelines**, prevent **tight coupling**, and reduce the risk of **cyclic dependencies**.

By controlling dependencies between layers, teams can enforce a **clean, modular architecture**, where each layer has a clear responsibility and can evolve independently without breaking other parts of the system.

## Purpose

The purpose of **Dependency Rules** is to enforce **controlled and predictable dependencies** between classes, packages, and layers in a Spring application.

Key objectives include:

1. **Prevent tight coupling**
   * Ensures layers or modules do not become overly dependent on each other, making the code easier to maintain and refactor.
2. **Avoid cyclic dependencies**
   * Prevents scenarios where two or more packages depend on each other, which can cause runtime issues, testing complications, and architectural drift.
3. **Maintain modularity and scalability**
   * By defining allowed dependencies, each layer or module can evolve independently, supporting better scalability and long-term maintainability.
4. **Support enforcement through tools**
   * Dependency rules can be automatically verified with ArchUnit or static analysis tools, catching violations early in development.
5. **Complement layered architecture and package rules**
   * While layered architecture defines the “what” of layers, dependency rules define the “how” classes and packages interact safely.

#### Rules

## **1. Controller Layer (`controller`)**

* Controllers **may depend on**:
  * Service (`service`) layer for business logic.
  * DTOs (`dto`) for request/response objects.
* Controllers **must not depend on**:
  * Repository (`repository`) or specification (`specification`) classes directly.
  * Entity (`entity`) classes directly.
  * Client (`client`) classes containing external business logic.

## **2. Service Layer (`service`)**

* Services **may depend on**:
  * Repository (`repository`) or specification (`specification`) for data access.
  * Client (`client`) for external API calls.
  * DTOs (`dto`) and mappers (`mapper`) for data transformations.
  * Utilities (`util`) for helper functions.
  * Configuration classes (`config`) containing properties loaded from .properties or .yaml file.
* Services **must not depend on**:
  * Controllers (`controller`) to prevent reverse dependencies.

## **3. Repository Layer (`repository`, `specification`)**

* Repositories **may depend on**:
  * Entity (`entity`) classes.
  * Specification (`specification`) classes for query building.
* Repositories **must not depend on**:
  * Controllers (`controller`) or services (`service`).
  * DTOs (`dto`) or mappers (`mapper`).
  * Client (`client`) or utilities containing business logic.

## **4. Entity Layer (`entity`)**

* Entities **may depend on**:
  * Other entities for relationships.
  * Constants (`constants`) for enums and fixed values.
* Entities **must not depend on**:
  * Controllers (`controller`) or services (`service`).
  * Repositories (`repository`) or DTOs (`dto`).
  * Clients (`client`) or utilities containing business logic.

## **5. DTO Layer (`dto`)**

* DTOs **may depend on**:
  * Validation classes (`validation`).
* DTOs **must not depend on**:
  * Controllers (`controller`) or services (`service`).
  * Repositories (`repository`) or entities (`entity`).

## **6. Mapper Layer (`mapper`)**

* Mappers **may depend on**:
  * DTOs (`dto`) and entities (`entity`).
* Mappers **must not depend on**:
  * Services (`service`) or repositories (`repository`).
  * Controllers (`controller`) or clients (`client`).

## **7. Client Layer (`client`)**

* Clients **may depend on**:
  * DTOs (`dto`) for requests/responses.
  * Utilities (`util`) for HTTP handling, serialization, or logging.
* Clients **must not depend on**:
  * Services (`service`) or controllers (`controller`).
  * Repositories (`repository`) or entities (`entity`).

## **8. Validation Layer (`validation`)**

* Validators **may depend on**:
  * DTOs (`dto`) or entities (`entity`) they validate.
  * Utilities (`util`) for helper methods.
* Validators **must not depend on**:
  * Controllers (`controller`) or services (`service`).
  * Repositories (`repository`) or clients (`client`).

## **9. Utility Layer (`util`)**

* Utilities **may be used by**:
  * Services, mappers, validation, and clients.
* Utilities **must not depend on**:
  * Services (`service`), controllers (`controller`), or repositories (`repository`).
  * Entities (`entity`) or DTOs (`dto`) containing business data.

## **10. Exception Layer (`exception`)**

* Exception classes **may depend on**:
  * Constants (`constants`) for error codes/messages.
* Exception classes **must not depend on**:
  * Controllers, services, repositories, or clients.

## **11. Config Layer (`config`)**

* Config classes **may depend on**:
  * Constants (`constants`) or utilities (`util`).
* Config classes **must not depend on**:
  * Controllers (`controller`), services (`service`), or repositories (`repository`).
