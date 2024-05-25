# INTERSECT

## Description

The `INTERSECT` clause in SQL is used to combine the results of two or more `SELECT` queries and return only the rows that are common to all queries. In other words, it returns the intersection of the result sets.

{% hint style="info" %}
The `INTERSECT` clause is supported by many relational database management systems (RDBMS) such as Oracle, PostgreSQL etc. MySQL does not support it.
{% endhint %}

## Characteristics of the `INTERSECT` Clause:

1. **Returns Common Rows**: The `INTERSECT` clause returns only the rows that appear in the result sets of both queries.
2. **Duplicate Elimination**: Duplicate rows are removed from the final result set. The result set contains only distinct rows.
3. **Column Match**: The number of columns and the data types of the columns in the `SELECT` statements must match.

```sql
SELECT column1, column2, ...
FROM table1
INTERSECT
SELECT column1, column2, ...
FROM table2;
```

## Example:

Consider two tables, `employees` and `managers`. We want to find employees who are also managers using `INTERSECT` clause

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

```sql
SELECT name, dept_id
FROM employees
INTERSECT
SELECT name, dept_id
FROM managers;
```

#### Output:

| name    | dept\_id |
| ------- | -------- |
| Bob     | 102      |
| Charlie | 103      |

