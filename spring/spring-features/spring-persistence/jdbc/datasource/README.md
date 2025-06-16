# Datasource

## About

A **Datasource** is a fundamental concept in Java Database Connectivity (JDBC) and is the primary means for an application to obtain a connection to a relational database. It abstracts the details of the database connection and provides an interface to manage connections efficiently. Spring uses the **DataSource** abstraction for interacting with databases through JDBC and is a core part of the JDBC module.

## What is a Datasource?

A **Datasource** represents a source of database connections in a Java application. Unlike **DriverManager**, which directly handles database connections, a **DataSource** is preferred because it provides better management capabilities, such as connection pooling, which improves performance by reusing database connections instead of creating new ones every time a connection is requested.

A **DataSource** object can be configured to provide connections to a specific database, manage connection pooling, and handle transaction management.

## Types of Datasource Implementations

In the context of Spring JDBC, there are several **DataSource** implementations available:

1. **BasicDataSource (Apache Commons DBCP)**: A simple DataSource that supports basic connection pooling.
2. **HikariCP**: A high-performance JDBC connection pool, which is the default in Spring Boot.
3. **C3P0**: Another connection pool provider, though it is less commonly used now compared to HikariCP.
4. **Proxool**: An alternative to the above for connection pooling.

## Setting Up DataSource in Spring

Spring provides various ways to configure a **DataSource** in our application, including both **XML-based** configuration and **Java-based** configuration.

### **1. Java Configuration (Spring Boot / Spring Java Config)**

Spring Boot automatically configures a **DataSource** if you provide the necessary properties in the `application.properties` or `application.yml` file.

```properties
# application.properties (Spring Boot)
spring.datasource.url=jdbc:mysql://localhost:3306/your_database
spring.datasource.username=root
spring.datasource.password=root_password
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.datasource.hikari.maximum-pool-size=10
```

In a Spring application that is not using Spring Boot, we can configure a **DataSource** using Java-based configuration like so:

```java
@Configuration
@EnableTransactionManagement
public class DataSourceConfig {

    @Bean
    public DataSource dataSource() {
        DriverManagerDataSource dataSource = new DriverManagerDataSource();
        dataSource.setDriverClassName("com.mysql.cj.jdbc.Driver");
        dataSource.setUrl("jdbc:mysql://localhost:3306/your_database");
        dataSource.setUsername("root");
        dataSource.setPassword("root_password");
        return dataSource;
    }
}
```

### **2. XML Configuration (Traditional Spring XML Config)**

In Spring, we can also configure a **DataSource** using XML. This was more common in earlier versions of Spring but is still useful in legacy applications.

```xml
<bean id="dataSource" class="org.apache.commons.dbcp2.BasicDataSource">
    <property name="driverClassName" value="com.mysql.cj.jdbc.Driver"/>
    <property name="url" value="jdbc:mysql://localhost:3306/your_database"/>
    <property name="username" value="root"/>
    <property name="password" value="root_password"/>
</bean>
```

## DataSource and Connection Pooling

One of the primary features of a **DataSource** is that it can manage a **connection pool**. **Connection pooling** involves maintaining a pool of database connections that can be reused by multiple clients or threads, rather than opening a new connection for every operation. This results in significant performance improvements, especially in high-traffic applications.

* **HikariCP**, the default connection pool in Spring Boot, is known for being **lightweight** and **fast**.
* We can configure the size of the connection pool to suit the needs of your application (e.g., setting a maximum number of connections).

**Example with HikariCP in Spring Boot:**

```properties
spring.datasource.hikari.maximum-pool-size=10
spring.datasource.hikari.minimum-idle=5
spring.datasource.hikari.idle-timeout=30000
spring.datasource.hikari.connection-timeout=30000
```

## JDBC Template with DataSource

The **JdbcTemplate** is Spring's high-level abstraction for interacting with a database. The **JdbcTemplate** internally uses a **DataSource** to manage connections, making database operations easier and more efficient.

**Example:**

```java
@Service
public class UserService {

    private final JdbcTemplate jdbcTemplate;

    @Autowired
    public UserService(DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }

    public List<User> getAllUsers() {
        String sql = "SELECT * FROM users";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(User.class));
    }
}
```

In the example above, the `JdbcTemplate` uses the provided **DataSource** to get database connections, execute the SQL query, and map the results to a list of `User` objects.
