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

## Features

1. **Build Automation**: Maven automates the process of compiling code, packaging binaries, running tests, generating documentation, and deploying artifacts.
2. **Dependency Management**: Maven manages project dependencies through a central repository, reducing the need for manual management.
3. **Project Structure**: Enforces a standard directory layout for projects, which helps maintain consistency across multiple projects.
4. **Plugin Architecture**: Maven uses plugins to perform tasks during the build process. Plugins can handle tasks like compiling code, running tests, and creating JAR files.
5. **Lifecycle Management**: Maven defines a set of lifecycle phases (e.g., `validate`, `compile`, `test`, `package`, `install`, `deploy`) that dictate the order in which build tasks are executed.

## **Benefits of using Maven:**

* **Standardization:** Enforces a consistent build process across projects, improving maintainability and collaboration within a team.
* **Reduced Complexity:** Handles dependency management, eliminating the need to manually track down and download libraries.
* **Improved Efficiency:** Automates repetitive tasks, saving developers time and effort.
* **Reproducible Builds:** Ensures that the build process is consistent across different environments, leading to reliable builds.

## Core Concepts

* **POM (Project Object Model)**: The `pom.xml` file is the heart of a Maven project. It contains information about the project and configuration details used by Maven to build the project.\
  We can use different name for POM.xml but we need to use option `-f.` \
  For example,  `mvn -f parent-pom.xml`

{% hint style="info" %}
When we create a Maven project, our project's `pom.xml` implicitly inherits from the Super POM unless we explicitly specify a different parent.
{% endhint %}

* **Dependencies**: Libraries or other projects that a project relies on. These are declared in the `pom.xml` file and Maven handles downloading and managing them.
* **Repositories**: Locations where Maven stores and retrieves project dependencies and plugins. There are local, central, and remote repositories.
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

## Configuration

* **Settings File**: `settings.xml` is used to configure Maven execution environment, such as repository locations and authentication information.
  * Global Settings: Located in `${MAVEN_HOME}/conf/settings.xml`.
  * User Settings: Located in `${user.home}/.m2/settings.xml`.

## Plugins

Maven uses plugins to extend its functionality. For example,

* **Compiler Plugin**: Compiles Java source files.
* **Surefire Plugin**: Runs unit tests.
* **Jar Plugin**: Creates JAR files from the compiled code.
* **Assembly Plugin**: Creates distributions from your project.

## Profiles

Maven profiles allow customization of the build process for different environments or use cases:

* Defined in `pom.xml` or `profiles.xml`.
* Can activate profiles based on conditions such as system properties, OS, or custom activators.

## Dependency Management

* Maven coordinates dependency versions using the `dependencyManagement` section in the `pom.xml`.
* **Transitive Dependencies**: Automatically includes dependencies required by your project's dependencies.
* **Scopes**: Define the classpath for different build tasks (e.g., `compile`, `test`, `provided`, `runtime`, `system`).

## Best Practices

1. **Version Control**: Always use specific versions for dependencies to ensure build reproducibility.
2. **Modularization**: Break down large projects into smaller, manageable modules.
3. **Dependency Management**: Use dependency management to centralize version information and reduce redundancy.
4. **Consistent Builds**: Use a continuous integration (CI) server to automate builds and tests.

