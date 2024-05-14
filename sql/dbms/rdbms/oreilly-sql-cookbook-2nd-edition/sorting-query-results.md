# Sorting Query Results

## Returning Query Results in a Specified Order

We want to order query result.

```
select ename,job,sal from emp where deptno = 10 order by sal asc;
select ename,job,sal from emp where deptno = 10 order by sal desc;
select ename,job,sal from emp where deptno = 10 order by 3 desc;
```

## Sorting by Multiple Fields

We want to sort the rows from EMP first by DEPTNO ascending, then by SALARY descending.

```
select empno,deptno,sal,ename,job from emp order by deptno, sal desc;
```

## Sorting by Substrings

We want to sort the results of a query by specific parts of a string. For example, we want to return employee names and jobs from table EMP and sort by the last two characters in the JOB field.

```
select ename,job from emp order by substr(job,length(job)-1);
```









