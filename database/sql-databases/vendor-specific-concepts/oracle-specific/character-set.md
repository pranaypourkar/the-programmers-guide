# Character Set

## About

A **character set** in Oracle defines how textual data is represented and stored. It maps **each character** (like `A`, `ñ`, or `你`) to a **unique numeric code (code point)** and encodes it in one or more **bytes**.

In Oracle, character sets affect:

* How `CHAR`, `VARCHAR2`, `CLOB` values are stored and interpreted
* Compatibility with client applications
* Byte size of characters (which impacts storage and length limits)
* Sorting, comparison, and indexing behavior for text

## Character Sets in Oracle

Oracle supports two character sets in a database:

### 1. **Database Character Set**

* Applies to: `CHAR`, `VARCHAR2`, `LONG`, and `CLOB`
* Chosen at the time of **database creation**
* Cannot be changed easily after creation
* Defines how most string data is stored

### 2. **National Character Set**

* Applies to: `NCHAR`, `NVARCHAR2`, and `NCLOB`
* Independent of the database character set
* Used to support **Unicode multilingual data**
* Chosen from a limited set: typically `AL16UTF16` or `UTF8`&#x20;

## Common Character Sets

{% hint style="success" %}
It’s recommended to use **AL32UTF8** in modern systems because it:

* Supports all known human languages
* Is required for modern applications (APIs, web interfaces, mobile)
* Prevents data loss during multilingual input
{% endhint %}

<table data-full-width="true"><thead><tr><th>Character Set</th><th>Encoding Type</th><th width="345.9375">Description</th><th>Bytes per Character</th></tr></thead><tbody><tr><td><code>WE8MSWIN1252</code></td><td>Single-byte</td><td>Western European (Windows Latin 1)</td><td>1</td></tr><tr><td><code>AL32UTF8</code></td><td>Multibyte (UTF-8)</td><td>Modern Unicode encoding; recommended for new systems</td><td>1 to 4</td></tr><tr><td><code>UTF8</code></td><td>Obsolete UTF-8</td><td>Old Oracle UTF-8 encoding; deprecated</td><td>1 to 3</td></tr><tr><td><code>AL16UTF16</code></td><td>UTF-16</td><td>Used for national character set only</td><td>2 or 4</td></tr><tr><td><code>US7ASCII</code></td><td>Single-byte</td><td>Basic ASCII, 7-bit</td><td>1</td></tr></tbody></table>

#### Example with AL32UTF8

<table><thead><tr><th width="225.3125">Character</th><th>Bytes (AL32UTF8)</th></tr></thead><tbody><tr><td><code>A</code></td><td>1 byte</td></tr><tr><td><code>é</code></td><td>2 bytes</td></tr><tr><td><code>क</code> (Devanagari)</td><td>3 bytes</td></tr><tr><td><code>😊</code> (Emoji)</td><td>4 bytes</td></tr></tbody></table>

## Byte Semantics vs Character Semantics

Oracle allows specifying string lengths in:

* **Byte semantics** (default): Limits are measured in bytes. Risky with multibyte character sets.
* **Character semantics**: Limits are measured in characters, regardless of how many bytes each character consumes.

We can configure this via:

```sql
ALTER SESSION SET NLS_LENGTH_SEMANTICS = CHAR;
```

or at table column level:

```sql
VARCHAR2(50 CHAR)
```

## How to Check Character Set

To check the character sets of your database:

```sql
SELECT * FROM NLS_DATABASE_PARAMETERS WHERE PARAMETER IN ('NLS_CHARACTERSET', 'NLS_NCHAR_CHARACTERSET');
```

## Collation and Sorting

Character sets influence **collation**, i.e., how Oracle sorts and compares strings. For example:

* `A < Z` in ASCII
* Accented characters may be ignored or prioritized depending on collation

Oracle 12c and above support **linguistic collation** and **case-insensitive** comparisons with `NLS_SORT`, `NLS_COMP`.

## Best Practices

### 1. **Use Unicode Character Set (`AL32UTF8`) for New Databases**

#### Why:

* `AL32UTF8` (Oracle’s implementation of UTF-8) supports all known characters from every language.
* It is fully compatible with modern applications (web, APIs, mobile).
* Required for features like XML, JSON, and RESTful services in Oracle.

#### How:

Set `AL32UTF8` at the time of database creation using:

```sql
CREATE DATABASE ... CHARACTER SET AL32UTF8;
```

> Avoid the older `UTF8` character set (deprecated).

### 2. **Use `CHAR` Semantics When Working with Multibyte Characters**

#### Problem:

By default, Oracle uses **byte semantics** (e.g., `VARCHAR2(10)` = 10 bytes). If using a multibyte character set (like `AL32UTF8`), this can lead to **truncation errors** if characters consume more than one byte.

#### Solution:

Use **character semantics** to allocate space by character count, not byte size.

**Ways to enable:**

*   At the session level:

    ```sql
    ALTER SESSION SET NLS_LENGTH_SEMANTICS = CHAR;
    ```
*   At the column level:

    ```sql
    CREATE TABLE users (name VARCHAR2(100 CHAR));
    ```

### 3. **Ensure Client-Server Character Set Compatibility**

#### Problem:

When client and server use different character sets, Oracle performs implicit **character set conversion**, which can:

* Corrupt data if unsupported characters are involved
* Add CPU overhead
* Cause query failures or display issues

#### Solution:

* Set the client’s `NLS_LANG` parameter correctly to match the database character set or desired behavior.
* Use `AL32UTF8` on both client and server when possible.

Example for Windows client:

```bash
set NLS_LANG=AMERICAN_AMERICA.AL32UTF8
```

### 4. **Validate Character Set Compatibility Before Migration**

When upgrading Oracle versions or migrating databases:

* Use tools like `CSMIG`, `CSSCAN`, or `DMU` (Database Migration Assistant for Unicode) to detect and resolve incompatible data.
* Use `Data Pump` with correct `CHARACTERSET` to avoid corrupt exports/imports.

Example export command:

```bash
bashCopyEditexpdp user/password directory=dir dumpfile=export.dmp logfile=export.log
```

Example import with charset conversion:

```bash
bashCopyEditimpdp user/password directory=dir dumpfile=export.dmp logfile=import.log remap_schema=old:new
```

### 5. **Avoid Mixing Character Sets in Distributed Systems**

#### Problem:

If different databases in a distributed setup use different character sets, it can cause:

* Conversion errors in DB links
* Query failures
* Inconsistent results

#### Recommendation:

* Standardize all related databases to use `AL32UTF8`.
* Always test distributed queries across DB links for compatibility.

### 6. **Use Unicode-Aware Data Types for Multilingual Data**

For storing multilingual text (Chinese, Arabic, Japanese, etc.), prefer:

* `NCHAR`, `NVARCHAR2`, and `NCLOB` (use the national character set)
* `VARCHAR2` with Unicode database character set (`AL32UTF8`)

Avoid legacy single-byte character sets unless absolutely necessary for legacy integration.

### **7. Always Document Character Set Configurations**

For each database and environment:

* Record the values of:
  * `NLS_CHARACTERSET`
  * `NLS_NCHAR_CHARACTERSET`
  * `NLS_LANG` (client-side)
* Include this in infrastructure documentation
* Helps during troubleshooting, migrations, and audits

### **8. Test Multilingual Applications Thoroughly**

Multilingual data involves:

* Data entry
* Storage
* Retrieval
* Sorting
* Collation
* Display on UI

Make sure all components (DB, UI, middleware, APIs) are Unicode-compatible and tested for multilingual behavior.

### **9. Plan for Future Growth and Internationalization**

Even if your current application is monolingual:

* Choose `AL32UTF8` early to avoid future rework
* Supports globalization, mobile interfaces, external integrations

## Scenario

If we have a table with **one `CHAR` column** and **one `NCHAR` column**, **each column uses a different character set**, because in Oracle:

* `CHAR`, `VARCHAR2`, and `CLOB` → use the **Database Character Set**
* `NCHAR`, `NVARCHAR2`, and `NCLOB` → use the **National Character Set**

So both `AL32UTF8` and `AL16UTF16` can be involved **in the same table**, with each applying to its respective column type.

#### Which Character Set Is Used?

| Column Type | Character Set Used         | Where It's Defined                        |
| ----------- | -------------------------- | ----------------------------------------- |
| `CHAR`      | **Database Character Set** | Example: `AL32UTF8`, `WE8MSWIN1252`, etc. |
| `NCHAR`     | **National Character Set** | Usually `AL16UTF16` or `UTF8`             |

You can check your settings with:

```sql
SELECT parameter, value FROM NLS_DATABASE_PARAMETERS
WHERE parameter IN ('NLS_CHARACTERSET', 'NLS_NCHAR_CHARACTERSET');
```

#### Should we use AL16UTF16 or AL32UTF8?

Here’s what Oracle recommends:

<table><thead><tr><th width="230.7578125">Setting</th><th width="180.83984375">Recommended Value</th><th>Reason</th></tr></thead><tbody><tr><td><code>NLS_CHARACTERSET</code></td><td><code>AL32UTF8</code></td><td>Unicode for database-wide multilingual support</td></tr><tr><td><code>NLS_NCHAR_CHARACTERSET</code></td><td><code>AL16UTF16</code></td><td>Default for national character set; optimized for <code>NCHAR</code></td></tr></tbody></table>

So:

* We **should** use `AL32UTF8` for database character set (applies to `CHAR`, `VARCHAR2`)
* We **should** use `AL16UTF16` for national character set (applies to `NCHAR`, `NVARCHAR2`)

These two are designed to work together efficiently and safely.

Let’s say:

```sql
CREATE TABLE example (
  name CHAR(50),
  description NCHAR(100)
);
```

* The `name` column uses `AL32UTF8` encoding (1–4 bytes per character)
* The `description` column uses `AL16UTF16` encoding (2 or 4 bytes per character)

Oracle will **store and manage both encodings internally**, and automatically handle them based on the column type.
