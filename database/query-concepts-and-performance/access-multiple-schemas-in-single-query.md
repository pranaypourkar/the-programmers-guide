# Access Multiple Schemas in Single Query

## About

In SQL, a **schema** is a logical namespace within a database that contains tables, views, procedures, etc. There are scenarios where we need to **query across multiple schemas**—either within the **same database** or **across different databases**.

{% hint style="info" %}
A **schema** is a logical container in a database that holds related objects like tables, views, and procedures, helping organize and manage them separately from other objects.

In some databases, **schema and user can be the same -** it depends on the database system.

#### In Oracle:

* A **schema is tightly linked to a user**.
* When we create a user, a schema with the same name is created automatically.
* So: **User = Schema** (in most practical terms).

#### In PostgreSQL:

* A **user** is an account that logs in.
* A **schema** is a namespace to organize objects.
* A user can **own multiple schemas**, and schemas can exist independently of users.

#### In MySQL:

* The term **schema is often used interchangeably with database**.
* So here, schema ≠ user.
{% endhint %}

## How to check if 2 schema are in same database ?

To check if **two schemas are in the same database**, we need to understand how our **RDBMS defines a "database" and a "schema"**, as this varies between systems.

If we can reference both `schema1.table` and `schema2.table` **in a single query without using a database link, foreign wrapper, or database name prefix**, they are most likely in the **same database**.

### Oracle

* Oracle treats a **user = schema**.
* All schemas live under the same **database (SID)**.

#### How to check:

1. **Run this query to see available schemas:**

```sql
SELECT username FROM all_users;
```

If we can access both schemas with one user session, they are in the same database.

2.  #### Connect as both users and run

    ```sql
    SELECT global_name FROM global_name;
    ```

    Compare the result — same value → same database.
3.  #### Run this from both users

    ```sql
    SELECT name, dbid FROM v$database;
    ```

    If both return the same values → same database.

### MySQL

* MySQL uses the term **schema = database**.
* So two “schemas” are actually two separate **databases**.

#### How to check:

```sql
SHOW DATABASES;
```

Then:

```sql
SHOW TABLES FROM schema1;
SHOW TABLES FROM schema2;
```

If `schema1` ≠ `schema2`, they are separate databases.

## Case 1: Accessing Multiple Schemas in the **Same Database**

#### Scenario

We have two schemas:

* `hr_schema` (contains `employees` table)
* `finance_schema` (contains `salaries` table)

We are logged in as user `hr_schema` and want to join `hr_schema.employees` with `finance_schema.salaries`.

#### Problem

By default, `hr_schema` **cannot access** tables in `finance_schema`.

#### Step-by-Step Setup

**1. Connect as `finance_schema` and grant privileges:**

```sql
GRANT SELECT ON salaries TO hr_schema;
```

This gives `hr_schema` permission to read from `finance_schema.salaries`.

**2. Connect as `hr_schema` and run the query:**

```sql
SELECT 
    e.employee_id,
    e.name,
    f.salary
FROM 
    employees e
JOIN 
    finance_schema.salaries f
ON 
    e.employee_id = f.employee_id;
```

#### Notes

* We can access the other schema's table directly using `schema_name.table_name`.
* We only need `SELECT` privilege to read. For other operations like `INSERT`, `UPDATE`, or `DELETE`, grant the respective permissions.

## Case 2: Accessing a Schema in a **Different Database** (Using DB Link)

#### Scenario

* `hr_schema` is in database `HRDB`.
* `finance_schema` is in database `FINDB`.
* We are logged in as `hr_schema` and want to access `finance_schema.salaries` which is in another Oracle database.

#### Problem

We cannot directly query across databases unless a **database link** is set up and permissions are granted.

#### Step-by-Step Setup

**1. Ensure tnsnames.ora or Oracle Net connectivity is configured**

Make sure `FINDB` is defined in our `tnsnames.ora` or our connection string points to the target database.

**2. Create a database link in HRDB (as `hr_schema`)**

```sql
CREATE DATABASE LINK finance_link
CONNECT TO finance_schema IDENTIFIED BY our_password
USING 'FINDB';
```

* `finance_link` is the name of the DB link.
* `'FINDB'` is the Oracle Net service name pointing to the FINDB instance.

**3. Grant required privileges in FINDB**

Connect to `finance_schema` in `FINDB` and run:

```sql
GRANT SELECT ON salaries TO hr_schema@HRDB;
```

Alternatively, to make it more generic:

```sql
GRANT SELECT ON salaries TO PUBLIC;
```

**4. Access the remote table via the link**

Back in `HRDB`, run:

```sql
SELECT 
    e.employee_id,
    e.name,
    f.salary
FROM 
    employees e
JOIN 
    salaries@finance_link f
ON 
    e.employee_id = f.employee_id;
```

#### Notes

* Always use `table_name@db_link_name` to reference a remote object.
* We can create **public** or **private** database links:
  * **Private**: Available only to the user who created it.
  * **Public**: Available to all users (requires DBA privilege).
