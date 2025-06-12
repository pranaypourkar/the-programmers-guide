# EXISTS and NOT EXISTS

## Description

The `EXISTS` and `NOT EXISTS` operators in SQL are used to test for the existence or non-existence of rows in a subquery. They are typically used in `WHERE` clauses to filter rows based on whether a subquery returns any results.

{% hint style="info" %}
**Efficiency**: `EXISTS` and `NOT EXISTS` are often more efficient than using `IN` or `NOT IN` with subqueries, especially with large datasets, because the subquery is typically optimized to stop processing as soon as a match is found.

**Subquery**: The subquery used with `EXISTS` or `NOT EXISTS` does not actually return any data to the main query. Instead, it only checks for the existence of rows that meet the condition.

**Correlation**: Subqueries used with `EXISTS` or `NOT EXISTS` are often correlated subqueries, meaning they refer to columns from the outer query.
{% endhint %}

## `EXISTS` Operator

The `EXISTS` operator returns `TRUE` if the subquery returns one or more rows. It is commonly used to check for the presence of related data.

### **Syntax:**

```sql
SELECT column1, column2, ...
FROM table_name
WHERE EXISTS (subquery);
```

### **Example:**

Consider two tables, `employees` and `departments`:

**employees:**

| emp\_id | name    | dept\_id |
| ------- | ------- | -------- |
| 1       | Alice   | 101      |
| 2       | Bob     | 102      |
| 3       | Charlie | 103      |
| 4       | Dave    | 104      |
| 5       | Eve     | 105      |

**departments:**

| dept\_id | dept\_name  |
| -------- | ----------- |
| 101      | Sales       |
| 102      | Engineering |
| 103      | HR          |

To find employees who belong to a department listed in the `departments` table:

```sql
SELECT name
FROM employees e
WHERE EXISTS (SELECT 1
              FROM departments d
              WHERE e.dept_id = d.dept_id);
```

### Result:

| name    |
| ------- |
| Alice   |
| Bob     |
| Charlie |

## `NOT EXISTS` Operator

The `NOT EXISTS` operator returns `TRUE` if the subquery returns no rows. It is used to check for the absence of related data.

### **Syntax:**

```sql
SELECT column1, column2, ...
FROM table_name
WHERE NOT EXISTS (subquery);
```

### **Example:**

To find employees who do not belong to any department listed in the `departments` table:

```sql
SELECT name
FROM employees e
WHERE NOT EXISTS (SELECT 1
                  FROM departments d
                  WHERE e.dept_id = d.dept_id);
```

### Result:

| name |
| ---- |
| Dave |
| Eve  |

