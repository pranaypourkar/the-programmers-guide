---
hidden: true
---

# Data Types

## About

Oracle provides a rich set of data types that extend beyond the standard SQL types to support advanced features and performance optimizations.

In Oracle Database, **data types** define the kind of values a column, variable, or expression can hold. Every data element in Oracle must be declared with an appropriate type that governs:

* The format and size of stored data
* The set of valid operations
* The amount of space allocated in memory or disk
* Compatibility with other types during operations like joins or comparisons

Oracle offers both **standard scalar types** (such as numbers, text, and dates) and **advanced or abstract types** (LOBs, XML, objects).

These types are broadly grouped into categories, each optimized for a specific domain of data representation.

## 1. Character (Text) Data Types

### Description

Character types are used to store text in either fixed or variable length. Oracle supports both **single-byte character sets** (like ASCII) and **multi-byte Unicode character sets**.

* **Character semantics vs byte semantics**: Length can be interpreted in number of characters or number of bytes.
* **Padding behavior**: Fixed-length types are padded with spaces to meet their defined size.
* **Encoding awareness**: `NCHAR`, `NVARCHAR2`, and `NCLOB` are designed for internationalization.

{% hint style="info" %}
`VARCHAR` is reserved for possible future standardization and should be avoided in production schemas.

For Unicode support, Oracle recommends using `AL32UTF8` character set with `NCHAR`/`NVARCHAR2`&#x20;
{% endhint %}

### Types

<table data-full-width="true"><thead><tr><th width="143.1875">Data Type</th><th>Description</th><th>Key Characteristics</th><th>Example Value</th></tr></thead><tbody><tr><td><code>CHAR(n)</code></td><td>Fixed-length character string, space-padded to length <code>n</code></td><td>- Always stores <code>n</code> bytes<br>- Padded with spaces if shorter</td><td><code>'Y'</code> is stored as <code>'Y '</code> in case CHAR(2)</td></tr><tr><td><code>VARCHAR2(n)</code></td><td>Variable-length character string up to <code>n</code> bytes</td><td>- Efficient storage<br>- No padding</td><td><code>'Hello'</code> stored as <code>'Hello'</code></td></tr><tr><td><code>VARCHAR(n)</code></td><td>ANSI SQL equivalent, internally treated as <code>VARCHAR2</code></td><td>- Supported but not recommended<br>- Future behavior undefined</td><td><code>'Hi'</code> stored as <code>'Hi'</code></td></tr><tr><td><code>NCHAR(n)</code></td><td>Fixed-length Unicode character string</td><td>- Unicode-aware<br>- Always <code>n</code> characters (not bytes)</td><td><code>'नमस्ते'</code> stored with padding</td></tr><tr><td><code>NVARCHAR2(n)</code></td><td>Variable-length Unicode character string up to <code>n</code> characters</td><td>- Unicode-aware<br>- No padding</td><td><code>'你好'</code> stored as-is</td></tr></tbody></table>

### **Byte and Character Limits**

Oracle imposes specific **maximum limits** depending on the data type and database settings (especially character set and semantics).

{% hint style="info" %}
**Character semantics**: If the database or column uses character semantics, the limits apply to characters instead of bytes. This is useful in multibyte/Unicode character sets.
{% endhint %}

<table><thead><tr><th width="152.84765625">Data Type</th><th>Max Length (Bytes)</th><th>Max Length (Characters)</th><th>Notes</th></tr></thead><tbody><tr><td><code>CHAR(n)</code></td><td>2000 bytes</td><td>Depends on byte-per-char</td><td>Fixed-length; may waste space if short data is stored.</td></tr><tr><td><code>VARCHAR2(n)</code></td><td>4000 bytes (SQL), 32767 bytes (PL/SQL)</td><td>Depends on byte-per-char</td><td>Most common string type; <code>n</code> is byte count unless <code>CHAR</code> semantics used.</td></tr><tr><td><code>NCHAR(n)</code></td><td>2000 bytes</td><td>1000 characters (UTF-16)</td><td>Always uses national character set (usually UTF-16).</td></tr><tr><td><code>NVARCHAR2(n)</code></td><td>4000 bytes (SQL), 32767 bytes (PL/SQL)</td><td>2000 characters (UTF-16)</td><td>Used for Unicode multilingual data.</td></tr><tr><td><code>VARCHAR(n)</code></td><td>Same as <code>VARCHAR2</code></td><td>Deprecated</td><td>Reserved by Oracle; avoid using.</td></tr></tbody></table>

### **Storage and Performance Implications**

<table data-full-width="true"><thead><tr><th width="140.55078125">Data Type</th><th width="144.59375">Storage Efficiency</th><th width="263.3125">Performance Impact</th><th>Best Use Case</th></tr></thead><tbody><tr><td><code>CHAR(n)</code></td><td>Low (always fixed)</td><td>Slower for short values</td><td>Fields with consistent, small size (e.g., 'Y'/'N')</td></tr><tr><td><code>VARCHAR2(n)</code></td><td>High</td><td>Fast and efficient</td><td>General-purpose strings</td></tr><tr><td><code>NCHAR(n)</code></td><td>Medium</td><td>Slight overhead (Unicode)</td><td>Fixed-width internationalized values</td></tr><tr><td><code>NVARCHAR2(n)</code></td><td>Medium-High</td><td>More space needed (UTF-16)</td><td>Multilingual applications</td></tr><tr><td><code>VARCHAR(n)</code></td><td>Same as <code>VARCHAR2</code></td><td>No gain; discouraged</td><td>Not recommended</td></tr></tbody></table>





