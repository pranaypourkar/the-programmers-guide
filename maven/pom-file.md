# POM File

## About

In Maven, the **Project Object Model** (`pom.xml`) is the heart of our build system. It defines _what our project is_, _how it should be built_, _what it depends on_, and _how it interacts with the Maven ecosystem_.

While small projects may use a minimal `pom.xml`, larger and enterprise projects often have highly structured POMs that handle:

* Dependency management
* Build configuration
* Multi-module orchestration
* Profiles for environment-specific builds

Understanding its structure means understanding **how Maven thinks about projects** and that’s the first step toward mastering Maven.

## Sample POM File

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
                             https://maven.apache.org/xsd/maven-4.0.0.xsd">

    <!-- ===== Model Version ===== -->
    <modelVersion>4.0.0</modelVersion>

    <!-- ===== Project Coordinates ===== -->
    <groupId>com.example</groupId>
    <artifactId>sample-app</artifactId>
    <version>1.0.0-SNAPSHOT</version>
    <packaging>jar</packaging>

    <!-- ===== Project Metadata ===== -->
    <name>Sample Maven Application</name>
    <description>An example project demonstrating all POM sections</description>
    <url>https://example.com/sample-app</url>

    <!-- ===== Parent POM ===== -->
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.1.1</version>
        <relativePath/> <!-- Look up parent from repository -->
    </parent>

    <!-- ===== Properties ===== -->
    <properties>
        <java.version>17</java.version>
        <maven.compiler.source>${java.version}</maven.compiler.source>
        <maven.compiler.target>${java.version}</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <maven.build.timestamp.format>yyyy-MM-dd HH:mm:ss</maven.build.timestamp.format>
    </properties>

    <!-- ===== Dependency Management ===== -->
    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>com.fasterxml.jackson.core</groupId>
                <artifactId>jackson-databind</artifactId>
                <version>2.15.0</version>
            </dependency>
        </dependencies>
    </dependencyManagement>

    <!-- ===== Dependencies ===== -->
    <dependencies>
        <!-- Spring Boot Web -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

        <!-- Lombok -->
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>

        <!-- Testing -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <!-- ===== Build Configuration ===== -->
    <build>
        <finalName>${project.artifactId}-${project.version}</finalName>
        <sourceDirectory>src/main/java</sourceDirectory>
        <testSourceDirectory>src/test/java</testSourceDirectory>

        <!-- Plugins -->
        <plugins>
            <!-- Compiler Plugin -->
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.11.0</version>
                <configuration>
                    <source>${java.version}</source>
                    <target>${java.version}</target>
                </configuration>
            </plugin>

            <!-- Surefire Plugin (Unit Testing) -->
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-plugin</artifactId>
                <version>3.1.2</version>
                <configuration>
                    <skipTests>false</skipTests>
                </configuration>
            </plugin>

            <!-- JAR Plugin (Custom Manifest) -->
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-jar-plugin</artifactId>
                <version>3.3.0</version>
                <configuration>
                    <archive>
                        <manifest>
                            <mainClass>com.example.MainApplication</mainClass>
                        </manifest>
                    </archive>
                </configuration>
            </plugin>
        </plugins>
    </build>

    <!-- ===== Repositories ===== -->
    <repositories>
        <repository>
            <id>central</id>
            <name>Maven Central Repository</name>
            <url>https://repo1.maven.org/maven2/</url>
        </repository>
    </repositories>

    <!-- ===== Plugin Repositories ===== -->
    <pluginRepositories>
        <pluginRepository>
            <id>central</id>
            <name>Maven Central Plugins</name>
            <url>https://repo1.maven.org/maven2/</url>
        </pluginRepository>
    </pluginRepositories>

    <!-- ===== Profiles ===== -->
    <profiles>
        <!-- Development Profile -->
        <profile>
            <id>dev</id>
            <activation>
                <activeByDefault>true</activeByDefault>
            </activation>
            <properties>
                <maven.compiler.debug>true</maven.compiler.debug>
            </properties>
        </profile>

        <!-- Production Profile -->
        <profile>
            <id>prod</id>
            <properties>
                <maven.compiler.debug>false</maven.compiler.debug>
            </properties>
        </profile>
    </profiles>

    <!-- ===== Modules (Multi-module projects) ===== -->
    <modules>
        <module>service-module</module>
        <module>web-module</module>
    </modules>

</project>
```

## **The `<project>` Root Element**

In Maven, **every POM must start** with a `<project>` element.\
This is the _container_ for **all other POM elements** - think of it as the root of the Maven configuration tree.

From our sample file:

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
                             https://maven.apache.org/xsd/maven-4.0.0.xsd">
```

#### **A. The `xmlns` Attribute**

```xml
xmlns="http://maven.apache.org/POM/4.0.0"
```

* Defines the default XML namespace for Maven’s POM schema.
* Ensures Maven interprets elements like `<groupId>` and `<version>` according to **POM 4.0.0 rules**.
* Without this, Maven could throw parsing errors or misinterpret elements.

#### **B. The `xmlns:xsi` Attribute**

```xml
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
```

* This namespace is not Maven-specific — it’s an **XML Schema Instance** namespace from W3C.
* It enables the use of `xsi:schemaLocation` in XML files to tell tools where to find the schema definition.

#### **C. The `xsi:schemaLocation` Attribute**

```xml
xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
                    https://maven.apache.org/xsd/maven-4.0.0.xsd"
```

* Maps the **Maven namespace** to the actual **XSD file** that describes POM structure.
* The first part:\
  `http://maven.apache.org/POM/4.0.0` — the namespace URI.
* The second part:\
  `https://maven.apache.org/xsd/maven-4.0.0.xsd` — the location of the XML Schema Definition (XSD) for Maven POM.

When tools like IntelliJ or Eclipse read our `pom.xml`, they use this schema to:

* Validate if elements are correct
* Show autocomplete suggestions
* Catch typos or misplaced elements before build time

#### **D. Closing the `<project>` Tag**

After defining namespaces, the `<project>` tag is not closed immediately instead, it wraps all other POM sections until the very end:

```xml
</project>
```

#### **E. Why This Section Matters ?**

* Without a proper `<project>` root with namespaces, Maven **won’t recognize our file as a valid POM**.
* Proper namespace/schema definitions ensure:
  * IDE support (syntax highlighting, code completion)
  * Validation before build
  * Compatibility with Maven 3.x and above

## **The `<modelVersion>` Element**

From our sample:

```xml
<modelVersion>4.0.0</modelVersion>
```

#### **A. Purpose**

* Defines **which version of the Project Object Model (POM)** we are using.
* Ensures Maven knows **how to interpret** the structure and available elements in our POM.

#### **B. Current Value**

* **Always `4.0.0`** for Maven 2, Maven 3, and Maven 4 (as of now).
* This version number hasn’t changed for years because:
  * The POM structure has remained stable.
  * Backward compatibility is a **core principle** in Maven.

#### **C. Historical Context**

* Maven 1.x had a different POM format (no `<modelVersion>` at all).
* When Maven 2 was released, they introduced **POM v4.0.0** to unify how build configuration was defined.
* Future changes (if Maven 5 introduces POM v5.0.0) would require updating this field.

#### **D. What Happens if We Change It ?**

*   If we set it to something unsupported, Maven will throw:

    ```
    Non-parseable POM
    ```
* This is one of the very few **non-optional** POM elements.

#### **E. Best Practice**

* Keep it **as the very first child** of `<project>`.
*   Always use:

    ```xml
    <modelVersion>4.0.0</modelVersion>
    ```
* Don’t remove it, even though Maven might sometimes seem to work without it in IDE-generated POMs.

## **Project Coordinates**

From our sample POM:

```xml
<groupId>com.example</groupId>
<artifactId>sample-app</artifactId>
<version>1.0.0-SNAPSHOT</version>
<packaging>jar</packaging>
```

These four elements tell Maven:

* **What** our project is called
* **Who** owns it
* **Which** version is being built
* **What type** of artifact is produced

They are collectively known as **GAV** (GroupId, ArtifactId, Version) + **Packaging**.

#### **A. `<groupId>`**

* Defines the **organization or group** that produces the project.
* Usually follows **reverse domain naming**:
  * Example: `com.google.guava`
  * For internal projects: `com.companyname.project`
* It ensures **global uniqueness** in repositories.

**Why reverse domain ?**

* Domains are unique to an organization, so reversing them avoids clashes.
* Example: `com.example` → no other company will accidentally use our namespace.

#### **B. `<artifactId>`**

* The **name of the built artifact** (without version or extension).
* Together with `groupId`, it must be unique.
* Examples:
  * `spring-core`
  * `hibernate-entitymanager`
  * `sample-app`
*   When packaged, Maven appends:

    ```
    <artifactId>-<version>.<packaging>
    ```

    Example:

    ```
    sample-app-1.0.0-SNAPSHOT.jar
    ```

#### **C. `<version>`**

* The **current version** of the project.
* **Formats**:
  * Release: `1.0.0`, `2.1.5`
  * Snapshot: `1.0.0-SNAPSHOT`
* **Snapshot** means:
  * Work in progress
  * Can change without notice
  * Maven won’t cache aggressively — it checks for updates on each build
* **Release** means:
  * Immutable
  * Stored permanently in repository without overwriting

{% hint style="success" %}
Always use SNAPSHOT during development, and set a proper release version before publishing.
{% endhint %}

#### **D. `<packaging>`**

* Defines the **type of artifact** Maven should create.
* Common values:
  * `jar` — Java library
  * `war` — Web application
  * `pom` — Parent or aggregator POM
  * `ear` — Enterprise Archive
  * `rar` — Resource Adapter Archive
* If omitted, **defaults to `jar`**.

#### **E. How Maven Uses GAV ?**

Maven stores artifacts in the repository structure:

```
~/.m2/repository/<groupId path>/<artifactId>/<version>/<artifactId>-<version>.<packaging>
```

Example for our sample:

```
~/.m2/repository/com/example/sample-app/1.0.0-SNAPSHOT/sample-app-1.0.0-SNAPSHOT.jar
```

#### **F. Best Practices**

1. **Uniqueness**: Ensure `groupId` + `artifactId` combination is unique across all repositories we publish to.
2. **Semantic Versioning**: Use `MAJOR.MINOR.PATCH` format for versions.
3. **Packaging Consistency**: Keep packaging type aligned with project type (don’t package a web app as `jar` unless using Spring Boot’s embedded server).

## **Project Metadata**

From our sample:

```xml
<name>Sample Maven Application</name>
<description>An example project demonstrating all POM sections</description>
<url>https://example.com/sample-app</url>
```

#### **A. `<name>`**

* A **readable project name** — not necessarily the same as `artifactId`.
* Appears in:
  * Generated project documentation (`mvn site`)
  * IDE displays
  * Maven Central listings
*   Example:

    ```xml
    <name>Apache Commons IO</name>
    ```

    vs.

    ```xml
    <artifactId>commons-io</artifactId>
    ```

#### **B. `<description>`**

* A **one- or two-line summary** of our project’s purpose.
* Visible in generated Maven reports, repository browsers, and artifact search tools.
* Should be:
  * **Clear** — avoid jargon unless our audience knows it
  * **Concise** — a few sentences at most
*   Example:

    ```xml
    <description>A utility library for working with IO in Java</description>
    ```

#### **C. `<url>`**

* The official **homepage or documentation URL** for the project.
* Can point to:
  * Project website
  * GitHub repository
  * Internal wiki (for private projects)
*   Example:

    ```xml
    <url>https://github.com/apache/commons-io</url>
    ```

#### **D. Why Metadata Matters ?**

1. **Discoverability** — if someone finds our artifact on Maven Central, they should immediately know what it does and where to learn more.
2. **Documentation Integration** — Maven site plugins and reporting tools pull these values automatically.
3. **Team Communication** — in large organizations, metadata helps new developers quickly grasp project purpose.

#### **E. Best Practices**

* **Always include `<name>` and `<description>`** even in private/internal projects - future maintainers will thank us.
* Keep `<url>` up to date. Nothing says “abandoned” like a broken homepage link.
* Treat this like a business card for our artifact.

## **The `<parent>` Section**

From our sample:

```xml
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>3.1.1</version>
    <relativePath/> <!-- Look up parent from repository -->
</parent>
```

#### **A. Purpose**

The `<parent>` element allows our project to **inherit**:

* Dependency versions
* Plugin configurations
* Properties
* Build settings

Instead of redefining them in every project, we can define them once in a **parent POM** and let child POMs inherit them.

#### **B. Structure**

1. **`<groupId>`**\
   The parent project’s group ID.
2. **`<artifactId>`**\
   The parent project’s artifact ID.
3. **`<version>`**\
   The parent POM’s version we want to use.
4. **`<relativePath>`** _(optional)_
   * If the parent POM is in our local filesystem (multi-module build), Maven uses this path to locate it.
   * Default: `../pom.xml`
   * Setting it to empty (`<relativePath/>`) forces Maven to look in the repository instead.

#### **C. How Inheritance Works ?**

* If the child POM **omits** certain elements (like `<properties>`, `<dependencyManagement>`, `<build>`), Maven will **merge** them from the parent POM.
* If the child **redefines** an element, it **overrides** the parent’s value.
* We can even have **multi-level inheritance** (parent → grandparent POM).

#### **D. Real-World Examples**

* **Spring Boot** uses `spring-boot-starter-parent` to:
  * Predefine common dependency versions (BOM style)
  * Configure compiler & test plugins
  * Set default encoding, resource filtering, etc.
* Large organizations create **internal parent POMs** to enforce:
  * Coding standards (plugin rules)
  * Common logging frameworks
  * Unified dependency versions

#### **E. Inheritance vs. Aggregation**

* **Inheritance** (`<parent>`) — share configuration; child still builds independently.
* **Aggregation** (`<modules>`) — build multiple modules in one go; no automatic config sharing unless they also share a parent.

#### **F. Best Practices**

* If using a parent from a public framework (like Spring Boot), **always match versions carefully** with the framework we are using.
* For internal projects, create a **custom parent POM** for consistency across all microservices/libraries.
* Avoid deep inheritance chains — they make troubleshooting difficult.

## **The `<properties>` Section**

From our sample:

```xml
<properties>
    <java.version>17</java.version>
    <maven.compiler.source>${java.version}</maven.compiler.source>
    <maven.compiler.target>${java.version}</maven.compiler.target>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <maven.build.timestamp.format>yyyy-MM-dd HH:mm:ss</maven.build.timestamp.format>
</properties>
```

#### **A. Purpose**

* Defines **custom variables** that can be reused throughout the POM.
* Makes the configuration **more maintainable** and **less repetitive**.
* Allows for **centralized updates** — change one property, and it updates everywhere it’s used.

#### **B. How Properties Work ?**

* We reference a property with `${propertyName}`.
* Maven **interpolates** (replaces) these placeholders **before** executing the build.
* Properties can:
  * Be **custom-defined** in `<properties>`
  * Come from Maven itself (built-in)
  * Be passed via CLI (`mvn clean install -Dproperty=value`)

#### **C. Common Use Cases**

1.  **Java version settings**

    ```xml
    <java.version>17</java.version>
    ```

    Used by compiler and other plugins.
2.  **Encoding**

    ```xml
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    ```
3.  **Timestamp formatting**

    ```xml
    <maven.build.timestamp.format>yyyy-MM-dd HH:mm:ss</maven.build.timestamp.format>
    ```
4.  **Plugin or dependency versions**

    ```xml
    <spring.boot.version>3.1.1</spring.boot.version>
    ```

    Then:

    ```xml
    <version>${spring.boot.version}</version>
    ```

#### **D. Built-In Maven Properties**

Maven comes with predefined variables we can use without declaring them:

* `${basedir}` — root directory of the project
* `${project.version}` — version from `<version>` tag
* `${project.build.directory}` — usually `target`
* `${settings.localRepository}` — path to local repo (`~/.m2/repository`)
* `${java.home}` — path to Java installation

#### **E. CLI-Defined Properties**

We can override or add properties at runtime:

```bash
mvn clean package -Djava.version=21
```

This will temporarily set `${java.version}` to `21` for that build.

#### **F. Best Practices**

1. **Centralize versions** in `<properties>` — avoids “version drift” in dependencies/plugins.
2. Use **meaningful names** for custom properties — avoid overly generic names like `<version>`.
3. Don’t hardcode Java or encoding values in multiple places — use a single property reference.
4. Be cautious with **overriding** properties via CLI in CI/CD — it can cause inconsistent builds if not documented.

## **The `<dependencyManagement>` Section**

From our sample:

```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
            <version>3.1.1</version>
        </dependency>
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <version>1.18.28</version>
        </dependency>
    </dependencies>
</dependencyManagement>
```

#### **A. Purpose**

* Acts like a **version control center** for dependencies.
* Lets us **declare versions once** and reuse them across multiple modules **without repeating the version each time**.
* Especially useful in **multi-module projects**.

#### **B. How It Works ?**

* Dependencies inside `<dependencyManagement>` **are not automatically included** in the build.
* They **only define defaults** for:
  * `version`
  * `scope`
  * `exclusions`
* To actually use them, we **still declare** them in `<dependencies>` — but without the version.

**Example:**

```xml
<!-- In parent POM -->
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
            <version>3.1.1</version>
        </dependency>
    </dependencies>
</dependencyManagement>

<!-- In child POM -->
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
        <!-- No version needed -->
    </dependency>
</dependencies>
```

Maven will automatically inject `3.1.1` from the parent.

#### **C. Benefits**

1. **Consistency** — no accidental version mismatches between modules.
2. **Centralized updates** — bump a version in one place, all modules get it.
3. **Cleaner child POMs** — less duplication, more readable.

#### **D. Typical Uses**

* **Multi-module projects** — Parent POM defines versions, child POMs just declare dependencies without versions.
* **BOM (Bill of Materials) imports** — Import another project’s dependency versions (e.g., Spring Boot’s BOM).

**Example of BOM import:**

```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-dependencies</artifactId>
            <version>3.1.1</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```

This imports **all** managed versions from Spring Boot’s BOM.

#### **E. Best Practices**

* Keep `<dependencyManagement>` only in **parent POMs** — avoid in regular modules unless they’re BOMs themselves.
* Avoid mixing managed and unmanaged versions for the same dependency — it creates confusion.
* Prefer BOM imports for large frameworks instead of manually listing every dependency.

## **The `<dependencies>` Section**

From our sample:

```xml
<dependencies>
    <!-- Web framework -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>

    <!-- Lombok for boilerplate code reduction -->
    <dependency>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
        <scope>provided</scope>
    </dependency>

    <!-- Testing library -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-test</artifactId>
        <scope>test</scope>
    </dependency>
</dependencies>
```

#### **A. Purpose**

* Lists all the external and internal libraries our project **depends on**.
* Maven automatically:
  * Downloads them from repositories.
  * Adds them to the classpath.
  * Handles **transitive dependencies** (dependencies of our dependencies).

#### **B. Key Elements**

Each `<dependency>` typically has:

1. **`<groupId>`** — Organization or project namespace.
2. **`<artifactId>`** — Unique name of the library/module.
3. **`<version>`** — The specific release we want.
   * Optional if managed in `<dependencyManagement>` or imported BOM.
4. **`<scope>`** — Defines where the dependency is available (more on this below).
5. **`<optional>`** _(optional)_ — If `true`, not included transitively by projects that depend on us.
6. **`<exclusions>`** _(optional)_ — Used to block unwanted transitive dependencies.

#### **C. Dependency Scopes**

<table data-full-width="true"><thead><tr><th width="154.98828125">Scope</th><th>Available In</th><th>Typical Use Case</th></tr></thead><tbody><tr><td><strong>compile</strong> <em>(default)</em></td><td>All phases (compile, test, runtime)</td><td>Core libraries our app always needs</td></tr><tr><td><strong>provided</strong></td><td>Compile + test, <strong>not</strong> runtime</td><td>Servlet API (container provides it)</td></tr><tr><td><strong>runtime</strong></td><td>Test + runtime, <strong>not</strong> compile</td><td>JDBC driver</td></tr><tr><td><strong>test</strong></td><td>Only in test classpath</td><td>JUnit, Mockito</td></tr><tr><td><strong>system</strong></td><td>Like provided, but requires explicit local path</td><td>Rarely used, for local JARs</td></tr><tr><td><strong>import</strong></td><td>Only in <code>&#x3C;dependencyManagement></code></td><td>For BOM imports</td></tr></tbody></table>

#### **D. Transitive Dependencies**

If our dependency depends on something else, Maven **pulls it in automatically**.\
Example:

* We add `spring-boot-starter-web`
* Maven fetches:
  * Spring MVC
  * Jackson
  * Tomcat
  * And so on...

We can **exclude** unwanted transitive dependencies:

```xml
<dependency>
    <groupId>com.example</groupId>
    <artifactId>library</artifactId>
    <exclusions>
        <exclusion>
            <groupId>commons-logging</groupId>
            <artifactId>commons-logging</artifactId>
        </exclusion>
    </exclusions>
</dependency>
```

#### **E. Best Practices**

* Use **BOM + `<dependencyManagement>`** to avoid repeating versions.
* Be careful with **scope=provided** — using it incorrectly can cause runtime `ClassNotFoundException`.
* Regularly check for **unused dependencies** (`mvn dependency:analyze`).

## **The `<build>` Section**

From our sample:

```xml
<build>
    <finalName>my-app</finalName>

    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-compiler-plugin</artifactId>
            <version>3.11.0</version>
            <configuration>
                <source>${java.version}</source>
                <target>${java.version}</target>
            </configuration>
        </plugin>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-jar-plugin</artifactId>
            <version>3.3.0</version>
            <configuration>
                <archive>
                    <manifest>
                        <addClasspath>true</addClasspath>
                        <mainClass>com.example.MainApp</mainClass>
                    </manifest>
                </archive>
            </configuration>
        </plugin>
    </plugins>
</build>
```

#### **A. Purpose**

* Defines **how Maven builds our project**:
  * Output naming
  * Plugins to run
  * Compiler and packaging settings
  * Directory configurations

#### **B. Key Elements**

**1. `<finalName>`**

* Sets the name of the generated artifact **without extension**.
* Example:
  * `finalName` = `my-app`
  * Packaging = `jar`
  * Output file = `my-app.jar`

**2. `<plugins>`**

* Plugins are **Maven’s workhorses** — they handle compilation, packaging, testing, deployment, etc.
* Inside each `<plugin>`:
  * **`<groupId>`** — Usually `org.apache.maven.plugins` for official plugins.
  * **`<artifactId>`** — Plugin name (e.g., `maven-compiler-plugin`).
  * **`<version>`** — Specific plugin version.
  * **`<configuration>`** — Custom settings for that plugin.

#### **C. Commonly Used Plugins**

1.  **Compiler Plugin**

    ```xml
    <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-compiler-plugin</artifactId>
        <version>3.11.0</version>
        <configuration>
            <source>${java.version}</source>
            <target>${java.version}</target>
        </configuration>
    </plugin>
    ```

    * Controls Java source/target version.
2.  **JAR Plugin**

    ```xml
    <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-jar-plugin</artifactId>
        <version>3.3.0</version>
        <configuration>
            <archive>
                <manifest>
                    <addClasspath>true</addClasspath>
                    <mainClass>com.example.MainApp</mainClass>
                </manifest>
            </archive>
        </configuration>
    </plugin>
    ```

    * Configures how JAR files are packaged and adds metadata.
3.  **Surefire Plugin** (for tests)

    ```xml
    <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-surefire-plugin</artifactId>
        <version>3.1.2</version>
    </plugin>
    ```

#### **D. Advanced Build Customization**

The `<build>` section can also include:

* **`<resources>`** — Non-Java files to include in build.
* **`<testResources>`** — Test-specific resources.
* **`<directory>`** — Change the default output dir (default: `target`).
* **`<filters>`** — Filter resources with property substitution.

Example:

```xml
<resources>
    <resource>
        <directory>src/main/resources</directory>
        <filtering>true</filtering>
    </resource>
</resources>
```

#### **E. Best Practices**

* Always **pin plugin versions** — Maven defaults can change unexpectedly.
* Group related plugin configs together for readability.
* Avoid overloading `pom.xml` with complex plugin logic — use external config files if necessary.
* Keep `<finalName>` meaningful for CI/CD pipelines.

## **The `<profiles>` Section**

From our sample:

```xml
<profiles>
    <profile>
        <id>dev</id>
        <properties>
            <env>development</env>
        </properties>
        <activation>
            <activeByDefault>true</activeByDefault>
        </activation>
        <dependencies>
            <dependency>
                <groupId>org.hsqldb</groupId>
                <artifactId>hsqldb</artifactId>
                <version>2.7.1</version>
                <scope>runtime</scope>
            </dependency>
        </dependencies>
    </profile>

    <profile>
        <id>prod</id>
        <properties>
            <env>production</env>
        </properties>
        <dependencies>
            <dependency>
                <groupId>mysql</groupId>
                <artifactId>mysql-connector-java</artifactId>
                <version>8.0.32</version>
                <scope>runtime</scope>
            </dependency>
        </dependencies>
    </profile>
</profiles>
```

#### **A. Purpose**

* Profiles let us **change Maven’s behavior based on conditions**.
* We can define:
  * Different dependencies
  * Different build plugins
  * Different properties
  * Different resource directories
* Useful for **dev vs test vs prod builds**, or platform-specific settings.

#### **B. Key Elements**

**1. `<id>`**

* Unique profile name.
*   Activated with:

    ```bash
    mvn clean install -Pprod
    ```

**2. `<activation>`**

* Defines conditions for automatic activation:
  * **`<activeByDefault>`** — Always active unless another profile is explicitly chosen.
  * **`<jdk>`** — Activates based on JDK version.
  * **`<os>`** — Activates based on OS name, family, arch, version.
  * **`<property>`** — Activates if a system property is present.
  * **`<file>`** — Activates if a file exists (or not).

Example:

```xml
<activation>
    <property>
        <name>env</name>
        <value>production</value>
    </property>
</activation>
```

**3. Profile-specific sections**

* `<dependencies>` — Add dependencies only for that profile.
* `<build>` — Override or add build settings for that profile.
* `<properties>` — Define environment-specific variables.

#### **C. How Profiles Work**

* **Without profiles** — All settings apply to all builds.
* **With profiles** — Only active profiles’ settings merge into the final build configuration.

Maven merges:

1. Global settings (in `settings.xml`)
2. Active profile settings (from `pom.xml` or `settings.xml`)
3. Command-line arguments

#### **D. Typical Use Cases**

* Switching **database drivers** between dev (HSQLDB) and prod (MySQL).
* Enabling/disabling **debug logging**.
* Using **different Java versions** for builds.
* Packaging different **resource sets**.

#### **E. Best Practices**

* Use profiles for **environmental differences**, not for optional features in the same environment.
* Avoid too many profiles - it can make builds unpredictable.
* Always **document profile purposes** for other developers.

## **The `<repositories>` Section**

Example:

```xml
<repositories>
    <repository>
        <id>central</id>
        <url>https://repo.maven.apache.org/maven2</url>
        <releases>
            <enabled>true</enabled>
        </releases>
        <snapshots>
            <enabled>false</enabled>
        </snapshots>
    </repository>

    <repository>
        <id>jitpack.io</id>
        <url>https://jitpack.io</url>
        <releases>
            <enabled>true</enabled>
        </releases>
        <snapshots>
            <enabled>true</enabled>
        </snapshots>
    </repository>
</repositories>
```

#### **A. Purpose**

* Defines **where Maven should look for dependencies** besides the default Maven Central repository.
* Useful when:
  * Using internal corporate artifact repositories (like Nexus or Artifactory)
  * Using third-party repositories (e.g., JitPack, Spring Milestone)
  * Accessing snapshot versions not in Maven Central

#### **B. Key Elements**

**1. `<id>`**

* Unique identifier for the repository.
* Used in logs, dependency resolution, and possible plugin configs.

**2. `<url>`**

* Repository base URL.
* Must point to a valid Maven repository structure.

**3. `<releases>` and `<snapshots>`**

* Control whether the repo is used for release artifacts, snapshot artifacts, or both.
* `<enabled>` can be `true` or `false`.

Example:

```xml
<releases>
    <enabled>true</enabled>
</releases>
<snapshots>
    <enabled>false</enabled>
</snapshots>
```

**4. Authentication**

* For private repos, credentials are stored **in `settings.xml`**, not the `pom.xml`.
* Example in `settings.xml`:

```xml
<servers>
    <server>
        <id>internal-repo</id>
        <username>myuser</username>
        <password>mypassword</password>
    </server>
</servers>
```

* The `<id>` here must match the `<id>` in `<repository>`.

#### **C. How Maven Resolves Dependencies**

1. **Local Repository** — Checks `~/.m2/repository` first.
2. **Remote Repositories** — Checks in order defined in `<repositories>`.
3. **Mirror Settings** — Can redirect all requests via `settings.xml`.

#### **D. Best Practices**

* Do not overuse external repositories — it can slow builds and create dependency conflicts.
* Always pin dependencies to specific versions when using non-central repos.
* Use **mirrors** in `settings.xml` for centralizing access to multiple repositories.
* For corporate projects, prefer a **single internal proxy** to external repositories.

## **The `<pluginRepositories>` Section**

Example:

```xml
<pluginRepositories>
    <pluginRepository>
        <id>apache-plugins</id>
        <url>https://repo.maven.apache.org/maven2</url>
        <releases>
            <enabled>true</enabled>
        </releases>
        <snapshots>
            <enabled>false</enabled>
        </snapshots>
    </pluginRepository>

    <pluginRepository>
        <id>custom-plugin-repo</id>
        <url>https://plugins.example.com/maven2</url>
        <releases>
            <enabled>true</enabled>
        </releases>
        <snapshots>
            <enabled>true</enabled>
        </snapshots>
    </pluginRepository>
</pluginRepositories>
```

#### **A. Purpose**

* Specifies **where Maven should look for build plugins** other than the default Maven Central repository.
* Maven uses **separate repository lists for plugins and dependencies**.
* Needed if:
  * We are using a plugin not hosted on Maven Central
  * Our organization hosts custom build plugins internally

#### **B. Key Elements**

**1. `<pluginRepository>`**

* Similar structure to `<repository>`:
  * **`<id>`** — Unique name
  * **`<url>`** — Repository location
  * **`<releases>` / `<snapshots>`** — Enable/disable artifact types

**2. Authentication**

* Just like normal repositories, credentials go into `settings.xml`:

```xml
<servers>
    <server>
        <id>custom-plugin-repo</id>
        <username>builduser</username>
        <password>secret</password>
    </server>
</servers>
```

**3. Mirrors**

* We can redirect all plugin repo lookups through a mirror in `settings.xml`.

#### **C. Difference from `<repositories>`**

<table data-full-width="true"><thead><tr><th width="333.484375">For Dependencies</th><th>For Plugins</th></tr></thead><tbody><tr><td><code>&#x3C;repositories></code></td><td><code>&#x3C;pluginRepositories></code></td></tr><tr><td>Controls where Maven searches for <strong>JARs, libraries, artifacts</strong></td><td>Controls where Maven searches for <strong>build plugins</strong></td></tr><tr><td>Used during dependency resolution</td><td>Used when fetching plugins for build lifecycle phases</td></tr></tbody></table>

#### **D. Best Practices**

* Avoid mixing dependency repositories with plugin repositories unless necessary.
* Keep custom plugins documented without a central repo, future builds may fail.
* For corporate environments, use an internal mirror/proxy to cache plugin artifacts.

## **The `<distributionManagement>` Section**

Example:

```xml
<distributionManagement>
    <repository>
        <id>releases-repo</id>
        <name>Company Releases</name>
        <url>https://repo.company.com/maven2/releases</url>
    </repository>

    <snapshotRepository>
        <id>snapshots-repo</id>
        <name>Company Snapshots</name>
        <url>https://repo.company.com/maven2/snapshots</url>
    </snapshotRepository>

    <site>
        <id>project-site</id>
        <name>Project Documentation</name>
        <url>scp://docs.company.com/www/project</url>
    </site>

    <downloadUrl>https://downloads.company.com/project</downloadUrl>
</distributionManagement>
```

#### **A. Purpose**

* Tells Maven **where to deploy built artifacts** (JAR, WAR, POM, etc.).
* Defines separate locations for:
  * **Release artifacts** (stable versions)
  * **Snapshot artifacts** (in-progress versions)
  * **Generated project site** (HTML documentation)
* Works together with `mvn deploy` phase.

#### **B. Key Elements**

**1. `<repository>`**

* Destination for **release versions**.
* Only accepts non-SNAPSHOT version numbers.
* Example:

```xml
<repository>
    <id>releases-repo</id>
    <url>https://repo.company.com/maven2/releases</url>
</repository>
```

**2. `<snapshotRepository>`**

* Destination for **SNAPSHOT versions**.
* SNAPSHOT builds allow overwriting — they are not immutable.

**3. `<site>`**

* Where Maven publishes the **site documentation** (`mvn site:deploy`).

**4. `<downloadUrl>`**

* Optional — URL for users to manually download artifacts outside Maven.

#### **C. Authentication**

* Credentials **must not** be stored in `pom.xml` — put them in `settings.xml`:

```xml
<servers>
    <server>
        <id>releases-repo</id>
        <username>deployuser</username>
        <password>deploypass</password>
    </server>
</servers>
```

* The `<id>` here matches the `<id>` in `<distributionManagement>`.

#### **D. How It Works ?**

1.  We run:

    ```bash
    mvn clean deploy
    ```
2. Maven:
   * Builds our project
   * Creates the POM and packaged artifact
   * Pushes it to the release or snapshot repo based on the version

#### **E. Best Practices**

* Always separate **release** and **snapshot** repositories.
* Keep deployment credentials outside of source control.
* Automate deployment in CI/CD pipelines to prevent manual errors.
* Avoid deploying directly to public repos without review.

## **The `<reporting>` Section**

Example:

```xml
<reporting>
    <outputDirectory>${project.build.directory}/site</outputDirectory>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-project-info-reports-plugin</artifactId>
            <version>3.4.5</version>
            <reportSets>
                <reportSet>
                    <reports>
                        <report>dependencies</report>
                        <report>plugins</report>
                        <report>licenses</report>
                    </reports>
                </reportSet>
            </reportSets>
        </plugin>

        <plugin>
            <groupId>org.jacoco</groupId>
            <artifactId>jacoco-maven-plugin</artifactId>
            <version>0.8.10</version>
            <reportSets>
                <reportSet>
                    <reports>
                        <report>report</report>
                    </reports>
                </reportSet>
            </reportSets>
        </plugin>
    </plugins>
</reporting>
```

#### **A. Purpose**

* Controls Maven’s **site reporting system**.
*   Defines which **reports** are generated when we run:

    ```bash
    mvn site
    ```
* These reports are often published to a website or artifact repository for:
  * Project documentation
  * Code quality analysis
  * Dependency tracking

#### **B. Key Elements**

**1. `<outputDirectory>`**

* Where the generated site is stored locally (default: `${project.build.directory}/site`).

**2. `<plugins>`**

* List of reporting plugins.
* **Important:** This `<plugins>` inside `<reporting>` is _different_ from the one inside `<build>` — it’s used only for generating reports, not building the project.

**3. `<reportSets>`**

* Defines specific sets of reports a plugin should generate.
* Allows filtering which reports run for different situations.

#### **C. Common Reporting Plugins**

1. **`maven-project-info-reports-plugin`**
   * Generates project info: dependencies, plugins, licenses, SCM, etc.
2. **`maven-javadoc-plugin`**
   * Generates JavaDocs for our codebase.
3. **`jacoco-maven-plugin`**
   * Generates code coverage reports.
4. **`maven-surefire-report-plugin`**
   * Creates test result reports.

#### **D. Best Practices**

* Don’t overload `<reporting>` with unnecessary plugins — large report sets slow down site generation.
* Use it in combination with CI/CD pipelines to publish reports automatically.
* Keep plugin versions pinned to avoid sudden output changes.

## **Project Metadata Sections**

These elements don’t directly affect compilation or packaging, but they are **critical for documentation, open-source compliance, and automated tooling**.

### A. `<licenses>`

Example:

```xml
<licenses>
    <license>
        <name>Apache License, Version 2.0</name>
        <url>https://www.apache.org/licenses/LICENSE-2.0</url>
        <distribution>repo</distribution>
        <comments>Standard open source license.</comments>
    </license>
</licenses>
```

**Purpose:**

* Declares the license(s) our project is distributed under.
* Used by tools like Maven Central’s validation process and license scanners.

**Key Fields:**

* **`<name>`** — Full license name.
* **`<url>`** — Link to license text.
* **`<distribution>`** — Usually `repo` (distributed with repo) or `manual`.
* **`<comments>`** — Optional notes about the license.

### B. `<developers>`

Example:

```xml
<developers>
    <developer>
        <id>pranay</id>
        <name>Pranay Pourkar</name>
        <email>pranay@example.com</email>
        <url>https://pranaypourkar.dev</url>
        <organization>ConceptJotter</organization>
        <organizationUrl>https://conceptjotter.dev</organizationUrl>
        <roles>
            <role>Developer</role>
            <role>Architect</role>
        </roles>
        <timezone>+5:30</timezone>
    </developer>
</developers>
```

**Purpose:**

* Lists the main contributors to the project.
* Important for open-source projects to give credit and contact points.

**Key Fields:**

* **`<id>`** — Short unique identifier.
* **`<roles>`** — Multiple roles possible (developer, maintainer, tester, etc.).
* **`<timezone>`** — Useful for distributed teams.

### C. `<contributors>`

Example:

```xml
<contributors>
    <contributor>
        <name>Jane Doe</name>
        <email>jane@example.com</email>
        <roles>
            <role>Tester</role>
        </roles>
    </contributor>
</contributors>
```

**Purpose:**

* Recognizes people who contributed but aren’t core developers.

### D. `<scm>` (Source Control Management)

Example:

```xml
<scm>
    <connection>scm:git:https://github.com/username/project.git</connection>
    <developerConnection>scm:git:ssh://git@github.com/username/project.git</developerConnection>
    <url>https://github.com/username/project</url>
    <tag>v1.0.0</tag>
</scm>
```

**Purpose:**

* Tells Maven and plugins where the source code repository lives.
* Useful for:
  * Automated release tagging
  * Generating SCM links in reports
  * Continuous Integration pipelines

**Key Fields:**

* **`<connection>`** — Read-only access URL.
* **`<developerConnection>`** — Write-access URL for maintainers.
* **`<url>`** — Web UI link to the repo.
* **`<tag>`** — Tag name for the current release.

### E. `<issueManagement>`

Example:

```xml
<issueManagement>
    <system>GitHub Issues</system>
    <url>https://github.com/username/project/issues</url>
</issueManagement>
```

**Purpose:**

* Indicates where bugs and feature requests are tracked.

### F. `<ciManagement>`

Example:

```xml
<ciManagement>
    <system>GitHub Actions</system>
    <url>https://github.com/username/project/actions</url>
</ciManagement>
```

**Purpose:**

* Documents the Continuous Integration system for the project.

#### **Best Practices**

* Always fill out `<licenses>` if publishing publicly — Maven Central will reject uploads without it.
* Include `<scm>` and `<developers>` for professional credibility.
* Keep metadata updated with each major release.
* For open-source work, align `<license>` and repository `LICENSE` file.

## **Complete Example of `pom.xml` with All Sections**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!-- Maven Project Object Model (POM) File -->
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
                             http://maven.apache.org/xsd/maven-4.0.0.xsd">

    <!-- Model Version -->
    <modelVersion>4.0.0</modelVersion>

    <!-- Project Coordinates -->
    <groupId>com.example</groupId>
    <artifactId>demo-project</artifactId>
    <version>1.0.0-SNAPSHOT</version>
    <packaging>jar</packaging>

    <!-- Project Information -->
    <name>Demo Project</name>
    <description>A sample Maven project demonstrating all POM sections.</description>
    <url>https://example.com/demo-project</url>

    <!-- Project Properties -->
    <properties>
        <java.version>17</java.version>
        <maven.compiler.source>${java.version}</maven.compiler.source>
        <maven.compiler.target>${java.version}</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>

    <!-- Dependency Management -->
    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-dependencies</artifactId>
                <version>3.2.1</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>

    <!-- Project Dependencies -->
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <!-- Repositories for Dependencies -->
    <repositories>
        <repository>
            <id>central</id>
            <url>https://repo.maven.apache.org/maven2</url>
        </repository>
        <repository>
            <id>jitpack.io</id>
            <url>https://jitpack.io</url>
        </repository>
    </repositories>

    <!-- Build Configuration -->
    <build>
        <finalName>demo-project</finalName>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.11.0</version>
                <configuration>
                    <source>${java.version}</source>
                    <target>${java.version}</target>
                </configuration>
            </plugin>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-plugin</artifactId>
                <version>3.1.2</version>
            </plugin>
        </plugins>
    </build>

    <!-- Profiles for Different Builds -->
    <profiles>
        <profile>
            <id>dev</id>
            <properties>
                <env>development</env>
            </properties>
        </profile>
        <profile>
            <id>prod</id>
            <properties>
                <env>production</env>
            </properties>
        </profile>
    </profiles>

    <!-- Distribution Management for Deployment -->
    <distributionManagement>
        <repository>
            <id>releases-repo</id>
            <url>https://repo.company.com/releases</url>
        </repository>
        <snapshotRepository>
            <id>snapshots-repo</id>
            <url>https://repo.company.com/snapshots</url>
        </snapshotRepository>
        <site>
            <id>project-site</id>
            <url>scp://docs.company.com/www/project</url>
        </site>
        <downloadUrl>https://downloads.company.com/demo-project</downloadUrl>
    </distributionManagement>

    <!-- Reporting Configuration -->
    <reporting>
        <outputDirectory>${project.build.directory}/site</outputDirectory>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-project-info-reports-plugin</artifactId>
                <version>3.4.5</version>
                <reportSets>
                    <reportSet>
                        <reports>
                            <report>dependencies</report>
                            <report>plugins</report>
                            <report>licenses</report>
                        </reports>
                    </reportSet>
                </reportSets>
            </plugin>
            <plugin>
                <groupId>org.jacoco</groupId>
                <artifactId>jacoco-maven-plugin</artifactId>
                <version>0.8.10</version>
                <reportSets>
                    <reportSet>
                        <reports>
                            <report>report</report>
                        </reports>
                    </reportSet>
                </reportSets>
            </plugin>
        </plugins>
    </reporting>

    <!-- Project Metadata -->
    <licenses>
        <license>
            <name>Apache License, Version 2.0</name>
            <url>https://www.apache.org/licenses/LICENSE-2.0</url>
            <distribution>repo</distribution>
        </license>
    </licenses>

    <developers>
        <developer>
            <id>pranay</id>
            <name>Pranay Pourkar</name>
            <email>pranay@example.com</email>
            <roles>
                <role>Developer</role>
            </roles>
        </developer>
    </developers>

    <contributors>
        <contributor>
            <name>Jane Doe</name>
            <roles>
                <role>Tester</role>
            </roles>
        </contributor>
    </contributors>

    <scm>
        <connection>scm:git:https://github.com/username/demo-project.git</connection>
        <developerConnection>scm:git:ssh://git@github.com/username/demo-project.git</developerConnection>
        <url>https://github.com/username/demo-project</url>
        <tag>v1.0.0</tag>
    </scm>

    <issueManagement>
        <system>GitHub Issues</system>
        <url>https://github.com/username/demo-project/issues</url>
    </issueManagement>

    <ciManagement>
        <system>GitHub Actions</system>
        <url>https://github.com/username/demo-project/actions</url>
    </ciManagement>

</project>
```
