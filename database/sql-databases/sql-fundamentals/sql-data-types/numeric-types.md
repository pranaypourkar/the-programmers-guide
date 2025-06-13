# Numeric Types

## About

**Numeric data types** are used to store numbers in a database. These numbers can be **integers** (whole numbers) or **decimals** (numbers with a fractional part). SQL provides a set of standard numeric types that most relational databases support, though exact names and behavior may vary slightly between vendors.

## 1. **INTEGER (or INT)**

* Stores whole numbers without a fractional component.
* Example: 1, -20, 999
* Storage size and range can vary depending on the system.
* Often used for IDs, counters, or quantities.

**Synonyms:** `INT`, `INTEGER`

## 2. **SMALLINT**

* Stores smaller-range integers than `INT`.
* Takes less storage.
* Suitable when the range of values is limited (e.g., 0–100).

## 3. **BIGINT**

* Stores very large integers.
* Useful for applications that require large numeric values (e.g., timestamps, large counters).

## 4. **DECIMAL(p, s)** or **NUMERIC(p, s)**

* Stores exact numbers with a fixed number of digits.
* `p` = total number of digits (precision).
* `s` = number of digits to the right of the decimal point (scale).
* Commonly used for monetary or financial data where precision is critical.

**Examples:**

* `DECIMAL(5,2)` can store values like 123.45, 99.99, etc.
* `NUMERIC(10,0)` is an integer with up to 10 digits.

**Note:** `DECIMAL` and `NUMERIC` are functionally equivalent in standard SQL.

## 5. **FLOAT(p)**

* Stores approximate numeric values with floating-point precision.
* `p` is precision, typically the number of bits used to represent the value.
* Useful for scientific calculations where precision is not exact.

## 6. **REAL**

* A floating-point number with lower precision than `FLOAT`.
* Approximate numeric data type.
* Not suitable when exact values are required.

## 7. **DOUBLE PRECISION**

* A floating-point number with higher precision than `REAL`.
* Also an approximate type.
* Used when more accuracy is needed in floating-point calculations.

## Vendor Support Overview

<table><thead><tr><th width="151.81640625">Data Type</th><th width="119.9765625">Standard SQL</th><th>Oracle</th><th width="89.375">MySQL</th><th width="111.34375">PostgreSQL</th><th>SQL Server</th></tr></thead><tbody><tr><td><code>INTEGER</code> / <code>INT</code></td><td>Yes</td><td>Yes</td><td>Yes</td><td>Yes</td><td>Yes</td></tr><tr><td><code>SMALLINT</code></td><td>Yes</td><td>Yes</td><td>Yes</td><td>Yes</td><td>Yes</td></tr><tr><td><code>BIGINT</code></td><td>Yes</td><td>Yes (from 8i)</td><td>Yes</td><td>Yes</td><td>Yes</td></tr><tr><td><code>DECIMAL(p,s)</code></td><td>Yes</td><td>Yes</td><td>Yes</td><td>Yes</td><td>Yes</td></tr><tr><td><code>NUMERIC(p,s)</code></td><td>Yes</td><td>Yes</td><td>Yes</td><td>Yes</td><td>Yes</td></tr><tr><td><code>FLOAT(p)</code></td><td>Yes</td><td>Yes (alias)</td><td>Yes</td><td>Yes</td><td>Yes</td></tr><tr><td><code>REAL</code></td><td>Yes</td><td>No (not standard)</td><td>Yes</td><td>Yes</td><td>Yes</td></tr><tr><td><code>DOUBLE PRECISION</code></td><td>Yes</td><td>No (use <code>BINARY_DOUBLE</code>)</td><td>Yes</td><td>Yes</td><td>Yes (<code>FLOAT(53)</code>)</td></tr></tbody></table>
