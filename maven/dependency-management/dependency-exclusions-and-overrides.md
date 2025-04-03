# Dependency Exclusions & Overrides

## Dependency Exclusion

### About

When we include a dependency in our project, Maven **automatically pulls its transitive dependencies**. However, some transitive dependencies may be **unnecessary**, **cause conflicts**, or **bloat the final JAR size**.

**Dependency Exclusion** allows us to **prevent Maven from downloading a specific transitive dependency**.

### Example Scenario – Why Use Exclusion?

Let's say we include **Spring Boot Starter Web**:

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

This automatically includes **Tomcat**. If we want to use **Jetty** instead, we must **exclude Tomcat**.

### How to Exclude a Transitive Dependency?

#### **Basic Example – Excluding Tomcat**

Tomcat is removed, and Jetty is added as the new web server.

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
    <exclusions>
        <exclusion>
            <groupId>org.apache.tomcat.embed</groupId>
            <artifactId>tomcat-embed-core</artifactId>
        </exclusion>
    </exclusions>
</dependency>

<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-jetty</artifactId>
</dependency>
```

#### **Excluding Multiple Dependencies**

We can exclude **multiple transitive dependencies** within the same declaration.

This removes both Tomcat and JSON processing dependencies.

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
    <exclusions>
        <exclusion>
            <groupId>org.apache.tomcat.embed</groupId>
            <artifactId>tomcat-embed-core</artifactId>
        </exclusion>
        <exclusion>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-json</artifactId>
        </exclusion>
    </exclusions>
</dependency>
```

### How to Find Unwanted Transitive Dependencies?

Run:

```sh
mvn dependency:tree
```

Example Output:

```
[INFO] ├─ org.springframework.boot:spring-boot-starter-web:jar:2.7.0
[INFO] │  ├─ org.apache.tomcat.embed:tomcat-embed-core:jar:9.0.62
[INFO] │  ├─ com.fasterxml.jackson.core:jackson-databind:jar:2.13.2
```

We can use this list to decide which dependencies to exclude.



## Dependency Override

### About

Sometimes, two different dependencies require **conflicting versions of the same library**. In such cases, Maven may pick a version automatically, which might **cause runtime errors**.

Dependency Override (Forcing a Specific Version) allows us to manually specify the version of a dependency to avoid conflicts.

### Example Scenario – Why Use Override?

Let's say:

* **Library A** depends on `jackson-databind:2.10.0`
* **Library B** depends on `jackson-databind:2.14.0`
* Maven **automatically picks one** (which might break compatibility).

To **force a specific version**, we need to use **dependencyManagement**.

### How to Override a Dependency Version?

The best way to override a dependency version is **via `dependencyManagement`**.

```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>com.fasterxml.jackson.core</groupId>
            <artifactId>jackson-databind</artifactId>
            <version>2.14.0</version>
        </dependency>
    </dependencies>
</dependencyManagement>
```

This ensures **Jackson always uses version 2.14.0**, preventing Maven from using older versions from transitive dependencies.

#### **Overriding Versions in `dependencies` Section**

Another approach (not recommended) is manually specifying the dependency **before any other dependency that includes it transitively**:

```xml
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
    <version>2.14.0</version>
</dependency>
```

However, this **does not work reliably** because **other dependencies might still use an older version**. Always prefer **dependencyManagement**.
