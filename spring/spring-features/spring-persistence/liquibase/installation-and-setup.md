# Installation & Setup

## About

Liquibase can be installed and configured in several ways depending on our workflow, environment, and integration needs. The setup process generally involves installing Liquibase, connecting to a database, and creating our first changelog.

## Installation Methods

### **1. Command-Line Interface (CLI) Installation**

The **CLI** method is the most direct and environment-agnostic approach.

* **When to use:** Ideal for database administrators, DevOps engineers, or anyone running migrations outside of an application context.
* **How it works:** We download a precompiled Liquibase binary (ZIP/TAR), extract it, and run commands directly from our terminal.
* **Advantages:**
  * No dependency on a specific programming language or build system.
  * Can manage _any_ supported database from a single machine.
  * Easier to integrate into shell scripts and automation jobs.
* **Disadvantages:**
  * Requires manual updates when new Liquibase versions are released.
  * Configuration must be managed separately (e.g., `liquibase.properties`).
* **Advanced tip:** Install Liquibase in a **central tools directory** and add it to the system `PATH` for global use. For multiple versions, keep them in versioned folders (e.g., `liquibase-4.29.0`) and switch PATH as needed.

### **2. Maven Plugin Integration**

Liquibase has an official **Maven plugin**, making it easy to run database migrations as part of our Java project’s build lifecycle.

* **When to use:** Ideal for Java developers who want database changes tied directly to the application’s version control and build process.
* **How it works:**
  * Add the Liquibase Maven plugin to `pom.xml`.
  * Define configuration in Maven profiles or `liquibase.properties`.
  *   Run commands like:

      ```bash
      mvn liquibase:update
      mvn liquibase:rollback -Dliquibase.rollbackCount=1
      ```
* **Advantages:**
  * No extra installation — Maven handles dependencies.
  * Fully integrated with Java build pipelines (e.g., Jenkins, GitLab CI).
  * Can leverage Maven profiles for environment-specific DB connections.
* **Disadvantages:**
  * Tied to Maven — not suitable for non-Java projects.
  * Slightly slower startup due to Maven overhead.

### **3. Gradle Plugin Integration**

Similar to Maven, but designed for Gradle-based builds.

* **When to use:** Ideal for Java/Kotlin projects already using Gradle.
* **How it works:**
  * Apply the Liquibase Gradle plugin in `build.gradle` or `build.gradle.kts`.
  * Configure database connection details and changelog paths.
  *   Run commands like:

      ```bash
      ./gradlew update
      ./gradlew rollback -PliquibaseCommandValue=1
      ```
* **Advantages:**
  * Easy integration with modern JVM projects.
  * Can chain Liquibase commands into custom Gradle tasks.
* **Disadvantages:**
  * Build-system dependent.

### **4. Spring Boot Auto-Run Integration**

Liquibase can run automatically at Spring Boot application startup.

* **When to use:** Ideal for microservices or applications where the database must be in sync at startup without manual intervention.
* **How it works:**
  * Add the `liquibase-core` dependency to our project.
  * Place changelogs in the classpath.
  * Spring Boot automatically runs Liquibase on application boot, applying changes before the app fully starts.
* **Advantages:**
  * Fully automated schema updates.
  * No manual migration steps in most environments.
* **Disadvantages:**
  * Risky for production environments if changes are not carefully reviewed.
  * Startup time increases if migrations are large.
* **Advanced tip:** Use Spring Profiles and Liquibase contexts to limit which changesets run in each environment.

### **5. Dockerized Liquibase**

Liquibase provides an **official Docker image**.

* **When to use:** Ideal for teams that want reproducible, isolated migration environments without installing Liquibase locally.
* **How it works:**
  *   Pull the image:

      ```bash
      docker pull liquibase/liquibase
      ```
  *   Run commands inside the container:

      ```bash
      docker run --rm -v $(pwd):/liquibase/changelog liquibase/liquibase update \
        --url=jdbc:postgresql://db:5432/mydb \
        --username=user --password=pass
      ```
* **Advantages:**
  * No host installation needed — everything runs inside a container.
  * Ensures consistent Liquibase version across team members and CI.
* **Disadvantages:**
  * Requires Docker installed and accessible.
  * Slightly more verbose commands unless wrapped in scripts.

### **6. Direct Java API Usage**

Liquibase can be used as a **library** inside our own Java code.

* **When to use:** For highly customized workflows where migrations are part of complex application logic.
* **Advantages:**
  * Full control over execution.
  * Can run migrations programmatically at specific lifecycle points.
* **Disadvantages:**
  * More setup required.
  * Tightly couples database migrations with application code.

## Database Connection Configuration

Before Liquibase can run migrations, it needs to know **where** to apply changes meaning it must be able to connect to our target database. This configuration step is essential for both local development and production deployments.

**1. Key Connection Parameters**

Liquibase requires a few standard parameters to establish a database connection:

* **`url`** – The JDBC connection string specifying the database type, host, port, and name.
  *   Example for PostgreSQL:

      ```
      jdbc:postgresql://localhost:5432/mydb
      ```
  *   Example for MySQL:

      ```
      jdbc:mysql://localhost:3306/mydb
      ```
* **`username`** – The database user with the necessary permissions to run schema changes (CREATE, ALTER, DROP, etc.).
* **`password`** – The password for the database user.
* **`changeLogFile`** – The path to the master changelog file (relative or absolute).
* **Optional parameters** –
  * `defaultSchemaName` – Default schema to apply changes in (useful for multi-schema DBs).
  * `driver` – Fully qualified JDBC driver class (only needed if Liquibase cannot detect it automatically).

**2. Configuration Methods**

Liquibase supports several ways to provide these parameters, allowing flexibility across environments:

**A. Command-Line Arguments**\
We can pass parameters directly in the Liquibase command:

```bash
liquibase \
  --url=jdbc:postgresql://localhost:5432/mydb \
  --username=dbuser \
  --password=dbpass \
  --changeLogFile=changelog/db.changelog-master.xml \
  update
```

* **Pros:** Fast for testing and one-off commands.
* **Cons:** Not secure for production because passwords may appear in shell history or process lists.

**B. `liquibase.properties` File**\
A more secure and maintainable approach is to place parameters in a `liquibase.properties` file in our project directory:

```properties
url=jdbc:postgresql://localhost:5432/mydb
username=dbuser
password=dbpass
changeLogFile=changelog/db.changelog-master.xml
```

Then run simply:

```bash
liquibase update
```

* **Pros:** Cleaner commands, reusable across runs.
* **Cons:** Must secure the file if it contains credentials (e.g., use `.gitignore` to avoid committing passwords).

**C. Environment Variables**\
Liquibase can read connection parameters from environment variables:

```bash
export LIQUIBASE_COMMAND_URL=jdbc:postgresql://localhost:5432/mydb
export LIQUIBASE_COMMAND_USERNAME=dbuser
export LIQUIBASE_COMMAND_PASSWORD=dbpass
liquibase update
```

* **Pros:** Good for CI/CD pipelines and avoiding credentials in files.
* **Cons:** Still visible to users on the same system via `env` or `printenv`.

**D. Build Tool Configuration**\
If using Maven or Gradle, we can define connection settings inside our build configuration, letting us run migrations with:

```bash
mvn liquibase:update
# or
./gradlew update
```

**3. Best Practices**

* **Separate environments** – Use different connection configs for `dev`, `staging`, and `prod` (e.g., `liquibase-dev.properties`, `liquibase-prod.properties`).
* **Avoid hardcoded passwords** – Use environment variables or a secure vault (e.g., HashiCorp Vault, AWS Secrets Manager).
* **Test before production** – Always run `liquibase status` or `liquibase updateSQL` before applying changes to production.
* **JDBC drivers** – Ensure the required driver `.jar` is on the Liquibase classpath, especially for databases like Oracle or SQL Server.

## Change log Organization & Creation

In Liquibase, a **changelog** is the heart of our database change management process. It’s a file (or a collection of files) that lists **changesets -** each changeset represents a specific, version-controlled database change.

Properly **organizing** and **creating** changelogs is critical for:

* Team collaboration
* Environment consistency
* Rollback reliability
* Long-term maintainability of database schema history

### **1. Changelog File Formats**

Liquibase supports multiple formats, letting us choose what fits our workflow:

* **XML** – The most feature-complete and widely used format.
* **YAML** – More human-readable for teams familiar with configuration files.
* **JSON** – Lightweight but less common.
* **SQL** – Ideal when DBAs want raw SQL control.

**Example (XML)**

```xml
<databaseChangeLog
        xmlns="http://www.liquibase.org/xml/ns/dbchangelog"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://www.liquibase.org/xml/ns/dbchangelog
        http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-4.8.xsd">

    <changeSet id="1" author="alice">
        <createTable tableName="customer">
            <column name="id" type="int" autoIncrement="true">
                <constraints primaryKey="true"/>
            </column>
            <column name="name" type="varchar(255)"/>
        </createTable>
    </changeSet>

</databaseChangeLog>
```

### **2. Master Changelog and Modular Structure**

For larger projects, we don’t want a single giant changelog file.\
Instead, **split changes into multiple files** and use a **master changelog** to include them.

**Example Structure**

```
db/
  changelog/
    db.changelog-master.xml
    v1/
      create-tables.xml
      insert-initial-data.xml
    v2/
      add-orders-table.xml
      update-customer-schema.xml
```

**Master Changelog (XML)**

```xml
<databaseChangeLog
        xmlns="http://www.liquibase.org/xml/ns/dbchangelog"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://www.liquibase.org/xml/ns/dbchangelog
        http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-4.8.xsd">

    <include file="v1/create-tables.xml" relativeToChangelogFile="true"/>
    <include file="v1/insert-initial-data.xml" relativeToChangelogFile="true"/>
    <include file="v2/add-orders-table.xml" relativeToChangelogFile="true"/>
    <include file="v2/update-customer-schema.xml" relativeToChangelogFile="true"/>
</databaseChangeLog>
```

**Why use a master changelog ?**

* Central entry point for Liquibase commands.
* Keeps history organized by feature or release.
* Makes it easier to add new changes without modifying old files.

### **3. Writing a Good Changeset**

A **changeset** is the atomic unit of Liquibase changes.\
It has **three required attributes**

* **`id`** – A unique identifier within the author’s namespace.
* **`author`** – The person or system that created it.
* **`changes`** – One or more operations (e.g., create table, insert data).

**Best Practices for Changesets**

* **Unique IDs**: Never reuse an `id` with the same `author`.
* **Small & Focused**: Each changeset should do _one logical change_ (e.g., create a table, add a column, insert reference data).
* **Rollback Ready**: Always include rollback instructions for production safety.
* **Immutable History**: Never modify an already-applied changeset; create a new one for fixes.

### **4. Rollback in Changelogs**

Defining rollback steps allows us to reverse changes if something goes wrong.\
**Example**

```xml
<changeSet id="2" author="bob">
    <addColumn tableName="customer">
        <column name="email" type="varchar(255)"/>
    </addColumn>
    <rollback>
        <dropColumn tableName="customer" columnName="email"/>
    </rollback>
</changeSet>
```

### **5. Organizing by Context and Labels**

Liquibase allows us to tag changesets for conditional execution:

* **Contexts** – Group changes by environment (e.g., `dev`, `test`, `prod`).
* **Labels** – Tag changes for feature-specific deployments.

**Example with Contexts**

```xml
<changeSet id="3" author="carol" context="dev">
    <insert tableName="sample_data">
        <column name="id" valueNumeric="1"/>
        <column name="name" value="Test User"/>
    </insert>
</changeSet>
```

Run only `dev` context

```bash
liquibase --contexts=dev update
```

### **6. Changelog Location & Version Control**

* Store changelogs in **source control** alongside application code.
* Keep them in a dedicated `db/changelog` directory.
* Use branching and pull requests to review schema changes just like code.
