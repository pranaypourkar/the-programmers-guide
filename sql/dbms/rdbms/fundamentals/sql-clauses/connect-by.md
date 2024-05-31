# CONNECT BY

{% hint style="info" %}
The `CONNECT BY` clause is specific to Oracle and is a feature unique to Oracle Database for handling hierarchical queries. However, other relational database management systems (RDBMS) have their own ways of dealing with hierarchical data, often using Common Table Expressions (CTEs) to achieve similar results.

For hierarchical queries, the pseudocolumn LEVEL starts with 1 (for queries not using CONNECT BY, LEVEL is 0, unless we are on release 10g and later when LEVEL is available only when using CONNECT BY) and increments by one after each evaluation (for each level of depth in the hierarchy).
{% endhint %}

## Description

The `CONNECT BY` clause in Oracle is used for hierarchical queries, which are queries that deal with data that has a parent-child relationship, such as organizational structures, bill of materials, or tree-structured data. It allows to traverse the hierarchy and generate a result set that reflects the hierarchical structure of the data.

## Components of `CONNECT BY`

1. **PRIOR**: This operator specifies the parent-child relationship in the hierarchy. It is used to indicate the column that holds the reference to the parent row.
2. **LEVEL**: A pseudo-column that returns the level number of a node in a tree structure. The root level is 1, the next level is 2, and so on.
3. **START WITH**: This clause specifies the root of the hierarchy, i.e., the starting point of the query.
4. **SYS\_CONNECT\_BY\_PATH**: A function that returns the path of a node from the root.

## Syntax

```sql
SELECT column_list
FROM table_name
START WITH condition
CONNECT BY PRIOR parent_column = child_column;
```

## Examples

### Employee and Manager

Consider a table `employees` with the following structure:

| EMPLOYEE\_ID | NAME | MANAGER\_ID |
| ------------ | ---- | ----------- |
| 1            | John | NULL        |
| 2            | Mike | 1           |
| 3            | Sara | 1           |
| 4            | Kate | 2           |
| 5            | Paul | 2           |

In this table:

* `EMPLOYEE_ID` is the unique identifier for each employee (child).
* `MANAGER_ID` is the unique identifier for the manager of each employee (parent).

#### Hierarchical Query Using `CONNECT BY`

To retrieve the hierarchy starting from the top-level manager:

```sql
SELECT EMPLOYEE_ID, NAME, LEVEL,
       SYS_CONNECT_BY_PATH(NAME, '->') AS PATH
FROM employees
START WITH MANAGER_ID IS NULL
CONNECT BY PRIOR EMPLOYEE_ID = MANAGER_ID
```

#### Explanation:

* **SELECT EMPLOYEE\_ID, NAME, LEVEL, SYS\_CONNECT\_BY\_PATH(NAME, '->') AS PATH**: Selects the employee ID, name, hierarchical level, and the path from the root.
* **FROM employees**: Specifies the source table.
* **START WITH MANAGER\_ID IS NULL**: Specifies the root of the hierarchy (employees with no manager).
* **CONNECT BY PRIOR EMPLOYEE\_ID = MANAGER\_ID**: Establishes the parent-child relationship. Each employee's manager is specified by `MANAGER_ID`.

{% hint style="info" %}
**Step-by-step breakdown of the hierarchy**

1. Start with the root node(s) where `MANAGER_ID IS NULL` (John).
2. For each row, find rows where `MANAGER_ID` matches the `EMPLOYEE_ID` of the current row.
3. Continue this process recursively to build the hierarchy.



#### Setting Up the Hierarchical Query

To establish the relationship that each employee reports to their manager, we want to specify that:

* **The parent row’s `EMPLOYEE_ID` should match the child row’s `MANAGER_ID`**.

This translates to:

* **PRIOR EMPLOYEE\_ID = MANAGER\_ID**
{% endhint %}

#### Result:

| EMPLOYEE\_ID | NAME | LEVEL | PATH               |
| ------------ | ---- | ----- | ------------------ |
| 1            | John | 1     | ->John             |
| 2            | Mike | 2     | ->John->Mike       |
| 3            | Sara | 2     | ->John->Sara       |
| 4            | Kate | 3     | ->John->Mike->Kate |
| 5            | Paul | 3     | ->John->Mike->Paul |

**LEVEL**: Indicates the depth of the current row in the hierarchy. The root node has a `LEVEL` of 1, its children have a `LEVEL` of 2, and so on.

**PRIOR**: Used to refer to the parent row in the hierarchy. In `PRIOR parent_column = child_column`, `PRIOR` refers to the value in the parent row.

**START WITH**: Specifies the root row(s) of the hierarchy. If omitted, all rows are considered roots, which is usually not desired.

**SYS\_CONNECT\_BY\_PATH**: Returns the path from the root to the current row, which is useful for displaying the hierarchy as a string.



### Print difference of 2 dates into rows

Given 2 dates, print all the dates within those 2 dates including itself.

```
SELECT 
    TO_DATE(level - 1 + TO_CHAR(TO_DATE('2024-05-28', 'YYYY-MM-DD'), 'YYYYDDD'), 'YYYYDDD') AS calendar_date
  FROM DUAL
  CONNECT BY LEVEL <= TRUNC(TO_DATE('2024-05-31', 'YYYY-MM-DD')) - TRUNC(TO_DATE('2024-05-28', 'YYYY-MM-DD')) + 1
```

<figure><img src="../../../../../.gitbook/assets/image (113).png" alt="" width="131"><figcaption></figcaption></figure>



