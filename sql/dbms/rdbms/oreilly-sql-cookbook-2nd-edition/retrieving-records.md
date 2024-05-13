# Retrieving Records

## Retrieving All Rows and Columns from a Table

```
select * from emp;
```

{% hint style="info" %}
Above query is same to this one in terms of performance but while writing program, it is good to write columns so that we will always know what columns we are returning from the query.&#x20;

**select empno,ename,job,sal,mgr,hiredate,comm,deptno from emp**
{% endhint %}

## Finding Rows That Satisfy Multiple Conditions

```sql
select * from emp where ( deptno = 10 or comm is not null or sal <= 2000 )
and deptno=20
```

## Providing Meaningful Names for Columns

Using the AS keyword to give new names to columns returned by the query is known as aliasing those columns. The new name that is given is known as aliase.

```
select sal as salary, comm as commission from emp
```
