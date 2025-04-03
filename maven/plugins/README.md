---
description: >-
  An overview of various plugins used commonly across various projects in the
  form of categories.
hidden: true
---

# Plugins

## About

Maven plugins are essential components that help automate and manage various tasks in a Maven build lifecycle. They extend Maven's capabilities beyond dependency management and are used for compilation, testing, packaging, deployment, reporting, and more.

A plugin in Maven is simply a **set of goals** that perform specific tasks, such as:

* Compiling Java code (`maven-compiler-plugin`)
* Running tests (`maven-surefire-plugin`)
* Packaging applications (`maven-assembly-plugin`, `maven-war-plugin`)
* Analyzing code quality (`maven-checkstyle-plugin`, `spotbugs-maven-plugin`)
* Deploying artifacts (`maven-deploy-plugin`)

## Goals in Maven Plugins

A **goal** in Maven is a specific task performed by a plugin. Each plugin consists of one or more goals that define what actions the plugin will execute.

For example, the **`maven-compiler-plugin`** has the goal `compile`, which compiles Java source files.

### Goals vs. Plugins vs. Phases

* **Plugin** = A collection of goals (e.g., `maven-compiler-plugin`)
* **Goal** = A specific task within a plugin (e.g., `compile`)
* **Phase** = A stage in the build lifecycle (e.g., `compile`, `test`, `package`)

{% hint style="success" %}
A goal can be bound to a phase **or executed directly** without a phase.
{% endhint %}

Goals can be executed -

* **Manually** using the command:

```sh
mvn compiler:compile
```

This will **execute the `compile` goal** from the `maven-compiler-plugin` without running the entire build lifecycle.

* **Bound to the Maven Build Lifecycle** (e.g., `compile`, `test`, `package`) so they execute automatically.

Maven plugins are **executed** within different phases of the **Maven Build Lifecycle**.

<table data-header-hidden><thead><tr><th width="169.859375"></th><th></th></tr></thead><tbody><tr><td><strong>Phase</strong></td><td><strong>Common Plugin Execution</strong></td></tr><tr><td>validate</td><td><code>maven-enforcer-plugin</code> (checks rules)</td></tr><tr><td>compile</td><td><code>maven-compiler-plugin</code> (compiles Java code)</td></tr><tr><td>test</td><td><code>maven-surefire-plugin</code> (runs unit tests)</td></tr><tr><td>package</td><td><code>maven-jar-plugin</code>, <code>maven-war-plugin</code> (creates JAR/WAR)</td></tr><tr><td>verify</td><td><code>maven-failsafe-plugin</code> (integration tests)</td></tr><tr><td>install</td><td><code>maven-install-plugin</code> (installs to local repository)</td></tr><tr><td>deploy</td><td><code>maven-deploy-plugin</code> (deploys artifacts)</td></tr></tbody></table>

### How to Find Goals for Any Plugin?

To see all goals of a plugin, use:

```sh
mvn help:describe -Dplugin=<plugin-name>
```

For example, to see all goals of `maven-compiler-plugin`:

```sh
mvn help:describe -Dplugin=maven-compiler-plugin -Dfull
```

## Why Do We Need Plugins?

Maven follows the **Convention over Configuration** principle, meaning most tasks (compiling, testing, packaging) follow predefined conventions. However, real-world projects often require **customization and automation**, which is where plugins come in.

#### **Some of the Reasons for Using Plugins**

* **Automate Build & Deployment Tasks** – Saves time by automating repetitive build steps.
* **Enhance Code Quality** – Plugins like Checkstyle and SpotBugs help enforce coding standards.
* **Generate Reports & Documentation** – Helps create Javadoc, project metadata, and test reports.
* **Package Applications in Different Formats** – WAR, JAR, and assembly packaging.
* **Optimize Performance** – Parallel test execution, build profiling, and performance tuning.

## Inbuilt (Default) Plugins in Maven

Maven includes some **default plugins** that are automatically used when running the build lifecycle. These plugins do **not** need to be explicitly declared in `pom.xml`.

#### **Default Plugins for Each Lifecycle Phase**

Maven automatically uses built-in plugins for different phases of the build lifecycle:

<table data-header-hidden><thead><tr><th width="202.765625"></th><th></th></tr></thead><tbody><tr><td><strong>Lifecycle Phase</strong></td><td><strong>Default Plugin &#x26; Goal</strong></td></tr><tr><td><code>validate</code></td><td><code>maven-enforcer-plugin:enforce</code></td></tr><tr><td><code>compile</code></td><td><code>maven-compiler-plugin:compile</code></td></tr><tr><td><code>test-compile</code></td><td><code>maven-compiler-plugin:testCompile</code></td></tr><tr><td><code>test</code></td><td><code>maven-surefire-plugin:test</code></td></tr><tr><td><code>package</code></td><td><code>maven-jar-plugin:jar</code>, <code>maven-war-plugin:war</code></td></tr><tr><td><code>install</code></td><td><code>maven-install-plugin:install</code></td></tr><tr><td><code>deploy</code></td><td><code>maven-deploy-plugin:deploy</code></td></tr></tbody></table>

{% hint style="info" %}
**These plugins will run automatically** even if they are **not declared** in the `pom.xml`.
{% endhint %}

## How to Declare a Plugin ?

Maven plugins are declared inside the `<plugins>` section of the **`pom.xml`** file.

**Example: Declaring a Plugin**

Below is an example of the **Maven Compiler Plugin**, which sets the Java version:

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-compiler-plugin</artifactId>
            <version>3.8.1</version>
            <configuration>
                <source>17</source>
                <target>17</target>
            </configuration>
        </plugin>
    </plugins>
</build>
```

## Common Maven Plugins & Their Goals

### **Compilation & Testing Plugins**

| Plugin                  | Goals                        | Purpose                   |
| ----------------------- | ---------------------------- | ------------------------- |
| `maven-compiler-plugin` | `compile`, `testCompile`     | Compiles Java source code |
| `maven-surefire-plugin` | `test`                       | Runs unit tests           |
| `maven-failsafe-plugin` | `integration-test`, `verify` | Runs integration tests    |

### **Packaging & Deployment Plugins**

| Plugin                 | Goals     | Purpose                                    |
| ---------------------- | --------- | ------------------------------------------ |
| `maven-jar-plugin`     | `jar`     | Packages JAR files                         |
| `maven-war-plugin`     | `war`     | Packages WAR files                         |
| `maven-install-plugin` | `install` | Installs artifacts in the local repository |
| `maven-deploy-plugin`  | `deploy`  | Deploys artifacts to a remote repository   |

### **Code Quality & Reporting Plugins**

| Plugin                    | Goals                     | Purpose                     |
| ------------------------- | ------------------------- | --------------------------- |
| `maven-checkstyle-plugin` | `check`                   | Enforces code style rules   |
| `maven-pmd-plugin`        | `pmd`, `cpd`              | Static code analysis        |
| `maven-javadoc-plugin`    | `javadoc`                 | Generates API documentation |
| `jacoco-maven-plugin`     | `prepare-agent`, `report` | Test coverage analysis      |

## Plugin Management

### About

**Plugin Management** in Maven is a way to **predefine** plugin configurations and versions in the `pom.xml`, ensuring consistency across multiple modules in a project. It allows you to declare plugins in a **centralized** manner **without immediately applying them**.

* **`<plugins>`**: Defines and **applies** a plugin immediately.
* **`<pluginManagement>`**: Declares plugin settings **but does NOT apply them automatically**. They are **only applied** if explicitly used in `<plugins>`.

### Why is Plugin Management Needed?

* Ensures **consistent versions** of plugins across all modules in a multi-module project.
* Avoids version mismatches when plugins are **implicitly used**.
* Centralizes plugin configuration, reducing duplication in child modules.
* Allows easy **customization** of plugin settings.

### How to Declare Plugin Management?

We define plugin management inside `<pluginManagement>` inside `<build>` in the parent `pom.xml`:

```xml
<project>
    <build>
        <pluginManagement>
            <plugins>
                <plugin>
                    <groupId>org.apache.maven.plugins</groupId>
                    <artifactId>maven-compiler-plugin</artifactId>
                    <version>3.8.1</version>
                    <configuration>
                        <source>17</source>
                        <target>17</target>
                    </configuration>
                </plugin>
                <plugin>
                    <groupId>org.apache.maven.plugins</groupId>
                    <artifactId>maven-surefire-plugin</artifactId>
                    <version>3.0.0-M7</version>
                </plugin>
            </plugins>
        </pluginManagement>
    </build>
</project>
```

* This does **not automatically apply** the plugins.
* To use a managed plugin in a child module, we must explicitly declare it in `<plugins>` **without specifying the version**.

### How to Use a Managed Plugin in a Child Module?

In a child module, we **do NOT need to specify the version** since it is inherited from `<pluginManagement>`:

```xml
<project>
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <configuration>
                    <source>17</source>
                    <target>17</target>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
```

Maven will automatically use **version `3.8.1`** from the **parent POM**.

### Use Cases of Plugin Management

#### **1. Multi-Module Project Plugin Version Control**

In a large enterprise project, multiple modules **should use the same plugin version** to avoid compatibility issues.

#### **2. Enforcing a Specific Compiler Version**

To prevent developers from using different Java versions for compilation.

#### **3. Centralizing Plugin Configurations**

If you need the same configurations across multiple modules (e.g., JUnit test runner in `maven-surefire-plugin`).
