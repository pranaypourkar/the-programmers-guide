# Dependency Management

## About

In a Maven project, **Dependency Management** refers to the process of **declaring, handling, and resolving** external libraries required for the application to function. Maven provides a structured way to **fetch, version, and control** dependencies automatically.

## Responsibilities of Dependency Management

* Automatically downloads required JARs from repositories.
* Ensures compatibility by managing dependency versions.
* Resolves transitive dependencies (dependencies of dependencies).
* Helps in **conflict resolution**, **scoping**, and **exclusions**.
* Allows centralizing dependency versions using **BOM (Bill of Materials)**.

## How Maven Handles Dependencies?

Maven dependencies are declared in the `pom.xml` file. Maven uses these declarations to:

1. **Download** the correct versions of required JARs.
2. **Check for transitive dependencies** (dependencies of the declared dependencies).
3. **Determine the scope** of dependencies (Compile, Runtime, Test, etc.).
4. **Handle conflicts** if different versions of the same dependency exist.

**Example of a Basic Dependency Declaration:**

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
    <version>3.0.0</version>
</dependency>
```

Maven will fetch **all required dependencies**, including transitive dependencies, for `spring-boot-starter-web`.

## Why is Dependency Management Important?

* **Ensures application stability** by avoiding conflicting versions.
* **Reduces manual effort** in downloading and managing JARs.
* **Keeps projects modular and maintainable**.
* **Improves performance and security** by enforcing tested versions.

