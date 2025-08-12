# Oracle XE

## About

The `oracle-xe` module from Testcontainers allows us to run **Oracle Express Edition (Oracle XE)** inside a Docker container during our integration tests. This is especially useful for enterprise applications that use Oracle databases in production and need realistic, production-like database behavior during testing.

## Purpose

Many Spring Boot applications use Oracle as their primary database. Testing such applications against a real Oracle instance is important to catch:

* Oracle-specific SQL differences
* Constraints and sequence behavior
* Real JDBC and connection handling
* Flyway or Liquibase migrations against Oracle

Testcontainers allows us to run Oracle XE dynamically during your tests, without needing a manually configured local or remote Oracle server.

## **Maven Dependency**

To use the Oracle XE container, add the following to our `pom.xml`:

```xml
<dependency>
    <groupId>org.testcontainers</groupId>
    <artifactId>oracle-xe</artifactId>
    <scope>test</scope>
</dependency>
```

This uses a prebuilt Docker image like `gvenzl/oracle-xe` under the hood.

## Using Oracle XE with Spring Boot and JUnit 5

Integrating **Oracle XE with Spring Boot** allows us to run true **integration tests** against a real Oracle database without setting up external infrastructure. This is ideal for testing repository layers, validating SQL queries, or running migrations in a fully controlled environment.

Testcontainers provides a seamless way to inject the runtime properties (such as JDBC URL, username, and password) into Spring’s application context using `@DynamicPropertySource`.

This ensures:

* The Oracle container starts before Spring Boot's context initializes.
* Spring picks up the dynamically generated connection details automatically.
* No need to hardcode configuration values in `application.properties`.

{% hint style="success" %}
- `@Testcontainers`: Tells JUnit 5 to manage lifecycle of containers in the test class.
- `@Container`: Marks the OracleContainer instance so Testcontainers will start and stop it automatically.
- `@SpringBootTest`: Loads Spring’s application context for integration testing.
- `@DynamicPropertySource`: Dynamically overrides Spring Boot properties at runtime before the context is initialized.
{% endhint %}

#### Example: Integration Test with Spring Boot and JUnit 5

```java
@SpringBootTest
@Testcontainers
public class OracleIntegrationTest {

    @Container
    static OracleContainer oracle = new OracleContainer("gvenzl/oracle-xe:21-slim")
        .withDatabaseName("testdb")
        .withUsername("demo_user")
        .withPassword("demo_pass");

    @DynamicPropertySource
    static void configure(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", oracle::getJdbcUrl);
        registry.add("spring.datasource.username", oracle::getUsername);
        registry.add("spring.datasource.password", oracle::getPassword);
        registry.add("spring.datasource.driver-class-name", oracle::getDriverClassName);
    }

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Test
    void shouldQueryDualTable() {
        Integer result = jdbcTemplate.queryForObject("SELECT 1 FROM dual", Integer.class);
        assertEquals(1, result);
    }
}
```

#### How It Works

1. **Container Setup**\
   The Oracle XE container is defined using `@Container`. When the test starts, Testcontainers automatically pulls the Docker image (if not already available), starts the container, and waits for it to be ready.
2. **Property Injection**\
   Before Spring Boot initializes the application context, the `@DynamicPropertySource` method is executed. It injects the container’s JDBC URL, username, password, and driver class name into Spring’s environment.
3. **Spring Boot Initialization**\
   Spring Boot configures the datasource using the values from the container, just like it would if you were reading them from `application.properties`.
4. **Autowiring Components**\
   Spring Boot wires up beans like `JdbcTemplate`, `EntityManager`, and any repositories you’ve defined.
5. **Test Execution**\
   The test runs and performs real database operations against Oracle XE running inside the container.

## Initialization Scripts

In many integration test scenarios, we may need our database to have predefined schema, tables, indexes, sequences, or test data before tests run. Testcontainers supports this through **initialization scripts**, which are plain SQL files executed automatically when the container starts.

This allows us to:

* Create required database structures
* Preload static reference data
* Simulate real-world data conditions
* Avoid repetitive setup in each test case

#### How Initialization Works

When we supply an SQL file using `.withInitScript("init.sql")`, Testcontainers mounts the file inside the container and tells Oracle XE to execute it after startup.

The script:

* Runs **once** when the container starts
* Executes using the default database user
* Should be **idempotent** if reused across test runs

#### Setting It Up

**1. Create the SQL Script**

Create a file named `init.sql` in the `src/test/resources` directory. For example:

```sql
CREATE TABLE employees (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    department VARCHAR2(50)
);

INSERT INTO employees (id, name, department) VALUES (1, 'Alice', 'Engineering');
INSERT INTO employees (id, name, department) VALUES (2, 'Bob', 'HR');
```

The file must be valid Oracle SQL. All statements should end with a semicolon.

**2. Reference the Script in the Container**

In our test class, configure the container to load the script:

```java
@Container
static OracleContainer oracle = new OracleContainer("gvenzl/oracle-xe:21-slim")
    .withDatabaseName("testdb")
    .withUsername("demo_user")
    .withPassword("demo_pass")
    .withInitScript("init.sql");
```

This will ensure the script runs **before** Spring Boot starts and before our test methods execute.





