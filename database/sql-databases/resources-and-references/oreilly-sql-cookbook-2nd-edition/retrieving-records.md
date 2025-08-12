# 1. Retrieving Records

## Retrieving All Rows and Columns from a Table

```
select * from emp;
```

{% hint style="info" %}
Above query is same to this one in terms of performance but while writing program, it is good to write columns so that we will always know what columns we are returning from the query.

**select empno,ename,job,sal,mgr,hiredate,comm,deptno from emp;**
{% endhint %}

## Finding Rows That Satisfy Multiple Conditions

```sql
select * from emp where ( deptno = 10 or comm is not null or sal <= 2000 )
and deptno=20
```

## Providing Meaningful Names for Columns

Using the AS keyword to give new names to columns returned by the query is known as aliasing those columns. The new name that is given is known as aliase.

```
select sal as salary, comm as commission from emp;
```

## Referencing an Aliased Column in the WHERE Clause

An attempt to reference alias names in the WHERE clause will fail. We need to wrap the query as an inline view to reference the aliased columns.

{% hint style="info" %}
The WHERE clause is evaluated before the SELECT; thus, SALARY and COMMISSION do not yet exist when the query’s WHERE clause is evaluated. Those aliases are not applied until after the WHERE clause processing is complete.
{% endhint %}

```
-- Will not work
select sal as salary, comm as commission from emp where salary < 5000

-- Will work
select * from (select sal as salary, comm as commission from emp) x where salary < 5000;
```

## Concatenating Column Values

We can return values in multiple columns as one column.

```
-- DB2, Oracle, PostgreSQL
select ename||' WORKS AS A '||job as msg from emp where deptno=10;

-- MySQL
select concat(ename, ' WORKS AS A ',job) as msg from emp where deptno=10;

-- SQL Server
select ename + ' WORKS AS A ' + job as msg from emp where deptno=10;
```

## Using Conditional Logic in a SELECT Statement

We can use the CASE expression to perform conditional logic directly.

```
select ename,sal,
    case when sal <= 2000 then 'UNDERPAID'
         when sal >= 4000 then 'OVERPAID'
         else 'OK'
    end as status
from emp
```

## Limiting the Number of Rows Returned

We can use the built-in function provided by the database to control the number of rows returned.

```
-- MySQL
select * from emp limit 5;

-- Oracle
select * from emp where rownum <= 5;
```

{% hint style="info" %}
Oracle ROWNUM explanation -

Here is what happens when we use ROWNUM <= 5 to return the first five rows:

1. Oracle executes the query.
2. Oracle fetches the first row and calls it row number one.
3. Have we gotten past row number five yet? If no, then Oracle returns the row, because it meets the criteria of being numbered less than or equal to five. If yes, then Oracle does not return the row.
4. Oracle fetches the next row and advances the row number (to two, then to three, then to four, and so forth).
5. Go to step 3.

Here is what happens when we use ROWNUM = 5

1. Oracle executes the query.
2. Oracle fetches the first row and calls it row number one.
3. Have we gotten to row number five yet? If no, then Oracle discards the row, because it doesn’t meet the criteria. If yes, then Oracle returns the row. But the answer will never be yes!
4. Oracle fetches the next row and calls it row number one. This is because the first row to be returned from the query must be numbered as one.
5. Go to step 3.
{% endhint %}

## Returning n Random Records from a Table

We want to return a specific number of random records from a table.

```
-- MySql
select ename,job from emp order by rand() limit 5

-- Oracle
select * from (
        select ename, job
        from emp
        order by dbms_random.value()
    ) where rownum <= 5
```

## Finding Null Values

We want to find all rows that are null for a particular column.

```
select * from emp where comm is null;
```

## Transforming Nulls into Real Values

We have rows that contain nulls and would like to return non-null values in place of those nulls.

<pre><code>-- Option 1: using built-in function (Better than option 2)
select coalesce(comm,0) from emp;

-- Option 2: using CASE
select case
<strong>         when comm is not null then comm
</strong>         else 0
       end
from emp;
</code></pre>

## Searching for Patterns

We want to return rows that match a particular substring or pattern.

```
select ename, job from emp where deptno in (10,20);
select ename, job from emp where deptno in (10,20) and (ename like '%I%' or job like '%ER');
```
