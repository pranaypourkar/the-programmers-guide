# Connection Pooling

## About

Connection pooling is a technique used to manage database connections efficiently by reusing a set of established connections instead of opening a new one for every database operation. Creating a database connection is an expensive operation, and without pooling, every request would result in a new connection, leading to high latency and resource exhaustion.

Spring and most Java applications rely heavily on connection pooling to improve performance, scalability, and reliability when accessing a relational database.

## What is Connection Pooling ?

Connection pooling is the process of maintaining a cache (or pool) of database connections. When a request needs to access the database, it borrows an existing connection from the pool. Once the operation is done, the connection is returned to the pool, making it available for other requests. This avoids the overhead of repeatedly opening and closing database connections.

## Why is Connection Pooling Important ?

* Reduces latency caused by frequent opening/closing of connections.
* Reuses existing connections to save database resources.
* Supports concurrency by allowing multiple threads to use the pool concurrently.
* Enhances application performance under load.
* Helps control the maximum number of open database connections.

## How It Works ?

1. Application starts and the connection pool initializes a set of pre-created database connections.
2. When the application needs to access the database, it requests a connection from the pool.
3. The pool provides an available connection.
4. The application performs its operations and returns the connection to the pool.
5. The pool manages idle time, removes dead connections, and can grow or shrink based on configuration.

## Common Connection Pool Libraries

Several libraries implement connection pooling in Java. Spring Boot supports them out of the box.

* HikariCP (default in Spring Boot)
* Apache Commons DBCP / DBCP2
* C3P0
* Tomcat JDBC Pool
