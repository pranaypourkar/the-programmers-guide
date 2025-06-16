# Transaction Management

## About

In JDBC, transaction management is handled manually by controlling the auto-commit behavior of a `Connection` object. JDBC transactions allow us to group multiple SQL operations into a single atomic unit of work. If one of the operations fails, we can roll back the entire transaction to maintain data consistency.

## **1. Basics of JDBC Transactions**

By default, JDBC connections operate in **auto-commit mode**. This means every SQL statement is immediately committed after execution. For proper transaction management, you must **disable auto-commit** and explicitly commit or roll back the transaction.

**Example (without Spring):**

```java
Connection conn = dataSource.getConnection();
try {
    conn.setAutoCommit(false); // start transaction

    // Execute multiple SQL statements
    PreparedStatement stmt1 = conn.prepareStatement("INSERT INTO employee ...");
    stmt1.executeUpdate();

    PreparedStatement stmt2 = conn.prepareStatement("UPDATE salary ...");
    stmt2.executeUpdate();

    conn.commit(); // commit if everything succeeds
} catch (SQLException e) {
    conn.rollback(); // rollback on any failure
    throw e;
} finally {
    conn.setAutoCommit(true); // restore default behavior
    conn.close();
}
```

## **2. Spring JDBC Transaction Management**

Spring provides a higher-level abstraction for managing transactions, often through:

* Declarative approach using `@Transactional`
* Programmatic approach using `TransactionTemplate`

Spring will manage the `Connection`, disable auto-commit, and commit or roll back the transaction based on the method execution and exceptions.

**Example (declarative):**

```java
@Transactional
public void performTransfer() {
    jdbcTemplate.update("UPDATE account SET balance = balance - 100 WHERE id = 1");
    jdbcTemplate.update("UPDATE account SET balance = balance + 100 WHERE id = 2");
}
```

In this case:

* Spring will automatically manage the transaction boundaries.
* If any exception is thrown inside the method, the entire transaction will be rolled back.

## Important Points

* **Auto-commit**
  * Enabled by default. Each SQL is committed automatically.
  * Must be set to false to begin a manual transaction.
* **Commit**
  * Used to make all changes made during the transaction permanent.
* **Rollback**
  * Used to revert all changes made during the transaction if an error occurs.
* **Savepoints**
  * We can define intermediate points in a transaction to roll back partially instead of the whole transaction.
  *   Example:

      ```java
      Savepoint savepoint = conn.setSavepoint();
      // do something
      conn.rollback(savepoint); // rollback only to savepoint
      ```

## Common Mistakes to Avoid

* Not resetting `autoCommit` to `true` after transaction ends (can cause issues if connection is reused).
* Not closing the `Connection` in a `finally` block (can lead to leaks).
* Assuming database rollback will always happen automatically (some databases require explicit rollback).

## When to Use JDBC-level Transactions ?

* When working directly with JDBC or Spring JDBC (`JdbcTemplate`).
* In small projects without the need for ORM or JPA.
* When we need precise, low-level control over transaction boundaries.
* When using stored procedures, or performing complex batch operations.
