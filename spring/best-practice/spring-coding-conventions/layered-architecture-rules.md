# Layered Architecture Rules

## About

Layered architecture is a design pattern that **organizes code into distinct layers**, each with a specific responsibility. In Spring applications, this typically includes layers such as **Controller, Service, Repository, and Domain**.

The **Layered Architecture Rules** define how these layers should interact, which dependencies are allowed, and which are prohibited. By enforcing these rules, teams ensure that each layer **only communicates with appropriate layers**, reducing coupling and improving maintainability.

Layered architecture also promotes **separation of concerns**, making it easier to test, modify, and extend individual parts of the system without impacting others.

## Purpose

The purpose of **Layered Architecture Rules** is to enforce **consistent separation of responsibilities** within a Spring application and ensure that **dependencies between layers are well-defined**.

Key objectives include:

1. **Maintain clear boundaries between layers**
   * Controllers should only handle HTTP requests and delegate business logic to services.
   * Services should encapsulate business logic and orchestrate calls to repositories or other services.
   * Repositories should handle persistence and data access, without involving controllers or services directly.
2. **Reduce coupling and increase modularity**
   * Prevents layers from depending on inappropriate layers, which reduces the risk of tight coupling and circular dependencies.
3. **Enable easier testing and maintainability**
   * Layers with well-defined responsibilities can be **tested in isolation**.
   * Changes in one layer have minimal impact on others.
4. **Promote scalability and long-term architectural integrity**
   * Helps the system evolve while maintaining a predictable structure and avoiding architectural erosion.

#### Rules

Consider the following packaging structure

```
com.company.employeeportal
├── config                  # Spring and application configuration (DataSource, Swagger, CORS, etc.)
├── client                  # External API calls logic
├── constants               # Application-wide constants and enums
├── api                     # REST controllers for handling HTTP requests
├── dto                     # Data Transfer Objects for request/response bodies
├── entity                  # JPA entity classes (Employee, Department, Salary, etc.)
├── exception               # Custom exceptions and global exception handling
├── mapper                  # MapStruct or manual mappers (Entity <-> DTO)
├── repository              # Spring Data JPA repositories specification
├── specification           # Spring Data JPA specification 
├── service                 # Service classes for handling business logic
├── util                    # Utility/helper classes (DateUtils, PaginationUtils, etc.)
├── validation              # Custom validators and annotation-based rules
```

## **1. Controller Layer Rules (`api`)**

* Controllers must **only handle HTTP requests** and delegate business logic to the **service layer**.
* Controllers **must not**:
  * Directly access repositories or entities.
  * Call utility classes that perform business logic (util classes can only be helper functions like formatting or validation).
* Controllers **may** depend on:
  * DTOs (`dto`) for request/response binding.
  * Services (`service`) for business operations.
* Controllers **must not** throw repository-specific exceptions; exceptions should be handled via service layer or mapped to global exception handlers (`exception`).

## **2. Service Layer Rules (`service`)**

* Services contain **business logic** and orchestrate operations between repositories, external clients, and domain objects.
* Service classes **may depend on**:
  * Repositories (`repository`) for data access.
  * Specifications (`specification`) for complex queries.
  * DTOs (`dto`) and Mappers (`mapper`) for transforming data.
  * Utilities (`util`) for helper functions like formatting, pagination, or validation helpers.
  * Client (`client`) for external API calls.
  * Validation (`validation`) for any logic evaluation.
  * Configuration classes (`config`) containing properties loaded from .properties or .yaml file.
* Service classes **must not**:
  * Access controllers.
  * Depend on presentation-specific logic.
  * Depend on entities outside of repository or mapping context without proper encapsulation.

## **3. Repository Layer Rules (`repository`, `specification`)**

* Repositories handle **data access** using Spring Data JPA or custom specifications.
* Repositories **may depend on**:
  * Entities (`entity`) for persistence mapping.
  * Specifications (`specification`) for query building.
* Repositories **must not**:
  * Depend on controllers, services, DTOs, or clients.
  * Contain business logic; they are purely for CRUD and query operations.

## **4. Entity Layer Rules (`entity`)**

* Entities represent **domain models** and **database tables**.
* Entities **may depend on**:
  * Other entities (associations/relationships).
  * Constants (`constants`) for enum values.
* Entities **must not**:
  * Depend on controllers, services, repositories, or DTOs.
  * Include business logic beyond basic entity-level validation or constraints.

## **5. DTO Layer Rules (`dto`)**

* DTOs are for **data transfer between layers**, especially for controller inputs/outputs.
* DTOs **may depend on**:
  * Validation annotations (`validation`) if needed.
* DTOs **must not**:
  * Depend on services, repositories, or entities directly.
  * Contain business logic.

## **6. Mapper Layer Rules (`mapper`)**

* Mappers handle **conversion between DTOs and entities**.
* Mapper classes **may depend on**:
  * DTOs (`dto`) and entities (`entity`).
  * Utilities (`util`) for helper functions like formatting etc.
* Mapper classes **must not**:
  * Contain business logic.
  * Access services or repositories.

## **7. Client Layer Rules (`client`)**

* Client classes handle **external API calls**.
* Client classes **may depend on**:
  * DTOs for request/response objects.
  * Utilities (`util`) for HTTP formatting or serialization helpers.
* Client classes **must not**:
  * Call services or access repositories.
  * Contain business logic beyond API request/response orchestration.

## **8. Validation Layer Rules (`validation`)**

* Validators contain **custom validation logic** for entities or DTOs.
* Validation classes **may depend on**:
  * DTOs or entities they validate.
  * Utilities (`util`) for helper functions.
* Validation classes **must not**:
  * Access services, repositories, or controllers.
  * Include business orchestration logic.

## **9. Utility Layer Rules (`util`)**

* Utility classes provide **generic helper functions** (date formatting, pagination, string manipulation).
* Utilities **must not**:
  * Contain business logic.
  * Depend on services, controllers, or repositories.
* Utilities **may** be used by controllers, services, mappers, or validation classes.

## **10. Exception Layer Rules (`exception`)**

* Exception classes and global handlers define **application-level error management**.
* Exception classes **may depend on**:
  * Constants (`constants`) for error codes/messages.
* Exception classes **must not**:
  * Access services, repositories, or controllers directly.
  * Contain business logic.

## **11. Config Layer Rules (`config`)**

* Configuration classes manage Spring or application-level setup.
* Config classes **may depend on**:
  * Constants or properties.
  * Utility classes for reusable setup.
* Config classes **must not**:
  * Contain business logic.
  * Access controllers, services, or repositories.
