# RDBMS

## **Description**

**RDBMS** stands for Relational Database Management System_._ A Relational Database Management System (RDBMS) is a type of database management system that stores data in a structured format, using tables consisting of rows and columns. All modern database management systems like SQL, MS SQL Server, ORACLE, MySQL, and Microsoft Access are based on RDBMS.

{% hint style="info" %}
It is called Relational Database Management System (RDBMS) because it is based on the relational model introduced by E.F. Codd.
{% endhint %}

<figure><img src="../../.gitbook/assets/image.png" alt=""><figcaption></figcaption></figure>

## **Key Points**

### **Data Model**

RDBMS follows the relational model of data, proposed by Edgar F. Codd in the 1970s. Data is organized into tables, where each table represents a relation. A table consists of <mark style="background-color:purple;">rows (also known as tuples or records)</mark> and <mark style="background-color:green;">columns (also known as attributes or fields)</mark>. Tables can have relationships with each other through keys, such as primary keys and foreign keys.

### **Data Integrity**

RDBMS enforces data integrity constraints to maintain the accuracy and consistency of data. Primary key constraints ensure that each row in a table is uniquely identified. Foreign key constraints enforce referential integrity between related tables, ensuring that relationships between tables remain valid.

These are the following categories of data integrity which exist with each RDBMS:

* <mark style="background-color:yellow;">Entity integrity</mark>: It specifies that there should be no duplicate rows in a table.
* <mark style="background-color:yellow;">Domain integrity:</mark> It enforces valid entries for a given column by restricting the type, the format, or the range of values.
* <mark style="background-color:yellow;">Referential integrity</mark>: It specifies that rows cannot be deleted, which are used by other records.
* <mark style="background-color:yellow;">User-defined integrity</mark>: It enforces some specific business rules defined by users. These rules are different from the entity, domain, or referential integrity.

### **ACID Properties**

RDBMS ensures transactions adhere to the ACID properties:

* <mark style="background-color:green;">Atomicity</mark>: Transactions are atomic, meaning they are either fully completed or fully aborted.
* <mark style="background-color:green;">Consistency</mark>: Transactions maintain data consistency by preserving integrity constraints.
* <mark style="background-color:green;">Isolation</mark>: Transactions are isolated from each other to prevent interference.
* <mark style="background-color:green;">Durability</mark>: Committed transactions are durably stored and not lost due to system failures.

### **Query Language**

RDBMS uses Structured Query Language (SQL) as the standard language for querying and manipulating data. SQL provides a set of commands for creating, modifying, and querying database objects such as tables, indexes, and views.

### **Normalization**

RDBMS supports database normalization, a process of organizing data to reduce redundancy and dependency. Normalization involves decomposing large tables into smaller, related tables and defining relationships between them to minimize data duplication.

### **Indexes**

RDBMS allows the creation of indexes on columns to improve the performance of data retrieval operations. Indexes provide fast access to rows based on the values of indexed columns, similar to the index of a book.

### **Transactions and Concurrency Control**

RDBMS handles concurrent access to data by multiple users or applications through concurrency control mechanisms. It ensures that transactions are executed in a serialized manner to maintain data consistency and isolation.

### **Security**

RDBMS provides security features such as authentication, authorization, and access control to protect sensitive data. Users can be granted or revoked permissions to access database objects based on their roles and privileges.

### **Backup and Recovery**

RDBMS offers tools and utilities for performing backups of database contents and restoring them in the event of data loss or system failures. Backup and recovery mechanisms ensure data durability and availability.





