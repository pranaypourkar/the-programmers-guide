# 8. Date Arithmetic

## Adding and Subtracting Days, Months, and Years

We need to add or subtract some number of days, months, or years from a date

```
-- Oracle
select 
    hiredate-5 as hd_minus_5D,
    hiredate+5 as hd_plus_5D,
    add_months(hiredate,-5) as hd_minus_5M,
    add_months(hiredate,5) as hd_plus_5M,
    add_months(hiredate,-5*12) as hd_minus_5Y,
    add_months(hiredate,5*12) as hd_plus_5Y
from emp
where deptno = 10
```

<figure><img src="../../../../.gitbook/assets/image (111).png" alt="" width="461"><figcaption></figcaption></figure>

## Determining the Number of Days Between Two Dates

We want to find the difference between two dates and represent the result in days.

For example, use two inline views to find the HIREDATEs for WARD and ALLEN, and then subtract one date from the other

```
select ward_hd - allen_hd
from (
    select hiredate as ward_hd
    from emp
    where ename = 'WARD'
) x,
(
    select hiredate as allen_hd
    from emp
    where ename = 'ALLEN'
) y
```

## Determining the Number of Business Days Between Two Dates

We want to find how many “working” days are between 2 dates, including the 2 dates themselves.

```
SELECT 
  -- Calculate the difference in days between the two dates (inclusive)
  TRUNC(TO_DATE('2024-05-31', 'YYYY-MM-DD')) - TRUNC(TO_DATE('2024-05-28', 'YYYY-MM-DD')) + 1 AS total_days,
  -- Count the number of weekend days (Saturday and Sunday) within the date range
  COUNT(CASE WHEN TO_CHAR(calendar_date, 'DY') IN ('SAT', 'SUN') THEN calendar_date END) AS weekend_days,
  -- Working days = total days - weekend days
  TRUNC(TO_DATE('2024-05-31', 'YYYY-MM-DD')) - TRUNC(TO_DATE('2024-05-28', 'YYYY-MM-DD')) + 1 - COUNT(CASE WHEN TO_CHAR(calendar_date, 'DY') IN ('SAT', 'SUN') THEN calendar_date END) AS working_days
FROM (
  -- Generate a sequence of dates between the start and end date (inclusive)
  SELECT 
    TO_DATE(level - 1 + TO_CHAR(TO_DATE('2024-05-28', 'YYYY-MM-DD'), 'YYYYDDD'), 'YYYYDDD') AS calendar_date
  FROM DUAL
  CONNECT BY LEVEL <= TRUNC(TO_DATE('2024-05-31', 'YYYY-MM-DD')) - TRUNC(TO_DATE('2024-05-28', 'YYYY-MM-DD')) + 1
) date_range
WHERE calendar_date BETWEEN TO_DATE('2024-05-28', 'YYYY-MM-DD') AND TO_DATE('2024-05-31', 'YYYY-MM-DD');
```

{% hint style="info" %}
Output of \
SELECT TO\_DATE(level - 1 + TO\_CHAR(TO\_DATE('2024-05-28', 'YYYY-MM-DD'), 'YYYYDDD'), 'YYYYDDD') AS calendar\_date FROM DUAL CONNECT BY LEVEL <= TRUNC(TO\_DATE('2024-05-31', 'YYYY-MM-DD')) - TRUNC(TO\_DATE('2024-05-28', 'YYYY-MM-DD')) + 1

![](<../../../../.gitbook/assets/image (112).png>)
{% endhint %}

## Determining the Number of Months or Years Between Two Dates

We want to find the difference between two dates in terms of either months or years.

```
select months_between(max_hd,min_hd),
months_between(max_hd,min_hd)/12
from (
    select min(hiredate) min_hd, max(hiredate) max_hd
    from emp
) x
```

## Determining the Number of Seconds, Minutes, or Hours Between Two Dates

We want to return the difference in seconds between two dates.

```
SELECT 
  -- Calculate the difference between the two dates in seconds
  CAST(end_date - start_date AS NUMBER(10, 6)) * 86400 AS seconds,
  -- Calculate the difference between the two dates in minutes
  CAST(end_date - start_date AS NUMBER(10, 6)) * 60 * 60 AS minutes,
  -- Calculate the difference between the two dates in hours
  CAST(end_date - start_date AS NUMBER(10, 6)) * 24 AS hours
FROM (
  -- Sample test data (replace with your actual dates)
  SELECT 
    TO_DATE('2024-05-31 10:00:00', 'YYYY-MM-DD HH24:MI:SS') AS start_date,
    TO_DATE('2024-06-01 12:30:00', 'YYYY-MM-DD HH24:MI:SS') AS end_date
  FROM DUAL
) date_range;
```

## Counting the Occurrences of Weekdays in a Year&#x20;

We want to count the number of times each weekday occurs in one year.

{% hint style="info" %}
To find the number of occurrences of each weekday in a year:

1. Generate all possible dates in the year.
2. Format the dates such that they resolve to the name of their respective weekdays.
3. Count the occurrence of each weekday name.
{% endhint %}

```
WITH x AS (
    SELECT
        level lvl
    FROM
        dual
    CONNECT BY
        level <= ( add_months(trunc(sysdate, 'y'),
                              12) - trunc(sysdate, 'y') )
)
SELECT
    to_char(trunc(sysdate, 'y') + lvl - 1,
            'DAY'),
    COUNT(*)
FROM
    x
GROUP BY
    to_char(trunc(sysdate, 'y') + lvl - 1,
            'DAY')
```

<figure><img src="../../../../.gitbook/assets/image (115).png" alt=""><figcaption></figcaption></figure>

## Determining the Date Difference Between the Current Record and the Next Record

We want to determine the difference in days between two dates (specifically dates stored in two different rows).

```
select ename, hiredate, next_hd,
next_hd - hiredate diff
from (
    select deptno, ename, hiredate,
    lead(hiredate)over(order by hiredate) next_hd
    from emp
)
where deptno=10
```

