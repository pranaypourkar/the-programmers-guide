# Caching

## About

When using JDBC directly (or via frameworks like Spring JDBC), caching can occur at multiple levels. These caches are essential for improving performance, reducing network round-trips, and avoiding repetitive database operations. Unlike JPA/Hibernate, JDBC does not provide automatic entity-level caching, but other forms of caching still play a significant role.

## 1. Prepared Statement Cache (Statement Caching)

* JDBC allows frequently executed SQL queries to be **prepared once and reused**, improving performance by avoiding repeated parsing and planning.
* Most **Connection Pool implementations** (like HikariCP) support **prepared statement caching**.
* This cache stores compiled SQL statements in memory so that re-execution doesn't recompile the SQL.

**Best practice:**

* Use `cachePrepStmts=true`, `prepStmtCacheSize`, and `prepStmtCacheSqlLimit` with your JDBC driver.
*   Example (for MySQL):

    ```
    spring.datasource.hikari.data-source-properties.cachePrepStmts=true
    spring.datasource.hikari.data-source-properties.prepStmtCacheSize=250
    spring.datasource.hikari.data-source-properties.prepStmtCacheSqlLimit=2048
    ```

## 2. ResultSet Caching

* JDBC **does not cache results by default**.
* If you need caching of query results, you must **implement it manually** (e.g., in memory using a `Map`, or use a caching layer like **Spring Cache** or **Caffeine**).
* Useful when the data changes rarely (e.g., lookup tables like countries, currencies).

**Best practice:**

* Avoid caching large or frequently-changing results.
* Use a caching abstraction to refresh data based on a time-to-live (TTL) policy.

## 3. Connection Pool Cache

* Datasource connection pooling (like in HikariCP) caches physical DB connections.
* This is not data caching, but **resource caching**, ensuring that new DB connections are not created on every request.
* It drastically reduces latency and overhead of creating TCP connections and handshakes.

**Best practice:**

* Always use a connection pool like HikariCP.
* Monitor connection pool health to avoid saturation or idle connection leaks.

## 4. Database-side Caching

* Many databases (like Oracle, PostgreSQL, MySQL) have internal caching (e.g., **buffer cache**, **query plan cache**, **disk block cache**).
* These work automatically and optimize repeated access to data or plans.

**Best practice:**

* Design queries and indexing to benefit from these DB caches.
* Reduce frequent full-table scans and ensure proper use of bind parameters.

## 5. Application-level Caching with JDBC

* In JDBC applications, you can use **manual or framework-based caching** (e.g., Spring Cache abstraction with providers like Ehcache, Redis, or Caffeine).
* For example, caching the result of a heavy JDBC query using Spring’s `@Cacheable`.

```java
@Cacheable("employeeSummary")
public List<EmployeeSummary> getEmployeeSummary() {
    return jdbcTemplate.query("SELECT * FROM employee_summary", rowMapper);
}
```
