# Normalization

## About

Normalization is the process of organizing a relational database to **reduce data redundancy and improve data integrity**. It divides larger tables into smaller, related tables and defines relationships between them.

{% hint style="success" %}
Normalization and denormalization are two fundamental concepts in relational database management systems (RDBMS) used to structure and optimize data storage.

* **Normalization** focuses on reducing redundancy and ensuring data integrity by organizing data into multiple related tables.
* **Denormalization** is the process of combining tables to improve read performance by reducing joins at the cost of increased redundancy.
{% endhint %}

## Objectives of Normalization

Normalization is a **database design process** that organizes data efficiently to minimize redundancy and dependency. It is done through a series of rules called **normal forms (1NF, 2NF, 3NF, BCNF, etc.)**. The primary objectives of normalization are:

### **1. Eliminate Data Redundancy (Avoid Storing Duplicate Data)**

* **What it means:** Ensure that data is **not unnecessarily duplicated** across tables.
* **Why it's important:** Redundant data wastes storage space and increases the risk of inconsistencies.
*   **Example:**

    * **Without Normalization:** A customer’s details (name, email, address) are stored in every row of the "Orders" table.
    * **With Normalization:** Customer details are moved to a separate **Customers** table, and the "Orders" table only references the **Customer ID**.

    **❌ Unnormalized Table (Data Redundancy)**

    ```
    Orders Table:
    +-----------+------------+------------+-------------------+
    | Order ID  | Customer   | Email      | Address           |
    +-----------+------------+------------+-------------------+
    | 101       | John Doe   | john@email | NY, USA          |
    | 102       | John Doe   | john@email | NY, USA          |
    | 103       | Alice Lee  | alice@email| CA, USA          |
    +-----------+------------+------------+-------------------+
    ```

    **✅ Normalized Tables (No Redundancy)**

    ```
    Customers Table:
    +------------+----------+------------+------------+
    | CustomerID | Name     | Email      | Address    |
    +------------+----------+------------+------------+
    | 1          | John Doe | john@email | NY, USA    |
    | 2          | Alice Lee| alice@email| CA, USA    |
    +------------+----------+------------+------------+

    Orders Table:
    +-----------+------------+
    | Order ID  | CustomerID |
    +-----------+------------+
    | 101       | 1          |
    | 102       | 1          |
    | 103       | 2          |
    +-----------+------------+
    ```
* **Impact:** Less storage space required and reduced data duplication.

### **2. Ensure Data Integrity and Consistency**

* **What it means:** Keep data accurate and **avoid contradictions**.
* **Why it's important:** If the same data is stored in multiple places, updating one but not the other creates **inconsistencies**.
*   **Example:**

    * If John Doe's email changes, we only update it in the **Customers** table, ensuring **all references remain accurate**.

    **❌ Without Normalization:**

    * Changing a customer’s email means **updating multiple rows** in the orders table, which increases the risk of inconsistent data.

    **✅ With Normalization:**

    * The customer’s email exists in a single place, ensuring **data consistency**.

### **3. Reduce Update Anomalies (Insertion, Update, Deletion Issues)**

Normalization prevents **three types of anomalies**:

#### **Insertion Anomaly**

* **Problem:** In an unnormalized table, adding a new customer **without an order** may be impossible.
*   **Example:**

    * If the **Orders** table stores customer details, we **can't insert a new customer** unless they place an order.

    **✅ Solution (Normalization):**

    * A separate **Customers** table allows storing customers **independently** of their orders.

#### **Update Anomaly**

* **Problem:** Updating redundant data in multiple rows can lead to **inconsistencies**.
*   **Example:**

    * If a customer changes their email, we must update it **everywhere it appears**.
    * If one row is missed, the database has **conflicting emails**.

    **✅ Solution (Normalization):**

    * Store the email in the **Customers** table and reference it in other tables.

#### **Deletion Anomaly**

* **Problem:** Deleting one piece of data **accidentally removes important related data**.
*   **Example:**

    * If the last order of a customer is deleted, their **entire record (name, email, etc.) may be lost** in an unnormalized table.

    **✅ Solution (Normalization):**

    * Keep customer data in a **separate table**, ensuring it isn’t lost when orders are deleted.

### **4. Improve Data Maintainability**

* **What it means:** Make it easier to **manage, update, and scale** the database.
* **Why it's important:**
  * A well-normalized database is **easier to modify** when business rules change.
  * Queries are **more efficient** since they work with **smaller, structured tables**.
* **Example:**
  * Adding a new **customer attribute (e.g., phone number)** requires only **modifying the Customers table**, instead of searching and updating multiple tables.

## **Normal Forms (NF)**

Normalization is achieved through **normal forms**, each eliminating a specific type of redundancy or anomaly.

### **First Normal Form (1NF)**

A table is in **1NF** if:

* Each column contains **atomic** values (no multiple values in a single column).
* Each row is uniquely identifiable (has a primary key).

**Example:**

```
Non-1NF Table:
---------------------------
StudentID | Name  | Subjects
---------------------------
101       | Alice | Math, Physics
102       | Bob   | Chemistry
```

```

1NF Table:
-------------------------------
StudentID | Name  | Subject
-------------------------------
101       | Alice | Math
101       | Alice | Physics
102       | Bob   | Chemistry
```

### **Second Normal Form (2NF)**

A table is in **2NF** if:

* It is already in **1NF**.
* **No partial dependency exists** (i.e., non-key attributes or columns must depend on the entire primary key, not just part of it).

{% hint style="success" %}
Partial dependency occurs only in tables with a composite primary key (a primary key with multiple columns).
{% endhint %}

**Example:**

```
Non-2NF Table (Composite Key Issue) (Composite Key - StudentID, CourseID)
--------------------------------------------------
StudentID | CourseID | StudentName | CourseName
--------------------------------------------------
101       | C01      | Alice       | Math
101       | C02      | Alice       | Physics
102       | C03      | Bob         | Chemistry
```

* `StudentName` depends only on `StudentID`, not on `CourseID`.
* `CourseName` depends only on `CourseID`, not on `StudentID`.

**Solution (Separate Tables)**:

```
Students Table:
----------------------
StudentID | Name
----------------------
101       | Alice
102       | Bob
```

```

Courses Table:
----------------------
CourseID | CourseName
----------------------
C01      | Math
C02      | Physics
C03      | Chemistry
```

```

StudentCourses Table (Mapping):
----------------------
StudentID | CourseID
----------------------
101       | C01
101       | C02
102       | C03
```

### **Third Normal Form (3NF)**

A table is in **3NF** if:

* It is already in **2NF**.
* **No transitive dependency exists** (i.e., every non-key column must depend only on the primary key, not another non-key column).

{% hint style="success" %}
Transitive dependency occurs when a non-key attribute depends on another non-key attribute instead of directly on the primary key.
{% endhint %}

**Example (Non-3NF Table):**

```
Employees Table:
----------------------------
EmpID | Name  | DeptID | DeptName
----------------------------
1     | John  | D01    | HR
2     | Alice | D02    | Finance
```

* `DeptName` depends on `DeptID`, **not directly on `EmpID`**.

**Solution (Separate Tables)**:

```
Employees Table:
----------------------
EmpID | Name  | DeptID
----------------------
1     | John  | D01
2     | Alice | D02
```

```

Departments Table:
----------------------
DeptID | DeptName
----------------------
D01    | HR
D02    | Finance
```

### **Boyce-Codd Normal Form (BCNF)**

BCNF  is an advanced version of 3NF (Third Normal Form) that eliminates certain anomalies that 3NF does not handle. It is stricter than 3NF and ensures that there are no functional dependencies (FDs) where a non-superkey attribute determines a key attribute.

A table is in **BCNF** if:

1. It is in **3NF** (i.e., no transitive dependencies).
2. **For every functional dependency (X → Y), X should be a super key**.
   * A **super key** is any set of attributes that uniquely identifies a row in a table.

{% hint style="success" %}
What is a Functional Dependency?

A **functional dependency (FD)** is a relationship between attributes in a **database table**, where **one set of attributes (X) uniquely determines another set of attributes (Y)**.

**Mathematically:**

> If two rows have the same values for X, then they must have the same values for Y.\
> This is denoted as:\
> **X → Y (X determines Y)**

* **X (Determinant)**: The attribute(s) that determine the value of Y.
* **Y (Dependent)**: The attribute(s) whose value depends on X.
{% endhint %}

#### **Examples**

**Example 1:** 3NF Table (But Not BCNF)

**Table: `Course_Instructor`**

| Course\_ID | Instructor | Room\_No |
| ---------- | ---------- | -------- |
| CS101      | Prof. A    | R101     |
| CS102      | Prof. B    | R102     |
| CS103      | Prof. C    | R101     |

* Composite primary key is (CourseID, Instructor) because:
  * Each course can have multiple instructors.
  * Each instructor can teach multiple courses.
* Candidate Keys: `{Course_ID, Instructor}` and `{Course_ID, Room_No}`
* Functional Dependencies:
  * `Course_ID → Room_No` (A course is always assigned to the same room).
  * `Instructor → Room_No` (Each instructor teaches in only one room).

**Issue:** `Instructor → Room_No` creates a dependency where a non-superkey (`Instructor`) determines a part of the primary key (`Room_No`). This violates BCNF

#### **Converting to BCNF (Decomposition)**

To remove the BCNF violation, we **split the table** into two:

#### **Table 1: `Course`**

| Course\_ID | Room\_No |
| ---------- | -------- |
| CS101      | R101     |
| CS102      | R102     |
| CS103      | R101     |

#### **Table 2: `Instructor_Room`**

| Instructor | Room\_No |
| ---------- | -------- |
| Prof. A    | R101     |
| Prof. B    | R102     |
| Prof. C    | R101     |

Now, both tables satisfy BCNF because:

* `Course_ID → Room_No` holds in `Course`, but `Course_ID` is a superkey.
* `Instructor → Room_No` holds in `Instructor_Room`, but `Instructor` is a superkey

**Example 2:** Employee-Project Relationship

Consider the following table:

| EmployeeID | EmployeeName | ProjectID | ProjectName  | Department |
| ---------- | ------------ | --------- | ------------ | ---------- |
| 101        | Alice        | P1        | AI Research  | R\&D       |
| 102        | Bob          | P1        | AI Research  | R\&D       |
| 103        | Charlie      | P2        | Data Science | R\&D       |
| 104        | David        | P3        | Cloud Infra  | IT         |
| 105        | Alice        | P3        | Cloud Infra  | IT         |

This is not in BCNF because:

* The composite primary key is `(EmployeeID, ProjectID)`, meaning an employee can work on multiple projects.
* The **Department** depends only on **ProjectName** (not the full key), leading to a **partial dependency**.
* If we update the department of a project, we must update multiple rows → **data inconsistency**.

**Convert to BCNF**

To satisfy BCNF, we remove the partial dependency and create **two separate tables**.

**Table 1: Employee-Project Assignment (BCNF)**

| EmployeeID | EmployeeName | ProjectID |
| ---------- | ------------ | --------- |
| 101        | Alice        | P1        |
| 102        | Bob          | P1        |
| 103        | Charlie      | P2        |
| 104        | David        | P3        |
| 105        | Alice        | P3        |

**Table 2: Project Information (BCNF)**

| ProjectID | ProjectName  | Department |
| --------- | ------------ | ---------- |
| P1        | AI Research  | R\&D       |
| P2        | Data Science | R\&D       |
| P3        | Cloud Infra  | IT         |

## Is Normalization applicable only to SQL ?

Normalization is **primarily applicable to SQL (relational) databases**, but the concept can also be applied in certain NoSQL databases where data integrity and efficient storage are needed.

### **1. Normalization in SQL (Relational Databases)**

Normalization is a **fundamental design principle** in SQL databases like **MySQL, PostgreSQL, SQL Server, and Oracle**. Since SQL databases follow the **ACID (Atomicity, Consistency, Isolation, Durability)** principles, normalization helps in:

* Reducing data redundancy
* Ensuring data integrity
* Minimizing update anomalies
* Optimizing storage

**Example:**

* Instead of storing customer and order details in one large table, they are split into separate **Customers** and **Orders** tables, with a foreign key linking them.
* This follows **First Normal Form (1NF), Second Normal Form (2NF), etc.**, up to **Boyce-Codd Normal Form (BCNF)**.

### **2. Normalization in NoSQL (Non-Relational Databases)**

NoSQL databases like **MongoDB, Cassandra, Redis, and DynamoDB** generally favor **denormalization** because:

* They prioritize **high-speed reads** and **scalability** over strict data integrity.
* They avoid **complex joins**, which can be slow in distributed systems.

However, **some NoSQL databases still use normalized structures** in certain cases:

* **Graph Databases (Neo4j, ArangoDB)**

Nodes and relationships resemble a **normalized schema**, where data is stored in separate entities.

* **Document Databases (MongoDB, CouchDB)**

Can reference other documents (similar to foreign keys in SQL), leading to a **partially normalized approach**.

* **Wide-Column Stores (Cassandra, HBase)**

Typically denormalized, but data modeling can involve some level of normalization to reduce redundancy in write-heavy workloads.
