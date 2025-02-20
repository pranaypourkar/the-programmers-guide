# DML (Data Manipulation Language)

DML (Data Manipulation Language) commands are used to interact with and modify data within existing database tables. These commands allows to insert new data, update existing data, delete unwanted data, and perform bulk operations for efficiency.

## INSERT

Adds new rows of data to a table.

* Syntax

```
INSERT INTO [schema_name.]table_name ([column_list]) VALUES ([value_list]);
```

* Example

```
INSERT INTO Customers (CustomerID, CustomerName, Email, Phone) VALUES (1001, 'John Smith', 'john.smith@email.com', '123-456-7890');
```

## UPDATE

Modifies existing data in a table based on a specific criteria (WHERE clause).

* Syntax

```
UPDATE [schema_table.]table_name SET [column_name] = new_value [, ...] WHERE condition;
```

* Example

```
UPDATE Customers SET Email = 'updated_email@example.com' WHERE CustomerID = 1002;
```

## DELETE

Removes rows of data from a table based on a specific criteria (WHERE clause).

* Syntax

```
DELETE FROM [schema_name.]table_name WHERE condition;
```

* Example

```
DELETE FROM Orders WHERE OrderDate < '2023-01-01';
```

## MERGE

The MERGE statement is used to perform an "upsert" operation, which means inserting new rows into a table or updating existing rows based on specified conditions

* Syntax

```
MERGE INTO [schema_name.]table_name USING (...)
  ON (matching_condition)
  WHEN MATched THEN UPDATE SET (...)
  WHEN NOT MATCHED THEN INSERT (...) VALUES (...);
```

* Example\
  Suppose we have two tables: `employees` and `employees_updates`. The `employees` table contains the current employee data, and the `employees_updates` table contains updates to be applied to the `employees` table. We will use the MERGE statement to update the `employees` table with the data from the `employees_updates` table.

```
-- Create employees table
CREATE TABLE employees (
    employee_id   NUMBER(6) PRIMARY KEY,
    first_name    VARCHAR2(50),
    last_name     VARCHAR2(50),
    department_id NUMBER(4)
);

-- Create employees_updates table
CREATE TABLE employees_updates (
    employee_id   NUMBER(6),
    first_name    VARCHAR2(50),
    last_name     VARCHAR2(50),
    department_id NUMBER(4)
);

-- Insert sample data into employees table
INSERT INTO employees VALUES (1, 'John', 'Doe', 101);
INSERT INTO employees VALUES (2, 'Jane', 'Smith', 102);
INSERT INTO employees VALUES (3, 'Alice', 'Johnson', 103);

-- Insert sample data into employees_updates table
INSERT INTO employees_updates VALUES (2, 'Jane', 'Doe', 105);
INSERT INTO employees_updates VALUES (4, 'Bob', 'Johnson', 104);

-- Merge
MERGE INTO employees e
USING employees_updates eu
ON (e.employee_id = eu.employee_id)
WHEN MATCHED THEN
    UPDATE SET e.first_name = eu.first_name,
               e.last_name = eu.last_name,
               e.department_id = eu.department_id
WHEN NOT MATCHED THEN
    INSERT (employee_id, first_name, last_name, department_id)
    VALUES (eu.employee_id, eu.first_name, eu.last_name, eu.department_id);
```

## CALL&#x20;

Executes a stored procedure or function in the database.

* Syntax

```
CALL [schema_name.]procedure_name([parameter_list]);
```

* Example

```
CALL Grant_Sales_Access('New_Sales_User');  -- Assuming a stored procedure exists
```

## EXPLAIN PLAN

Analyzes and displays the execution plan for a SQL statement, providing insights into how the database will retrieve data.

* Syntax

```
EXPLAIN PLAN FOR [SQL statement];
```

* Example

```
EXPLAIN PLAN FOR SELECT * FROM Customers WHERE CustomerID = 1001;
SELECT * FROM TABLE(dbms_xplan.display);
```

## LOCK TABLE

Explicitly locks a table or specific rows to prevent other users from modifying the data concurrently. We can release a table lock implicitly by committing or rolling back the transaction

* Syntax

```
LOCK TABLE [schema_name.]table_name [mode] [NOWAIT];
```

* Example

```
LOCK TABLE Customers IN EXCLUSIVE MODE NOWAIT;
UPDATE Customers SET Email = 'updated_email@example.com' WHERE CustomerID = 1001;
COMMIT;
```
