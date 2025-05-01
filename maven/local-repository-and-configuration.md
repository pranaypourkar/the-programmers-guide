# Local Repository & Configuration

## About

Apache Maven uses a local repository and configuration files to manage dependencies, plugins, and build settings. Understanding the structure and customization options of Maven's local repository and configuration files is essential for effectively managing Maven-based projects.

## What is the Local Repository?

The **local repository** is a directory on the developer's machine where Maven stores all the project dependencies, plugins, and artifacts that it downloads from remote repositories such as Maven Central.

#### Default Location

* **Windows**: `C:\Users\<username>\.m2\repository`
* **macOS/Linux**: `/Users/<username>/.m2/repository` or `~/.m2/repository`

#### Purpose

* Acts as a cache to avoid downloading dependencies multiple times.
* Improves build performance and offline capabilities.
* Custom-built artifacts and third-party JARs not available in public repositories can also be installed here using the `mvn install` command.

## Global & User Level Settings

Maven supports two levels of configuration files: **global settings** and **user-specific settings**.&#x20;

{% hint style="info" %}
Understanding the difference between them is essential when managing shared environments or customizing Maven for individual developers.
{% endhint %}

### 1. Global `settings.xml`

* **Location**:\
  `<MAVEN_HOME>/conf/settings.xml`\
  (e.g., `/opt/apache-maven-3.9.6/conf/settings.xml` on Unix-based systems or `C:\Program Files\Apache\maven-x.y.z\conf\settings.xml` on Windows)
* **Scope**:\
  Applies **system-wide**, meaning it affects **all users** on the machine who run Maven using that installation.
* **Purpose**:
  * Define **default configurations** for all users (e.g., corporate mirrors, proxies).
  * Useful in **enterprise setups** or **build environments** (e.g., CI/CD agents).
  * Avoid putting user-specific credentials or local paths here.
* **Editing Notes**:\
  Requires admin or write access to the Maven installation directory. Avoid making unnecessary changes to prevent affecting all builds globally.

### 2. User `settings.xml`

* **Location**:\
  `~/.m2/settings.xml`\
  (e.g., `/Users/john/.m2/settings.xml` on macOS/Linux or `C:\Users\john\.m2\settings.xml` on Windows)
* **Scope**:\
  Applies **only to the current user**. Overrides corresponding values in the global `settings.xml`.
* **Purpose**:
  * Customize Maven behavior for a specific developer.
  * Store **personal repository credentials**, custom profiles, proxies, or environment-specific configurations.
  * Keeps user-level customizations isolated and easy to manage.
* **Editing Notes**:\
  Does **not require admin access**. Safe to modify. If the file does not exist, it can be created manually.

### 3. Precedence and Override Behavior

When both files are present:

* Maven **first reads** the global `settings.xml`.
* Then it **overlays values from the user-level** `settings.xml`.
* This means values in the user file take **priority** over the global settings if both define the same element (e.g., `mirrors`, `servers`, `profiles`).

## The `.m2` Directory

`.m2` is a **hidden directory in our user’s home folder** created by Maven. It stores configuration files and the **local repository** of downloaded Maven dependencies.

#### Default Location

* **Windows:** `C:\Users\<username>\.m2\`
* **macOS/Linux:** `/Users/<username>/.m2/`  or `~/.m2/repository`

### Structure of `.m2` Directory

```
.m2/
├── repository/          # Local cache of all downloaded dependencies
├── settings.xml         # Optional user-specific Maven configuration
└── settings-security.xml  # Encrypted passwords (optional)
```

#### `repository/`

* Contains all Maven artifacts (JARs, POMs) that Maven has downloaded.
* Helps avoid downloading dependencies repeatedly from the internet.
* We can safely delete this folder to force Maven to re-download all dependencies.

#### `settings.xml`

* This file is used to **override default Maven settings**.
* It is not created by default - we need to create it manually if customization is needed.
* Full path:
  * Windows: `C:\Users\<username>\.m2\settings.xml`
  * macOS/Linux: `~/.m2/settings.xml`

#### `settings-security.xml`

* This file is used by Maven to **securely store the master password**, which is required to **decrypt encrypted passwords** stored in the `settings.xml` file. It enhances security by avoiding plain text credentials.
* It is **not created by default** - we must generate it manually when using encrypted passwords in `settings.xml`.
* Full path:
  * **Windows**: `C:\Users\<username>\.m2\settings-security.xml`
  * **macOS/Linux**: `~/.m2/settings-security.xml`

## **Local Repository (`repository/`)**

### About

The `repository/` directory is Maven’s **local artifact cache**. It stores all dependencies, plugins, and project-specific artifacts resolved during Maven builds. It contains -

* **Downloaded Dependencies**: JARs, POMs, sources, and javadocs pulled from remote repositories like Maven Central.
* **Project Artifacts**: If we run `mvn install`, our project’s JAR or WAR is saved here.
* **Directory Structure**:
  *   Maven uses a groupId-path layout. For example:

      ```
      com/
        google/
          guava/
            guava/
              30.1.1-jre/
                guava-30.1.1-jre.jar
                guava-30.1.1-jre.pom
      ```

### Usage

* Maven checks this directory before downloading anything from a remote repo.
* Speeds up builds by caching artifacts locally.
* Enables offline builds (`mvn -o` or `--offline`).

### Default Location

* Windows: `C:\Users\<your-username>\.m2\repository`
* Linux/macOS: `/Users/<your-username>/.m2/repository` or `~/.m2/repository`

### Customizing Location

We can change the default location by:

1.  Adding this to `~/.m2/settings.xml`:

    ```xml
    <localRepository>/custom/path/to/repository</localRepository>
    ```
2.  Or using the CLI:

    ```bash
    mvn clean install -Dmaven.repo.local=/custom/path
    ```

### Maintenance

* Clean unused artifacts periodically.
*   Use:

    ```bash
    mvn dependency:purge-local-repository
    ```

## **User-Specific Configuration File (`settings.xml`)**

### About

This is an **optional** XML configuration file for Maven that allows us to override default behaviors, set profiles, proxies, server credentials, mirrors, and more - specific to our **user**.

### Default Location

* Windows: `C:\Users\<username>\.m2\settings.xml`
* Linux/macOS: `~/.m2/settings.xml`

> Note: If not present, Maven uses only the global settings from `MAVEN_HOME/conf/settings.xml`.

### Key Configurable Elements

**a. `localRepository`**

* Override the default location of the local repository.

**b. `mirrors`**

*   Redirect all Maven traffic to a mirror, e.g., internal Artifactory or Nexus:

    ```xml
    <mirrors>
      <mirror>
        <id>internal-repo</id>
        <mirrorOf>*</mirrorOf>
        <url>https://repo.mycompany.com/maven2</url>
      </mirror>
    </mirrors>
    ```

**c. `proxies`**

*   Needed in corporate environments where internet access is behind a proxy:

    ```xml
    <proxies>
      <proxy>
        <id>example-proxy</id>
        <active>true</active>
        <protocol>http</protocol>
        <host>proxy.company.com</host>
        <port>8080</port>
      </proxy>
    </proxies>
    ```

**d. `servers`**

*   Store credentials for repositories or deployment servers:

    ```xml
    <servers>
      <server>
        <id>my-private-repo</id>
        <username>admin</username>
        <password>encrypted-password</password>
      </server>
    </servers>
    ```

> Use `id` values that match repository definitions in `pom.xml`.

**e. `profiles` and `activeProfiles`**

*   Define environment-specific properties and configurations:

    ```xml
    <profiles>
      <profile>
        <id>dev</id>
        <properties>
          <env>development</env>
        </properties>
      </profile>
    </profiles>

    <activeProfiles>
      <activeProfile>dev</activeProfile>
    </activeProfiles>
    ```

### Security

* Avoid plain text passwords. Use `settings-security.xml` for encryption (explained below).

### Sample `settings.xml` File

```xml
<?xml version="1.0" encoding="UTF-8"?>
<settings xmlns="http://maven.apache.org/SETTINGS/1.1.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.1.0 
                              https://maven.apache.org/xsd/settings-1.1.0.xsd">

  <!--
    Optional: Override the default local repository location.
    If not specified, Maven uses ~/.m2/repository.
  -->
  <localRepository>/Users/your-username/.m2/custom-repo</localRepository>

  <!--
    Optional: Define proxies if you are behind a corporate firewall.
    This allows Maven to access the internet through your proxy server.
  -->
  <proxies>
    <proxy>
      <id>corporate-proxy</id>
      <active>true</active>
      <protocol>http</protocol>
      <host>proxy.company.com</host>
      <port>8080</port>
      <username>proxyUser</username>         <!-- Optional -->
      <password>proxyPassword</password>     <!-- Optional -->
      <nonProxyHosts>localhost|127.0.0.1</nonProxyHosts>
    </proxy>
  </proxies>

  <!--
    Optional: Define mirrors to redirect Maven downloads.
    Useful for using internal repositories or caching proxies (like Nexus/Artifactory).
  -->
  <mirrors>
    <mirror>
      <id>internal-central</id>
      <mirrorOf>central</mirrorOf>
      <url>https://nexus.company.com/repository/maven-public/</url>
    </mirror>
  </mirrors>

  <!--
    Define server credentials for authentication with private repositories or deployment targets.
    The password can be encrypted using settings-security.xml.
  -->
  <servers>
    <server>
      <id>internal-repo</id> <!-- Match the repository id in your POM file -->
      <username>deploymentUser</username>
      <password>{encrypted-password}</password>
    </server>

    <server>
      <id>github</id> <!-- Used when deploying to GitHub Packages -->
      <username>your-github-username</username>
      <password>{your-github-token}</password>
    </server>
  </servers>

  <!--
    Optional: Define custom build profiles.
    Profiles can include different properties, repositories, plugin configurations, etc.
    You can activate them manually or automatically based on environment.
  -->
  <profiles>

    <!-- Development profile -->
    <profile>
      <id>dev</id>
      <activation>
        <activeByDefault>true</activeByDefault>
      </activation>
      <properties>
        <env.name>development</env.name>
      </properties>
    </profile>

    <!-- Production profile -->
    <profile>
      <id>prod</id>
      <properties>
        <env.name>production</env.name>
      </properties>
    </profile>

  </profiles>

  <!--
    Define which profiles should be active.
    You can also activate profiles using the command line (-P).
  -->
  <activeProfiles>
    <activeProfile>dev</activeProfile>
    <!-- Uncomment below to activate production profile by default -->
    <!-- <activeProfile>prod</activeProfile> -->
  </activeProfiles>

</settings>
```

## Security Configuration (`settings-security.xml`)

### About

`settings-security.xml` allows you to store the **master password** that Maven uses to decrypt encrypted passwords in `settings.xml`.

### Default Location

* Windows: `C:\Users\<username>\.m2\settings-security.xml`
* Linux/macOS: `~/.m2/settings-security.xml`

### How It Works ?

1.  **Generate Encrypted Password**:

    ```bash
    mvn --encrypt-password yourPassword
    ```

    Example output:

    ```
    {COQLCEewfjfSJLkfH39js38s=}
    ```
2.  **Use Encrypted Password in `settings.xml`**:

    ```xml
    <server>
      <id>private-repo</id>
      <username>your-username</username>
      <password>{COQLCEewfjfSJLkfH39js38s=}</password>
    </server>
    ```
3.  **Generate Master Password**:

    ```bash
    mvn --encrypt-master-password myMasterPass
    ```

    Save the output in `settings-security.xml`:

    ```xml
    <settingsSecurity>
      <master>{someEncryptedMasterPassword}</master>
    </settingsSecurity>
    ```

> Maven will automatically use this master password to decrypt the encrypted password at runtime.

### Purpose

* Secure sensitive credentials without hardcoding them in plain text.
* Required for organizations or CI systems dealing with private repositories.

### Sample `settings-security.xml`  File

```xml
<?xml version="1.0" encoding="UTF-8"?>
<settingsSecurity xmlns="http://maven.apache.org/SETTINGS/1.0.0"
                  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                  xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 
                                      https://maven.apache.org/xsd/settings-security-1.0.0.xsd">

  <!--
    The master password used to encrypt/decrypt other passwords 
    in settings.xml (in <server><password>...</password> fields).

    This master password is itself encrypted using Maven's built-in 
    tool (`mvn --encrypt-master-password`) and stored here.

    Maven uses this encrypted master password to decrypt other
    encrypted values found in your settings.xml.

    Example usage:
      mvn --encrypt-master-password your-master-pass
      # Copy output to <master>...</master> below
  -->
  <master>{ENCRYPTED-MASTER-PASSWORD}</master>

</settingsSecurity>
```
