# BLOB

## About

**BLOB (Binary Large Object)** is a **data type** in Oracle used to store **large, unstructured binary data**. Some of the examples include Images, PDFs, audio/video files, Word documents, Excel files, ZIP archives, etc.

BLOBs store **raw bytes**, meaning the content is **not human-readable** and can't be viewed as plain text. In Oracle, a BLOB can store up to **4 GB** of binary data.

## **BasicFiles vs SecureFiles**

Oracle supports two main storage formats for LOBs:

<table data-header-hidden data-full-width="true"><thead><tr><th width="147.6180419921875"></th><th width="254.150146484375"></th><th></th></tr></thead><tbody><tr><td>Feature</td><td><strong>BasicFiles (legacy)</strong></td><td><strong>SecureFiles (modern, default in 11g+)</strong></td></tr><tr><td>Compression</td><td>No</td><td>Yes (deduplication &#x26; compression)</td></tr><tr><td>Encryption</td><td>No</td><td>Yes (Transparent Data Encryption - TDE)</td></tr><tr><td>Performance</td><td>Slower, traditional architecture</td><td>Faster, optimized LOB management</td></tr><tr><td>Deduplication</td><td>No</td><td>Yes – identical LOBs stored once</td></tr><tr><td>Default Mode</td><td>Until Oracle 11g</td><td>From Oracle 11g onwards</td></tr></tbody></table>

### **Enabling SecureFiles**

By default, Oracle 11g+ creates SecureFiles if:

* Tablespace is locally managed
* Segment space management is automatic

To **force SecureFiles** explicitly:

```sql
CREATE TABLE content_data (
  id NUMBER PRIMARY KEY,
  content BLOB
) LOB (content) STORE AS SECUREFILE;
```

### **LOB Storage Clauses**

We can customize **LOB storage behavior**:

```sql
CREATE TABLE content_data (
    id NUMBER,
    content BLOB
)
LOB (content) STORE AS SECUREFILE (
    TABLESPACE users
    ENABLE STORAGE IN ROW
    CHUNK 8192
    RETENTION AUTO
    CACHE READS
    NOCOMPRESS
    KEEP_DUPLICATES
);
```

<table><thead><tr><th width="235.2196044921875">Clause</th><th>Description</th></tr></thead><tbody><tr><td><code>ENABLE STORAGE IN ROW</code></td><td>Stores small LOBs (default up to 4K) inline with the row for performance</td></tr><tr><td><code>DISABLE STORAGE IN ROW</code></td><td>Always store out-of-line, regardless of size</td></tr><tr><td><code>CHUNK</code></td><td>Defines I/O block size for LOBs (default 8192 bytes)</td></tr><tr><td><code>CACHE READS</code></td><td>Enables caching of LOB data in buffer cache</td></tr><tr><td><code>RETENTION AUTO</code></td><td>For temporary LOBs – retains for session duration</td></tr><tr><td><code>NOCOMPRESS / COMPRESS</code></td><td>Compression control for SecureFiles</td></tr><tr><td><code>KEEP_DUPLICATES</code></td><td>Retains duplicate LOBs (default)</td></tr><tr><td><code>DEDUPLICATE</code></td><td>Stores only one copy of identical LOBs (SecureFiles only)</td></tr></tbody></table>



## Example

Assume we have the following table:

```sql
CREATE TABLE content_data (
    id NUMBER PRIMARY KEY,
    content BLOB
);
```

This table stores a binary object in the `content` column, such as a file or document, linked to a unique `id`.

#### **1. Insert a Row with Empty BLOB**

We can't directly insert binary data using plain SQL. Instead, insert an empty BLOB placeholder and update it using tools or PL/SQL:

```sql
INSERT INTO content_data (id, content) VALUES (1, EMPTY_BLOB());
```

#### **2. Delete a BLOB Row**

```sql
DELETE FROM content_data WHERE id = 1;
```

#### **3. Check BLOB Length**

```sql
SELECT id, DBMS_LOB.getlength(content) AS content_size
FROM content_data;
```

#### **4. Insert Actual File via SQL Developer**

Steps:

a. Go to `Tools → Preferences → Database → Advanced` → Ensure “Use OCI/Thick driver” is enabled for BLOB support (optional but recommended).

b. Run:

```sql
SELECT * FROM content_data;
```

c. In the results grid:

* Click on the `(BLOB)` cell under `content`.
* Click the small pencil/edit icon.
* In the BLOB editor, click `Load...`.
* Select a file from our filesystem (e.g., PDF, image, etc.).
* Click `OK` to save.

d. Commit the transaction (Ctrl + Enter or click Commit button).

#### **5. Retrieve & View a File**

From SQL Developer:

* Query the table:

```sql
SELECT * FROM content_data WHERE id = 1;
```

* In the `content` column (shows `[BLOB]`), click the pencil icon.
* Click `Save As...` to export the file from the database to our local disk.
* Open the file using an appropriate viewer (e.g., Adobe Reader, image viewer).

<figure><img src="../../../../../.gitbook/assets/oracle-blob-1.png" alt="" width="308"><figcaption></figcaption></figure>

<figure><img src="../../../../../.gitbook/assets/oracle-blob-2.png" alt="" width="375"><figcaption></figcaption></figure>

<figure><img src="../../../../../.gitbook/assets/oracle-blob-3 (1).png" alt="" width="375"><figcaption></figcaption></figure>

#### **6. Update the File in a BLOB**

Same steps as insertion:

1. Query the row in SQL Developer.
2. Click the `content` cell.
3. Click the pencil icon.
4. Choose `Load...` and select a new file.
5. Click `OK`, then `Commit`.



## **Performance Considerations**

Efficient use of BLOBs is critical for maintaining application performance and reducing resource overhead. Since BLOBs can store very large data (up to 4 GB), careless use can lead to **I/O bottlenecks**, **memory pressure**, and **slow query performance**.

**a. Minimize Unnecessary BLOB Access**

Avoid fetching BLOBs unless we explicitly need them. For example:

```sql
-- Bad: Fetches entire BLOB even if we only need ID
SELECT * FROM content_data WHERE id = 1;

-- Good: Fetch only what we need
SELECT id FROM content_data WHERE id = 1;
```

Even though we don’t see the BLOB in the output, the database engine may still read LOB metadata or blocks depending on how the query is constructed and the client behaves (especially in GUI tools).

**b. Use `DEFERRED` LOB Reading (Client-Side Streaming)**

In application development (e.g., Java, Python, C#), use **LOB locators** and stream data instead of reading the whole BLOB into memory.

In JDBC:

```java
InputStream in = resultSet.getBlob("content").getBinaryStream();
```

This ensures the BLOB is read in chunks and not loaded entirely into memory, which is crucial for large files.

**c. Avoid Frequent Updates on BLOB Columns**

Every update to a BLOB can cause Oracle to:

* Create a new version of the LOB (especially with SecureFiles)
* Update the LOB index
* Generate redo/undo information

Instead of frequent updates:

* Use temporary LOBs (`DBMS_LOB.CREATETEMPORARY`)
* Or split metadata and binary data so we only update metadata when possible

**d. Separate Metadata and BLOBs**

Design tables to store file metadata (name, MIME type, size) separately from the BLOB, so most queries don’t touch the BLOB unless required.

```sql
CREATE TABLE file_metadata (
    id NUMBER PRIMARY KEY,
    file_name VARCHAR2(255),
    mime_type VARCHAR2(100),
    file_size NUMBER,
    content BLOB
);
```

Queries that only filter or search by name or size avoid reading the BLOB column.

**e. Use `ENABLE STORAGE IN ROW` Carefully**

* If our BLOBs are typically small (e.g., < 4KB), `ENABLE STORAGE IN ROW` can improve performance since the BLOB is stored directly in the table block.
* For larger BLOBs, use `DISABLE STORAGE IN ROW` to avoid row chaining and block-level I/O inefficiency.

**f. Choose Optimal `CHUNK` Size**

LOB data is read/written in **chunks**, which are the I/O units for LOBs. Larger chunks:

* Reduce the number of read/write operations
* Increase throughput (especially for SecureFiles)

Use a power-of-two value like `8192` or `16384` for `CHUNK`.

**g. Tune Caching for LOBs**

By default, BLOBs are **not cached** in the buffer cache. We can enable it with:

```sql
CACHE READS
```

This is beneficial if:

* BLOBs are frequently read
* They are not too large (to avoid cache pollution)

Otherwise, use:

```sql
NOCACHE
```

to avoid caching large, rarely-used BLOBs.

**h. Deduplication and Compression**

If we're storing many similar or identical BLOBs (e.g., templates or logos):

* Use **SecureFiles with DEDUPLICATE** to reduce storage
* Enable **COMPRESSION** to save space, especially on slow disk environments

```sql
LOB (content) STORE AS SECUREFILE (
  DEDUPLICATE
  COMPRESS HIGH
);
```

This improves space efficiency with minimal performance cost.

**i. Avoid Full Table Scans When Querying by Metadata**

If users are querying by `file_name`, `mime_type`, etc., make sure these columns are indexed so that BLOBs aren’t unnecessarily accessed during table scans.

**j. Use PL/SQL Efficiently**

In PL/SQL, prefer:

* Using `DBMS_LOB.OPEN` and `DBMS_LOB.READ` to read large BLOBs in chunks
* Avoid using `DBMS_LOB.SUBSTR()` to retrieve large segments; it's inefficient and returns RAW, not binary files
