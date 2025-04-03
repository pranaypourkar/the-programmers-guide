# Bill of Materials (BOM)

## About

A **Bill of Materials (BOM)** is a special type of **Maven POM (Project Object Model) file** that manages dependency versions centrally. Instead of specifying versions for each dependency separately, a BOM allows defining them once in a **single place**, ensuring consistency across multiple modules or projects.

BOM helps prevent **version mismatches**, reduces dependency conflicts, and simplifies project maintenance.

## Why Use a BOM?

### Problem Without BOM (Version Inconsistency & Repetition)

Without a BOM, we must **explicitly declare versions** for each dependency:

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
    <version>3.1.0</version>
</dependency>

<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
    <version>3.1.0</version>
</dependency>
```

This **duplicates version numbers** across dependencies, making version upgrades **error-prone**.

### Solution With BOM (Centralized Versioning)

With a BOM, versions are managed **once** at a central location:

```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-dependencies</artifactId>
            <version>3.1.0</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```

Now, we can add dependencies **without specifying versions**:

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>

<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>
```

Maven **automatically picks up versions** from the BOM.

## **How to Create a BOM ?**

A BOM is just a **POM file** with -

* Packaging type set to **pom**
* Dependencies listed **without scope**
* Version numbers specified **centrally**

#### **Example BOM POM (`my-bom/pom.xml`)**

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>my-bom</artifactId>
    <version>1.0.0</version>
    <packaging>pom</packaging>

    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-web</artifactId>
                <version>3.1.0</version>
            </dependency>
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-data-jpa</artifactId>
                <version>3.1.0</version>
            </dependency>
        </dependencies>
    </dependencyManagement>
</project>
```

Any project that imports this BOM **inherits the defined versions** without needing to specify them.

## Using a Custom BOM in a Project

Once a BOM is created, **import it** in a project’s `pom.xml`:

```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>com.example</groupId>
            <artifactId>my-bom</artifactId>
            <version>1.0.0</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```

Now, dependencies can be added **without version numbers**:

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

Maven will use the versions **from the imported BOM**.

## Maven's Built-in BOMs

Maven provides several **official BOMs** that help with version consistency:

### Spring Boot BOM (Recommended for Spring Projects)

```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-dependencies</artifactId>
            <version>3.1.0</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```

This ensures **all Spring Boot starters use compatible versions**.

### Jakarta EE BOM (For Enterprise Java Applications)

```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>jakarta.platform</groupId>
            <artifactId>jakarta.jakartaee-api</artifactId>
            <version>9.1.0</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```

Ensures **all Jakarta EE dependencies are consistent**.

## Benefits of Using BOM

<table><thead><tr><th width="190.3125">Feature</th><th width="226.6171875">Without BOM </th><th>With BOM </th></tr></thead><tbody><tr><td><strong>Version Consistency</strong></td><td>Hard to maintain</td><td>Ensured centrally</td></tr><tr><td><strong>Conflict Prevention</strong></td><td>Manual resolution</td><td>Automatic handling</td></tr><tr><td><strong>Code Maintenance</strong></td><td>Redundant versioning</td><td>Cleaner <code>pom.xml</code></td></tr><tr><td><strong>Scalability</strong></td><td>Difficult for large projects</td><td>Best suited for enterprise applications</td></tr></tbody></table>

