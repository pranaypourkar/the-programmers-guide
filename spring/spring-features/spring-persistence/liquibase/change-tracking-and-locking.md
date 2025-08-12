# Change Tracking & Locking

## About

Liquibase automatically tracks which changes have been applied to a database and prevents conflicting or concurrent changes through its **tracking tables**. This system ensures that migrations are **safe, repeatable, and idempotent** meaning you can run the same changelog multiple times without accidentally reapplying the same changes.

## **`DATABASECHANGELOG` Table (Tracking Applied Changes)**

When Liquibase runs for the first time on a database, it creates a special table called **`DATABASECHANGELOG`**.

**Purpose**

* Acts as a historical record of every changeset that has been executed on that database.
* Allows Liquibase to determine which changes still need to be applied.

**Key columns in `DATABASECHANGELOG`**

* **`ID`** – Changeset ID (from the `id` attribute in your changelog).
* **`AUTHOR`** – Name from the `author` attribute in your changelog.
* **`FILENAME`** – Path to the changelog file containing the changeset.
* **`DATEEXECUTED`** – When the changeset was applied.
* **`ORDEREXECUTED`** – The sequence number in which it was applied.
* **`MD5SUM`** – Hash of the changeset contents, used to detect modifications.
* **`DESCRIPTION`** – Summary of the change type (e.g., “Create Table”).
* **`COMMENTS`** – Optional notes from the changeset.
* **`TAG`** – Optional version tag assigned at execution time.

**Why this matters ?**

* If you run `liquibase update` again, Liquibase compares your changelogs with the `DATABASECHANGELOG` table and **skips** any changesets already recorded there.
* This prevents duplicate changes from being applied accidentally.

## **`DATABASECHANGELOGLOCK` Table (Preventing Concurrent Execution)**

Liquibase also creates a **`DATABASECHANGELOGLOCK`** table to handle **locking**.

**Purpose**

* Ensures that only **one Liquibase instance** can apply changes to a database at any given time.
* Prevents corruption or partial application of changes when multiple processes (or team members) try to update the same DB concurrently.

**How it works ?**

1. Before running any changes, Liquibase checks the `DATABASECHANGELOGLOCK` table.
2. If the lock is free (`LOCKED = false`), Liquibase sets it to `true` and starts executing changes.
3. Once the run finishes, Liquibase releases the lock (`LOCKED = false` again).
4. If another process tries to run Liquibase while it’s locked, it will wait (or fail, depending on configuration).

**Key columns in `DATABASECHANGELOGLOCK`:**

* **`ID`** – Lock record ID (usually `1`).
* **`LOCKED`** – Boolean indicating if the DB is currently locked.
* **`LOCKGRANTED`** – Timestamp when the lock was acquired.
* **`LOCKEDBY`** – Host and process details of the locking instance.

## **Handling Modified Changesets**

Liquibase uses an **MD5 checksum** stored in `DATABASECHANGELOG` to detect if a changeset’s definition has changed after being applied.

**Scenarios**

* **Changeset unchanged** → Liquibase skips it.
* **Changeset modified** → Liquibase throws an error (`ValidationFailedException`).
* **Forcing Liquibase to accept new checksum:**
  *   Run:

      ```bash
      liquibase clearCheckSums
      ```
  * This forces Liquibase to recalculate checksums next time.

**Why this matters**

* Prevents silent changes to applied migrations (which could cause schema inconsistencies).
* Encourages immutable migration history.

## **Lock Troubleshooting**

Sometimes a Liquibase process might crash or be killed before releasing the lock. In such cases:

*   Check the lock:

    ```sql
    SELECT * FROM DATABASECHANGELOGLOCK;
    ```
*   Manually release it if needed:

    ```sql
    sqlCopyEditUPDATE DATABASECHANGELOGLOCK SET LOCKED = false, LOCKGRANTED = NULL, LOCKEDBY = NULL WHERE ID = 1;
    ```
*   Or use the Liquibase command:

    ```bash
    liquibase releaseLocks
    ```

## What is MD5SUM ?

The `MD5SUM` column in the `databasechangelog` table is used by Liquibase to track whether a changeset has been altered. It stores a hash of the changeset's content, and Liquibase checks this hash each time it runs to detect any modifications in previously applied changesets.

If we're manually inserting entries into the `databasechangelog` table and don't know the exact `MD5SUM` value, we can leave it as `NULL` or calculate it as follows:

#### Option 1: Leave `MD5SUM` as `NULL`

If we leave the `MD5SUM` column as `NULL`, Liquibase will compute the correct value and update it on the next application startup. This approach is typically safe if we are restoring from scratch.

Example:

```sql
INSERT INTO databasechangelog (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, EXECTYPE, MD5SUM)
VALUES ('1', 'our_author', 'db/changelog/db.changelog-master.xml', CURRENT_TIMESTAMP, 1, 'EXECUTED', NULL);
```

#### Option 2: Calculate MD5SUM Manually (If Necessary)

If we need an exact match for the `MD5SUM`, we can calculate the MD5 hash for each changeset. Liquibase's algorithm for MD5 is based on the raw XML content of the changeset.

For example, we could use an MD5 hash generator in our programming language to calculate the MD5 of the changeset’s XML content. Here’s a quick example in Java if we need to automate it:

```java
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class MD5Generator {
    public static void main(String[] args) throws NoSuchAlgorithmException {
        String changesetContent = "<our changeset XML content here>";
        MessageDigest md = MessageDigest.getInstance("MD5");
        byte[] hash = md.digest(changesetContent.getBytes(StandardCharsets.UTF_8));

        StringBuilder sb = new StringBuilder();
        for (byte b : hash) {
            sb.append(String.format("%02x", b));
        }
        System.out.println("MD5SUM: " + sb.toString());
    }
}
```

Insert the calculated MD5 hash into our SQL insert statement.

