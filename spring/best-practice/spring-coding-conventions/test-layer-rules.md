# Test Layer Rules

## About

**Test Layer Rules** define guidelines for organizing, writing, and structuring **unit, integration, and functional tests** in a Spring project. Proper test layer rules ensure that tests are **maintainable, reliable, and clearly separated from production code**.

In Spring applications, the test layer typically includes:

* **Unit Tests**: Focused on individual classes or methods using mocks.
* **Integration Tests**: Validate interactions between multiple components or layers.
* **Functional / End-to-End Tests**: Validate complete workflows, often using Spring Boot test utilities or mock servers.

By enforcing test layer rules, teams can maintain **high code quality** and **avoid mixing test concerns with production code**.

## Purpose

The purpose of **Test Layer Rules** is to ensure that testing in a Spring project is **structured, effective, and maintainable**, while keeping test code separate from production code.

Key objectives include:

1. **Maintain clear separation of concerns**
   * Tests should reside in dedicated test packages (`src/test/java`) and mirror the production package structure.
2. **Ensure reliability and consistency**
   * Proper layering of unit, integration, and functional tests ensures predictable and reproducible results.
3. **Facilitate maintainability and refactoring**
   * Well-structured tests allow developers to safely modify production code without breaking unrelated functionality.
4. **Enable automated enforcement**
   * Test coverage, naming conventions, and dependency rules can be enforced via CI/CD pipelines.
5. **Promote team collaboration**
   * Consistent test organization helps new developers understand the testing strategy and locate relevant tests quickly.

#### Rules

## **1. Package Structure**

* Test classes should mirror the **production package structure**.
  * Example: `com.company.employeeportal.service.EmployeeService` → `com.company.employeeportal.service.EmployeeServiceTest`
* Separate packages for **unit**, **integration**, and **functional tests** can be created if needed.

## **2. Naming Conventions**

* Unit test classes should end with **`Test`**.
  * Example: `EmployeeServiceTest`
* Integration test classes can end with **`IT`** (Integration Test).
  * Example: `EmployeeServiceIT`
* Functional / End-to-End tests can use descriptive suffixes like **`E2ETest`**.

## **3. Annotations**

* Use Spring testing annotations appropriately:
  * `@SpringBootTest` for full application context tests.
  * `@WebMvcTest` for controller-layer tests.
  * `@DataJpaTest` for repository-layer tests.
  * `@MockBean` and `@Autowired` for dependency injection in tests.

## **4. Dependency Rules**

* Test classes **may depend** on:
  * Production classes under test.
  * Mocks, test utilities, DTOs, and entities.

## **5. Test Method Conventions**

* Methods should use **descriptive names** using camelCase, clearly indicating the scenario.
  * Example: `createEmployee_shouldReturnSavedEmployee_whenValidDataProvided()`
* Each test should **verify a single behavior** (unit principle).

## **6. Test Isolation**

* Unit tests should **not depend on external services or databases**; use mocks or in-memory replacements.
* Integration tests may connect to **test databases or mock servers**, but ensure isolation per test.

## **7. Avoid Test Pollution**

* Do not modify **shared static data** across tests unless properly reset.
* Ensure **idempotent tests** that can run independently and in parallel.

## **8. Utilities and Helpers**

* Shared test utilities or mock data providers can reside in a **`util`** subpackage under `src/test/java`.
* Avoid placing production logic in test utilities.
