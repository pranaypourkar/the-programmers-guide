---
description: >-
  An overview of various dependencies used commonly across various  projects in
  the form of categories.
hidden: true
---

# Dependencies

### Server

### Database

#### H2

* H2 Database offers both in-memory and file-based database options. Integrating H2 database into Maven project involves two main scenarios i.e. using it for persistence in application or for integration testing\*\*.\*\* Dependency scope as test ensures the dependency is only available during tests and not included in the final packaged application.

<details>

<summary>H2 Database Dependency</summary>

```
<dependency>
    <groupId>com.h2database</groupId>
    <artifactId>h2</artifactId>
    <version>1.4.199</version>
    <scope>test</scope>
</dependency>
```

</details>

H2 database specific properties can be defined in application.yaml file like below.

```
spring:
  datasource:
    url: jdbc:h2:mem:testdb
    username: sa
    password:
    driver-class-name: org.h2.Driver
```

{% hint style="info" %}
* **In-memory:** Use `jdbc:h2:mem:your_database_name` for a private in-memory database
* **File-based:** Use `jdbc:h2:~/your_database_name` or `jdbc:h2:file:your_database_name` to store data in a file on your local system.
{% endhint %}

#### Oracle

* Oracle Driver

Oracle JDBC driver for Java allows Java applications to connect to Oracle database. It's commonly used when developing Java applications that need to interact with Oracle database.

<details>

<summary>Oracle Database Driver Dependency</summary>

```
<dependency>
    <groupId>com.oracle.database.jdbc</groupId>
    <artifactId>ojdbc8</artifactId>
    <version>23.3.0.23.09</version>
</dependency>
```

</details>

Oracle database specific properties can be defined in application.yaml file like below.

> ```
> spring:
>   datasource:
>     url: jdbc:oracle:thin:@//hostname:port/service_name
>     username: your_username
>     password: your_password
>     driver-class-name: oracle.jdbc.driver.OracleDriver
> ```

#### Mysql

* Mysql Driver

Mysql JDBC driver for Java allows Java applications to connect to Mysql database. It's commonly used when developing Java applications that need to interact with Mysql database.

<details>

<summary>Mysql Database Driver Dependency</summary>

```
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.31</version>
</dependency>
```

</details>

Mysql database specific properties can be defined in application.yaml file like below.

```
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/your_database_name
    username: your_username
    password: your_password
    driver-class-name: com.mysql.cj.jdbc.Driver
```

### Open API Specification

### Tests

### Utility

* **Lombok**

Lombok is a Java library that helps reduce boilerplate code by providing annotations to generate getter, setter, constructor, and other utility methods during compilation. This can lead to cleaner and more concise code.

> It provides annotations which help reduce boilerplate code for getters, setters, equals, hashCode, , toString, constructors, builders, loggers, checked exceptions handling with @SneakyThrows, data validation with @NonNull to enforce non-null fields etc.

<details>

<summary>Lombok Dependency</summary>

```markup
<dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
    <version>1.18.28</version>
    <scope>provided</scope>
</dependency>
```

</details>
