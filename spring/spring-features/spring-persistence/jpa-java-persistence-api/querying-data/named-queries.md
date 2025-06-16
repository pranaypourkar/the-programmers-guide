# Named Queries

## About

**Named Queries** in JPA are pre-defined static queries that are given a name and defined either via annotations or XML. These queries are typically written in JPQL and are associated with entity classes. Once defined, they can be invoked by name through the `EntityManager` or Spring Data JPA repository.

## Why use Named Queries?

* Centralized query management
* Reuse across multiple classes/methods
* Better for static, frequently-used queries
* Pre-compilation in some JPA implementations for performance boost

## Characteristics

<table data-full-width="true"><thead><tr><th width="253.390625">Feature</th><th>Description</th></tr></thead><tbody><tr><td><strong>Static</strong></td><td>Defined once and reused; cannot be dynamically changed.</td></tr><tr><td><strong>Precompiled</strong></td><td>May be compiled during startup (depends on JPA provider like Hibernate).</td></tr><tr><td><strong>Scoped to Entity</strong></td><td>Defined on an entity class.</td></tr><tr><td><strong>Readable and Reusable</strong></td><td>Named queries can be referenced easily throughout the application.</td></tr><tr><td><strong>Better for Shared Queries</strong></td><td>Useful when multiple services/repositories use the same query.</td></tr></tbody></table>

## Syntax Structure

### Annotation-based Named Query

Use `@NamedQuery` or `@NamedQueries` on the entity class.

```java
@Entity
@NamedQuery(
    name = "Employee.findByDepartment",
    query = "SELECT e FROM Employee e WHERE e.department = :dept"
)
public class Employee {
    @Id
    private Long id;
    private String name;
    private String department;
}
```

### XML-based Named Query (persistence.xml)

```xml
<named-query name="Employee.findByDepartment">
    <query>SELECT e FROM Employee e WHERE e.department = :dept</query>
</named-query>
```

### Accessing Named Query

**Using `EntityManager`:**

```java
List<Employee> employees = entityManager
    .createNamedQuery("Employee.findByDepartment", Employee.class)
    .setParameter("dept", "IT")
    .getResultList();
```

**Using Spring Data JPA:**

```java
@Query(name = "Employee.findByDepartment")
List<Employee> findByDepartment(@Param("dept") String department);
```

{% hint style="info" %}
**Note:** If the named query is not found, we’ll get a runtime error.
{% endhint %}

{% hint style="info" %}
`@Query("SELECT e FROM Employee e WHERE e.department = :dept")`\
`List findByDepartment(@Param("dept") String department);`\


This is not a named query — it’s an inline JPQL query, and it's often preferred for simplicity when the query is short or used in only one place.
{% endhint %}

## Where Can You Declare Named Queries?

### 1. **On the Entity Class (Most Common & Recommended)**

This is the standard and preferred way.

```java
@Entity
@NamedQuery(
    name = "Employee.findByDepartment",
    query = "SELECT e FROM Employee e WHERE e.department = :dept"
)
public class Employee {
    // fields...
}
```

The JPA provider scans the entity class and registers the query automatically at startup.

### 2. **In `persistence.xml` (Less Common)**

We can define named queries in XML instead of annotations.

```xml
<named-query name="Employee.findByDepartment">
    <query>SELECT e FROM Employee e WHERE e.department = :dept</query>
</named-query>
```

Useful when:

* We don’t want query logic in code.
* We are externalizing queries for maintainability or tools.

### 3. **In Mapped Superclass or Embeddable?**

**Not supported.** We cannot define `@NamedQuery` inside a `@MappedSuperclass` or `@Embeddable`.

### 4. **Outside Entity Class?**

There’s no support for declaring named queries in arbitrary classes or repositories.

However, if we're using **Spring Data JPA**, we can define static queries using `@Query` in repository interfaces **instead of NamedQuery**.

```java
@Query("SELECT e FROM Employee e WHERE e.department = :dept")
List<Employee> findByDepartment(@Param("dept") String dept);
```

Equivalent in functionality, but avoids the need for `@NamedQuery`.

## Examples

### 1. Find Employees by Department

```java
@NamedQuery(
    name = "Employee.findByDepartment",
    query = "SELECT e FROM Employee e WHERE e.department = :dept"
)
```

```java
List<Employee> result = em.createNamedQuery("Employee.findByDepartment", Employee.class)
                          .setParameter("dept", "Sales")
                          .getResultList();
```

### 2. Find Employees with Salary Above Threshold

```java
@NamedQuery(
    name = "Employee.findHighEarners",
    query = "SELECT e FROM Employee e WHERE e.salary > :minSalary"
)
```

### 3. Count Employees in Department

```java
@NamedQuery(
    name = "Employee.countByDepartment",
    query = "SELECT COUNT(e) FROM Employee e WHERE e.department = :dept"
)
```
