# Character Types

## About

**Character data types** are used to store **textual data**, such as names, addresses, and descriptions. SQL provides standard character types that most relational databases support, with slight variations.

There are two main categories:

1. **Fixed-length** character types
2. **Variable-length** character types

## 1. **CHAR(n)**

* Stores **fixed-length** character strings.
* Always occupies `n` characters, **padding with spaces** if input is shorter.
* Use when all values are known to have the same length (e.g., status codes, country codes).

**Example:**\
`CHAR(5)` will store `'abc'` as `'abc '` (with two spaces).

## 2. **VARCHAR(n)** or **CHARACTER VARYING(n)**

* Stores **variable-length** character strings.
* Maximum length is `n`, but only uses as much space as needed.
* More efficient for storing strings of varying length.

**Example:**\
`VARCHAR(10)` can store `'abc'` using 3 characters instead of 10.

## 3. **TEXT** (non-standard, vendor-specific)

* Stores large text data (longer than `VARCHAR(n)` limits).
* Not part of standard SQL but supported by many databases.

## Vendor Support Overview

<table data-header-hidden><thead><tr><th width="117.2265625"></th><th width="77.76171875"></th><th width="107.15234375"></th><th width="139.4921875"></th><th></th></tr></thead><tbody><tr><td>Database</td><td><code>CHAR</code></td><td><code>VARCHAR</code></td><td><code>TEXT</code> Support</td><td>Notes</td></tr><tr><td><strong>Oracle</strong></td><td>Yes</td><td>Yes</td><td>No <code>TEXT</code>; use <code>CLOB</code></td><td>Oracle uses <code>CLOB</code> for large character data. <code>VARCHAR2</code> is preferred.</td></tr><tr><td><strong>MySQL</strong></td><td>Yes</td><td>Yes</td><td>Yes</td><td>Supports <code>TINYTEXT</code>, <code>TEXT</code>, <code>MEDIUMTEXT</code>, <code>LONGTEXT</code>.</td></tr><tr><td><strong>PostgreSQL</strong></td><td>Yes</td><td>Yes</td><td>Yes</td><td><code>TEXT</code> has no length limit and behaves like unlimited <code>VARCHAR</code>.</td></tr><tr><td><strong>SQL Server</strong></td><td>Yes</td><td>Yes</td><td>Yes (<code>TEXT</code> deprecated)</td><td>Use <code>VARCHAR(MAX)</code> instead of <code>TEXT</code>.</td></tr><tr><td><strong>SQLite</strong></td><td>Yes</td><td>Yes</td><td>Yes</td><td>Very flexible typing; <code>TEXT</code> used commonly.</td></tr></tbody></table>
