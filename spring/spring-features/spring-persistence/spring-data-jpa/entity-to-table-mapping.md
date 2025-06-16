# Entity-to-Table Mapping

## About

* In JPA, **an Entity** (`@Entity` annotated class) **represents a table** conceptually.
* However, **just creating a Java entity class does not&#x20;**_**by itself**_**&#x20;create a table in the database** unless certain **conditions** are met.

It depends on:

* How our **JPA Provider** (Hibernate, EclipseLink, etc.) is configured.
* What **DDL (Data Definition Language) generation settings** we have.
* Whether the **database** already has tables manually created or not.

<table data-full-width="true"><thead><tr><th width="336.76953125">Step</th><th>Behavior</th></tr></thead><tbody><tr><td>We create an Entity class</td><td>It defines how a row of a table should look like (the <em>mapping</em>)</td></tr><tr><td>JPA provider (Hibernate) sees your Entity</td><td>It <em>can</em> generate a table based on your entity <em>if configured</em></td></tr><tr><td>Otherwise</td><td>JPA just expects the table already exists in the database</td></tr></tbody></table>

## Behind the Scenes in Spring Data JPA

When our Spring Boot application starts:

1. **Spring Boot Auto-configures Hibernate** as the default JPA provider.
2. Hibernate **scans all `@Entity` classes**.
3. Based on Hibernate settings, it decides whether to:
   * **Validate** against existing tables (check structure).
   * **Create** tables from scratch.
   * **Update** existing tables (alter, add missing columns).
   * **Do nothing** and assume tables are already correctly created.

## The Key Setting: `spring.jpa.hibernate.ddl-auto`

This property controls **whether Hibernate will create/update/validate the schema**.

<table data-full-width="true"><thead><tr><th width="185.9609375">Value</th><th>What Happens</th></tr></thead><tbody><tr><td><code>none</code></td><td>Do nothing — Hibernate does not touch database schema.</td></tr><tr><td><code>validate</code></td><td>Validate the schema — check if tables/columns match the Entities. Throws error if mismatch.</td></tr><tr><td><code>update</code></td><td>Update the schema — create new tables or columns as necessary.</td></tr><tr><td><code>create</code></td><td>Drop all existing tables and create new ones from Entity mappings on every application start.</td></tr><tr><td><code>create-drop</code></td><td>Same as create, but drops tables when the app stops. Useful for testing.</td></tr></tbody></table>

#### Example application.yml file

```yaml
spring:
  jpa:
    hibernate:
      ddl-auto: update
```

Result: Hibernate will **create** missing tables and columns if needed.

## What If You Don't Set `ddl-auto`?

* Spring Boot will **by default** use `create-drop` for an **in-memory database** like H2.
* For **production databases** (like MySQL, Postgres), we must set it manually or it might **assume** `none` or throw warnings.
