# Large Object Types

## About

**Large Object (LOB) types** are used to store large volumes of data such as lengthy text, images, audio, video, or documents. LOBs are stored separately from regular row data, allowing efficient handling of very large data.

LOBs are divided into two broad categories:

* **Character LOBs (CLOBs)** – for large text
* **Binary LOBs (BLOBs)** – for binary data

## 1. **BLOB (Binary Large Object)**

* Stores binary data such as images, audio, video, PDFs, or any other unstructured binary content.
* Does **not support character encoding**.
* Cannot be searched or manipulated directly using text operations.

**Example use:** Store a JPEG image file.

## 2. **CLOB (Character Large Object)**

* Stores large amounts of character/text data.
* Supports **character encoding** (like UTF-8).
* Used when text content exceeds typical `VARCHAR` limits.

**Example use:** Store a full HTML document or a long article.

## 3. **NCLOB (National Character Large Object)**

* Same as `CLOB`, but stores **Unicode character data** (national character set).
* Useful for multilingual applications.

## Vendor Support Overview

<table data-header-hidden data-full-width="true"><thead><tr><th width="117.44921875"></th><th width="102.03125"></th><th width="101.734375"></th><th width="85.51953125"></th><th></th></tr></thead><tbody><tr><td>Database</td><td><code>BLOB</code></td><td><code>CLOB</code></td><td><code>NCLOB</code></td><td>Notes</td></tr><tr><td><strong>Oracle</strong></td><td>Yes</td><td>Yes</td><td>Yes</td><td>Full LOB and external file support</td></tr><tr><td><strong>MySQL</strong></td><td>Yes</td><td>Yes</td><td>No</td><td>Uses <code>TINYTEXT</code>, <code>TEXT</code>, <code>MEDIUMTEXT</code>, <code>LONGTEXT</code> instead of <code>CLOB</code></td></tr><tr><td><strong>PostgreSQL</strong></td><td>Yes</td><td>Yes</td><td>No</td><td>Uses <code>TEXT</code> for large text; <code>BYTEA</code> as alternative to <code>BLOB</code></td></tr><tr><td><strong>SQL Server</strong></td><td>Yes</td><td>Yes (<code>VARCHAR(MAX)</code>)</td><td>No</td><td><code>TEXT</code>, <code>NTEXT</code>, <code>IMAGE</code> deprecated; use <code>VARBINARY(MAX)</code>, <code>VARCHAR(MAX)</code></td></tr><tr><td><strong>SQLite</strong></td><td>Yes</td><td>Yes</td><td>No</td><td>Very flexible typing; no strict separation</td></tr></tbody></table>
