# JDBC Components

## About

JDBC provides a standard set of **Java interfaces and classes** that enable communication with relational databases. These components abstract the underlying database operations, making database interactions in Java **uniform, flexible, and vendor-independent**.

The **core JDBC components** include:

1. `DriverManager`
2. `Driver`
3. `Connection`
4. `Statement`
5. `PreparedStatement`
6. `CallableStatement`
7. `ResultSet`
8. `SQLException`
9. `DatabaseMetaData`
10. `ResultSetMetaData`

### 1. DriverManager

**Role:** `DriverManager` is a **class** in the `java.sql` package responsible for managing a list of database drivers.

#### Responsibilities

* Loads JDBC drivers at runtime.
* Establishes connections to the database via `getConnection()` method.
* Acts as a **factory** for `Connection` objects.

#### Example

```java
Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mydb", "root", "password");
```

#### Internal Mechanism

* It scans registered drivers and delegates the connection request to the appropriate `Driver`.

### 2. Driver

**Role:** Driver is an **interface** that every JDBC driver class must implement. It acts as a **bridge** between DriverManager and the actual database.

#### Responsibilities

* Understand the connection URL and initiate database communication.
* Register itself with `DriverManager`.

#### Example

```java
public class MySQLDriver implements Driver {
    static {
        DriverManager.registerDriver(new MySQLDriver());
    }
}
```

Note: Most modern drivers auto-register using `META-INF/services/java.sql.Driver`.

### 3. Connection

**Role:** `Connection` is an **interface** representing a session/connection with the database.

#### Responsibilities

* Creates `Statement`, `PreparedStatement`, `CallableStatement`.
* Manages **transactions** (commit, rollback).
* Provides access to metadata.
* Controls connection settings like auto-commit, isolation level.

#### Example

```java
Connection conn = DriverManager.getConnection(...);
conn.setAutoCommit(false);
conn.commit();
```

#### Important Methods

* `createStatement()`
* `prepareStatement()`
* `setAutoCommit(boolean)`
* `commit()`
* `rollback()`
* `close()`

### 4. Statement

**Role:** `Statement` is an **interface** used to execute static SQL queries.

#### Responsibilities

* Executes DDL and DML queries without input parameters.
* Returns results via `ResultSet`.

#### Example

```java
Statement stmt = conn.createStatement();
ResultSet rs = stmt.executeQuery("SELECT * FROM users");
```

#### Limitations

* Not suitable for dynamic queries.
* Prone to SQL injection.
* Poor performance on repeated queries due to re-parsing.

### 5. PreparedStatement

**Role:** `PreparedStatement` extends `Statement` and is used to execute **parameterized queries**.

#### Responsibilities

* Precompiles the SQL query for better performance.
* Prevents SQL injection.
* Suitable for repeated queries.

#### Example

```java
PreparedStatement ps = conn.prepareStatement(
    "SELECT * FROM users WHERE id = ?");
ps.setInt(1, 101);
ResultSet rs = ps.executeQuery();
```

#### Advantages

* Improved performance.
* Safe input handling.
* Supports batch processing.

### 6. CallableStatement

**Role:** Used to **execute stored procedures** in the database.

#### Responsibilities

* Handles IN, OUT, and INOUT parameters.
* Useful for business logic embedded in the database.

#### Example

```java
CallableStatement cs = conn.prepareCall("{call getUserDetails(?)}");
cs.setInt(1, 101);
ResultSet rs = cs.executeQuery();
```

### 7. ResultSet

**Role:** `ResultSet` represents the **tabular data** returned by SQL queries.

#### Responsibilities

* Navigates through the result set (next, previous, absolute, etc.).
* Retrieves column data by index or name.

#### Example

```java
while (rs.next()) {
    int id = rs.getInt("id");
    String name = rs.getString("name");
}
```

#### Cursor Types

* TYPE\_FORWARD\_ONLY
* TYPE\_SCROLL\_INSENSITIVE
* TYPE\_SCROLL\_SENSITIVE

#### Concurrency Modes:

* CONCUR\_READ\_ONLY
* CONCUR\_UPDATABLE

### 8. SQLException

**Role:** Handles **database access errors** and other SQL-related issues.

#### Responsibilities

* Provides details about errors (SQL state, error code, message).
* Supports chained exceptions.

#### Example

```java
try {
    // DB code
} catch (SQLException e) {
    System.out.println("Error Code: " + e.getErrorCode());
    System.out.println("SQL State: " + e.getSQLState());
    e.printStackTrace();
}
```

### 9. DatabaseMetaData

**Role:** Provides **metadata about the database** such as tables, users, supported features, etc.

#### Responsibilities

* Discover table names, schemas, column data types.
* Check for support of SQL features or data types.

#### Example

```java
DatabaseMetaData metaData = conn.getMetaData();
ResultSet tables = metaData.getTables(null, null, "%", new String[] {"TABLE"});
```

### 10. ResultSetMetaData

**Role:** Provides **metadata about the ResultSet**, such as column count, column name, data type.

#### Responsibilities

* Useful in dynamic query execution or generic data processing.

#### Example

```java
ResultSetMetaData rsmd = rs.getMetaData();
int columnCount = rsmd.getColumnCount();
for (int i = 1; i <= columnCount; i++) {
    System.out.println(rsmd.getColumnName(i));
}
```

## Lifecycle of JDBC Components

1. **Driver registration** (`Driver` with `DriverManager`)
2. **Create a connection** (`Connection`)
3. **Create and execute query** (`Statement` / `PreparedStatement`)
4. **Process results** (`ResultSet`)
5. **Close resources** (important to prevent leaks)

## Interactions

* `DriverManager` returns a `Connection`.
* `Connection` creates `Statement` or its variants.
* `Statement` executes SQL and returns a `ResultSet`.
* `ResultSet` is used to read data row by row.
* Exceptions during these operations are captured by `SQLException`.
