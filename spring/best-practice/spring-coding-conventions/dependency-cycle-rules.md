# Dependency Cycle Rules

## About

**Dependency Cycle Rules** define guidelines to **prevent cyclic dependencies** between packages, layers, or classes in a Spring application. A **dependency cycle** occurs when two or more components depend on each other, directly or indirectly, creating a circular chain.

Cyclic dependencies can cause:

* Runtime errors due to circular bean creation.
* Difficulty in unit testing and mocking.
* Poor maintainability and architectural drift.

Enforcing these rules ensures that **layers and packages remain independent**, supporting modularity and clean architecture.

## Purpose

The purpose of **Dependency Cycle Rules** is to **prevent circular dependencies** that can compromise the maintainability, testability, and modularity of a Spring project.

Key objectives include:

1. **Maintain modularity**
   * Ensures that each layer or package can evolve independently without introducing hidden dependencies.
2. **Prevent runtime issues**
   * Avoids circular bean instantiation errors in Spring’s dependency injection.
3. **Simplify testing and mocking**
   * Independent layers are easier to unit test and mock without complex workarounds.
4. **Enforce clean architecture**
   * Cycles often indicate architectural violations; preventing them preserves the intended design.
5. **Enable automated detection**
   * Tools like ArchUnit can detect dependency cycles early in the development cycle.

#### Rules

## **1. Layer-Level Cycles**

* **Forbidden:**
  * Controllers depending on repositories or entities directly.
  * Services depending on controllers.
  * Repositories depending on services or controllers.
* **Allowed:**
  * Controllers → Services → Repositories → Entities → Constants/Utilities.

## **2. Package-Level Cycles**

* Packages must not have **mutual dependencies**.
  * Example: `service` → `repository` → `service` is forbidden.
* Dependencies should follow a **unidirectional flow** from higher layers to lower layers.

## **3. Class-Level Cycles**

* Classes should not reference each other in a circular manner.
  * Example: `EmployeeService` referencing `DepartmentService`, which references `EmployeeService`.
* Use interfaces, event-driven design, or dependency injection to break potential cycles.

## **4. Utility & Constants**

* Utility (`util`) and constants (`constants`) packages **must not depend on business layers**.
* These packages are safe to be used across layers but should remain **independent**.

## **5. Validation and Mapper Cycles**

* Validators and mappers **must not introduce circular references** with services or controllers.
* They can depend on DTOs, entities, and utilities only.

## **6. Client and External APIs**

* Client classes **must not depend on controllers or services**, preventing cycles between internal and external communication layers.

## **7. Detection and Enforcement**

* Use **ArchUnit or static analysis tools** to detect cycles at compile-time or in CI/CD pipelines.
* Regularly review dependencies during refactoring to prevent inadvertent cycles.
