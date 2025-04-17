# Querying Data

## About

Querying is one of the most critical parts of working with JPA. JPA provides multiple ways to **retrieve, filter, and manipulate** data from the database using object-oriented approaches rather than SQL. This simplifies development and improves maintainability.

## Types of Queries in JPA

JPA supports four main ways to query data:

1. JPQL (Java Persistence Query Language)
2. Criteria API
3. Native SQL Queries
4. Derived Query Methods (Spring Data JPA)

## 1. JPQL (Java Persistence Query Language)

### About

**JPQL** stands for **Java Persistence Query Language**. It is the **standard query language of JPA** (Java Persistence API) and is used to query **Java entity objects** instead of database tables directly.

### Characteristics

<table><thead><tr><th width="195.35546875">Feature</th><th>Description</th></tr></thead><tbody><tr><td><strong>Object-Oriented</strong></td><td>Operates on entity objects, not tables or columns.</td></tr><tr><td><strong>Portable</strong></td><td>Not tied to a specific database vendor.</td></tr><tr><td><strong>Static / Dynamic</strong></td><td>Can be defined at compile-time or built dynamically at runtime.</td></tr><tr><td><strong>Supports Joins</strong></td><td>Can navigate object relationships using JOIN.</td></tr><tr><td><strong>Part of JPA Standard</strong></td><td>Fully standardized across JPA providers (Hibernate, EclipseLink, etc).</td></tr></tbody></table>

### Syntax Structure

```sql
SELECT <select_clause>
FROM <entity_class> [AS] <alias>
[WHERE <conditions>]
[GROUP BY ...]
[HAVING ...]
[ORDER BY ...]
```

#### Example

```java
SELECT e FROM Employee e WHERE e.department.name = 'IT'
```

### JPQL vs SQL

<table><thead><tr><th width="169.48046875">Feature</th><th>SQL</th><th>JPQL</th></tr></thead><tbody><tr><td>Targets</td><td>Tables and Columns</td><td>Entities and Fields</td></tr><tr><td>Joins</td><td>Based on foreign keys</td><td>Based on object relationships</td></tr><tr><td>Type</td><td>Database-level</td><td>Application-level abstraction</td></tr><tr><td>Portability</td><td>Vendor-specific</td><td>Vendor-agnostic</td></tr></tbody></table>



## 2. Criteria API

### **About**

The **Criteria API** is a **type-safe, programmatic** way of building dynamic queries using Java objects and methods rather than writing strings. It's especially useful for building complex queries where the structure is determined at runtime.

### **Characteristics**

* **Type-safe**: Catches syntax and field errors at compile time.
* **Dynamic**: Ideal for building queries with user-driven filters.
* **Verbose**: Requires more boilerplate than JPQL.
* **Integrated with Metamodel**: Can use static metamodel classes for even more type safety.
* **Portable**: Part of the JPA specification and works across JPA providers.

### **Syntax Structure**

```java
CriteriaBuilder cb = em.getCriteriaBuilder();
CriteriaQuery<Employee> cq = cb.createQuery(Employee.class);
Root<Employee> root = cq.from(Employee.class);
cq.select(root).where(cb.equal(root.get("department"), "IT"));
List<Employee> results = em.createQuery(cq).getResultList();
```

### Criteria API vs JPQL

<table data-full-width="true"><thead><tr><th width="230.50390625">Feature</th><th>Criteria API</th><th>JPQL</th></tr></thead><tbody><tr><td>Query Type</td><td>Object-oriented, Java code</td><td>String-based query language</td></tr><tr><td>Type Safety</td><td>Compile-time checked</td><td>X Runtime only</td></tr><tr><td>Dynamic Querying</td><td>Strong support</td><td>Requires string concatenation</td></tr><tr><td>Readability</td><td>Verbose and less readable</td><td>More concise and readable</td></tr><tr><td>Maintainability</td><td>Refactor-friendly</td><td>Errors possible if entity fields renamed</td></tr><tr><td>Ideal Use Case</td><td>Complex, conditional filters</td><td>Simple to moderately complex queries</td></tr></tbody></table>

### 3. Native SQL

### **About**

**Native SQL queries** in JPA allow you to write plain SQL and run it through JPA. These are useful when you need database-specific functionality, use raw SQL joins, stored procedures, or complex queries not supported by JPQL.

### **Characteristics**

* **Full SQL power**: Uses complete database syntax.
* **Database dependent**: Tied to a specific RDBMS dialect.
* **Bypasses abstraction**: Operates directly on DB tables.
* **Less portable**: Might break if the DB vendor changes.
* **Mapping required**: You can map results to entities or DTOs manually.

### **Syntax Structure**

```java
Query query = em.createNativeQuery("SELECT * FROM employee WHERE status = ?", Employee.class);
query.setParameter(1, "ACTIVE");
List<Employee> result = query.getResultList();
```

### **Native SQL vs JPQL**

<table data-full-width="true"><thead><tr><th width="208.21875">Feature</th><th>Native SQL</th><th>JPQL</th></tr></thead><tbody><tr><td>Syntax</td><td>Raw SQL</td><td>Object-oriented query</td></tr><tr><td>Portability</td><td>XVendor-specific</td><td>Portable across DBs</td></tr><tr><td>Entity Awareness</td><td>X Works with tables</td><td>Works with entities</td></tr><tr><td>Use of ORM Features</td><td>X Limited or manual</td><td>Fully integrat</td></tr><tr><td>Use Case</td><td>Complex SQL, vendor-specific logic</td><td>Standard CRUD and entity navigation</td></tr></tbody></table>

### 4. Named Queries

### **About**

**Named Queries** are **static, pre-defined JPQL queries** that are defined using annotations (typically on the entity class). They promote reuse and centralize query logic.

**Characteristics**

* **Static and pre-compiled**: Verified at deployment.
* **Reusable**: Can be called anywhere via name.
* **Maintainable**: Kept with the entity for better encapsulation.
* **Optimizable**: Some providers pre-parse/optimize them.
* **Supports both JPQL and native**: Use `@NamedQuery` or `@NamedNativeQuery`.

### &#x20;**Syntax Structure**

```java
@Entity
@NamedQuery(
    name = "Employee.findByStatus",
    query = "SELECT e FROM Employee e WHERE e.status = :status"
)
```

Usage:

```java
em.createNamedQuery("Employee.findByStatus")
  .setParameter("status", "ACTIVE")
  .getResultList();
```

**Named Query vs JPQL**

<table><thead><tr><th width="164.66796875">Feature</th><th width="207.25">Named Query</th><th>JPQL</th></tr></thead><tbody><tr><td>Definition Time</td><td>Compile time</td><td>Runtime</td></tr><tr><td>Reusability</td><td>Easily reused</td><td>Needs to be redefined each time</td></tr><tr><td>Location</td><td>In entity or XML config</td><td>Inline in code</td></tr><tr><td>Maintainability</td><td>Centralized</td><td>Scattered</td></tr><tr><td>Use Case</td><td>Frequently used queries</td><td>One-off, dynamic, or simple queries</td></tr></tbody></table>
