# Best Practices in JDBC Usage

## About

Using JDBC efficiently requires more than just connecting to a database and running queries. Proper usage ensures **performance, reliability, security**, and **maintainability** in your Java applications.

## 1. Resource Management

#### Always Close JDBC Resources

JDBC objects such as `Connection`, `Statement`, and `ResultSet` consume critical system and database resources.

**Best Practice:** Use **try-with-resources** (Java 7+) to automatically close these resources:

```java
try (Connection conn = DriverManager.getConnection(...);
     PreparedStatement ps = conn.prepareStatement(...);
     ResultSet rs = ps.executeQuery()) {
    // Use ResultSet
}
```

If using older Java:

```java
finally {
    try { rs.close(); } catch (Exception e) {}
    try { stmt.close(); } catch (Exception e) {}
    try { conn.close(); } catch (Exception e) {}
}
```

## 2. Use of `PreparedStatement`

#### Avoid `Statement` for Dynamic Queries

Using `PreparedStatement` protects against **SQL injection**, improves performance (via query pre-compilation), and ensures cleaner code.

```java
PreparedStatement ps = conn.prepareStatement(
    "SELECT * FROM users WHERE email = ?");
ps.setString(1, userInputEmail);
```

Never do this:

```java
Statement stmt = conn.createStatement();
stmt.executeQuery("SELECT * FROM users WHERE email = '" + userInputEmail + "'");
```

### 3. Connection Management

#### Use Connection Pooling

Creating a `Connection` is **expensive**. In real-world applications, always use a **Connection Pool** like:

* HikariCP (recommended for Spring Boot)
* Apache DBCP
* C3P0

This improves:

* **Performance**
* **Scalability**
* **Thread safety**

## 4. Transaction Management

#### Handle Transactions Manually for DML Operations

Turn off auto-commit when dealing with multiple queries that must execute as a single transaction:

```java
conn.setAutoCommit(false);
try {
    // multiple statements
    conn.commit();
} catch (SQLException e) {
    conn.rollback();
}
```

Avoid leaving auto-commit ON during multi-step operations—this may lead to **data inconsistency**.

## 5. Batch Processing

#### Use Batch Updates for Bulk Inserts/Updates

Avoid inserting/updating records one-by-one. Use batching to improve performance:

```java
PreparedStatement ps = conn.prepareStatement("INSERT INTO users VALUES (?, ?)");
for (User u : users) {
    ps.setString(1, u.getName());
    ps.setString(2, u.getEmail());
    ps.addBatch();
}
ps.executeBatch();
```

This reduces network round-trips and load on the DB server.

### 6. Exception Handling

#### Catch and Log `SQLException` with All Details

Always log:

* SQL State
* Error Code
* Message

```java
} catch (SQLException e) {
    System.err.println("SQLState: " + e.getSQLState());
    System.err.println("ErrorCode: " + e.getErrorCode());
    e.printStackTrace();
}
```

Use custom exception handling wrappers in large applications for better control and reusability.

## 7. Avoid Hardcoding Connection Parameters

#### Externalize Configuration

Never hardcode DB URL, username, or password in source code.

**Use:**

* `.properties` files
* Environment variables
* Secrets manager (for production)

## 8. Use Database Metadata Carefully

`DatabaseMetaData` and `ResultSetMetaData` are powerful but expensive to use at runtime. Use only when necessary (e.g., writing generic query tools).

## 9. Use Correct Fetch Sizes

For large result sets, set an appropriate fetch size:

```java
Statement stmt = conn.createStatement();
stmt.setFetchSize(100);
```

This avoids memory overflows during large queries.

## 10. Avoid Unnecessary Queries

Only fetch needed columns:

```sql
SELECT id, name FROM users -- Y
```

Avoid:

```sql
SELECT * FROM users -- ❌
```

## 11. Use Logging/Monitoring Tools

Integrate tools like:

* P6Spy
* Spring Boot Actuator
* Log4J/SLF4J for query logging

These help in diagnosing slow queries, connection leaks, and bottlenecks.

## 12. Security Best Practices

* Sanitize all user inputs (though `PreparedStatement` handles most)
* Never expose DB errors to end users
* Use the **least privilege principle** for DB users
* Always use **encrypted connections** (SSL/TLS) in production
