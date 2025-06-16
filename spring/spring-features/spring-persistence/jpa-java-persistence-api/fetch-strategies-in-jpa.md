# Fetch Strategies in JPA

## About

* In JPA, `FetchType` defines **when and how** related entities or fields are **loaded** from the database **when an entity is accessed**.
* It determines the **loading behavior** of associations (`@OneToOne`, `@OneToMany`, `@ManyToOne`, `@ManyToMany`) **and large fields** (`@Lob`).
* Fetching means retrieving associated data when we load the main entity.

## FetchType Types

There are **two** types:

<table><thead><tr><th width="132.28125">FetchType</th><th>Description</th></tr></thead><tbody><tr><td><strong>EAGER</strong></td><td>Load the related entity <strong>immediately</strong> when the main entity is loaded.</td></tr><tr><td><strong>LAZY</strong></td><td>Load the related entity <strong>only when explicitly accessed</strong> (on demand).</td></tr></tbody></table>

## Default Fetch Types (By Relationship Type)

Depending on the kind of relationship, **JPA defines a default FetchType**:

<table><thead><tr><th width="235.78515625">Relationship Type</th><th>Default FetchType</th></tr></thead><tbody><tr><td><code>@ManyToOne</code></td><td>EAGER</td></tr><tr><td><code>@OneToOne</code></td><td>EAGER</td></tr><tr><td><code>@OneToMany</code></td><td>LAZY</td></tr><tr><td><code>@ManyToMany</code></td><td>LAZY</td></tr><tr><td><code>@ElementCollection</code></td><td>LAZY</td></tr><tr><td><code>@Lob</code> fields</td><td>LAZY (recommended, but implementation-dependent)</td></tr></tbody></table>

## Example

### Entity Classes

```java
@Entity
public class Employee {
    @Id
    private Long id;
    
    private String name;

    @ManyToOne(fetch = FetchType.LAZY)
    private Department department;
}
```

```java
@Entity
public class Department {
    @Id
    private Long id;
    
    private String name;
}
```

### Fetching Behavior

#### **Case 1: LAZY Fetching**

```java
Employee emp = entityManager.find(Employee.class, 1L);
// Only employee data loaded
emp.getDepartment().getName(); 
// NOW a query is fired to fetch Department when we call getDepartment()
```

#### **Case 2: EAGER Fetching**

```java
@ManyToOne(fetch = FetchType.EAGER)
private Department department;
```

```java
Employee emp = entityManager.find(Employee.class, 1L);
// Employee + Department loaded together automatically in a JOIN query
```

## Problems With EAGER Fetching

* **Performance Hit**: Always brings associated data even if we don’t need it.
* **Multiple Joins**: In complex entity graphs, results in huge SQL queries with many joins → slows down the application.
* **Memory Usage**: Wastes memory by loading unnecessary data.
* **N+1 Query Problem**: When not handled properly, EAGER can result in additional hidden queries.

## Problems With LAZY Fetching

* **LazyInitializationException**:
  * Happens if we try to access a LAZY field **outside the transaction**.
  * Because the proxy cannot load the real data anymore — the EntityManager is closed.
* **Extra Queries**:
  * Each LAZY access can cause an extra database call if we don't fetch smartly.
  * Can cause **N+1 query problems** if not optimized.

### Solutions and Best Practices

<table data-full-width="true"><thead><tr><th width="360.4765625">Problem</th><th>Solution</th></tr></thead><tbody><tr><td>Avoid unnecessary EAGER loading</td><td>Use <code>FetchType.LAZY</code> by default wherever possible.</td></tr><tr><td>Need multiple associations loaded together?</td><td>Use <code>JOIN FETCH</code> in JPQL/HQL queries.</td></tr><tr><td>Avoid LazyInitializationException</td><td>Fetch necessary associations <strong>within</strong> the transaction or use DTO projections.</td></tr><tr><td>Complex graphs?</td><td>Consider <strong>Entity Graphs</strong> to control fetch dynamically.</td></tr><tr><td>Heavy fields (e.g., BLOB/CLOB)?</td><td>Always LAZY fetch them.</td></tr></tbody></table>

