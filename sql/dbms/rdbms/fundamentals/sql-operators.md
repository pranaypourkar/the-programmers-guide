# SQL Operators

## Description

SQL operators are symbols or keywords used to perform operations on data. They can be classified into several categories.

## Different Operators

### **Arithmetic Operators**:&#x20;

Used to perform mathematical operations.

* `+` (Addition)
* `-` (Subtraction)
* `*` (Multiplication)
* `/` (Division)
* `%` (Modulo)

**Example:**

```sql
SELECT salary + 1000 AS increased_salary FROM employees;
```

### **Comparison Operators**:&#x20;

Used to compare two values.

* `=` (Equal to)
* `<>` or `!=` (Not equal to)
* `>` (Greater than)
* `<` (Less than)
* `>=` (Greater than or equal to)
* `<=` (Less than or equal to)

**Example:**

```
SELECT * FROM employees WHERE salary > 50000;
```

### **Logical Operators**:&#x20;

Used to combine multiple conditions.

* `AND` (Both conditions must be true)
* `OR` (At least one condition must be true)
* `NOT` (Negates a condition)

**Example:**

```
SELECT * FROM employees WHERE salary > 50000 AND department_id = 10;
```

### **Bitwise Operators**:&#x20;

Used to perform bitwise operations.

* `&` (Bitwise AND)
* `|` (Bitwise OR)
* `^` (Bitwise XOR)

**Example:**

```
SELECT 5 & 3;  -- Results in 1
```

### **Set Operators**:&#x20;

Used to combine the results of two or more queries.

* `UNION` (Combines results of two queries and removes duplicates)
* `UNION ALL` (Combines results of two queries without removing duplicates)
* `INTERSECT` (Returns common results of two queries)
* `MINUS` or `EXCEPT` (Returns results from the first query that are not in the second query)

**Example:**

```
SELECT name FROM employees
UNION
SELECT name FROM managers;
```

### **String Operators**:&#x20;

Used to perform operations on strings.

* `||` (Concatenation in Oracle and PostgreSQL)
* `+` (Concatenation in SQL Server)
* `LIKE` (Pattern matching)

**Example:**

```sql
SELECT first_name || ' ' || last_name AS full_name FROM employees;
```











