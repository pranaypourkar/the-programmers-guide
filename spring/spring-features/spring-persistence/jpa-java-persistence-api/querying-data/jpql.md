# JPQL

## About

**JPQL** is the object-oriented query language defined by the **Java Persistence API (JPA)**. It’s similar in syntax to SQL but operates on the **entity object model** rather than directly on database tables.

* **SQL** works on tables, rows, columns.
* **JPQL** works on entities, fields, relationships.

## Some of the Features of JPQL

* Queries entities and their relationships using object-based syntax.
* Supports CRUD operations using HQL-like statements.
* Abstracts underlying SQL and RDBMS-specific queries.
* Enables navigation across **entity relationships** like `@OneToMany`, `@ManyToOne`.
* Strongly integrated with **JPA EntityManager**.

## JPQL Query Types

### 1. Basic SELECT

Fetch entities or specific fields from a table (entity).

```java
TypedQuery<Employee> query = em.createQuery(
  "SELECT e FROM Employee e", Employee.class);
List<Employee> result = query.getResultList();
```

_Fetch all employees from the database._

### 2. SELECT with WHERE Clause

```java
TypedQuery<Employee> query = em.createQuery(
  "SELECT e FROM Employee e WHERE e.department = :dept", Employee.class);
query.setParameter("dept", "Finance");
```

_Find all employees in the Finance department._

### 3. Selecting Specific Fields (Projection)

```java
TypedQuery<String> query = em.createQuery(
  "SELECT e.name FROM Employee e", String.class);
```

_Fetch just the names of all employees._

Or multiple fields:

```java
TypedQuery<Object[]> query = em.createQuery(
  "SELECT e.name, e.salary FROM Employee e", Object[].class);
```

### 4. Using Aggregate Functions

```java
Query query = em.createQuery(
  "SELECT AVG(e.salary) FROM Employee e");
Double averageSalary = (Double) query.getSingleResult();
```

_Get average salary across all employees._

### 5. GROUP BY and HAVING

```java
Query query = em.createQuery(
  "SELECT e.department, COUNT(e) FROM Employee e GROUP BY e.department HAVING COUNT(e) > 5");
```

_Find departments with more than 5 employees._

### 6. JOINs (Entity Relationships)

**JPQL handles joins using entity fields, not tables.**

```java
TypedQuery<Project> query = em.createQuery(
  "SELECT p FROM Project p JOIN p.employees e WHERE e.name = :name", Project.class);
query.setParameter("name", "John Doe");
```

_Get projects where John Doe is assigned._

### 7. ORDER BY Clause

```java
TypedQuery<Employee> query = em.createQuery(
  "SELECT e FROM Employee e ORDER BY e.salary DESC", Employee.class);
```

_List employees sorted by salary (highest first)._

### 8. IN Clause

```java
List<String> departments = List.of("IT", "HR");
TypedQuery<Employee> query = em.createQuery(
  "SELECT e FROM Employee e WHERE e.department IN :departments", Employee.class);
query.setParameter("departments", departments);
```

_Get employees from IT or HR._

### 9. LIKE Clause (Pattern Matching)

```java
TypedQuery<Employee> query = em.createQuery(
  "SELECT e FROM Employee e WHERE e.name LIKE :name", Employee.class);
query.setParameter("name", "A%");
```

_Find employees whose name starts with 'A'._

### 10. Subqueries

```java
TypedQuery<Employee> query = em.createQuery(
  "SELECT e FROM Employee e WHERE e.salary > (SELECT AVG(e2.salary) FROM Employee e2)", Employee.class);
```

_Get employees earning above the average salary._

### 11. UPDATE and DELETE

> JPQL supports `UPDATE` and `DELETE`, but **not INSERT**.

**UPDATE**

```java
Query query = em.createQuery(
  "UPDATE Employee e SET e.salary = e.salary * 1.1 WHERE e.department = :dept");
query.setParameter("dept", "IT");
int updated = query.executeUpdate();
```

_Give 10% raise to IT department._

**DELETE**

```java
Query query = em.createQuery(
  "DELETE FROM Employee e WHERE e.status = :status");
query.setParameter("status", "INACTIVE");
int deleted = query.executeUpdate();
```

_Remove all inactive employees._

### 12. Constructor Expressions (DTO Projection)

```java
TypedQuery<EmployeeDTO> query = em.createQuery(
  "SELECT new com.example.EmployeeDTO(e.name, e.salary) FROM Employee e", EmployeeDTO.class);
```

_Return results in a custom DTO._

## Limitations of JPQL

* No support for **INSERT**.
* Complex SQL (window functions, full joins, recursive CTEs) not supported.
* Limited database-specific syntax (must switch to native queries).







