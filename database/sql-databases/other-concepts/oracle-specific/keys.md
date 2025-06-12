# Keys

## About

Keys are essential components of Oracle RDBMS that ensure data integrity, uniqueness, and relationships between tables. They help enforce business rules and prevent anomalies in relational databases.

## **1. Primary Key**

A **Primary Key (PK)** uniquely identifies each row in a table. It ensures that **no duplicate** or **NULL values** exist in the column(s) defined as the primary key.

{% hint style="success" %}
&#x20;A table can have **only one primary key**, but it can consist of multiple columns.
{% endhint %}

### **Characteristics**

* **Uniqueness:** Each row must have a unique primary key value.
* **Not Null:** Cannot contain NULL values.
* **Single Column or Composite:** Can be a single column or a combination of multiple columns.
* **Automatically Indexed:** Oracle automatically creates a **unique index** for the primary key.

### **Single Primary Key Example**

```sql
CREATE TABLE Employees (
    EmployeeID NUMBER PRIMARY KEY,
    Name VARCHAR2(50),
    Department VARCHAR2(50)
);
```

### **Composite Primary Key Example**

```sql
CREATE TABLE EmployeeProjects (
    EmployeeID NUMBER,
    ProjectID NUMBER,
    PRIMARY KEY (EmployeeID, ProjectID)
);
```

## **2. Composite Key**

A **Composite Key** consists of **multiple columns** used together to form a unique identifier.

### **Example**

```sql
CREATE TABLE OrderDetails (
    OrderID NUMBER,
    ProductID NUMBER,
    Quantity NUMBER,
    PRIMARY KEY (OrderID, ProductID)
);
```

Here, **OrderID + ProductID** together form a **Composite Primary Key**.

## **3. Unique Key**

A **Unique Key (UK)** enforces **uniqueness** on a column but allows **NULL values** (unlike the primary key).

### **Characteristics**

* Ensures **no duplicate values** in a column.
* **Allows NULL values** (since NULLs are not considered duplicates).
* Oracle automatically creates a **unique index** for the key.
* A table can have **multiple unique keys**.

### **Example**

```sql
CREATE TABLE Employees (
    EmployeeID NUMBER PRIMARY KEY,
    Email VARCHAR2(100) UNIQUE
);
```

### **Difference Between Primary Key & Unique Key**

| Feature              | Primary Key        | Unique Key         |
| -------------------- | ------------------ | ------------------ |
| **Uniqueness**       | Ensures uniqueness | Ensures uniqueness |
| **NULLs Allowed**    | No                 | Yes                |
| **Indexing**         | Auto-indexed       | Auto-indexed       |
| **Number per Table** | Only 1             | Multiple           |

## **4. Foreign Key (Referential Integrity)**

A **Foreign Key (FK)** is a column (or combination of columns) that establishes a relationship between **two tables**. It ensures that the value in the column **must exist in the referenced table**.

### **Characteristics**

* Maintains **referential integrity** between tables.
* Prevents **orphan records** (i.e., cannot insert a record without a valid reference).
* Supports **ON DELETE CASCADE** or **ON DELETE SET NULL** to manage deletions in the parent table.

### **Example**

```sql
CREATE TABLE Departments (
    DepartmentID NUMBER PRIMARY KEY,
    DepartmentName VARCHAR2(50)
);

CREATE TABLE Employees (
    EmployeeID NUMBER PRIMARY KEY,
    Name VARCHAR2(50),
    DepartmentID NUMBER,
    CONSTRAINT fk_department FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);
```

### **Foreign Key Actions on DELETE:**

<table><thead><tr><th width="250">Action</th><th>Behavior</th></tr></thead><tbody><tr><td><strong>ON DELETE CASCADE</strong></td><td>Automatically deletes child records if the parent is deleted.</td></tr><tr><td><strong>ON DELETE SET NULL</strong></td><td>Sets foreign key to NULL when parent is deleted.</td></tr><tr><td><strong>No Action (Default)</strong></td><td>Restricts deletion if child records exist.</td></tr></tbody></table>

## **5. Candidate Key**

A **Candidate Key** is a **potential primary key**. A table may have multiple candidate keys, but only **one can be chosen as the primary key**.

### **Example**

Consider a table with `EmployeeID` and `Email`—both are unique and can serve as a primary key.

```sql
CREATE TABLE Employees (
    EmployeeID NUMBER UNIQUE,
    Email VARCHAR2(100) UNIQUE
);
```

* `EmployeeID` and `Email` are **candidate keys**.
* If we choose `EmployeeID` as the **primary key**, `Email` remains a **unique key**.

## **6. Super Key**

A **Super Key** is any set of columns that **uniquely identifies a row**. It includes:

* **Primary Key**
* **Candidate Keys**
* **Any combination of attributes that uniquely identify a row**

### **Example**

In the `Employees` table, the following are **Super Keys**:

* `{EmployeeID}`
* `{Email}`
* `{EmployeeID, Email}`

{% hint style="success" %}
A **Super Key** may contain extra attributes, whereas a **Candidate Key** has the minimal number of attributes required to ensure uniqueness.
{% endhint %}

## **7. Alternate Key**

An **Alternate Key** is a **Candidate Key that is not chosen** as the **Primary Key**.

### **Example**

If `EmployeeID` and `Email` are **Candidate Keys**, and we choose `EmployeeID` as the **Primary Key**, then `Email` becomes an **Alternate Key**.

## **8. Surrogate Key**

A **Surrogate Key** is an **artificially generated** key, usually an **auto-increment number** that serves as the primary key.

### **Characteristics**

* Has **no business meaning** (i.e., does not come from actual data).
* Typically a **sequentially generated** unique identifier.

### **Example**

```sql
CREATE TABLE Customers (
    CustomerID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Name VARCHAR2(100),
    Email VARCHAR2(100) UNIQUE
);
```

Here, `CustomerID` is a **Surrogate Key**.

## Best Practices for Using Keys

### **1. Best Practices for Primary Keys (PK)**

✅ **Choose a Stable and Unique Column**

* Use a column whose value **does not change frequently** (e.g., an auto-incremented ID).
* Avoid using natural keys (e.g., Social Security Number, email) as primary keys unless absolutely necessary.

✅ **Use Surrogate Keys When Necessary**

* A **surrogate key** (auto-generated unique ID) is often better than a **natural key**, especially when natural keys are long or subject to change.
* Example using `IDENTITY` column:

```sql
CREATE TABLE Customers (
    CustomerID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Email VARCHAR2(255) UNIQUE
);
```

✅ **Avoid Composite Primary Keys Unless Necessary**

* A **composite key** (multiple columns forming a primary key) can **increase complexity** in indexing and foreign key references.
* If necessary, ensure both columns are **stable and short** to improve performance.
* Example:

```sql
CREATE TABLE OrderDetails (
    OrderID NUMBER,
    ProductID NUMBER,
    PRIMARY KEY (OrderID, ProductID)
);
```

✅ **Ensure the Primary Key is Indexed**

* Oracle **automatically creates a unique index** on the primary key column, ensuring **fast lookups**.

✅ **Avoid Using Large Data Types as Primary Keys**

* Avoid using **VARCHAR2, CLOB, or BLOB** as primary keys. Instead, prefer **NUMBER or INTEGER**.
* Example: **Bad Practice ❌**

```sql
CREATE TABLE Users (
    Username VARCHAR2(100) PRIMARY KEY
);
```

* Example: **Good Practice ✅**

```sql
CREATE TABLE Users (
    UserID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Username VARCHAR2(100) UNIQUE
);
```

### **2. Best Practices for Unique Keys (UK)**

✅ **Use Unique Keys for Business-Critical Columns**

* Use **unique keys** for columns like **email, phone number, or username** to prevent duplicate entries.

```sql
CREATE TABLE Employees (
    EmployeeID NUMBER PRIMARY KEY,
    Email VARCHAR2(255) UNIQUE
);
```

✅ **Avoid Excessive Unique Constraints**

* If multiple columns require uniqueness, analyze if **application logic** can enforce it instead of the database.
* Too many unique constraints **increase the overhead** of indexing and constraint checks.

✅ **Ensure Unique Constraints are Indexed**

* Oracle automatically creates a **unique index** when you define a unique key.
* If a unique key is frequently used in WHERE clauses, **consider additional indexing** for performance optimization.

✅ **NULL Handling in Unique Keys**

* Unlike primary keys, **unique keys allow NULL values** (but NULL values are treated as distinct).
* Be cautious if you expect multiple NULLs in a unique column.

### **3. Best Practices for Foreign Keys (FK)**

✅ **Always Index Foreign Keys for Performance**

* Oracle **does not automatically create indexes** on foreign keys, which can lead to **slow queries**.
* Manually create an **index on foreign key columns** to optimize performance.

```sql
CREATE INDEX idx_employee_department ON Employees(DepartmentID);
```

✅ **Use ON DELETE CASCADE or ON DELETE SET NULL Where Needed**

* Define **ON DELETE CASCADE** if child records should be deleted when a parent is deleted.
* Define **ON DELETE SET NULL** if child records should not be deleted but should lose the reference.

```sql
CREATE TABLE Employees (
    EmployeeID NUMBER PRIMARY KEY,
    DepartmentID NUMBER,
    CONSTRAINT fk_department FOREIGN KEY (DepartmentID) 
    REFERENCES Departments(DepartmentID) ON DELETE CASCADE
);
```

✅ **Avoid Foreign Keys in High-Write Workloads if Necessary**

* Foreign keys enforce integrity but can **slow down inserts/updates** in high-write scenarios.
* Consider **denormalization** or application-level validation if performance is impacted.

✅ **Use DEFERRABLE Constraints for Bulk Inserts**

* Use `DEFERRABLE INITIALLY DEFERRED` to **delay foreign key checks** until commit time, improving **bulk insert performance**.

```sql
ALTER TABLE Orders ADD CONSTRAINT fk_customer FOREIGN KEY (CustomerID)
REFERENCES Customers(CustomerID) DEFERRABLE INITIALLY DEFERRED;
```

### **4. Best Practices for Composite Keys**

✅ **Use Composite Keys Only When Necessary**

* Composite keys **increase complexity** and require **all parts** to be included in foreign keys.
* If queries frequently **use only one part** of the composite key, consider using **surrogate keys instead**.

✅ **Ensure Composite Key Order Matches Query Patterns**

* When defining a composite primary key, **order the columns** based on **query access patterns**.

```sql
CREATE TABLE OrderItems (
    OrderID NUMBER,
    ProductID NUMBER,
    PRIMARY KEY (OrderID, ProductID)
);
```

* If most queries **filter by OrderID**, then `OrderID` should be the **first column** in the key.

✅ **Index Composite Keys Correctly**

* Oracle **creates an index** on composite primary keys but ensure **it aligns with query needs**.
* Example: If queries frequently **search by ProductID**, consider an **additional index**.

### **5. Best Practices for Surrogate Keys**

✅ **Use Surrogate Keys When Natural Keys Are Complex**

* Surrogate keys provide **stability and consistency** in joins and references.
* Example:

```sql
CREATE TABLE Users (
    UserID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Email VARCHAR2(255) UNIQUE
);
```

✅ **Do Not Expose Surrogate Keys to Users**

* **Avoid displaying surrogate keys** like `UserID` in URLs or public-facing applications.
* Instead, use **UUIDs or hashed values** for security reasons.

✅ **Ensure Surrogate Keys Are Indexed Properly**

* Since they are often **join keys**, ensure proper indexing to avoid performance issues.

### **6. General Best Practices for Using Keys**

✅ **Keep Primary and Foreign Key Columns Short & Indexed**

* Use **NUMBER, INTEGER, or SMALL VARCHAR2** columns for primary/foreign keys.
* Avoid large **VARCHAR2 or complex data types** as keys.

✅ **Analyze Query Patterns Before Defining Keys**

* Define keys based on **how data is accessed and joined** to optimize indexing and performance.

✅ **Avoid Overusing Foreign Keys in High-Throughput Applications**

* If your database has **millions of inserts per second**, foreign key constraints might introduce performance overhead.
* In some cases, application-level validation might be preferred.

✅ **Regularly Check for Orphaned Foreign Key Records**

* Use queries to check for orphaned records when `ON DELETE CASCADE` is not applied.

```sql
SELECT * FROM Employees WHERE DepartmentID NOT IN (SELECT DepartmentID FROM Departments);
```

✅ **Use Constraints Instead of Triggers for Integrity**

* Use **keys and constraints** instead of **triggers** whenever possible, as constraints are more efficient.

✅ **Monitor & Tune Indexes on Key Columns**

* Regularly **analyze indexes** on primary, unique, and foreign key columns to **avoid performance bottlenecks**.
