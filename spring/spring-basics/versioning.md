# Versioning

## **Spring Framework Versioning**

The **Spring Framework** is the core framework for dependency injection, transaction management, and general application development.

* **Versioning Pattern:** `Major.Minor.Patch` (e.g., **5.3.30**)
* **Releases:**
  * **Major:** Introduces breaking changes (e.g., **Spring 5 → Spring 6**)
  * **Minor:** New features and improvements (e.g., **Spring 5.2 → Spring 5.3**)
  * **Patch:** Bug fixes and security updates (e.g., **Spring 5.3.30**)

**Spring Framework Latest Versions**

<table data-full-width="true"><thead><tr><th width="209">Spring Version</th><th width="184">Release Date</th><th width="186">JDK Requirement</th><th>Key Changes</th></tr></thead><tbody><tr><td><strong>Spring 6.x</strong> (Latest)</td><td>Nov 2022</td><td>Java 17+</td><td>Jakarta EE 9+, AOT support</td></tr><tr><td><strong>Spring 5.x</strong></td><td>2017 - 2023</td><td>Java 8+</td><td>Functional programming support</td></tr></tbody></table>

{% hint style="danger" %}
**Important:** Spring **6.x+ requires Java 17** and Jakarta EE (not Java EE).
{% endhint %}

## **Spring Boot Versioning**

Spring Boot is built on top of Spring Framework and simplifies configuration.

* Versioning Pattern: Uses Major.Minor.Patch (e.g., 3.1.2)
* Spring Boot always aligns with a specific Spring Framework version.
* Each Spring Boot version depends on a specific Spring Framework version.

**Spring Boot and Spring Framework Compatibility**

| **Spring Boot Version** | **Spring Framework Version** | **JDK Requirement** |
| ----------------------- | ---------------------------- | ------------------- |
| Spring Boot 3.x         | Spring 6.x                   | Java 17+            |
| Spring Boot 2.7.x       | Spring 5.3.x                 | Java 8+             |
| Spring Boot 2.6.x       | Spring 5.3.x                 | Java 8+             |

{% hint style="danger" %}
**Example:** If using **Spring Boot 3.x**, we **must** use Spring **6.x**.
{% endhint %}

## **How to Check the Spring & Spring Boot Versions?**

### **1. Checking Spring Boot Version in `pom.xml` (Maven)**

The Spring Boot version is specified in the `parent` section:

```xml
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>3.1.2</version>  <!-- Spring Boot Version -->
</parent>
```

Since Spring Boot manages Spring Framework dependencies, this version determines which Spring Framework version is used.

### **2. Checking the Spring Framework Version**

#### **Method 1: Use `mvn dependency:tree` (Maven)**

Run the following command in your project directory:

```sh
mvn dependency:tree | grep spring-core
```

This will output something like:

```
[INFO] org.springframework:spring-core:jar:6.0.11:compile
```

Here, **Spring Framework version is `6.0.11`**.

#### **Method 2: Check in `dependencyManagement`**

If we're **not using** `spring-boot-starter-parent`, Spring Framework version may be declared manually:

```xml
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-core</artifactId>
    <version>5.3.30</version>  <!-- Spring Framework Version -->
</dependency>
```

#### **Method 3: Check at Runtime via Spring Boot Actuator**

If we have Spring Boot Actuator enabled:

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

Then visit below url.

```
http://localhost:8080/actuator/info
```

This will display Spring Boot and Spring Framework versions.

### **3. Checking in `META-INF/MANIFEST.MF`**

If running a **Spring Boot JAR**, check:

```sh
unzip -p myapp.jar META-INF/MANIFEST.MF | grep Spring
```

or inside the JAR under:

```
BOOT-INF/lib/spring-core-*.jar
```

This file name contains the **Spring Framework version**.
