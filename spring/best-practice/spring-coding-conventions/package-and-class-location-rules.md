# Package & Class Location Rules

## About

**Package & Class Location Rules** define how classes should be **organized within the project’s package structure**. Proper organization improves **readability, maintainability, and modularity**.

In Spring projects, packages often reflect **functional or architectural separation**, such as `controller`, `service`, `repository`, `entity`, `dto`, `mapper`, and `util`. Enforcing these rules ensures that:

* Classes are **predictably placed** based on their role.
* Developers can **quickly locate relevant classes**.
* Tools like ArchUnit or static analyzers can **validate package conventions**.

These rules complement **layered architecture rules** by providing **physical structure guidance**, ensuring that classes not only follow proper dependencies but also reside in the correct locations within the project.

## Purpose

The purpose of **Package & Class Location Rules** is to enforce **consistent placement of classes within the project structure**, ensuring that the package organization reflects the **role and responsibility** of each class.

Key objectives include:

1. **Improve project readability and navigation**
   * Developers can easily find classes based on package names, reducing time spent searching for code.
2. **Support maintainability and modularity**
   * By keeping related classes together and separating unrelated components, the codebase becomes easier to maintain and extend.
3. **Enable automated validation**
   * Tools like ArchUnit can verify that classes are correctly placed, reducing errors introduced during development or refactoring.
4. **Reinforce architectural rules**
   * Proper package placement complements layered architecture rules, ensuring that dependencies align with physical structure.
5. **Facilitate team collaboration**
   * A predictable structure ensures that multiple developers working on the same project follow the same conventions, making code reviews and onboarding smoother.

#### Rules

## **1. Controller Layer (`controller`)**

* Classes annotated with `@RestController` or containing `Controller` in their name must reside in the `controller` package.
* Controllers **must not** be placed in `service`, `repository`, or `entity` packages.

## **2. Service Layer (`service`)**

* All business logic classes should reside in the `service` package.
* Services **must not** be placed in `controller`, `repository`, or `entity` packages.

## **3. Repository Layer (`repository`, `specification`)**

* Repository interfaces and Spring Data JPA specifications must reside in `repository` or `specification` packages.
* Repositories **must not** reside in `service`, `controller`, or `entity` packages.

## **4. Entity Layer (`entity`)**

* JPA entity classes must reside in the `entity` package.
* Entities **must not** be placed in `controller`, `service`, or `repository` packages.

## **5. DTO Layer (`dto`)**

* DTOs for requests and responses must reside in the `dto` package.
* DTOs **must not** be placed in `service`, `repository`, or `entity` packages.

## **6. Mapper Layer (`mapper`)**

* Mapper classes should reside in the `mapper` package.

## **7. Client Layer (`client`)**

* Classes handling external API calls must reside in the `client` package.
* Clients **must not** reside in `service`, `controller`, or `repository`.

## **8. Validation Layer (`validation`)**

* Custom validators must reside in the `validation` package.

## **9. Utility Layer (`util`)**

* Generic helper classes must reside in the `util` package.

## **10. Exception Layer (`exception`)**

* Custom exceptions and global exception handlers must reside in the `exception` package.
* Exceptions **must not** reside in service, controller, or repository packages.

## **11. Config Layer (`config`)**

* Spring or application configuration classes must reside in the `config` package.
