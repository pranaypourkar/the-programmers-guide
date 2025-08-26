# Collation

## About

Collation is a set of **rules** that define how strings are **sorted** and **compared**. These rules are applied when performing operations like:

* `ORDER BY` to sort results
* `WHERE name = 'John'` to compare values
* `GROUP BY name` to group similar records

The rules include:

* **Case sensitivity** (is `a` equal to `A`?)
* **Accent sensitivity** (is `é` equal to `e`?)
* **Language-specific sorting** (does `ä` come before or after `z`?)

**Naming Convention**

MySQL collation names follow this format:

```
character_set_name + _ + collation_name
```

Examples:

* `utf8mb4_general_ci` → character set: `utf8mb4`, collation: `general_ci`
* `latin1_swedish_ci` → character set: `latin1`, collation: `swedish_ci`

**Common Suffixes**

* `_ci` → Case Insensitive (e.g., `a = A`)
* `_cs` → Case Sensitive
* `_bin` → Binary comparison (exact byte-by-byte match)

**How to Check Available Collations**

```sql
SHOW COLLATION;
```

{% file src="../../../../.gitbook/assets/show_collation.csv" %}

## **How Collation Works Internally**

MySQL converts characters into **binary code points** using the character set. Then, collation defines how those code points are **evaluated** for equality and order:

* `Binary collation`: Compares the raw byte values directly.
* `General collation`: Uses simplified sorting rules.
* `Unicode collation`: Follows the Unicode Collation Algorithm (UCA), more accurate and language-aware.

## **Character Set vs Collation**

<table><thead><tr><th width="156.2265625">Feature</th><th width="271.9227294921875">Character Set</th><th>Collation</th></tr></thead><tbody><tr><td>What it defines</td><td>Encoding and storage of text</td><td>Comparison and sorting rules</td></tr><tr><td>Example</td><td><code>utf8mb4</code>, <code>latin1</code>, <code>ascii</code></td><td><code>utf8mb4_unicode_ci</code>, <code>latin1_swedish_ci</code></td></tr><tr><td>Storage impact</td><td>Affects byte size of characters</td><td>No impact on storage, only on string logic</td></tr></tbody></table>

## **Types of Collations**

<table data-header-hidden><thead><tr><th width="156.1180419921875"></th><th></th></tr></thead><tbody><tr><td><strong>Suffix</strong></td><td><strong>Meaning</strong></td></tr><tr><td><code>_ci</code></td><td>Case-insensitive: <code>'a' = 'A'</code></td></tr><tr><td><code>_cs</code></td><td>Case-sensitive: <code>'a' ≠ 'A'</code></td></tr><tr><td><code>_ai</code></td><td>Accent-insensitive: <code>'é' = 'e'</code></td></tr><tr><td><code>_as</code></td><td>Accent-sensitive: <code>'é' ≠ 'e'</code></td></tr><tr><td><code>_bin</code></td><td>Binary comparison (byte-by-byte): strictest and fastest</td></tr><tr><td><code>_0900</code></td><td>Unicode version 9.0 (used in MySQL 8.0 and later)</td></tr><tr><td><code>_520</code></td><td>Unicode version 5.2 (used for more accurate ordering)</td></tr></tbody></table>

### **a. Case Insensitive Collations (`_ci`)**

* `'A' = 'a'`
* Common default in MySQL
* Good for user-facing applications

### **b. Case Sensitive Collations (`_cs`)**

* `'A' != 'a'`
* Used when case must be preserved (e.g., passwords)

### **c. Accent Sensitive Collations (`_as`)**

* `'e' != 'é'`
* Important for supporting multiple languages

### **d. Binary Collation (`_bin`)**

* Compares bytes directly
* Strictest comparison
* Fastest performance
* Used for internal keys, identifiers

## **Common MySQL Collations and Their Meanings**

<table data-header-hidden data-full-width="true"><thead><tr><th width="225.36981201171875"></th><th width="136.74566650390625"></th><th></th></tr></thead><tbody><tr><td><strong>Collation Name</strong></td><td><strong>Character Set</strong></td><td><strong>Meaning / Behavior</strong></td></tr><tr><td><code>utf8mb4_general_ci</code></td><td><code>utf8mb4</code></td><td>Case-insensitive, fast, simplified Unicode collation. Suitable for general use.</td></tr><tr><td><code>utf8mb4_unicode_ci</code></td><td><code>utf8mb4</code></td><td>Case-insensitive, full Unicode-compliant. Slower but accurate multilingual sorting.</td></tr><tr><td><code>utf8mb4_unicode_520_ci</code></td><td><code>utf8mb4</code></td><td>Same as above, but based on Unicode 5.2 standard. Better for newer Unicode versions.</td></tr><tr><td><code>utf8mb4_bin</code></td><td><code>utf8mb4</code></td><td>Binary collation: case-sensitive and accent-sensitive. Fastest and strict comparison.</td></tr><tr><td><code>utf8mb4_general_cs</code></td><td><code>utf8mb4</code></td><td>Case-sensitive variant of <code>general_ci</code>. <code>'a' != 'A'</code>.</td></tr><tr><td><code>utf8mb4_0900_ai_ci</code></td><td><code>utf8mb4</code></td><td>Unicode 9.0, accent-insensitive, case-insensitive. Used in MySQL 8.0+.</td></tr><tr><td><code>utf8mb4_0900_as_cs</code></td><td><code>utf8mb4</code></td><td>Unicode 9.0, accent-sensitive, case-sensitive.</td></tr><tr><td><code>utf8mb4_0900_bin</code></td><td><code>utf8mb4</code></td><td>Unicode 9.0 binary collation. Strictest match.</td></tr><tr><td><code>latin1_swedish_ci</code></td><td><code>latin1</code></td><td>Default for <code>latin1</code>, case-insensitive.</td></tr><tr><td><code>latin1_general_ci</code></td><td><code>latin1</code></td><td>Case-insensitive, faster for general use in Western languages.</td></tr><tr><td><code>latin1_general_cs</code></td><td><code>latin1</code></td><td>Case-sensitive version of <code>latin1_general_ci</code>.</td></tr><tr><td><code>ascii_general_ci</code></td><td><code>ascii</code></td><td>Case-insensitive ASCII collation.</td></tr><tr><td><code>ascii_bin</code></td><td><code>ascii</code></td><td>Binary collation for ASCII characters. Case-sensitive and fast.</td></tr><tr><td><code>utf8_general_ci</code></td><td><code>utf8</code></td><td>Same as <code>utf8mb4_general_ci</code> but with older 3-byte character support only.</td></tr><tr><td><code>utf8_unicode_ci</code></td><td><code>utf8</code></td><td>Unicode-compliant collation for <code>utf8</code> character set.</td></tr><tr><td><code>utf8_bin</code></td><td><code>utf8</code></td><td>Binary collation for 3-byte <code>utf8</code>.</td></tr></tbody></table>

## **How to Set & Check Collation**

### **Set Collation**

**1. Server Level (default)**\
Set in configuration file (`my.cnf` or `my.ini`):

```ini
[mysqld]
collation-server = utf8mb4_general_ci
```

**2. Database Level**

```sql
CREATE DATABASE mydb CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
```

**3. Table Level**

```sql
CREATE TABLE users (
  name VARCHAR(100)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

**4. Column Level**

```sql
CREATE TABLE users (
  name VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin
);
```

**5. Query Level (for comparison)**

```sql
SELECT * FROM users WHERE name COLLATE utf8mb4_general_ci = 'john';
```

**6. In application.properties file (Spring)**

```
spring.datasource.url=jdbc:mysql://localhost:3306/your_database_name?useUnicode=true&characterEncoding=UTF-8&useSSL=false
spring.datasource.username=your_username
spring.datasource.password=your_password
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
```

### **Check Current Collation**

```sql
SELECT @@collation_database;
SELECT @@collation_server;
SELECT COLLATION(name) FROM users;
```

### **Changing Collation**

Change collation for a column:

```sql
ALTER TABLE users MODIFY name VARCHAR(100) COLLATE utf8mb4_unicode_ci;
```

## **Practical Scenarios**

**a. Usernames Must Be Unique and Case-Sensitive**

```sql
VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin
```

**b. Searching Names Without Case Sensitivity**

```sql
VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci
```

**c. Sorting Multilingual Content Correctly**

```sql
utf8mb4_unicode_ci` or `utf8mb4_unicode_520_ci
```
