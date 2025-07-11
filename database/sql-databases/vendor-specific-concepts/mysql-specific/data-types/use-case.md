# Use Case

## UUID

A `BINARY(16)` column in MySQL stores **16 bytes** of binary data, typically used to store **UUIDs** in binary form (instead of as strings like `'550e8400-e29b-41d4-a716-446655440000'`), which saves space and improves performance.

{% hint style="info" %}
In **MySQL**, when we store UUIDs using `BINARY(16)` and insert them using `UNHEX()`, tools like **MySQL Workbench** will display them as `BLOB` (binary) because:

* MySQL Workbench **doesn’t interpret the binary data as a UUID string**.
* `BINARY(16)` is the correct and efficient way to store UUIDs in MySQL for performance, but the raw binary format isn’t human-readable.
{% endhint %}

Here are **some example `BINARY(16)` values**, shown in **hex format** (what we'll see if we run `HEX(column)`):

| Binary Value (Hex)                 | Notes                        |
| ---------------------------------- | ---------------------------- |
| `550E8400E29B41D4A716446655440000` | A UUID stored as binary      |
| `00000000000000000000000000000001` | Just 16 bytes ending in `01` |
| `FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF` | All bits set to 1            |
| `AABBCCDDEEFF00112233445566778899` | Random sample                |
| `0102030405060708090A0B0C0D0E0F10` | Sequential bytes             |

#### How to Insert into a `BINARY(16)` Column

```sql
CREATE TABLE sample_binary (
    id BINARY(16)
);
```

**1. Using `UNHEX()` with a hex string:**

```sql
INSERT INTO sample_binary (id) VALUES (UNHEX('550E8400E29B41D4A716446655440000'));
```

**2. Using a UUID directly:**

```sql
-- Convert UUID to binary and insert
INSERT INTO sample_binary (id) VALUES (UNHEX(REPLACE('550e8400-e29b-41d4-a716-446655440000', '-', '')));
```

#### Syntax for `WHERE` with hex value

```sql
SELECT *
FROM segment.content
WHERE uuid = UNHEX('0190DE6CBB1674B880C5F0A552BEA151');
```

#### Reading from a `BINARY(16)` Column

Using Concatenation

To **read** and **convert back to UUID format**:

```sql

SELECT
  LOWER(CONCAT_WS('-',
    HEX(SUBSTRING(id, 1, 4)),
    HEX(SUBSTRING(id, 5, 2)),
    HEX(SUBSTRING(id, 7, 2)),
    HEX(SUBSTRING(id, 9, 2)),
    HEX(SUBSTRING(id, 11))
  )) AS uuid_string
FROM sample_binary;
```

Using `BIN_TO_UUID()` (MySQL 8.0.13+ only):

```sql
SELECT BIN_TO_UUID(uuid) AS readable_uuid FROM segment.content;
```

Output:`0190de6c-bb16-74b8-80c5-f0a552bea151`(properly formatted UUID)

#### Why Use `BINARY(16)` for UUIDs?

| Format       | Storage | Index Size | Readability | Best For           |
| ------------ | ------- | ---------- | ----------- | ------------------ |
| `CHAR(36)`   | 36 B    | 36 B       | Readable    | Simplicity         |
| `BINARY(16)` | 16 B    | 16 B       | Binary      | Performance, Index |

Use `BINARY(16)` for performance; use `CHAR(36)` only if readability in the DB itself is critical.

