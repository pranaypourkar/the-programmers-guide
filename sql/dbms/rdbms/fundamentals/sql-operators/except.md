# EXCEPT

## Description

The `EXCEPT` operator in SQL is used to return all rows from the first `SELECT` statement that are not present in the second `SELECT` statement. It effectively subtracts the result set of the second query from the result set of the first query. It is often used to find differences between two sets of data.

## Characteristics of the `EXCEPT` Operator

1. **Eliminates Duplicates**: The `EXCEPT` operator automatically removes duplicate rows from the result set.
2. **Column Match**: The number of columns and the data types of the columns in the `SELECT` statements must match.
3. **Order of Queries Matters**: The order of the `SELECT` statements is important because it determines which rows are subtracted from which.

## Syntax

```sql
SELECT column1, column2, ...
FROM table1
EXCEPT
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

To find employees who are not managers, we can use the `EXCEPT` operator as follows:

```sql
SELECT name, dept_id
FROM employees
EXCEPT
SELECT name, dept_id
FROM managers;
```

#### Result:

| name  | dept\_id |
| ----- | -------- |
| Alice | 101      |
| Dave  | 104      |

In this example, the `EXCEPT` clause returns the rows where the `name` and `dept_id` are present in the `employees` table but not in the `managers` table.
