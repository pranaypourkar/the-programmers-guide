# Naming Convention Rules

## About

**Naming Convention Rules** define **how classes, methods, packages, and variables should be named** in a Spring application. Consistent naming improves **code readability, maintainability, and team collaboration**, and ensures that the role of each class or component is immediately clear.

Naming conventions also help **automated tools** like ArchUnit, static analyzers, and CI/CD checks to enforce structure, detect violations, and prevent misplacements of classes.

## Purpose

The purpose of **Naming Convention Rules** is to enforce **clear, consistent, and descriptive names** across classes, packages, methods, and variables in a Spring application.

Key objectives include:

1. **Improve readability**
   * Names should immediately convey the purpose and responsibility of a class, method, or variable.
2. **Support maintainability**
   * Consistent naming reduces confusion, makes code easier to navigate, and simplifies refactoring.
3. **Enable automated enforcement**
   * Tools like ArchUnit or static analyzers can detect naming violations if conventions are consistently applied.
4. **Reflect architecture and roles**
   * Naming patterns indicate the **layer, responsibility, or type** of a component, e.g., controllers, services, repositories, DTOs, and exceptions.
5. **Facilitate collaboration**
   * Team members can quickly understand unfamiliar code when naming conventions are followed consistently.

#### Rules

## **1. Controller Layer (`controller`)**

* Class names should end with **`Controller`**.
* Example: `EmployeeController`, `DepartmentController`.
* Methods should use **camelCase** and clearly describe the action (e.g., `getEmployeeById`, `createDepartment`).

## **2. Service Layer (`service`)**

* Class names should end with **`Service`**.
* Example: `EmployeeService`, `SalaryService`.
* Methods should use **camelCase** and indicate the business operation performed.

## **3. Repository Layer (`repository`)**

* Interface names should end with **`Repository`**.
* Example: `EmployeeRepository`, `DepartmentRepository`.
* Custom query methods should follow Spring Data JPA naming conventions (e.g., `findByDepartmentId`).

## **4. Entity Layer (`entity`)**

* Class names should be **singular nouns** representing the domain model.
* Example: `Employee`, `Department`, `Salary`.
* Field names should use **camelCase**, and constants (enums) should use **UPPER\_CASE**.

## **5. DTO Layer (`dto`)**

* Class names should end with **`Dto`** or a descriptive suffix like `Request` / `Response`.
* Example: `EmployeeDto`, `DepartmentRequest`, `SalaryResponse`.
* Fields should use **camelCase**, matching JSON property conventions where applicable.

## **6. Mapper Layer (`mapper`)**

* Class names should end with **`Mapper`**.
* Example: `EmployeeMapper`, `DepartmentMapper`.
* Methods should clearly indicate the conversion direction (e.g., `toDto`, `toEntity`, `mapToLoyaltyResponse`).

## **7. Client Layer (`client`)**

* Class names should end with **`Client`** or include the external system name.
* Example: `PayrollClient`, `NotificationServiceClient`.
* Methods should clearly indicate the API operation (e.g., `fetchPayrollData`, `sendNotification`).

## **8. Validation Layer (`validation`)**

* Class names should end with **`Validator`**.
* Example: `EmployeeValidator`, `DepartmentValidator`.
* Methods should indicate the validation action (e.g., `validateEmployeeId`, `validateSalaryAmount`).

## **9. Utility Layer (`util`)**

* Class names should end with **`Utils`** or **`Helper`**.
* Example: `DateUtils`, `PaginationHelper`.
* Methods should be descriptive of the operation (e.g., `formatDate`, `calculatePageCount`).

## **10. Exception Layer (`exception`)**

* Class names should end with **`Exception`** or **`Error`**.
* Example: `EmployeeNotFoundException`, `InvalidSalaryException`.

## **11. Config Layer (`config`)**

* Class names should reflect the configuration purpose and end with **`Config`**.
* Example: `SwaggerConfig`, `DataSourceConfig`.

## **12. Package Naming**

* Use **lowercase, dot-separated names** for packages.
* Example: `com.company.employeeportal.controller`, `com.company.employeeportal.service`.
* Avoid underscores or mixed-case in package names.
