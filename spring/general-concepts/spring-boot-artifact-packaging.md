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

#### **JAR file structure**

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

### 1. What is a WAR File?

A **WAR** file is a standard format used for deploying **web applications** on a **Java EE (Enterprise Edition) server**. It contains all the components required for a web application to run, such as Java classes, libraries, configuration files, static resources, and JSP (JavaServer Pages) files. A WAR file can be deployed to any compliant servlet container or application server that implements the Java Servlet API.

The WAR file has a specific structure and layout that conforms to the Java Servlet Specification. However, Spring Boot adds some enhancements to make it easier to work with WAR packaging in modern development workflows.

### 2. Structure of a Spring Boot WAR File

When we package a Spring Boot application as a WAR file (e.g., `sample-project-1.0-SNAPSHOT.war`), the file will have the following structure after extraction:

```plaintext
sample-project-1.0-SNAPSHOT.war
  - META-INF/
  - WEB-INF/
     - classes/
     - lib/
     - lib-provided/
     - web.xml
  - org/
```

#### **-> `META-INF/` Directory**

This is a standard directory in any JAR or WAR file that contains metadata about the archive.

*   **`META-INF/MANIFEST.MF`**:

    * This is the manifest file for the WAR file, similar to a JAR. It typically contains metadata such as:
      * **Manifest-Version**: The version of the manifest format.
      * **Class-Path**: The classpath needed to run the application (optional in WARs).
      * **Main-Class**: Often absent in WAR files, as they do not run standalone like JARs.
      * In a Spring Boot WAR, the **Main-Class** attribute might not be present, since the WAR will be managed by the external server.

    Example `MANIFEST.MF`:

    ```plaintext
    Manifest-Version: 1.0
    Created-By: Apache Maven 3.6.0
    Built-By: user
    Build-Jdk: 11.0.11
    ```

**-> `WEB-INF/` Directory**

The `WEB-INF` directory is the heart of the WAR file and is not directly accessible via the web browser. It contains all the important parts of the web application: classes, libraries, and configuration files.

* **`WEB-INF/web.xml`** (Optional):
  * This file is the **deployment descriptor** for the Java EE web application. It specifies configurations like servlets, filters, listeners, and security settings.
  * For Spring Boot applications, we typically don’t need to configure `web.xml` manually, as Spring Boot uses **Java-based configuration**. However, if we need to, we can override this and add custom servlet or filter configurations.
  * Example:

```
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         version="3.1">
    <display-name>Sample Spring Boot Web Application</display-name>

    <!-- Optional custom servlets and filters -->
</web-app>
```

* **`WEB-INF/classes/`**:
  * This directory contains all the compiled classes from our `src/main/java` directory.
  * All of our application’s resources (like `application.properties`, `application.yml`, or static resources) will also reside here.
  *   Example:

      ```plaintext
      WEB-INF/classes/com/example/demo/
        MainApplication.class
        UserService.class
      WEB-INF/classes/application.properties
      ```
* **`WEB-INF/lib/`**:
  * This directory contains all the JAR dependencies required by the application. This includes all libraries we specified in the `pom.xml` or `build.gradle` file.
  * Spring Boot makes sure that all our external dependencies (like `spring-core`, `spring-web`, etc.) are included here.
  *   Example:

      ```plaintext
      WEB-INF/lib/spring-web-5.3.10.jar
      WEB-INF/lib/hibernate-core-5.4.32.Final.jar
      ```
* **`WEB-INF/lib-provided/`** (Optional):
  * If we are relying on certain dependencies that are provided by the application server (e.g., `javax.servlet-api`, `spring-web`), we can place them in this directory to signal that they should not be included in the final WAR.
  * These libraries are typically **provided** by the servlet container (e.g., Tomcat), and we don’t need to include them in the WAR file.
  *   Example:

      ```plaintext
      WEB-INF/lib-provided/servlet-api.jar
      WEB-INF/lib-provided/jsp-api.jar
      ```

#### **-> `org/springframework/boot/loader/` Directory (Optional)**

In a Spring Boot JAR, this directory contains Spring Boot’s **launcher classes**. However, for a WAR deployment, this may or may not be present. When deploying a Spring Boot application as a WAR, the servlet container’s classloader handles the loading process.

* **If present**: This folder contains `JarLauncher`, `WarLauncher`, and other Spring Boot loader classes used for custom class loading when running as a standalone WAR.
* **If absent**: The WAR relies on the external servlet container for launching, so this package isn't needed.

#### **-> Static Resources (Optional)**

Static resources (like HTML, CSS, JS, and image files) are usually placed outside of the `WEB-INF` directory in the root directory of the WAR. For example:

* **`index.html`**: The main landing page for the application.
* **`static/`**: This directory holds static resources such as images, CSS files, or JavaScript files that are publicly accessible.

Example structure:

```plaintext
sample-project-1.0-SNAPSHOT.war
  - index.html
  - static/
     - css/
     - js/
     - images/
```

## EAR Packaging

### 1. What is an EAR File?

An **EAR (Enterprise Archive)** is a file format used for packaging and deploying Java EE enterprise applications. It encapsulates multiple related modules that together form a cohesive application, including **Web Applications (WARs)**, **EJB (Enterprise JavaBeans) modules (JARs)**, and **utility libraries**. EAR packaging is typically used for applications with complex business logic involving multiple tiers (web tier, business tier, etc.).

EAR files follow a **standardized structure** as defined by the Java EE specifications, and are deployed to **application servers** that support the full Java EE platform.

### 2. Typical Structure of an EAR File

When we package a Java EE application as an EAR file (e.g., `sample-project-1.0-SNAPSHOT.ear`), the resulting file structure, after extraction, looks like the following:

```plaintext
sample-project-1.0-SNAPSHOT.ear
  - META-INF/
      - application.xml
      - MANIFEST.MF
  - lib/
  - sample-webapp-1.0-SNAPSHOT.war
  - sample-ejb-1.0-SNAPSHOT.jar
  - common-utilities.jar
```

#### -> **`META-INF/` Directory**

This directory holds metadata about the EAR file and its contents.

* **`META-INF/MANIFEST.MF`**:
  * Similar to other Java archive formats (JAR, WAR), the `MANIFEST.MF` file in the `META-INF` directory contains information about the EAR file itself.
  *   Example:

      ```plaintext
      Manifest-Version: 1.0
      Created-By: Apache Maven 3.6.3
      Build-Jdk: 11.0.10
      ```
* **`META-INF/application.xml`** (Optional):
  * This is the **deployment descriptor** for the EAR file. It describes how the different modules (WARs, EJB JARs, etc.) in the EAR should be deployed.
  * For Spring Boot applications or modern Java EE configurations, this file may be optional or even omitted, as many servers can use annotations or default conventions.
  * A typical `application.xml` would specify all the modules (JARs and WARs) that are part of the EAR, and any context root or configuration settings.
  *   Example:

      ```xml
      <application xmlns="http://xmlns.jcp.org/xml/ns/javaee"
                   version="7">
          <display-name>Sample Enterprise Application</display-name>

          <!-- Web module -->
          <module>
              <web>
                  <web-uri>sample-webapp-1.0-SNAPSHOT.war</web-uri>
                  <context-root>/sample</context-root>
              </web>
          </module>

          <!-- EJB module -->
          <module>
              <ejb>sample-ejb-1.0-SNAPSHOT.jar</ejb>
          </module>

          <!-- Utility module -->
          <module>
              <java>common-utilities.jar</java>
          </module>
      </application>
      ```

### **3. WAR Modules**

* **Web Applications** are packaged as **WAR** files and included in the EAR. Each WAR module contains the structure already discussed in the previous section (like `WEB-INF`, `META-INF`, `classes`, etc.).
* These WAR modules represent the **web tier** of the enterprise application, and they handle HTTP requests and responses. For example, in a traditional multi-tier enterprise application, the web module (WAR) would serve as the user interface (UI) tier that interacts with the business tier (EJB).

Example:

```
sample-project-1.0-SNAPSHOT.ear
  - sample-webapp-1.0-SNAPSHOT.war
     - META-INF/
     - WEB-INF/
     - index.html
     - WEB-INF/web.xml
```

The `WAR` module would behave just like any Spring Boot web application or Java EE web application.

### 4. J**AR Modules (EJB and Utility JARs)**

* **EJB Modules** are packaged as **JAR** files within the EAR. These contain the **business logic** in the form of **Enterprise JavaBeans (EJBs)**.
* **Utility JARs**: These are libraries shared across the application, which can be referenced by both WAR and EJB modules. Utility classes or shared components, like logging frameworks, database utilities, or shared services, can be placed in this directory.

Example:

```
sample-project-1.0-SNAPSHOT.ear
  - sample-ejb-1.0-SNAPSHOT.jar
     - META-INF/
     - com/example/ejb/
        - UserBean.class
  - common-utilities.jar
     - com/example/util/
        - StringUtils.class
```

## JAR vs WAR vs EAR

<table data-header-hidden data-full-width="true"><thead><tr><th></th><th></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Aspect</strong></td><td><strong>JAR</strong></td><td><strong>WAR</strong></td><td><strong>EAR</strong></td></tr><tr><td><strong>Purpose</strong></td><td>Standalone applications (with embedded server).</td><td>Deployable web applications to a servlet container (e.g., Tomcat).</td><td>Multi-module enterprise applications (web, EJB, etc.) managed by an application server.</td></tr><tr><td><strong>Application Server</strong></td><td>Embedded (self-contained) server, like Tomcat, Jetty, or Undertow.</td><td>Requires external servlet container (Tomcat, Jetty) for deployment.</td><td>Requires a full-fledged Java EE-compliant application server (e.g., WildFly, GlassFish, WebLogic).</td></tr><tr><td><strong>Deployment Method</strong></td><td>Directly run via <code>java -jar &#x3C;app>.jar</code>.</td><td>Deploy WAR to a servlet container (Tomcat, Jetty, etc.).</td><td>Deploy EAR to a Java EE-compliant application server.</td></tr><tr><td><strong>Structure</strong></td><td>Contains <code>BOOT-INF/classes</code>(compiled classes), <code>BOOT-INF/lib</code>(dependencies), and Spring Boot loader classes.</td><td>Contains a typical WAR structure: <code>WEB-INF/</code>, <code>META-INF/</code>, <code>classes</code>, <code>lib</code>.</td><td>Contains multiple modules, including WARs, EJB JARs, and shared libraries (<code>lib/</code>).</td></tr><tr><td><strong>Configuration Files</strong></td><td>Application-specific configurations (<code>application.properties</code>, <code>application.yml</code>) bundled in <code>BOOT-INF/classes</code>.</td><td>Standard <code>web.xml</code>configuration in <code>WEB-INF/</code>.</td><td><code>application.xml</code> in <code>META-INF/</code> for EAR metadata and module definitions.</td></tr><tr><td><strong>Embedded Server</strong></td><td>Yes (Tomcat, Jetty, Undertow can be embedded within the JAR).</td><td>No, relies on the servlet container in which it is deployed.</td><td>No, relies on the application server for both web and EJB modules.</td></tr><tr><td><strong>Ease of Deployment</strong></td><td>Simple to deploy as a single JAR; just run it as a standard Java application.</td><td>Requires deployment to an external servlet container (Tomcat, Jetty).</td><td>More complex as multiple modules are deployed as one EAR package.</td></tr><tr><td><strong>Scalability</strong></td><td>Good for microservices or small applications due to its simplicity and self-contained nature.</td><td>Suitable for larger applications but still requires a container.</td><td>Best suited for enterprise-level applications with complex modules (web, EJB, etc.).</td></tr><tr><td><strong>Module Handling</strong></td><td>No modularity; the JAR encapsulates everything.</td><td>WAR is a single web module with JSP, servlets, Spring controllers, etc.</td><td>EAR can bundle multiple WARs, EJB JARs, and shared libraries for modularity.</td></tr><tr><td><strong>Spring Boot Support</strong></td><td>Fully supported by Spring Boot (standard packaging method for Spring Boot apps).</td><td>Supported but requires a slight change to <code>pom.xml</code> for WAR packaging.</td><td>Not directly supported by Spring Boot (typically used in full Java EE environments).</td></tr><tr><td><strong>Use Cases</strong></td><td>Ideal for standalone microservices or self-contained applications.</td><td>Web applications that need to run in traditional servlet containers.</td><td>Large, complex enterprise applications requiring EJB, multiple WARs, and shared resources.</td></tr><tr><td><strong>Class Loading</strong></td><td>Handles its own class loading with Spring Boot Loader.</td><td>Depends on the servlet container’s classloader.</td><td>Handled by the Java EE application server, allowing multiple modules to share classes.</td></tr><tr><td><strong>Shared Libraries</strong></td><td>All dependencies are bundled inside the JAR itself (via <code>BOOT-INF/lib</code>).</td><td>External libraries can be shared via the servlet container’s <code>lib</code> directory.</td><td>A dedicated <code>lib/</code> directory inside the EAR for shared libraries accessible by all modules (WAR, JAR).</td></tr><tr><td><strong>Application Server Features</strong></td><td>Limited application server features (e.g., no full Java EE compliance).</td><td>Only servlet-based features (no EJB or resource adapters).</td><td>Full Java EE support including EJB, JPA, messaging, resource adapters, etc.</td></tr><tr><td><strong>Security</strong></td><td>Spring Security can be bundled for application-level security.</td><td>Relies on container-based security, e.g., web.xml for security constraints.</td><td>Uses the full range of Java EE security (JASPIC, JAAS, container-managed security).</td></tr><tr><td><strong>Customization</strong></td><td>Customization of the embedded server is possible (configuring ports, HTTPS, etc.).</td><td>Relies on the external servlet container’s configuration.</td><td>Application server manages module interaction, security, and resource adapters.</td></tr><tr><td><strong>Hot Deployment</strong></td><td>Not typically supported; usually requires restarting the app for changes.</td><td>Some servlet containers support hot deployment (reloading changes without restarting).</td><td>Most Java EE servers support hot deployment for EARs (hot swapping modules).</td></tr><tr><td><strong>Development Effort</strong></td><td>Lower effort, simpler setup for microservices and small applications.</td><td>Medium effort, suitable for traditional web apps.</td><td>Higher effort, more suited for enterprise-level, multi-module apps.</td></tr><tr><td><strong>Tools</strong></td><td>Built using tools like <strong>Spring Boot</strong>, <strong>Maven</strong>, <strong>Gradle</strong> with Spring Boot plugins for packaging.</td><td>Built using <strong>Spring Boot</strong> with modified <strong>pom.xml</strong> for WAR packaging.</td><td>Typically built using <strong>Maven EAR Plugin</strong> or <strong>Ant</strong>, and deployed on application servers like WildFly or WebLogic.</td></tr><tr><td><strong>Typical Examples</strong></td><td>Microservices, REST APIs, standalone applications (e.g., Spring Boot apps).</td><td>Standard web applications using JSP/Servlets or Spring MVC.</td><td>Enterprise applications involving multiple modules, e.g., web (WAR) and business logic (EJB JAR).</td></tr></tbody></table>

