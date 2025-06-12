# DCL (Data Control Language)

DCL (Data Control Language) commands are used to manage access privileges for users and database objects. These commands allows to grant specific permissions to users or roles, enabling them to interact with the database in controlled ways.

## GRANT

Assigns specific privileges (e.g., SELECT, INSERT, UPDATE, DELETE) on a table, schema object, or system privilege to a user or role.

* Syntax

```
GRANT privilege_type[(column_list)] ON [schema_name.]object_type [object_name] TO user_name [role_name];
```

* Example

```
GRANT SELECT, INSERT ON Customers TO Sales_User;

-- Granting all privileges on the Orders table to the Manager role
GRANT ALL ON Orders TO Manager;

-- Granting CREATE SESSION system privilege to a new user
GRANT CREATE SESSION TO New_User;
```

## REVOKE

Takes away previously granted privileges from a user or role.

* Syntax

```
REVOKE privilege_type[(column_list)] ON [schema_name.]object_type [object_name] FROM user_name [role_name];
```

* Example

<pre><code>-- Revokes delete permission
<strong>REVOKE DELETE ON Orders FROM Marketing_User;  
</strong>-- Revoking all privileges on the Customers table from the Guest role
REVOKE ALL ON Customers FROM Guest;
</code></pre>
