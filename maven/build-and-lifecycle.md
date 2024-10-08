---
description: >-
  An overview of Maven's build process, covering its lifecycle, phases and
  default plugins.
---

# Build & Lifecycle

## About

Maven organizes the build process into several lifecycle wherein each comprising a series of phases.

## **Clean Lifecycle**

This lifecycle is responsible for cleaning up the project. It includes the following phases:

* **pre-clean**: Executes tasks before the project is cleaned.

> Use Case: A project might generate temporary files during the build process that need to be cleaned up before starting a fresh build. It can also be used to prepare the build environment, such as stopping services or releasing resources that might interfere with the build process.

* **clean**: Removes all files generated by the previous build. By default, Maven builds all output (compiled classes, JARs, generated resources, etc.) into the `target`directory in your project's root directory. Maven deletes this target directory along with all its contents, effectively removing all artifacts generated during the build process.

{% hint style="info" %}
The target directory typically contains subdirectories such as:

```
classes: Compiled Java classes
test-classes: Compiled test classes
generated-sources: Generated source code (if any)
maven-archiver: Files related to packaging (e.g., JAR file)
surefire-reports: Reports generated by the Surefire plugin during unit testing
site: Site documentation (if generated)
```
{% endhint %}

## **Default Lifecycle**

The default lifecycle handles the build process and includes different phases. Phases are executed in a sequential order, ensuring specific tasks are completed before moving on. There are <mark style="background-color:purple;">8 standard phases</mark>.

* **validate**: Verify project structure and configuration correctness.

> Use case: If there are missing or incorrect configurations in the project's pom.xml file (for eg. incorrect XML syntax, missing dependencies, conflicting plugin configurations, conflicting plugin configurations ), the validate phase might throw errors

* **compile**: Compile source code into classes.
* **test**: Run unit tests using a suitable testing framework to test individual units. Does not include integration tests.
* **package**: Packages the compiled code into a distributable format, such as a JAR or WAR.
* **verify**: Perform additional checks on the packaged artifact for quality standards.

> Use case: Suitable for running tasks like code quality analysis, static code analysis, or even performance tests. Tasks executed in the verify phase often generate reports detailing the results of various checks and tests.

* **install**: Build the package and Installs the package into the local repository for use as a dependency in other projects.
* **deploy**: Copies the final package to the remote repository for sharing with other developers and projects.
* **site**: Generate project site documentation.

<figure><img src="../.gitbook/assets/image (224).png" alt="" width="488"><figcaption></figcaption></figure>

The Above standard 8 phases provide a structured framework, but plugins can introduce additional phases or customize existing ones for specific purposes. They are not technically part of the core lifecycle. Instead, they are bindings to goals of various plugins that are automatically executed during specific phases of the standard lifecycle. <mark style="color:red;">For example</mark>, the generate-sources phase is bound to the generate-sources goal of the maven-compiler-plugin. Similarly, process-resources is bound to the process-resources goal of the maven-resources-plugin.

**initialize:** Use to initialize properties, plugins, and resources that the build will use. It is not associated with a specific plugin, instead, it's part of the default build lifecycle. This phase is responsible for initializing properties, plugins, and resources needed for the build process.

> Use Case: It can be used to set initial values for project properties, which can be used throughout the build process. If a project requires custom resources or configurations that need to be loaded before the build starts. Also, it can be used to configure parameters for plugins that will be used in subsequent phases

Below are typically associated with <mark style="color:green;">maven-compiler-plugin</mark>

* **generate-sources:** Generates any source code for the project.
* **process-sources:** Processes the source code, such as compiling Java source files.
* **process-classes:** Processes the compiled classes, such as applying bytecode enhancements.
* **generate-test-sources:** Generates any test source code.
* **process-test-sources:** Processes the test source code.
* **test-compile**: Compiles the test source code.

Below are typically associated with <mark style="color:green;">maven-resources-plugin</mark>

* **generate-resources**: Generates resources for the project.
* **process-resources:** Processes the project resources.
* **generate-test-resources:** Generates test resources.
* **process-test-resources:** Processes test resources.

Below are typically associated with <mark style="color:green;">maven-surefire-plugin</mark> or <mark style="color:green;">maven-failsafe-plugin</mark>

* **process-test-classes**: Processes the compiled test classes.

Below are typically associated with <mark style="color:green;">maven-jar-plugin, maven-war-plugin</mark>

* **prepare-package**: Prepares the package before it is packaged.

Below are typically associated with <mark style="color:green;">maven-failsafe-plugin</mark>

* **pre-integration-test:** Executes tasks before integration tests are run.
* **integration-test:** Runs integration tests using an appropriate testing framework.
* **post-integration-test:** Executes tasks after integration tests are run.

## **Site Lifecycle**

This lifecycle is responsible for generating a project's site documentation. The directory where Maven generates the site documentation is `target/site`. It includes the following phases:

* **pre-site:** Executes tasks before the site is generated.
* **site:** Generates the project's site documentation.
* **post-site:** Executes tasks after the site is generated.
* **site-deploy:** Deploys the generated site documentation to the specified server.

<figure><img src="../.gitbook/assets/image (225).png" alt="" width="317"><figcaption><p>Generated Site Reports</p></figcaption></figure>

{% file src="../.gitbook/assets/bookstore-reference – Project Information.pdf" %}
Sample Site Document
{% endfile %}

{% file src="../.gitbook/assets/bookstore-reference – Project Summary.pdf" %}
Sample site Document
{% endfile %}

{% hint style="info" %}
We can customize the default phases and their associated behavior using Maven's plugin configuration. Maven provides flexibility to adjust the execution of default phases and even create custom phases if needed. For e.g. to customize the behavior of the compile phase to perform additional tasks before and after compilation, configure the maven-compiler-plugin in your POM.

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-compiler-plugin</artifactId>
            <version>3.8.1</version>
            <configuration>
                <!-- Compiler configuration options -->
            </configuration>
            <executions>
                <execution>
                    <id>custom-compile</id>
                    <phase>compile</phase>
                    <goals>
                        <goal>compile</goal>
                    </goals>
                    <configuration>
                        <!-- Custom configuration for this execution -->
                        <source>1.8</source>
                        <target>1.8</target>
                        <compilerArgs>
                            <arg>-Xlint:unchecked</arg>
                            <arg>-Xlint:deprecation</arg>
                        </compilerArgs>
                    </configuration>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
```
{% endhint %}

## **Default Plugins**

Maven plugins consist of one or more goals, which represent specific tasks or actions. Maven comes bundled with several default plugins that provide essential functionality for managing and building projects. No need to import default plugin specifically in pom.xml, if default configuration is needed for the project.

<figure><img src="../.gitbook/assets/image (226).png" alt="" width="518"><figcaption></figcaption></figure>

**maven-clean-plugin**: Provides functionality for cleaning the project by deleting generated files and directories. It is typically bound to the clean phase of the build lifecycle.

**maven-compiler-plugin**: This plugin is responsible for compiling the project's source code. It supports different versions of Java and allows configuration of compiler options.

**maven-deploy-plugin:** Deploys project artifacts to a remote repository or server. It is typically bound to the deploy phase of the build lifecycle.

**maven-install-plugin:** Installs the project artifacts (e.g., JAR, WAR) into the local Maven repository. It is typically bound to the install phase of the build lifecycle.

**maven-jar-plugin**: Facilitates the creation of JAR (Java Archive) files for packaging Java projects. It allows customization of the JAR's manifest and inclusion of additional resources.

**maven-resources-plugin**: Handles the copying of project resources to the output directory during the resource phase of the build lifecycle. It supports filtering and processing of resources.

**maven-site-plugin**: It is a crucial plugin in Maven for generating project documentation in HTML format. It's commonly used to create a project's website, including various reports, documentation, and other information helpful for developers and users.

**maven-surefire-plugin**: Used for executing unit tests during the test phase of the build lifecycle. It supports various test frameworks like JUnit and TestNG.

{% hint style="info" %}
Each of the default plugins in Maven can be customized extensively to fit the specific requirements of the project. For example

```
// Configure maven-surefire-plugin
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-surefire-plugin</artifactId>
    <version>3.0.0-M5</version>
    <configuration>
        <includes>
            <include>**/*Test.java</include>
        </includes>
        <!-- Other configuration options -->
    </configuration>
</plugin>

// Configure maven-compiler-plugin
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-compiler-plugin</artifactId>
    <version>3.8.1</version>
    <configuration>
        <source>1.8</source>
        <target>1.8</target>
        <!-- Other configuration options -->
    </configuration>
</plugin>
```
{% endhint %}
