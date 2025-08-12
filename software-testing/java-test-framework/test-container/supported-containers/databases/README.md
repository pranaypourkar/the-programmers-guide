# Databases

## About

Databases are the most commonly tested component in backend systems and Testcontainers offers robust, production-like containers to test against **real database engines**. Instead of relying on in-memory databases (like H2 or HSQLDB), which often behave differently from production systems, we can use Testcontainers to spin up the **actual database** in a container dynamically, per test class or per test method.

This approach enables **reliable integration tests**, helps prevent environment-specific issues, and ensures your tests interact with the same SQL dialect, features, and behaviors as our production setup.

## **Why Use Testcontainers for Databases?**

1. **Production Parity**\
   Run tests against the actual database engine (e.g., PostgreSQL, Oracle XE, MySQL), eliminating discrepancies between test and prod environments.
2. **Isolation and Repeatability**\
   Each test can start with a fresh database state. No leftover data. No cross-test pollution.
3. **No Local Setup Required**\
   Developers don't need to install or configure the database locally. It all runs inside a Docker container, orchestrated automatically by the test.
4. **Cross-Platform CI Support**\
   Works seamlessly in CI/CD pipelines tests behave the same whether on a laptop or in GitHub Actions, GitLab CI, Jenkins, or Bitbucket Pipelines.
5. **Scripted Initialization**\
   Easily preload data or create schema using `init.sql`, `Flyway`, or `Liquibase` when the container starts.

## **Features**

* Full support for test lifecycle management via JUnit 4/5.
* Built-in image support for many major databases.
* Dynamic injection of JDBC URL, username, password using `@DynamicPropertySource` or Spring `TestPropertySource`.
* Option to customize ports, time zones, startup strategies, volumes, and networking.

## **Popular Database Containers**

<table><thead><tr><th width="152.47222900390625">Database</th><th>Notes</th></tr></thead><tbody><tr><td><strong>PostgreSQL</strong></td><td>Fast and most widely used with Testcontainers.</td></tr><tr><td><strong>MySQL</strong></td><td>Supports MySQL 5.x and 8.x variants.</td></tr><tr><td><strong>Oracle XE</strong></td><td>Useful for enterprise apps. Uses <code>gvenzl/oracle-xe</code> image.</td></tr><tr><td><strong>MongoDB</strong></td><td>Non-relational (NoSQL) support for document-based testing.</td></tr><tr><td><strong>MS SQL Server</strong></td><td>Requires Linux-compatible Docker host. Good for .NET &#x26; Java hybrid apps.</td></tr><tr><td><strong>MariaDB</strong></td><td>Drop-in MySQL replacement.</td></tr></tbody></table>
