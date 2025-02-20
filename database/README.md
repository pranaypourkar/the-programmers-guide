# Database

## About

Databases are organized collections of structured or unstructured data that enable efficient storage, retrieval, and management. They are essential for applications ranging from simple websites to complex enterprise systems.

## Features of Databases

* **Data Organization** – Stores data in structured formats like tables (SQL) or flexible formats (NoSQL).
* **Data Integrity & Consistency** – Ensures accuracy and reliability.
* **Scalability** – Supports increasing amounts of data and users.
* **Concurrency Control** – Manages multiple users accessing data simultaneously.
* **Security** – Provides authentication, authorization, and encryption features.
* **Backup & Recovery** – Ensures data safety through automated backups and failover mechanisms.

## **Types of Databases**

### **1. Relational Databases (SQL)**

* Use structured tables and relationships.
* Examples: MySQL, PostgreSQL, Oracle, SQL Server.

### **2. NoSQL Databases**

* Handle unstructured or semi-structured data with flexible schemas.
* Examples: MongoDB (Document-based), Redis (Key-Value), Cassandra (Column-based), Neo4j (Graph-based).

### **3. Object-Oriented Databases**

* Store data as objects similar to programming paradigms.
* Example: db4o, ObjectDB.

### **4. Columnar Databases**

* Optimize storage for analytical queries by storing data in columns.
* Examples: Apache HBase, Amazon Redshift.

### **5. Time-Series Databases**

* Designed for storing time-stamped data efficiently.
* Examples: InfluxDB, TimescaleDB.

### **6. Graph Databases**

* Store data as interconnected nodes and edges for relationship-heavy data.
* Example: Neo4j, ArangoDB.

## **Choosing the Right Database**

* **For Structured Data & Transactions:** Use SQL databases like MySQL or PostgreSQL.
* **For Scalability & Unstructured Data:** Use NoSQL databases like MongoDB.
* **For Analytics & Reporting:** Use Columnar databases like Amazon Redshift.
* **For Time-Series Data:** Use InfluxDB or TimescaleDB.
* **For Complex Relationships:** Use Graph databases like Neo4j.

## **Database vs. DBMS**

<table data-full-width="true"><thead><tr><th width="195">Feature</th><th>Database</th><th>DBMS</th></tr></thead><tbody><tr><td>Definition</td><td>Collection of structured/unstructured data.</td><td>Software that manages database operations.</td></tr><tr><td>Example</td><td>Tables in MySQL, Documents in MongoDB.</td><td>MySQL Server, MongoDB, Oracle DBMS.</td></tr><tr><td>Functionality</td><td>Passive data storage.</td><td>Provides querying, security, backup, and access control.</td></tr><tr><td>User Interaction</td><td>No direct user interaction.</td><td>Users interact through SQL, APIs, and tools.</td></tr></tbody></table>
