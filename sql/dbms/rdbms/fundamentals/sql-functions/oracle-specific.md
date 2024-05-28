# Oracle Specific

## REPLACE

### Description

The `REPLACE` function in Oracle is used to replace occurrences of a specified substring within a string with another substring. It is a string manipulation function that can be used to modify parts of a string based on specific criteria. It is case-sensitive.

### Syntax

```sql
REPLACE(string, search_string, replacement_string)
```

### Parameters

* **string**: The original string in which the search and replace operation will be performed.
* **search\_string**: The substring that we want to find within the original string.
* **replacement\_string**: The substring that will replace every occurrence of the `search_string`. If `replacement_string` is omitted, all occurrences of `search_string` are removed.

### Return Value

The function returns a new string where all occurrences of `search_string` are replaced with `replacement_string`.

### Examples

```
SELECT REPLACE('Hello World', 'World', 'Oracle') AS replaced_string
FROM DUAL;
-- Output -> Hello Oracle

SELECT REPLACE('Hello World', 'World') AS replaced_string
FROM DUAL;
-- Output -> Hello

SELECT REPLACE('banana', 'a', 'o') AS replaced_string
FROM DUAL;
-- Output -> bonono

SELECT FIRST_NAME, REPLACE(FIRST_NAME, 'a', 'o') AS new_name
FROM employees;
```

## TRANSLATE

### Description

The `TRANSLATE` function in Oracle is used to replace characters in a string with other characters based on a given mapping. Unlike `REPLACE`, which operates on substrings, `TRANSLATE` operates on individual characters and can simultaneously replace multiple characters with different characters.

### Parameters

* **string**: The original string in which the replacement will take place.
* **from\_string**: A string containing characters to be replaced.
* **to\_string**: A string containing characters that will replace the characters in `from_string`.

### Return Value

The function returns a new string where each character in the `from_string` is replaced with the corresponding character in the `to_string`.

{% hint style="info" %}
* The `from_string` and `to_string` should have the same length. If `to_string` is shorter, extra characters in `from_string` are removed from the `string`.
* Each character in `from_string` is mapped to the character in the same position in `to_string`.
* If any character in `from_string` does not have a corresponding character in `to_string`, that character is removed from the string.
* Character-by-Character Replacement i.e. each character in `from_string` is replaced by the character at the same position in `to_string`.
* Works for character-by-character translation and **requires non-empty mapping strings**.
{% endhint %}

### Examples

```
SELECT TRANSLATE('banana', 'a', 'o') AS translated_string
FROM DUAL;
-- Output -> bonono

SELECT TRANSLATE('banana', 'an', 'om') AS translated_string
FROM DUAL;
-- Output -> bomomo

SELECT TRANSLATE('banana', 'a', '') AS translated_string
FROM DUAL;
-- Output -> null

SELECT FIRST_NAME, TRANSLATE(FIRST_NAME, 'ae', 'oi') AS new_name
FROM employees;
```

### How TRANSLATE differs from REPLACE?

<table data-full-width="true"><thead><tr><th width="270">Feature</th><th>REPLACE</th><th>TRANSLATE</th></tr></thead><tbody><tr><td><strong>Purpose</strong></td><td>Replace occurrences of a substring</td><td>Replace occurrences of individual characters</td></tr><tr><td><strong>Syntax</strong></td><td><code>REPLACE(string, search_string, replacement_string)</code></td><td><code>TRANSLATE(string, from_string, to_string)</code></td></tr><tr><td><strong>Operation</strong></td><td>Works on substrings</td><td>Works on individual characters</td></tr><tr><td><strong>Case Sensitivity</strong></td><td>Case-sensitive</td><td>Case-sensitive</td></tr><tr><td><strong>Character Mapping</strong></td><td>One-to-one mapping for the entire substring</td><td>One-to-one character mapping</td></tr><tr><td><strong>Use Case Example</strong></td><td>Replace all occurrences of "cat" with "dog"</td><td>Replace all occurrences of 'a' with 'b', 'e' with 'i'</td></tr><tr><td><strong>When <code>search_string</code> or <code>from_string</code> is not found</strong></td><td>No change</td><td>No change</td></tr><tr><td><strong>Handling of NULLs</strong></td><td>If any argument is <code>NULL</code>, returns <code>NULL</code></td><td>If any argument is <code>NULL</code>, returns <code>NULL</code></td></tr><tr><td><strong>Performance</strong></td><td>Generally used for fewer, more complex replacements</td><td>Generally faster for character replacements</td></tr><tr><td><strong>Removing Characters</strong></td><td>Cannot directly remove a substring without replacing</td><td>Can remove characters by providing an empty <code>to_string.</code> If we want to remove multiple characters using <code>TRANSLATE</code>, we need to ensure that the <code>to_string</code> parameter is not empty but contains a character that will be mapped to the characters in the <code>from_string</code></td></tr><tr><td><strong>Example 1</strong></td><td><code>REPLACE('Hello World', 'World', 'Oracle')</code> returns <code>Hello Oracle</code></td><td><code>TRANSLATE('Hello', 'Hlo', 'Bri')</code> returns <code>Berro</code></td></tr><tr><td><strong>Example 2</strong></td><td><code>REPLACE('banana', 'a', 'o')</code> returns <code>bonono</code></td><td><code>TRANSLATE('banana', 'an', 'om')</code> returns <code>bomomo</code></td></tr><tr><td><strong>Use in Columns</strong></td><td><code>SELECT REPLACE(column_name, 'old', 'new') FROM table</code></td><td><code>SELECT TRANSLATE(column_name, 'from_chars', 'to_chars') FROM table</code></td></tr></tbody></table>

## LENGTH

### Description

The `LENGTH` function in Oracle is used to return the number of characters in a string.

### Syntax

```sql
LENGTH(string)
```

### Parameters

* **string**: The string expression whose length you want to determine. This can be a column name, a literal string, or any expression that evaluates to a string.

### Return Value

The function returns an integer representing the number of characters in the specified string. If the string is `NULL`, the function returns `NULL`.

### Examples

```
SELECT LENGTH('Hello World') AS length_of_string
FROM DUAL;
-- Output -> 11

SELECT FIRST_NAME, LENGTH(FIRST_NAME) AS length_of_name
FROM employees;
```

## TRIM

### Description

The `TRIM` function in Oracle is used to remove leading and trailing spaces or other specified characters from a string. It is particularly useful for cleaning up data by removing unnecessary whitespace or specific unwanted characters from the beginning and end of strings.

### Syntax

```sql
TRIM([ [LEADING | TRAILING | BOTH] [trim_character] FROM ] string)
```

### Parameters

* **LEADING | TRAILING | BOTH**: Specifies which side(s) of the string to trim. The default is `BOTH`.
  * **LEADING**: Trims characters from the beginning of the string.
  * **TRAILING**: Trims characters from the end of the string.
  * **BOTH**: Trims characters from both the beginning and the end of the string.
* **trim\_character**: The character to be trimmed from the string. If not specified, spaces are trimmed by default.
* **string**: The string expression from which the characters are to be trimmed.

### Return Value

The function returns a new string with the specified characters removed from the specified side(s).

### Examples

```
-- Remove leading and trailing spaces from a string
SELECT TRIM('  Hello World  ') AS trimmed_string FROM DUAL;
-- Output -> Hello World

-- Remove leading and trailing asterisks (*) from a string
SELECT TRIM('*' FROM '***Hello***') AS trimmed_string FROM DUAL;
-- Output -> Hello

-- Remove only the leading spaces from a string
SELECT TRIM(LEADING ' ' FROM '  Hello World  ') AS trimmed_string FROM DUAL;
-- Output -> Hello World 

-- Remove only the trailing spaces from a string
SELECT TRIM(TRAILING ' ' FROM '  Hello World  ') AS trimmed_string FROM DUAL;
-- Output ->

-- Using TRIM with a Column
SELECT FIRST_NAME, TRIM(FIRST_NAME) AS trimmed_name
FROM employees;
```

## CAST&#x20;

### Description

The `CAST` function in Oracle is used to convert one data type to another. It is a versatile function that allows to change the data type of an expression to a different data type, which is particularly useful when dealing with different types of data in queries.

### Syntax

```sql
CAST(expression AS target_data_type)
```

### Parameters

* **expression**: The value or column that you want to convert.
* **target\_data\_type**: The data type to which you want to convert the expression.

### Supported Data Types

The `CAST` function supports conversion to and from a wide range of data types like

* VARCHAR2, CHAR
* NUMBER, INTEGER, FLOAT
* DATE, TIMESTAMP
* BLOB, CLOB

### Examples

```
-- Convert a VARCHAR2 column to a NUMBER:
SELECT CAST('123' AS NUMBER) AS number_value FROM DUAL;

-- Convert a NUMBER to a VARCHAR2
SELECT CAST(123 AS VARCHAR2(10)) AS string_value FROM DUAL;

-- Convert a DATE to a TIMESTAMP
SELECT CAST(SYSDATE AS TIMESTAMP) AS timestamp_value FROM DUAL;

-- Using CAST in a Table Query
SELECT employee_id, hire_date, CAST(hire_date AS TIMESTAMP) AS hire_timestamp FROM employees;

-- Combining CAST with Other Functions
SELECT CAST(ROUND(123.456, 2) AS VARCHAR2(10)) AS rounded_string FROM DUAL;

-- Oracle will raise an error
SELECT CAST('abc' AS NUMBER) AS invalid_conversion FROM DUAL;
```

{% hint style="info" %}
**NULL Handling**: If the expression is `NULL`, the `CAST` function returns NULL of the target data type.
{% endhint %}

## LOWER

### Description

The `LOWER` function converts all characters in a string to lowercase.

### **Syntax**

```sql
LOWER(string)
```

### **Parameters**

* **string**: The input string to be converted to lowercase.

### **Return Value**

The function returns a new string with all characters converted to lowercase.

### **Examples**

```
SELECT LOWER('Hello World') AS lower_string FROM DUAL;
-- Output -> hello world

SELECT LOWER(FIRST_NAME) AS lower_name FROM employees;
```

## UPPER

### Description

The `UPPER` function converts all characters in a string to uppercase.

### **Syntax**

```sql
UPPER(string)
```

### **Parameters**

* **string**: The input string to be converted to uppercase.

### **Return Value**

The function returns a new string with all characters converted to uppercase.

### **Examples**

```
SELECT UPPER('Hello World') AS upper_string FROM DUAL;
-- Output -> HELLO WORLD

SELECT UPPER(FIRST_NAME) AS upper_name FROM employees;
```

## RPAD

### Description

The `RPAD` function pads the right side of a string with a specified character to a specified length.

### **Syntax**

```sql
RPAD(string, length, [pad_string])
```

### **Parameters**

* **string**: The input string to be padded.
* **length**: The total length of the resulting string after padding.
* **pad\_string** (optional): The string to pad with. If not specified, spaces are used.

### **Return Value**

The function returns a new string of the specified length, padded with the specified character (or spaces) on the right side.

### **Examples**

```
-- Pad a string with spaces to a length of 10
SELECT RPAD('Hello', 10) AS padded_string FROM DUAL;
-- Output -> Hello     

-- Pad a string with asterisks (*) to a length of 10
SELECT RPAD('Hello', 10, '*') AS padded_string FROM DUAL;
-- Output -> Hello*****

SELECT RPAD(FIRST_NAME, 15, '-') AS padded_name FROM employees;
```

## LPAD

### Description

The `LPAD` function pads the left side of a string with a specified character to a specified length.

### **Syntax**

```sql
LPAD(string, length, [pad_string])
```

### **Parameters**

* **string**: The input string to be padded.
* **length**: The total length of the resulting string after padding.
* **pad\_string** (optional): The string to pad with. If not specified, spaces are used.

### **Return Value**

The function returns a new string of the specified length, padded with the specified character (or spaces) on the left side.

### **Examples**

<pre><code>-- Pad a string with spaces to a length of 10
SELECT LPAD('Hello', 10) AS padded_string FROM DUAL;
<strong>-- Output ->     Hello
</strong><strong>
</strong><strong>-- Pad a string with asterisks (*) to a length of 10
</strong>SELECT LPAD('Hello', 10, '*') AS padded_string
FROM DUAL;
-- Output -> *****Hello

-- Pad a column
SELECT LPAD(FIRST_NAME, 15, '-') AS padded_name
FROM employees;

</code></pre>

## SYS\_CONNECT\_BY\_PATH

### Description

The `SYS_CONNECT_BY_PATH` function in Oracle is used in hierarchical queries to return the path of a column value from the root to the current row in a tree-structured format. It is particularly useful for displaying hierarchical relationships in a readable format.

### Syntax

```sql
SYS_CONNECT_BY_PATH(column, delimiter)
```

### Parameters

* **column**: The column for which the path is to be constructed.
* **delimiter**: The character or string that separates the levels in the hierarchy.

### Return Value

The function returns a string that represents the path from the root node to the current node, with each level separated by the specified delimiter.

### Usage Context

The `SYS_CONNECT_BY_PATH` function is used in the context of hierarchical queries, which are queries that use the `CONNECT BY` clause to define parent-child relationships within the data.

{% hint style="info" %}
If the column used in `SYS_CONNECT_BY_PATH` is `NULL`, it includes the `NULL` values in the path.
{% endhint %}

### Examples

#### Employee Manager Hierarchy

We have an `employees` table with columns `EMPLOYEE_ID`, `MANAGER_ID`, and `FIRST_NAME`. We need to display the hierarchical path of employee names with the help of `SYS_CONNECT_BY_PATH`

```
SELECT EMPLOYEE_ID, FIRST_NAME, 
       SYS_CONNECT_BY_PATH(FIRST_NAME, ' -> ') AS hierarchy_path
FROM employees
START WITH MANAGER_ID IS NULL
CONNECT BY PRIOR EMPLOYEE_ID = MANAGER_ID;
```

Sample Output

<figure><img src="../../../../../.gitbook/assets/image (4).png" alt="" width="563"><figcaption></figcaption></figure>

#### Create sequence or generate data

```
SELECT LEVEL, SYS_CONNECT_BY_PATH(LEVEL, ' -> ') AS level_path
FROM DUAL
CONNECT BY LEVEL <= 5;
```

Sample Output

<figure><img src="../../../../../.gitbook/assets/image (5).png" alt="" width="452"><figcaption></figcaption></figure>
