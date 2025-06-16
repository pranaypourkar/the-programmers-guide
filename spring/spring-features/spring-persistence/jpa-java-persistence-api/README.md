# JPA (Java Persistence API)

## About

**JPA (Java Persistence API)** is a standard specification provided by Java EE (now Jakarta EE) for **object-relational mapping (ORM)** in Java applications. It provides a **standardized and annotation-based** way to map Java objects to relational database tables.

JPA is **not a framework itself**, but a **set of interfaces**. Actual implementations like **Hibernate**, **EclipseLink**, and **OpenJPA** provide the working functionality.

## Why JPA?

* Reduces boilerplate JDBC code
* Simplifies CRUD and query operations
* Promotes maintainability using object-oriented approaches
* Encourages cleaner domain-driven designs
* Standardizes persistence layer across frameworks

## JPA Implementations

Since **JPA (Java Persistence API)** is just a **specification**, it needs an actual **implementation** (a library/framework) to work at runtime. Below are the most popular and widely used **implementations of JPA.**

### 1. Hibernate (ORM)

* Most widely used JPA implementation.
* Developed by Red Hat.
* Implements both **JPA specification** and its own **extended ORM features**.
* Provides:
  * First-level and second-level caching
  * Lazy loading, dirty checking
  * Support for JPQL, HQL (Hibernate Query Language)
  * Advanced features: filters, interceptors, custom types, etc.
* **Default JPA provider** in Spring Boot.

### 2. EclipseLink

* Reference implementation of JPA (especially JPA 2.1+).
* Developed by the Eclipse Foundation.
* Originally based on Oracle TopLink.
* Focuses on enterprise-grade applications and JPA compliance.
* Offers extended features like NoSQL support and weaving.

Use when:

* We want a vendor-neutral JPA implementation.
* We work with Jakarta EE stack or GlassFish.

### 3. OpenJPA

* Developed by Apache Software Foundation.
* Fully compliant with the JPA specification.
* Less popular than Hibernate or EclipseLink.
* Used in some legacy enterprise environments.

Use when:

* Working with Apache or open-source-heavy stacks.
* We want a lightweight, extensible JPA provider.

### 4. DataNucleus

* Supports not only JPA but also JDO (Java Data Objects).
* Supports both relational and NoSQL databases (MongoDB, HBase, etc.).
* Good for polyglot persistence environments.

Use when:

* We want to mix relational and non-relational DBs.
* Working with multi-database types.

### 5. TopLink (Oracle)

* One of the oldest ORM tools, originally from Oracle.
* Oracle’s proprietary JPA implementation.
* Often used in Oracle Fusion Middleware or WebLogic applications.
* EclipseLink is the open-source continuation of TopLink.

## Querying in JPA

Querying in JPA is used to **retrieve and manipulate data** stored in a relational database using **object-oriented concepts**. JPA provides **three powerful querying approaches.**

### 1. JPQL (Java Persistence Query Language)

#### What is JPQL?

JPQL is an **object-oriented query language** similar to SQL but it works **with entity objects and their properties** instead of tables and columns.

* **Portable** across databases
* **Type-safe** (when using TypedQuery)
* **Supports joins, subqueries, aggregation**

#### Syntax Highlights

```java
SELECT e FROM Employee e WHERE e.salary > 5000
```

* `Employee` is an **entity class**, not a table.
* `e.salary` is a **field**, not a column.

#### Parameters

**Named:**

```java
Query query = em.createQuery("SELECT e FROM Employee e WHERE e.name = :name");
query.setParameter("name", "John");
```

**Positional:**

```java
Query query = em.createQuery("SELECT e FROM Employee e WHERE e.name = ?1");
query.setParameter(1, "John");
```

#### TypedQuery

```java
TypedQuery<Employee> query = em.createQuery("SELECT e FROM Employee e", Employee.class);
List<Employee> resultList = query.getResultList();
```

#### Common JPQL Keywords

* `SELECT`, `FROM`, `WHERE`, `GROUP BY`, `HAVING`, `ORDER BY`
* `JOIN`, `LEFT JOIN`, `FETCH`
* `IN`, `IS NULL`, `BETWEEN`, `LIKE`

### 2. Criteria API

#### What is Criteria API?

The Criteria API is a **type-safe, object-oriented alternative to JPQL** that builds queries dynamically using Java code.

* Useful for **dynamic queries** (e.g., based on optional filters)
* Avoids **string-based** query issues (compile-time safety)

#### Example: Find Employees by Department

```java
CriteriaBuilder cb = em.getCriteriaBuilder();
CriteriaQuery<Employee> cq = cb.createQuery(Employee.class);
Root<Employee> root = cq.from(Employee.class);
cq.select(root).where(cb.equal(root.get("department"), "IT"));
List<Employee> results = em.createQuery(cq).getResultList();
```

#### Components

<table><thead><tr><th width="281.1953125">Component</th><th>Purpose</th></tr></thead><tbody><tr><td><code>CriteriaBuilder</code></td><td>Entry point to create query objects</td></tr><tr><td><code>CriteriaQuery</code></td><td>Represents the overall query</td></tr><tr><td><code>Root&#x3C;T></code></td><td>Represents the root entity</td></tr><tr><td><code>Predicate</code></td><td>Represents the conditions (WHERE)</td></tr><tr><td><code>Join</code></td><td>Used to join entities</td></tr></tbody></table>

### 3. Native SQL Queries

#### What is Native Query?

JPA allows execution of **raw SQL queries** when JPQL or Criteria API is insufficient or inefficient.

```java
Query query = em.createNativeQuery("SELECT * FROM employees WHERE salary > ?", Employee.class);
query.setParameter(1, 5000);
List<Employee> results = query.getResultList();
```

#### When to Use Native Queries?

* Vendor-specific optimizations
* Complex joins or aggregations not easily expressible in JPQL
* Performance-critical paths

### 4. Named Queries

Named Queries are **predefined static queries** written using JPQL or SQL, usually placed at the entity level using annotations:

#### JPQL Named Query

```java
@Entity
@NamedQuery(
  name = "Employee.findByDepartment",
  query = "SELECT e FROM Employee e WHERE e.department = :dept"
)
public class Employee { ... }
```

#### Usage

```java
List<Employee> emps = em.createNamedQuery("Employee.findByDepartment", Employee.class)
                        .setParameter("dept", "IT")
                        .getResultList();
```

### 5. Query Return Types

<table><thead><tr><th width="320.109375">Return Type</th><th>Description</th></tr></thead><tbody><tr><td><code>Entity</code></td><td>Returns full entity objects</td></tr><tr><td><code>Object[]</code></td><td>Returns selected fields from multiple columns</td></tr><tr><td><code>List&#x3C;Object[]></code></td><td>Used for projections or joins</td></tr><tr><td><code>DTO (custom)</code></td><td>Use constructor expressions or mapping logic</td></tr></tbody></table>

#### DTO Projection Example

```java
SELECT new com.example.dto.EmpDTO(e.name, e.salary) FROM Employee e
```

### 6. Pagination

Use `setFirstResult` and `setMaxResults` for paginated queries.

```java
TypedQuery<Employee> query = em.createQuery("SELECT e FROM Employee e", Employee.class);
query.setFirstResult(0);
query.setMaxResults(10);
List<Employee> page = query.getResultList();
```

### 7. Common Query Scenarios

| Scenario                 | Query Type      | Notes                       |
| ------------------------ | --------------- | --------------------------- |
| Dynamic search filters   | Criteria API    | Build predicates at runtime |
| Simple static search     | JPQL            | Easy and readable           |
| DB-specific optimization | Native SQL      | Use with caution            |
| Complex projections      | JPQL / Native   | Use `new` or `Object[]`     |
| Sorting and pagination   | JPQL / Criteria | Easily supported            |

## JPA vs Hibernate

<table data-full-width="true"><thead><tr><th width="144.5078125">Feature</th><th width="357.17578125">JPA</th><th>Hibernate</th></tr></thead><tbody><tr><td>Type</td><td>Specification (API)</td><td>Implementation of JPA (and more)</td></tr><tr><td>Standardized?</td><td>Yes (javax.persistence / jakarta.persistence)</td><td>No, but widely adopted</td></tr><tr><td>Provider?</td><td>No (you need an implementation)</td><td>Yes</td></tr><tr><td>Features</td><td>Basic ORM</td><td>Advanced features like caching, filters, validations</td></tr></tbody></table>
