# MINUS

## Description

The `MINUS` operator in SQL is used to return all rows from the first `SELECT` statement that are not present in the second `SELECT` statement. It is effectively the same as the `EXCEPT` operator and is commonly used in Oracle databases.

{% hint style="info" %}
**Supported Databases**: The `MINUS` operator is supported by Oracle and some other SQL databases but not by all, such as MySQL or SQL Server. In databases that do not support `MINUS`, similar functionality can be achieved using `LEFT JOIN` or subqueries.
{% endhint %}

1. **Eliminates Duplicates**: The `MINUS` operator automatically removes duplicate rows from the result set.
2. **Column Match**: The number of columns and the data types of the columns in the `SELECT` statements must match.
3. **Order of Queries Matters**: The order of the `SELECT` statements determines which rows are subtracted from which.

## Syntax

```sql
SELECT column1, column2, ...
FROM table1
MINUS
SELECT column1, column2, ...
FROM table2;
```

## Example

Consider two tables, `employees` and `managers`, with the following data:

**`employees` table:**

| emp\_id | name    | dept\_id |
| ------- | ------- | -------- |
| 1       | Alice   | 101      |
| 2       | Bob     | 102      |
| 3       | Charlie | 103      |
| 4       | Dave    | 104      |

**`managers` table:**

| mgr\_id | name    | dept\_id |
| ------- | ------- | -------- |
| 2       | Bob     | 102      |
| 3       | Charlie | 103      |
| 5       | Eve     | 105      |

To find employees who are not managers, you can use the `MINUS` operator as follows:

```sql
SELECT name, dept_id
FROM employees
MINUS
SELECT name, dept_id
FROM managers;
```

## Result

| name  | dept\_id |
| ----- | -------- |
| Alice | 101      |
| Dave  | 104      |

In this example, the `MINUS` clause returns the rows where the `name` and `dept_id` are present in the `employees` table but not in the `managers` table.
