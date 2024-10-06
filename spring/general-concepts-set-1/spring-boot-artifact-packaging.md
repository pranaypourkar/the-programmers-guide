# Spring Boot Artifact Packaging

## About

Spring Boot artifact packaging refers to the process of bundling our Spring Boot application into a deployable format. This packaging ensures that our application can be easily deployed and run on various environments without requiring additional setup or configuration. Spring Boot provides multiple options for packaging artifacts (such as JARs and WARs) to simplify deployment. The packaging mode chosen depends on the type of application (standalone or traditional web app) and the intended deployment environment.

## Most common types of Packaging Options

* **JAR (Java Application Archive)**: By default, Spring Boot packages applications as executable JARs. An executable JAR includes the application's code, dependencies, and an embedded servlet container (such as Tomcat or Jetty), enabling us to run the application with a simple `java -jar` command.
* **WAR (Web Application  Archive)**: Spring Boot can also package applications as traditional WAR files. These WAR files are deployable to external servlet containers (such as Tomcat, Jetty, or WildFly). WAR packaging is useful when deploying Spring Boot applications in environments where a servlet container is already provided by the infrastructure
* **EAR (Enterprise Application Archive):** This packaging format is used for deploying large-scale enterprise applications that consist of multiple modules, such as EJBs, web applications, and connectors. EAR files include multiple modules, each packaged as a JAR or WAR file. They are suitable for complex applications with multiple components that need to be deployed together.
* **Executable JAR:** This is a special type of JAR file that can be executed directly from the command line without requiring the `java -jar` command. It includes a native launcher that allows the application to be run on different operating systems without requiring a Java installation. Executable JAR files are convenient for distributing our application to users who may not have Java installed.

## JAR Packaging

### 1. What is a JAR File?

* A **JAR** is a compressed archive that can contain Java classes, libraries, images, and resources necessary for a Java application to run.
* It uses the same format as a **ZIP** file but has additional metadata for Java applications.
* JAR files are platform-independent and allow Java applications to be distributed and deployed easily.

{% hint style="info" %}
#### **Compression in JAR Files**

* JAR files use ZIP compression to reduce the size of the archive. This compression helps in faster transmission and better storage utilization.
* The compression is automatically handled when we create a JAR using tools like `jar` or build systems like Maven or Gradle.
{% endhint %}

### **2.** Types of JAR Files

* **Library JAR**: A non-executable JAR that contains code (typically reusable libraries) without a `Main-Class` entry.
* **Executable JAR**: Contains a `Main-Class` entry in its `MANIFEST.MF` file, which allows the JAR to be executed with `java -jar`.
* **Runnable JAR**: A type of executable JAR but with dependencies packed inside (a "fat JAR").

<table data-header-hidden data-full-width="true"><thead><tr><th width="162"></th><th></th><th></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Aspect</strong></td><td><strong>Fat JAR (Uber JAR)</strong></td><td><strong>Thin JAR</strong></td><td><strong>Modular JAR (Jigsaw)</strong></td><td><strong>Executable JAR</strong></td></tr><tr><td><strong>Description</strong></td><td>Bundles the application code and all its dependencies into a single JAR.</td><td>Contains only the application code and minimal metadata. Dependencies must be provided externally.</td><td>Designed for use with Java modules introduced in Java 9. Contains module metadata (module-info.class).</td><td>Contains the main class and can be run directly with <code>java -jar</code>, but may not include dependencies.</td></tr><tr><td><strong>Purpose</strong></td><td>Simplifies deployment by packaging everything together.</td><td>Reduces size by excluding dependencies.</td><td>Enables modularity in Java applications and better dependency management.</td><td>Provides a runnable JAR for Java apps but dependencies are handled externally.</td></tr><tr><td><strong>Dependencies</strong></td><td>Embedded within the JAR (e.g., in <code>BOOT-INF/lib/</code>).</td><td>Not included in the JAR; they must be managed externally (e.g., in <code>lib/</code> folder or via classpath).</td><td>Dependencies can be external or modular, managed via modules.</td><td>Dependencies are not included and must be managed via classpath.</td></tr><tr><td><strong>Class Loading</strong></td><td>Uses a custom class loader (e.g., Spring Boot Loader) to load dependencies.</td><td>Relies on the external classpath for dependencies.</td><td>Java's module system handles class loading and visibility.</td><td>Standard Java class loader, dependencies managed via classpath.</td></tr><tr><td><strong>Size</strong></td><td>Larger, since it includes the application and all dependencies.</td><td>Smaller, as it only contains the application code and metadata.</td><td>Typically smaller but may vary based on module dependencies.</td><td>Typically smaller, only contains the application code and a <code>MANIFEST.MF</code>.</td></tr><tr><td><strong>Usage</strong></td><td>Common in Spring Boot, standalone apps, and microservices where ease of deployment is important.</td><td>Used in environments where dependencies are provided externally, like application servers.</td><td>Modular applications built with Java 9+ where fine-grained control over dependencies is needed.</td><td>Common for simple applications, but requires dependencies to be handled manually.</td></tr><tr><td><strong>Build Tools</strong></td><td>Typically created using Maven/Gradle plugins (e.g., Spring Boot Maven/Gradle Plugin, Maven Shade Plugin).</td><td>Standard JAR creation in Maven/Gradle without plugins that package dependencies.</td><td>Built using Jigsaw and compatible build tools (Maven/Gradle).</td><td>Generated using build tools (e.g., Maven <code>jar</code> plugin) with a main class specified in <code>MANIFEST.MF</code>.</td></tr><tr><td><strong>Deployment</strong></td><td>Self-contained; can be deployed directly without worrying about external dependencies.</td><td>Requires external dependencies, making deployment more complex (dependencies must be provided by the environment).</td><td>Deployed with external modules, allowing for fine control of dependency management.</td><td>Requires external libraries or dependencies to be available on the classpath.</td></tr><tr><td><strong>Advantages</strong></td><td>- Simplifies deployment<br>- Bundles everything needed<br>- Ideal for microservices and cloud deployments</td><td>- Smaller JAR file<br>- Separation of concerns (code vs. libraries)<br>- Useful for large apps managed by servers like Tomcat, JBoss</td><td>- Clear separation of modules<br>- Better dependency management<br>- Enhanced encapsulation</td><td>- Smaller size<br>- Easier to understand and build for simple applications</td></tr><tr><td><strong>Disadvantages</strong></td><td>- Larger JAR file<br>- Redundant packaging if dependencies are already available in the environment</td><td>- Needs external libraries<br>- Deployment can be complex in certain environments</td><td>- More complex to configure<br>- Requires understanding of Java’s module system</td><td>- Does not include dependencies, must manage classpath manually</td></tr><tr><td><strong>Example</strong></td><td>Spring Boot application packaged using Maven/Gradle plugins to include the app and its dependencies.</td><td>Java EE or Jakarta EE apps deployed to an application server, where libraries are provided by the server.</td><td>Modular Java application using the <code>module-info.java</code> descriptor introduced in Java 9.</td><td>Simple standalone Java application with a <code>Main-Class</code> specified in the <code>MANIFEST.MF</code>.</td></tr></tbody></table>

### 3. Typical JAR File

A Typical JAR file contains:

* **Java Class Files**: Compiled `.class` files from the Java source code.
* **Resources**: Non-code resources such as images, configuration files, property files, etc.
* **Manifest File (`META-INF/MANIFEST.MF`)**: A special file that contains metadata about the JAR, such as the main class to be executed, versioning information, and other properties.

{% hint style="info" %}
A typical JAR file usually does not include its third-party dependencies. It only contains our compiled class files and resources. External libraries (dependencies) must be included in the classpath separately when running the application
{% endhint %}

#### **Typical JAR file structure**

```
my-application.jar
|-- META-INF/
    |-- MANIFEST.MF  # Contains metadata
|-- com/
    |-- myapp/
        |-- Main.class  # Java class files
|-- resources/
    |-- config.properties  # Resources used by the application
```

#### **-> Manifest File (`MANIFEST.MF`)**

The **MANIFEST.MF** file located in the `META-INF` directory is critical for providing meta-information about the JAR file. It follows a key-value format and can contain:

*   **Version Information**: Version of the manifest and the JAR file.

    ```
    Manifest-Version: 1.0
    ```
* **Main-Class**: Specifies the entry point (the class containing the `main()` method) of the application when the JAR is executable.

```
Main-Class: com.myapp.Main
```

* **Class-Path**: Specifies external libraries or JAR files required for the application to run.

```
Class-Path: lib/dependency1.jar lib/dependency2.jar
```

Example `MANIFEST.MF`:

```
Manifest-Version: 1.0
Main-Class: com.example.Main
Class-Path: lib/library1.jar lib/library2.jar
```

**-> `com/myapp/` (or equivalent package structure)**

* This is where all our compiled **class files** are stored. The directory structure reflects the package hierarchy of our Java classes.
*   Example:

    ```
    com/myapp/
      MainApplication.class
      SomeOtherClass.class
    ```

**->** **`resources/`** (or other resource directories)

* Non-class files such as properties files, images, or XML configuration files are often included here.
* These files might be configuration files or other resources that our application needs to access at runtime.
*   Example:

    ```
    resources/
      config.properties
      messages.properties
    ```

#### **Running a JAR**

* If the manifest specifies a `Main-Class`, we can run the JAR with:

```
java -jar my-application.jar
```

* Otherwise, we must manually specify the classpath and main class to run:

```
java -cp my-application.jar com.example.myapp.MainApplication
```

### **4. Spring Boot JAR File**

In addition to a typical JAR file, a Spring Boot JAR has:

* **Embedded Dependencies**: All third-party libraries are included in `BOOT-INF/lib`, making it a **fat JAR**. This eliminates the need for an external dependency manager during runtime.
* **Custom Class Loader**: Spring Boot uses a custom class loader (from the `org.springframework.boot.loader` package) to load classes from `BOOT-INF/classes` and `BOOT-INF/lib` correctly.
* **Embedded Server**: If we're building a Spring Boot web application, the JAR file will contain an embedded web server (like Tomcat or Jetty) inside the `BOOT-INF/lib` directory, allowing the application to run standalone without external servers.

#### **Spring Boot JAR file structure**

```
sample-project-1.0-SNAPSHOT/
  |-- BOOT-INF/
      |-- classes/
      |-- lib/
  |-- META-INF/
      |-- maven/org.example/sample-project/
  |-- org/springframework/boot/loader/
```

#### -> **`BOOT-INF/` Directory**

This is where Spring Boot segregates the application’s compiled classes and its dependencies.

&#x20;   **--- `BOOT-INF/classes/`**:

* Contains our application’s compiled `.class` files and other resources (e.g., properties or YAML files).
*   For example:

    ```
    BOOT-INF/classes/com/example/demo/
      MainApplication.class
      OtherClass.class
    ```

&#x20;   **--- `BOOT-INF/lib/`**:

* Contains all the third-party dependencies packaged within our Spring Boot application. These are the libraries our application needs to run, based on what we declared in`pom.xml` or `build.gradle`.
* Each library is stored as a separate JAR file.
*   For example:

    ```
    BOOT-INF/lib/spring-boot-starter-web-2.7.0.jar
    BOOT-INF/lib/commons-lang3-3.12.0.jar
    ```

#### **-> `META-INF/` Directory**

This directory contains metadata about our application, typical in Java archive files.

&#x20;   **--- `META-INF/MANIFEST.MF`**:

* The manifest file contains metadata such as the entry point of our Spring Boot application and the version of Spring Boot.
*   Example content:

    ```
    Manifest-Version: 1.0
    Created-By: Maven JAR Plugin 3.3.0
    Build-Jdk-Spec: 22
    Implementation-Title: sample-project
    Implementation-Version: 1.0-SNAPSHOT
    Main-Class: org.springframework.boot.loader.JarLauncher
    Start-Class: org.example.Application
    Spring-Boot-Version: 3.1.10
    Spring-Boot-Classes: BOOT-INF/classes/
    Spring-Boot-Lib: BOOT-INF/lib/
    Spring-Boot-Classpath-Index: BOOT-INF/classpath.idx
    Spring-Boot-Layers-Index: BOOT-INF/layers.idx
    ```
* **Main-Class**: Specifies the class that will bootstrap our Spring Boot application, typically `JarLauncher`.
* **Start-Class**: Our application’s entry point with the `main()` method (`MainApplication` in this case)

&#x20;   **--- `META-INF/maven/org.example/sample-project/`**:

* This subdirectory contains files generated by Maven during the build process:
  * **`pom.xml`**: The project’s Maven `pom.xml` file. It defines the project’s dependencies and configuration.
  * **`pom.properties`**: This file contains information such as the group ID, artifact ID, version, and other Maven-related metadata.
*   Example structure:

    ```
    META-INF/maven/org.example/sample-project/
      pom.xml
      pom.properties
    ```

&#x20;**-> `org/springframework/boot/loader/` Directory**

This directory is part of the Spring Boot **Loader**. It contains the classes that manage launching our Spring Boot application.

* **Loader Classes**:
  * The classes here, such as `JarLauncher`, `WarLauncher`, and `PropertiesLauncher`, handle the custom class loading and the execution of our Spring Boot JAR file.
  * These classes are responsible for reading classes from `BOOT-INF/classes` and `BOOT-INF/lib` and ensuring that they are available to the application.
  * Key classes:
    * **`JarLauncher`**: Handles launching the Spring Boot JAR.
    * **`WarLauncher`**: Used if the application is packaged as a WAR (not typical for a JAR).
    * **`PropertiesLauncher`**: Enables launching based on configuration properties.

Example:

```
org/springframework/boot/loader/
  JarLauncher.class
  WarLauncher.class
  PropertiesLauncher.class
```

### 5. **How Spring Boot Fat JAR Works?**

When we run a Spring Boot JAR using `java -jar sample-project-1.0-SNAPSHOT.jar`, the following process happens:

1. **Spring Boot Loader**: The `JarLauncher` (specified in the `MANIFEST.MF`) starts execution.
2. **Class Loading**: The launcher sets up a custom class loader that loads classes from `BOOT-INF/classes` (our application’s classes) and `BOOT-INF/lib` (our dependencies).
3. **Application Startup**: The `Start-Class` (our main application class, specified in the manifest) is then located and executed, starting the Spring Boot application.
4. **Embedded Server**: If it’s a web application, the embedded web server (e.g., Tomcat) is started, and the application becomes accessible via the configured port (default: `8080`).

### **6. Creating a JAR File**

#### **a. Using the JDK `jar` Tool**

The JDK provides a `jar` command to create, view, or extract JAR files.

**-> Creating a JAR**: If we have compiled class files in the `com/example` directory:

```
jar cvf myapp.jar -C ./com .    
```

* `c`: Create a new JAR file.
* `v`: Verbose output to show the files being added.
* `f`: Output the result to a file (e.g., `myapp.jar`).
* `-C`: Change to the specified directory (`./com`) before adding files.

**-> Adding a Manifest File**: We can include a custom `MANIFEST.MF` file using:

```
jar cvfm myapp.jar MANIFEST.MF -C ./com .
```

#### **b. Using Build Tools**

*   **Maven**: Maven simplifies the process of building JAR files using the `maven-jar-plugin`:

    ```
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-jar-plugin</artifactId>
                <version>3.2.0</version>
            </plugin>
        </plugins>
    </build>
    ```

### **7. Security in JAR Files**

**a. Signing JAR Files**

We can sign a JAR file to ensure its authenticity and integrity. Signing is typically used when distributing JARs over the web.

* **Sign JAR**: Use the `jarsigner` tool to sign a JAR file.

```
jarsigner -keystore mykeystore -signedjar signed.jar myapp.jar alias_name
```

**b. Verifying Signed JARs**

We can verify the signature of a JAR file using:

```
jarsigner -verify signed.jar
```

### **8. Multi-Release JARs**

Introduced in Java 9, **multi-release JARs** allow different class versions to be packaged for different Java runtime environments. This enables backward compatibility while taking advantage of newer Java features.

* **Structure of a multi-release JAR**:

```
META-INF/versions/9/com/example/MyClass.class
META-INF/versions/11/com/example/MyClass.class
```

The JVM automatically selects the appropriate class version based on the runtime environment.



## WAR Packaging





## EAR Packaging





