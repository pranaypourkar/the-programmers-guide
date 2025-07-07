---
hidden: true
---

# Liquibase



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
