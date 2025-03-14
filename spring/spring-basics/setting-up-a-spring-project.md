---
description: >-
  Setting up a Spring project correctly is essential to ensure smooth
  development and maintainability.
---

# Setting Up a Spring Project

## Prerequisites (JDK, IDE, Maven/Gradle)&#x20;

Before starting a Spring project, ensure we have the necessary tools installed on our system.

### **1.1 Java Development Kit (JDK)**

Spring applications require **JDK 8 or later** (JDK 17+ recommended for latest features).

**Check if Java is installed:**

```sh
java -version
```

**Download JDK:**

* **Official OpenJDK**: [https://openjdk.org](https://openjdk.org/)
* **Oracle JDK**: [https://www.oracle.com/java/technologies/javase-downloads.html](https://www.oracle.com/java/technologies/javase-downloads.html)

### **1.2 Integrated Development Environment (IDE)**

You need an IDE for writing and managing your Spring project. Some popular choices:

* **IntelliJ IDEA (Recommended)** – Excellent Spring Boot support
* **Eclipse IDE** – Widely used for Java development
* **VS Code** – Lightweight alternative with Java extensions
* **Spring Tool Suite (STS)** – Optimized for Spring projects

### **1.3 Build Tools: Maven or Gradle**

Spring projects typically use **Maven** or **Gradle** as the build system.

**Check Maven installation:**

```sh
mvn -version
```

**Check Gradle installation:**

```sh
gradle -version
```

**Install Maven/Gradle if not available:**

* **Maven**: [https://maven.apache.org/download.cgi](https://maven.apache.org/download.cgi)
* **Gradle**: https://gradle.org/install

## Creating a Spring Project (Spring Initializr)&#x20;

[Spring Initializr](https://start.spring.io/) is the easiest way to generate a Spring Boot project.

### **2.1 Using Spring Initializr (Recommended)**

1. **Go to** [Spring Initializr](https://start.spring.io/)
2. Select:

* **Project Type**: Maven / Gradle
* **Language**: Java
* **Spring Boot Version**: Latest stable version

3. Enter **Group ID** (e.g., `com.example`) and **Artifact ID** (e.g., `myapp`).
4. Add required dependencies (e.g., `Spring Web`, `Spring Boot Actuator`, `Spring Data JPA`).
5. Click **"Generate"** to download the project as a ZIP file.
6. Extract and open the project in your preferred IDE.

### **2.2 Creating a Project Manually**

If we prefer, we can create a project manually using **Maven** or **Gradle**.

**Maven Project Setup**

```sh
mvn archetype:generate -DgroupId=com.example -DartifactId=myapp -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
```

Add Spring Boot dependencies in `pom.xml`:

```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
</dependencies>
```

Run the project:

```sh
mvn spring-boot:run
```

**Gradle Project Setup**

Initialize a Gradle project and add dependencies to `build.gradle`:

```gradle
dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-web'
}
```

Run the project:

```sh
./gradlew bootRun
```

## Project Structure Overview

Once the Spring project is created, the default structure follows a **standardized convention**. Below is an overview of key directories and files:

```
myapp/
│── src/
│   ├── main/
│   │   ├── java/com/example/myapp/
│   │   │   ├── MyAppApplication.java   # Main entry point of the application
│   │   │   ├── controller/             # Controllers (handling HTTP requests)
│   │   │   ├── service/                # Business logic
│   │   │   ├── repository/             # Data access layer
│   │   │   ├── model/                   # Data models
│   │   ├── resources/
│   │   │   ├── application.properties  # Configuration file
│   │   │   ├── static/                 # Static files (HTML, CSS, JS)
│   │   │   ├── templates/              # Templates (Thymeleaf, Freemarker)
│   │   │   ├── schema.sql              # Database initialization scripts
│   ├── test/java/com/example/myapp/    # Unit and integration tests
│── pom.xml (for Maven projects)  
│── build.gradle (for Gradle projects)
│── mvnw, mvnw.cmd (Maven wrapper)
│── gradlew, gradlew.bat (Gradle wrapper)
│── .gitignore (Git ignore rules)
```

#### **Important Files and Folders**

<table data-full-width="true"><thead><tr><th width="357">Folder/File</th><th>Description</th></tr></thead><tbody><tr><td><strong><code>MyAppApplication.java</code></strong></td><td>Main class annotated with <code>@SpringBootApplication</code>. Starts the Spring application.</td></tr><tr><td><strong><code>controller/</code></strong></td><td>Contains REST controllers (<code>@RestController</code>) that handle HTTP requests.</td></tr><tr><td><strong><code>service/</code></strong></td><td>Business logic layer (<code>@Service</code>).</td></tr><tr><td><strong><code>repository/</code></strong></td><td>Data access layer (<code>@Repository</code>). Works with databases via Spring Data JPA.</td></tr><tr><td><strong><code>model/</code></strong></td><td>Contains entity classes (<code>@Entity</code>) for database interactions.</td></tr><tr><td><strong><code>resources/application.properties</code></strong></td><td>Configuration file for database connections, server settings, etc.</td></tr><tr><td><strong><code>resources/templates/</code></strong></td><td>Used for template engines like <strong>Thymeleaf</strong> or <strong>Freemarker</strong>.</td></tr><tr><td><strong><code>test/java/</code></strong></td><td>Contains JUnit test cases for unit and integration testing.</td></tr></tbody></table>

### **Running the Spring Boot Application**

Once the project is set up, run it using:

```sh
mvn spring-boot:run   # If using Maven
./gradlew bootRun      # If using Gradle
```

Or directly from the `main` method:

```java
@SpringBootApplication
public class MyAppApplication {
    public static void main(String[] args) {
        SpringApplication.run(MyAppApplication.class, args);
    }
}
```

The application will start at **`http://localhost:8080/`**.

