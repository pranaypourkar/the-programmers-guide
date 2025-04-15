# Code Quality and Analysis

## About

The **Code Quality and Analysis** category includes Maven plugins that help enforce coding standards, detect bugs, identify code smells, and ensure maintainability of our codebase. These tools are vital for ensuring that our code is readable, robust, secure, and maintainable over time—especially in team environments or enterprise-grade applications.

They typically analyze the source code either statically (without execution) or by inspecting bytecode and offer detailed reports or fail builds based on rule violations.

## Maven Checkstyle Plugin

The **Checkstyle Plugin** integrates Checkstyle into the Maven build. It checks Java code against a defined coding standard or style guide (e.g., Google Java Style, Sun's Java conventions).

**Common Goals**

<table><thead><tr><th width="232.58203125">Goal</th><th>Description</th></tr></thead><tbody><tr><td><code>checkstyle:check</code></td><td>Runs Checkstyle and fails the build on rule violations</td></tr><tr><td><code>checkstyle:checkstyle</code></td><td>Generates a Checkstyle report in the <code>target/site</code> directory</td></tr></tbody></table>

**Basic Configuration**

```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-checkstyle-plugin</artifactId>
  <version>3.3.0</version>
  <configuration>
    <configLocation>google_checks.xml</configLocation>
    <encoding>UTF-8</encoding>
    <consoleOutput>true</consoleOutput>
    <failsOnError>true</failsOnError>
  </configuration>
</plugin>
```

We can use custom or predefined configuration files (e.g., `google_checks.xml`, `sun_checks.xml`).

## PMD Maven Plugin

The **PMD Plugin** integrates PMD into Maven. It scans Java source code to identify potential bugs, dead code, suboptimal code, and overcomplicated expressions.

**Common Goals**

<table><thead><tr><th width="220.625">Goal</th><th>Description</th></tr></thead><tbody><tr><td><code>pmd:check</code></td><td>Runs analysis and fails the build if violations are found</td></tr><tr><td><code>pmd:pmd</code></td><td>Generates a PMD report (<code>target/site</code>)</td></tr><tr><td><code>pmd:cpd</code></td><td>Detects duplicate code (Copy-Paste Detector)</td></tr></tbody></table>

**Basic Configuration**

```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-pmd-plugin</artifactId>
  <version>3.21.0</version>
  <configuration>
    <targetJdk>17</targetJdk>
    <printFailingErrors>true</printFailingErrors>
    <failOnViolation>true</failOnViolation>
  </configuration>
</plugin>
```

PMD uses rule sets like `java-basic`, `java-braces`, or we can define your own.

## SpotBugs Maven Plugin

**SpotBugs** (successor of FindBugs) is a static analysis tool that identifies potential bugs in Java bytecode. The **SpotBugs Maven Plugin** enables its use as part of your Maven build process.

**Common Goals**

<table><thead><tr><th width="197.58984375">Goal</th><th>Description</th></tr></thead><tbody><tr><td><code>spotbugs:check</code></td><td>Runs SpotBugs analysis and fails the build on violations</td></tr><tr><td><code>spotbugs:spotbugs</code></td><td>Generates XML/HTML reports in <code>target/site</code></td></tr></tbody></table>

**Basic Configuration**

```xml
<plugin>
  <groupId>com.github.spotbugs</groupId>
  <artifactId>spotbugs-maven-plugin</artifactId>
  <version>4.7.3.0</version>
  <configuration>
    <effort>Max</effort>
    <threshold>Low</threshold>
    <failOnError>true</failOnError>
  </configuration>
</plugin>
```

We can configure custom bug filters using an XML file and control report formats.

## OWASP Dependency-Check Maven Plugin

The **OWASP Dependency-Check Plugin** scans our project for known vulnerable dependencies by referencing the [National Vulnerability Database (NVD)](https://nvd.nist.gov/).

**Common Goals**

<table><thead><tr><th width="234.6484375">Goal</th><th>Description</th></tr></thead><tbody><tr><td><code>dependency-check:check</code></td><td>Scans for vulnerable dependencies and fails the build if found</td></tr></tbody></table>

#### **Basic Configuration**

```xml
<plugin>
  <groupId>org.owasp</groupId>
  <artifactId>dependency-check-maven</artifactId>
  <version>8.4.0</version>
  <executions>
    <execution>
      <goals>
        <goal>check</goal>
      </goals>
    </execution>
  </executions>
</plugin>
```

**Report Outputs**

Generates HTML, XML, and JSON reports under `target/dependency-check-report`.

## Enforcer Maven Plugin

The **Maven Enforcer Plugin** helps enforce rules on the build environment, dependency versions, or plugin versions to ensure consistency across a development team.

#### **Common Rules**

| Rule                    | Purpose                                       |
| ----------------------- | --------------------------------------------- |
| `requireMavenVersion`   | Ensure a minimum Maven version                |
| `requireJavaVersion`    | Require a specific Java version               |
| `banDuplicateClasses`   | Fail the build if duplicate classes are found |
| `requireUpperBoundDeps` | Detect conflicting dependency versions        |

#### **Basic Configuration:**

```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-enforcer-plugin</artifactId>
  <version>3.3.0</version>
  <executions>
    <execution>
      <id>enforce-rules</id>
      <goals>
        <goal>enforce</goal>
      </goals>
      <configuration>
        <rules>
          <requireMavenVersion>
            <version>[3.8,)</version>
          </requireMavenVersion>
          <requireJavaVersion>
            <version>[17,)</version>
          </requireJavaVersion>
        </rules>
      </configuration>
    </execution>
  </executions>
</plugin>
```

