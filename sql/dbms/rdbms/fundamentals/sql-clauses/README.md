# SQL Clauses

## Description

SQL clauses are keywords that specify conditions or modify the behavior of SQL statements. They form the building blocks of SQL queries.

## Different Clauses

### **SELECT Clause**:&#x20;

Specifies the columns to be retrieved.&#x20;

**Example:**

```sql
SELECT name, salary FROM employees;
```

### **FROM Clause**:&#x20;

Specifies the table(s) from which to retrieve the data.&#x20;

**Example:**

```sql
SELECT name, salary FROM employees;
```

### **WHERE Clause**:&#x20;

Filters the rows based on a specified condition.&#x20;

**Example:**

```sql
SELECT name, salary FROM employees WHERE department_id = 10;
```

### **GROUP BY Clause**:&#x20;

Groups rows that have the same values in specified columns into aggregated data.&#x20;

**Example:**

```sql
SELECT department_id, AVG(salary) FROM employees GROUP BY department_id;
```

### **HAVING Clause**:&#x20;

Filters groups based on a specified condition (used with `GROUP BY`).&#x20;

**Example:**

```sql
SELECT department_id, AVG(salary) FROM employees GROUP BY department_id HAVING AVG(salary) > 50000;
```

### **ORDER BY Clause**:&#x20;

Sorts the result set based on one or more columns.&#x20;

**Example:**

```sql
SELECT name, salary FROM employees ORDER BY salary DESC;
```

### **JOIN Clause**:&#x20;

Combines rows from two or more tables based on a related column.&#x20;

**Example:**

```sql
SELECT employees.name, departments.dept_name
FROM employees
JOIN departments ON employees.dept_id = departments.dept_id;
```

### **INSERT INTO Clause**:&#x20;

Adds new rows to a table.

**Example:**

```sql
INSERT INTO employees (name, department_id, salary) VALUES ('John Doe', 10, 60000);
```

### **UPDATE Clause**:&#x20;

Modifies existing rows in a table.&#x20;

**Example:**

```sql
UPDATE employees SET salary = salary + 5000 WHERE department_id = 10;
```

### **DELETE Clause**:&#x20;

Removes rows from a table.&#x20;

**Example:**

```sql
DELETE FROM employees WHERE department_id = 10;
```

### **LIMIT/OFFSET Clause**:&#x20;

Specifies the number of rows to return or skip (supported in databases like MySQL, PostgreSQL).

**Example:**

```sql
SELECT * FROM employees LIMIT 10 OFFSET 20;
```

### **DISTINCT Clause**:&#x20;

Removes duplicate rows from the result set.&#x20;

**Example:**

```sql
SELECT DISTINCT department_id FROM employees;
```



