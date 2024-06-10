# RDBMS

## **Description**

**RDBMS** stands for Relational Database Management System_._ A Relational Database Management System (RDBMS) is a type of database management system that stores data in a structured format, using tables consisting of rows and columns. All modern database management systems like SQL, MS SQL Server, ORACLE, MySQL, and Microsoft Access are based on RDBMS.

{% hint style="info" %}
It is called Relational Database Management System (RDBMS) because it is based on the relational model introduced by E.F. Codd.
{% endhint %}

<figure><img src="../../../.gitbook/assets/image (3) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

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

{% hint style="info" %}
Most commonly used constraint available in SQL&#x20;

NOT NULL Constraint - Ensures that a column cannot have a NULL value.&#x20;

DEFAULT Constraint - Provides a default value for a column when none is specified.&#x20;

UNIQUE Key - Ensures that all the values in a column are different.&#x20;

PRIMARY Key - Uniquely identifies each row/record in a database table.&#x20;

FOREIGN Key - Uniquely identifies a row/record in any another database table.&#x20;

CHECK Constraint - Ensures that all values in a column satisfy certain conditions.&#x20;

INDEX Constraint - Used to create and retrieve data from the database very quickly.
{% endhint %}

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

There are two goals of this normalization process −

* Eliminating redundant data, for example, storing the same data in more than one table.
* Ensuring data dependencies make sense.

By following these goals, it will help reduce the amount of space a database consumes and ensures that data is logically stored. Normalization consists of a series of guidelines that help guide you in creating a good database structure.

Normalization guidelines are divided into **normal forms**; it is like a format or the way a database structure is laid out. The aim of normal forms is to organize the database structure, so that it complies with the rules of first normal form, then second normal form and finally the third normal form. It is up to us to take it further and go to the Fourth Normal Form, Fifth Normal Form and so on, but in general, the Third Normal Form is more than enough for a normal Database Application.

1. <mark style="background-color:purple;">First Normal Form (1NF)</mark>

In 1NF, a table is said to be in the first normal form if it meets the following criteria:

* Rule 1 (Atomic Values):  Every column of a table should contain only atomic values and not a set of values or a composite value. An atomic value is a value that cannot be divided further.
* Rule 2 (No Repeating Groups): There are no repeating groups of data. This means a table should not contain repeating columns. All columns should have a unique name.

<mark style="background-color:yellow;">Example Violation of 1NF:</mark>

Imagine a table storing customer information with a column named "Phones" where you list all the customer's phone numbers separated by commas. This violates 1NF because a single cell holds multiple values.&#x20;

Imagine a table storing information about employees, with columns named "EmployeeID", "FirstName", "LastName1", and another column also named "LastName2". This table violates 1NF because it has two columns which stores last name.

{% hint style="info" %}
No RDBMS allow you to create two columns with exactly the same name within a single table.
{% endhint %}

2. <mark style="background-color:purple;">Second Normal Form (2NF)</mark>

In 2NF, a table is in the second normal form if it meets the following criteria:

* Rule 1: It is already in 1NF.
* Rule 2: All non-key attributes are fully functionally dependent on the primary key. Means, there should be no partial dependencies, meaning that each non-key attribute is dependent on the entire primary key, not just part of it.

<mark style="background-color:yellow;">Example Violation of 1NF:</mark>

Consider a table storing order details with columns for OrderID, CustomerID, CustomerName, and Product details (Product name, price, etc.). This violates 2NF because Customer name depends on CustomerID, which is only a part of the primary key (likely OrderID and CustomerID together).

3. <mark style="background-color:purple;">Third Normal Form (3NF)</mark>

In 3NF, a table is in the third normal form if it meets the following criteria:

* Rule 1: It is already in 2NF.
* Rule 2: It has no transitive dependencies. A transitive dependency occurs when a non-key attribute depends on another non-key attribute, which is itself dependent on the primary key. In 3NF, all non-key attributes are directly dependent on the primary key, and there are no indirect dependencies between non-key attributes.

<mark style="background-color:yellow;">Example Violation of 1NF:</mark>

In the following table the street name, city and the state are bound to their zip code.

```
CREATE TABLE CUSTOMERS(
   CUST_ID       INT              NOT NULL,
   CUST_NAME     VARCHAR (20)      NOT NULL,
   DOB           DATE,
   STREET        VARCHAR(200),
   CITY          VARCHAR(100),
   STATE         VARCHAR(100),
   ZIP           VARCHAR(12),
   EMAIL_ID      VARCHAR(256),
   PRIMARY KEY (CUST_ID)
);
```

The dependency between the zip code and the address is called as a transitive dependency. To comply with the third normal form, we need to move the Street, City and the State fields into their own table, which can be called as the Zip Code table.

### **Indexes**

RDBMS allows the creation of indexes on columns to improve the performance of data retrieval operations. Indexes provide fast access to rows based on the values of indexed columns, similar to the index of a book.

### **Transactions and Concurrency Control**

RDBMS handles concurrent access to data by multiple users or applications through concurrency control mechanisms. It ensures that transactions are executed in a serialized manner to maintain data consistency and isolation.

### **Security**

RDBMS provides security features such as authentication, authorization, and access control to protect sensitive data. Users can be granted or revoked permissions to access database objects based on their roles and privileges.

### **Backup and Recovery**

RDBMS offers tools and utilities for performing backups of database contents and restoring them in the event of data loss or system failures. Backup and recovery mechanisms ensure data durability and availability.



## Difference between DBMS and RDBMS

RDBMS is a specific type of DBMS with a more structured approach.

<table data-full-width="true"><thead><tr><th width="91">No.</th><th>DBMS</th><th>RDBMS</th></tr></thead><tbody><tr><td>1)</td><td>DBMS applications store <strong>data as file</strong>.</td><td>RDBMS applications store <strong>data in a tabular form</strong>.</td></tr><tr><td>2)</td><td>In DBMS, data is generally stored in either a hierarchical form or a navigational form.</td><td>In RDBMS, the tables have an identifier called primary key and the data values are stored in the form of tables.</td></tr><tr><td>3)</td><td><strong>Normalization is not</strong> present in DBMS.</td><td><strong>Normalization is</strong> present in RDBMS.</td></tr><tr><td>4)</td><td>DBMS does <strong>not apply any security</strong> with regards to data manipulation.</td><td>RDBMS <strong>defines the integrity constraint</strong> for the purpose of ACID (Atomocity, Consistency, Isolation and Durability) property.</td></tr><tr><td>5)</td><td>DBMS uses file system to store data, so there will be <strong>no relation between the tables</strong>.</td><td>in RDBMS, data values are stored in the form of tables, so a <strong>relationship</strong> between these data values will be stored in the form of a table as well.</td></tr><tr><td>6)</td><td>DBMS has to provide some uniform methods to access the stored information.</td><td>RDBMS system supports a tabular structure of the data and a relationship between them to access the stored information.</td></tr><tr><td>7)</td><td>DBMS <strong>does not support distributed database</strong>.</td><td>RDBMS <strong>supports distributed database</strong>.</td></tr><tr><td>8)</td><td>Examples of DBMS are file systems, <strong>xml</strong> etc.</td><td>Example of RDBMS are <strong>mysql</strong>, <strong>postgre</strong>, <strong>sql server</strong>, <strong>oracle</strong> etc.</td></tr></tbody></table>

