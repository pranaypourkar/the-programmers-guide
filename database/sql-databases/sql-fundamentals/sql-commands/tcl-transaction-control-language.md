# TCL (Transaction Control Language)

TCL (Transaction Control Language) commands are used to manage transactions, which are a series of database operations treated as a single unit. These commands ensure data integrity by controlling how changes are committed or rolled back.

## COMMIT

Makes all changes performed within a transaction permanent. This saves the changes to the database.

* Syntax

```
COMMIT;
```

* Example

```
-- Insert data into two tables within a transaction
BEGIN
  INSERT INTO Orders (OrderID, CustomerID, OrderDate) VALUES (2023051401, 1001, SYSDATE);
  INSERT INTO OrderItems (OrderID, ProductID, Quantity) VALUES (2023051401, 1234, 2);
  COMMIT;
END;
```

## ROLLBACK

Undoes all changes made within a transaction, reverting the database to its state before the transaction began.

* Syntax

```
ROLLBACK;
```

* Example

```
BEGIN
  INSERT INTO Orders (OrderID, CustomerID, OrderDate) VALUES (2023051402, 1002, SYSDATE);
  INSERT INTO OrderItems (OrderID, ProductID, Quantity) VALUES (2023051402, 5678, 10);
  ROLLBACK;
END;
```

{% hint style="info" %}
In Oracle and most relational database systems, transactions do function as atomic units. This means all changes within a transaction are treated as a single entity. If any statement within the transaction fails due to an exception, the entire transaction automatically rolls back, undoing all the changes attempted within that transaction block.
{% endhint %}

## SAVEPOINT

Creates a named point within a transaction. We can optionally roll back to a specific savepoint instead of the entire transaction.

* Syntax

```
SAVEPOINT savepoint_name;
```

* Example

```
-- Start a transaction
BEGIN
  -- Update first_name for employee with ID 1001
  UPDATE employees SET first_name = 'John' WHERE employee_id = 1001;

  -- Create a savepoint
  SAVEPOINT before_update_1002;

  -- Update first_name for employee with ID 1002
  UPDATE employees SET first_name = 'Jane' WHERE employee_id = 1002;

  -- Commit the transaction
  COMMIT;
EXCEPTION
  -- Handle exceptions
  WHEN OTHERS THEN
    -- Rollback to savepoint if an error occurs
    ROLLBACK TO before_update_1002;
    -- Handle the error (print error message, log, etc.)
    DBMS_OUTPUT.PUT_LINE('An error occurred. Rolling back to savepoint.');
END;
```

## SET TRANSACTION

Defines isolation level and other transaction characteristics. Used for advanced control over transaction behavior.

* Syntax

```
SET TRANSACTION [isolation_level] [other_parameters];
```

* Example

```
-- Setting transaction isolation level to READ COMMITTED
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
```



