# Transitive Dependency

## About

A **transitive dependency** in Maven is a dependency that our project does not explicitly declare but is **included automatically** because another dependency requires it.

For example, if our project depends on **Spring Boot Starter Web**, it will automatically include **Spring MVC, Tomcat, and Jackson** without us having to specify them individually.

## Why Do We Need Transitive Dependencies?

Maven's transitive dependency mechanism helps in:

* **Reducing Manual Effort** – No need to specify every required library.
* **Avoiding Compatibility Issues** – Ensures all dependencies work together.
* **Maintaining a Clean `pom.xml`** – Only direct dependencies need to be declared.

## How Transitive Dependencies Work?

Maven resolves dependencies using a **dependency tree**, where

1. **Direct Dependencies** – Explicitly declared in your `pom.xml`.
2. **Transitive Dependencies** – Automatically included based on direct dependencies.

#### **Example: Understanding Transitive Dependencies**

Let's say we add **Spring Boot Starter Web** to our project:

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

This dependency internally requires:

* Spring MVC
* Jackson (for JSON processing)
* Tomcat (embedded web server)

We don’t need to specify these separately; Maven will fetch them automatically.

## How to View Transitive Dependencies?

Maven provides a command to analyze dependency trees:

```sh
mvn dependency:tree
```

**Example Output**

```
[INFO] org.springframework.boot:spring-boot-starter-web:jar:2.7.0
[INFO] ├─ org.springframework.boot:spring-boot-starter:jar:2.7.0
[INFO] │  ├─ org.springframework.boot:spring-boot:jar:2.7.0
[INFO] │  ├─ org.springframework.boot:spring-boot-autoconfigure:jar:2.7.0
[INFO] │  ├─ org.springframework:spring-core:jar:5.3.20
[INFO] ├─ org.springframework.boot:spring-boot-starter-json:jar:2.7.0
[INFO] │  ├─ com.fasterxml.jackson.core:jackson-databind:jar:2.13.2
[INFO] ├─ org.apache.tomcat.embed:tomcat-embed-core:jar:9.0.62
```

This means

* We included **spring-boot-starter-web**
* It pulled **Spring Boot Starter JSON**, **Jackson**, and **Tomcat Embed Core**

## How to Manage Transitive Dependencies?

### **A. Excluding Unwanted Transitive Dependencies**

Sometimes, a transitive dependency might cause conflicts or be unnecessary. We can **exclude** it using

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
```

This removes **Tomcat**, useful if we are using another web server like Jetty.

### **B. Forcing a Specific Version of a Transitive Dependency**

If a transitive dependency has **an older version**, we can override it in `dependencyManagement`:

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

This ensures **Jackson** uses version **2.14.0**, even if a lower version is pulled.
