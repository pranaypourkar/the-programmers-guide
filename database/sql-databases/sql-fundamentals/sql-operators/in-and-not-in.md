# IN and NOT IN

## Description

The `IN` and `NOT IN` operators in SQL are used to filter result sets based on whether a value matches any value in a specified list or subquery. These operators provide a convenient way to write conditions that check for membership within a set of values.

{% hint style="info" %}
IN and NOT IN are essentially OR operations and will yield different results because of how NULL values are treated by logical OR evaluations.

In SQL, “TRUE or NULL” is TRUE, but “FALSE or NULL” is NULL! We must keep this in mind when using IN predicates, and when performing logical OR evaluations and NULL values are involved
{% endhint %}

{% hint style="info" %}
**NULL Values**: Be cautious when using `NOT IN` with subqueries that may return `NULL` values. If any value in the subquery result set is `NULL`, the `NOT IN` operator will not return any rows because `NULL` comparisons result in unknown.

**Example Handling NULL:**

```sql
SELECT name
FROM employees
WHERE dept_id NOT IN (SELECT dept_id FROM departments WHERE dept_id IS NOT NULL);
```
{% endhint %}

## `IN` Operator

The `IN` operator is used to specify multiple values in a `WHERE` clause. It checks if a value matches any value in a list or a result set from a subquery.

### **Syntax:**

```sql
SELECT column1, column2, ...
FROM table_name
WHERE column_name IN (value1, value2, ...);
```

### **Example:**

Consider a table `employees`:

| emp\_id | name    | dept\_id |
| ------- | ------- | -------- |
| 1       | Alice   | 101      |
| 2       | Bob     | 102      |
| 3       | Charlie | 103      |
| 4       | Dave    | 104      |
| 5       | Eve     | 105      |

To find employees in departments 101, 102, or 103:

```sql
SELECT name, dept_id
FROM employees
WHERE dept_id IN (101, 102, 103);
```

### **Result:**

| name    | dept\_id |
| ------- | -------- |
| Alice   | 101      |
| Bob     | 102      |
| Charlie | 103      |

## `NOT IN` Operator

The `NOT IN` operator is used to specify multiple values in a `WHERE` clause. It checks if a value does not match any value in a list or a result set from a subquery.

### **Syntax:**

```sql
SELECT column1, column2, ...
FROM table_name
WHERE column_name NOT IN (value1, value2, ...);
```

### **Example:**

To find employees not in departments 101, 102, or 103:

```sql
SELECT name, dept_id
FROM employees
WHERE dept_id NOT IN (101, 102, 103);
```

**Result:**

| name | dept\_id |
| ---- | -------- |
| Dave | 104      |
| Eve  | 105      |







