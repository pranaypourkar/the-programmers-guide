# WITH

## Description

The `WITH` clause, also known as the subquery factoring clause, is a feature that allows to define temporary named result sets based on subqueries. These named result sets can then be referenced within the main body of your SQL statement, improving readability, modularity, and potentially performance. The `WITH` clause is also known as Common Table Expressions (CTEs).

{% hint style="info" %}
The `WITH` clause is supported by many RDBMS such as MySQL, SQL Server, Oracle etc.
{% endhint %}

## **Syntax:**

```
WITH cte_name AS (
    SELECT ...
)
SELECT ...
FROM cte_name;
```

**Example:**

```
WITH employee_name AS (
    SELECT 'Sundar' AS FIRST_NAME FROM DUAL
)
SELECT FIRST_NAME FROM employee_name;
```

```
WITH order_details AS (
  SELECT OrderID, SUM(Quantity * UnitPrice) AS TotalAmount
  FROM OrderItems
  GROUP BY OrderID
)
SELECT o.CustomerID, od.OrderID, od.TotalAmount
FROM Orders o
INNER JOIN order_details od ON o.OrderID = od.OrderID;
```
