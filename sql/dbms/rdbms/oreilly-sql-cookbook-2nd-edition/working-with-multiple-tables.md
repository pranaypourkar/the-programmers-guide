# 3. Working with Multiple Tables

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

## Combining Related Rows

Suppose we want to return rows from multiple tables by joining on a known common column or joining on columns that share common values. For example, we want to display the names of all employees in department 10 along with the location of each employee’s department, but that data is stored in two separate tables.

```
select e.ename, d.loc 
from emp e, dept d
where e.deptno = d.deptno and e.deptno = 10;
```

{% hint style="info" %}
The solution is an example of a join, or more accurately an equi-join, which is a type of inner join. Use the JOIN clause if we prefer to have the join logic in the FROM clause rather than the WHERE clause. Both styles are ANSI compliant.
{% endhint %}

```
select e.ename, d.loc
from emp e inner join dept d
on (e.deptno = d.deptno)
where e.deptno = 10
```

## Finding Rows in Common Between Two Tables

We want to find common rows between two tables, but there are multiple columns on which we can join. Suppose we have a view **V** with us.

<pre><code>-- Solution 1 using where clause
select e.empno,e.ename,e.job,e.sal,e.deptno
from emp e, V
where e.ename = v.ename
and e.job = v.job
and e.sal = v.sal

-- Solution 2 using join clause
select e.empno,e.ename,e.job,e.sal,e.deptno
from emp e join V
on ( e.ename = v.ename
and e.job = v.job
and e.sal = v.sal )

-- Solution 3 using intersect (specific to Oracle, PostgreSQL)
select empno,ename,job,sal,deptno
from emp
where (ename,job,sal) in (
select ename,job,sal from emp
intersect
select ename,job,sal from V
<strong>)
</strong></code></pre>



## Retrieving Values from One Table That Do Not Exist in Another

We want to find those values in one table that do not also exist in other table. For example, we want to find which departments (if any) in table DEPT do not exist in table EMP.

```
-- DB2, PostgreSQL, and SQL Server : Use the set operation EXCEPT:
select deptno from dept
except
select deptno from emp

-- Oracle : Use the set operation MINUS:
select deptno from dept
minus
select deptno from emp

-- Mysql
select deptno from dept
where deptno not in (select deptno from emp)
```

## Retrieving Rows from One Table That Do Not Correspond to Rows in Another

We want to find rows that are in one table that do not have a match in another table, for two tables that have common keys. For example, we want to find which departments have no employees.

```
select d.*
from dept d left outer join emp e
on (d.deptno = e.deptno)
where e.deptno is null
```

## Adding Joins to a Query Without Interfering with Other Joins

We have a query that returns the results. You need additional information, but when trying to get it, we started losing data from the original result set.

**Example**: We want to return all employees, the location of the department in which they work, and the date they received a bonus.

```
select e.ename, d.loc, eb.received
 from emp e join dept d
  on (e.deptno=d.deptno)
 left join emp_bonus eb
  on (e.empno=eb.empno)
order by 2
```

## Determining Whether Two Tables Have the Same Data

We want to know whether two tables or views have the same data (cardinality and values). We can perform SET difference MINUS or EXCEPT, depending on the DBMS, to make the problem of comparing tables easy to solve.

```
(
select empno,ename,job,mgr,hiredate,sal,comm,deptno,count(*) as cnt
  from V
  group by empno,ename,job,mgr,hiredate,sal,comm,deptno
minus
select empno,ename,job,mgr,hiredate,sal,comm,deptno,count(*) as cnt
  from emp
  group by empno,ename,job,mgr,hiredate,sal,comm,deptno
)
union all
(
select empno,ename,job,mgr,hiredate,sal,comm,deptno,count(*) as cnt
  from emp
  group by empno,ename,job,mgr,hiredate,sal,comm,deptno
minus
select empno,ename,job,mgr,hiredate,sal,comm,deptno,count(*) as cnt
  from V
  group by empno,ename,job,mgr,hiredate,sal,comm,deptno
)
```

{% hint style="info" %}
If the tables in question are equal, then no rows are returned. If the tables are different, the rows causing the difference are returned. As an easy first step when comparing tables, we can compare the cardinalities alone rather than including them with the data comparison.

`select count(`_`) from emp`_ \
_`union`_ \
_`select count(`_`) from dept`

Because UNION will filter out duplicates, only one row will be returned if the tables’ cardinalities are the same. Because two rows are returned in this example, we know that the tables do not contain identical row sets
{% endhint %}

## Identifying and Avoiding Cartesian Products

We want to return the name of each employee in department 20 along with the location of the department. The following query is returning incorrect data due to cartesian product

```
-- Incorrect query
select e.ename, d.loc
from emp e, dept d
where e.deptno = 20;

-- Correct query
select e.ename, d.loc
from emp e, dept d
where e.deptno = 10
and d.deptno = e.deptno
```

## Performing Joins When Using Aggregates

We want to perform an aggregation, but the query involves multiple tables. For example, we want to find the sum of the salaries for employees in department 10 along with the sum of their bonuses. Some employees have more than one bonus but all employees in department 10 have been given bonuses.

Sample table EMP\_BONUS contains the following data:

<figure><img src="../../../../.gitbook/assets/image (1) (1) (1) (1).png" alt="" width="493"><figcaption></figcaption></figure>

```
-- Solution 1
select deptno,
    sum(distinct sal) as total_sal,
    sum(bonus) as total_bonus
from (
    select e.empno,
        e.ename,
        e.sal,
        e.deptno,
        e.sal*case when eb.type = 1 then .1
            when eb.type = 2 then .2
            else .3
            end as bonus
    from emp e, emp_bonus eb
    where e.empno = eb.empno
    and e.deptno = 10
) x
group by deptno

-- Solution 2 using window function
select e.empno,
    e.ename,
    sum(distinct e.sal) over (partition by e.deptno) as total_sal,
    e.deptno,
    sum(e.sal*case when eb.type = 1 then .1
        when eb.type = 2 then .2
        else .3 end) over (partition by deptno) as total_bonus
from emp e, emp_bonus eb
where e.empno = eb.empno and e.deptno = 10
```

{% hint style="info" %}
We have to be careful when computing aggregates across joins. Typically when duplicates are returned due to a join, we can avoid miscalculations by aggregate functions in two ways: Using DISTINCT or by performing the aggregation first prior to joining because the aggregate will already be computed before the join.
{% endhint %}

## Performing Outer Joins When Using Aggregates

Same scenario as above but not all employees in department 10 have been given bonuses.

<figure><img src="../../../../.gitbook/assets/image (1) (1) (1) (1) (1).png" alt="" width="256"><figcaption></figcaption></figure>

<pre><code>-- Solution 1
select deptno,
    sum(distinct sal) as total_sal,
    sum(bonus) as total_bonus
from (
    select e.empno,
        e.ename,
        e.sal,
        e.deptno,
        e.sal*case when eb.type is null then 0
            when eb.type = 1 then .1
            when eb.type = 2 then .2
            else .3 end as bonus
    from emp e left outer join emp_bonus eb
    on (e.empno = eb.empno)
    where e.deptno = 10
)
group by deptno

-- Solution 2 using window function
select distinct deptno,total_sal,total_bonus
from (
    select e.empno,
        e.ename,
        sum(distinct e.sal) over (partition by e.deptno) as total_sal,
        e.deptno,
<strong>        sum(e.sal*case when eb.type is null then 0
</strong>            when eb.type = 1 then .1
            when eb.type = 2 then .2
            else .3
            end) over (partition by deptno) as total_bonus
    from emp e left outer join emp_bonus eb
    on (e.empno = eb.empno)
    where e.deptno = 10
) x
</code></pre>

## Returning Missing Data from Multiple Tables

We want to return missing data from multiple tables simultaneously. Solution is to use FULL OUTER JOIN to return missing rows from both tables along with matching rows.

```
select d.deptno,d.dname,e.ename
from dept d full outer join emp e
on (d.deptno=e.deptno)
```

## Using NULLs in Operations and Comparisons

NULL is never equal to or not equal to any value, not even itself, but we want to evaluate values returned by a nullable column. For example, we want to find all employees in EMP whose commission is less than the commission of employee ALAN. Employees with a NULL commission should be included as well. Solution is to use function such as COALESCE to transform the NULL value into a real value that can be used in standard evaluation.

```
select ename,comm
from emp
where coalesce(comm,0) < ( select comm
    from emp
    where ename = 'ALAN' )
```







