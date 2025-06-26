# MYSQL Examples

## 1. Retrieve values that are exactly 10 characters long

```sql
SELECT column_name
FROM your_table
WHERE CHAR_LENGTH(column_name) = 10;
```

In this query:

* Replace `column_name` with the name of the column we want to check the length of.
* Replace `your_table` with the name of our table.

This query will return all rows where the specified column contains values that are exactly 10 characters long.
