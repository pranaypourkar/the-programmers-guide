# HikariCP

## About

HikariCP is a fast, lightweight, reliable JDBC connection pool library. It is the default connection pool implementation used in Spring Boot (from version 2.x onwards). HikariCP is known for its performance, low overhead, and minimal configuration needs, yet it provides powerful tuning options.

## What is HikariCP ?

HikariCP is a JDBC connection pool implementation designed to be extremely fast and simple to use. It manages a pool of active database connections that can be reused, avoiding the cost of establishing a new connection for every request.

{% hint style="info" %}
Hikari means "light" in Japanese, reflecting the library’s goal to be lightweight and fast.
{% endhint %}

## Key Features

* Minimal footprint with low latency and high throughput
* Asynchronous house-keeping
* Fast connection acquisition
* Leak detection support
* Built-in connection health checks
* JDBC4-compliant
* Excellent performance under load

## Default in Spring Boot

Starting from Spring Boot 2.0, HikariCP is the default DataSource. Spring Boot will automatically configure it when it detects `spring.datasource.*` properties.

Minimal setup via `application.properties`:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/test_db
spring.datasource.username=root
spring.datasource.password=root
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
```

Spring Boot will detect HikariCP in the classpath and configure it automatically.

## Properties

### Commonly Used HikariCP Properties

<table data-full-width="true"><thead><tr><th>Property</th><th>Description</th><th>Best Practice</th></tr></thead><tbody><tr><td><code>spring.datasource.hikari.pool-name</code></td><td>Name of the connection pool</td><td>Use meaningful names for easier debugging/logging</td></tr><tr><td><code>spring.datasource.hikari.maximum-pool-size</code></td><td>Maximum number of connections in the pool (default: 10)</td><td>Set based on DB capacity and concurrent load; typically 10–30</td></tr><tr><td><code>spring.datasource.hikari.minimum-idle</code></td><td>Minimum number of idle connections in the pool</td><td>Set equal to <code>maximum-pool-size</code> to avoid pool shrinking</td></tr><tr><td><code>spring.datasource.hikari.idle-timeout</code></td><td>Maximum idle time (ms) for a connection before it's removed</td><td>Set lower for low-traffic apps; 30000 (30s) is good</td></tr><tr><td><code>spring.datasource.hikari.connection-timeout</code></td><td>Max time (ms) to wait for a connection from the pool</td><td>Keep between 20000–30000; too low may cause exceptions under load</td></tr><tr><td><code>spring.datasource.hikari.max-lifetime</code></td><td>Maximum lifetime (ms) of a connection before it’s recycled</td><td>Set slightly less than DB’s timeout (e.g. 1800000 = 30 min)</td></tr><tr><td><code>spring.datasource.hikari.leak-detection-threshold</code></td><td>Logs a warning if a connection is held longer than this (ms)</td><td>Use 15000–30000 in dev/test to detect leaks</td></tr><tr><td><code>spring.datasource.hikari.validation-timeout</code></td><td>Timeout (ms) for validating a connection</td><td>Default is 5000; reduce if you see slow validation</td></tr></tbody></table>

### Other Useful Properties

<table data-full-width="true"><thead><tr><th>Property</th><th>Description</th><th>Best Practice</th></tr></thead><tbody><tr><td><code>spring.datasource.hikari.auto-commit</code></td><td>Auto-commit behavior for connections (default: true)</td><td>Set to false if you use transactions explicitly</td></tr><tr><td><code>spring.datasource.hikari.read-only</code></td><td>Set connections to read-only if you're not modifying data</td><td>Use in read-heavy/reporting apps</td></tr><tr><td><code>spring.datasource.hikari.initialization-fail-timeout</code></td><td>Time (ms) to wait before failing startup if DB is down (default: 1ms)</td><td>Set to <code>-1</code> to disable fail-fast during startup</td></tr><tr><td><code>spring.datasource.hikari.isolate-internal-queries</code></td><td>If true, internal queries run in their own connection state</td><td>Keep false unless you suspect conflicts</td></tr><tr><td><code>spring.datasource.hikari.allow-pool-suspension</code></td><td>Allows pool to be suspended and resumed</td><td>Rarely used; keep false unless required</td></tr><tr><td><code>spring.datasource.hikari.keepalive-time</code></td><td>Prevents idle connections from being closed if they haven’t timed out</td><td>Set if your DB closes idle connections before <code>max-lifetime</code></td></tr><tr><td><code>spring.datasource.hikari.catalog</code></td><td>Sets the default catalog for connections</td><td>Use only if your app needs a specific catalog</td></tr><tr><td><code>spring.datasource.hikari.schema</code></td><td>Sets the default schema</td><td>Set when multiple schemas are used in the DB</td></tr><tr><td><code>spring.datasource.hikari.connection-init-sql</code></td><td>SQL executed after a connection is created</td><td>Useful for DB-level session parameters (e.g. <code>SET timezone</code>)</td></tr></tbody></table>

### Validation Settings

HikariCP doesn't use `testOnBorrow`, `testWhileIdle`, etc. like other pools. Instead:

<table data-full-width="true"><thead><tr><th>Property</th><th>Description</th><th>Best Practice</th></tr></thead><tbody><tr><td><code>spring.datasource.hikari.connection-test-query</code></td><td>Custom query to test connection validity</td><td>HikariCP auto-detects based on driver; override if needed</td></tr><tr><td><code>spring.datasource.hikari.validation-timeout</code></td><td>Timeout (ms) to complete a validation query</td><td>Keep 1000–5000ms depending on DB response time</td></tr></tbody></table>

## Best Practices for HikariCP in Spring Boot

1. **Set the pool size based on database and application capacity**
   * `maximum-pool-size` should reflect the concurrency your database can handle.
   * Start with 10–30 depending on expected load.
   * Never exceed the database’s allowed max connections.
2. **Match `minimum-idle` to `maximum-pool-size` in high-throughput systems**
   * Prevents idle connections from being closed and recreated constantly.
   * Helps maintain performance during sudden traffic spikes.
3. **Use `max-lifetime` below the database’s timeout**
   * If your database closes idle connections after 30 minutes, set `max-lifetime` to 25–28 minutes.
   * Prevents "connection closed" errors due to backend timeout.
4. **Set `idle-timeout` lower than `max-lifetime`**
   * Prevents unnecessary long-held idle connections.
   * Example: `idle-timeout = 30000`, `max-lifetime = 1800000`.
5. **Enable `leak-detection-threshold` during development**
   * Helps identify when connections are not being closed.
   * Example: `leak-detection-threshold = 15000` (15 seconds).
6. **Use `connection-timeout` based on SLA and latency**
   * Set it reasonably low to avoid users waiting too long.
   * Default is 30 seconds; values between 10,000–20,000 ms work well in most cases.
7. **Avoid using long-living transactions**
   * These hold connections longer and reduce pool availability.
   * Always close EntityManagers, JDBC connections, or Sessions properly.
8. **Set `auto-commit` wisely**
   * Default is true; disable only if you manage transactions explicitly.
   * Mismatched auto-commit settings can cause silent data issues.
9. **Avoid unnecessary validation queries**
   * Hikari automatically chooses efficient methods (e.g., JDBC’s isValid()).
   * Only use `connection-test-query` if absolutely necessary.
10. **Monitor pool behavior using Spring Boot Actuator**
    * Enable `management.endpoints.web.exposure.include=*` and inspect metrics like:
      * `hikaricp.connections.active`
      * `hikaricp.connections.idle`
      * `hikaricp.connections.pending`
      * `hikaricp.connections.usage`
11. **Avoid frequent restart of the application or forcing pool shutdown**
    * Closing pools too often (especially in microservices) leads to socket issues or DB throttling.
    * Let the pool recycle connections naturally.
12. **Consider using a separate pool or datasource for batch/long-running jobs**
    * This avoids blocking web requests while a few threads hold connections for long-running tasks.
13. **Use the latest HikariCP and JDBC drivers**
    * Keeps your app secure, stable, and compatible with database enhancements.
14. **Avoid having too many pools in a microservice environment**
    * One well-tuned pool per service is ideal.
    * Multiple small pools can starve the DB if misconfigured.
15. **Use profiling tools like VisualVM, JConsole, or Spring Boot Micrometer**
    * Helps understand real-time pool usage, bottlenecks, and leak points.

