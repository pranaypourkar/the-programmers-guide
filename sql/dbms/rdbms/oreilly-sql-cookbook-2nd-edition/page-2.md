# 7. Working with Numbers

## Computing an Average

We want to compute the average value in a column.

1. Computing the average of all employee salaries

```
select avg(sal) as avg_sal from emp
```

2. Compute the average salary for each department

```
select deptno, avg(sal) as avg_sal from emp
group by deptno
```

## Finding the Min/Max Value in a Column

We want to find the highest and lowest values in a given column.

1. Lowest and highest salaries for all employees

```
select min(sal) as min_sal, max(sal) as max_sal from emp
```

2. Lowest and highest salaries for each department

```
select deptno, min(sal) as min_sal, max(sal) as max_sal 
from emp group by deptno
```

## Summing the Values in a Column

We want to compute the sum of all values in a column.

1. Sum for all employees

```
select sum(sal) from emp
```

2. &#x20;Sum for each department

```
select deptno, sum(sal) as total_for_dept
from emp group by deptno
```

## Counting Rows in a Table

We want to count the number of rows in a table, or want to count the number of values in a column.

1. Counting rows for the whole table

```
select count(*) from emp
```

2. Counting rows for each department

```
select deptno, count(*)
from emp group by deptno
```

## Counting Values in a Column

We want to count the number of non-NULL values in a column

```
select count(comm) from emp
```

{% hint style="info" %}
When we do COUNT(\*), counting is rows (regardless of actual value, which is why rows containing NULL and non-NULL values are counted). But when we do COUNT a column, we  are counting the number of non-NULL values in that column.
{% endhint %}

## Generating a Running Total

We want to calculate a running total or cumulative of values in a column

```
select ename, sal,
sum(sal) over (order by sal,empno) as running_total
from emp
order by 2
```

<figure><img src="../../../../.gitbook/assets/image.png" alt="" width="248"><figcaption></figcaption></figure>

## Generating a Running Product

We want to compute a running product on a numeric column

```
-- Oracle
select empno,ename,sal,
exp(sum(ln(sal))over(order by sal,empno)) as running_prod
from emp
where deptno = 10
```

{% hint style="info" %}
#### Steps to Calculate the Product Using `LN` and `EXP`

1. **Calculate the natural logarithm (`LN`) of each number.**
2. **Sum the logarithms.**
3. **Take the exponential (`EXP`) of the sum to get the product.**

```sql
SELECT EXP(SUM(LN(value))) AS product
FROM (
  SELECT 2 AS value FROM DUAL UNION ALL
  SELECT 3 AS value FROM DUAL UNION ALL
  SELECT 4 AS value FROM DUAL
);
-- Output -> 24
```
{% endhint %}

## Smoothing a Series of Values



