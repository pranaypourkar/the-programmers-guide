# Use Case

## Scenario 1

We had around 10 Liquibase change log entries in the `databasechangelog` table. Unfortunately, the table was accidentally deleted, and now our Spring Boot service fails to start due to a Liquibase error.

When the `databasechangelog` table is deleted, Liquibase loses track of which changesets have already been applied. Without this history, Liquibase attempts to reapply all changesets, which can cause conflicts and prevent your Spring Boot application from starting.

Here's a step-by-step approach to resolve this issue:

#### 1. **Recreate the `databasechangelog` Table Manually**

*   If we have access to the original `databasechangelog` structure, recreate the table. Here is a simplified SQL script to recreate the basic `databasechangelog` table (adjust column types as necessary for our database):

    ```sql
    CREATE TABLE databasechangelog (
        ID VARCHAR(255) NOT NULL,
        AUTHOR VARCHAR(255) NOT NULL,
        FILENAME VARCHAR(255) NOT NULL,
        DATEEXECUTED TIMESTAMP NOT NULL,
        ORDEREXECUTED INT NOT NULL,
        EXECTYPE VARCHAR(10) NOT NULL,
        MD5SUM VARCHAR(35) NULL,
        DESCRIPTION VARCHAR(255) NULL,
        COMMENTS VARCHAR(255) NULL,
        TAG VARCHAR(255) NULL,
        LIQUIBASE VARCHAR(20) NULL,
        CONTEXTS VARCHAR(255) NULL,
        LABELS VARCHAR(255) NULL,
        DEPLOYMENT_ID VARCHAR(10) NULL,
        PRIMARY KEY (ID, AUTHOR, FILENAME)
    );
    ```

#### 2. **Insert Entries for Already Applied Changesets**

*   If we know which changesets had already been applied (for example, from previous logs or backups), insert entries into the recreated `databasechangelog` table for each of those changesets. Here’s an example SQL insert statement:

    ```sql
    INSERT INTO databasechangelog (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, EXECTYPE)
    VALUES ('1', 'your_author', 'db/changelog/db.changelog-master.xml', CURRENT_TIMESTAMP, 1, 'EXECUTED');
    ```

    * Adjust `ID`, `AUTHOR`, `FILENAME`, and `ORDEREXECUTED` values as per your changesets.

#### 3. **Re-run Liquibase to Verify State**

* After recreating the `databasechangelog` table and adding entries for applied changes, restart your Spring Boot application. Liquibase should recognize the changesets as "executed" and not attempt to reapply them.

#### 4. **Use `liquibase validate` (Optional)**

* To ensure the changelog integrity, you can run the `liquibase validate` command to check for any discrepancies in the changelog files.
