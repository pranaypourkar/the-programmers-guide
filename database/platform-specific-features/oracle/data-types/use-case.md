# Use Case

## About

This section serves as a practical guide for choosing the **right Oracle data types based on real-world use cases**. While Oracle provides a rich set of data types, choosing the correct one is essential for:

* Ensuring **data integrity**
* Optimizing **storage and performance**
* Improving **interoperability** with APIs, services, and other systems
* Supporting **future scalability**

The goal of this page is to help make **informed decisions** when modeling database schemas by mapping **common business requirements** to the most appropriate Oracle data types.

## 1. UUID

Store a Java `UUID` (e.g., `550e8400-e29b-41d4-a716-446655440000`) in an Oracle database.

{% hint style="success" %}
In Java, a **UUID (Universally Unique Identifier)** is a **128-bit value** used to uniquely identify objects across space and time, without requiring a central authority.

* It is defined in the class `java.util.UUID`.
* Commonly used for database primary keys, distributed systems, and identifiers that must be globally unique.
*   Typically represented as a 36-character string (including hyphens), e.g.:

    ```
    UUID uuid = UUID.randomUUID();// 550e8400-e29b-41d4-a716-446655440000
    ```
{% endhint %}

Oracle Data Type Suggestion

<table data-full-width="true"><thead><tr><th width="140.07122802734375">Oracle Data Type</th><th width="132.14154052734375">Size</th><th width="121.62579345703125">Readability</th><th width="172.993896484375">Index Performance</th><th>Recommended for UUID?</th><th>Notes</th></tr></thead><tbody><tr><td><code>RAW(16)</code></td><td>16 bytes</td><td>No</td><td>Fast</td><td>Yes</td><td>Stores UUID as binary. Compact and efficient.</td></tr><tr><td><code>CHAR(36)</code></td><td>36 bytes</td><td>Yes</td><td>Moderate</td><td>Not preferred</td><td>Stores UUID as a string with hyphens. Wastes space.</td></tr><tr><td><code>VARCHAR2(36)</code></td><td>~38–40 bytes</td><td>Yes</td><td>Moderate</td><td>Not preferred</td><td>Slightly more flexible, but still inefficient.</td></tr><tr><td><code>CLOB</code></td><td>Large</td><td>Yes</td><td>Poor</td><td>No</td><td>Overkill for UUIDs. Used for large text data.</td></tr><tr><td><code>NUMBER</code></td><td>Varies</td><td>No</td><td>Complicated</td><td>No</td><td>UUIDs are not numeric. Avoid.</td></tr></tbody></table>

{% hint style="info" %}
**Why `RAW(16)` but not `VARCHAR2(16)`?**

* A UUID is **128 bits** = **16 bytes**.
* `RAW(16)` is designed to store exactly **16 bytes of binary data**, which matches the size of a UUID in binary form.
* `VARCHAR2(16)` stores **character data**, not binary. If we try to store a UUID as a string in `VARCHAR2(16)`, it won’t fit — the standard UUID string (without hyphens) is 32 characters long.
* Even if we encode the UUID to Base16 or hexadecimal, it will require **32 characters**, so `VARCHAR2(16)` is too short.



#### Why `VARCHAR2(32)` but not `VARCHAR2(16)`?

* If we choose to store the UUID as a **hex string** (e.g., `"550e8400e29b41d4a716446655440000"`), it requires exactly **32 characters**.
* `VARCHAR2(32)` is the minimum needed to store that format.
* `VARCHAR2(16)` can only hold 16 characters, which is insufficient to hold the entire UUID string (even without hyphens).

**Suggestion**

* Use `RAW(16)` if we're storing the UUID in its **binary form** — it's compact and efficient.
* Use `VARCHAR2(32)` if we need a **human-readable string** version (without hyphens).
* `VARCHAR2(16)` is not suitable for storing full UUIDs in any forma
{% endhint %}

## 2. Tracking Record Creation Timestamps

### 2.1 Using `NUMBER(38,0)`

In our Oracle tables, some columns such as `CREATED_DATE_TIME` store date/time information using the `NUMBER(38,0)` data type. These numeric values represent the **Unix epoch timestamp in seconds** — the number of seconds that have elapsed since `1970-01-01T00:00:00Z` (UTC).

{% hint style="success" %}
Why `'19700101'`?

*   It's the **epoch** for **Unix time**, meaning:

    > **Unix timestamp `0` = 1970-01-01 00:00:00 UTC**
* Every Unix timestamp is a **count of seconds** since this date.\
  For example:
  * `0` → `1970-01-01 00:00:00`
  * `1679130362` → `2023-03-18 07:06:02`
{% endhint %}

#### **What is `NUMBER(38,0)` in Oracle?**

* It is a numeric column that allows up to **38 digits** with **no decimal precision**.
* Essentially, it behaves like a **very large integer**.
* It is often used to store:
  * Timestamps in epoch format (Unix time)
  * Millisecond timestamps
  * Unique identifiers
  * Time-based sortable values

#### **Sample Value: `1679130362`**

To interpret it, let's break it down.

**Interpretation:**

This is likely a **Unix timestamp** in **seconds since epoch** (i.e., since `1970-01-01T00:00:00Z`).

We can verify and convert it:

*   **Online Conversion**:

    ```
    1679130362 seconds since epoch ≈ 2023-03-18 09:46:02 UTC
    ```
*   **In Java**:

    ```java
    long timestamp = 1679130362L;
    Instant instant = Instant.ofEpochSecond(timestamp);
    ZonedDateTime dateTime = instant.atZone(ZoneId.of("UTC"));
    System.out.println(dateTime);
    // Output: 2023-03-18T09:46:02Z
    ```

So, this number represents the creation time as a **UTC timestamp** in **seconds**, not milliseconds.

#### **How Java Stores This Value**

When storing from Java to Oracle:

```java
long unixSeconds = Instant.now().getEpochSecond(); // Example: 1679130362
preparedStatement.setLong(1, unixSeconds);
```

This stores the Unix timestamp as a `NUMBER(38,0)`.

To read from the database:

```java
long createdDateTime = resultSet.getLong("CREATED_DATE_TIME");
Instant instant = Instant.ofEpochSecond(createdDateTime);
ZonedDateTime zdt = instant.atZone(ZoneId.systemDefault());
```

If you’re using Spring JPA:

```java
@Column(name = "CREATED_DATE_TIME")
private Long createdDateTime;

public LocalDateTime getCreatedDateTimeAsDate() {
    return Instant.ofEpochSecond(createdDateTime)
                  .atZone(ZoneId.systemDefault())
                  .toLocalDateTime();
}
```

In **Oracle**, if we have a value like `'1679130362'` (a Unix timestamp in **seconds since 1970-01-01**), we can convert it to a human-readable date using:

```sql
SELECT
  TO_DATE('19700101','YYYYMMDD') + NUMTODSINTERVAL(1679130362, 'SECOND') AS readable_date
FROM dual;
```

To filter records where the **converted `created_date_time`** is **after 1st December 2024**, we'll need to compare the converted timestamp to a proper Oracle `DATE`.

```sql
SELECT
  TO_CHAR(
    TO_DATE('19700101','YYYYMMDD') + NUMTODSINTERVAL(TO_NUMBER(created_date_time), 'SECOND'),
    'YYYY-MM-DD HH24:MI:SS'
  ) AS readable_date,
  model
FROM device
WHERE
  TO_DATE('19700101','YYYYMMDD') + NUMTODSINTERVAL(TO_NUMBER(created_date_time), 'SECOND') > TO_DATE('2024-12-01', 'YYYY-MM-DD')
ORDER BY readable_date DESC;
```

