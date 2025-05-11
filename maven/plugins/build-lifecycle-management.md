# Build Lifecycle Management

## About

**Build Lifecycle Management Plugins** control the different **phases** of the Maven **build lifecycle**—such as **compilation, testing, packaging, deployment, and installation**. These plugins ensure that Maven can consistently build, test, and distribute projects by handling specific tasks at different lifecycle stages.

Maven defines three **default lifecycles**:

1. **Clean** – Removes previous build artifacts.
2. **Default** – Handles compilation, testing, packaging, and deployment.
3. **Site** – Generates project documentation.

Each lifecycle consists of **phases**, and various **plugins** execute specific goals within these phases.

## How Plugins Fit into the Maven Build Lifecycle?

Each plugin executes specific **goals**, and these goals are bound to **phases** in the Maven build lifecycle.

For example:

* `compile` → **maven-compiler-plugin** (`compile`)
* `test` → **maven-surefire-plugin** (`test`)
* `package` → **maven-jar-plugin** (`jar`)
* `verify` → **maven-failsafe-plugin** (`integration-test`)
* `install` → **maven-install-plugin** (`install`)
* `deploy` → **maven-deploy-plugin** (`deploy`)

## 1. Compilation & Code Processing Plugins

### `maven-compiler-plugin`

The `maven-compiler-plugin` is responsible for **compiling Java source files**. It ensures that your project's source code is compiled using the correct **Java version** and **compiler settings**.

**Syntax**

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-compiler-plugin</artifactId>
    <version>3.8.1</version>
    <configuration>
        <source>17</source>
        <target>17</target>
        <compilerArgs>
            <arg>-Xlint:unchecked</arg>
            <arg>-Xlint:deprecation</arg>
        </compilerArgs>
        <skip>false</skip>
    </configuration>
</plugin>
```

This configuration **compiles** Java code using **Java 17**.

**Configuration Options**

<table data-full-width="true"><thead><tr><th width="358.1796875">Configuration</th><th width="447.3125">Description</th><th>Default</th></tr></thead><tbody><tr><td><code>source</code></td><td>Specifies the Java source version</td><td>1.6</td></tr><tr><td><code>target</code></td><td>Specifies the Java target bytecode version</td><td>1.6</td></tr><tr><td><code>compilerArgs</code></td><td>Additional compiler arguments</td><td><code>None</code></td></tr><tr><td><code>debug</code></td><td>Enables debug symbols</td><td><code>true</code></td></tr><tr><td><code>failOnError</code></td><td>Stops the build if compilation fails</td><td><code>true</code></td></tr><tr><td><code>verbose</code></td><td>Prints detailed compiler output</td><td><code>false</code></td></tr><tr><td><code>skip</code></td><td>Skips compilation phase</td><td><code>None</code></td></tr><tr><td>Compiler Arguments -<code>Xlint:unchecked</code></td><td>enable warnings for unchecked operations.</td><td><code>None</code></td></tr><tr><td>Compiler Arguments -<code>Xlint:deprecation</code></td><td>enable warnings for deprecated operations.</td><td><code>None</code></td></tr></tbody></table>

### `maven-resources-plugin`

The `maven-resources-plugin` is responsible for **copying project resources** (such as `.properties`, `.xml`, and `.json` files) into the appropriate build directories.

**Syntax**

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-resources-plugin</artifactId>
    <version>3.2.0</version>
    <executions>
        <execution>
            <id>copy-resources</id>
            <phase>process-resources</phase>
            <goals>
                <goal>resources</goal>
            </goals>
        </execution>
    </executions>
</plugin>

// Different configuration use case

// Copy Specific Files - This only copies config.properties instead of all resources.
    <configuration>
        <resources>
            <resource>
                <directory>src/main/resources</directory>
                <includes>
                    <include>config.properties</include>
                </includes>
            </resource>
        </resources>
    </configuration>

// Enable Variable Substitution in Resource
    <configuration>
        <resources>
            <resource>
                <directory>src/main/resources</directory>
                <filtering>true</filtering>
            </resource>
        </resources>
    </configuration>
```

This plugin executes in the `process-resources` phase to copy files from `src/main/resources` to `target/classes`.

**Configuration Options**

<table><thead><tr><th width="140.359375">Configuration</th><th width="385.91796875">Description</th><th>Default</th></tr></thead><tbody><tr><td><code>resources</code></td><td>Specifies the directories for resource files</td><td><code>src/main/resources</code></td></tr><tr><td><code>includes</code></td><td>Specifies which files to include</td><td><code>**/*</code></td></tr><tr><td><code>excludes</code></td><td>Specifies which files to exclude</td><td><code>None</code></td></tr><tr><td><code>filtering</code></td><td>Allows variables in resources (<code>${}</code> placeholders)</td><td><code>false</code></td></tr></tbody></table>

### `maven-enforcer-plugin`

The `maven-enforcer-plugin` ensures that projects adhere to **rules**, such as enforcing Java versions, dependency versions, and best practices.

**Syntax**

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-enforcer-plugin</artifactId>
    <version>3.0.0</version>
    <executions>
        <execution>
            <id>enforce-java</id>
            <goals>
                <goal>enforce</goal>
            </goals>
            <configuration>
                <rules>
                    <requireJavaVersion>
                        <version>[17,)</version> // This enforces Java 17 or higher.
                    </requireJavaVersion>
                </rules>
            </configuration>
        </execution>
    </executions>
</plugin>

// Different configuration use case

// Enforce a Specific Maven Version
<rules>
    <requireMavenVersion>
        <version>[3.6,)</version>
    </requireMavenVersion>
</rules>

// Ban Specific Dependencies
<rules>
    <bannedDependencies>
        <excludes>
            <exclude>org.slf4j:slf4j-log4j12</exclude>
        </excludes>
    </bannedDependencies>
</rules>
```

**Configuration Options**

| Rule                  | Description                              |
| --------------------- | ---------------------------------------- |
| `requireJavaVersion`  | Ensures a minimum Java version           |
| `requireMavenVersion` | Ensures a minimum Maven version          |
| `requireOS`           | Restricts build execution to specific OS |
| `bannedDependencies`  | Blocks unwanted dependencies             |
| `bannedPlugins`       | Blocks unwanted plugins                  |

## 2. Testing Plugins

### `maven-surefire-plugin`

The `maven-surefire-plugin` runs **unit tests** during the `test` phase of the Maven lifecycle. It executes **JUnit, TestNG, and other testing frameworks**.

#### **Syntax**

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-surefire-plugin</artifactId>
    <version>3.0.0-M7</version>
</plugin>

// Different configuration use case

// Running a Specific Test Class
    <configuration>
        <test>com.example.MyTest</test>
    </configuration>
    
// Running Tests in Parallel
    <configuration>
        <forkCount>2</forkCount>
        <parallel>methods</parallel>
    </configuration>    

// Skipping Tests
    <configuration>
        <skipTests>true</skipTests>
    </configuration>
```

By default, it runs tests from **`src/test/java`**.

#### **Configuration Options**

<table data-full-width="true"><thead><tr><th width="160.15625">Configuration</th><th width="534.6875">Description</th><th>Default</th></tr></thead><tbody><tr><td><code>includes</code></td><td>Specify which test classes to run</td><td><code>**/Test*.java</code></td></tr><tr><td><code>excludes</code></td><td>Specify which tests to exclude</td><td><code>None</code></td></tr><tr><td><code>test</code></td><td>Runs a specific test class</td><td><code>None</code></td></tr><tr><td><code>forkCount</code></td><td>Number of JVMs to run tests in parallel</td><td><code>1</code></td></tr><tr><td><code>parallel</code></td><td>Enables parallel execution (<code>methods</code>, <code>classes</code>, <code>both</code>)</td><td><code>None</code></td></tr><tr><td><code>skipTests</code></td><td>Skips all tests</td><td><code>false</code></td></tr><tr><td><code>failIfNoTests</code></td><td>Fails the build if no tests are found</td><td><code>true</code></td></tr></tbody></table>

### `maven-failsafe-plugin`

The `maven-failsafe-plugin` is designed for **integration tests** (ITs) and runs tests **after the application is built and deployed**.

**Syntax**

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-failsafe-plugin</artifactId>
    <version>3.0.0-M7</version>
    <executions>
        <execution>
            <id>integration-tests</id>
            <phase>integration-test</phase>
            <goals>
                <goal>verify</goal>
            </goals>
        </execution>
    </executions>
</plugin>

// Different configuration use case

// Running Only Integration Tests. This runs only test files ending with IT.java (e.g., MyServiceIT.java)
    <configuration>
        <includes>
            <include>**/*IT.java</include>
        </includes>
    </configuration>

// Allow Integration Test Failures Without Stopping the Build
    <configuration>
        <errorFailingTests>false</errorFailingTests>
    </configuration>
```

Failsafe ensures that **even if an integration test fails, Maven doesn't stop the build immediately** but allows post-build cleanup.

**Configuration Options**

<table data-full-width="true"><thead><tr><th width="191.71484375">Configuration</th><th width="542.06640625">Description</th><th>Default</th></tr></thead><tbody><tr><td><code>includes</code></td><td>Specify test classes to run</td><td><code>**/IT*.java</code></td></tr><tr><td><code>excludes</code></td><td>Specify test classes to exclude</td><td><code>None</code></td></tr><tr><td><code>errorFailingTests</code></td><td>Set to <code>false</code> to allow failures without stopping the build</td><td><code>true</code></td></tr><tr><td><code>skipITs</code></td><td>Skip integration tests</td><td><code>false</code></td></tr><tr><td><code>parallel</code></td><td>Run tests in parallel</td><td><code>None</code></td></tr></tbody></table>

### `maven-verifier-plugin`

The `maven-verifier-plugin` is useful for **functional testing** of Maven projects. It verifies that the output of a Maven build meets the expected criteria.

**Syntax**

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-verifier-plugin</artifactId>
    <version>1.1</version>
</plugin>

// Different configuration use case

// Verify Expected Build Output. This verifies that target/output.txt contains SUCCESS.
    <configuration>
        <expectedFile>target/output.txt</expectedFile>
        <expectedContent>SUCCESS</expectedContent>
    </configuration>
```

## 3. Packaging Plugins

### `maven-jar-plugin`

The `maven-jar-plugin` is used to package Java applications into a **JAR (Java ARchive) file**. It includes compiled `.class` files, `META-INF`, and resource files.

**Syntax**

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-jar-plugin</artifactId>
    <version>3.3.0</version>
</plugin>

// Different configuration use case

// Custom JAR Name. This generates my-custom-app.jar instead of the default name.
<configuration>
    <finalName>my-custom-app</finalName>
</configuration>

// Creating a Sources JAR. This generates artifactId-version-sources.jar containing only source code.
<execution>
    <goals>
        <goal>jar</goal>
    </goals>
    <configuration>
        <classifier>sources</classifier>
    </configuration>
</execution>

```

**Configuration Options**

<table data-full-width="true"><thead><tr><th width="157.37890625">Configuration</th><th width="310.046875">Description</th><th>Default</th></tr></thead><tbody><tr><td><code>finalName</code></td><td>Name of the generated JAR file</td><td><code>project.artifactId-version.jar</code></td></tr><tr><td><code>classifier</code></td><td>Adds a suffix (e.g., <code>-sources</code>)</td><td><code>None</code></td></tr><tr><td><code>excludes</code></td><td>Files to exclude</td><td><code>None</code></td></tr><tr><td><code>includes</code></td><td>Files to include</td><td><code>None</code></td></tr></tbody></table>

### `maven-war-plugin`

The `maven-war-plugin` is used to package **web applications** into a **WAR (Web Application Archive)** for deployment on Java web servers.

**Syntax**

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-war-plugin</artifactId>
    <version>3.4.0</version>
</plugin>

// Different configuration use case

// Creating a Custom WAR Name. This generates my-app.war instead of the default name.
    <configuration>
        <warName>my-app</warName>
    </configuration>

// Skipping Web XML Validation
    <configuration>
        <failOnMissingWebXml>false</failOnMissingWebXml>
    </configuration>
```

**Configuration Options**

<table data-full-width="true"><thead><tr><th width="215.390625">Configuration</th><th>Description</th><th>Default</th></tr></thead><tbody><tr><td><code>failOnMissingWebXml</code></td><td>Whether to fail if <code>web.xml</code> is missing</td><td><code>true</code></td></tr><tr><td><code>warName</code></td><td>Name of the WAR file</td><td><code>project.artifactId-version.war</code></td></tr><tr><td><code>outputDirectory</code></td><td>Where to place the WAR file</td><td><code>target/</code></td></tr></tbody></table>

### `maven-ear-plugin`

The `maven-ear-plugin` is used to create **EAR (Enterprise Archive) files**, which bundle multiple Java EE components (JARs and WARs).

**Syntax**

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-ear-plugin</artifactId>
    <version>3.2.0</version>
</plugin>

// Different configuration use case

// Skipping application.xml. This allows EAR packaging without application.xml.
<configuration>
    <generateApplicationXml>false</generateApplicationXml>
</configuration>
```

**Configuration Options**

<table data-full-width="true"><thead><tr><th width="282.8125">Configuration</th><th>Description</th><th>Default</th></tr></thead><tbody><tr><td><code>defaultJavaBundleDir</code></td><td>Directory for JAR modules</td><td><code>lib/</code></td></tr><tr><td><code>failOnMissingApplicationXml</code></td><td>Fail if <code>application.xml</code> is missing</td><td><code>true</code></td></tr><tr><td><code>generateApplicationXml</code></td><td>Generate <code>application.xml</code> automatically</td><td><code>true</code></td></tr></tbody></table>

### `maven-assembly-plugin`

The `maven-assembly-plugin` allows **custom packaging** formats such as **ZIP, TAR, TAR.GZ**, and self-contained archives.

**Syntax**

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-assembly-plugin</artifactId>
    <version>3.6.0</version>
</plugin>

// Packaging JAR with Dependencies. This packages the JAR with all dependencies included.
<execution>
    <goals>
        <goal>single</goal>
    </goals>
    <configuration>
        <descriptorRef>jar-with-dependencies</descriptorRef>
    </configuration>
</execution>

// Creating a ZIP Archive. This creates a ZIP archive of the project.
<execution>
    <goals>
        <goal>single</goal>
    </goals>
    <configuration>
        <formats>
            <format>zip</format>
        </formats>
    </configuration>
</execution>
```

**Configuration Options**

<table data-full-width="true"><thead><tr><th width="154.15625">Configuration</th><th width="466.33203125">Description</th><th>Default</th></tr></thead><tbody><tr><td><code>descriptorRef</code></td><td>Predefined package types (<code>jar-with-dependencies</code>, etc.)</td><td><code>None</code></td></tr><tr><td><code>finalName</code></td><td>Name of the output archive</td><td><code>project.artifactId-version</code></td></tr><tr><td><code>formats</code></td><td>Output formats (<code>zip</code>, <code>tar.gz</code>, etc.)</td><td><code>zip</code></td></tr></tbody></table>

### `maven-shade-plugin`

The `maven-shade-plugin` is used to create a **fat JAR (Uber JAR)** that includes all dependencies.

**Syntax**

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-shade-plugin</artifactId>
    <version>3.4.1</version>
</plugin>

// Creating a Fat JAR. This creates fat-jar.jar with all dependencies included.
<configuration>
    <finalName>fat-jar</finalName>
</configuration>
```

**Configuration Options**

<table data-full-width="true"><thead><tr><th width="240.171875">Configuration</th><th width="258.60546875">Description</th><th>Default</th></tr></thead><tbody><tr><td><code>finalName</code></td><td>Name of the output JAR</td><td><code>project.artifactId-version.jar</code></td></tr><tr><td><code>shadedArtifactAttached</code></td><td>Attach shaded JAR to build</td><td><code>false</code></td></tr></tbody></table>

## 4. Deployment & Installation Plugins

### `maven-install-plugin`

The `maven-install-plugin` is used to **install** project artifacts (JAR, WAR, EAR, etc.) into the local repository (`~/.m2/repository`). This allows other projects on the same system to reference them.

**Syntax**

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-install-plugin</artifactId>
    <version>3.1.1</version>
</plugin>

// Installing a Custom Artifact. This installs the artifact using a legacy repository layout.
<execution>
    <goals>
        <goal>install</goal>
    </goals>
    <configuration>
        <repositoryLayout>legacy</repositoryLayout>
    </configuration>
</execution>

// Skipping Installation in a Profile. To activate this profile, run: mvn clean package -DskipInstall=true
<profiles>
    <profile>
        <id>skip-install</id>
        <activation>
            <property>
                <name>skipInstall</name>
                <value>true</value>
            </property>
        </activation>
        <properties>
            <install.skip>true</install.skip>
        </properties>
    </profile>
</profiles>
```

**Configuration Options**

| Configuration      | Description                 | Default   |
| ------------------ | --------------------------- | --------- |
| `skip`             | Skip the installation step  | `false`   |
| `repositoryLayout` | Define repository structure | `default` |

### `maven-deploy-plugin`

The `maven-deploy-plugin` is used to **deploy** project artifacts to a **remote repository** (e.g., Nexus, Artifactory, or Maven Central) for sharing across teams or organizations.

**Syntax**

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-deploy-plugin</artifactId>
    <version>3.1.1</version>
</plugin>

// Deploying to a Remote Repository. This deploys artifacts to https://repo.mycompany.com/releases.
<distributionManagement>
    <repository>
        <id>my-repo</id>
        <url>https://repo.mycompany.com/releases</url>
    </repository>
</distributionManagement>

<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-deploy-plugin</artifactId>
    <version>3.1.1</version>
</plugin>
```

**Configuration Options**

<table data-full-width="true"><thead><tr><th width="236.95703125">Configuration</th><th>Description</th><th>Default</th></tr></thead><tbody><tr><td><code>url</code></td><td>The repository URL for deployment</td><td><code>None</code> (Must be provided)</td></tr><tr><td><code>repositoryId</code></td><td>The ID of the target repository</td><td><code>None</code></td></tr><tr><td><code>altDeploymentRepository</code></td><td>Alternative repository specification</td><td><code>None</code></td></tr></tbody></table>

### `wagon-maven-plugin`

The **`wagon-maven-plugin`** is a Maven plugin provided by the [Codehaus Mojo](https://www.mojohaus.org/) project that enables automated file transfers as part of a Maven build lifecycle. It leverages the **Maven Wagon** transport framework to upload or download files using various protocols such as **SCP**, **FTP**, **HTTP**, and more.

This plugin is ideal for:

* Deploying build artifacts to non-Maven servers or directories
* Automating backup, distribution, or deployment steps
* Transferring files as part of custom CI/CD pipeline

Features

* Supports standard Maven Wagon protocols (e.g., `scp`, `ftp`, `http`, `file`)
* Can be bound to any Maven phase (like `deploy` or `install`)
* Simple integration using server credentials from `settings.xml`
* Fine-grained control over what files are transferred (via `includes`, `excludes`, `fromDir`, etc.)

**Syntax**

```xml
<plugin>
    <groupId>org.codehaus.mojo</groupId>
    <artifactId>wagon-maven-plugin</artifactId>
    <version>2.0.0</version>
</plugin>

// Deploying to an FTP Server. This uploads my-app.jar to an FTP server.
<execution>
    <goals>
        <goal>upload</goal>
    </goals>
    <configuration>
        <url>ftp://ftp.example.com/deploy/</url>
        <fromFile>target/my-app.jar</fromFile>
        <toFile>my-app.jar</toFile>
    </configuration>
</execution>

```

**Configuration Options**

| Configuration | Description             | Default  |
| ------------- | ----------------------- | -------- |
| `url`         | Remote location URL     | Required |
| `fromFile`    | Local file to upload    | Required |
| `toFile`      | Remote destination file | Required |

### `maven-scm-plugin`

The `maven-scm-plugin` provides integration with **Git, SVN, Mercurial, CVS**, and other SCM tools for tagging and releasing.

**Syntax**

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-scm-plugin</artifactId>
    <version>1.11.2</version>
</plugin>

// Tagging a Release in Git. This creates a Git tag (v1.0.0) for the current project.
mvn scm:tag -Dtag=v1.0.0
```

**Configuration Options**

| Configuration            | Description        | Default  |
| ------------------------ | ------------------ | -------- |
| `connectionUrl`          | SCM repository URL | Required |
| `developerConnectionUrl` | SCM developer URL  | Required |
| `tagBase`                | Base tag URL       | Optional |

### `maven-release-plugin`

The `maven-release-plugin` automates the **release process**, including versioning, tagging, and deployment.

**Syntax**

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-release-plugin</artifactId>
    <version>3.0.0-M8</version>
</plugin>
```

{% hint style="info" %}
**Running the Release Process**

```sh
mvn release:prepare
mvn release:perform
```

This process:

1. Updates the version in `pom.xml`
2. Tags the code in SCM
3. Deploys the release artifact
{% endhint %}

**Configuration Options**

<table><thead><tr><th width="184">Configuration</th><th>Description</th><th>Default</th></tr></thead><tbody><tr><td><code>tagNameFormat</code></td><td>Format for tags</td><td><code>project.artifactId-version</code></td></tr><tr><td><code>releaseProfiles</code></td><td>Additional Maven profiles to use</td><td><code>None</code></td></tr></tbody></table>

## 5. Clean & Site Plugins

`maven-clean-plugin`

The `maven-clean-plugin` is responsible for **removing the `target/` directory** created during the build. This ensures that stale or obsolete files don’t affect the next build process.

> Deletes all files generated by the previous build in the `target/` directory.

```bash
mvn clean
```

**Syntax**

```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-clean-plugin</artifactId>
  <version>3.3.1</version>
</plugin>

// Clean Additional Directory
<configuration>
  <filesets>
    <fileset>
      <directory>${project.basedir}/logs</directory>
    </fileset>
  </filesets>
</configuration>
```

Configuration Options

<table><thead><tr><th width="262.35546875">Configuration</th><th width="397.1875">Description</th><th>Default</th></tr></thead><tbody><tr><td><code>filesets</code></td><td>Allows you to specify additional files/folders to delete</td><td>None</td></tr><tr><td><code>excludeDefaultDirectories</code></td><td>If <code>true</code>, does not delete the default <code>target/</code> dir</td><td><code>false</code></td></tr></tbody></table>

### `maven-site-plugin`

The `maven-site-plugin` is used to **generate a complete website** for your project using metadata from the `pom.xml` and additional documentation resources (Markdown, APT, etc.).

> Generates HTML pages for project reports, Javadoc, changelogs, dependency reports, etc.

Use

```bash
mvn site
```

This creates the site in `target/site/index.html`.

Syntax

```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-site-plugin</artifactId>
  <version>4.0.0-M9</version>
</plugin>

// Customize Site Output Directory
<configuration>
  <outputDirectory>${project.build.directory}/custom-site</outputDirectory>
</configuration>
```

Configuration Options

<table><thead><tr><th width="187.75">Configuration</th><th width="372.08984375">Description</th><th>Default</th></tr></thead><tbody><tr><td><code>reportPlugins</code></td><td>Specifies which reporting plugins to include</td><td>Default reports</td></tr><tr><td><code>outputDirectory</code></td><td>Directory where site files will be generated</td><td><code>target/site</code></td></tr><tr><td><code>inputEncoding</code></td><td>File encoding</td><td><code>UTF-8</code></td></tr></tbody></table>
