# Best Practice

* SQL statements are case-insensitive. Many SQL developers find that using <mark style="background-color:purple;">uppercase for all SQL keywords</mark> and <mark style="background-color:yellow;">lowercase for column and table names</mark> makes code easier to read and debug.

```
SELECT * FROM customers WHERE country = 'USA';
```

*   When a wildcard (\*) is specified, all the columns in the table are returned. The column order will typically, but not always, be the physical order in which the columns appear in the table definition. However, SQL data is seldom displayed as is. Even though use of wildcards

    may save the time and effort needed to list the desired columns explicitly, retrieving unnecessary columns usually slows down the performance of retrieval and the application.
* If SQL query is unsorted, meaning no explicit sort order, data will typically be displayed in the order in which it appears in the underlying tables. This could be the order in which the data was added to the tables initially. However, if data was subsequently updated or deleted, the order will be affected by how the DBMS reuses reclaimed storage space. The end result is that we cannot (and should not) rely on the sort order if we do not explicitly control it.
*   **SQL Versus Application Filtering**: Data can also be filtered at the client application level. To do this, the SQL SELECT statement retrieves more data than is actually required for the

    client application, and the client code loops through the returned data to extract just the needed rows. As a rule, this practice is strongly discouraged. Databases are optimized to perform filtering quickly and efficiently. Making the client application (or development language) do the database’s job will dramatically impact application performance and will create applications that cannot scale properly. In addition, if data is filtered at the client, the server has to send unneeded data across the network connections, resulting in a waste of network bandwidth usage.
* We might expect that when we filter to select all rows that do not have a particular value (Say someColumn !=10), rows with a NULL will be returned. But they will not. NULL is strange this way, and rows with NULL in the filter column are not returned when filtering for matches or when filtering for non-matches.
* **Wildcard Filtering:** Rules to keep in mind when using wildcards -

\-> Don’t overuse wildcards. If another search operator will do, use it instead.\
\-> When we do use wildcards, try not to use them at the beginning of the search pattern unless absolutely necessary. Search patterns that begin with wildcards are the slowest to process.\
\-> Pay careful attention to the placement of the wildcard symbols. If they are misplaced, you might not return the data you intended.

* **AS Optional Keyword (Alias)**: Use of the AS keyword is optional in many DBMSs, but using it is considered a best practice. Aliases have other uses too. Some common uses include renaming a column if the real table column name contains illegal characters (for example, spaces) and expanding column names if the original names are either ambiguous or easily misread.
*   Although, we can perform checks before inserting new rows (do a SELECT on another table to make sure the values are valid and present), it is best to avoid this practice for the following reasons:

    \-> If database integrity rules are enforced at the client level, every client is obliged to enforce those rules, and inevitably some clients won’t.

    \-> We must also enforce the rules on UPDATE and DELETE operations. Performing client-side checks is a time-consuming process. Having the DBMS do the checks for you is far more efficient.
