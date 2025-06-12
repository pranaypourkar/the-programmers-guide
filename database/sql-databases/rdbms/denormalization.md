# Denormalization

## About

Denormalization is the process of restructuring a database to optimize read performance by combining tables and reducing the need for joins. This is achieved by introducing controlled redundancy to avoid complex queries, especially in read-heavy applications.

Unlike normalization, which ensures minimal redundancy and data integrity, denormalization prioritizes query performance at the cost of storage efficiency. It is widely used in data warehouses, analytics platforms, and reporting systems where read operations are more frequent than write operations.

## **Objectives of Denormalization**

Denormalization is performed with specific goals in mind:

### **1. Improve Query Performance**

* Reducing **JOIN operations** across multiple tables speeds up query execution.
* This is especially useful for large-scale **data retrieval** in OLAP (Online Analytical Processing) systems.

### **2. Reduce Computational Overhead**

* JOINs require CPU cycles and **temporary memory allocation**.
* Pre-joining data in a **denormalized structure** reduces query complexity.

### **3. Optimize Read-Heavy Workloads**

* **Data warehouses, dashboards, and analytics platforms** prioritize fast retrieval over data integrity.
* By keeping frequently accessed data together, **report generation and analytics become faster**.

### **4. Simplify Query Logic**

* Complex **JOIN-heavy queries** become **simpler and easier to maintain**.
* Reduces the need for **nested subqueries and multi-table aggregations**.

### **5. Reduce Index Overhead**

* More **indexes** on **normalized tables** mean more storage and maintenance overhead.
* Fewer indexes in a **denormalized schema** reduce **update costs**.

### **6. Balance Performance vs Storage Trade-offs**

* Accepting **some redundancy** in exchange for **faster query execution**.
* Commonly used in applications where **performance is more critical than storage cost**.

## **Techniques of Denormalization**

Denormalization is achieved through **various techniques**, each suited for different use cases.

### **1. Adding Redundant Data**

* **Duplicate columns** from related tables to reduce JOINs.
* Example: Storing `DeptName` directly in the `Employees` table instead of joining with `Departments`.

### **2. Precomputed Aggregations**

* Prestore **SUM, AVG, COUNT, MIN, MAX** values in tables instead of computing dynamically.
* Useful in **dashboard reports** where calculations are expensive.

### **3. Merging Tables**

* Instead of **separating related entities** into multiple tables, store them in a **single denormalized table**.
* Example: Combining **Orders** and **OrderDetails** into a single table.

### **4. Using Arrays or JSON**

* Instead of **splitting multi-valued attributes** into separate rows, store them as JSON/arrays.
* Example: Storing a list of **product categories** as a JSON array in a single column instead of a separate lookup table.

### **5. Materialized Views**

* **Store precomputed results** from queries to avoid expensive joins on every request.
* Common in **data warehousing and analytical databases**.

## **Example of Denormalization**

### **1. Normalized Database (3NF)**

Consider an **e-commerce system** with the following normalized tables:

**Customers Table**

```
+---------+-----------+----------------+
| CustID  | Name      | Email          |
+---------+-----------+----------------+
| 1001    | Alice     | alice@email.com|
| 1002    | Bob       | bob@email.com  |
+---------+-----------+----------------+
```

**Orders Table**

```
+---------+---------+------------+
| OrderID | CustID  | OrderDate  |
+---------+---------+------------+
| 5001    | 1001    | 2024-01-01 |
| 5002    | 1002    | 2024-02-01 |
+---------+---------+------------+
```

**Products Table**

```
+---------+-------------+--------+
| ProdID  | Name        | Price  |
+---------+-------------+--------+
| 2001    | Laptop      | 800    |
| 2002    | Phone       | 500    |
+---------+-------------+--------+
```

**OrderDetails Table**

```
+---------+---------+-------+----------+
| OrderID | ProdID  | Qty   | Price    |
+---------+---------+-------+----------+
| 5001    | 2001    | 1     | 800      |
| 5001    | 2002    | 2     | 1000     |
| 5002    | 2002    | 1     | 500      |
+---------+---------+-------+----------+
```

**Query Performance Issue:** To fetch **a customer's order details**, multiple joins are needed:

```sql
SELECT C.Name, O.OrderID, P.Name, OD.Qty, OD.Price  
FROM Customers C  
JOIN Orders O ON C.CustID = O.CustID  
JOIN OrderDetails OD ON O.OrderID = OD.OrderID  
JOIN Products P ON OD.ProdID = P.ProdID  
WHERE C.CustID = 1001;
```

This requires **four JOINs**, increasing **latency**.

### **2. Denormalized Database**

Instead of separate tables, we can store **order data directly in one table**:

```
+---------+---------+----------------+-----------------------------+
| OrderID | CustID  | CustomerName   | Products                    |
+---------+---------+----------------+-----------------------------+
| 5001    | 1001    | Alice          | Laptop-1, Phone-2 ($1800)   |
| 5002    | 1002    | Bob            | Phone-1 ($500)              |
+---------+---------+----------------+-----------------------------+
```

Now, fetching order details requires **only one SELECT query**:

```sql
SELECT * FROM Orders WHERE CustID = 1001;
```

## Is Denormalization applicable only to SQL or NoSQL also?

Denormalization is applicable to **both SQL and NoSQL** databases, but the way it is implemented differs.

### **1. Denormalization in SQL Databases (RDBMS)**

* In traditional relational databases (SQL-based), denormalization is a deliberate design choice to optimize read-heavy workloads.
* It is often used in data warehouses, reporting systems, and high-performance applications where minimizing JOIN operations is crucial.
* Techniques include adding redundant columns, merging tables, precomputing aggregations, and using materialized views.

**Example in SQL (Denormalized Table)**\
Instead of separate `Customers` and `Orders` tables:

```sql
+---------+---------+--------------+----------------+
| OrderID | CustID  | CustomerName | Products       |
+---------+---------+--------------+----------------+
| 5001    | 1001    | Alice        | Laptop, Phone  |
| 5002    | 1002    | Bob          | Phone         |
+---------+---------+--------------+----------------+
```

This avoids costly JOINs in queries.

### **2. Denormalization in NoSQL Databases**

* NoSQL databases **naturally favor denormalization** because they prioritize **scalability and read** performance.
* Unlike SQL, where normalization is the default, NoSQL databases are typically designed with denormalized structures from the start.
* NoSQL databases such as MongoDB (document-based), Cassandra (wide-column), and Redis (key-value) use embedded documents, wide-column storage, and key-value lookups to store redundant data for fast access.

**Example in NoSQL (MongoDB Document Model)**\
Instead of separate collections for users and orders, denormalization allows embedding:

```json
{
    "orderId": "5001",
    "customer": {
        "custId": "1001",
        "name": "Alice"
    },
    "products": [
        { "name": "Laptop", "price": 800 },
        { "name": "Phone", "price": 500 }
    ]
}
```

* This avoids JOIN-like operations and allows faster queries at the cost of redundancy.
* Updating customer data is more complex since it exists in multiple documents.
