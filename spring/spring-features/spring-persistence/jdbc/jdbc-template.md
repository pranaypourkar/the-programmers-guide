# JDBC Template

## About

`JdbcTemplate` is a **core class provided by Spring Framework** to simplify interaction with relational databases using JDBC (Java Database Connectivity). It abstracts away much of the boilerplate code required when using standard JDBC, such as opening/closing connections, managing exceptions, and handling result sets.

It is part of the `org.springframework.jdbc.core` package and is considered one of the **oldest and most stable** features of the Spring ecosystem.

## Why Use JdbcTemplate?

Traditional JDBC code involves a lot of repetitive and error-prone tasks like:

* Managing database connections
* Creating and closing `PreparedStatement` and `ResultSet`
* Handling SQLExceptions explicitly
* Manually mapping result sets to Java objects

`JdbcTemplate` solves these problems by:

* Handling resource management automatically
* Providing utility methods for common SQL operations
* Supporting both positional and named parameters
* Reducing error-prone and verbose code

## Is it still relevant?

**JdbcTemplate** is still used in modern microservices, but its usage has become more niche compared to other technologies like **Spring Data JPA** or **Spring Data MongoDB**, especially in the context of **microservices architecture**. Let me explain in more detail:

### Use of JdbcTemplate in Modern Microservices

1. **When to Use JdbcTemplate**:
   * **Legacy Systems**: If we're working with an existing database that already uses raw SQL (especially in legacy systems), `JdbcTemplate` is still valuable. It allows you to directly interact with the database without the overhead of an ORM.
   * **Complex SQL Queries**: If our service requires complex, highly optimized SQL queries that don’t fit well with JPA/Hibernate's abstraction, `JdbcTemplate` is ideal. It lets you write custom SQL with full control over the query execution.
   * **Performance-sensitive Applications**: In some scenarios, particularly with high-performance or real-time systems, raw SQL queries executed via `JdbcTemplate` can be more efficient than ORM solutions, as they eliminate the overhead of JPA/Hibernate.
   * **Simple Data Models**: If our microservice has simple data models that do not require the complexity of an ORM like Hibernate, `JdbcTemplate` can be an efficient solution.
2. **Advantages**:
   * **Simplicity**: `JdbcTemplate` simplifies JDBC usage by abstracting away repetitive tasks such as connection management and exception handling.
   * **Control**: It gives us complete control over the SQL you write, which is crucial when you need to optimize for specific queries or performance.
   * **Lightweight**: `JdbcTemplate` is less "heavy" than full-fledged ORM solutions like Hibernate, making it a good choice for smaller or less complex microservices.

### Limitations in Microservices:

While `JdbcTemplate` can be useful, modern microservices often prefer **Spring Data JPA** or other higher-level abstractions due to the following reasons:

1. **ORM Advantages**:
   * **Entity Mapping**: With Spring Data JPA, you can map database tables to Java objects, reducing the amount of boilerplate code needed to fetch, insert, and update records.
   * **Query Methods**: Spring Data JPA provides repository methods like `findById()`, `save()`, `delete()`, and `findAll()` that automatically handle CRUD operations without writing SQL queries.
   * **Automatic Entity Management**: It provides automatic management of entities and relationships, such as one-to-many, many-to-many, and cascading operations, which is especially useful in complex models.
2. **Scalability**:
   * **Declarative Approach**: Spring Data JPA (and Spring Data in general) allows a more declarative approach to database access with fewer lines of code, which can help speed up development and maintenance.
   * **Repository Pattern**: Spring Data JPA uses repositories that promote cleaner and more modular code, which is especially important for microservices where decoupling and separation of concerns are key principles.
3. **Microservice Complexity**:
   * Modern microservices often use multiple databases (polyglot persistence), which may involve not just relational databases (where `JdbcTemplate` shines) but also NoSQL databases like **MongoDB**, **Cassandra**, or **Elasticsearch**. In such cases, Spring Data's abstraction layer helps manage interactions across various databases, reducing the need for direct JDBC usage.
4. **Transactional Management**:
   * Spring Data JPA provides declarative transaction management via the `@Transactional` annotation, which can be complex or cumbersome to implement manually when using `JdbcTemplate`.

## How JdbcTemplate Works ?

`JdbcTemplate` works by:

1. Accepting a `DataSource` object (typically configured by Spring Boot).
2. Providing methods like `query()`, `update()`, `batchUpdate()`, `queryForObject()`, and `execute()` for SQL operations.
3. Handling connection creation, statement preparation, execution, and resource cleanup automatically.
4. Allowing custom mapping of `ResultSet` to domain objects using `RowMapper`, `ResultSetExtractor`, or `BeanPropertyRowMapper`&#x20;

## Example

**Dependency (Spring Boot Starter JDBC)**

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-jdbc</artifactId>
</dependency>
```

**application.properties**

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/employeedb
spring.datasource.username=root
spring.datasource.password=yourpassword
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
```

**Java Configuration (if not using Spring Boot)**

```java
@Bean
public JdbcTemplate jdbcTemplate(DataSource dataSource) {
    return new JdbcTemplate(dataSource);
}
```

**Repository Example**

```java
@Repository
public class EmployeeJdbcRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<Employee> findAll() {
        String sql = "SELECT * FROM employee";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(Employee.class));
    }

    public int save(Employee employee) {
        String sql = "INSERT INTO employee (name, email, department_id) VALUES (?, ?, ?)";
        return jdbcTemplate.update(sql, employee.getName(), employee.getEmail(), employee.getDepartmentId());
    }
}
```

#### RowMapper Example

```java
public class EmployeeRowMapper implements RowMapper<Employee> {
    @Override
    public Employee mapRow(ResultSet rs, int rowNum) throws SQLException {
        return new Employee(
            rs.getLong("id"),
            rs.getString("name"),
            rs.getString("email"),
            rs.getLong("department_id")
        );
    }
}
```

#### Common JdbcTemplate Methods

<table data-full-width="true"><thead><tr><th width="415.28515625">Method</th><th>Description</th></tr></thead><tbody><tr><td><code>query(String sql, RowMapper&#x3C;T>)</code></td><td>Execute a select query and map each row to an object</td></tr><tr><td><code>queryForObject(String sql, Class&#x3C;T>)</code></td><td>Execute a query expected to return exactly one object</td></tr><tr><td><code>update(String sql, Object... args)</code></td><td>Execute insert/update/delete SQL</td></tr><tr><td><code>batchUpdate(String sql, List&#x3C;Object[]>)</code></td><td>Execute multiple insert/update/delete in batch</td></tr><tr><td><code>execute(String sql)</code></td><td>Execute any arbitrary SQL statement</td></tr></tbody></table>

## When to Use JdbcTemplate ?

Use JdbcTemplate when:

* We want full control over SQL queries.
* We want a lightweight alternative to JPA/Hibernate.
* We don’t need the overhead of an ORM.
* We are working with legacy databases or stored procedures.

## When Not to Use JdbcTemplate ?

Avoid JdbcTemplate when

* We require advanced ORM features like lazy loading, entity relationships, or entity lifecycle callbacks.
* We are already using Spring Data JPA and want to avoid mixing abstraction levels unnecessarily.
