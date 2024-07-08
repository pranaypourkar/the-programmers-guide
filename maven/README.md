# Maven

## About

Maven is an open-source project management tool specifically designed to simplify and standardize the build process, especially for Java projects. It goes beyond just build automation and offers features like dependency management and documentation generation.

It provides the developer a complete build lifecycle framework. On executing Maven commands, it will look for POM file in Maven and will run the command on the resources described in the POM.

* **Purpose**: Maven simplifies the build process, manages dependencies, and provides project management features.
* **Developed By**: The Apache Software Foundation.
* **Latest Version**: [Check the official Apache Maven website for the latest version](https://maven.apache.org/).

{% hint style="info" %}
While primarily used for Java projects, Maven can also be employed for building projects in other languages with the help of plugins.
{% endhint %}

## List of various aspect that maven manages

### 1. **Build Management**

* **Compilation**: Compiles the source code of the project.
* **Packaging**: Packages the compiled code into distributable formats such as JAR, WAR, etc.
* **Assembly**: Combines multiple artifacts, source files, and other resources into a single archive.

### 2. **Dependency Management**

* **Transitive Dependencies**: Automatically resolves and includes dependencies of dependencies.
* **Dependency Scope**: Manages different scopes such as `compile`, `provided`, `runtime`, `test`, and `system`.
* **Dependency Versions**: Manages versions of dependencies to ensure compatibility and resolve conflicts.

### 3. **Project Management**

* **Project Structure**: Defines a standard directory layout for projects.
* **Project Documentation**: Generates project documentation including reports on code quality, dependencies, etc.
* **Project Metadata**: Manages metadata such as project name, version, description, licenses, and organization information.

### 4. **Lifecycle Management**

* **Default Lifecycle**: Manages the standard phases of a project build (validate, compile, test, package, verify, install, deploy).
* **Clean Lifecycle**: Manages the cleanup of project artifacts generated during previous builds.
* **Site Lifecycle**: Manages the creation of a project's site documentation.

### 5. **Plugin Management**

* **Build Plugins**: Extends Maven’s capabilities by integrating with various build tools and processes (e.g., Surefire for testing, Compiler for compilation).
* **Reporting Plugins**: Generates reports on various aspects of the project (e.g., Javadoc, Checkstyle, PMD).
* **Custom Plugins**: Supports custom plugins for specific build requirements and workflows.

### 6. **Repository Management**

* **Local Repository**: Stores dependencies and plugins locally.
* **Central Repository**: Uses Maven Central Repository for resolving dependencies.
* **Remote Repositories**: Configures additional remote repositories for dependency resolution.
* **Snapshot and Release Repositories**: Manages different repositories for snapshot and release versions of artifacts.

### 7. **Configuration Management**

* **Properties**: Defines and manages properties for use within the POM and plugins.
* **Profiles**: Manages different configurations and builds for different environments or use cases.
* **Settings**: Manages user-specific and global configurations in `settings.xml`.

### 8. **Project Inheritance and Aggregation**

* **Parent POM**: Uses parent POMs for sharing configurations across multiple projects.
* **Multi-module Projects**: Manages multiple related projects within a single build.

### 9. **Version Management**

* **Release Management**: Manages the process of releasing project versions.
* **Versioning Schemes**: Manages versioning schemes including snapshots and stable releases.
* **Dependency Versions**: Manages and resolves versions of dependencies.

### 10. **Continuous Integration**

* **Integration with CI Tools**: Integrates with Continuous Integration tools like Jenkins, Bamboo, etc., for automated builds and tests.

### 11. **Site Generation**

* **Project Site**: Generates a project website including documentation, reports, and project information.
* **Reports**: Includes various reports such as unit test results, code coverage, code quality metrics, etc.

### 12. **Artifact Management**

* **Artifact Deployment**: Deploys artifacts to remote repositories.
* **Artifact Distribution**: Distributes artifacts via repositories for use by other projects.

### 13. **Testing Management**

* **Unit Testing**: Manages and runs unit tests.
* **Integration Testing**: Supports integration testing phases.
* **Test Reports**: Generates and manages test reports.

### 14. **Resource Management**

* **Resource Filtering**: Filters resources for environment-specific configurations.
* **Resource Copying**: Copies resources to the output directory during the build process.

### 15. **Extensions and Customization**

* **Maven Extensions**: Supports extensions to modify the build lifecycle.
* **Custom Lifecycle**: Defines custom lifecycles and phases.

## **Benefits of using Maven:**

* **Standardization:** Enforces a consistent build process across projects, improving maintainability and collaboration within a team.
* **Reduced Complexity:** Handles dependency management, eliminating the need to manually track down and download libraries.
* **Improved Efficiency:** Automates repetitive tasks, saving developers time and effort.
* **Reproducible Builds:** Ensures that the build process is consistent across different environments, leading to reliable builds.

## Core Concepts

### **POM (Project Object Model)**

The `pom.xml` file is the heart of a Maven project. It contains information about the project and configuration details used by Maven to build the project.\
We can use different name for POM.xml but we need to use option `-f.` \
For example,  `mvn -f parent-pom.xml`

{% hint style="info" %}
When we create a Maven project, our project's `pom.xml` implicitly inherits from the Super POM unless we explicitly specify a different parent.
{% endhint %}

### **Dependencies**&#x20;

Libraries or other projects that a project relies on. These are declared in the `pom.xml` file and Maven handles downloading and managing them.

### Dependency Management

* Maven coordinates dependency versions using the `dependencyManagement` section in the `pom.xml`.
* **Transitive Dependencies**: Automatically includes dependencies required by our project's dependencies.
* **Scopes**: Define the classpath for different build tasks (e.g., `compile`, `test`, `provided`, `runtime`, `system`).

### Configuration

* **Settings File**: `settings.xml` is used to configure Maven execution environment, such as repository locations and authentication information.
  * Global Settings: Located in `${MAVEN_HOME}/conf/settings.xml`.
  * User Settings: Located in `${user.home}/.m2/settings.xml`.

### **Repositories**

Locations where Maven stores and retrieves project dependencies and plugins. There are local, central, and remote repositories.

* **Local Repository**: Contains all the dependencies that have been downloaded and cached for reuse in future builds.\
  Default location: `${user.home}/.m2/repository`.
*   **Central Repository**: The default repository provided by Maven. Maven provides most of the generic dependency resources at this remote location.&#x20;

    Default central repository URL: `https://repo.maven.apache.org/maven2`.

    Maven checks this repository if dependencies are not found in the local or remote repositories.
* **Remote Repositories**: Additional repositories that can be specified in the `pom.xm` under the `<repositories>` section. Can also be defined in the `settings.xml` file under the `<profiles>` section.

```xml
<!-- Example configuration in pom.xml -->

<repositories>
  <repository>
    <id>my-repo</id>
    <url>http://my.company.com/maven2</url>
  </repository>
</repositories>
```

{% hint style="info" %}
Maven retrieves dependencies in a specific sequence, checking various repositories to resolve and download the required artifacts. Here's the sequence in which Maven tries to retrieve dependencies:

1. **Local Repository**
2. **Remote Repositories**
3. **Central Repository**

#### Sequence of Dependency Retrieval

1. **Local Repository**:
   * Maven first checks the local repository, which is a cache on the developer's machine. The default location is `${user.home}/.m2/repository`.
   * If the dependency is found in the local repository, it is used directly.
2. **Remote Repositories**:
   * If the dependency is not found in the local repository, Maven checks remote repositories defined in the `pom.xml` file or in the `settings.xml` file.
   * These repositories can be internal corporate repositories, third-party repositories, or any other repositories configured in the project.
3. **Central Repository**:
   * If the dependency is not found in either the local or remote repositories, Maven finally checks the central repository.
   * The default central repository is `https://repo.maven.apache.org/maven2`.
{% endhint %}

### Plugins

Maven uses plugins to extend its functionality. A Maven plugin is a group of goals. However, these goals aren’t necessarily all bound to the same phase. &#x20;

Some of the Maven Plugins are:

* **Compiler Plugin**: Compiles Java source files.
* **Surefire Plugin**: Runs unit tests.
* **Jar Plugin**: Creates JAR files from the compiled code.
* **Assembly Plugin**: Creates distributions from your project.

Maven plugins are used to:

* create jar file
* create war file
* compile code files
* unit testing of code
* create project documentation
* create project reports etc.

Maven provides following two types of Plugins

* **Build plugins −** They execute during the build and should be configured in the \<build/> element of pom.xml
* **Reporting plugins −** They execute during the site generation and they should be configured in the \<reporting/> element of the pom.xml

### Profiles

Maven profiles allow customization of the build process for different environments or use cases:

* Defined in `pom.xml` or `profiles.xml`.
* Can activate profiles based on conditions such as system properties, OS, or custom activators.

## Project Structure

Maven projects follow a standard directory layout:

* `src/main/java`: Application/Library source code.
* `src/main/resources`: Application/Library resources.
* `src/test/java`: Test source code.
* `src/test/resources`: Test resources.
* `target`: Compiled code and other build outputs.

## Basic Commands

* `mvn clean`: Cleans the project by deleting the `target` directory.
* `mvn compile`: Compiles the source code.
* `mvn test`: Runs the tests.
* `mvn package`: Packages the compiled code into a distributable format (e.g., JAR, WAR).
* `mvn install`: Installs the package into the local repository.
* `mvn deploy`: Deploys the package to a remote repository.

## Best Practices

1. **Version Control**: Always use specific versions for dependencies to ensure build reproducibility.
2. **Modularization**: Break down large projects into smaller, manageable modules.
3. **Dependency Management**: Use dependency management to centralize version information and reduce redundancy.
4. **Consistent Builds**: Use a continuous integration (CI) server to automate builds and tests.

