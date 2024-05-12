# RDBMS

**RDBMS** stands for Relational Database Management System_._ A Relational Database Management System (RDBMS) is a type of database management system that stores data in a structured format, using tables consisting of rows and columns. All modern database management systems like SQL, MS SQL Server, ORACLE, MySQL, and Microsoft Access are based on RDBMS.

{% hint style="info" %}
It is called Relational Database Management System (RDBMS) because it is based on the relational model introduced by E.F. Codd.
{% endhint %}

<figure><img src="../../.gitbook/assets/image.png" alt=""><figcaption></figcaption></figure>

**Data Model**:

RDBMS follows the relational model of data, proposed by Edgar F. Codd in the 1970s.

* Data is organized into tables, where each table represents a relation.
* A table consists of rows (also known as tuples or records) and columns (also known as attributes or fields).
* Tables can have relationships with each other through keys, such as primary keys and foreign keys.

1. **Data Integrity**:
   * RDBMS enforces data integrity constraints to maintain the accuracy and consistency of data.
   * Primary key constraints ensure that each row in a table is uniquely identified.
   * Foreign key constraints enforce referential integrity between related tables, ensuring that relationships between tables remain valid.
2. **ACID Properties**:
   * RDBMS ensures transactions adhere to the ACID properties:
     * Atomicity: Transactions are atomic, meaning they are either fully completed or fully aborted.
     * Consistency: Transactions maintain data consistency by preserving integrity constraints.
     * Isolation: Transactions are isolated from each other to prevent interference.
     * Durability: Committed transactions are durably stored and not lost due to system failures.
3. **Query Language**:
   * RDBMS uses Structured Query Language (SQL) as the standard language for querying and manipulating data.
   * SQL provides a set of commands for creating, modifying, and querying database objects such as tables, indexes, and views.
4. **Normalization**:
   * RDBMS supports database normalization, a process of organizing data to reduce redundancy and dependency.
   * Normalization involves decomposing large tables into smaller, related tables and defining relationships between them to minimize data duplication.
5. **Indexes**:
   * RDBMS allows the creation of indexes on columns to improve the performance of data retrieval operations.
   * Indexes provide fast access to rows based on the values of indexed columns, similar to the index of a book.
6. **Transactions and Concurrency Control**:
   * RDBMS handles concurrent access to data by multiple users or applications through concurrency control mechanisms.
   * It ensures that transactions are executed in a serialized manner to maintain data consistency and isolation.
7. **Security**:
   * RDBMS provides security features such as authentication, authorization, and access control to protect sensitive data.
   * Users can be granted or revoked permissions to access database objects based on their roles and privileges.
8. **Backup and Recovery**:
   * RDBMS offers tools and utilities for performing backups of database contents and restoring them in the event of data loss or system failures.
   * Backup and recovery mechanisms ensure data durability and availability.





