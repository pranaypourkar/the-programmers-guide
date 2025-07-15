---
description: An overview of the options available while executing maven commands.
---

# Command-line Options

## **About**

Maven supports a variety of command-line options that can be used to customize build behavior. These options help in skipping tests, debugging builds, activating profiles, selecting specific modules, and more.

Below is a categorized reference of commonly used options.

## 1. Test Control Options

These options control the **execution of tests**, including skipping, targeting specific types, and configuration.

### Skip Tests Execution

#### `-DskipTests`

Skips the **execution** of tests, but **still compiles** them.

```bash
mvn clean install -DskipTests
```

Use when:

* We want to package or install without running tests.
* We still want test class compilation (e.g., for tools relying on them).

#### `-Dmaven.test.skip=true`

Skips **both compilation and execution** of tests.

```bash
mvn clean install -Dmaven.test.skip=true
```

Use when:

* We want a completely test-free build (faster).
* Tests are irrelevant for a particular environment or deployment.

#### `-DskipITs` or `-DskipFailsafeTests`

Skips only **integration tests** (run using the Failsafe plugin).

```bash
mvn clean install -DskipFailsafeTests
```

Use when:

* We want to run only unit tests and exclude long-running integration tests.

### Executing a Specific Test Class

We can run a specific test class using the `-Dtest` option.

```bash
mvn test -Dtest=UserServiceTest
```

Use when:

* We’re working on a specific class and want fast feedback.

### Executing a Specific Test Method in a Class

To run a **specific test method**, use `ClassName#methodName` format:

```bash
mvn test -Dtest=UserServiceTest#shouldReturnUserById
```

Use when:

* Debugging or rerunning a single failing test case.
* Focusing on targeted behavior during development.

### Executing Multiple Test Classes

We can specify multiple test classes using comma-separated values:

```bash
mvn test -Dtest=UserServiceTest,OrderServiceTest
```

Wildcard support is also available:

```bash
mvn test -Dtest=User*Test
```

## 2. Profile Settings

### Activate Profiles (`-P`)

Activates one or more Maven **build profiles** defined in `pom.xml` or `settings.xml`.

```bash
mvn clean install -Pproduction
```

Use when:

* Switching between environments (dev, staging, prod).
* Activating custom dependency sets or plugin settings.

## 3. Configuration Activation

### Define System or Project Properties (`-D` )

Passes key-value pairs as **system properties** or project properties.

```bash
mvn clean install -Denv=staging
```

Use when:

* Passing environment-specific values.
* Activating conditional logic inside `pom.xml` or plugins.

## 4. Debugging Build Issue

### Debug Output (`-X` )

Enables **verbose output** for debugging build problems.

```bash
mvn clean install -X
```

Use when:

* Builds fail unexpectedly.
* We want insight into dependency resolution, plugin goals, or internal state.

### Show Full Stack Traces (`-e` )

Displays detailed stack traces for build errors.

```bash
mvn clean install -e
```

Use when:

* Understanding failure causes or reporting bugs.
* Debugging plugin misbehavior.

## 5. Module and Project Selection (Multi-module Projects)

### Build Selected Modules (`-pl` )

Builds only the selected **modules** in a multi-module Maven project.

```bash
mvn clean install -pl module-a,module-b
```

Use when:

* You want to rebuild or test specific modules only.
* Avoiding full rebuild of all modules.

### **Build required Upstream Modules** Dependencies (`-am` )

Automatically builds any **required upstream modules** of the modules listed in `-pl`.

```bash
mvn install -pl module-b -am
```

Use when:

* The selected module depends on others that haven’t been built.

### Prevent building child modules (`-N` or `--non-recursive` )

Prevents Maven from building child modules in a multi-module project.

```bash
mvn install -N
```

Use when:

* We only want to build or install the root project.
* Speeding up builds during early testing.

## 6. Project Structure and Location

### Use Alternate POM File (`-f` )

Specifies an alternate location or name for the `pom.xml`.

```bash
mvn clean install -f /path/to/alternate/pom.xml
```

Use when:

* We are in a different directory.
* We `pom.xml` has a non-standard name.



## **7. Chaining Phases**

Multiple phases can be chained using spaces in a single command. This executes each phase sequentially.

`mvn clean compile test package verify install`

{% hint style="info" %}
In Maven, when resolving dependencies, the order in which repositories are checked depends on the order they are defined in the `pom.xml` file. By default the sequence is:

1. **Local Repository**: Maven first looks into the local repository, which is usually located in the home directory (`~/.m2/repository` on Unix-like systems, or `%USERPROFILE%\.m2\repository` on Windows). If the required dependencies are found there, Maven uses them directly without further processing.
2. **Remote Repositories**: If the dependencies are not found in the local repository, Maven checks any remote repositories configured in the `pom.xml` file. These remote repositories could be the organization's internal repositories or other external repositories besides Maven Central. Maven checks them in the order they are defined in the `pom.xml`.
3. **Maven Central**: If the dependencies are not found in any of the configured repositories, Maven then checks Maven Central, which is the default central repository for open-source Java libraries.
{% endhint %}

## 8. Download Dependency

In Maven, we can **pull (download) a dependency from a repository using the command line** without adding it to a `pom.xml` by using the `dependency:get` goal provided by the `maven-dependency-plugin`.

#### Syntax

{% code overflow="wrap" %}
```bash
mvn dependency:get -DgroupId=<group-id> -DartifactId=<artifact-id> -Dversion=<version> [-Dclassifier=<classifier>] [-Dpackaging=<packaging>]
```
{% endcode %}

#### Download a standard JAR

{% code overflow="wrap" %}
```bash
mvn dependency:get -DgroupId=org.apache.commons -DartifactId=commons-lang3 -Dversion=3.12.0
```
{% endcode %}

This will download the `commons-lang3-3.12.0.jar` to your local Maven repository (`~/.m2/repository`).

#### Download a JAR with a specific packaging

```bash
mvn dependency:get -DgroupId=org.springframework.boot -DartifactId=spring-boot-starter-web -Dversion=2.7.6 -Dpackaging=jar
```

> Packaging defaults to `jar` if not specified.

#### Download a JAR with a classifier (e.g., `sources`)

```bash
mvn dependency:get -DgroupId=org.apache.commons -DartifactId=commons-lang3 -Dversion=3.12.0 -Dclassifier=sources
```

This downloads `commons-lang3-3.12.0-sources.jar`.

