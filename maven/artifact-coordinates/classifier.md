# Classifier

## About

The `<classifier>` element in Maven is an optional part of artifact coordinates. It is used to **distinguish artifacts** that are built from the same project but serve different purposes.

The classifier adds an extra label to the artifact name and allows us to **attach and retrieve alternate artifacts**, such as source code, documentation, or test versions, without changing the main artifact details.

Maven projects may need to generate or consume more than one artifact from the same codebase. Using a classifier helps:

* Identify different types of outputs (e.g., main JAR, test JAR, source JAR)
* Separate OS-specific or environment-specific builds
* Attach custom builds in CI/CD pipelines

### Coordinate Format

An artifact with a classifier has this format:

```
<groupId>:<artifactId>:<version>:<classifier>
```

Example:

```
com.example:utility-lib:1.0.0:sources
```

This refers to the **sources JAR** of version `1.0.0` of `utility-lib`.

## 1. classifier - sources

#### What It Means

The `sources` classifier is used to publish or consume a JAR file that contains the **source code** of a Maven project. This is typically used to:

* Make the source code available to developers using the library.
* Enable IDE features like "Go to definition", "View source", and debugging inside dependencies.
* Improve traceability and code visibility during integration or support.

#### When to Use

We use the `sources` classifier when:

* We are publishing a library and want to include the readable `.java` source files for other developers.
* We are consuming a dependency and want to download and attach its source code (commonly done by IDEs).
* We want to debug into external library code.

#### How It Works

-> Without Classifier

Maven typically builds and installs:

```
my-lib-1.0.0.jar  → Compiled .class files
```

-> With `sources` Classifier

An additional artifact is created:

```
my-lib-1.0.0-sources.jar  → Contains .java source files
```

Both are deployed to the Maven repository, and the sources JAR can be retrieved using the classifier.



### Publishing Sources with Maven

#### Step 1: Use `maven-source-plugin`

This plugin creates a separate JAR that contains all `.java` source files.

```xml
<build>
  <plugins>
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-source-plugin</artifactId>
      <version>3.2.1</version>
      <executions>
        <execution>
          <id>attach-sources</id>
          <phase>verify</phase>
          <goals>
            <goal>jar</goal>
          </goals>
        </execution>
      </executions>
    </plugin>
  </plugins>
</build>
```

This will generate a `my-lib-1.0.0-sources.jar` in the `target/` directory and attach it to the build.

#### Step 2: Install or Deploy

To install to local repository:

```sh
mvn clean install
```

To deploy to remote repository:

```sh
mvn clean deploy
```

Both the main JAR and the sources JAR will be uploaded.

### Consuming Source JAR in Another Project

To explicitly add the source JAR via classifier:

```xml
<dependency>
  <groupId>com.example</groupId>
  <artifactId>my-lib</artifactId>
  <version>1.0.0</version>
  <classifier>sources</classifier>
</dependency>
```

This will only bring in the `my-lib-1.0.0-sources.jar` and **not** the compiled classes.

> Note: In real-world use, developers rarely add the `sources` JAR manually. IDEs like IntelliJ and Eclipse auto-fetch them if available.

## 2. classifier - classes

#### What It Means

The `classes` classifier is used to **generate and attach a JAR containing only the compiled `.class` files**, excluding other resources, metadata, or bundled dependencies. It differs from the default JAR in that it:

* Does **not include `META-INF/`, `resources/`, or other files** from `src/main/resources`
* Is typically used when we need a **pure bytecode-only** output

#### When to Use

We might use `classifier=classes` when:

* We need just the compiled classes to embed or bundle elsewhere.
* We are creating multiple variants of our artifact for a framework or platform.
* We are building a custom artifact (e.g., a stripped-down version without resources or META-INF).
* We are developing a multi-module project where some modules only need raw `.class` files from others (e.g., code generators, transformation tools).

#### How It Works

Standard Build Output

By default, Maven creates:

```
my-lib-1.0.0.jar  → Includes compiled .class files + resources + META-INF
```

With `classifier=classes`

It creates:

```
my-lib-1.0.0-classes.jar  → Only compiled .class files from /target/classes
```

### How to Generate a `classes` JAR

#### Step 1: Use `maven-jar-plugin` to attach a `classes` JAR

```xml
<build>
  <plugins>
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-jar-plugin</artifactId>
      <version>3.3.0</version>
      <executions>
        <execution>
          <id>attach-classes-jar</id>
          <phase>package</phase>
          <goals>
            <goal>jar</goal>
          </goals>
          <configuration>
            <classifier>classes</classifier>
            <includes>
              <include>**/*.class</include>
            </includes>
            <excludes>
              <exclude>META-INF/**</exclude>
            </excludes>
          </configuration>
        </execution>
      </executions>
    </plugin>
  </plugins>
</build>
```

#### Step 2: Run the build

```sh
mvn clean package
```

The `target/` directory will contain:

* `my-lib-1.0.0.jar` (default)
* `my-lib-1.0.0-classes.jar` (only `.class` files)

### Consuming the `classes` JAR

If another module or project wants to depend only on the `.class` content, it can declare:

```xml
<dependency>
  <groupId>com.example</groupId>
  <artifactId>my-lib</artifactId>
  <version>1.0.0</version>
  <classifier>classes</classifier>
</dependency>
```

This brings in only the stripped-down compiled code.

## 3. classifier - api

#### What It Means

The `api` classifier is used to attach a **JAR containing API specification files**—most commonly OpenAPI (Swagger) YAML or JSON files. It allows developers to:

* Distribute machine-readable API contracts independently of the main code.
* Enable clients or consumers to generate client SDKs.
* Share API definition artifacts in CI/CD pipelines.
* Version API contracts separately from the implementation logic.

#### When to Use

Use `classifier=api` when:

* We want to publish an **OpenAPI spec** (`openapi.yaml`, `openapi.json`) as a standalone artifact.
* We are working in a **contract-first** or **API-first** architecture.
* We have multiple teams where one team owns the API and another consumes it.
* We want to let consumers generate clients using tools like Swagger Codegen or OpenAPI Generator.

#### How It Works

Standard Build Output

By default, Maven creates:

```
my-service-1.0.0.jar → Application classes and resources
```

With `classifier=api`

We generate an additional artifact:

```
my-service-1.0.0-api.jar → Contains only OpenAPI spec files (e.g., openapi.yaml)
```

This allows publishing and versioning the API specification alongside the service, but independently usable.

### How to Generate an `api` JAR

We manually or automatically place OpenAPI spec files (like `openapi.yaml`) under a known directory, and attach them using the `maven-jar-plugin`.

#### Step 1: Place API Spec in a Directory

Place our OpenAPI file at:

```
src/main/api/openapi.yaml
```

#### Step 2: Configure `maven-jar-plugin` to attach it

```xml
<build>
  <plugins>
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-jar-plugin</artifactId>
      <version>3.3.0</version>
      <executions>
        <execution>
          <id>attach-api-jar</id>
          <phase>package</phase>
          <goals>
            <goal>jar</goal>
          </goals>
          <configuration>
            <classifier>api</classifier>
            <includes>
              <include>**/*.yaml</include>
              <include>**/*.yml</include>
              <include>**/*.json</include>
            </includes>
            <basedir>${project.basedir}/src/main/api</basedir>
          </configuration>
        </execution>
      </executions>
    </plugin>
  </plugins>
</build>
```

This tells Maven to package the API files from `src/main/api` into a JAR with the `api` classifier.

#### Step 3: Run the Build

```sh
mvn clean package
```

Output:

* `target/my-service-1.0.0.jar` → default application JAR
* `target/my-service-1.0.0-api.jar` → contains only `openapi.yaml` or similar

### Consuming the API Spec in Another Project

Other teams or modules can now depend on the published API artifact:

```xml
<dependency>
  <groupId>com.mycompany.services</groupId>
  <artifactId>my-service</artifactId>
  <version>1.0.0</version>
  <classifier>api</classifier>
</dependency>
```

This can be used by:

* Code generation tools to build client stubs
* API documentation sites
* Linter/contract validator plugins in CI

## 4. classifier - javadoc

#### What It Means

The `javadoc` classifier is used to attach a separate JAR that contains **Javadoc-generated HTML documentation** for a project’s public API. This classifier allows developers to:

* Publish human-readable API documentation as a separate artifact.
* Let consuming developers explore classes and methods directly in IDEs.
* Maintain documentation versioned alongside the codebase.

#### When to Use

Use the `javadoc` classifier when:

* We want to distribute HTML documentation for a library.
* We are building a reusable SDK or module used by other teams.
* We want documentation to be browsable inside IDEs or on artifact repository websites.
* We want to expose a stable API to external clients while hiding implementation details.

#### How It Works

Without Classifier

Standard Maven build produces:

```
my-lib-1.0.0.jar → compiled code + resources
```

With `classifier=javadoc`

We generate an additional artifact:

```
my-lib-1.0.0-javadoc.jar → contains `index.html` and related Javadoc files
```

This artifact can be attached and deployed along with the main JAR.

### How to Generate a Javadoc JAR

#### Step 1: Use the `maven-javadoc-plugin`

Add the following plugin to our `pom.xml`:

```xml
<build>
  <plugins>
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-javadoc-plugin</artifactId>
      <version>3.6.3</version>
      <executions>
        <execution>
          <id>attach-javadoc</id>
          <goals>
            <goal>jar</goal>
          </goals>
          <phase>verify</phase>
        </execution>
      </executions>
    </plugin>
  </plugins>
</build>
```

This tells Maven to generate Javadoc and attach it as a JAR with classifier `javadoc`.

#### Step 2: Run the Build

```sh
mvn clean verify
```

Output in the `target/` directory:

* `my-lib-1.0.0.jar` → compiled application/library
* `my-lib-1.0.0-javadoc.jar` → generated API docs

### Consuming the Javadoc JAR

To explicitly include the Javadoc artifact:

```xml
<dependency>
  <groupId>com.example</groupId>
  <artifactId>my-lib</artifactId>
  <version>1.0.0</version>
  <classifier>javadoc</classifier>
</dependency>
```

> Note: In practice, developers rarely add this manually. Tools like IntelliJ IDEA and Eclipse auto-download the Javadoc if available in the repository.



## 5. classifier - tests

#### What It Means

The `tests` classifier is used to package and attach a JAR that contains the **compiled test classes** (usually from `src/test/java`). This allows us to:

* Share common test utilities and base classes between modules.
* Create dedicated test libraries reused across projects.
* Enable integration tests or functional tests to depend on unit test components of another module.

This JAR is not built by default in Maven and requires manual configuration.

#### When to Use

Use `classifier=tests` when:

* We have **reusable test utilities**, base test classes, or mocks needed in other modules.
* We are creating a **shared testing framework** for an internal team.
* We want to isolate test logic from production logic but still distribute it.
* We are testing libraries that require simulation or shared mock data.

#### How It Works

Normal Maven Build

Produces:

```
my-lib-1.0.0.jar → compiled main classes only
```

With `classifier=tests`

We generate:

```
my-lib-1.0.0-tests.jar → compiled test classes from `src/test/java`
```

This allows other projects to include test code separately from production code.

### How to Generate a Test JAR

#### Step 1: Use `maven-jar-plugin`

Add the following plugin configuration to `pom.xml`:

```xml
<build>
  <plugins>
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-jar-plugin</artifactId>
      <version>3.3.0</version>
      <executions>
        <execution>
          <id>attach-tests</id>
          <goals>
            <goal>test-jar</goal>
          </goals>
        </execution>
      </executions>
    </plugin>
  </plugins>
</build>
```

This will create a JAR from the `src/test/java` directory and attach it with the `tests` classifier.

#### Step 2: Run the Build

```sh
mvn clean package
```

We’ll now see in the `target/` directory:

* `my-lib-1.0.0.jar` → main compiled code
* `my-lib-1.0.0-tests.jar` → compiled test classes only

### Consuming the Test JAR in Another Module

Another module that wants to reuse the test classes can add a dependency like:

```xml
<dependency>
  <groupId>com.example</groupId>
  <artifactId>my-lib</artifactId>
  <version>1.0.0</version>
  <classifier>tests</classifier>
  <scope>test</scope>
</dependency>
```

* The `scope` should be set to `test` to avoid this code leaking into production classpath.
* Maven will resolve and include the test-only JAR during test compilation of the consuming module.



## 6. classifier - platform-specific

#### What It Means

The platform-specific classifier is used to publish **artifacts targeted for a specific operating system or hardware architecture**. It allows us to:

* Deliver native binaries (`.so`, `.dll`, `.dylib`) tailored to a platform.
* Provide different configurations or compiled results per platform.
* Maintain consistent artifact coordinates across platforms while delivering different contents.

This classifier is often used in:

* JNI (Java Native Interface) bindings
* Cross-platform CLI tools
* Embedded systems
* Libraries that integrate with native SDKs or drivers

#### When to Use

Use platform-specific classifiers when:

* We build and package **different binaries** per platform (e.g., Linux vs. Windows vs. macOS).
* We Java code wraps native libraries using **JNI or JNA**.
* Our app requires platform-specific launchers or shell scripts.
* We distribute executable wrappers like `.exe`, `.sh`, `.bat`.

#### How It Works

Let’s say our project `image-processor` builds a shared native library using C/C++ and JNI. We compile this native library separately for:

* Linux (x86\_64)
* macOS (ARM64)
* Windows (x64)

We package each output as a separate artifact with a unique classifier:

```
image-processor-1.0.0-linux-x86_64.jar
image-processor-1.0.0-mac-arm64.jar
image-processor-1.0.0-windows-x64.jar
```

All these have the same groupId, artifactId, and version, but differ in classifier.

### How to Build and Attach Platform-Specific Artifacts

#### Step 1: Build native libraries for each platform

We typically do this using external build tools like:

* CMake
* Gradle with JNI support
* Docker (for cross-compilation)

Let’s assume each native binary is named:

* `libimageproc.so` for Linux
* `libimageproc.dylib` for macOS
* `imageproc.dll` for Windows

#### Step 2: Place the binary in a custom directory, like:

```
src/main/native/linux-x86_64/
src/main/native/mac-arm64/
src/main/native/windows-x64/
```

#### Step 3: Configure `maven-jar-plugin` for each classifier

We can use Maven profiles to create different platform-specific JARs:

```xml
<profiles>
  <profile>
    <id>linux-x86_64</id>
    <build>
      <plugins>
        <plugin>
          <groupId>org.apache.maven.plugins</groupId>
          <artifactId>maven-jar-plugin</artifactId>
          <version>3.3.0</version>
          <executions>
            <execution>
              <id>attach-linux</id>
              <phase>package</phase>
              <goals>
                <goal>jar</goal>
              </goals>
              <configuration>
                <classifier>linux-x86_64</classifier>
                <basedir>${project.basedir}/src/main/native/linux-x86_64</basedir>
              </configuration>
            </execution>
          </executions>
        </plugin>
      </plugins>
    </build>
  </profile>
</profiles>
```

Repeat for other platforms (mac-arm64, windows-x64) using separate profiles.

#### Step 4: Build each classifier version

```sh
mvn clean package -Plinux-x86_64
mvn clean package -Pmac-arm64
mvn clean package -Pwindows-x64
```

Each command generates a different artifact with a platform-specific classifier.

### Consuming Platform-Specific Artifact

In another project, depending on the runtime platform, use the appropriate dependency:

```xml
<dependency>
  <groupId>com.example</groupId>
  <artifactId>image-processor</artifactId>
  <version>1.0.0</version>
  <classifier>linux-x86_64</classifier>
</dependency>
```

To make this dynamic, we can write platform-detection logic or let our CI/CD or packaging tool resolve the correct artifact based on OS.
