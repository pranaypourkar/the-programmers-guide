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

<figure><img src="../../../../../.gitbook/assets/spring-persistence-examples-employee-portal.png" alt=""><figcaption></figcaption></figure>

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

## Oracle DDL (Data Definition Language) SQL queries

{% hint style="info" %}
Oracle will automatically create indexes for **primary keys** and **unique constraints**, so we don’t need to define those manually again.
{% endhint %}

### `departments` Table

```sql
-- Department table stores organizational departments
CREATE TABLE departments (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    location VARCHAR2(100)
);

-- Optional: index for name if used in filters or sorting
CREATE INDEX idx_departments_name ON departments(name);
```

{% hint style="info" %}
Oracle automatically:

* Creates a **sequence** internally (we don't need to define it)
* Links it to that column
* Auto-increments the value on each insert

NUMBER -> Defines the column as a number (Oracle's flexible numeric type)

GENERATED ALWAYS AS IDENTITY -> Tells Oracle to **auto-generate** values for this column (identity)

PRIMARY KEY -> Declares this column as the **primary key** of the table
{% endhint %}

### `addresses` Table

```sql
-- Address table stores address information for employees
CREATE TABLE addresses (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    street VARCHAR2(200),
    city VARCHAR2(100),
    state VARCHAR2(100),
    zip VARCHAR2(20),
    country VARCHAR2(100)
);
```

### `employees` Table

```sql
-- Employee table with FK to department and address
CREATE TABLE employees (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) UNIQUE,
    phone VARCHAR2(20),
    hire_date DATE,
    department_id NUMBER NOT NULL,
    address_id NUMBER,

    CONSTRAINT fk_employee_department FOREIGN KEY (department_id)
        REFERENCES departments(id),

    CONSTRAINT fk_employee_address FOREIGN KEY (address_id)
        REFERENCES addresses(id)
);

-- Index to speed up lookups by department (frequent join)
CREATE INDEX idx_employees_department_id ON employees(department_id);

-- Index for address-based searches
CREATE INDEX idx_employees_address_id ON employees(address_id);

-- Index for email lookups (even though it’s unique, good to make it explicit)
CREATE UNIQUE INDEX idx_employees_email ON employees(email);
```

### `projects` Table

```sql
-- Project table stores client project information
CREATE TABLE projects (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    client VARCHAR2(100),
    budget NUMBER(12,2)
);

-- Optional: index for project name filtering or sorting
CREATE INDEX idx_projects_name ON projects(name);
```

#### `employee_project` Table (Join Table)

```sql
-- Join table for Many-to-Many relation between Employee and Project
CREATE TABLE employee_project (
    employee_id NUMBER NOT NULL,
    project_id NUMBER NOT NULL,

    CONSTRAINT pk_employee_project PRIMARY KEY (employee_id, project_id),

    CONSTRAINT fk_emp_proj_employee FOREIGN KEY (employee_id)
        REFERENCES employees(id) ON DELETE CASCADE,

    CONSTRAINT fk_emp_proj_project FOREIGN KEY (project_id)
        REFERENCES projects(id) ON DELETE CASCADE
);

-- Indexes to speed up joins from both sides of the many-to-many relation
CREATE INDEX idx_emp_proj_employee_id ON employee_project(employee_id);
CREATE INDEX idx_emp_proj_project_id ON employee_project(project_id);
```

### `salaries` Table

```sql
-- Salary table tracks monthly salary components per employee
CREATE TABLE salaries (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    employee_id NUMBER NOT NULL,
    base_salary NUMBER(12,2),
    bonus NUMBER(12,2),
    deductions NUMBER(12,2),
    month VARCHAR2(15),
    year NUMBER(4),
    status VARCHAR2(50),

    CONSTRAINT fk_salary_employee FOREIGN KEY (employee_id)
        REFERENCES employees(id) ON DELETE CASCADE
);

-- Employee-based salary lookup
CREATE INDEX idx_salaries_employee_id ON salaries(employee_id);

-- Querying by salary period
CREATE INDEX idx_salaries_month_year ON salaries(month, year);
```

### `payment_history` Table

```sql
-- Payment history table logs payments made for each salary
CREATE TABLE payment_history (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    salary_id NUMBER NOT NULL,
    payment_date DATE,
    amount_paid NUMBER(12,2),
    payment_mode VARCHAR2(50),
    remarks VARCHAR2(255),

    CONSTRAINT fk_payment_salary FOREIGN KEY (salary_id)
        REFERENCES salaries(id) ON DELETE CASCADE
);

-- Index to speed up lookups by salary ID
CREATE INDEX idx_payment_salary_id ON payment_history(salary_id);

-- Index for payment date filtering
CREATE INDEX idx_payment_date ON payment_history(payment_date);
```

## Sample Data Insertion Queries

{% code overflow="wrap" fullWidth="true" %}
```sql
// departments
INSERT INTO departments (id, name, location) VALUES (1, 'Engineering', 'New York');
INSERT INTO departments (id, name, location) VALUES (2, 'HR', 'San Francisco');
INSERT INTO departments (id, name, location) VALUES (3, 'Finance', 'Chicago');

// addresses
INSERT INTO addresses (id, street, city, state, zip, country)
VALUES (1, '123 Main St', 'New York', 'NY', '10001', 'USA');
INSERT INTO addresses (id, street, city, state, zip, country)
VALUES (2, '456 Park Ave', 'San Francisco', 'CA', '94101', 'USA');
INSERT INTO addresses (id, street, city, state, zip, country)
VALUES (3, '789 Lakeshore Dr', 'Chicago', 'IL', '60601', 'USA');

// employees
INSERT INTO employees (id, name, email, phone, hire_date, department_id, address_id)
VALUES (1, 'Alice Johnson', 'alice@example.com', '1234567890', TO_DATE('2020-01-15', 'YYYY-MM-DD'), 1, 1);
INSERT INTO employees (id, name, email, phone, hire_date, department_id, address_id)
VALUES (2, 'Bob Smith', 'bob@example.com', '2345678901', TO_DATE('2021-03-10', 'YYYY-MM-DD'), 2, 2);
INSERT INTO employees (id, name, email, phone, hire_date, department_id, address_id)
VALUES (3, 'Carol White', 'carol@example.com', '3456789012', TO_DATE('2019-07-22', 'YYYY-MM-DD'), 3, 3);

// projects
INSERT INTO projects (id, name, client, budget)
VALUES (1, 'Portal Revamp', 'TechCorp', 50000);
INSERT INTO projects (id, name, client, budget)
VALUES (2, 'HR System Upgrade', 'PeopleSoft', 30000);

// employee_project
-- Alice is on both projects
INSERT INTO employee_project (employee_id, project_id) VALUES (1, 1);
INSERT INTO employee_project (employee_id, project_id) VALUES (1, 2);
-- Bob is only on project 2
INSERT INTO employee_project (employee_id, project_id) VALUES (2, 2);
-- Carol is only on project 1
INSERT INTO employee_project (employee_id, project_id) VALUES (3, 1);

// salaries
INSERT INTO salaries (id, employee_id, base_salary, bonus, deductions, month, year, status)
VALUES (1, 1, 6000, 500, 200, 'JAN', 2024, 'PAID');
INSERT INTO salaries (id, employee_id, base_salary, bonus, deductions, month, year, status)
VALUES (2, 1, 6000, 600, 250, 'FEB', 2024, 'PAID');
INSERT INTO salaries (id, employee_id, base_salary, bonus, deductions, month, year, status)
VALUES (3, 2, 4000, 200, 150, 'JAN', 2024, 'PENDING');

// payment_history
INSERT INTO payment_history (id, salary_id, payment_date, amount_paid, payment_mode, remarks)
VALUES (1, 1, TO_DATE('2024-01-31', 'YYYY-MM-DD'), 6300, 'BANK_TRANSFER', 'Salary for Jan');
INSERT INTO payment_history (id, salary_id, payment_date, amount_paid, payment_mode, remarks)
VALUES (2, 2, TO_DATE('2024-02-29', 'YYYY-MM-DD'), 6350, 'BANK_TRANSFER', 'Salary for Feb');
```
{% endcode %}

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
├── repository              # Spring Data JPA repositories specification
│
├── specification           # Spring Data JPA specification 
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

## Prerequisites

### Pom File

pom.xml

<pre class="language-xml"><code class="lang-xml"><strong>&#x3C;project xmlns="http://maven.apache.org/POM/4.0.0"
</strong>         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
                             http://maven.apache.org/xsd/maven-4.0.0.xsd">
    &#x3C;modelVersion>4.0.0&#x3C;/modelVersion>
    
    &#x3C;parent>
        &#x3C;groupId>org.springframework.boot&#x3C;/groupId>
        &#x3C;artifactId>spring-boot-starter-parent&#x3C;/artifactId>
        &#x3C;version>${spring.boot.version}&#x3C;/version>
        &#x3C;relativePath/>
    &#x3C;/parent>
    
    &#x3C;groupId>com.company&#x3C;/groupId>
    &#x3C;artifactId>employee-portal&#x3C;/artifactId>
    &#x3C;version>1.0.0&#x3C;/version>
    &#x3C;packaging>jar&#x3C;/packaging>

    &#x3C;properties>
        &#x3C;java.version>17&#x3C;/java.version>
        &#x3C;spring.boot.version>3.1.2&#x3C;/spring.boot.version>
    &#x3C;/properties>

    &#x3C;dependencies>
        &#x3C;!-- Spring Boot Starters -->
        &#x3C;dependency>
            &#x3C;groupId>org.springframework.boot&#x3C;/groupId>
            &#x3C;artifactId>spring-boot-starter-web&#x3C;/artifactId>
        &#x3C;/dependency>
        
        &#x3C;dependency>
            &#x3C;groupId>org.springframework.boot&#x3C;/groupId>
            &#x3C;artifactId>spring-boot-starter-data-jpa&#x3C;/artifactId>
        &#x3C;/dependency>

        &#x3C;!-- Oracle JDBC -->
        &#x3C;dependency>
            &#x3C;groupId>com.oracle.database.jdbc&#x3C;/groupId>
            &#x3C;artifactId>ojdbc8&#x3C;/artifactId>
            &#x3C;version>19.3.0.0&#x3C;/version>
        &#x3C;/dependency>

        &#x3C;!-- Lombok -->
        &#x3C;dependency>
            &#x3C;groupId>org.projectlombok&#x3C;/groupId>
            &#x3C;artifactId>lombok&#x3C;/artifactId>
            &#x3C;optional>true&#x3C;/optional>
        &#x3C;/dependency>

        &#x3C;!-- Bean Validation -->
        &#x3C;dependency>
            &#x3C;groupId>jakarta.validation&#x3C;/groupId>
            &#x3C;artifactId>jakarta.validation-api&#x3C;/artifactId>
        &#x3C;/dependency>

        &#x3C;!-- MapStruct -->
        &#x3C;dependency>
            &#x3C;groupId>org.mapstruct&#x3C;/groupId>
            &#x3C;artifactId>mapstruct&#x3C;/artifactId>
            &#x3C;version>1.5.5.Final&#x3C;/version>
        &#x3C;/dependency>

        &#x3C;!-- Swagger/OpenAPI -->
        &#x3C;dependency>
            &#x3C;groupId>org.springdoc&#x3C;/groupId>
            &#x3C;artifactId>springdoc-openapi-starter-webmvc-ui&#x3C;/artifactId>
            &#x3C;version>2.1.0&#x3C;/version>
        &#x3C;/dependency>

        &#x3C;!-- Test -->
        &#x3C;dependency>
            &#x3C;groupId>org.springframework.boot&#x3C;/groupId>
            &#x3C;artifactId>spring-boot-starter-test&#x3C;/artifactId>
            &#x3C;scope>test&#x3C;/scope>
        &#x3C;/dependency>
    &#x3C;/dependencies>
&#x3C;/project>
</code></pre>

### Application Properties File

application.properties

```properties
spring.datasource.url=jdbc:oracle:thin:@localhost:1521:xe
spring.datasource.username=your_oracle_user
spring.datasource.password=your_password
spring.datasource.driver-class-name=oracle.jdbc.OracleDriver

spring.jpa.hibernate.ddl-auto=none
spring.jpa.show-sql=true
spring.jpa.database-platform=org.hibernate.dialect.Oracle12cDialect

server.port=8080
```

### Main Class File

EmployeePortalApplication.java&#x20;

```java
package com.company.employeeportal;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class EmployeePortalApplication {
    public static void main(String[] args) {
        SpringApplication.run(EmployeePortalApplication.class, args);
    }
}
```

### Entity Class Files

#### Employee.java

```java
@Entity
@Table(name = "employees")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Employee {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String email;
    private String phone;

    @Temporal(TemporalType.DATE)
    private Date hireDate;

    @ManyToOne
    @JoinColumn(name = "department_id", nullable = false)
    private Department department;

    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "address_id", referencedColumnName = "id")
    private Address address;

    @ManyToMany
    @JoinTable(
        name = "employee_project",
        joinColumns = @JoinColumn(name = "employee_id"),
        inverseJoinColumns = @JoinColumn(name = "project_id")
    )
    private Set<Project> projects = new HashSet<>();

    @OneToMany(mappedBy = "employee", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Salary> salaries = new ArrayList<>();
}
```

#### Department.java

```java
@Entity
@Table(name = "departments")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Department {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String location;

    @OneToMany(mappedBy = "department")
    private List<Employee> employees = new ArrayList<>();
}
```

#### Address.java

```java
@Entity
@Table(name = "addresses")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Address {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String street;
    private String city;
    private String state;
    private String zip;
    private String country;

    @OneToOne(mappedBy = "address")
    private Employee employee;
}
```

#### Project.java

```java
@Entity
@Table(name = "projects")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Project {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String client;
    private Double budget;

    @ManyToMany(mappedBy = "projects")
    private Set<Employee> employees = new HashSet<>();
}
```

#### Salary.java

```java
@Entity
@Table(name = "salaries")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Salary {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "employee_id", nullable = false)
    private Employee employee;

    private Double baseSalary;
    private Double bonus;
    private Double deductions;
    private String month;
    private Integer year;
    private String status;

    @OneToMany(mappedBy = "salary", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<PaymentHistory> paymentHistories = new ArrayList<>();
}
```

#### PaymentHistory.java

```java
@Entity
@Table(name = "payment_history")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class PaymentHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "salary_id", nullable = false)
    private Salary salary;

    @Temporal(TemporalType.DATE)
    private Date paymentDate;

    private Double amountPaid;
    private String paymentMode;
    private String remarks;
}
```

{% hint style="info" %}
The `employee_project` table is a **join table** handled implicitly by the `@ManyToMany` mappings in both `Employee` and `Project`, so no separate entity is required unless we want to add extra fields (like assignment date).
{% endhint %}

