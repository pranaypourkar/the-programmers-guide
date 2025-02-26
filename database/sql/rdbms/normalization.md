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

* A table is in **1NF** if:
  * Each column contains **atomic** values (no multiple values in a single column).
  * Each row is uniquely identifiable (has a primary key).
*   **Example:**

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

* A table is in **2NF** if:
  * It is already in **1NF**.
  * **No partial dependency exists** (i.e., non-key attributes must depend on the entire primary key, not just part of it).
*   **Example:**

    ```
    Non-2NF Table (Composite Key Issue):
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

* A table is in **3NF** if:
  * It is already in **2NF**.
  * **No transitive dependency exists** (i.e., non-key attributes must depend **only** on the primary key).
*   **Example (Non-3NF Table):**

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

**Boyce-Codd Normal Form (BCNF)**

* A stricter version of 3NF where **every determinant must be a candidate key**.
* Used to remove anomalies **not addressed in 3NF**.



