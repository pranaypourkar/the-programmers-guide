---
hidden: true
---

# Views

## Description

A view is a virtual table that is based on the result set of a SQL query. Views provide a way to encapsulate complex queries, simplify data access, and enhance security by restricting user access to specific rows and columns. Views do not store data themselves but rather store the query that retrieves the data from the underlying tables.

{% hint style="info" %}
Most RDBMS support views including Oracle, MySql, etc.
{% endhint %}

## Key Characteristics of Views

1. **Virtual Table**: A view behaves like a table but does not store data. Instead, it dynamically retrieves data from the underlying tables each time it is queried.
2. **Simplifies Queries**: Views can encapsulate complex joins, filters, and aggregations, simplifying query writing and readability.
3. **Security**: Views can restrict user access to specific rows and columns, enhancing data security and privacy.
4. **Updatable**: Some views are updatable, meaning you can perform `INSERT`, `UPDATE`, and `DELETE` operations on the view, which in turn affect the underlying tables. However, not all views are updatable.

## **Benefits of Views**

* **Data Abstraction:** Views can simplify complex queries by hiding the underlying table structure and join conditions from users. They present a focused representation of the data relevant to the user's needs.
* **Security:** Views can be used to restrict access to sensitive data in base tables. We can control which columns and rows are visible through the view's definition.
* **Data Independence:** If the underlying table structure changes, we can modify the view definition to reflect those changes without impacting applications or users who rely on the view. This promotes loose coupling between applications and data structures.
* **Simplified Queries:** Views can pre-join multiple tables or perform calculations, making it easier for users to write queries without needing to know the intricate details of the base tables.

## **Types of Views**

* **Simple Views:** Based on a single SELECT statement referencing one or more base tables.
* **Complex Views:** Can involve joins, aggregations, subqueries, and other SQL functionalities within the view definition.

## Creating a View

The `CREATE VIEW` statement is used to define a new view.

### Syntax

```
CREATE VIEW view_name AS
SELECT column1, column2, ...
FROM table_name
WHERE condition;
```

### Example

Consider a table `employees`:

| emp\_id | name    | dept\_id | salary |
| ------- | ------- | -------- | ------ |
| 1       | Alice   | 101      | 5000   |
| 2       | Bob     | 102      | 6000   |
| 3       | Charlie | 103      | 5500   |
| 4       | Dave    | 101      | 5200   |
| 5       | Eve     | 102      | 5900   |

To create a view that shows employees in department 101 with a salary greater than 5000:

```sql
CREATE VIEW high_salary_dept101 AS
SELECT name, salary
FROM employees
WHERE dept_id = 101 AND salary > 5000;
```

## Querying a View

We can query a view just like a table.

### **Example**

```sql
SELECT * FROM high_salary_dept101;
```

### **Result**

| name | salary |
| ---- | ------ |
| Dave | 5200   |

## Updatable Views

A view is considered updatable if it allows `INSERT`, `UPDATE`, or `DELETE` operations. For a view to be updatable, certain conditions must be met:

* The view must reference only one base table.
* The view must include all NOT NULL columns of the base table.
* The view must not include set operations (`UNION`, `INTERSECT`, `MINUS`).
* The view must not use aggregate functions or `DISTINCT`.

### **Example**

```sql
CREATE VIEW employees_dept101 AS
SELECT emp_id, name, salary
FROM employees
WHERE dept_id = 101;
```

Now we can perform updates through the view:

```sql
UPDATE employees_dept101
SET salary = 5300
WHERE emp_id = 4;
```

This updates Dave's salary in the `employees` table.

## Dropping a View

To remove a view, use the `DROP VIEW` statement.

### **Syntax:**

```sql
DROP VIEW view_name;
```

### **Example**

```sql
DROP VIEW high_salary_dept101;
```
