---
description: Frequently Asked Question on Maven
---

# FAQs

## How do we rename a maven project?

1\) Rename the project using Eclipse or other IDE.

2\) Update the artifactId in our pom.xml

## Can we use different name for POM.xml?

Yes. We could mention file name using the -f option.

**mvn -f** parent-pom.xml

## What are the minimum requirements for a POM?

At a bare minimum, the POM must include the following elements:

1. **Project Root:** The root element of the POM file
2. **Model Version (`modelVersion`)**: Specifies the model version for the POM. The current model version is `4.0.0`.
3. **Group ID (`groupId`)**: Specifies the group that the project belongs to. This is typically a reversed domain name (e.g., `com.example`).
4. **Artifact ID (`artifactId`)**: The unique identifier for the project within the group.
5. **Version (`version`)**: Specifies the version of the project.

#### Example of a minimal `pom.xml` file:

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>

  <groupId>com.example</groupId>
  <artifactId>my-project</artifactId>
  <version>1.0.0</version>
</project>
```

Explanation of Each Element

* **`<project>`**: The root element of the POM file.
* **`xmlns` and `xsi:schemaLocation`**: These attributes define the XML namespace and schema location for the POM.
* **`<modelVersion>`**: Indicates the version of the POM model, which should be `4.0.0`.
* **`<groupId>`**: A unique identifier for the project’s group. This is typically based on the project's package structure or the domain of the organization.
* **`<artifactId>`**: The name of the project. This ID must be unique within the group.
* **`<version>`**: The version of the project. This can follow semantic versioning (e.g., `1.0.0`, `1.0.1`, `1.1.0`, etc.).

## What is Maven artifact?

An artifact is a JAR (for example), that gets deployed to a Maven repository. Each artifact has a group ID , an artifact ID (artifact name) and a version string.

## What is MOJO?

Maven plain Old Java Object. Each mojo is an executable goal in Maven.

## How do I skip the tests?

Include the parameter -Dmaven.test.skip=true or -DskipTests=true in the

## How can I run a single unit test?

Use the parameter -Dtest=MyTestClassName at the command line.

## What is Maven plugin?

Plugin is a distribution of one or more related mojos.

## Different types of dependency scope?

In Maven, dependency scopes define the visibility and lifecycle of a dependency. The scope of a dependency determines where it is available in the project lifecycle (compile, test, runtime, etc.) and whether it is included in the final package. Here are the different types of dependency scopes in Maven:

#### 1. `compile`

* **Default Scope**: If no scope is specified, the dependency is assumed to be in the `compile` scope.
* **Availability**: Available in all classpaths (compilation, testing, runtime, and packaged in the final artifact).
* **Use Case**: For dependencies required for the project to compile, such as the main application libraries.

```
<dependency>
  <groupId>org.springframework</groupId>
  <artifactId>spring-core</artifactId>
  <version>5.3.9</version>
  <scope>compile</scope> <!-- This is the default, so it can be omitted -->
</dependency>
```

#### 2. `provided`

* **Availability**: Available in the compilation and test classpaths but not in the runtime classpath.
* **Use Case**: For dependencies provided by the runtime environment (e.g., a servlet API provided by the application server).

```
<dependency>
  <groupId>javax.servlet</groupId>
  <artifactId>servlet-api</artifactId>
  <version>2.5</version>
  <scope>provided</scope>
</dependency>
```

#### 3. `runtime`

* **Availability**: Available in the runtime and test classpaths but not in the compilation classpath.
* **Use Case**: For dependencies required only at runtime, such as JDBC drivers.

```
<dependency>
  <groupId>mysql</groupId>
  <artifactId>mysql-connector-java</artifactId>
  <version>8.0.23</version>
  <scope>runtime</scope>
</dependency>
```

#### 4. `test`

* **Availability**: Available only in the test classpath.
* **Use Case**: For dependencies needed only for testing purposes, such as testing frameworks (e.g., JUnit).

```
<dependency>
  <groupId>junit</groupId>
  <artifactId>junit</artifactId>
  <version>4.13.2</version>
  <scope>test</scope>
</dependency>
```

#### 5. `system`

* **Availability**: Similar to `provided`, but the JAR file for the dependency must be explicitly provided and not downloaded from a repository.
* **Use Case**: For dependencies that must be explicitly specified and are not available in any remote repository.
* **Additional Requirement**: Requires the `systemPath` element to specify the path to the JAR file.

```
<dependency>
  <groupId>com.example</groupId>
  <artifactId>example-library</artifactId>
  <version>1.0.0</version>
  <scope>system</scope>
  <systemPath>${project.basedir}/libs/example-library-1.0.0.jar</systemPath>
</dependency>
```

#### 6. `import` (for dependency management)

* **Availability**: Only used in the `<dependencyManagement>` section.
* **Use Case**: Used to import dependencies from a BOM (Bill of Materials) POM.

```
<dependencyManagement>
  <dependencies>
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-dependencies</artifactId>
      <version>2.5.4</version>
      <scope>import</scope>
      <type>pom</type>
    </dependency>
  </dependencies>
</dependencyManagement>
```

## What makes a fully qualified name for the artifact?

Three properties group ID, artifact ID and the version string together identifies the artifact.

```
 <groupId>:<artifactId>:<version>
```

## Where do we find .class files of a Maven project?

Under the folder ${basedir}/target/classes/.

## What is Super POM?

The Super POM is the ultimate parent POM for all Maven projects. It defines default configurations and settings that apply to every Maven project, providing a set of shared, base configurations. When we create a Maven project, our project's `pom.xml` implicitly inherits from this Super POM unless we explicitly specify a different parent.

### Location

The Super POM is provided by the Maven installation and is located in the `maven-model-builder` library.

### Key Aspects

* **Inheritance**: Every `pom.xml` file in Maven implicitly inherits from the Super POM.
* **Defaults**: It defines default behaviors, properties, and configurations that can be overridden by your project's `pom.xml`.
* **Extensibility**: By extending the Super POM, Maven projects benefit from standardized build processes and settings.

### Example of the Super POM

Here is a simplified version of what the Super POM contains:

```xml
<project>
  <modelVersion>4.0.0</modelVersion>
  <groupId>org.apache.maven</groupId>
  <artifactId>super-pom</artifactId>
  <version>1.0</version>
  <packaging>pom</packaging>

  <dependencyManagement>
    <dependencies>
      <dependency>
        <groupId>org.apache.maven</groupId>
        <artifactId>maven-model</artifactId>
        <version>3.6.0</version>
        <scope>compile</scope>
      </dependency>
      <!-- More default dependencies -->
    </dependencies>
  </dependencyManagement>

  <repositories>
    <repository>
      <id>central</id>
      <url>https://repo.maven.apache.org/maven2</url>
    </repository>
  </repositories>

  <pluginRepositories>
    <pluginRepository>
      <id>central</id>
      <url>https://repo.maven.apache.org/maven2</url>
    </pluginRepository>
  </pluginRepositories>

  <build>
    <pluginManagement>
      <plugins>
        <plugin>
          <groupId>org.apache.maven.plugins</groupId>
          <artifactId>maven-clean-plugin</artifactId>
          <version>3.1.0</version>
        </plugin>
        <!-- More default plugins -->
      </plugins>
    </pluginManagement>
  </build>
</project>
```

#### Default Settings from the Super POM

Here are some of the default configurations provided by the Super POM:

1. **Repositories**:
   * The central repository (`https://repo.maven.apache.org/maven2`) is defined as the default repository.
2. **Plugin Repositories**:
   * The central plugin repository is also defined.
3. **Build Plugins**:
   * Common build plugins and their versions are specified, such as `maven-clean-plugin`, `maven-compiler-plugin`, and `maven-surefire-plugin`.
4. **Dependency Management**:
   * Default dependencies and their versions are managed.

### Overriding the Super POM

We can override or extend the settings provided by the Super POM in our project's `pom.xml`. For example:

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>

  <groupId>com.example</groupId>
  <artifactId>my-project</artifactId>
  <version>1.0.0</version>

  <repositories>
    <repository>
      <id>my-repo</id>
      <url>http://mycompany.com/maven2</url>
    </repository>
  </repositories>

  <build>
    <plugins>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-compiler-plugin</artifactId>
        <version>3.8.1</version>
        <configuration>
          <source>1.8</source>
          <target>1.8</target>
        </configuration>
      </plugin>
    </plugins>
  </build>
</project>
```

#### How to View the Super POM

You can view the Super POM by running the following Maven command:

```sh
mvn help:effective-pom
```

This command generates the effective POM for our project, which includes the merged configurations from your `pom.xml` and the Super POM.

### Add a New POM as Parent

To add a new POM as a parent to our Maven project, we need to specify the parent POM in our project's `pom.xml` file. This is done using the `<parent>` element. The parent POM can provide shared configurations, dependencies, and plugins for all child projects.

#### Steps to Add a New POM as Parent

1.  **Define the Parent POM**: Create a parent POM with the common configurations that you want to share across multiple projects.

    ```xml
    <project xmlns="http://maven.apache.org/POM/4.0.0"
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
      <modelVersion>4.0.0</modelVersion>
      
      <groupId>com.example</groupId>
      <artifactId>parent-project</artifactId>
      <version>1.0.0</version>
      <packaging>pom</packaging>
      
      <dependencyManagement>
        <dependencies>
          <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-core</artifactId>
            <version>5.3.9</version>
          </dependency>
          <!-- Add more dependencies as needed -->
        </dependencies>
      </dependencyManagement>

      <build>
        <pluginManagement>
          <plugins>
            <plugin>
              <groupId>org.apache.maven.plugins</groupId>
              <artifactId>maven-compiler-plugin</artifactId>
              <version>3.8.1</version>
              <configuration>
                <source>1.8</source>
                <target>1.8</target>
              </configuration>
            </plugin>
            <!-- Add more plugins as needed -->
          </plugins>
        </pluginManagement>
      </build>
    </project>
    ```
2.  **Add the Parent POM to the Child Project**: In your child project's `pom.xml`, specify the parent POM using the `<parent>` element.

    ```xml
    <project xmlns="http://maven.apache.org/POM/4.0.0"
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
      <modelVersion>4.0.0</modelVersion>

      <parent>
        <groupId>com.example</groupId>
        <artifactId>parent-project</artifactId>
        <version>1.0.0</version>
      </parent>

      <groupId>com.example</groupId>
      <artifactId>child-project</artifactId>
      <version>1.0.0</version>

      <dependencies>
        <dependency>
          <groupId>org.springframework</groupId>
          <artifactId>spring-core</artifactId>
        </dependency>
        <!-- Add more dependencies as needed -->
      </dependencies>

      <build>
        <plugins>
          <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-compiler-plugin</artifactId>
          </plugin>
          <!-- Add more plugins as needed -->
        </plugins>
      </build>
    </project>
    ```

#### How It Works

* **Inheritance**: The child project inherits the configurations from the parent POM, including dependency management, plugins, properties, and other settings.
* **Override**: The child project can override any configuration from the parent POM by redefining it in its own `pom.xml`.
* **Dependency Management**: The child project will use the versions of dependencies specified in the parent POM's `<dependencyManagement>` section unless overridden in the child POM.

#### Benefits

* **Centralized Configuration**: Common configurations are centralized in the parent POM, making it easier to manage and update them.
* **Consistency**: Ensures consistency across multiple projects by sharing the same configurations.
* **Reduced Redundancy**: Reduces redundancy in configuration by avoiding duplication of common settings in each child project.

## Difference between compile and install.

`compile` compiles the source code of the project whereas `install` installs the package into the local repository, for use as a dependency in other projects locally.

## How do I specify packaging/distributable format in Maven?

The packaging for our project can be specified via the POM element **\<packaging>**.

Some of the valid packaging values are **jar, war, ear and pom**. If no packaging value has been specified, it will default to **jar**.

```
<project ...>
  ...
  <packaging>war</packaging>
  ...
</project>
```

## What is Transitive Dependency?

In Maven, a transitive dependency is an indirect dependency that a project inherits from its direct dependencies. This means if Project A depends on Project B, and Project B depends on Project C, then Project A will also have Project C as a dependency. Transitive dependencies allow for automatic inclusion of necessary dependencies without explicitly specifying them in the `pom.xml` file.

**Example**

**Project A `pom.xml`:**

```xml
<project>
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.example</groupId>
  <artifactId>project-a</artifactId>
  <version>1.0.0</version>
  <dependencies>
    <dependency>
      <groupId>com.example</groupId>
      <artifactId>project-b</artifactId>
      <version>1.0.0</version>
    </dependency>
  </dependencies>
</project>
```

**Project B `pom.xml`:**

```xml
<project>
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.example</groupId>
  <artifactId>project-b</artifactId>
  <version>1.0.0</version>
  <dependencies>
    <dependency>
      <groupId>com.example</groupId>
      <artifactId>project-c</artifactId>
      <version>1.0.0</version>
    </dependency>
  </dependencies>
</project>
```

In this case, Project A will have both Project B and Project C as dependencies.

## Difference Between `maven compile` and `maven install`

* **`mvn compile`**:
  * **Purpose**: Compiles the source code of the project.
  * **Lifecycle Phase**: Executes up to the `compile` phase.
  * **Outcome**: Generates `.class` files in the `target/classes` directory.
  * **Usage**: Used when you only need to compile the code and not perform further actions like testing or packaging.
* **`mvn install`**:
  * **Purpose**: Installs the package into the local repository, for use as a dependency in other projects locally.
  * **Lifecycle Phase**: Executes all phases in the default lifecycle up to `install` (includes compile, test, package, etc.).
  * **Outcome**: Installs the resulting artifact (e.g., JAR, WAR) into the local Maven repository (`~/.m2/repository`).
  * **Usage**: Used when you want to build the project and make it available for other local projects to use as a dependency

## What is Maven Snapshot ?

A snapshot in Maven represents a version of the project that is currently in development and may change. Snapshots are used to indicate that the version is not stable and is still under active development.

* **Snapshot Versioning**: Snapshot versions are denoted with `-SNAPSHOT` at the end of the version number (e.g., `1.0.0-SNAPSHOT`).
* **Updating**: Maven checks for updates to snapshot dependencies on each build, ensuring the latest development version is used.
* **Storage**: Snapshots are stored in a special directory in the repository to keep track of different builds.

**Example**

**Snapshot Dependency in `pom.xml`:**

```xml
<dependency>
  <groupId>com.example</groupId>
  <artifactId>example-project</artifactId>
  <version>1.0.0-SNAPSHOT</version>
</dependency>
```

## What is Maven's order of inheritance?

**Parent POM**:

* **Description**: The parent POM is the first source of inherited configurations. If our project specifies a parent POM using the `<parent>` element, all configurations, properties, dependency management, plugins, and plugin management defined in the parent POM are inherited by the child POM.
* **Inheritance**: Elements from the parent POM are inherited first and can be overridden by the child POM.
*   **Example**:

    ```xml
    <parent>
      <groupId>com.example</groupId>
      <artifactId>parent-project</artifactId>
      <version>1.0.0</version>
    </parent>
    ```

**Project POM**:

* **Description**: The project POM (`pom.xml`) is the main configuration file for our Maven project. It contains the project's own configurations, dependencies, properties, and build settings.
* **Precedence**: Configurations in the project POM override those inherited from the parent POM.
*   **Example**:

    ```xml
    <project>
      <modelVersion>4.0.0</modelVersion>
      <groupId>com.example</groupId>
      <artifactId>child-project</artifactId>
      <version>1.0.0</version>
      <parent>
        <groupId>com.example</groupId>
        <artifactId>parent-project</artifactId>
        <version>1.0.0</version>
      </parent>
      <!-- Project-specific configurations -->
    </project>
    ```

**Settings**:

* **Description**: The settings file (`settings.xml`) contains user-specific configurations for Maven, including repository locations, proxies, and user credentials. There are two `settings.xml` files: one global (located in `MAVEN_HOME/conf`) and one user-specific (located in `~/.m2`).
* **Precedence**: Settings in `settings.xml` can override configurations in the project POM, particularly for repository settings and user-specific configurations.
*   **Example** (`~/.m2/settings.xml`):

    ```xml
    <settings>
      <mirrors>
        <mirror>
          <id>central-mirror</id>
          <mirrorOf>central</mirrorOf>
          <url>http://mirror.example.com/maven2</url>
        </mirror>
      </mirrors>
      <!-- Other user-specific settings -->
    </settings>
    ```

**CLI Parameters**:

* **Description**: Command Line Interface (CLI) parameters provided when invoking Maven commands. These include system properties, profiles, and other command-line options.
* **Precedence**: CLI parameters have the highest precedence and can override configurations specified in both the settings file and the project POM. They are useful for temporary configurations and for passing arguments dynamically.
*   **Example**:

    ```sh
    mvn clean install -Dproperty=value -Pprofile
    ```

#### Order of Precedence

1. **CLI Parameters**: Highest precedence, overrides all other configurations.
2. **Settings**: User-specific configurations that override project POM settings.
3. **Project POM**: Main project configurations that override parent POM settings.
4. **Parent POM**: Base configurations inherited by the project.

## How Maven uses Convention over Configuration?

Maven's features and plugins are initialized with default conventions and the basic functionality of Maven requires minimum or no configuration.

## How do I install a 3rd party jar (for example) into the Maven repository?

To install a third-party JAR into your local Maven repository, you can use the `mvn install:install-file` command. This command allows you to specify the file path of the JAR and the necessary Maven coordinates such as `groupId`, `artifactId`, `version`, and `packaging`. Here is a step-by-step guide on how to do this:

#### Step-by-Step Guide

1. **Prepare the JAR File**: Make sure you have the JAR file you want to install locally on your system. Note the path to this file.
2.  **Run the Maven Command**: Use the following command to install the JAR into your local Maven repository:

    ```sh
    mvn install:install-file -Dfile=<path-to-file> -DgroupId=<group-id> \
        -DartifactId=<artifact-id> -Dversion=<version> -Dpackaging=<packaging>
    ```

    * **`-Dfile`**: Path to the JAR file you want to install.
    * **`-DgroupId`**: The group ID you want to assign to the JAR.
    * **`-DartifactId`**: The artifact ID you want to assign to the JAR.
    * **`-Dversion`**: The version number you want to assign to the JAR.
    * **`-Dpackaging`**: The packaging type (usually `jar`).

#### Example

Let's assume you have a JAR file located at `/path/to/external-library-1.0.0.jar` and you want to install it with the following Maven coordinates:

* **Group ID**: `com.example`
* **Artifact ID**: `external-library`
* **Version**: `1.0.0`
* **Packaging**: `jar`

The command would be:

```sh
mvn install:install-file -Dfile=/path/to/external-library-1.0.0.jar -DgroupId=com.example \
    -DartifactId=external-library -Dversion=1.0.0 -Dpackaging=jar
```

#### Using a POM File (Optional)

If you have a POM file for the JAR, you can include it using the `-DpomFile` parameter:

```sh
mvn install:install-file -Dfile=/path/to/external-library-1.0.0.jar -DgroupId=com.example \
    -DartifactId=external-library -Dversion=1.0.0 -Dpackaging=jar -DpomFile=/path/to/external-library.pom
```

#### Verifying the Installation

After running the command, the JAR file should be installed in your local Maven repository, typically located at `~/.m2/repository/com/example/external-library/1.0.0/`.

You can verify the installation by checking if the following files are present in the directory:

```bash
~/.m2/repository/com/example/external-library/1.0.0/external-library-1.0.0.jar
~/.m2/repository/com/example/external-library/1.0.0/external-library-1.0.0.pom
```

#### Adding the Dependency to Your Project

Once the JAR is installed in your local Maven repository, you can add it as a dependency in your project's `pom.xml`:

```xml
<dependency>
  <groupId>com.example</groupId>
  <artifactId>external-library</artifactId>
  <version>1.0.0</version>
</dependency>
```

## List out the dependency scope in Maven?

**Compile**: It is the default scope, and it indicates what dependency is available in the classpath of the project\
**Provided**: It indicates that the dependency is provided by JDK or web server or container at runtime\
**Runtime**: This tells that the dependency is not needed for compilation but is required during execution\
**Test**: It says dependency is available only for the test compilation and execution phases\
**System**: It indicates you have to provide the system path\
**Import**: This indicates that the identified or specified POM should be replaced with the dependencies in that POM’s section

## List out the build phases in Maven?

**Validate**: validate the project is correct and all necessary information is offered.\
**Compile**: compile the source code of the project.\
**Test**: test the compiled source code employing an appropriate unit testing framework and these tests should not require the code deployed or packaged.\
**Package**: take the compiled code and package it in its distributable format like a JAR.\
**Integration-Test**: process and deploy the package if needed to run integration tests\
**Verify**: run any tests to verify the package is still valid and meets quality requirements.\
**Install**: install the package into the native repository, to be used as a dependency in alternative projects regionally.\
**Deploy**: copies the final package to the remote repository for sharing with alternative projects and developers.

## How to run a Spring Boot application directly from the command line without any packaging file (e.g. JAR file)?

The `mvn spring-boot:run` command is used in Maven to run a Spring Boot application directly from the command line without the need to package it as a JAR file first. This is particularly useful for development, as it allows to quickly start up the application and see changes in real-time. We can pass additional properties or profiles as parameters.

{% hint style="info" %}
**`spring-boot-maven-plugin`** should be included in the `pom.xml` file of the Spring Boot project.
{% endhint %}

```git
mvn spring-boot:run
mvn spring-boot:run -Dspring-boot.run.profiles=dev
mvn spring-boot:run -Dspring-boot.run.arguments="--server.port=8081"
```



