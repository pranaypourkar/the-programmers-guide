# 2. Sorting Query Results

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

## Sorting Mixed Alphanumeric Data

Use the functions REPLACE and TRANSLATE to modify the string for sorting.

{% hint style="info" %}
REPLACE

Replaces all occurrences of a specific substring within a string with another substring.

`REPLACE(string_expression, old_substring, new_substring)`



TRANSLATE

Translates characters within a string based on a translation table defined by another string.

`TRANSLATE(string_expression, from_string, to_string)`
{% endhint %}

```
/* ORDER BY ENAME */
select data
from V
order by replace(
translate(data,'0123456789','##########'),'#','')
```

## Dealing with Nulls When Sorting

We want to sort results from EMP by COMM, but the field is nullable. We need a way to specify whether nulls should come last.

{% hint style="info" %}
Do NULL values come first or last when we use ORDER BY?

The SQL standard does not define the default ordering of NULLs. If we apply the ORDER BY clause to a column with NULLs, the NULL values will be placed either first or last in the result set. The output depends on the database type.

For example, in Oracle, the NULL value records will come first.
{% endhint %}

```
/* NON-NULL COMM SORTED ASCENDING, ALL NULLS LAST */
select ename,sal,comm
from (
    select ename,sal,comm,
    case when comm is null then 0 else 1 end as is_null
    from emp
    ) x
order by is_null desc,comm
```

```
-- Oracle specific solution
/* NON-NULL COMM SORTED ASCENDING, ALL NULLS LAST */
select ename,sal,comm from emp order by comm nulls last;
```

## Sorting based on some specific data

We want to sort based on some conditional logic. For example, if JOB is SALESMAN, we want to sort on COMM; otherwise, we want to sort by SAL. Use a CASE expression in the ORDER BY clause.

```
select ename,sal,job,comm from emp order by 
case when job = 'SALESMAN' then comm else sal end;
```







