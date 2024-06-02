# 10. Working with Ranges

## Locating a Range of Consecutive Values

We want to determine which rows represent a range of consecutive projects.

For example, consider the below data. Excluding the first row, each row’s PROJ\_START should equal the PROJ\_END of the row before it. We want to find the range of dates for consecutive projects, we would like to return all rows where the current PROJ\_END equals the next row’s PROJ\_START

```
select * from V

PROJ_ID PROJ_START PROJ_END
------- ----------- -----------
1 01-JAN-2020 02-JAN-2020
2 02-JAN-2020 03-JAN-2020
3 03-JAN-2020 04-JAN-2020
4 04-JAN-2020 05-JAN-2020
5 06-JAN-2020 07-JAN-2020
6 16-JAN-2020 17-JAN-2020
7 17-JAN-2020 18-JAN-2020
8 18-JAN-2020 19-JAN-2020
9 19-JAN-2020 20-JAN-2020
10 21-JAN-2020 22-JAN-2020
11 26-JAN-2020 27-JAN-2020
12 27-JAN-2020 28-JAN-2020
13 28-JAN-2020 29-JAN-2020
14 29-JAN-2020 30-JAN-2020
```

Sample Output

```
PROJ_ID PROJ_START PROJ_END
------- ----------- -----------
1 01-JAN-2020 02-JAN-2020
2 02-JAN-2020 03-JAN-2020
3 03-JAN-2020 04-JAN-2020
6 16-JAN-2020 17-JAN-2020
7 17-JAN-2020 18-JAN-2020
8 18-JAN-2020 19-JAN-2020
11 26-JAN-2020 27-JAN-2020
12 27-JAN-2020 28-JAN-2020
13 28-JAN-2020 29-JAN-2020
```

```
select proj_id, proj_start, proj_end
from (
    select proj_id, proj_start, proj_end,
    lead(proj_start)over(order by proj_id) next_proj_start
    from V
) alias
where next_proj_start = proj_end
```

## Finding Differences Between Rows in the Same Group or Partition

We want to return the DEPTNO, ENAME, and SAL of each employee along with the difference in SAL between employees in the same department. The difference should be between each current employee and the employee hired immediately afterward. For each employee hired last in his department, return “N/A” for the difference.

<figure><img src="../../../../.gitbook/assets/image (3).png" alt="" width="352"><figcaption></figcaption></figure>

```
with next_sal_tab (deptno,ename,sal,hiredate,next_sal)
as
(
  select 
  deptno, 
  ename, 
  sal, 
  hiredate,
  lead(sal)over(partition by deptno order by hiredate) as next_sal 
  from emp 
)
select deptno, ename, sal, hiredate, coalesce(cast(sal-next_sal as char), 'N/A') as diff
from next_sal_tab
```

## Locating the Beginning and End of a Range of Consecutive Values

We have located the ranges of consecutive values and want to find just their start and end points.

**Sample data and output**

<figure><img src="../../../../.gitbook/assets/image (1) (1) (1).png" alt="" width="563"><figcaption></figcaption></figure>

```
SELECT
    proj_grp,
    MIN(proj_start),
    MAX(proj_end)
FROM
    (
        SELECT
            proj_id,
            proj_start,
            proj_end,
            SUM(flag) OVER( ORDER BY  proj_id ) proj_grp
        FROM
            (
                SELECT
                    proj_id,
                    proj_start,
                    proj_end,
                    CASE
                        WHEN LAG(proj_end) OVER(  ORDER BY proj_id  ) = proj_start THEN
                            0
                        ELSE
                            1
                    END flag
                FROM
                    v
            ) alias1
    ) alias2
GROUP BY
    proj_grp
```

## Filling in Missing Values in a Range of Values

We want to return the number of employees hired each year for the entire decade of the 2005s (2000-2009), but there are some years in which no employees were hired.

**Sample Output**

<figure><img src="../../../../.gitbook/assets/image (2) (1).png" alt="" width="116"><figcaption></figcaption></figure>

```
SELECT
    x.yr,
    coalesce(cnt, 0) cnt
FROM
    (
        SELECT
            EXTRACT(YEAR FROM MIN(hiredate) OVER()) - mod(EXTRACT(YEAR FROM MIN(hiredate) OVER()), 10) + ROWNUM - 1 yr
        FROM
            emp
        WHERE
            ROWNUM <= 10
    ) x
    LEFT JOIN (
        SELECT
            TO_NUMBER(to_char(hiredate, 'YYYY')) yr,
            COUNT(*)                             cnt
        FROM
            emp
        GROUP BY
            TO_NUMBER(to_char(hiredate, 'YYYY'))
    ) y ON ( x.yr = y.yr )
```

## Generating Consecutive Numeric Values

We need to have row source generator like below.

<figure><img src="../../../../.gitbook/assets/image (3) (1).png" alt="" width="88"><figcaption></figcaption></figure>

```
SELECT
    array id
FROM
    dual
MODEL
    DIMENSION BY ( 0 idx )
    MEASURES ( 1 array )
    RULES ITERATE(10) ( array[iteration_number]= iteration_number + 1 )
```

