# Maven Lifecycle and Dependency Scope

## About

Maven organizes the **build process** into well-defined phases, allowing structured execution of tasks like **compilation, testing, packaging, and deployment**.

Maven has three primary lifecycles:

* **Clean**: Removes previous build artifacts.
* **Default (Build)**: Compiles, tests, packages, and deploys the project.
* **Site**: Generates documentation.

Among these, the **default lifecycle** consists of the following key phases:

<table data-header-hidden><thead><tr><th width="120.73046875"></th><th></th></tr></thead><tbody><tr><td><strong>Phase</strong></td><td><strong>Description</strong></td></tr><tr><td><code>validate</code></td><td>Ensures the project is correct and necessary information is available.</td></tr><tr><td><code>compile</code></td><td>Compiles source code of the project.</td></tr><tr><td><code>test</code></td><td>Runs unit tests using a testing framework (e.g., JUnit, TestNG).</td></tr><tr><td><code>package</code></td><td>Bundles compiled code into a distributable format (JAR, WAR, etc.).</td></tr><tr><td><code>verify</code></td><td>Runs integration tests to ensure package correctness.</td></tr><tr><td><code>install</code></td><td>Installs the package in the local repository (~/.m2) for use by other projects.</td></tr><tr><td><code>deploy</code></td><td>Uploads the package to a remote repository for sharing with others.</td></tr></tbody></table>

## Dependency Scope vs. Lifecycle Phases

Maven dependencies are **activated** based on their **scope** at different phases of the build lifecycle.

### **1. `compile` Phase**

* Converts `.java` source files to `.class` bytecode.
* Dependencies in **compile**, **provided**, and **system** scope are available.
* **test** and **runtime** dependencies are **not available**.

**Example:**

```sh
mvn compile
```

{% hint style="success" %}
Available Scopes: **compile, provided, system**\
Ignored Scopes: **test, runtime**
{% endhint %}

### **2. `test` Phase**

* Executes **unit tests** using JUnit/TestNG.
* Requires compiled source code from `compile` phase.
* Dependencies in **compile, provided, runtime, and test** scopes are available.

**Example:**

```sh
mvn test
```

{% hint style="success" %}
Available Scopes: **compile, provided, runtime, test**\
Ignored Scopes: **system** (not propagated)
{% endhint %}

**Example `pom.xml`:**

```xml
<dependency>
    <groupId>junit</groupId>
    <artifactId>junit</artifactId>
    <version>4.13.2</version>
    <scope>test</scope>
</dependency>
```

* JUnit is available **only** during test execution.
* It **won't be included** in the final JAR/WAR.

### **3. `package` Phase**

* Packages compiled code into a **JAR/WAR/ZIP**.
* Dependencies in **compile, runtime** scope are included in the package.
* **provided and test** dependencies are **not included**.

**Example:**

```sh
mvn package
```

{% hint style="success" %}
Available Scopes: **compile, runtime**\
Ignored Scopes: **test, provided**
{% endhint %}

### **4. `verify` Phase**

* Runs **integration tests** to verify the packaged application.
* Often used with frameworks like **Selenium, Cucumber, or REST Assured**.
* Dependencies in **compile, runtime, test** scopes are available.

**Example:**

```sh
mvn verify
```

{% hint style="success" %}
Available Scopes: **compile, runtime, test**\
Ignored Scopes: **provided, system**
{% endhint %}

### **5. `install` Phase**

* Deploys the built JAR/WAR into the **local Maven repository** (`~/.m2`).
* Useful for sharing dependencies across local projects.
* Dependencies in **compile, runtime** scope are packaged.

**Example:**

```sh
mvn install
```

{% hint style="success" %}
Available Scopes: **compile, runtime**\
Ignored Scopes: **test, provided, system**
{% endhint %}

### **6. `deploy` Phase**

* Uploads the package to a **remote repository** (like Nexus, Artifactory, or Maven Central).
* Used in **CI/CD pipelines** for distributing artifacts.
* Dependencies in **compile, runtime** scope are deployed.

**Example:**

```sh
mvn deploy
```

{% hint style="success" %}
Available Scopes: **compile, runtime**\
Ignored Scopes: **test, provided, system**
{% endhint %}

