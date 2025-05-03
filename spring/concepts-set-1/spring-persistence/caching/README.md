# Caching

## About

Caching is a technique used to store frequently accessed data in memory so that future requests can be served faster without repeatedly hitting the database. In the context of Spring JPA, caching improves performance by reducing the number of database queries.

### Types of Caching

There are three levels of caching relevant to Spring JPA:

1\. First-Level Cache (L1)\
2\. Second-Level Cache (L2)\
3\. Spring Cache Abstraction (Custom Caching)

## 1. First-Level Cache (L1) — JPA EntityManager Cache

### About

The **First-Level Cache (L1)** is a **built-in cache provided by JPA/Hibernate** that operates at the **`EntityManager` level**.\
It caches entities **within a single persistence context (i.e., within a single transaction or session)**.

It is always **enabled by default**, and **you don’t need to configure anything** to use it.

### Key Characteristics

* **Scope:** Per `EntityManager` / per transaction (in Spring, usually one per method with `@Transactional`).
* **Automatic:** Managed by the persistence provider; no setup required.
* **Short-lived:** Cleared at the end of a transaction or method scope.
* **Non-shared:** Not visible across transactions, threads, or service calls.
* **Cache Key:** Based on entity class and primary key (e.g., `Employee` with ID `1`).

### How it Works ?

When you retrieve an entity using `EntityManager.find()` or `JpaRepository.findById()`:

1. Hibernate first checks the **first-level cache** (in-memory, tied to the `EntityManager`).
2. If found, it **returns the cached entity** without querying the database.
3. If not found, it **queries the DB**, loads the entity, and stores it in the L1 cache for later reuse **within the same transaction**.

### Example

```java
@Transactional
public void fetchEmployeeTwice() {
    Employee emp1 = employeeRepository.findById(1L).orElseThrow(); // Hits DB
    Employee emp2 = employeeRepository.findById(1L).orElseThrow(); // Comes from L1 cache

    // emp1 == emp2 (same object instance)
}

public void outsideTransaction() {
        Employee e1 = employeeRepository.findById(100L).orElseThrow(); // hits DB
        Employee e2 = employeeRepository.findById(100L).orElseThrow(); // hits DB again
    }
```

* The second call does **not hit the DB** again — the entity is served from the L1 cache.
* Both `emp1` and `emp2` refer to the **same object in memory**.

### Why is This Useful ?

* **Reduces repeated database queries** in the same transaction.
* **Improves performance** without additional memory or configuration.
* **Ensures entity consistency** within the same transaction (modifying `emp1` affects `emp2`).

{% hint style="info" %}
#### What Is and Isn’t Cached ?

Yes - Entities fetched by `find`, `getReference`, or `query` methods\
Yes - Entities loaded within a `@Transactional` method

No - Entities fetched **in a different transaction**\
No - Native SQL results unless mapped to entities\
No - Entities evicted manually or modified externally (not tracked)
{% endhint %}

### How is It Cleared ?

* When the `EntityManager` is closed (end of transaction/method).
* When you call `EntityManager.clear()` or `flush()`.
* It is never shared outside the current transaction.

## 2. Second-Level Cache (L2) — Hibernate Shared Cache

### About

The **Second-Level Cache (L2)** is a **shared cache across sessions or transactions**.\
Unlike the first-level cache (L1) which is tied to a single `EntityManager`, L2 is **global for the application** (within the same JVM) and requires **explicit configuration**.

It stores **entity data between transactions**, helping avoid database hits when the same data is accessed repeatedly across different transactions or service calls.

### Key Characteristics

* **Scope:** Application-wide / SessionFactory-wide
* **Requires Configuration:** Must be explicitly enabled
* **Backed by Providers:** Needs a caching provider like Ehcache, Hazelcast, Caffeine, etc.
* **Shared Across Transactions:** Works across different sessions or `@Transactional` methods
* **Only Entity Caching by Default:** Can cache entities, queries, and collections (if enabled)

### How It Works ?

1. An entity is fetched from the database in transaction A and stored in L2 cache.
2. Later, transaction B requests the same entity — it is served from the L2 cache **without a DB hit**.
3. L2 uses an **external cache provider** like Ehcache to persist that entity temporarily in memory.

### Example Use Case

```java
// Transaction 1
employeeRepository.findById(100L); // Hits DB, stores in L2

// Transaction 2 (later)
employeeRepository.findById(100L); // Served from L2 cache (no DB hit)
```

### Cache Providers

We need to plug in a **provider** for L2 to work:

* **Ehcache** – widely used, recommended
* **Caffeine** – high-performance, Java-only
* **Hazelcast / Infinispan** – for distributed use cases

### How to Enable in Spring Boot (Hibernate + Ehcache)

**1. Add dependencies to `pom.xml`**

```xml
<dependency>
    <groupId>org.hibernate.orm</groupId>
    <artifactId>hibernate-ehcache</artifactId>
</dependency>
```

**2. application.properties**

```properties
spring.jpa.properties.hibernate.cache.use_second_level_cache=true
spring.jpa.properties.hibernate.cache.region.factory_class=org.hibernate.cache.jcache.JCacheRegionFactory
spring.cache.jcache.config=classpath:ehcache.xml
```

**3. Annotate Entities**

```java
@Entity
@Cacheable
@org.hibernate.annotations.Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Employee {
    @Id
    private Long id;
    private String name;
}
```

### Cache Strategy Types

Hibernate provides various strategies:

* `READ_ONLY` – Best for immutable data
* `NONSTRICT_READ_WRITE` – For mostly read data, occasional updates
* `READ_WRITE` – Ensures consistency with updates (uses locks)
* `TRANSACTIONAL` – For full transactional guarantees (requires JTA)

#### Example with Strategy

```java
@Entity
@Cacheable
@org.hibernate.annotations.Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Department {
    @Id
    private Long id;
    private String name;
}
```

### When to Use L2 Cache ?

Yes - When the same entity data is accessed frequently\
Yes - When DB reads are heavy and data changes infrequently\
Yes -When response time is critical (reduce DB latency)

No - When data changes very frequently\
No - When DB and cache could go out of sync\
No - If you're already caching at service or controller level

## 3. Spring Cache Abstraction (Custom Caching)





