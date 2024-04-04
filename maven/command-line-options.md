---
description: An overview of the options available while executing maven commands.
---

# Command-line Options

**Different Command line Options**

* \-D: Specifies system properties or project properties.&#x20;

`mvn clean install -DskipTests`

* \-P: Activates one or more Maven profiles during the build process.&#x20;

`mvn clean install -Pproduction`

* \-X: Enables debug mode, providing detailed debugging output during the build process. It's helpful for diagnosing build issues or understanding the build process.&#x20;

`mvn clean install -X`

* \-e: Enables error output, displaying stack traces for errors that occur during the build process. It's useful for identifying and troubleshooting build failures.&#x20;

`mvn clean install -e`

* \-U: Forces Maven to check for updated dependencies and plugins from remote repositories, even if the local cache is up to date&#x20;

`mvn clean install -U`

* \-f: Specifies an alternate location for the POM file. It allows you to execute Maven commands in a directory without a POM or with a non-standard POM filename.&#x20;

`mvn clean install -f /path/to/alternate/pom.xml`

* \-pl: Specifies a comma-separated list of modules to build. It allows you to selectively build specific modules in a multi-module project.

`mvn clean install -pl module1,module2`



**Chaining Phases**

Multiple phases can be chained using spaces in a single command. This executes each phase sequentially.

`mvn clean compile test package verify install`&#x20;



{% hint style="info" %}
In Maven, when resolving dependencies, the order in which repositories are checked depends on the order they are defined in the `pom.xml` file. By default the sequence is:

1. **Local Repository**: Maven first looks into the local repository, which is usually located in the home directory (`~/.m2/repository` on Unix-like systems, or `%USERPROFILE%\.m2\repository` on Windows). If the required dependencies are found there, Maven uses them directly without further processing.
2. **Remote Repositories**: If the dependencies are not found in the local repository, Maven checks any remote repositories configured in the `pom.xml` file. These remote repositories could be the organization's internal repositories or other external repositories besides Maven Central. Maven checks them in the order they are defined in the `pom.xml`.
3. **Maven Central**: If the dependencies are not found in any of the configured repositories, Maven then checks Maven Central, which is the default central repository for open-source Java libraries.
{% endhint %}



**Skipping phases:**

* To skip a specific phase (-Dmaven.\<phase>.skip=true).&#x20;

`mvn clean install -Dmaven.test.skip=true`

* To skip both test and site phases&#x20;

`mvn clean install -DskipTests`

{% hint style="info" %}
\-DskipTests only skips the test execution, but -Dmaven.test.skip=true will skip the compilation of test classes as well
{% endhint %}

* To skip only integration tests

`mvn clean install -DskipFailsafeTests`





