# Employee Portal

## About

A comprehensive, real-world Spring Boot application that simulates an enterprise-grade **Employee Management Portal**. This portal provides complete CRUD functionality and advanced data handling features such as:

* **Dynamic Filtering & Search**: Query employees based on multiple optional fields like name, department, role, salary range, and joining date.
* **Pagination & Sorting**: Efficient navigation through large datasets using Spring Data JPA’s built-in pagination and sorting capabilities.
* **Advanced Querying**: Incorporates JPQL, Criteria API, Native SQL, and Specifications to support dynamic and complex queries.
* **Projections**: Optimizes performance with interface-based, DTO-based, and nested projections.
* **Entity Relationships**: Demonstrates one-to-one, one-to-many, and many-to-many mappings with real-world relevance (e.g., Employee–Department, Employee–Projects).
* **Validation & Error Handling**: Ensures data integrity and returns meaningful status codes and error responses.
* **Transactional Operations**: Covers updates and bulk operations with transaction boundaries and concurrency control.
* **Performance Tuning**: Showcases best practices including fetch strategies, indexing hints, and caching options.

This example is designed to simulate real business requirements and demonstrate how to build scalable and maintainable persistence layers using **Spring Boot + Spring Data JPA + Hibernate**.

## Tools, Libraries & Technologies

* **Language**: Java 17+
* **Framework**: Spring Boot 3.x
* **Persistence**: Spring Data JPA with Hibernate (as JPA Provider)
* **Database**: Oracle Database 19c+
* **Build Tool**: Maven
* **REST**: Spring Web
* **Validation**: Jakarta Validation (Hibernate Validator)
* **Testing**: JUnit 5, Mockito, Testcontainers (for Oracle or H2)
* **IDE**: IntelliJ IDEA / Eclipse
* **Others**: Lombok (for reducing boilerplate)

## ER Diagram

<figure><img src="../../../../.gitbook/assets/spring-persistence-examples-employee-portal.png" alt=""><figcaption></figcaption></figure>

<details>

<summary>Plant UML File</summary>

```
@startuml

' Entity: Employee
entity Employee {
  * id : Long <<PK>>
  --
  name : String
  email : String
  phone : String
  hire_date : Date
  department_id : Long <<FK>>
  address_id : Long <<FK>>
}

' Entity: Department
entity Department {
  * id : Long <<PK>>
  --
  name : String
  location : String
}

' Entity: Address
entity Address {
  * id : Long <<PK>>
  --
  street : String
  city : String
  state : String
  zip : String
  country : String
}

' Entity: Project
entity Project {
  * id : Long <<PK>>
  --
  name : String
  client : String
  budget : Double
}

' Join Table: employee_project (Many-to-Many)
entity employee_project {
  * employee_id : Long <<FK>>
  * project_id : Long <<FK>>
}

' Entity: Salary
entity Salary {
  * id : Long <<PK>>
  --
  employee_id : Long <<FK>>
  base_salary : Double
  bonus : Double
  deductions : Double
  month : String
  year : Integer
  status : String
}

' Entity: PaymentHistory
entity PaymentHistory {
  * id : Long <<PK>>
  --
  salary_id : Long <<FK>>
  payment_date : Date
  amount_paid : Double
  payment_mode : String
  remarks : String
}

' Relationships
Employee }o--|| Department : belongs_to
Employee }o--|| Address : has_one
Employee ||--o{ employee_project : assigned_to
Project ||--o{ employee_project : assigned_with
Employee ||--o{ Salary : earns
Salary ||--o{ PaymentHistory : tracked_by

@enduml
```

</details>



## Folder Structure

```apacheconf
com.company.employeeportal
│
├── config                  # Spring and application configuration (DataSource, Swagger, CORS, etc.)
│
├── constants               # Application-wide constants and enums
│
├── controller              # REST controllers for handling HTTP requests
│
├── dto                     # Data Transfer Objects for request/response bodies
│
├── entity                  # JPA entity classes (Employee, Department, Salary, etc.)
│
├── exception               # Custom exceptions and global exception handling
│
├── mapper                  # MapStruct or manual mappers (Entity <-> DTO)
│
├── repository              # Spring Data JPA repositories
│
├── service
│   ├── impl                # Implementations of service interfaces
│   └── spec                # JPA Specification classes for dynamic querying
│
├── util                    # Utility/helper classes (DateUtils, PaginationUtils, etc.)
│
├── validation              # Custom validators and annotation-based rules
│
└── payload                 # Generic API response structures (ApiResponse, PageResponse, etc.)
```

{% hint style="info" %}
* We may optionally add a `security` package if the portal includes authentication/authorization.
* If internationalization is needed, add a `i18n` or `messages` package.
* If salary logic grows complex, you could even modularize it further with `salary`, `payroll`, or `finance` sub-packages under `service`, `controller`, `entity`, etc.
{% endhint %}

