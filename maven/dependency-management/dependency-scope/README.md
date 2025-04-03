# Dependency Scope

## About

In Maven, dependency scopes define the visibility and lifecycle of a dependency. The scope of a dependency determines where it is available in the project lifecycle (compile, test, runtime, etc.) and whether it is included in the final package. Here are the different types of dependency scopes in Maven.

{% hint style="success" %}
Maven dependency scope defines **when** and **where** a dependency is required in a project. It controls:

* Availability of dependencies at **compile-time**, **test-time**, **runtime**, or **packaging**.
* Inclusion of dependencies in the final artifact.
* Propagation of dependencies to dependent projects (transitive dependencies).
{% endhint %}

Maven has six dependency scopes -

<table data-header-hidden data-full-width="true"><thead><tr><th width="110.81640625"></th><th width="328.984375"></th><th></th><th></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Scope</strong></td><td><strong>Used for</strong></td><td><strong>Available at Compile?</strong></td><td><strong>Available at Runtime?</strong></td><td><strong>Inherited by Child Projects?</strong></td><td><strong>Packaged in WAR/JAR?</strong></td></tr><tr><td><code>compile</code></td><td>Default scope (for APIs)</td><td>Yes</td><td>Yes</td><td>Yes</td><td>Yes</td></tr><tr><td><code>provided</code></td><td>Dependencies available at runtime (like Java EE APIs, servlet APIs)</td><td>Yes</td><td>No</td><td>Yes</td><td>No</td></tr><tr><td><code>runtime</code></td><td>Needed at runtime, but not at compile-time (e.g., JDBC drivers)</td><td>No</td><td>Yes</td><td>Yes</td><td>Yes</td></tr><tr><td><code>test</code></td><td>Only required for testing (JUnit, Mockito, etc.)</td><td>No</td><td>Yes (Test phase only)</td><td>No</td><td>No</td></tr><tr><td><code>system</code></td><td>Similar to <code>provided</code>, but requires an absolute path to a local JAR</td><td>Yes</td><td>Yes</td><td>Yes</td><td>No</td></tr><tr><td><code>import</code></td><td>Used with <code>dependencyManagement</code> in multi-module projects</td><td>No</td><td>No</td><td>Yes</td><td>No</td></tr></tbody></table>

## 1. `compile`

* **Default Scope**: If no scope is specified, the dependency is assumed to be in the `compile` scope.
* **Availability**: Available in all classpaths (compilation, testing, runtime, and packaged in the final artifact).
* **Use Case**: For dependencies required for the project to compile, such as the main application libraries.

```xml
<dependency>
  <groupId>org.springframework</groupId>
  <artifactId>spring-core</artifactId>
  <version>5.3.9</version>
  <scope>compile</scope> <!-- This is the default, so it can be omitted -->
</dependency>
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-lang3</artifactId>
    <version>3.12.0</version>
</dependency>
```

## 2. `provided`

* Similar to `compile`, but **not packaged** in the final artifact.
* **Availability**: Available in the compilation and test classpaths but not in the runtime classpath.
* **Use Case**: For dependencies provided by the runtime environment (e.g., a servlet API provided by the application server). For eg, we are deploying to an application server like Tomcat, WildFly, or GlassFish, which **already provides** the required JARs.

```xml
<dependency>
  <groupId>javax.servlet</groupId>
  <artifactId>servlet-api</artifactId>
  <version>2.5</version>
  <scope>provided</scope>
</dependency>
```

## 3. `runtime`

* **Availability**: Available in the runtime and test classpaths but not in the compilation classpath.&#x20;
* **Use Case**: For dependencies required only at runtime, such as JDBC drivers.
* Helps reduce unnecessary dependencies during compilation.

{% hint style="info" %}
We only need the dependency **when the application runs**, not when compiling the code.
{% endhint %}

```xml
<dependency>
  <groupId>mysql</groupId>
  <artifactId>mysql-connector-java</artifactId>
  <version>8.0.23</version>
  <scope>runtime</scope>
</dependency>
```

## 4. `test`

* **Availability**: Available only in the test classpath. Dependencies required only for testing.
* **Use Case**: For dependencies needed only for testing purposes, such as testing frameworks (e.g., JUnit). Typically used for **JUnit, Mockito, TestNG**, etc.

{% hint style="info" %}
Used when writing **unit tests, integration tests, or functional tests**.
{% endhint %}

```xml
<dependency>
  <groupId>junit</groupId>
  <artifactId>junit</artifactId>
  <version>4.13.2</version>
  <scope>test</scope>
</dependency>
```

## 5. `system` (Rarely Used)

* **Availability**: Similar to `provided`, but the JAR file for the dependency must be explicitly provided and not downloaded from a repository.
* **Use Case**: For dependencies that must be explicitly specified and are not available in any remote repository. Useful when we have **proprietary JARs** that are not available in public repositories.
* **Additional Requirement**: Requires the `systemPath` element to specify the path to the JAR file.

{% hint style="info" %}
**Why to Avoid It?**

* Hardcodes paths, making the project **non-portable**.
* Better alternatives: **Use a private Maven repository (like Nexus/Artifactory).**
{% endhint %}

```xml
<dependency>
  <groupId>com.example</groupId>
  <artifactId>example-library</artifactId>
  <version>1.0.0</version>
  <scope>system</scope>
  <systemPath>${project.basedir}/libs/example-library-1.0.0.jar</systemPath>
</dependency>
```

## 6. `import` (Used in Multi-Module Projects)

* **Availability**: Not a regular dependency, but rather a way to manage dependencies. Only used in the `<dependencyManagement>` section.
* **Use Case**: Used to import dependencies from a BOM (Bill of Materials) POM. Managing dependency versions **centrally** in a parent POM.

```xml
<dependencyManagement>
  <dependencies>
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-dependencies</artifactId>
      <version>2.5.4</version>
      <scope>import</scope>
      <type>pom</type>
    </dependency>
  </dependencies>
</dependencyManagement>
```

{% hint style="info" %}
**Handling Scope Conflicts**

If a dependency appears in different scopes across modules, Maven applies **nearest dependency wins**:

* The **scope closest to the current module** is applied.
* If scopes conflict, **test < runtime < provided < compile**.
{% endhint %}



## How Dependency Scope Affects Transitive Dependencies ?

Maven **automatically propagates** dependencies (also known as **transitive dependencies**) based on the scope of the parent dependency. However, the scope of a transitive dependency may change depending on the scope of the dependency that introduced it.

### **Propagation Rules for Transitive Dependencies**

* **Compile Scope**: If a dependency is declared with `compile`, its transitive dependencies are also available with `compile` scope in dependent projects.
* **Provided Scope**: Dependencies declared with `provided` scope do not propagate transitively.
* **Runtime Scope**: If a dependency is declared with `runtime`, its transitive dependencies are only available at **runtime** (not at compile-time).
* **Test Scope**: Dependencies with `test` scope **are not propagated** transitively. They are only available in the module where they are declared.
* **System Scope**: Dependencies with `system` scope **are not propagated** at all.
* **Import Scope**: Used for **dependencyManagement** in parent POMs, it does not propagate dependencies directly.

### **Example: How Scope Affects Transitive Dependencies**

Consider the following scenario:

**Dependency Hierarchy**

1. **Project A** depends on **Library B** with `compile` scope.
2. **Library B** depends on **Library C** with `runtime` scope.
3. **Project A** will get:
   * **Library B** with `compile` scope.
   * **Library C** with **runtime** scope (because transitive dependencies inherit their scope from their parent).

**Transitive Scope Propagation**

<table data-header-hidden><thead><tr><th width="235.30078125"></th><th></th></tr></thead><tbody><tr><td><strong>Parent Dependency Scope</strong></td><td><strong>Transitive Dependencies' Scope in Child Modules</strong></td></tr><tr><td><code>compile</code></td><td><strong>compile</strong> (default behavior)</td></tr><tr><td><code>provided</code></td><td><strong>Not propagated</strong></td></tr><tr><td><code>runtime</code></td><td><strong>runtime</strong> (not available at compile-time)</td></tr><tr><td><code>test</code></td><td><strong>Not propagated</strong> (only for the current module)</td></tr><tr><td><code>system</code></td><td><strong>Not propagated</strong> (requires manual JAR inclusion)</td></tr><tr><td><code>import</code></td><td><strong>Not propagated</strong> (only for dependency management)</td></tr></tbody></table>

### **Overriding Transitive Dependency Scope**

We can override transitive dependency scopes by re-declaring the dependency with a different scope.

**Example:**

```xml
<dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>slf4j-api</artifactId>
    <version>1.7.36</version>
    <scope>compile</scope>
</dependency>
```

If this was originally a `runtime` dependency, we **force** it to be `compile`.

## Optimizing Dependencies Using Dependency Analysis Plugin

Use this plugin to check **unused dependencies**:

```sh
mvn dependency:analyze
```

It will report **unnecessary dependencies** or those with **incorrect scopes**.

## Example

### 1. Compile Scope (Default)

#### **Example: Spring Boot Core Dependencies**

**Scenario:** A Spring Boot web application needs `spring-web` at **compile-time and runtime**.

```xml
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-web</artifactId>
    <version>5.3.29</version>
</dependency>
```

**Why `compile`?**

* Needed during **development** for writing controllers and services.
* Required at **runtime** for handling HTTP requests.
* Included in the **final JAR/WAR** file.

### 2. Provided Scope

#### **Example: Servlet API in a Web Application**

**Scenario:** A Java web application runs on **Tomcat**, which already provides the Servlet API.

```xml
<dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>javax.servlet-api</artifactId>
    <version>4.0.1</version>
    <scope>provided</scope>
</dependency>
```

**Why `provided`?**

* The **Servlet API is already available** in Tomcat at runtime.
* Avoids **duplicate dependencies** in the final JAR/WAR.
* Available at **compile-time**, but not included in the final package.

**What happens if we use `compile` instead?**

* The Servlet API JAR will be included in our WAR, leading to **conflicts** when deployed in Tomcat.

### 3. Runtime Scope

#### **Example: JDBC Driver**

**Scenario:** Our application **connects to MySQL**, but the MySQL driver is **only needed at runtime**, not at compile-time.

```xml
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.33</version>
    <scope>runtime</scope>
</dependency>
```

**Why `runtime`?**

* **Not needed** at compile-time because we use **JDBC interfaces (`java.sql.Connection`)**.
* Required **at runtime** when the app connects to MySQL.
* Included in the **final JAR/WAR**.

**What happens if we use `compile` instead?**

* The MySQL driver will be available **at compile-time**, even though we only need it at runtime.

### 4. Test Scope

#### **Example: JUnit & Mockito for Testing**

**Scenario:** Our application needs JUnit and Mockito for **unit testing**, but these should **not** be included in production.

```xml
<dependency>
    <groupId>junit</groupId>
    <artifactId>junit</artifactId>
    <version>4.13.2</version>
    <scope>test</scope>
</dependency>

<dependency>
    <groupId>org.mockito</groupId>
    <artifactId>mockito-core</artifactId>
    <version>5.7.0</version>
    <scope>test</scope>
</dependency>
```

**Why `test`?**

* JUnit and Mockito are **only needed for testing**, so they **should not be packaged** in the final artifact.
* Reduces **bloat** in the final build.
* Available **only during test compilation and execution**.

**What happens if we use `compile` instead?**

* The testing libraries would be **included in the production JAR**, which is unnecessary.

## **5. System Scope**

#### **Example: Proprietary JAR**

**Scenario:** Our project uses a **custom in-house library** (`custom-lib.jar`) that is **not available in any Maven repository**.

```xml
<dependency>
    <groupId>com.company</groupId>
    <artifactId>custom-lib</artifactId>
    <version>1.0.0</version>
    <scope>system</scope>
    <systemPath>${project.basedir}/libs/custom-lib.jar</systemPath>
</dependency>
```

**Why `system`?**

* The JAR **is not in Maven Central** or a private repo.
* Ensures that a specific version of `custom-lib.jar` is always used.

**Why is `system` not recommended?**

* **Hardcodes file paths**, making the project **non-portable**.
* Better alternative: Upload the JAR to a **private Nexus/Artifactory repository**.

**Better approach: Deploy the JAR to a local Maven repo**

{% code overflow="wrap" %}
```sh
mvn install:install-file -Dfile=libs/custom-lib.jar -DgroupId=com.company -DartifactId=custom-lib -Dversion=1.0.0 -Dpackaging=jar
```
{% endcode %}

Then use:

```xml
<dependency>
    <groupId>com.company</groupId>
    <artifactId>custom-lib</artifactId>
    <version>1.0.0</version>
</dependency>
```

### 6. Import Scope (Multi-Module Projects)

#### **Example: Spring Boot Dependency Management**

**Scenario:** A multi-module Maven project needs to **share dependencies** across multiple submodules.

In the **parent `pom.xml`**:

```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-dependencies</artifactId>
            <version>2.7.0</version>
            <scope>import</scope>
            <type>pom</type>
        </dependency>
    </dependencies>
</dependencyManagement>
```

**Why `import`?**

* Ensures **all submodules use the same dependency versions**.
* **Prevents version mismatches** across modules.

**What happens if we don’t use `import`?**

* Each submodule might have **different versions** of dependencies, causing conflicts.

