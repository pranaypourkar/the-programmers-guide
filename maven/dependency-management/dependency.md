# Dependency

## About

A **dependency** in a **Maven Spring Boot** project refers to an **external library** or module that our project requires to function properly. These dependencies are declared in the **`pom.xml`** (Project Object Model) file and are automatically downloaded and managed by Maven.

For example, if our Spring Boot application needs to interact with a **database**, we might include the **Spring Data JPA** dependency. Similarly, if we need to build a REST API, we would include the **Spring Web** dependency.

## Why Do We Need Dependencies in a Spring Boot Project?

Spring Boot applications rely on multiple third-party libraries and frameworks. Instead of manually downloading and managing these libraries, Maven allows us to -

* **Automatically Download Required Libraries** – No need to manually find and install JAR files.
* **Manage Versions** – Ensures that all libraries are compatible with each other.
* **Handle Transitive Dependencies** – Automatically resolves and includes libraries that your dependencies need.
* **Provide Easy Updates** – Easily update dependencies to newer versions for security and feature improvements.

## How Dependencies Work in a Maven Spring Boot Project?

### **Step 1: Declaring Dependencies in `pom.xml`**

All dependencies in a Spring Boot project are declared inside the `<dependencies>` section of the `pom.xml` file. Each dependency includes:

* **Group ID** – Identifies the project or organization that provides the dependency.
* **Artifact ID** – The specific name of the dependency (library/module).
* **Version** – The version of the dependency being used.

**Example: Adding the Spring Boot Starter Web Dependency**

```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
</dependencies>
```

* The **Spring Boot Starter Web** dependency includes everything needed to build a web application, including an embedded Tomcat server.
* No need to specify a **version**, because Spring Boot **automatically manages** versions using its **Spring Boot BOM (Bill of Materials).**

### **Step 2: Maven Downloads Dependencies Automatically**

Once the dependencies are declared in `pom.xml`, Maven will -

* Download the required JAR files from the **Maven Central Repository**.
* Store them in the **local repository** (`~/.m2/repository/`).
* Make them available to the project **at compile time and runtime**.

## Types of Dependencies in a Spring Boot Project

Spring Boot provides a wide range of dependencies categorized into different groups based on their usage:

### **A. Spring Boot Starters (Preconfigured Dependencies)**

Spring Boot provides **starter dependencies** that bundle together commonly used libraries, making it easier to include them in your project.

* **Spring Boot Starter Web** – For building REST APIs and web applications.
* **Spring Boot Starter Data JPA** – For database access using Hibernate and JPA.
* **Spring Boot Starter Security** – For adding authentication and authorization.
* **Spring Boot Starter Test** – For unit and integration testing.

**Example: Adding Spring Boot Starter Dependencies**

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>
```

* This will **automatically** include Hibernate and other required database libraries.

### **B. Third-Party Dependencies**

Apart from Spring Boot starters, our project might need additional third-party libraries such as:

* **Database Drivers** (e.g., MySQL, PostgreSQL)
* **JSON Processing** (e.g., Jackson, Gson)
* **Logging Frameworks** (e.g., Logback, Log4j2)

**Example: Adding a MySQL Database Driver**

```xml
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <scope>runtime</scope>
</dependency>
```

* This allows Spring Boot to connect to a **MySQL database**.

### **C. Test Dependencies**

Spring Boot provides specialized testing dependencies for writing unit tests and integration tests.

* **JUnit** – The default testing framework.
* **Mockito** – For mocking dependencies in unit tests.
* **Spring Boot Test** – Provides utilities for testing Spring Boot applications.

**Example: Adding Spring Boot Testing Dependencies**

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-test</artifactId>
    <scope>test</scope>
</dependency>
```

* This ensures that the testing libraries are available **only during the test phase**.

## How Maven Resolves Dependencies in a Spring Boot Project?

Maven follows a structured process to resolve dependencies:

1. **Checks Local Repository (`~/.m2/repository/`)**

If the required dependency is already downloaded, it will be used.

2. **Checks Remote Repositories (Maven Central, Custom Repositories)**

If the dependency is not found locally, Maven will download it from a remote repository.

3. **Resolves Transitive Dependencies**

If a dependency has its own dependencies, Maven will **automatically download** them.

#### **Example: Transitive Dependency Resolution**

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

This dependency includes:

* Spring MVC
* Embedded Tomcat
* Jackson JSON Processor
