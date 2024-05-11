# Best Practice

* SQL statements are case-insensitive. Many SQL developers find that using <mark style="background-color:purple;">uppercase for all SQL keywords</mark> and <mark style="background-color:yellow;">lowercase for column and table names</mark> makes code easier to read and debug.

```
SELECT * FROM customers WHERE country = 'USA';
```

*   When a wildcard (\*) is specified, all the columns in the table are returned. The column order will typically, but not always, be the physical order in which the columns appear in the table definition. However, SQL data is seldom displayed as is. Even though use of wildcards

    may save the time and effort needed to list the desired columns explicitly, retrieving unnecessary columns usually slows down the performance of retrieval and the application.
