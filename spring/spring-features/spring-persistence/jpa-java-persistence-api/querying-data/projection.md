# Projection

## About

**Projection** in JPA allows us to retrieve **partial data** from a table/entity rather than fetching the entire entity object. This is especially useful when:

* We don't need all fields (reduces memory/IO).
* We want to optimize performance.
* We want to shape our response objects differently than the entity structure.

Instead of returning full entities like `Employee`, we can return just names, or a combination of selected fields.

## Why Use Projection?

* **Performance**: Avoids unnecessary fetching of unused fields (especially large blobs, associations).
* **Encapsulation**: Returns only relevant data to API clients.
* **Shaping Results**: Can transform or aggregate data in custom structures.
* **Avoid Lazy Loading Issues**: Does not rely on full entity graphs.

## Types of Projections in Spring Data JPA

Spring Data JPA supports multiple ways to extract partial data from entities using projections. This is helpful when:

* We want to **optimize query performance**.
* We only need a **subset of fields** from a table.
* We need to **return data in a custom structure** for API responses or UI consumption.

### 1. **Interface-based Projections**

Interface-based projections use Java interfaces to retrieve specific fields from entities. Spring Data JPA will **dynamically generate proxy implementations** for the interface and only fetch the selected properties from the database.

#### How it works

We define a Java interface with getter methods that match the entity's field names. When we call the repository method, Spring returns proxies that only populate the specified fields.

#### Example

```java
public interface EmployeeNameView {
    String getName();
}
```

```java
List<EmployeeNameView> findByDepartment(String department);
```

#### Characteristics

* Must match field names from the entity.
* No need to write any query if method names follow Spring Data conventions.
* Proxy instances returned, not full entities.

#### Advantages

* Lightweight and easy to write.
* Automatically handled by Spring Data.
* Efficient: only required columns are selected.

#### Limitations

* Cannot define business logic.
* Cannot be used when transformations or computations are needed.
* Difficult to use for nested or derived fields (requires closed projection syntax).

### 2. **Class-based Projections (DTOs)**

Class-based projections use **custom DTO (Data Transfer Object) classes** with constructors that accept selected fields. You manually define what you want to retrieve using JPQL or native SQL queries.

#### How it works

Spring maps results into DTOs using constructor expressions in JPQL. The constructor in the DTO must exactly match the select fields.

#### Example

```java
public class EmployeeDTO {
    private final String name;
    private final String department;

    public EmployeeDTO(String name, String department) {
        this.name = name;
        this.department = department;
    }

    // getters
}
```

```java
@Query("SELECT new com.example.EmployeeDTO(e.name, e.department.name) FROM Employee e")
List<EmployeeDTO> getEmployeeDetails();
```

#### Characteristics

* Requires constructor with selected fields.
* Supports complex logic (can include calculations or nested fields).
* Select clause must match constructor exactly.

#### Advantages

* Full control over shape of response.
* Works well for complex responses, aggregations, joins.
* Supports nested mappings, custom logic in constructor.

#### Limitations

* Requires more code (manual DTO creation).
* Must write `new` keyword in JPQL or native queries.
* Refactoring DTO fields requires updating query as well.

### 3. **Dynamic Projections**

Dynamic projections allow us to use a single repository method and dynamically pass the projection type (interface or DTO) at runtime.

#### How it works

The repository method accepts a `Class<T>` parameter, and Spring determines the result type dynamically. It still uses interface- or class-based projection logic under the hood.

#### Example

```java
<T> List<T> findByDepartment(String department, Class<T> type);
```

```java
List<EmployeeNameView> view = repo.findByDepartment("HR", EmployeeNameView.class);
List<EmployeeDTO> dto = repo.findByDepartment("HR", EmployeeDTO.class);
```

#### Characteristics

* Generic method supporting multiple return types.
* Useful in APIs where clients choose which view they want.
* Can be used with both interfaces and DTOs.

#### Advantages

* Single repository method to support multiple projections.
* Reduces duplication of repository methods.
* Makes API flexible (e.g., mobile and web clients can request different views).

#### Limitations

* Does not work well with custom JPQL queries (unless separate queries are defined).
* You must manage query compatibility manually.
* Not suitable when result sets vary too much between projections.

### 4. **Nested/Closed Projections**

Nested (also known as **closed projections**) are projections that access properties of associated (nested) entities using **nested interfaces**.

#### How it works

Spring will join the necessary tables and populate the nested fields if you define sub-projection interfaces for related entities. This only works with interface-based projections.

#### Example

```java
public interface EmployeeProjection {
    String getName();
    DepartmentInfo getDepartment();

    interface DepartmentInfo {
        String getName();
    }
}
```

#### Characteristics

* Only works with interface-based projections.
* Uses **getter-based navigation** to access nested fields.
* Requires associations to be navigable in JPA (e.g., `@ManyToOne`, `@OneToOne`).

#### Advantages

* Allows you to drill into nested objects cleanly.
* Efficient: generates optimized SQL with joins.
* No need for custom queries.

#### Limitations

* No support for nested DTOs.
* Cannot apply transformations or logic.
* Only works when property names match exactly.

### 5. **Open Projections (SpEL)**

Open projections use **SpEL (Spring Expression Language)** inside interface getters to compute values dynamically at runtime from the entity fields.

#### How it works

Spring will evaluate the `@Value` expression at runtime and inject the result. This allows simple data transformation logic in the projection layer.

#### Example

```java
public interface EmployeeOpenProjection {
    @Value("#{target.name + ' - ' + target.department.name}")
    String getSummary();
}
```

#### Characteristics

* Based on Spring Expression Language.
* Only works with interface-based projections.
* Computation happens in memory after query result.

#### Advantages

* Supports simple dynamic transformations.
* Easy for quick custom display logic.

#### Limitations

* SpEL expressions evaluated in memory (not in DB).
* Less efficient than DTO-based projections.
* Cannot be used in large or performance-critical operations.
* Difficult to debug and error-prone.

## How Projection Works Internally ?

Spring Data inspects the return type of your repository method. Based on the type:

* For **interface-based**, it uses JDK proxies to create dynamic implementations.
* For **DTOs**, it rewrites the JPQL to use `new` constructor syntax.
* For **dynamic projections**, it uses runtime type dispatching.

It **does not** load the entire entity and filter afterward—it changes the SQL/JPQL **select clause** to only fetch requested columns.

## Caveats and Limitations

<table data-full-width="true"><thead><tr><th width="210.65234375">Type</th><th width="162.8046875">Supports Nested?</th><th width="161.78515625">Supports Custom Logic?</th><th width="179.97265625">Performance Efficient?</th><th>Notes</th></tr></thead><tbody><tr><td>Interface-based</td><td>Yes (closed only)</td><td>No</td><td>Yes</td><td>Lightweight and good for flat data</td></tr><tr><td>Class-based (DTO)</td><td>Yes</td><td>Yes</td><td>Yes</td><td>Most flexible and maintainable</td></tr><tr><td>Open Projections (SpEL)</td><td>No</td><td>Yes (via SpEL)</td><td>No</td><td>Not recommended</td></tr><tr><td>Dynamic Projections</td><td>Depends on usage</td><td>Depends</td><td>Yes</td><td>Great for API flexibility</td></tr></tbody></table>

## Best Practices

* Use **interface-based projections** for simple read-only use cases with flat or slightly nested data.
* Use **DTO projections** for complex transformations, joins, or computations.
* Use **dynamic projections** in APIs where clients can choose what to fetch.
* Avoid **open projections** in large-scale or critical systems.
* Use **closed projections** when we need to traverse related entities in a clean, typed way.
