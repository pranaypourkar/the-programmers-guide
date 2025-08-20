# Annotation Usage Rules

## About

**Annotation Usage Rules** define how **Spring-specific and custom annotations** should be applied across the project. Proper usage ensures that classes behave as intended, follow Spring’s lifecycle, and respect the layered architecture.

These rules cover **stereotype annotations** (`@Controller`, `@Service`, `@Repository`), **validation annotations**, **transaction management**, and other Spring-specific or custom annotations. By standardizing annotation usage, teams can reduce misconfigurations, runtime errors, and architectural violations.

## Purpose

The purpose of **Annotation Usage Rules** is to ensure **consistent, correct, and meaningful application of annotations** in a Spring project.

Key objectives include:

1. **Enforce correct Spring behavior**
   * Proper use of `@Controller`, `@Service`, `@Repository`, and `@Component` ensures Spring correctly detects and manages beans.
2. **Maintain layered architecture integrity**
   * Prevents misplacing annotations that could break dependency rules or layer separation.
3. **Reduce runtime errors and misconfigurations**
   * Proper annotation usage avoids issues like missing beans, circular dependencies, or transaction mismanagement.
4. **Support automated checks**
   * Tools like ArchUnit can validate annotation usage across layers, detecting violations early.
5. **Promote readability and maintainability**
   * Developers can immediately understand the role of a class or method based on its annotations.

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

## **1. Controller Layer (`api`)**

* Classes must be annotated with **`@RestController`**.
* Endpoints may use **`@RequestMapping`, `@GetMapping`, `@PostMapping`, `@PutMapping`, `@DeleteMapping`** as appropriate.
* Controllers **must not** have `@Service` or `@Repository` annotations.

## **2. Service Layer (`service`)**

* Classes must be annotated with **`@Service`**.
* Methods that require transactional behavior must use **`@Transactional`** with appropriate propagation and read-only settings.
* Services **must not** be annotated with `@Controller` or `@Repository`.

## **3. Repository Layer (`repository`)**

* Interfaces must be annotated with **`@Repository`** (for Spring Data JPA repositories, this is optional but recommended for exception translation).
* Repositories **must not** have `@Service` or `@Controller` annotations.

## **4. Entity Layer (`entity`)**

* Classes must be annotated with **`@Entity`**.
* Use **`@Table`** to define table names if different from class names.
* Primary keys must use **`@Id`** and appropriate generation strategies (`@GeneratedValue`).
* Relationships should use **`@OneToMany`, `@ManyToOne`, `@OneToOne`, `@ManyToMany`** as required.

## **5. DTO Layer (`dto`)**

* DTOs may use **validation annotations** from `javax.validation` or `jakarta.validation` such as **`@NotNull`, `@Size`, `@Pattern`**.
* DTOs **must not** have Spring stereotype annotations (`@Service`, `@Repository`, `@Controller`).

## **6. Mapper Layer (`mapper`)**

* Mapper interfaces/classes may use **MapStruct annotations** like **`@Mapper`** or **`@Mapping`**.
* Mappers **must not** include Spring stereotype annotations.

## **7. Client Layer (`client`)**

* Classes may use **`@Component`** or a custom qualifier to register as a Spring bean.
* External API-specific annotations like **`@FeignClient`** can be used if applicable.
* Clients **must not** have `@Controller`, `@Service`, or `@Repository`.

## **8. Validation Layer (`validation`)**

* Custom validators must use **`@Component`** or proper Spring stereotype to enable dependency injection.
* Validation annotations on DTO/entity fields must be consistent and follow naming conventions.

## **9. Utility Layer (`util`)**

* Utility classes **must not** use Spring stereotype annotations unless absolutely necessary.
* Typically, utilities are **static helper classes** and should remain annotation-free.

## **10. Exception Layer (`exception`)**

* Exception classes **must not** be annotated with Spring stereotypes.
* Global exception handlers may use **`@ControllerAdvice`** and **`@ExceptionHandler`** annotations.

## **11. Config Layer (`config`)**

* Configuration classes **must** use **`@Configuration`**.
* Beans should be defined with **`@Bean`** annotations.
* Conditional configuration may use **`@Conditional`, `@Profile`, `@PropertySource`**, or other relevant Spring annotations.
