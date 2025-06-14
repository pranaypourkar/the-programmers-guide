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

## 2. Numeric Data Types

### Description

Numeric types in Oracle are highly flexible and configurable. They support exact (fixed-point) and approximate (floating-point) representations.

* **Precision (p)**: Total number of significant digits.
* **Scale (s)**: Number of digits to the right of the decimal point.
* **Overflow and rounding**: Operations that exceed scale may be rounded or truncated based on context.
* **Binary vs decimal**: Oracle supports both binary floats and precise decimal arithmetic.

### Types

Oracle provides two main categories of numeric types:

1. **Exact Numeric Types**
   * `NUMBER`
   * `INTEGER`, `INT`, `SMALLINT`, `DEC`, `DECIMAL`, `NUMERIC` (ANSI-compatible synonyms)
2. **Approximate Numeric Types**
   * `BINARY_FLOAT`
   * `BINARY_DOUBLE`&#x20;

### `NUMBER(p, s)` – General Purpose Numeric Type

* A variable-precision numeric type that can store integers and decimals.
* `p` is **precision** (total number of significant digits).
* `s` is **scale** (number of digits to the right of the decimal point).

#### Ranges

* Maximum precision: **38 digits**
* Scale range: `-84` to `127`

#### Examples

<table><thead><tr><th width="144.80078125">Declaration</th><th width="379.08984375">Description</th><th>Acceptable Values</th></tr></thead><tbody><tr><td><code>NUMBER</code></td><td>Maximum flexibility. Default precision/scale.</td><td><code>42</code>, <code>3.1415</code>, <code>-9999.99</code></td></tr><tr><td><code>NUMBER(5)</code></td><td>Up to 5 digits. No decimal.</td><td><code>12345</code>, <code>-9999</code></td></tr><tr><td><code>NUMBER(7, 2)</code></td><td>7 digits total, 2 after decimal.</td><td><code>12345.67</code></td></tr><tr><td><code>NUMBER(*, 0)</code></td><td>Any number of digits, no decimal.</td><td>Integer values only</td></tr></tbody></table>

#### Behavior

* If the number exceeds the specified precision, Oracle raises an error.
* If scale is higher than actual decimals, Oracle appends trailing zeroes.
* If scale is lower, Oracle rounds the value.

**ANSI-Compatible Synonyms**

These are alternative names mapped to `NUMBER`:

<table><thead><tr><th width="254.265625">Synonym</th><th>Oracle Equivalent</th></tr></thead><tbody><tr><td><code>INTEGER</code></td><td><code>NUMBER(38,0)</code></td></tr><tr><td><code>INT</code></td><td><code>NUMBER(38,0)</code></td></tr><tr><td><code>SMALLINT</code></td><td><code>NUMBER(38,0)</code></td></tr><tr><td><code>DEC</code></td><td><code>NUMBER(p,s)</code></td></tr><tr><td><code>DECIMAL</code></td><td><code>NUMBER(p,s)</code></td></tr><tr><td><code>NUMERIC</code></td><td><code>NUMBER(p,s)</code></td></tr></tbody></table>

### `FLOAT(p)` – Approximate with Decimal Precision

* Floating-point number with `p` bits of binary precision.
* `FLOAT(p)` is internally treated as `NUMBER(p)`.

{% hint style="info" %}
Although named `FLOAT`, Oracle does **not** use IEEE floating point here unless we use `BINARY_FLOAT` or `BINARY_DOUBLE`.
{% endhint %}

#### Example

* `FLOAT(10)` means up to 10 digits of precision.

Use `FLOAT` with caution as its behavior may be misleading—use `BINARY_FLOAT` or `BINARY_DOUBLE` if we truly need floating-point arithmetic.

**Example 1: Basic FLOAT column**

```sql
CREATE TABLE sample_float_table (
    id        NUMBER,
    value     FLOAT -- same as NUMBER with default precision (usually 126)
);
```

We can insert values like:

```sql
INSERT INTO sample_float_table (id, value) VALUES (1, 12345.6789);
INSERT INTO sample_float_table (id, value) VALUES (2, -0.000345);
```

**Example 2: FLOAT with precision**

```sql
CREATE TABLE precise_float_table (
    id         NUMBER,
    value      FLOAT(10) -- same as NUMBER(10)
);
```

This means the column `value` can store **up to 10 significant digits**, e.g.,

```sql
INSERT INTO precise_float_table VALUES (1, 123456.7890); -- OK
INSERT INTO precise_float_table VALUES (2, 1234567890.12); -- Error or rounded
```

### `BINARY_FLOAT` and `BINARY_DOUBLE` – Binary Floating Point Types

These types use IEEE 754 format for representing approximate decimal numbers.

<table><thead><tr><th width="169.83203125">Data Type</th><th width="95.3046875">Size</th><th width="114.94140625">Precision</th><th>Use Case</th></tr></thead><tbody><tr><td><code>BINARY_FLOAT</code></td><td>32 bits</td><td>~6 digits</td><td>Fast approximate calculations</td></tr><tr><td><code>BINARY_DOUBLE</code></td><td>64 bits</td><td>~15 digits</td><td>Higher precision computations</td></tr></tbody></table>

#### Key Characteristics

* Support **NaN**, **positive/negative infinity**, and **subnormal numbers**.
* **Faster** than `NUMBER` due to hardware-level operations.
* Cannot be indexed using B-tree indexes.
* Not exact—do not use in financial or accounting systems.

#### Examples

```sql
CREATE TABLE temperature_data (
  city_name VARCHAR2(100),
  avg_temp  BINARY_FLOAT
);

INSERT INTO temperature_data VALUES ('Delhi', 42.57);
```

### NUMBER vs BINARY\_FLOAT/DOUBLE

| Feature     | `NUMBER`           | `BINARY_FLOAT` / `DOUBLE` |
| ----------- | ------------------ | ------------------------- |
| Precision   | Exact (up to 38 d) | Approximate               |
| Storage     | Variable           | Fixed (4 or 8 bytes)      |
| Performance | Slower             | Faster                    |
| Usage       | Financial          | Scientific, statistical   |
| Indexing    | B-tree supported   | Not supported             |
| Rounding    | Controlled         | IEEE-based                |

## 3. Date & Time Data Types

Temporal types store points in time or durations. Oracle aligns partially with SQL standards but also adds its own enhancements for timezone-aware storage and interval management.

* **Oracle’s `DATE` includes time**: Unlike standard SQL, `DATE` in Oracle includes both date and time down to seconds.
* **Fractional seconds and precision**: Timestamps support up to 9 digits of fractional seconds.
* **Timezone handling**: Oracle supports both session-relative and absolute time zones.
* **Intervals as durations**: Represent spans of time, not absolute moments.

### `DATE`

Stores **both date and time values**, accurate to the **second**. This is the most basic and commonly used temporal type in Oracle.

* Internally stored as **7 bytes**:
  * Century, Year, Month, Day, Hour, Minute, Second
* Default format: `DD-MON-YY` (can be changed via `NLS_DATE_FORMAT`)
* Does **not** support fractional seconds or time zones.

```sql
DATE '2024-06-05'
TO_DATE('2024-06-05 14:30:00', 'YYYY-MM-DD HH24:MI:SS')
```

### `TIMESTAMP`

Extends `DATE` by including **fractional seconds** (up to 9 digits of precision). Used where higher accuracy is required.

* Default fractional precision is **6 digits**.
* Internally stored as **11 bytes**.
* No time zone support.

#### Syntax:

```sql
TIMESTAMP [(fractional_seconds_precision)]
```

```sql
TIMESTAMP '2024-06-05 14:30:00.123456'
```

### `TIMESTAMP WITH TIME ZONE` (abbreviated: `TIMESTAMP WITH TZ`)

Adds **time zone offset** information to a timestamp, making it suitable for storing absolute moments in time globally.

* Stores time in **UTC** and retains the time zone offset.
* Time zone can be expressed as an offset (e.g., `+05:30`) or region name (e.g., `'Asia/Kolkata'`).
* Useful for **distributed systems**.

#### Syntax:

```sql
TIMESTAMP [(fractional_seconds_precision)] WITH TIME ZONE
```

```sql
TIMESTAMP '2024-06-05 14:30:00.123456 +05:30'
```

### `TIMESTAMP WITH LOCAL TIME ZONE` (abbreviated: `TIMESTAMP WITH LTZ`)

Stores the timestamp in **UTC internally**, but **displays it in the user's session time zone**. Useful for applications with users across time zones.

* Time zone information is **not stored**, but inferred from session.
* Automatically adjusted during storage and retrieval.
* Ideal for **user-facing logs or event timestamps**.

#### Syntax:

```sql
TIMESTAMP [(fractional_seconds_precision)] WITH LOCAL TIME ZONE
```

```sql
TIMESTAMP '2024-06-05 14:30:00.123456' AT LOCAL
```

### `INTERVAL YEAR TO MONTH`

Represents a **duration** (not a point in time) in terms of years and months.

* Used to **add/subtract** months or years to/from a date.
* Cannot include days, hours, or minutes.
* Useful in **business date arithmetic** (e.g., contract terms).

```sql
INTERVAL YEAR [(precision)] TO MONTH
```

```sql
INTERVAL '2-3' YEAR TO MONTH   -- 2 years, 3 months
```

### `INTERVAL DAY TO SECOND`

Represents a **duration** in days, hours, minutes, seconds, and fractional seconds.

* Supports up to 9 digits of fractional second precision.
* Used for **time spans**, e.g., tracking elapsed time.

#### Syntax:

```sql
INTERVAL DAY [(day_precision)] TO SECOND [(fractional_seconds_precision)]
```

```sql
INTERVAL '5 12:30:15.123456' DAY TO SECOND
-- 5 days, 12 hours, 30 minutes, 15.123456 seconds
```

