# Terminology

### Data

Data is a collection of a distinct small unit of information.

### Database

The database is a collection of inter-related data which is used to retrieve, insert, update and delete the data efficiently. It is also used to organize the data in the form of a table, schema, views, and reports, etc. For example, the employee database organizes the data about the employee, department,  etc.

### **Table**

A structured set of data elements, organized in rows and columns. Tables are the primary structure in a relational database.

### **Row**

Also known as a record, it represents a single, complete set of related data in a table.

### **Column**

Also known as a field, it represents a single attribute of data in a table.

### **Primary Key**

A column or set of columns that uniquely identifies each row in a table. It ensures data integrity and provides a way to reference individual records.

### **Foreign Key**

A column or set of columns in one table that references the primary key in another table. It establishes a relationship between the two tables.

### **Index**

An optional structure associated with a table to improve the speed of data retrieval. Indexes are created on columns to quickly locate rows in a table.

### **Query**

A request for data or information from a database. SQL queries are used to retrieve, insert, update, or delete data from tables

### **Normalization**

A process of organizing data in a database to reduce redundancy and dependency. It involves dividing large tables into smaller, related tables and defining relationships between them.

### **Transaction**

A single unit of work performed within a database management system. It can consist of one or more SQL statements that are executed as a single operation.

### **View**

A virtual table generated from the result of a SQL query. Views do not store data themselves but provide a way to present data stored in tables in a customized format.

### **Stored Procedure**

A pre-compiled collection of SQL statements that are stored and executed on the database server. Stored procedures can accept input parameters and return multiple values.

### **Trigger**

A special type of stored procedure that is automatically executed or fired in response to specific events, such as data manipulation (insert, update, delete) on a table.

### **Clauses**

Components within a statement that define specific actions (e.g., SELECT clause in a SELECT statement).

### Operator

A special keyword used to join or change clauses within a WHERE clause. Also known as logical operators. Eg. OR, AND, IN etc

### **Degree**

Represents the number of columns in a table. It indicates the complexity of each record (row) in the table. A higher degree (more columns) can provide richer data but also increases storage requirements and complexity of managing the data.\
**Example**: A Customers table with columns for CustomerID, FirstName, LastName, Email, and PhoneNumber has a degree of 5.

### **Cardinality**

Represents the number of rows in a table. It indicates the overall size or volume of data stored in the table. A higher cardinality (more rows) can lead to larger storage needs and potentially slower query performance for retrieving data.\
**Example**: A Customers table with information for 1000 customers has a cardinality of 1000.

