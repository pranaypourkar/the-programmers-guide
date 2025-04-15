---
description: >-
  Plugins for integrating with testing frameworks, running integration tests,
  and managing test resources.
---

# Integration and Testing

## About

The **Integration and Testing** category covers Maven plugins that help in:

* Running **unit tests** and **integration tests**
* Managing **test resources and environments**
* Integrating with **testing frameworks** (e.g., JUnit, TestNG, Cucumber)
* Generating **test execution reports**
* Ensuring **phased test execution** (unit tests vs integration tests)
* Supporting **end-to-end test automation** in CI/CD pipelines

These plugins ensure our application is thoroughly tested at various levels before packaging or deployment.

#### **Need for Integration and Testing Plugins**

* Automatically run tests during Maven phases (`test`, `verify`)
* Control **test scope** (unit vs integration)
* Generate **detailed reports** of test outcomes
* Manage **test dependencies and resources**
* Integrate with external tools like **Cucumber**, **Arquillian**, **Selenium**, or **Dockerized test setups**

## **maven-surefire-plugin**

Handles execution of **unit tests** (typically fast, in-memory tests). Bound to the `test` phase of the lifecycle.

**Syntax**

```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-surefire-plugin</artifactId>
  <version>3.2.5</version>
</plugin>
```

#### **Key Configurations**

<table><thead><tr><th width="311.64453125">Configuration</th><th>Purpose</th></tr></thead><tbody><tr><td><code>includes</code>, <code>excludes</code></td><td>Control which test classes to include or exclude</td></tr><tr><td><code>test</code></td><td>Run specific test class</td></tr><tr><td><code>forkCount</code>, <code>reuseForks</code></td><td>Parallel and fork control</td></tr><tr><td><code>systemPropertyVariables</code></td><td>Set system properties</td></tr></tbody></table>

#### **Usage**

```bash
mvn test
```

> Automatically picks up `Test*.java` or `*Test.java`.

## **maven-failsafe-plugin**

Used for **integration tests**, designed to run after the application has been built. Bound to the `integration-test` and `verify` phases.

**Syntax**

```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-failsafe-plugin</artifactId>
  <version>3.2.5</version>
  <executions>
    <execution>
      <id>integration-tests</id>
      <goals>
        <goal>integration-test</goal>
        <goal>verify</goal>
      </goals>
    </execution>
  </executions>
</plugin>
```

**File Naming Convention**

Failsafe runs tests named like:

* `*IT.java` (IT = Integration Test)
* `*ITCase.java`

**Command**

```bash
mvn verify
```

## **maven-resources-plugin**

Copies and filters test-specific resources (like config files, test data) to `target/test-classes`.

**Syntax**

```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-resources-plugin</artifactId>
  <version>3.3.1</version>
</plugin>
```

**Use Cases**

* Load `.properties`, `.yml`, or `.json` for tests
* Filter placeholders using Maven properties

## **cucumber-maven-plugin**

Integrates [Cucumber](https://cucumber.io) for **Behavior Driven Development (BDD)** with Maven. Allows us to run `.feature` files and glue them with Java step definitions.

**Syntax Example**

```xml
<plugin>
  <groupId>io.cucumber</groupId>
  <artifactId>cucumber-maven-plugin</artifactId>
  <version>7.11.0</version>
  <executions>
    <execution>
      <id>run-cukes</id>
      <phase>verify</phase>
      <goals>
        <goal>test</goal>
      </goals>
    </execution>
  </executions>
</plugin>
```

> Requires Cucumber JUnit/TestNG runner and feature files in `src/test/resources`.

## **docker-maven-plugin / fabric8-maven-plugin**&#x20;

Used to spin up Docker containers (e.g., DB, Redis, MQ) during integration tests.

**Use Cases**

* Test services against real DBs (e.g., PostgreSQL) using Docker
* Spin up microservices before integration tests

> These are **not part of Maven core** but useful in microservice or system integration testing.

