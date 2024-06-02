# Set 1

## Display 9th record from employees table

```
-- Solution 1 using rowid
select rowid, first_name from employees where rowid = 
(
    select rowid from employees where rownum <= 9 
    minus 
    select rowid from employees where rownum < 9
);

-- Solution 2 using rownum
select * from 
(
select rownum r, e.* from employees e where rownum <= 9 order by employee_id
) a where a.r = 9
```

## Display 5 TO 7 records from employees table

```
-- Solution 1 using rowid
select rowid, first_name from employees where rowid in 
(
    select rowid from employees where rownum <= 7 
    minus 
    select rowid from employees where rownum < 5
);

-- Solution 2 using rownum
select * from 
(
select rownum r, e.* from employees e where rownum <= 9 order by employee_id
) a where a.r >= 5 and a.r <= 7
```

## Delete The Repeated Rows from employees table

```
DELETE FROM employees WHERE rowid NOT IN 
(SELECT MIN(rowid) FROM employees GROUP BY ename);
```

## Display the names of the employees who earn highest salary in their respective departments

```
select * from employees where (DEPARTMENT_ID,salary) in 
(select DEPARTMENT_ID, max(salary) from employees group by DEPARTMENT_ID);
```

## Display the names of employees whose names have second alphabet A in their names

```
SELECT ename FROM emp WHERE ename LIKE ‘_A%’;
```

