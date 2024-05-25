# Working with Multiple Tables

## Stacking One Rowset atop Another (Union All)

We want to return data stored in more than one table, conceptually stacking one result set atop the other. The tables do not necessarily have a common key, but their columns do have the same data types. For example

<figure><img src="../../../../.gitbook/assets/image (95).png" alt="" width="199"><figcaption></figcaption></figure>

```
select ename as ename_and_dname, deptno from emp where deptno = 10
union all
select '----------', null from t1
union all
select dname, deptno from dept;
```

{% hint style="info" %}
UNION ALL will include duplicates if they exist. If we want to filter out duplicates, use the UNION operator. It uses distinct to filter duplicate record.
{% endhint %}

## Joins

Joins are used to combine data from multiple tables based on a related column. They allow you to retrieve comprehensive information that spans across different tables.

**Types of Joins**

### **Inner Join (Simple Join):**

Returns rows where there's a match in the join condition between the tables. It excludes rows that do not have matching values in the joined tables.

```
SELECT *
FROM table1
INNER JOIN table2 ON table1.column_name = table2.column_name;
```

**Example:** Find all orders (Orders table) with customer details (Customers table) based on matching customer IDs.

```
SELECT Orders.OrderID, Customers.CustomerName, Orders.OrderDate
FROM Orders
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID;
```

{% hint style="info" %}
The conditions\
`Orders.CustomerID = Customers.CustomerID` and `Customers.CustomerID = Orders.CustomerID` are equivalent and will produce the same results.

However, there can be subtle performance differences in certain scenarios depending on the optimizer's strategy. While both conditions are functionally equivalent, the order we choose might influence how the optimizer decides to access the tables and perform the join. In most cases, these differences are negligible.

It's generally considered good practice to write the join condition in a way that reads more naturally, often placing the table with the primary key (assumed to be Customers in this case) on the left side of the comparison. For complex joins with multiple conditions, the order of comparisons within the ON clause can become more relevant for optimization.
{% endhint %}

### **Outer Joins:**

Outer joins return all rows from one table and matching rows from the other table based on the join condition. Rows from the other table that don't have a match will be included with null values for the columns from the non-matching table

There are three types of outer joins:

#### **Left Outer Join (LEFT JOIN):**

Returns all rows from the left table and matching rows from the right table. Unmatched rows in the right table will have null values for columns joined from the right table.

```
SELECT *
FROM table1
LEFT JOIN table2 ON table1.column_name = table2.column_name;
```

#### **Right Outer Join (RIGHT JOIN):**

Similar to left outer join, but returns all rows from the right table and matching rows from the left table. Unmatched rows in the left table will have null values for columns joined from the left table.

```
SELECT *
FROM table1
RIGHT JOIN table2 ON table1.column_name = table2.column_name;
```

#### **Full Outer Join (FULL JOIN):**

Returns all rows from both tables, including unmatched rows with null values for columns from the non-matching table.

```
SELECT *
FROM table1
FULL JOIN table2 ON table1.column_name = table2.column_name;
```

### **Self Join:**

Joins a table to itself based on a matching condition between columns within the same table. Use aliases (alias1, alias2) to differentiate between the two instances of the same table.

```
SELECT *
FROM table_name AS alias1
INNER JOIN table_name AS alias2 ON alias1.column_name = alias2.column_name;
```

**Example:** Find employees who manage other employees (Employees table) based on matching manager ID and employee ID.

```
SELECT e1.EmployeeName AS ManagerName, e2.EmployeeName AS ManagedEmployee
FROM Employees e1
INNER JOIN Employees e2 ON e1.ManagerID = e2.EmployeeID;
```

### **Cross Join (Cartesian Product):**

A cross join returns the Cartesian product of the two tables, meaning it combines all rows from the first table with all rows from the second table. This can be a large dataset, so need to use it cautiously.

```
SELECT *
FROM table1
CROSS JOIN table2;
```

**Example**: A Cross Join (Cartesian Product) isn't as frequently used as other join types like inner joins. However, there are some scenarios where it can be useful.

Imagine if we have an online store that sells products (products table) and different sizes available for those products (sizes table). We want to display a list of all possible product-size combinations on a web page.

**Tables**

* Products (ProductID, ProductName)
* Sizes (SizeID, SizeName)

```
SELECT p.ProductName, s.SizeName
FROM Products p
CROSS JOIN Sizes s;
```

This query will generate all possible combinations of products and sizes, even for products that might not have all available sizes.

**Sample Data**

**Products Table:**

| ProductID | ProductName |
| --------- | ----------- |
| 101       | T-Shirt     |
| 102       | Jeans       |
| 103       | Hat         |

**Sizes Table:**

| SizeID | SizeName |
| ------ | -------- |
| 201    | Small    |
| 202    | Medium   |
| 203    | Large    |

**Output:**

| ProductName | SizeName |
| ----------- | -------- |
| T-Shirt     | Small    |
| T-Shirt     | Medium   |
| T-Shirt     | Large    |
| Jeans       | Small    |
| Jeans       | Medium   |
| Jeans       | Large    |
| Hat         | Small    |
| Hat         | Medium   |
| Hat         | Large    |

### **Natural Join (Optional):**

Performs an inner join based on columns with the same name and data type in both tables and selects rows with equal values in the relevant columns. Not recommended due to potential ambiguity, especially with synonyms or homonyms.

```
SELECT *
FROM table1
NATURAL JOIN table2;
```



{% hint style="info" %}
#### Equijoin

An equijoin is any join in which the joining condition uses the equality operator (`=`) to match rows between the tables. It can be used with different types of joins, such as inner joins, outer joins, and self joins.
{% endhint %}

{% hint style="info" %}
**`USING` clause**

The `USING` clause in Oracle is an alternative way to specify the join condition in certain types of joins, specifically **equi joins** where columns have the same name in both tables. It offers a more concise syntax compared to the `ON` clause.

It specifies the columns used to match rows between two tables in an equi join. Offers a simpler syntax compared to the `ON` clause when joining columns with the same name in both tables. For example below, `table1` and `table2` are the tables being joined.`column_name1`, `column_name2`, etc. are the list of columns with the same name in both tables that will be used for the join condition.

```
SELECT ...
FROM table1
JOIN table2 USING (column_name1, column_name2, ...)
```



```
SELECT Orders.OrderID, Customers.CustomerName, Orders.OrderDate
FROM Orders
JOIN Customers USING (CustomerID);
```
{% endhint %}







