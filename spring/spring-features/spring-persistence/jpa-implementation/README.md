# JPA Implementation

## About JPA

* **JPA (Java Persistence API)** is a **Java specification** (a set of _rules_ or _guidelines_).
* JPA **defines**:
  * How Java objects (entities) map to relational database tables.
  * How to perform CRUD operations, queries, transaction management, etc.

{% hint style="success" %}
**JPA itself is just a specification** — it **does not** provide any working code or logic.

Think of JPA like an "Interface" that someone must implement.
{% endhint %}

{% hint style="info" %}
**JPA** (Java Persistence API) is defined in JSR (Java Specification Request) documents — initially JSR 220 (EJB 3.0), later evolved into JSR 317 (JPA 2.0), JSR 338 (JPA 2.1), and so on. It standardizes _Object-Relational Mapping_ (ORM), entity management, JPQL (Java Persistence Query Language), criteria queries, etc.

JPA introduces **interfaces and annotations** like:

* `EntityManager`, `EntityTransaction`, `Query`
* Annotations like `@Entity`, `@Table`, `@Id`, `@OneToMany`, `@ManyToOne`
{% endhint %}

## About JPA Implementation

* A JPA Implementation is a real library/framework that implements the contracts defined by the JPA specification.
* It provides the working code that does:
  * Managing entity life cycles (persist, merge, remove, detach).
  * Translating JPQL (Java Persistence Query Language) into SQL.
  * Managing caching, flushing, dirty checking.
  * Handling transactions.
  * Optimizing database interaction.

<table data-full-width="true"><thead><tr><th width="122.5390625">Aspect</th><th>JPA Specification</th><th>JPA Implementation</th></tr></thead><tbody><tr><td>What it does</td><td>Defines "what should be done"</td><td>Provides "how it is actually done"</td></tr><tr><td>Example</td><td><code>@Entity</code>, <code>EntityManager</code>, <code>@OneToMany</code>, JPQL syntax rules</td><td>Hibernate, EclipseLink, OpenJPA, DataNucleus</td></tr></tbody></table>

{% hint style="info" %}
**Why Separate JPA and Implementation?**

* **Portability**:\
  We can change the JPA implementation (say Hibernate → EclipseLink) without changing much of our Java code.
* **Standardization**:\
  Java developers can write one standard code (`@Entity`, `EntityManager`) and multiple vendors can compete on performance/features.
* **Loose Coupling**:\
  Our code **talks to JPA API**, and **behind the scenes**, the implementation does the work.
{% endhint %}

## What a JPA Implementation Must Provide Technically ?

To conform to the JPA specification, a JPA provider (like Hibernate) must implement:

<table data-full-width="true"><thead><tr><th width="314.171875">Feature</th><th>Description</th></tr></thead><tbody><tr><td><strong>Persistence Context Management</strong></td><td>Handling life cycle states (Transient, Managed, Detached, Removed)</td></tr><tr><td><strong>EntityManager</strong></td><td>Real class implementing <code>javax.persistence.EntityManager</code></td></tr><tr><td><strong>Persistence Unit Deployment</strong></td><td>Understand and parse <code>persistence.xml</code> or Spring Boot configs</td></tr><tr><td><strong>Entity Mapping</strong></td><td>Convert Java class metadata into SQL DDL (Data Definition Language) and ORM mapping</td></tr><tr><td><strong>SQL Generation</strong></td><td>Translate JPQL queries and Criteria API calls into actual SQL</td></tr><tr><td><strong>Transaction Handling</strong></td><td>Support for JTA (Java Transaction API) and resource-local transactions</td></tr><tr><td><strong>Caching</strong></td><td>Manage first-level (mandatory) and second-level (optional) caches</td></tr><tr><td><strong>Flush and Dirty Checking</strong></td><td>Auto-detect which fields changed and optimize update SQL</td></tr><tr><td><strong>Lazy and Eager Loading</strong></td><td>Implement efficient fetching mechanisms according to FetchType</td></tr><tr><td><strong>Optimistic and Pessimistic Locking</strong></td><td>Implement concurrency control</td></tr><tr><td><strong>Callbacks and Listeners</strong></td><td>Support <code>@PrePersist</code>, <code>@PostPersist</code>, etc. entity life-cycle callbacks</td></tr></tbody></table>

## Architecture Layers Typically Found in a JPA Implementation

Most modern JPA Implementations internally have **multi-layered architectures**:

<table data-full-width="true"><thead><tr><th width="270.90234375">Layer</th><th>Responsibility</th></tr></thead><tbody><tr><td><strong>Session/EntityManager Layer</strong></td><td>User API entry point, entity management operations.</td></tr><tr><td><strong>Persistence Context Layer</strong></td><td>Context cache, flush ordering, dirty checking.</td></tr><tr><td><strong>SQL Generation Layer</strong></td><td>Build and optimize SQL queries from JPQL or Criteria API.</td></tr><tr><td><strong>Transaction Layer</strong></td><td>Handle transactional demarcation (commit, rollback).</td></tr><tr><td><strong>Schema/DDL Layer</strong></td><td>Manage schema creation/update/drop based on mappings.</td></tr><tr><td><strong>Caching Layer</strong></td><td>First-level cache (mandatory) and optional second-level cache integration.</td></tr><tr><td><strong>Metadata Layer</strong></td><td>Parse and store mappings from annotations/XML.</td></tr><tr><td><strong>Database Dialect Layer</strong></td><td>Abstracts vendor-specific SQL variations (e.g., MySQL vs Oracle).</td></tr></tbody></table>

## Common JPA Implementations

<table data-full-width="true"><thead><tr><th width="187.81640625">JPA Implementation</th><th width="243.92578125">Maintained By</th><th>Notes</th></tr></thead><tbody><tr><td><strong>Hibernate</strong></td><td>Red Hat</td><td>Most popular, default in Spring Boot, rich features.</td></tr><tr><td><strong>EclipseLink</strong></td><td>Eclipse Foundation</td><td>Reference Implementation for JPA. Good integration with Java EE.</td></tr><tr><td><strong>Apache OpenJPA</strong></td><td>Apache Software Foundation</td><td>Less popular today, once used in older Java EE servers.</td></tr><tr><td><strong>DataNucleus</strong></td><td>Open Source Project</td><td>Supports JPA and also other data stores like NoSQL.</td></tr><tr><td><strong>Batoo JPA</strong></td><td>(Defunct)</td><td>Claimed to be faster than Hibernate, now discontinued.</td></tr></tbody></table>

{% hint style="info" %}
**Hibernate** is the most dominant, **even if you don't specify**, Spring Boot picks Hibernate internally as default JPA provider.

**EclipseLink** is used where Java EE or Jakarta EE compliance is more important (example: Jakarta EE servers like GlassFish).
{% endhint %}

## How to Choose a JPA Implementation ?

| Criteria                              | Decision                                  |
| ------------------------------------- | ----------------------------------------- |
| Ecosystem Compatibility (Spring Boot) | Hibernate (default and most compatible)   |
| Jakarta EE / Java EE full compliance  | EclipseLink                               |
| Multi-database (SQL + NoSQL) support  | DataNucleus                               |
| Very lightweight JPA needs            | Older projects may use OpenJPA (rare now) |

## How to Configure a JPA Implementation in Spring Boot ?

In Spring Boot, "**configuring a JPA implementation**" means:

* Deciding **which JPA provider (implementation)** we want (Hibernate, EclipseLink, etc.).
* Setting up **how** it interacts with:
  * our **database** (MySQL, PostgreSQL, etc.),
  * our **entities** (`@Entity` classes),
  * and our **application behavior** (schema generation, SQL output, transactions, etc.).

Spring Boot **auto-configures** most of the JPA setup, but we can **override and fine-tune it** manually.

### JPA Provider Selection (By Default)

* If we add only:

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>
```

**Hibernate** is **automatically chosen** as the JPA provider.

{% hint style="info" %}
**Why?**

* `spring-boot-starter-data-jpa` has a **transitive dependency** on Hibernate (comes with `hibernate-core.jar`).
* Spring Boot looks for available providers on the classpath. Hibernate wins by default if found.
{% endhint %}

If we want another provider (like EclipseLink):

* **Exclude Hibernate** from the starter.
* **Add EclipseLink** dependency manually.

Example (Maven):

```xml
<!-- Starter without Hibernate -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
    <exclusions>
        <exclusion>
            <groupId>org.hibernate</groupId>
            <artifactId>hibernate-core</artifactId>
        </exclusion>
    </exclusions>
</dependency>

<!-- Add EclipseLink separately -->
<dependency>
    <groupId>org.eclipse.persistence</groupId>
    <artifactId>eclipselink</artifactId>
    <version>3.0.2</version>
</dependency>
```

Additionally, we must **tell Spring Boot** to use a different `JpaVendorAdapter`.

### Configuration in application.properties

Spring Boot uses externalized configuration.

Common JPA-related properties we configure

```properties
# Data Source
spring.datasource.url=jdbc:mysql://localhost:3306/yourdb
spring.datasource.username=youruser
spring.datasource.password=yourpass
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# JPA Settings
spring.jpa.database-platform=org.hibernate.dialect.MySQLDialect
spring.jpa.show-sql=true
spring.jpa.hibernate.ddl-auto=update
spring.jpa.open-in-view=false
```

**Details**

<table data-full-width="true"><thead><tr><th width="294.02734375">Property</th><th>Purpose</th></tr></thead><tbody><tr><td><code>spring.datasource.*</code></td><td>DB connection properties (URL, username, password, driver).</td></tr><tr><td><code>spring.jpa.database-platform</code></td><td>Force dialect if needed (Hibernate dialect, or EclipseLink equivalent).</td></tr><tr><td><code>spring.jpa.show-sql</code></td><td>Logs generated SQL queries to console.</td></tr><tr><td><code>spring.jpa.hibernate.ddl-auto</code></td><td>Control schema generation: <code>none</code>, <code>validate</code>, <code>update</code>, <code>create</code>, <code>create-drop</code>.</td></tr><tr><td><code>spring.jpa.open-in-view</code></td><td>Controls EntityManager session scope (per transaction vs per web request).</td></tr></tbody></table>

Spring Boot internally configures a `JpaVendorAdapter`

| Implementation                | Purpose                          |
| ----------------------------- | -------------------------------- |
| `HibernateJpaVendorAdapter`   | Hibernate-specific behaviors.    |
| `EclipseLinkJpaVendorAdapter` | EclipseLink-specific behaviors.  |
| `OpenJpaVendorAdapter`        | Apache OpenJPA-specific behavior |

## What Happens Behind the Scenes ?

When Spring Boot starts:

1. Detects JPA provider on the classpath (Hibernate usually).
2. Auto-configures:
   * `EntityManagerFactory`
   * `TransactionManager`
   * `JpaVendorAdapter`
3. Reads `application.properties` or `application.yml`
4. Applies properties to JPA internals.
5. Starts connection to database.
6. Scans for `@Entity` classes automatically if packages are set up properly.
7. If `ddl-auto` is `update` or `create`, generates schema automatically.
8. Opens Persistence Contexts for request/transaction scopes.







