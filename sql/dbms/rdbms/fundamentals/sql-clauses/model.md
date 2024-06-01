# MODEL

{% hint style="warning" %}
The `MODEL` clause is a feature specific to Oracle SQL and is not supported by all DBMS. It is unique to Oracle and provides advanced, spreadsheet-like calculation capabilities within SQL queries, which is not a standard feature across other SQL databases.
{% endhint %}

## Description

The `MODEL` clause in Oracle SQL is a feature that allows to perform inter-row and inter-column calculations in a spreadsheet-like fashion within a SQL query. It provides a way to define a multidimensional array and apply rules to it, enabling complex data manipulations and calculations.

## Key Features of the MODEL Clause

1. **Multidimensional Arrays**: Treats query results as multidimensional arrays.
2. **Rules-Based Calculations**: Allows the definition of rules for calculations that can span across rows and columns.
3. **Cell References**: Supports references to other cells in the array, similar to how spreadsheet cells can reference each other.

## Basic Syntax

Here is a simplified syntax of the `MODEL` clause:

```sql
SELECT ...
FROM ...
MODEL
    [ PARTITION BY (partition_clause) ]
    DIMENSION BY (dimension_clause)
    MEASURES (measure_clause)
    [ RULES (rule_clause) ];
```

* **PARTITION BY**: Divides the data into partitions, similar to a `GROUP BY` clause.
* **DIMENSION BY**: Specifies the dimensions of the array (e.g., rows or columns). In the context of the `MODEL` clause, dimensions act like rows in a spreadsheet
* **MEASURES**: Defines the measures or the actual data values that will be manipulated. Measures act like the data cells in a spreadsheet that can be manipulated.
* **RULES**: Contains the rules that define how calculations are performed.

{% hint style="info" %}
Pseudo Keywords

**ANY:** This keyword refers to all members within a particular dimension. It's often used in conjunction with aggregate functions like `SUM` or `AVG` to calculate values across all elements in that dimension.

**CURRENT:** This keyword refers to the current row being processed within the model. It can be useful for calculations that depend on the values in the current row.\


Pseudo Functions

**CV() (Current Value):** This function retrieves the value of a measure from the previous row within the same dimension partition. It's particularly helpful for calculations that involve comparisons or running totals.

**DENSE\_RANK() and RANK():** These functions assign ranking positions to members within a dimension, considering potential ties and gaps in the data. They can be used for calculations based on ranking or percentiles.

**LAG() and LEAD():** These functions access values from previous or subsequent rows within the same dimension partition, allowing for calculations that depend on past or future values.
{% endhint %}

## Example

Sample Data

```
select employee_id, first_name, last_name, salary, manager_id, department_id 
                      from employees;
                      
 EMPLOYEE_ID FIRST_NAME           LAST_NAME                     SALARY MANAGER_ID DEPARTMENT_ID
 ----------- -------------------- ------------------------- ---------- ---------- -------------
 198 Donald               OConnell                        2600        124            50
 199 Douglas              Grant                           2600        124            50
 200 Jennifer             Whalen                          4400        101            10
 201 Michael              Hartstein                      13000        100            20
 202 Pat                  Fay                             6000        201            20
 203 Susan                Mavris                          6500        101            40
 204 Hermann              Baer                           10000        101            70
 205 Shelley              Higgins                        12008        101           110
 206 William              Gietz                           8300        205           110
 100 Steven               King                           24000                       90
 101 Neena                Kochhar   
```

### Simple example with no calculations or modifications (rules) applied to the data.

```
SELECT
    employee_id,
    salary
FROM
    employees
MODEL
    DIMENSION BY ( employee_id )  -- employee_id is the dimension
    MEASURES ( salary )           -- salary is the measure
    ( )                           -- empty rules section
ORDER BY
    employee_id
FETCH FIRST 10 ROWS ONLY
```

<figure><img src="../../../../../.gitbook/assets/image (121).png" alt="" width="225"><figcaption></figcaption></figure>

### Addressing a specific cell&#x20;

```
SELECT
    employee_id,
    salary
FROM
    employees
MODEL
    DIMENSION BY ( employee_id )
    MEASURES ( salary )
    RULES ( salary[employee_id = 100]= salary[employee_id = 100]+ 1000 )
ORDER BY
    employee_id
FETCH FIRST 10 ROWS ONLY;
```

<figure><img src="../../../../../.gitbook/assets/image (122).png" alt=""><figcaption></figcaption></figure>

### Addressing a range of cells (using a loop)

```
SELECT
    employee_id,
    salary
FROM
    employees
MODEL
    DIMENSION BY ( employee_id )
    MEASURES ( salary )
    RULES ( salary[
        FOR employee_id FROM 100 TO 105 INCREMENT 1
    ]= 1000 )
ORDER BY
    employee_id
FETCH FIRST 10 ROWS ONLY;
```

<figure><img src="../../../../../.gitbook/assets/image (123).png" alt="" width="174"><figcaption></figcaption></figure>

{% hint style="info" %}
Following query throws an error

```
  select employee_id, salary 
  from employees
  model
    dimension by (employee_id)
    measures (salary)
    RULES (
      salary[for employee_id from 100 to 105 INCREMENT 1] = 
        salary[for employee_id from 100 to 105 INCREMENT 1] + 1000 
      )
  order by employee_id
  fetch first 10 rows only;
  
  select employee_id, salary
  *
  ERROR at line 1:
  ORA-32622: illegal multi-cell reference
```
{% endhint %}

### Use of pseudo function cv()

```
SELECT
    employee_id,
    salary
FROM
    employees
MODEL
    DIMENSION BY ( employee_id )
    MEASURES ( salary )
    RULES ( salary[
        FOR employee_id FROM 100 TO 105 INCREMENT 1
    ]= salary[cv()]+ 1000 )
ORDER BY
    employee_id
FETCH FIRST 10 ROWS ONLY;
```

<figure><img src="../../../../../.gitbook/assets/image (124).png" alt=""><figcaption></figcaption></figure>

### Addressing a range of cells (using a list of values)

```
SELECT
    employee_id,
    salary
FROM
    employees
MODEL
    DIMENSION BY ( employee_id )
    MEASURES ( salary )
    RULES ( salary[
        FOR employee_id IN ( 100,
        102,
        104,
        105 )
    ]= salary[cv()]+ 1000 )
ORDER BY
    employee_id
FETCH FIRST 10 ROWS ONLY;
```

<figure><img src="../../../../../.gitbook/assets/image (125).png" alt="" width="170"><figcaption></figcaption></figure>

### Addressing a range of cells (using a subquery)

```
SELECT
    employee_id,
    salary
FROM
    employees
MODEL
    DIMENSION BY ( employee_id )
    MEASURES ( salary )
    RULES ( salary[
        FOR employee_id IN (
            SELECT
                level + 99
            FROM
                dual
            WHERE
                level NOT IN ( 2, 4 )
            CONNECT BY level <= 6
        )
    ]= salary[cv()]+ 1000 )
ORDER BY
    employee_id
FETCH FIRST 10 ROWS ONLY;
```

<figure><img src="../../../../../.gitbook/assets/image (126).png" alt="" width="164"><figcaption></figcaption></figure>

### The pseudo keyword ANY

```
-- Update all salaries by adding 1000 to the existing salary
SELECT
    employee_id,
    salary
FROM
    employees
MODEL
    DIMENSION BY ( employee_id )
    MEASURES ( salary )
    RULES ( salary[ANY]= salary[cv()]+ 1000 )
ORDER BY
    employee_id
FETCH FIRST 10 ROWS ONLY;
```

<figure><img src="../../../../../.gitbook/assets/image (127).png" alt="" width="171"><figcaption></figcaption></figure>

### Addressing cells relative to the current cell

```
SELECT
    employee_id,
    salary
FROM
    employees
MODEL
    DIMENSION BY ( employee_id )
    MEASURES ( salary )
    RULES ( salary[ANY]
    ORDER BY
        employee_id ASC
    = salary[cv()]+ salary[cv() + 1]+ salary[cv() + 3])
ORDER BY
    employee_id
FETCH FIRST 10 ROWS ONLY;
```

<figure><img src="../../../../../.gitbook/assets/image (129).png" alt="" width="161"><figcaption></figcaption></figure>

### Generating data

```
SELECT
    criteria
FROM
    dual
MODEL
    DIMENSION BY ( 100 criteria )
    MEASURES ( 0 x )
    RULES ( x[
        FOR criteria FROM 100 TO 105 INCREMENT 1
    ]= 0 );
```

<figure><img src="../../../../../.gitbook/assets/image (128).png" alt="" width="103"><figcaption></figcaption></figure>

### Row returning behaviour

```
SELECT
    employee_id
FROM
    employees
MODEL RETURN UPDATED ROWS
    DIMENSION BY ( employee_id )
    MEASURES ( 0 x )
    RULES ( x[
        FOR employee_id FROM 1 TO 10 INCREMENT 1
    ]= 0 );
```

<figure><img src="../../../../../.gitbook/assets/image (130).png" alt="" width="116"><figcaption></figcaption></figure>



