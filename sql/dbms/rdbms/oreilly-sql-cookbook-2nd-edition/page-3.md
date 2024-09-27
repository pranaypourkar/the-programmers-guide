# 14. Odds 'n' Ends

## Transposing a Result Set Using Oracle’s MODEL Clause

<figure><img src="../../../../.gitbook/assets/image (2) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt="" width="314"><figcaption></figcaption></figure>

```
select max(d10) d10,
max(d20) d20,
max(d30) d30
from (
    select d10,d20,d30
    from ( select deptno, count(*) cnt from emp group by deptno )
    model
    dimension by(deptno d)
    measures(deptno, cnt d10, cnt d20, cnt d30)
    rules(
        d10[any] = case when deptno[cv()]=10 then d10[cv()] else 0 end,
        d20[any] = case when deptno[cv()]=20 then d20[cv()] else 0 end,
        d30[any] = case when deptno[cv()]=30 then d30[cv()] else 0 end
)
)
```

## Extracting Elements of a String from Unfixed Locations

We have a string field that contains serialized log data. We want to parse through the string and extract the relevant information. Unfortunately, the relevant information is not at fixed points in the string.

Sample Input

<figure><img src="../../../../.gitbook/assets/image (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt="" width="375"><figcaption></figcaption></figure>

We want to extract the values between the square brackets

Sample Output

<figure><img src="../../../../.gitbook/assets/image (2) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt="" width="330"><figcaption></figcaption></figure>

```
create view V
as
    select 'xxxxxabc[867]xxx[-]xxxx[5309]xxxxx' msg from dual
    union all
    select 'xxxxxtime:[11271978]favnum:[4]id:[Joe]xxxxx' msg from dual
    union all
    select 'call:[F_GET_ROWS()]b1:[ROSEWOOD…SIR]b2:[44400002]77.90xxxxx' msg from dual
    union all
    select 'film:[non_marked]qq:[unit]tailpipe:[withabanana?]80sxxxxx' msg from dual

select substr(msg,
    instr(msg,'[',1,1)+1,
    instr(msg,']',1,1)-instr(msg,'[',1,1)-1) first_val,
    substr(msg,
    instr(msg,'[',1,2)+1,
    instr(msg,']',1,2)-instr(msg,'[',1,2)-1) second_val,
    substr(msg,
    instr(msg,'[',-1,1)+1,
    instr(msg,']',-1,1)-instr(msg,'[',-1,1)-1) last_val
from V
```

## Finding the Number of Days in a Year (an Alternate Solution)

We want to find the number of days in a year.

```
select 'Days in 2021: '||
    to_char(add_months(trunc(sysdate,'y'),12)-1,'DDD')
    as report
from dual
union all
select 'Days in 2020: '||
    to_char(add_months(trunc(
    to_date('01-SEP-2020'),'y'),12)-1,'DDD')
from dual
```

<figure><img src="../../../../.gitbook/assets/image (3) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt="" width="177"><figcaption></figcaption></figure>

## Searching for Mixed Alphanumeric Strings

We have a column with mixed alphanumeric data and want to return those rows that have both alphabetical and numeric characters.

```
STRINGS
------------
1010 switch
333
3453430278
ClassSummary
findRow 55
threes
```

Sample Output

```
STRINGS
------------
1010 switch
findRow 55
```

```
with v as (
    select 'ClassSummary' strings from dual union
    select '3453430278' from dual union
    select 'findRow 55' from dual union
    select '1010 switch' from dual union
    select '333' from dual union
    select 'threes' from dual
)
select strings
from (
    select strings,
    translate(
    strings,
    'abcdefghijklmnopqrstuvwxyz0123456789',
    rpad('#',26,'#')||rpad('*',10,'*')
) translated
from v
) x
whereinstr(translated,'#') > 0
and instr(translated,'*') > 0
```

## Converting Whole Numbers to Binary

We want to convert a whole number to its binary representation.

<figure><img src="../../../../.gitbook/assets/image (4) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt="" width="211"><figcaption></figcaption></figure>

Because of MODEL’s ability to iterate and provide array access to row values, it is a best choice for this operation.

```
select ename,
sal,
(
select bin
from dual
model
dimension by ( 0 attr )
measures ( sal num, cast(null as varchar2(30)) bin, '0123456789ABCDEF' hex
 )
 rules iterate (10000) until (num[0] <= 0) (
 bin[0] = substr(hex[cv()],mod(num[cv()],2)+1,1)||bin[cv()],
 num[0] = trunc(num[cv()]/2)
 )
 ) sal_binary
from emp
```

## Pivoting a Ranked Result Set

We want to rank the values in a table and then pivot the result set into three columns. The idea is to show the top three, the next three, and then all the rest.

<figure><img src="../../../../.gitbook/assets/image (6) (1) (1) (1) (1) (1).png" alt="" width="325"><figcaption></figcaption></figure>

```
SELECT
    MAX(
        CASE grp
            WHEN 1 THEN
                rpad(ename, 6)
                || ' ('
                || sal
                || ')'
        END
    ) top_3,
    MAX(
        CASE grp
            WHEN 2 THEN
                rpad(ename, 6)
                || ' ('
                || sal
                || ')'
        END
    ) next_3,
    MAX(
        CASE grp
            WHEN 3 THEN
                rpad(ename, 6)
                || ' ('
                || sal
                || ')'
        END
    ) rest
FROM
    (
        SELECT
            ename,
            sal,
            rnk,
            CASE
                WHEN rnk <= 3 THEN
                    1
                WHEN rnk <= 6 THEN
                    2
                ELSE
                    3
            END grp,
            ROW_NUMBER()
            OVER(PARTITION BY
                CASE
                    WHEN rnk <= 3 THEN
                        1
                    WHEN rnk <= 6 THEN
                        2
                    ELSE
                        3
                END
                 ORDER BY
                     sal DESC, ename
            )   grp_rnk
        FROM
            (
                SELECT
                    ename,
                    sal,
                    DENSE_RANK()
                    OVER(
                        ORDER BY
                            sal DESC
                    ) rnk
                FROM
                    emp
            ) x
    ) y
GROUP BY
    grp_rnk
```

**Explanation**

<figure><img src="../../../../.gitbook/assets/image (7) (1) (1) (1) (1) (1).png" alt="" width="293"><figcaption></figcaption></figure>

<div align="left">

<figure><img src="../../../../.gitbook/assets/image (8) (1) (1) (1) (1).png" alt="" width="342"><figcaption></figcaption></figure>

 

<figure><img src="../../../../.gitbook/assets/image (9) (1) (1) (1).png" alt="" width="237"><figcaption></figcaption></figure>

</div>

## Adding a Column Header into a Double Pivoted Result Set

We want to stack two result sets and then pivot them into two columns. Additionally, we want to add a “header” for each group of rows in each column. For example, we have two tables containing information about employees working in different areas of development in your company

```
select * from it_research
DEPTNO ENAME
------ --------------------
100 HOPKINS
100 JONES
100 TONEY
200 MORALES
200 P.WHITAKER
200 MARCIANO
200 ROBINSON
300 LACY
300 WRIGHT
300 J.TAYLOR

select * from it_apps
DEPTNO ENAME
------ -----------------
400 CORRALES
400 MAYWEATHER
400 CASTILLO
400 MARQUEZ
400 MOSLEY
500 GATTI
500 CALZAGHE
600 LAMOTTA
600 HAGLER
600 HEARNS
600 FRAZIER
700 GUINN
700 JUDAH
700 MARGARITO
```

Sample Output

<figure><img src="../../../../.gitbook/assets/image (10) (1).png" alt="" width="252"><figcaption></figcaption></figure>

```
create table IT_research (deptno number, ename varchar2(20))

insert into IT_research values (100,'HOPKINS')
insert into IT_research values (100,'JONES')
insert into IT_research values (100,'TONEY')
insert into IT_research values (200,'MORALES')
insert into IT_research values (200,'P.WHITAKER')
insert into IT_research values (200,'MARCIANO')
insert into IT_research values (200,'ROBINSON')
insert into IT_research values (300,'LACY')
insert into IT_research values (300,'WRIGHT')
insert into IT_research values (300,'J.TAYLOR')

create table IT_apps (deptno number, ename varchar2(20))

insert into IT_apps values (400,'CORRALES')
insert into IT_apps values (400,'MAYWEATHER')
insert into IT_apps values (400,'CASTILLO')
insert into IT_apps values (400,'MARQUEZ')
insert into IT_apps values (400,'MOSLEY')
insert into IT_apps values (500,'GATTI')
insert into IT_apps values (500,'CALZAGHE')
insert into IT_apps values (600,'LAMOTTA')
insert into IT_apps values (600,'HAGLER')
insert into IT_apps values (600,'HEARNS')
insert into IT_apps values (600,'FRAZIER')
insert into IT_apps values (700,'GUINN')
insert into IT_apps values (700,'JUDAH')
insert into IT_apps values (700,'MARGARITO')

select max(decode(flag2,0,it_dept)) research,
       max(decode(flag2,1,it_dept)) apps
  from (
select sum(flag1)over(partition by flag2 order by flag1,rownum) flag,
  it_dept, 
  flag2
  from (
select 1 flag1, 0 flag2,
decode(rn,1,to_char(deptno),' '||ename) it_dept
  from (
select x.*, y.id, row_number()over(partition by x.deptno order by y.id) rn
from (
  select deptno,
  ename,
  count(*)over(partition by deptno) cnt
  from it_research
) x,
(select level id from dual connect by level <= 2) y
)
where rn <= cnt+1
union all
select 1 flag1, 1 flag2,
 decode(rn,1,to_char(deptno),' '||ename) it_dept
 from (
   select x.*, y.id,
   row_number()over(partition by x.deptno order by y.id) rn
   from (
   select deptno,
   ename,
   count(*)over(partition by deptno) cnt
   from it_apps
 ) x,
 (select level id from dual connect by level <= 2) y
 )
 where rn <= cnt+1
 ) tmp1
 ) tmp2
 group by flag

```

## Parsing Serialized Data into Rows

We have serialized data (stored in strings) that you want to parse and return as rows. The values are delimited by colons, and a string may or may not have all three entries

```
STRINGS
-----------------------------------
entry:stewiegriffin:lois:brian:
entry:moe::sizlack:
entry:petergriffin:meg:chris:
entry:willie:
entry:quagmire:mayorwest:cleveland:
entry:::flanders:
entry:robo:tchi:ken:
```

Sample Output

<figure><img src="../../../../.gitbook/assets/image (11) (1).png" alt="" width="293"><figcaption></figcaption></figure>

```
create view V
as
    select 'entry:stewiegriffin:lois:brian:' strings
    from dual
union all
    select 'entry:moe::sizlack:'
    from dual
union all
    select 'entry:petergriffin:meg:chris:'
    from dual
union all
    select 'entry:willie:'
    from dual
union all
    select 'entry:quagmire:mayorwest:cleveland:'
    from dual
union all
    select 'entry:::flanders:'
    from dual
union all
    select 'entry:robo:tchi:ken:'
    from dual;


with cartesian as (
    select level id
    from dual
    connect by level <= 100
)
select max(decode(id,1,substr(strings,p1+1,p2-1))) val1,
    max(decode(id,2,substr(strings,p1+1,p2-1))) val2,
    max(decode(id,3,substr(strings,p1+1,p2-1))) val3
from (
    select v.strings,
    c.id,
    instr(v.strings,':',1,c.id) p1,
    instr(v.strings,':',1,c.id+1)-instr(v.strings,':',1,c.id) p2
    from v, cartesian c
    where c.id <= (length(v.strings)-length(replace(v.strings,':')))-1
)
group by strings
order by 1
```

**Explanation**

<figure><img src="../../../../.gitbook/assets/image (12).png" alt="" width="466"><figcaption></figcaption></figure>

<figure><img src="../../../../.gitbook/assets/image (13).png" alt="" width="472"><figcaption></figcaption></figure>

## Calculating Percent Relative to Total

We want to report a set of numeric values, and you want to show each value as a percentage of the whole.

Sample Output

<figure><img src="../../../../.gitbook/assets/image (14).png" alt="" width="263"><figcaption></figcaption></figure>

```
select job,num_emps,sum(round(pct)) pct_of_all_salaries
 from (
  select job,
  count(*)over(partition by job) num_emps,
  ratio_to_report(sal)over()*100 pct
  from emp
)
group by job,num_emps
```

