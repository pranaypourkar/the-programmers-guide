# DQL (Data Query Language)

DQL (Data Query Language) forms the core of data retrieval in Oracle. DQL commands, specifically the `SELECT` statement, allows to extract and manipulate data from the database tables based on specific criteria.

## SELECT

Retrieves data from one or more tables based on a set of conditions.

* Syntax

```
SELECT [SELECT_list]
FROM [schema_name.]table_name [, ...]
WHERE condition
[GROUP BY column_list]
[HAVING condition]
[ORDER BY column_list ASC|DESC]
```

* Example

```
SELECT ProductID, COUNT(*) AS Total_Orders
FROM OrderItems
GROUP BY ProductID
HAVING COUNT(*) > 5;
```
