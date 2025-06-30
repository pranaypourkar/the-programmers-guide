# Artifact Coordinates

## About

Artifact coordinates in Maven uniquely identify a project artifact (such as a JAR, WAR, or POM) within a repository. These coordinates are used during build, dependency resolution, and artifact deployment.

Every Maven artifact is defined by a combination of the following:

```
<groupId>:<artifactId>:<version>[:<packaging>][:<classifier>]
```

## 1. groupId

Defines the namespace or organization to which the artifact belongs. It is meant to **avoid conflicts between artifacts from different teams or vendors**.

* Usually follows a **reverse domain name** convention: `com.company.project`
* Can include subgroups: `org.springframework.boot`, `io.quarkus.resteasy`
* Group IDs are hierarchical and are used to scope the artifact within a structured space in Maven Central or internal Nexus/Artifactory repositories.

For a Spring Boot artifact:

```xml
<groupId>org.springframework.boot</groupId>
```

This identifies that the artifact is maintained by the Spring Boot team.

Organizations often use:

* `com.mycompany.internal.module`
* `org.company.shared.utils`\
  to separate internal reusable libraries from customer-facing modules.

## 2. artifactId

The **name of the artifact** (library, module, or application). It should be unique **within a groupId**.

* The artifactId determines the name of the output file (like `artifactId-version.jar`)
* Often reflects the Maven module or submodule name

For a library providing JSON parsing:

```xml
<artifactId>json-parser</artifactId>
```

If we have multiple related libraries:

```xml
<artifactId>json-parser-core</artifactId>
<artifactId>json-parser-extensions</artifactId>
```

Within a single company or microservices project:

* `user-api`, `user-service`, `user-db-model`
* Artifact names are often aligned with domain boundaries.

## 3. version

Defines the **specific version of the artifact**. Maven retrieves and caches artifacts based on version.

* Follows semantic versioning (`MAJOR.MINOR.PATCH`) but not enforced.
* Can be SNAPSHOT for in-development versions (e.g., `1.0.0-SNAPSHOT`)
* Maven uses the version to determine if it needs to download or reuse a local copy.

**Special Behavior:**

* **`1.0-SNAPSHOT`**: Treated as mutable; Maven may check for updates on every build.
* **`1.0.0`**: Treated as immutable and cached locally after download.

Teams publish internal builds to private repositories as:

* `1.2.0-alpha`
* `2.5.1-RC1`
* `3.0.0-SNAPSHOT`

Versioning is critical for:

* Dependency management
* Rollbacks
* Reproducible builds

## 4. packaging

Defines the **type of artifact to be generated**. Determines what Maven builds and how.

**Common Values:**

* `jar` (default)
* `war` (web application)
* `pom` (for aggregator/parent modules)
* `ear` (enterprise application)



* Influences which plugins are invoked (e.g., `maven-jar-plugin` for `jar`, `maven-war-plugin` for `war`)
* Can be extended by custom plugin-defined types
* A multi-module project might use:
  * `pom` for parent
  * `jar` for library modules
  * `war` for deployable services

Example:

```xml
<packaging>war</packaging>
```

## 5. classifier

An optional label to **distinguish artifacts built from the same POM** but with different content.

**Use Cases:**

* Source JARs (`classifier=sources`)
* Javadoc JARs (`classifier=javadoc`)
* Platform-specific builds (`classifier=linux-x86_64`)
* Test JARs (`classifier=tests`)



* The classifier does **not** change the functionality of the artifact but its **identity** and **purpose**.
* Classifier must be used carefully to avoid dependency resolution conflicts.
* When attaching multiple artifacts (e.g., using the `maven-attach-plugin`), the classifier helps segregate them.

```xml
<classifier>sources</classifier>  → Provides readable source code
<classifier>javadoc</classifier>  → Provides documentation for IDEs
<classifier>native</classifier>   → Provides OS-specific binaries
<classifier>api</classifier>   → Provides Open API Spec files
```

For example, the following artifacts are all from the same module but serve different roles:

* `my-lib-1.0.jar`
* `my-lib-1.0-sources.jar`
* `my-lib-1.0-javadoc.jar`&#x20;

## Comparison

<table data-full-width="true"><thead><tr><th width="167.53558349609375">Element</th><th>Purpose</th><th>Real-World Analogy</th></tr></thead><tbody><tr><td><code>groupId</code></td><td>Logical organization</td><td>Like a company or team namespace</td></tr><tr><td><code>artifactId</code></td><td>Specific module or project</td><td>Like a product or component name</td></tr><tr><td><code>version</code></td><td>Which release or revision</td><td>Like a software version (v1.2.0)</td></tr><tr><td><code>packaging</code></td><td>What kind of file to build</td><td>Like a file type (.jar, .war)</td></tr><tr><td><code>classifier</code></td><td>Optional tag for purpose or variant</td><td>Like a label (source, javadoc, native)</td></tr></tbody></table>

## Full Coordinate Example

```xml
<dependency>
    <groupId>com.example</groupId>
    <artifactId>my-library</artifactId>
    <version>1.0.0</version>
    <packaging>jar</packaging>
    <classifier>sources</classifier>
</dependency>
```
