# Dependency Management

## About

This category includes plugins that help manage how dependencies are resolved, downloaded, analyzed, and maintained within a Maven project. These plugins assist with inspecting the dependency tree, resolving conflicts, managing transitive dependencies, enforcing dependency constraints, and working with repositories.

These tools are especially useful for large or complex projects with many modules or dependencies, where tracking and controlling dependency versions and scopes is critical.

## Maven Dependency Plugin

The **Maven Dependency Plugin** (`maven-dependency-plugin`) is a key tool for analyzing, resolving, and manipulating project dependencies. It offers a rich set of goals to help us understand the dependencies in our project, copy them, unpack them, or list their structure.

**Common Goals**

<table data-full-width="true"><thead><tr><th width="346.1328125">Goal</th><th>Description</th></tr></thead><tbody><tr><td><code>dependency:tree</code></td><td>Shows the dependency hierarchy (useful for conflict resolution)</td></tr><tr><td><code>dependency:list</code></td><td>Lists all dependencies used in the project</td></tr><tr><td><code>dependency:copy</code></td><td>Copies specific dependencies to a folder</td></tr><tr><td><code>dependency:copy-dependencies</code></td><td>Copies all project dependencies</td></tr><tr><td><code>dependency:unpack</code></td><td>Unpacks dependency JARs into specified directories</td></tr><tr><td><code>dependency:analyze</code></td><td>Analyzes unused or undeclared dependencies</td></tr><tr><td><code>dependency:purge-local-repository</code></td><td>Removes specific artifacts from the local repository to force fresh download</td></tr></tbody></table>

**Plugin Configuration**

```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-dependency-plugin</artifactId>
  <version>3.6.0</version>
</plugin>

// Copying dependencies
<configuration>
  <outputDirectory>${project.build.directory}/libs</outputDirectory>
  <includeScope>runtime</includeScope>
</configuration>
```

**Example**

```
// List dependencies
mvn dependency:list

// Show dependency tree
mvn dependency:tree

// Analyze for unused or undeclared dependencies
mvn dependency:analyze
```

## Versions Maven Plugin

The **Versions Maven Plugin** (`versions-maven-plugin`) helps manage versions of dependencies, plugins, and even the parent POM. It is especially useful for identifying outdated dependencies and suggesting updates.

**Common Goals**

<table data-full-width="true"><thead><tr><th width="368.67578125">Goal</th><th>Description</th></tr></thead><tbody><tr><td><code>versions:display-dependency-updates</code></td><td>Lists available newer versions of dependencies</td></tr><tr><td><code>versions:use-latest-versions</code></td><td>Replaces current versions with the latest available</td></tr><tr><td><code>versions:use-next-releases</code></td><td>Updates to the next release version only (no SNAPSHOT)</td></tr><tr><td><code>versions:lock-snapshots</code></td><td>Converts all SNAPSHOT dependencies to specific versions</td></tr></tbody></table>

**Plugin Configuration**

```xml
<plugin>
  <groupId>org.codehaus.mojo</groupId>
  <artifactId>versions-maven-plugin</artifactId>
  <version>2.16.0</version>
  <configuration>
    <allowSnapshots>false</allowSnapshots>
    <generateBackupPoms>false</generateBackupPoms>
  </configuration>
</plugin>
```

**Example**

```
// Display dependency updates
mvn versions:display-dependency-updates

// Use latest versions
mvn versions:use-latest-versions
```

## Maven Install Plugin

The **Maven Install Plugin** (`maven-install-plugin`) is responsible for installing our project's artifacts (e.g., JARs, POMs) into the local Maven repository (`~/.m2/repository`) so they can be reused by other local projects.

This plugin is automatically bound to the `install` phase of the build lifecycle.

**Goal**

<table><thead><tr><th width="223.38671875">Goal</th><th>Description</th></tr></thead><tbody><tr><td><code>install:install</code></td><td>Installs the project artifact into the local repository</td></tr></tbody></table>

**Plugin Configuration**

```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-install-plugin</artifactId>
  <version>3.1.1</version>
</plugin>
```

**Example**

```bash
mvn install
```

This will:

* Compile the code
* Run tests
* Package the artifact (JAR/WAR)
* Install it to your local repository

## Maven Deploy Plugin

While more common in release workflows, the **Maven Deploy Plugin** (`maven-deploy-plugin`) is closely related to dependency management because it handles publishing artifacts to a remote repository, making them available as dependencies in other projects.

It works with remote repositories like Nexus or Artifactory.

**Goal**

<table><thead><tr><th width="278.90625">Goal</th><th>Description</th></tr></thead><tbody><tr><td><code>deploy:deploy</code></td><td>Uploads project artifacts to a remote repository</td></tr></tbody></table>

**Plugin Configuration**

```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-deploy-plugin</artifactId>
  <version>3.1.1</version>
</plugin>
```

**Example**

```bash
mvn deploy
```

We must configure `distributionManagement` in `pom.xml` and authentication credentials in `settings.xml`.

