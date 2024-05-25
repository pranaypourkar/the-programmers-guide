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



