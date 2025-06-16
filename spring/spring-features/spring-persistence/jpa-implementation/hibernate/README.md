# Hibernate

## About

* **Hibernate** is a powerful **Object-Relational Mapping (ORM)** framework for Java.
* It provides an **implementation** of the **JPA specification** (but it also existed before JPA was created).
* Hibernate is both:
  * A **JPA Provider** (when used via `javax.persistence` APIs)
  * A **full-featured standalone ORM** (with its own Hibernate APIs beyond JPA)

Thus, Hibernate is **both a standard JPA implementation** **and** **an extended ORM toolkit**.

## Features of Hibernate

<table data-full-width="true"><thead><tr><th width="313.91796875">Feature</th><th>Details</th></tr></thead><tbody><tr><td><strong>ORM Mapping</strong></td><td>Maps Java objects to database tables using annotations/XML.</td></tr><tr><td><strong>Automatic SQL Generation</strong></td><td>Developers don't need to manually write SQL for most operations (save, update, delete).</td></tr><tr><td><strong>Transparent Persistence</strong></td><td>Java objects can be persisted without being aware of Hibernate-specific APIs.</td></tr><tr><td><strong>Caching</strong></td><td>Built-in first-level (mandatory) and optional second-level caching.</td></tr><tr><td><strong>Lazy Loading</strong></td><td>Association fetching is deferred until actually needed.</td></tr><tr><td><strong>Dirty Checking</strong></td><td>Hibernate automatically detects changes to managed objects and updates the database accordingly.</td></tr><tr><td><strong>HQL (Hibernate Query Language)</strong></td><td>Object-oriented SQL-like language that works with entity names and fields instead of table/column names.</td></tr><tr><td><strong>Criteria API</strong></td><td>Programmatic, typesafe query creation (prior to JPA Criteria).</td></tr><tr><td><strong>Transaction Management</strong></td><td>Supports JTA, JDBC, and manual transactions.</td></tr><tr><td><strong>Schema Generation and Validation</strong></td><td>Auto-create/update database schemas based on entity mappings.</td></tr><tr><td><strong>Custom Interceptors and Event Listeners</strong></td><td>Customize behavior during persistence events.</td></tr></tbody></table>

## Hibernate vs JPA

<table data-full-width="true"><thead><tr><th width="124.76953125">Aspect</th><th>JPA</th><th>Hibernate</th></tr></thead><tbody><tr><td><strong>Definition</strong></td><td>Java standard/specification (interface only)</td><td>Actual software framework (implementation)</td></tr><tr><td><strong>APIs</strong></td><td>Only standard APIs (e.g., <code>EntityManager</code>)</td><td>Both JPA standard APIs + Hibernate-specific APIs (e.g., <code>Session</code>)</td></tr><tr><td><strong>Vendor</strong></td><td>No vendor — just a spec maintained by Jakarta EE (previously Oracle)</td><td>Red Hat developed and maintains Hibernate</td></tr><tr><td><strong>Usage</strong></td><td>Needs an implementation like Hibernate, EclipseLink, etc.</td><td>Hibernate can work with or without JPA APIs</td></tr></tbody></table>

## Hibernate Architecture

Hibernate is **layered** internally. Here’s a breakdown:

<table data-full-width="true"><thead><tr><th width="217.98828125">Layer</th><th>Responsibility</th></tr></thead><tbody><tr><td><strong>Session Factory</strong></td><td>Startup object that initializes Hibernate internals, manages caches, and creates <code>Session</code> objects. Immutable, thread-safe object for creating <code>Session</code> instances. Very expensive to create and must be singleton.</td></tr><tr><td><strong>Session</strong></td><td>Core Hibernate object for CRUD operations, transaction boundaries, query execution. Lightweight, not thread-safe. Used for a single unit of work (transaction).</td></tr><tr><td><strong>Persistence Context</strong></td><td>Cache of managed entities (attached to Session).</td></tr><tr><td><strong>Transaction Manager</strong></td><td>Bridges Hibernate with JTA or JDBC transaction APIs.</td></tr><tr><td><strong>Connection Provider</strong></td><td>Manages database connection pooling.</td></tr><tr><td><strong>Dialect</strong></td><td>Abstracts differences between database vendors (e.g., MySQL vs Oracle).</td></tr><tr><td><strong>Entity Persister</strong></td><td>Responsible for mapping a Java entity to a table and generating SQL.</td></tr><tr><td><strong>Query Translator</strong></td><td>Parses HQL/JPQL into SQL.</td></tr><tr><td><strong>Cache Layer</strong></td><td>Provides first-level cache (mandatory) and optional second-level cache integrations (like EhCache, Infinispan).</td></tr><tr><td><strong>Interceptor</strong></td><td>Provides callbacks on entity life-cycle events.</td></tr><tr><td><strong>Event System</strong></td><td>Internally Hibernate uses an event-driven model (pre-insert, post-load, etc.).</td></tr></tbody></table>

## How Hibernate Works on a High Level ?

1. **Configuration Phase**:
   * Read `hibernate.cfg.xml` (or Spring Boot properties).
   * Scan entity classes annotated with `@Entity`.
   * Build metadata and mappings.
2. **SessionFactory Creation**:
   * Heavyweight object, created once per application.
   * Holds database connection pool, caching, dialect, etc.
3. **Session Management**:
   * For each unit of work (typically a request/transaction), a `Session` is created.
   * It manages the Persistence Context (the cache of currently managed entities).
4. **Transaction Control**:
   * Begin transaction.
   * Perform create, read, update, delete operations.
   * Commit or rollback transaction.
5. **SQL Generation and Execution**:
   * Hibernate generates SQL behind the scenes (select, insert, update, delete).
   * SQL is executed using JDBC under the hood.
6. **Flush and Synchronization**:
   * At commit or flush time, Hibernate synchronizes in-memory entity changes with the database.
7. **Session Close**:
   * After transaction commit/rollback, Session is closed.
   * Persistence Context is cleared.

## Hibernate Annotations Beyond Standard JPA

Hibernate adds its own annotations (not portable across JPA providers):

<table><thead><tr><th width="237.01171875">Annotation</th><th>Purpose</th></tr></thead><tbody><tr><td><code>@Type</code></td><td>Specify custom Hibernate-specific types.</td></tr><tr><td><code>@CreationTimestamp</code></td><td>Auto-populate a timestamp on entity creation.</td></tr><tr><td><code>@UpdateTimestamp</code></td><td>Auto-populate a timestamp on entity update.</td></tr><tr><td><code>@DynamicInsert</code></td><td>Generate SQL insert only with non-null fields.</td></tr><tr><td><code>@DynamicUpdate</code></td><td>Generate SQL update only with modified fields.</td></tr><tr><td><code>@Formula</code></td><td>Map an entity property to a SQL subquery.</td></tr><tr><td><code>@NaturalId</code></td><td>Mark an alternative key (natural ID) for the entity.</td></tr></tbody></table>

## Hibernate Caching Architecture

<table><thead><tr><th width="182.125">Cache Type</th><th>Description</th></tr></thead><tbody><tr><td><strong>First-Level Cache</strong></td><td>Mandatory. Every Session has a first-level cache (persistence context). No configuration needed.</td></tr><tr><td><strong>Second-Level Cache</strong></td><td>Optional. Shared between sessions. Requires external cache provider (e.g., Ehcache, Infinispan).</td></tr><tr><td><strong>Query Cache</strong></td><td>Caches the results of queries (especially useful for read-heavy systems). Must be enabled separately.</td></tr></tbody></table>

## Hibernate Fetch Strategies

Hibernate supports:

* **Lazy Fetching** (default for associations): Load associated entities only when accessed.
* **Eager Fetching**: Load associated entities immediately with the parent entity.

Fetching modes:

* **Join Fetch** (using SQL joins)
* **Select Fetch** (separate select statements)

Hibernate allows tuning fetch mode using `@Fetch(FetchMode.SELECT)` or `@Fetch(FetchMode.JOIN)`.

## Hibernate Session Life Cycle

Hibernate manages the **state** of an entity through different phases:

<table data-full-width="true"><thead><tr><th width="117.359375">State</th><th width="603.38671875">Meaning</th><th>Example</th></tr></thead><tbody><tr><td><strong>Transient</strong></td><td>New object not associated with any Hibernate Session; not persisted yet.</td><td><code>new User()</code></td></tr><tr><td><strong>Persistent</strong></td><td>Object is associated with an open Session and tracked; any changes are automatically detected and synchronized to DB.</td><td><code>session.save(user)</code></td></tr><tr><td><strong>Detached</strong></td><td>Object was once associated with a Session but Session is closed; changes are not automatically detected.</td><td>After <code>session.close()</code></td></tr><tr><td><strong>Removed</strong></td><td>Object is scheduled for deletion but might still exist in Session until flush.</td><td><code>session.delete(user)</code></td></tr></tbody></table>

## Hibernate in Spring Boot Context

When using Hibernate inside Spring Boot:

* Hibernate is automatically configured via `spring-boot-starter-data-jpa`.
* Default Hibernate properties are applied unless overridden.
* Hibernate SessionFactory is managed internally by Spring's EntityManagerFactory.
* We rarely interact directly with `Session` — we use JPA's `EntityManager` which is backed by Hibernate Session.

Spring Boot default Hibernate DDL options:

* `validate`, `update`, `create`, `create-drop`, `none`.

```properties
spring.jpa.hibernate.ddl-auto=update
```

## Advanced Concepts

### Batch Processing

* Hibernate can batch multiple SQL statements together to reduce database round trips.
* Example:

```properties
hibernate.jdbc.batch_size=30
```

Hibernate will batch up to 30 insert/update statements into a single network call.

**Example**

```java
Session session = sessionFactory.openSession();
Transaction tx = session.beginTransaction();
for (int i = 0; i < 1000; i++) {
    Employee emp = new Employee("Employee " + i);
    session.save(emp);
    if (i % 30 == 0) { // Flush and clear batch every 30 records
        session.flush();
        session.clear();
    }
}
tx.commit();
session.close();
```

Batch processing improves performance drastically for bulk operations.

### Stateless Session

* **StatelessSession** is a special Hibernate session that **does not maintain a persistence context** (no cache, no dirty checking).
* It behaves more like plain JDBC.

**Example**

```java
StatelessSession session = sessionFactory.openStatelessSession();
Transaction tx = session.beginTransaction();
Employee emp = new Employee("Stateless Employee");
session.insert(emp);
tx.commit();
session.close();
```

Useful for batch inserts/updates where tracking every object is costly.

### Multi-Tenancy Support

Hibernate supports **multi-tenancy** models:

<table><thead><tr><th width="162.3984375">Strategy</th><th>Meaning</th></tr></thead><tbody><tr><td><strong>DATABASE</strong></td><td>Different tenants use different physical databases.</td></tr><tr><td><strong>SCHEMA</strong></td><td>Same DB, but different schemas for tenants.</td></tr><tr><td><strong>DISCRIMINATOR</strong></td><td>Same table, a special column distinguishes tenant records.</td></tr></tbody></table>

Spring Boot + Hibernate can configure multi-tenant systems using `MultiTenantConnectionProvider` and `CurrentTenantIdentifierResolver`.





