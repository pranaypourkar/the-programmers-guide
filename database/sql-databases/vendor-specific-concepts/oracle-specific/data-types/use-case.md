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



