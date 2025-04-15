# Reporting

## **About**

The **Reporting** category in Maven involves plugins that generate various types of reports during the build process. These reports can include:

* **Test coverage**
* **Code metrics**
* **Static code analysis**
* **Dependency and plugin usage**
* **Project documentation summaries**

These reports are useful for both developers and project stakeholders to assess code quality, test effectiveness, compliance, and maintainability.

**Need for Reporting Plugins**

* Provide **insight into codebase health** (quality, complexity, bugs)
* Enable **auditable documentation** of project state
* Track **test performance, coverage, and errors**
* Automatically **document dependencies and plugin usage**
* Enhance **transparency** and **maintainability** across teams

## **maven-project-info-reports-plugin**

Generates standard project documentation including dependencies, plugins, team info, SCM, licenses, and more.

**Common Reports**

<table><thead><tr><th width="239.9140625">Report</th><th>Description</th></tr></thead><tbody><tr><td><code>dependencies</code></td><td>Shows all project dependencies</td></tr><tr><td><code>dependency-management</code></td><td>Shows dependencies managed via dependencyManagement</td></tr><tr><td><code>plugins</code></td><td>Lists build plugins</td></tr><tr><td><code>licenses</code></td><td>Details licenses used in the project</td></tr><tr><td><code>scm</code></td><td>Shows source code management info (like Git)</td></tr><tr><td><code>summary</code></td><td>High-level project info summary</td></tr></tbody></table>

**Syntax**

```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-project-info-reports-plugin</artifactId>
  <version>3.4.5</version>
</plugin>
```

**Usage**

Runs with `mvn site`, or we can run individual goals like:

```bash
mvn project-info-reports:dependencies
```

## **maven-surefire-report-plugin**

Generates HTML reports from test results produced by the Surefire plugin. Useful for viewing pass/fail details, error messages, and test case summaries.

**Syntax**

```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-surefire-report-plugin</artifactId>
  <version>3.2.5</version>
</plugin>
```

**Common Config Options**

| Property      | Purpose                                  |
| ------------- | ---------------------------------------- |
| `aggregate`   | Combine reports for multimodule projects |
| `showSuccess` | Show passed tests                        |
| `outputName`  | Set custom name for report file          |

**Usage**

```bash
mvn surefire-report:report
```

This typically outputs `surefire-report.html` under `target/site`.

## **jacoco-maven-plugin**

Generates **code coverage reports** for our tests. Helps us analyze which parts of the code are covered and which are not.

**Syntax**

```xml
<plugin>
  <groupId>org.jacoco</groupId>
  <artifactId>jacoco-maven-plugin</artifactId>
  <version>0.8.10</version>
  <executions>
    <execution>
      <id>prepare-agent</id>
      <goals><goal>prepare-agent</goal></goals>
    </execution>
    <execution>
      <id>report</id>
      <phase>verify</phase>
      <goals><goal>report</goal></goals>
    </execution>
  </executions>
</plugin>
```

#### **Report Types**

* HTML
* XML
* CSV

#### **Output**

Reports go into `target/site/jacoco/index.html`&#x20;

## **sonar-maven-plugin (SonarQube)**

Integrates with **SonarQube**, a powerful code quality platform that analyzes:

* Code smells
* Bugs
* Security vulnerabilities
* Code coverage
* Duplications

**Syntax**

```xml
<plugin>
  <groupId>org.sonarsource.scanner.maven</groupId>
  <artifactId>sonar-maven-plugin</artifactId>
  <version>3.9.1.2184</version>
</plugin>
```

**Usage**

Run with

```bash
mvn sonar:sonar \
  -Dsonar.projectKey=example \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=token
```

> Requires a running SonarQube server and a configured token.

## **maven-site-plugin**

This is the core plugin for generating a complete Maven **site** that includes all reporting, documentation, and static HTML pages for our project.

**Syntax**

```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-site-plugin</artifactId>
  <version>4.0.0-M9</version>
</plugin>
```

**Command to Generate Site**

```bash
mvn site
```

It will include reports from all reporting plugins into the `target/site/` directory in a browsable form.
