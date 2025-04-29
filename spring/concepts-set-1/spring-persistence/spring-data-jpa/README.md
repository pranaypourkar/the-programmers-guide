# Spring Data JPA

## About

**Spring Data JPA** is a part of the larger **Spring Data** family. It is a **framework** that:

* Simplifies the **implementation** of **data access layers** using **JPA** (Java Persistence API).
* Reduces the amount of **boilerplate** code for repository classes.
* Provides ready-to-use **CRUD**, **pagination**, **sorting**, **query** creation **without writing any SQL/JPAQL manually** (unless needed).
* Integrates seamlessly with **Hibernate** (or any other JPA provider).

{% hint style="info" %}
Spring Data JPA = Spring + JPA (Hibernate or others) + Repository Abstraction + Query Generation
{% endhint %}

## Why Spring Data JPA?

Traditional JPA (or Hibernate) involves a lot of **repetitive code**:

```java
EntityManager em = entityManagerFactory.createEntityManager();
Employee emp = em.find(Employee.class, id);
```

**Spring Data JPA** abstracts and automates these things by just providing an **interface**.\
Example:

```java
public interface EmployeeRepository extends JpaRepository<Employee, Long> {
}
```

No need to manually open/close `EntityManager`, no manual queries for basic operations.

## Components of Spring Data JPA

<table data-full-width="true"><thead><tr><th width="230.29296875">Component</th><th>Description</th></tr></thead><tbody><tr><td><strong>Repository Interfaces</strong></td><td>Abstractions like <code>JpaRepository</code>, <code>CrudRepository</code>, <code>PagingAndSortingRepository</code> for different functionalities.</td></tr><tr><td><strong>Query Methods</strong></td><td>Define methods in interfaces; Spring Data JPA automatically generates queries based on method names.</td></tr><tr><td><strong>Custom Queries</strong></td><td>Create your own JPQL/SQL queries using <code>@Query</code>.</td></tr><tr><td><strong>Specifications</strong></td><td>Build dynamic, type-safe queries.</td></tr><tr><td><strong>Projections</strong></td><td>Fetch only required data instead of entire entity.</td></tr><tr><td><strong>Auditing</strong></td><td>Automatic tracking of entity creation, modification timestamps.</td></tr><tr><td><strong>Pagination &#x26; Sorting</strong></td><td>Built-in support for pageable results.</td></tr><tr><td><strong>Transactional Support</strong></td><td>Integrated with Spring’s <code>@Transactional</code> management.</td></tr></tbody></table>

## Commonly Used Spring Data JPA Interfaces

<table data-full-width="true"><thead><tr><th width="302.95703125">Interface</th><th>Purpose</th></tr></thead><tbody><tr><td><strong>CrudRepository&#x3C;T, ID></strong></td><td>Basic CRUD operations: save, find, delete.</td></tr><tr><td><strong>PagingAndSortingRepository&#x3C;T, ID></strong></td><td>Extends <code>CrudRepository</code>; adds paging and sorting features.</td></tr><tr><td><strong>JpaRepository&#x3C;T, ID></strong></td><td>Extends <code>PagingAndSortingRepository</code>; adds JPA-specific operations like batch delete, flush, etc.</td></tr><tr><td><strong>JpaSpecificationExecutor&#x3C;T></strong></td><td>Execute dynamic queries using JPA Criteria API (Specifications).</td></tr><tr><td><strong>QueryByExampleExecutor&#x3C;T></strong></td><td>Query entities based on example instances.</td></tr></tbody></table>

## **How Spring Data JPA Works Internally**

When we define a simple **repository interface** like:

```java
public interface EmployeeRepository extends JpaRepository<Employee, Long> { }
```

Spring Data JPA **automatically** provides the implementation of this interface **at runtime** — we **do not** have to implement it manually.

<table><thead><tr><th width="71.74609375">Step</th><th>Action</th></tr></thead><tbody><tr><td>1</td><td>Spring Boot scans for Repository Interfaces during startup.</td></tr><tr><td>2</td><td>A Proxy (Dynamic Implementation) of the repository is created.</td></tr><tr><td>3</td><td>Proxy uses <strong>JpaRepositoryFactory</strong> to produce repository beans.</td></tr><tr><td>4</td><td>Proxy internally uses an <strong>EntityManager</strong> to perform operations.</td></tr><tr><td>5</td><td>Method names are parsed and converted into JPA Queries automatically.</td></tr><tr><td>6</td><td>Transactional behavior is automatically managed.</td></tr></tbody></table>

### Step 1: Component Scanning

* Spring Boot auto-configures JPA when it detects `spring-boot-starter-data-jpa` in the classpath.
* It scans the **package** and **sub-packages** for interfaces extending `JpaRepository`, `CrudRepository`, or other repository markers.

The scan happens using annotations like:

```java
@EnableJpaRepositories(basePackages = "com.example.repository")
```

Or if we don't explicitly configure it, **Spring Boot auto-detects** based on the location of your `@SpringBootApplication` class.

### Step 2: Repository Proxy Generation

* Spring uses a **dynamic proxy** (`JDK Dynamic Proxy` or `CGLIB Proxy`) to **create a runtime implementation** of your repository interface.
* This proxy does **not** contain any handwritten logic; instead, it delegates calls to the correct logic.

The key class responsible is:\
&#xNAN;**`org.springframework.data.jpa.repository.support.JpaRepositoryFactoryBean`**

This class creates a `JpaRepositoryFactory`, which then builds a **repository proxy**.

### Step 3: EntityManager Injection

* Every generated repository proxy is injected with a **JPA `EntityManager`**.
* `EntityManager` is the main API for persisting, finding, updating, and removing entities in JPA.

**`JpaEntityInformation`** (meta-information about the entity) is also associated with each repository.

So when we call `save()`, `findById()`, etc., **the proxy simply delegates to methods on `EntityManager`** like:

```java
entityManager.persist(entity);
entityManager.find(Entity.class, id);
```

### Step 4: Parsing Method Names into Queries

If we define a method like:

```java
List<Employee> findByDepartment(String department);
```

Spring Data JPA:

* **Parses** method name (`findByDepartment`)
* **Creates JPQL** query:

```jpql
SELECT e FROM Employee e WHERE e.department = :department
```

This parsing is powered by:\
&#xNAN;**`org.springframework.data.repository.query.parser.PartTree`**

Spring **does not require you to write the query manually** unless it’s too complex.

### Step 5: Executing Custom Queries

When we add:

```java
@Query("SELECT e FROM Employee e WHERE e.department = :dept")
List<Employee> fetchByDepartment(@Param("dept") String department);
```

Spring Data JPA detects the `@Query` annotation and uses it **instead of parsing the method name**.

The execution pipeline is handled by `SimpleJpaQuery` or custom `QueryLookupStrategy`.

### Step 6: Transaction Management

* By default, Spring Data JPA repositories operate inside a **transactional context**.
* The methods like `save()`, `delete()`, etc., are **automatically transactional**.
* Spring Boot configures transaction management using `@EnableTransactionManagement`.

If needed, we can override by putting `@Transactional(readOnly = true)` on repository methods.

### Key Internal Classes Involved

<table data-full-width="true"><thead><tr><th width="250.32421875">Class</th><th>Purpose</th></tr></thead><tbody><tr><td><code>JpaRepositoryFactoryBean</code></td><td>Responsible for creating repository proxies.</td></tr><tr><td><code>JpaRepositoryFactory</code></td><td>Creates repository implementations dynamically.</td></tr><tr><td><code>SimpleJpaRepository</code></td><td>Default implementation of repository logic.</td></tr><tr><td><code>EntityManager</code></td><td>Core JPA component for persistence operations.</td></tr><tr><td><code>PartTree</code></td><td>Parses query methods into JPQL.</td></tr><tr><td><code>QueryLookupStrategy</code></td><td>Strategy interface for looking up queries (derived, annotated, or named queries).</td></tr></tbody></table>

### Example Internal Flow

Suppose we have this repository:

```java
public interface EmployeeRepository extends JpaRepository<Employee, Long> {
    List<Employee> findByName(String name);
}
```

The behind-the-scenes flow will be:

<table data-full-width="true"><thead><tr><th width="83.43359375">Step</th><th>What Happens</th></tr></thead><tbody><tr><td>1</td><td>Spring Boot scans and finds <code>EmployeeRepository</code>.</td></tr><tr><td>2</td><td><code>JpaRepositoryFactoryBean</code> creates a dynamic proxy.</td></tr><tr><td>3</td><td>Proxy is linked to an <code>EntityManager</code>.</td></tr><tr><td>4</td><td>You call <code>findByName("John")</code>.</td></tr><tr><td>5</td><td>Proxy parses method → generates JPQL → binds parameter <code>"John"</code>.</td></tr><tr><td>6</td><td>Query is executed via <code>EntityManager</code> under a transactional context.</td></tr><tr><td>7</td><td>Result (List of Employees) is returned to you.</td></tr></tbody></table>







