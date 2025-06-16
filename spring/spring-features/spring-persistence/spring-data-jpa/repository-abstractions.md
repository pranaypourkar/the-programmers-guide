# Repository Abstractions

## About

In a typical Java application, if we want to interact with a database (e.g., fetch, insert, update records), we would traditionally:

* Write a **DAO (Data Access Object)** class manually
* Inject an `EntityManager`
* Manually create queries and handle exceptions

**Spring Data JPA** **abstracts** all that by providing a **Repository Layer**.

**Repository Abstraction** means:

> Hiding the complexity of data access layers through ready-made interfaces, while still providing flexibility for customization.

Instead of writing SQL/JPQL and managing `EntityManager` code manually, we just define interfaces - Spring Data JPA takes care of the rest.

## Evolution of Repository Abstractions

<table data-full-width="true"><thead><tr><th width="217.1640625">Level</th><th>Description</th></tr></thead><tbody><tr><td>DAO Pattern</td><td>You create classes to manage database operations manually (classic way).</td></tr><tr><td>JPA EntityManager</td><td>Java EE way to persist entities with EntityManager.</td></tr><tr><td>Spring Data Repositories</td><td>Modern abstraction: You <strong>only define interfaces</strong>; implementation is created automatically.</td></tr></tbody></table>

Spring Data JPA **builds a high-level abstraction** **on top of JPA** and **EntityManager**.

## Core Repository Interfaces in Spring Data

Spring Data JPA provides several **base interfaces** that we can extend:

<table data-full-width="true"><thead><tr><th width="322.93359375">Interface</th><th>Purpose</th></tr></thead><tbody><tr><td><code>Repository&#x3C;T, ID></code></td><td>Base marker interface — No methods, just identifies a repository.</td></tr><tr><td><code>CrudRepository&#x3C;T, ID></code></td><td>Provides basic CRUD methods like <code>save</code>, <code>findById</code>, <code>findAll</code>, <code>delete</code>.</td></tr><tr><td><code>PagingAndSortingRepository&#x3C;T, ID></code></td><td>Extends <code>CrudRepository</code> and adds pagination and sorting capabilities.</td></tr><tr><td><code>JpaRepository&#x3C;T, ID></code></td><td>Extends <code>PagingAndSortingRepository</code>; adds JPA-specific methods like <code>flush()</code>, <code>saveAll()</code>, <code>deleteInBatch()</code>.</td></tr><tr><td><code>QueryByExampleExecutor&#x3C;T></code></td><td>Allows query creation using Example (probe object) for dynamic search.</td></tr></tbody></table>

### 1. `Repository<T, ID>`

* Pure marker interface — **does not declare any method**.
* Purpose: Identify the type as a Repository for Spring Data to pick up.

```java
public interface MyRepository extends Repository<Employee, Long> { }
```

### 2. `CrudRepository<T, ID>`

* Provides **basic CRUD operations**:

| Method              | Description               |
| ------------------- | ------------------------- |
| `save(S entity)`    | Save an entity.           |
| `findById(ID id)`   | Find an entity by its ID. |
| `findAll()`         | Fetch all entities.       |
| `delete(T entity)`  | Delete an entity.         |
| `existsById(ID id)` | Check if entity exists.   |
| `count()`           | Get count of entities.    |

```java
public interface EmployeeRepository extends CrudRepository<Employee, Long> { }
```

### 3. `PagingAndSortingRepository<T, ID>`

* Extends `CrudRepository`.
* Adds **pagination** and **sorting** capabilities.

| Method                       | Description           |
| ---------------------------- | --------------------- |
| `findAll(Pageable pageable)` | Fetch paginated data. |
| `findAll(Sort sort)`         | Fetch sorted data.    |

```java
Page<Employee> findAll(Pageable pageable);
List<Employee> findAll(Sort sort);
```

### 4. `JpaRepository<T, ID>`

* Extends `PagingAndSortingRepository`.
* Adds **JPA-specific optimizations** like:

<table data-full-width="true"><thead><tr><th width="340.91796875">Method</th><th>Description</th></tr></thead><tbody><tr><td><code>flush()</code></td><td>Synchronizes persistence context to the database immediately.</td></tr><tr><td><code>saveAll(Iterable&#x3C;S> entities)</code></td><td>Batch save entities.</td></tr><tr><td><code>deleteInBatch(Iterable&#x3C;T> entities)</code></td><td>Batch delete.</td></tr><tr><td><code>findAllById(Iterable&#x3C;ID> ids)</code></td><td>Find all entities matching IDs.</td></tr></tbody></table>

{% hint style="success" %}
Most real-world applications extend `JpaRepository`.
{% endhint %}

```java
public interface EmployeeRepository extends JpaRepository<Employee, Long> { }
```

### 5. `QueryByExampleExecutor<T>`

* Allows building queries using **Example Matching** instead of manual query methods.

Example:

```java
Employee probe = new Employee();
probe.setDepartment("IT");
Example<Employee> example = Example.of(probe);

List<Employee> employees = employeeRepository.findAll(example);
```

No need to define explicit query methods.

## How Repository Abstractions Work Internally ?

* Spring Data JPA creates **dynamic proxies** for the repository interfaces.
* Proxies **interpret method names** to generate SQL/JPQL automatically.
* If we add `@Query`, it directly executes the provided query.
* The proxy uses injected **EntityManager** to perform all operations.

{% hint style="info" %}
No manual implementation needed. No manual query writing needed for simple cases.
{% endhint %}

## Customizing Repositories

If default behavior isn't enough:

* We can write **custom methods** manually (Custom Repository Implementation).
* Or **override** default methods.

```java
public interface CustomEmployeeRepository {
    List<Employee> findEmployeesWithHighSalary();
}

public class CustomEmployeeRepositoryImpl implements CustomEmployeeRepository {
    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public List<Employee> findEmployeesWithHighSalary() {
        // custom JPQL
        return entityManager.createQuery("SELECT e FROM Employee e WHERE e.salary > 100000", Employee.class)
                .getResultList();
    }
}
```

Then:

```java
public interface EmployeeRepository extends JpaRepository<Employee, Long>, CustomEmployeeRepository { }
```
