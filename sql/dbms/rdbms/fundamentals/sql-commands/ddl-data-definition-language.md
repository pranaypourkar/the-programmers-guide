# DDL (Data Definition Language)

It is used to define the structure of the database schema, including creating, altering, and dropping schema objects like tables, views, indexes, and users.

{% hint style="info" %}
DDL does not include creating the database itself in oracle context. DDL commands are specifically used to define the structure of objects within an existing database. It is included in some database management systems (DBMS), such as MySQL and PostgreSQL.
{% endhint %}

## CREATE

Creates a new database object.

* Syntax

```
CREATE [schema_name.]object_type [object_name] ([object_definition]);
```

* Example

```
CREATE TABLE Customers (
  CustomerID NUMBER PRIMARY KEY,
  CustomerName VARCHAR2(50) NOT NULL,
  Email VARCHAR2(100) UNIQUE,
  Phone VARCHAR2(20)
);
```

## ALTER

Modifies the structure of an existing database object.

* Syntax

```
ALTER [schema_name.]object_type [object_name] [alter_definition];
```

* Example

```
ALTER TABLE Customers ADD Age NUMBER;
ALTER TABLE Orders MODIFY COLUMN OrderDate DATE FORMAT 'YYYY-MM-DD';
```

## DROP&#x20;

Removes a database object from the schema.

* Syntax

```
DROP [schema_name.]object_type [object_name];
```

* Example

```
DROP TABLE Orders;
```

## TRUNCATE

Removes all rows from a table, but preserves the table structure. This is a faster alternative to DROP and then CREATE, but <mark style="background-color:red;">cannot be rolled back</mark>.

* Syntax

```
TRUNCATE TABLE [schema_name.]table_name;
```

* Example

```
TRUNCATE TABLE Orders;
```

## COMMENT

Adds a comment to a database object to provide descriptive information&#x20;

* Syntax

```
COMMENT ON [schema_name.]object_type [object_name] IS 'comment_text';
```

* Example

```
COMMENT ON TABLE Customers IS 'Stores customer information';
```

## RENAME

Renames a database object.

* Syntax

```
RENAME [schema_name.]object_type [old_name] TO [new_name];
```

* Example

```
RENAME TABLE Users TO Application_Users;
```
