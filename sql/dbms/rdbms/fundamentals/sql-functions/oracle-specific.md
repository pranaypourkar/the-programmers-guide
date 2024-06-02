# Oracle Specific

## String Manipulation Functions

### REPLACE

#### Description

The `REPLACE` function in Oracle is used to replace occurrences of a specified substring within a string with another substring. It is a string manipulation function that can be used to modify parts of a string based on specific criteria. It is case-sensitive.

#### Syntax

```sql
REPLACE(string, search_string, replacement_string)
```

#### Parameters

* **string**: The original string in which the search and replace operation will be performed.
* **search\_string**: The substring that we want to find within the original string.
* **replacement\_string**: The substring that will replace every occurrence of the `search_string`. If `replacement_string` is omitted, all occurrences of `search_string` are removed.

#### Return Value

The function returns a new string where all occurrences of `search_string` are replaced with `replacement_string`.

#### Examples

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

### TRANSLATE

#### Description

The `TRANSLATE` function in Oracle is used to replace characters in a string with other characters based on a given mapping. Unlike `REPLACE`, which operates on substrings, `TRANSLATE` operates on individual characters and can simultaneously replace multiple characters with different characters.

#### Parameters

* **string**: The original string in which the replacement will take place.
* **from\_string**: A string containing characters to be replaced.
* **to\_string**: A string containing characters that will replace the characters in `from_string`.

#### Return Value

The function returns a new string where each character in the `from_string` is replaced with the corresponding character in the `to_string`.

{% hint style="info" %}
* The `from_string` and `to_string` should have the same length. If `to_string` is shorter, extra characters in `from_string` are removed from the `string`.
* Each character in `from_string` is mapped to the character in the same position in `to_string`.
* If any character in `from_string` does not have a corresponding character in `to_string`, that character is removed from the string.
* Character-by-Character Replacement i.e. each character in `from_string` is replaced by the character at the same position in `to_string`.
* Works for character-by-character translation and **requires non-empty mapping strings**.
{% endhint %}

#### Examples

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

#### How TRANSLATE differs from REPLACE?

<table data-full-width="true"><thead><tr><th width="270">Feature</th><th>REPLACE</th><th>TRANSLATE</th></tr></thead><tbody><tr><td><strong>Purpose</strong></td><td>Replace occurrences of a substring</td><td>Replace occurrences of individual characters</td></tr><tr><td><strong>Syntax</strong></td><td><code>REPLACE(string, search_string, replacement_string)</code></td><td><code>TRANSLATE(string, from_string, to_string)</code></td></tr><tr><td><strong>Operation</strong></td><td>Works on substrings</td><td>Works on individual characters</td></tr><tr><td><strong>Case Sensitivity</strong></td><td>Case-sensitive</td><td>Case-sensitive</td></tr><tr><td><strong>Character Mapping</strong></td><td>One-to-one mapping for the entire substring</td><td>One-to-one character mapping</td></tr><tr><td><strong>Use Case Example</strong></td><td>Replace all occurrences of "cat" with "dog"</td><td>Replace all occurrences of 'a' with 'b', 'e' with 'i'</td></tr><tr><td><strong>When <code>search_string</code> or <code>from_string</code> is not found</strong></td><td>No change</td><td>No change</td></tr><tr><td><strong>Handling of NULLs</strong></td><td>If any argument is <code>NULL</code>, returns <code>NULL</code></td><td>If any argument is <code>NULL</code>, returns <code>NULL</code></td></tr><tr><td><strong>Performance</strong></td><td>Generally used for fewer, more complex replacements</td><td>Generally faster for character replacements</td></tr><tr><td><strong>Removing Characters</strong></td><td>Cannot directly remove a substring without replacing</td><td>Can remove characters by providing an empty <code>to_string.</code> If we want to remove multiple characters using <code>TRANSLATE</code>, we need to ensure that the <code>to_string</code> parameter is not empty but contains a character that will be mapped to the characters in the <code>from_string</code></td></tr><tr><td><strong>Example 1</strong></td><td><code>REPLACE('Hello World', 'World', 'Oracle')</code> returns <code>Hello Oracle</code></td><td><code>TRANSLATE('Hello', 'Hlo', 'Bri')</code> returns <code>Berro</code></td></tr><tr><td><strong>Example 2</strong></td><td><code>REPLACE('banana', 'a', 'o')</code> returns <code>bonono</code></td><td><code>TRANSLATE('banana', 'an', 'om')</code> returns <code>bomomo</code></td></tr><tr><td><strong>Use in Columns</strong></td><td><code>SELECT REPLACE(column_name, 'old', 'new') FROM table</code></td><td><code>SELECT TRANSLATE(column_name, 'from_chars', 'to_chars') FROM table</code></td></tr></tbody></table>

### LENGTH

#### Description

The `LENGTH` function in Oracle is used to return the number of characters in a string.

#### Syntax

```sql
LENGTH(string)
```

#### Parameters

* **string**: The string expression whose length you want to determine. This can be a column name, a literal string, or any expression that evaluates to a string.

#### Return Value

The function returns an integer representing the number of characters in the specified string. If the string is `NULL`, the function returns `NULL`.

#### Examples

```
SELECT LENGTH('Hello World') AS length_of_string
FROM DUAL;
-- Output -> 11

SELECT FIRST_NAME, LENGTH(FIRST_NAME) AS length_of_name
FROM employees;
```

### TRIM

#### Description

The `TRIM` function in Oracle is used to remove leading and trailing spaces or other specified characters from a string. It is particularly useful for cleaning up data by removing unnecessary whitespace or specific unwanted characters from the beginning and end of strings.

#### Syntax

```sql
TRIM([ [LEADING | TRAILING | BOTH] [trim_character] FROM ] string)
```

#### Parameters

* **LEADING | TRAILING | BOTH**: Specifies which side(s) of the string to trim. The default is `BOTH`.
  * **LEADING**: Trims characters from the beginning of the string.
  * **TRAILING**: Trims characters from the end of the string.
  * **BOTH**: Trims characters from both the beginning and the end of the string.
* **trim\_character**: The character to be trimmed from the string. If not specified, spaces are trimmed by default.
* **string**: The string expression from which the characters are to be trimmed.

#### Return Value

The function returns a new string with the specified characters removed from the specified side(s).

#### Examples

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

### LOWER

#### Description

The `LOWER` function converts all characters in a string to lowercase.

#### **Syntax**

```sql
LOWER(string)
```

#### **Parameters**

* **string**: The input string to be converted to lowercase.

#### **Return Value**

The function returns a new string with all characters converted to lowercase.

#### **Examples**

```
SELECT LOWER('Hello World') AS lower_string FROM DUAL;
-- Output -> hello world

SELECT LOWER(FIRST_NAME) AS lower_name FROM employees;
```

### UPPER

#### Description

The `UPPER` function converts all characters in a string to uppercase.

#### **Syntax**

```sql
UPPER(string)
```

#### **Parameters**

* **string**: The input string to be converted to uppercase.

#### **Return Value**

The function returns a new string with all characters converted to uppercase.

#### **Examples**

```
SELECT UPPER('Hello World') AS upper_string FROM DUAL;
-- Output -> HELLO WORLD

SELECT UPPER(FIRST_NAME) AS upper_name FROM employees;
```

### RPAD

#### Description

The `RPAD` function pads the right side of a string with a specified character to a specified length.

#### **Syntax**

```sql
RPAD(string, length, [pad_string])
```

#### **Parameters**

* **string**: The input string to be padded.
* **length**: The total length of the resulting string after padding.
* **pad\_string** (optional): The string to pad with. If not specified, spaces are used.

#### **Return Value**

The function returns a new string of the specified length, padded with the specified character (or spaces) on the right side.

#### **Examples**

```
-- Pad a string with spaces to a length of 10
SELECT RPAD('Hello', 10) AS padded_string FROM DUAL;
-- Output -> Hello     

-- Pad a string with asterisks (*) to a length of 10
SELECT RPAD('Hello', 10, '*') AS padded_string FROM DUAL;
-- Output -> Hello*****

SELECT RPAD(FIRST_NAME, 15, '-') AS padded_name FROM employees;
```

### LPAD

#### Description

The `LPAD` function pads the left side of a string with a specified character to a specified length.

#### **Syntax**

```sql
LPAD(string, length, [pad_string])
```

#### **Parameters**

* **string**: The input string to be padded.
* **length**: The total length of the resulting string after padding.
* **pad\_string** (optional): The string to pad with. If not specified, spaces are used.

#### **Return Value**

The function returns a new string of the specified length, padded with the specified character (or spaces) on the left side.

#### **Examples**

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

### SUBSTR

#### Description

The `SUBSTR` function in Oracle extracts a substring from a string, starting from a specified position and optionally for a specified length.

#### Syntax

```sql
SUBSTR(string, start_position, [length])
```

#### Parameters

* **string**: The input string from which the substring will be extracted.
* **start\_position**: The position at which the extraction starts. This is a 1-based index.
  * If `start_position` is positive, it starts from the beginning of the string.
  * If `start_position` is negative, it starts from the end of the string and counts backwards.
* **length** (optional): The number of characters to extract. If omitted, the function returns the substring from `start_position` to the end of the string.

{% hint style="info" %}
**Positive Start Position**: Starts extracting from the beginning of the string.

**Negative Start Position**: Starts extracting from the end of the string.

**Length**: If not specified, extraction goes to the end of the string.

**Return Value**: Returns `NULL` if `start_position` is beyond the string length or if `length` is less than or equal to 0
{% endhint %}

#### Return Value

The function returns a substring of the specified length starting from the specified position. If `start_position` is beyond the length of the string, the function returns `NULL`. If `length` is less than or equal to 0, the function returns `NULL`.

#### Examples

```
-- Extract a substring from the 7th character to the end of the string
SELECT SUBSTR('Hello World', 7) AS substring FROM DUAL;
-- Output -> World

-- Extract 5 characters starting from the 1st character
SELECT SUBSTR('Hello World', 1, 5) AS substring FROM DUAL;
-- Output -> Hello

-- Extract 5 characters starting from the 6th character from the end
SELECT SUBSTR('Hello World', -6, 5) AS substring FROM DUAL;
-- Output -> World

-- Extracting from a Column
SELECT FIRST_NAME, SUBSTR(FIRST_NAME, 1, 3) AS first_three_chars
FROM employees;
```

### INSTR

#### Description

The `INSTR` function in Oracle is used to search for a substring within a string and return the position at which the substring is found. If the substring is not found, it returns 0. This function is useful for string manipulation and searching within text data.

#### Syntax

```sql
INSTR(string, substring [, start_position [, nth_appearance]])
```

#### Parameters

* **string**: The string to be searched.
* **substring**: The substring to search for.
* **start\_position** (optional): The position in the string to start the search. The default is 1.
* **nth\_appearance** (optional): Specifies which occurrence of the substring to search for. The default is 1.

#### Return Value

The function returns the position of the first character of the nth occurrence of the substring in the string. If the substring is not found, it returns 0.

#### Examples

<pre><code>SELECT INSTR('Oracle Database', 'a') AS position
FROM DUAL;
-- Output -> 2

SELECT INSTR('Oracle Database', 'a', 3) AS position
FROM DUAL;
-- Output -> 8

SELECT INSTR('Oracle Database', 'a', 1, 2) AS position
FROM DUAL;
-- Output -> 12

SELECT INSTR('Oracle Database', 'x') AS position
FROM DUAL;
<strong>-- Output -> 0
</strong></code></pre>

### REGEXP\_LIKE

#### Description

The `REGEXP_LIKE` function in Oracle is used to perform regular expression matching. It is a powerful function for pattern matching and is particularly useful for complex search conditions. It allows to search for a string that matches a regular expression pattern.

#### Syntax

```sql
REGEXP_LIKE(source_string, pattern [, match_parameter])
```

#### Parameters

* **source\_string**: The string to be searched.
* **pattern**: The regular expression pattern to search for.
* **match\_parameter** (optional): A string that can include one or more of the following modifiers:
  * `'i'`: Case-insensitive matching.
  * `'c'`: Case-sensitive matching (default).
  * `'n'`: The period `.` does not match the newline character.
  * `'m'`: The string is treated as multiple lines. The `^` and `$` match the start and end of any line within the source string.

#### Common regular expression symbols

<table><thead><tr><th width="224">Symbol</th><th>Description</th></tr></thead><tbody><tr><td><code>^</code></td><td>Matches the start of a string.</td></tr><tr><td><code>$</code></td><td>Matches the end of a string.</td></tr><tr><td><code>.</code></td><td>Matches any single character except newline.</td></tr><tr><td><code>[]</code></td><td>Matches any single character within the brackets.</td></tr><tr><td><code>[^]</code></td><td>Matches any single character not within the brackets.</td></tr><tr><td><code>*</code></td><td>Matches 0 or more occurrences of the preceding element.</td></tr><tr><td><code>+</code></td><td>Matches 1 or more occurrences of the preceding element.</td></tr><tr><td><code>?</code></td><td>Matches 0 or 1 occurrence of the preceding element.</td></tr><tr><td><code>{n}</code></td><td>Matches exactly n occurrences of the preceding element.</td></tr><tr><td><code>{n,}</code></td><td>Matches n or more occurrences of the preceding element.</td></tr><tr><td><code>{n,m}</code></td><td>Matches at least n and at most m occurrences of the preceding element.</td></tr><tr><td><code>\d</code></td><td>Matches any digit (equivalent to <code>[0-9]</code>).</td></tr><tr><td><code>\D</code></td><td>Matches any non-digit.</td></tr><tr><td><code>\w</code></td><td>Matches any word character (alphanumeric plus underscore).</td></tr><tr><td><code>\W</code></td><td>Matches any non-word character.</td></tr><tr><td><code>\s</code></td><td>Matches any whitespace character (space, tab, newline).</td></tr><tr><td><code>\S</code></td><td>Matches any non-whitespace character.</td></tr><tr><td><code>\b</code></td><td>Matches a word boundary.</td></tr><tr><td><code>\B</code></td><td>Matches a non-word boundary.</td></tr><tr><td><code>()</code></td><td>Groups expressions and captures the matched text.</td></tr><tr><td><code>(?:...)</code></td><td>Groups expressions without capturing the matched text.</td></tr><tr><td><code>(?=...)</code></td><td>Positive lookahead; matches if the expression within the parentheses can be matched.</td></tr><tr><td><code>(?!...)</code></td><td>Negative lookahead; matches if the expression within the parentheses cannot be matched.</td></tr><tr><td><code>(?&#x3C;=...)</code></td><td>Positive lookbehind; matches if the preceding text matches the expression within the parentheses.</td></tr><tr><td><code>(?&#x3C;!...)</code></td><td>Negative lookbehind; matches if the preceding text does not match the expression within the parentheses.</td></tr><tr><td><code>\</code></td><td>Escapes a special character to match it literally.</td></tr></tbody></table>

#### Examples

```
-- Return employees whose first name starts with 'J'
SELECT first_name FROM employees WHERE REGEXP_LIKE(first_name, '^J');

-- Case-Insensitive Matching
SELECT first_name FROM employees
WHERE REGEXP_LIKE(first_name, '^j', 'i');

-- Return employees whose first name is either 'John' or 'Jane'
SELECT first_name FROM employees
WHERE REGEXP_LIKE(first_name, '^(John|Jane)$');

-- Returns employees whose first name contains any digit
SELECT first_name FROM employees
WHERE REGEXP_LIKE(first_name, '[0-9]');

-- Returns employees whose first name starts with 'A' and is exactly 4 characters long
SELECT first_name FROM employees
WHERE REGEXP_LIKE(first_name, '^A.{3}$');

-- Returns employees whose first name ends with 'smith', regardless of case
SELECT first_name FROM employees
WHERE REGEXP_LIKE(first_name, 'smith$', 'i');

-- Returns comments that contain lines starting with 'Thank you', treating the comment as multiple lines
SELECT comment FROM feedback
WHERE REGEXP_LIKE(comment, '^Thank you', 'm')

-- Check if a string is exactly 4 characters long
SELECT 'Match' AS result
FROM DUAL
WHERE REGEXP_LIKE('Test', '^.{4}$');

-- Check if a string contains 'abc' and is not affected by newlines
SELECT 'Match' AS result
FROM DUAL
WHERE REGEXP_LIKE('abc\ndef', 'abc', 'n');

-- Check if any line in a multiline string starts with 'Hello'
SELECT 'Match' AS result
FROM DUAL
WHERE REGEXP_LIKE('First line\nHello world', '^Hello', 'm');

-- Check if a string does not contain any digits
SELECT 'Match' AS result
FROM DUAL
WHERE REGEXP_LIKE('HelloWorld', '^\D*$');
```

### REGEXP\_REPLACE

The `REGEXP_REPLACE` function in Oracle is used to search a string for a regular expression pattern and replace it with another string. It is useful for advanced string manipulation where patterns and replacements can be specified with regular expressions.

#### Syntax

```sql
REGEXP_REPLACE(source_string, pattern, replace_string [, position [, occurrence [, match_parameter]]])
```

#### Parameters

* **source\_string**: The string to search within.
* **pattern**: The regular expression pattern to search for.
* **replace\_string**: The string to replace the matched pattern with.
* **position** (optional): The position in the source string to start the search. The default is 1.
* **occurrence** (optional): The occurrence of the pattern to be replaced. The default is 0, meaning all occurrences.
* **match\_parameter** (optional): A string that can include one or more of the following modifiers:
  * `'i'`: Case-insensitive matching.
  * `'c'`: Case-sensitive matching (default).
  * `'n'`: The period `.` does not match the newline character.
  * `'m'`: The string is treated as multiple lines. The `^` and `$` match the start and end of any line within the source string.

#### Examples

```
-- Replace all occurrences of a pattern
SELECT REGEXP_REPLACE('123abc456', '[0-9]', 'X') AS result
FROM DUAL;
-- Output -> XXXabcXXX

-- Replace First Occurrence
SELECT REGEXP_REPLACE('123abc456', '[0-9]', 'X', 1, 1) AS result
FROM DUAL;
-- Output -> X23abc456

-- Replace all occurrences of a pattern, ignoring case
SELECT REGEXP_REPLACE('abcABCabc', 'a', 'X', 1, 0, 'i') AS result
FROM DUAL;
-- Output -> XbcXBCXbc

-- Use captured groups in the replacement string
SELECT REGEXP_REPLACE('abc123', '([a-z]+)([0-9]+)', '\2\1') AS result
FROM DUAL;
-- Output -> 123abc

-- Replace all non-word characters with a space
SELECT REGEXP_REPLACE('Hello, World! 123.', '\W', ' ') AS result
FROM DUAL;
-- Output -> Hello World 123

-- Remove all digits from a string
SELECT REGEXP_REPLACE('Phone: 123-456-7890', '\d', '') AS result
FROM DUAL;
-- Output -> Phone: --

-- Replace the first character of each line in a multiline string
SELECT REGEXP_REPLACE('Line1\nLine2\nLine3', '^.', 'X', 1, 0, 'm') AS result
FROM DUAL;
-- Output -> Xine1\nXine2\nXine3
```

## Datatype Conversion

### CAST&#x20;

#### Description

The `CAST` function in Oracle is used to convert one data type to another. It is a versatile function that allows to change the data type of an expression to a different data type, which is particularly useful when dealing with different types of data in queries.

#### Syntax

```sql
CAST(expression AS target_data_type)
```

#### Parameters

* **expression**: The value or column that you want to convert.
* **target\_data\_type**: The data type to which you want to convert the expression.

#### Supported Data Types

The `CAST` function supports conversion to and from a wide range of data types like

* VARCHAR2, CHAR
* NUMBER, INTEGER, FLOAT
* DATE, TIMESTAMP
* BLOB, CLOB

#### Examples

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

## Hierarchical Function

### SYS\_CONNECT\_BY\_PATH

#### Description

The `SYS_CONNECT_BY_PATH` function in Oracle is used in hierarchical queries to return the path of a column value from the root to the current row in a tree-structured format. It is particularly useful for displaying hierarchical relationships in a readable format.

#### Syntax

```sql
SYS_CONNECT_BY_PATH(column, delimiter)
```

#### Parameters

* **column**: The column for which the path is to be constructed.
* **delimiter**: The character or string that separates the levels in the hierarchy.

#### Return Value

The function returns a string that represents the path from the root node to the current node, with each level separated by the specified delimiter.

#### Usage Context

The `SYS_CONNECT_BY_PATH` function is used in the context of hierarchical queries, which are queries that use the `CONNECT BY` clause to define parent-child relationships within the data.

{% hint style="info" %}
If the column used in `SYS_CONNECT_BY_PATH` is `NULL`, it includes the `NULL` values in the path.
{% endhint %}

#### Examples

1. **Employee Manager Hierarchy**

We have an `employees` table with columns `EMPLOYEE_ID`, `MANAGER_ID`, and `FIRST_NAME`. We need to display the hierarchical path of employee names with the help of `SYS_CONNECT_BY_PATH`

```
SELECT EMPLOYEE_ID, FIRST_NAME, 
       SYS_CONNECT_BY_PATH(FIRST_NAME, ' -> ') AS hierarchy_path
FROM employees
START WITH MANAGER_ID IS NULL
CONNECT BY PRIOR EMPLOYEE_ID = MANAGER_ID;
```

Sample Output

<figure><img src="../../../../../.gitbook/assets/image (4) (1) (1) (1).png" alt="" width="563"><figcaption></figcaption></figure>

2. Create sequence or generate data

```
SELECT LEVEL, SYS_CONNECT_BY_PATH(LEVEL, ' -> ') AS level_path
FROM DUAL
CONNECT BY LEVEL <= 5;
```

Sample Output

<figure><img src="../../../../../.gitbook/assets/image (5) (1) (1).png" alt="" width="452"><figcaption></figcaption></figure>

## Null Handling Functions

### NVL

#### Description

The `NVL` function in Oracle is used to replace `NULL` values with a specified value. This function is particularly useful when dealing with potential `NULL` values in your data and you want to ensure that your results are complete and meaningful.

#### Syntax

```sql
NVL(expression1, expression2)
```

#### Parameters

* **expression1**: The expression to be checked for `NULL`.
* **expression2**: The value to be returned if `expression1` is `NULL`.

#### Return Value

The function returns `expression2` if `expression1` is `NULL`. If `expression1` is not `NULL`, it returns `expression1`.

#### Examples

```
SELECT NVL(NULL, 'Default Value') AS result FROM DUAL;
-- Output -> Default Value

SELECT FIRST_NAME, NVL(FIRST_NAME, 'Unknown') AS name
FROM employees;
```

### COALESCE

#### Description

The `COALESCE` function in Oracle is used to return the first non-null expression among its arguments. It's a more versatile and flexible alternative to the `NVL` function, as it can handle multiple expressions and return the first one that is not `NULL`.

#### Syntax

```sql
COALESCE(expr1, expr2, ..., exprn)
```

#### Parameters

* **expr1, expr2, ..., exprn**: The expressions to be evaluated in the order they are provided. The function returns the first non-null expression.

{% hint style="info" %}
`COALESCE` stops evaluating expressions once it finds the first non-null expression, potentially improving performance.
{% endhint %}

#### Return Value

The function returns the first non-null expression among its arguments. If all arguments are `NULL`, it returns `NULL`.

#### Examples

```
-- Return the first non-null value
SELECT COALESCE(NULL, NULL, 'First Non-Null', 'Second Non-Null') AS result
FROM DUAL;
-- Output -> First Non-Null

-- Employees table with columns commission_pct, bonus, and salary
SELECT employee_id, 
       COALESCE(commission_pct, bonus, salary) AS compensation
FROM employees;

```

## Arithmetic Functions

### AVG

The `AVG` function calculates the average value of a numeric column.

#### **Syntax**

```sql
SELECT AVG(column_name) AS avg_value
FROM table_name;
```

### MIN

The `MIN` function returns the smallest value in a set.

#### **Syntax**

```sql
SELECT MIN(column_name) AS min_value
FROM table_name;
```

### MAX

The `MAX` function returns the largest value in a set.

#### **Syntax**

```sql
SELECT MAX(column_name) AS max_value
FROM table_name;
```

### COUNT

The `COUNT` function returns the number of rows that match a specified condition.

#### **Syntax**

```sql
SELECT COUNT(column_name) AS count_value
FROM table_name;
```

### SUM

The `SUM` function returns the total sum of a numeric column.

#### **Syntax**

```sql
SELECT SUM(column_name) AS sum_value
FROM table_name;
```

{% hint style="info" %}
When we do COUNT(\*), counting is rows (regardless of actual value, which is why rows containing NULL and non-NULL values are counted). But when we do COUNT a column, we are counting the number of non-NULL values in that column.
{% endhint %}

### EXP

The `EXP` function returns `e` raised to the power of a given number. The constant `e` is approximately equal to 2.71828.

#### **Syntax**

```sql
SELECT EXP(2) AS exp_value
FROM DUAL;
-- Output -> 7.389056
```

### LN

The `LN` function returns the natural logarithm (base `e`) of a given number.

#### **Syntax**

```sql
SELECT LN(7.389056) AS ln_value
FROM DUAL;
-- Output -> 2
```

### LOG

The `LOG` function returns the logarithm of a given number with a specified base.

#### **Syntax**

```sql
SELECT LOG(base, n) AS log_value
FROM DUAL;
```

### POWER

The `POWER` function returns a number raised to the power of another number.

#### **Syntax**

```sql
SELECT POWER(m, n) AS power_value
FROM DUAL;
```

### SQRT

The `SQRT` function returns the square root of a given number.

#### **Syntax**

```
SELECT SQRT(n) AS sqrt_value
FROM DUAL;
```

### ROUND

The `ROUND` function returns a number rounded to a specified number of decimal places.

#### **Syntax**

```sql
SELECT ROUND(n, decimals) AS rounded_value
FROM DUAL;
```

#### **Example**

Round 123.4567 to two decimal places:

```sql
SELECT ROUND(123.4567, 2) AS rounded_value
FROM DUAL;
-- Output -> 123.46
```

### TRUNC

The `TRUNC` function truncates a number to a specified number of decimal places, effectively removing the fractional part beyond the specified decimal places.

**Syntax**

```sql
SELECT TRUNC(n, decimals) AS truncated_value
FROM DUAL;
```

**Example**

Truncate 123.4567 to two decimal places:

```sql
SELECT TRUNC(123.4567, 2) AS truncated_value
FROM DUAL;
-- Output -> 123.45
```

### MOD

The `MOD` function returns the remainder of a division operation.

#### **Syntax**

```sql
SELECT MOD(m, n) AS mod_value
FROM DUAL;
```

#### **Example**

Calculate the remainder of 10 divided by 3:

```sql
SELECT MOD(10, 3) AS mod_value
FROM DUAL;
-- Output -> 1
```

### CEIL

The `CEIL` function returns the smallest integer greater than or equal to a given number.

**Syntax**

```sql
SELECT CEIL(n) AS ceil_value
FROM DUAL;
```

**Example**

Calculate the ceiling of 123.456:

```sql
SELECT CEIL(123.456) AS ceil_value
FROM DUAL;
-- Output -> 124
```

### FLOOR

The `FLOOR` function returns the largest integer less than or equal to a given number.

#### **Syntax**

```sql
SELECT FLOOR(n) AS floor_value
FROM DUAL;
```

#### **Example**

Calculate the floor of 123.456:

```sql
SELECT FLOOR(123.456) AS floor_value
FROM DUAL;
-- Output -> 123
```

### ABS

The `ABS` function returns the absolute value of a number.

**Syntax**

```sql
SELECT ABS(n) AS abs_value
FROM DUAL;
```

**Example**

Calculate the absolute value of -123.456:

```sql
SELECT ABS(-123.456) AS abs_value
FROM DUAL;
-- Output -> 123.456
```

### MEDIAN

The `MEDIAN` function computes the median of a set of values. The median is the value separating the higher half from the lower half of a data sample.

#### **Syntax**

```sql
MEDIAN(value_expression) OVER ( [partition_by_clause] order_by_clause )
```

#### **Example**

Assume we have a table `employees` with a `salary` column. To calculate the median salary for the entire table:

```sql
-- calculate the median salary for the entire table
SELECT 
    MEDIAN(salary) OVER () AS median_salary
FROM 
    employees;
    
-- calculate the median salary for each department
SELECT 
    department_id, 
    MEDIAN(salary) OVER (PARTITION BY department_id) AS median_salary
FROM 
    employees;    
```

### PERCENTILE\_CONT

The `PERCENTILE_CONT` function is an inverse distribution function that returns the value corresponding to the specified percentile in a group of values.

#### **Syntax**

```sql
PERCENTILE_CONT(percentile) WITHIN GROUP (ORDER BY value_expression) 
OVER ( [partition_by_clause] )
```

* **percentile**: A numeric value between 0 and 1. For example, 0.5 represents the 50th percentile (median).
* **value\_expression**: The column or expression on which the percentile calculation is performed.

**Example**

Calculate the median (50th percentile) salary for the entire table:

```sql
SELECT 
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary) AS median_salary
FROM 
    employees;
```

Calculate the 90th percentile salary for each department:

```sql
SELECT 
    department_id, 
    PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY salary) 
    OVER (PARTITION BY department_id) AS perc90_salary
FROM 
    employees;
```



## Window functions

Window functions in SQL, also known as analytic functions, allows to perform calculations across a set of table rows that are somehow related to the current row. This is similar to aggregate functions but unlike aggregate functions, window functions do not cause rows to become grouped into a single output row—the rows retain their separate identities.

### LAG

The `LAG` function provides access to a row at a given physical offset prior to the current row within the partition.

#### **Syntax**

```sql
LAG(value_expression [, offset] [, default]) OVER ( [partition_by_clause] order_by_clause )
```

* **value\_expression**: The column or expression to evaluate.
* **offset**: The number of rows back from the current row from which to obtain the value (default is 1).
* **default**: The value to return if the offset goes out of the bounds of the partition.

**Example**

```sql
--  Get the hire date of the previous employee for each row in the employees table
SELECT 
    employee_id, 
    hire_date, 
    LAG(hire_date, 1) OVER (ORDER BY hire_date) AS prev_hire_date
FROM 
    employees;
```

### LEAD

The `LEAD` function provides access to a row at a given physical offset following the current row within the partition.

#### **Syntax**

```sql
LEAD(value_expression [, offset] [, default]) OVER ( [partition_by_clause] order_by_clause )
```

* **value\_expression**: The column or expression to evaluate.
* **offset**: The number of rows back from the current row from which to obtain the value (default is 1).
* **default**: The value to return if the offset goes out of the bounds of the partition.

#### **Example**

```sql
-- Get the hire date of the previous employee for each row in the employees table
SELECT 
    employee_id, 
    hire_date, 
    LEAD(hire_date, 1) OVER (ORDER BY hire_date) AS next_hire_date
FROM 
    employees;
```

### ROW\_NUMBER

The `ROW_NUMBER` function assigns a unique number to each row to which it is applied, starting from 1.

#### **Syntax**

```sql
ROW_NUMBER() OVER ( [partition_by_clause] order_by_clause )
```

#### **Example**

```sql
-- Assign a unique rank to each employee based on their salary in descending order
SELECT 
    employee_id, 
    salary, 
    ROW_NUMBER() OVER (ORDER BY salary DESC) AS rank
FROM 
    employees;
```

### RANK

The `RANK` function provides the rank of a row within the partition of a result set. The rank of a row is one plus the number of ranks that come before it.

#### **Syntax**

```sql
RANK() OVER ( [partition_by_clause] order_by_clause )
```

**Example**

```sql
-- Ranks employees based on their salary, in descending order. 
-- Rows with equal values receive the same rank, and the next rank value will be skipped.
SELECT 
    employee_id, 
    salary, 
    RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM 
    employees;
```

### DENSE\_RANK

The `DENSE_RANK` function is similar to `RANK`, but it does not skip rank values if there are ties.

#### **Syntax**

```sql
DENSE_RANK() OVER ( [partition_by_clause] order_by_clause )
```

#### **Example**

<pre class="language-sql"><code class="lang-sql"><strong>-- Ranks employees based on their salary, in descending order, without skipping any rank values.
</strong><strong>SELECT 
</strong>    employee_id, 
    salary, 
    DENSE_RANK() OVER (ORDER BY salary DESC) AS salary_dense_rank
FROM 
    employees;
</code></pre>

### NTILE

The `NTILE` function distributes the rows in an ordered partition into a specified number of groups, and assigns a number to each row indicating the group to which it belongs.

#### **Syntax**

```sql
NTILE(num_buckets) OVER ( [partition_by_clause] order_by_clause )
```

#### **Example**

<pre class="language-sql"><code class="lang-sql"><strong>-- Divides the employees into four groups based on their salary, 
</strong><strong>-- and assigns each row a number indicating its quartile.
</strong><strong>SELECT 
</strong>    employee_id, 
    salary, 
    NTILE(4) OVER (ORDER BY salary DESC) AS salary_quartile
FROM 
    employees;
</code></pre>

## Date Functions

### ADD\_MONTHS

The `ADD_MONTHS` function adds a specified number of months to a date.

#### **Syntax**

```sql
ADD_MONTHS(date, number_of_months)
```

* **date**: The starting date.
* **number\_of\_months**: The number of months to add (can be positive or negative).

#### **Example**

```
-- Add 3 months to the current dat
SELECT ADD_MONTHS(SYSDATE, 3) AS new_date
FROM DUAL;

-- Subtract 2 months from a specific date
SELECT ADD_MONTHS(TO_DATE('2023-05-25', 'YYYY-MM-DD'), -2) AS new_date
FROM DUAL;
```

### TO\_CHAR (with Date Formatting)

The `TO_CHAR` function converts a date or number to a string using a specified format.

#### **Syntax**

```sql
TO_CHAR(date, 'format_model')
```

* **date**: The date value to be converted.
* **format\_model**: The format in which the date should be returned. Common format models include:
  * `'YYYY'`: Four-digit year.
  * `'MM'`: Two-digit month.
  * `'DD'`: Two-digit day.
  * `'DY'`: Three-character day of the week (e.g., MON, TUE).
  * `'HH24'`: Hour of the day in 24-hour format.
  * `'MI'`: Minutes.
  * `'SS'`: Seconds.

#### **Example**

```
SELECT 
    TO_CHAR(SYSDATE, 'YYYY-MM-DD') AS formatted_date,
    TO_CHAR(SYSDATE, 'DY') AS day_of_week,
    TO_CHAR(SYSDATE, 'HH24:MI:SS') AS time_of_day
FROM DUAL;
```

<figure><img src="../../../../../.gitbook/assets/image (114).png" alt="" width="317"><figcaption></figcaption></figure>

### TO\_DATE

The `TO_DATE` function converts a string to a date using a specified format.

#### **Syntax**

```sql
TO_DATE(string, 'format_model')
```

* **string**: The string to be converted to a date.
* **format\_model**: The format in which the string is provided. The format model should match the string format.

#### **Example**

```
SELECT 
    TO_DATE('2024-05-25', 'YYYY-MM-DD') AS converted_date
FROM DUAL;

SELECT 
    TO_DATE('25-MAY-2024 14:30:00', 'DD-MON-YYYY HH24:MI:SS') AS converted_date
FROM DUAL;
```

### MONTHS\_BETWEEN

The `MONTHS_BETWEEN` function returns the number of months between two dates. The result can include a fractional part if the dates are not exactly a whole number of months apart.

#### **Syntax**

```sql
MONTHS_BETWEEN(date1, date2)
```

* **date1**: The later date.
* **date2**: The earlier date.

#### **Example**

```
SELECT 
    MONTHS_BETWEEN(TO_DATE('2024-05-25', 'YYYY-MM-DD'), TO_DATE('2024-01-15', 'YYYY-MM-DD')) AS months_diff
FROM 
    DUAL;
-- Output -> 4.3225806
```

### TRUNC

The `TRUNC` function truncates a date to the specified unit of measure. This function is often used to remove the time portion of a date or to truncate the date to a specific level (e.g., year, month).

#### **Syntax**

```sql
TRUNC(date [, format])
```

* **date**: The date to be truncated.
* **format**: The unit of measure to truncate the date to (optional). Common format models include:
  * `'YYYY'`: Truncate to the first day of the year.
  * `'MM'`: Truncate to the first day of the month.
  * `'DD'`: Truncate to midnight of the current day (default if format is not specified).

#### Example

```
SELECT 
    TRUNC(TO_DATE('2024-05-25 14:30:00', 'YYYY-MM-DD HH24:MI:SS')) AS trunc_day,
    TRUNC(TO_DATE('2024-05-25 14:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'MM') AS trunc_month,
    TRUNC(TO_DATE('2024-05-25 14:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'YYYY') AS trunc_year
FROM 
    DUAL;
```

<figure><img src="../../../../../.gitbook/assets/image (116).png" alt=""><figcaption></figcaption></figure>

### LAST\_DAY

The `LAST_DAY` function returns the last day of the month that contains the specified date.

#### **Syntax**

```sql
LAST_DAY(date)
```

* **date**: The date from which to determine the last day of the month.

#### **Example**

```sql
-- Get the last day of the month for a specific date
SELECT 
    LAST_DAY(TO_DATE('2024-05-15', 'YYYY-MM-DD')) AS last_day_of_month
FROM 
    DUAL;
-- Output --> 2024-05-31
```

### NEXT\_DAY

The `NEXT_DAY` function returns the date of the first specified weekday that is later than the given date.

#### **Syntax**

```sql
NEXT_DAY(date, 'day_of_week')
```

* **date**: The starting date.
* **day\_of\_week**: The name of the weekday (in English). It can be abbreviated (e.g., 'MON' for Monday).

#### **Example**

<pre class="language-sql"><code class="lang-sql"><strong>-- Find the next Monday after a specific date
</strong><strong>SELECT 
</strong>    NEXT_DAY(TO_DATE('2024-05-15', 'YYYY-MM-DD'), 'MONDAY') AS next_monday
FROM 
    DUAL;
-- Output --> 2024-05-20
</code></pre>

### EXTRACT

The `EXTRACT` function extracts a specific part of a date (such as year, month, day, hour, minute, second) or an interval.

#### **Syntax**

```sql
EXTRACT(part FROM date)
```

* **part**: The part of the date to extract. Common parts include `YEAR`, `MONTH`, `DAY`, `HOUR`, `MINUTE`, `SECOND`.
* **date**: The date from which to extract the part.

#### **Example**

```sql
-- Extract the year, month, and day from a date
SELECT 
    EXTRACT(YEAR FROM TO_DATE('2024-05-15', 'YYYY-MM-DD')) AS year,
    EXTRACT(MONTH FROM TO_DATE('2024-05-15', 'YYYY-MM-DD')) AS month,
    EXTRACT(DAY FROM TO_DATE('2024-05-15', 'YYYY-MM-DD')) AS day
FROM 
    DUAL;
-- Output
--YEAR	MONTH	DAY
--2024	5	15
```

## Conditional Functions

### DECODE&#x20;

The `DECODE` function provides functionality similar to a CASE statement. It allows to perform conditional querying and can transform data within a query based on specific conditions.

#### **Syntax**

```sql
DECODE(expression, search1, result1, search2, result2, ..., default)
```

* **expression**: The value to be evaluated.
* **search1, search2, ...**: The values to compare against the expression.
* **result1, result2, ...**: The results to return if the corresponding search value matches the expression.
* **default**: The default result to return if no match is found (optional).

#### **Example**

Suppose we have an `employees` table with an `employee_id` and a `department_id`, and want to translate department IDs into department names.

```sql
SELECT
    employee_id,
    department_id,
    DECODE(department_id,
           10, 'Finance',
           20, 'HR',
           30, 'IT',
           40, 'Sales',
           'Unknown') AS department_name
FROM
    employees;
```

### CASE&#x20;

The `CASE` statement in Oracle SQL is a versatile conditional expression that allows to implement conditional logic directly in your SQL queries. It is similar to the `DECODE` function but more powerful and flexible because it can handle complex conditions and multiple data types.

#### Syntax

There are two types of `CASE` statements: the simple `CASE` statement and the searched `CASE` statement.

#### **Simple CASE Statement**

The simple `CASE` statement compares an expression to a set of simple expressions to determine the result.

```sql
CASE expression
    WHEN value1 THEN result1
    WHEN value2 THEN result2
    ...
    ELSE default_result
END
```

#### **Searched CASE Statement**

The searched `CASE` statement evaluates a set of Boolean expressions to determine the result.

```sql
CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    ...
    ELSE default_result
END
```

#### Examples

**Example 1: Simple CASE Statement**

Suppose we have an `employees` table with columns `employee_id`, `first_name`, `last_name`, and `department_id`, and want to translate department IDs into department names.

```sql
SELECT
    employee_id,
    first_name,
    last_name,
    department_id,
    CASE department_id
        WHEN 10 THEN 'Finance'
        WHEN 20 THEN 'HR'
        WHEN 30 THEN 'IT'
        WHEN 40 THEN 'Sales'
        ELSE 'Unknown'
    END AS department_name
FROM
    employees;
```

#### **Example 2: Searched CASE Statement**

Suppose we want to classify employees based on their salary ranges.

```sql
SELECT
    employee_id,
    first_name,
    last_name,
    salary,
    CASE
        WHEN salary < 30000 THEN 'Low'
        WHEN salary BETWEEN 30000 AND 70000 THEN 'Medium'
        WHEN salary > 70000 THEN 'High'
        ELSE 'Unknown'
    END AS salary_level
FROM
    employees;
```

#### **Example 3: Combining CASE with Other SQL Features**

You can combine the `CASE` statement with other SQL clauses such as `ORDER BY` and `FETCH FIRST`.

```sql
SELECT
    employee_id,
    first_name,
    last_name,
    salary,
    department_id,
    CASE department_id
        WHEN 10 THEN 'Finance'
        WHEN 20 THEN 'HR'
        WHEN 30 THEN 'IT'
        WHEN 40 THEN 'Sales'
        ELSE 'Unknown'
    END AS department_name,
    CASE
        WHEN salary < 30000 THEN 'Low'
        WHEN salary BETWEEN 30000 AND 70000 THEN 'Medium'
        WHEN salary > 70000 THEN 'High'
        ELSE 'Unknown'
    END AS salary_level
FROM
    employees
ORDER BY
    salary DESC
FETCH FIRST 5 ROWS ONLY;
```

## Advanced Aggregation Function

### GROUPING Function

The `GROUPING` function is used to distinguish between a detail row and an aggregate row created by a `ROLLUP` or `CUBE` operation. It returns `1` for a row created by `ROLLUP` or `CUBE` and `0` for a regular row.

#### **Syntax**

```sql
GROUPING(column_name)
```

#### Example 1

```
SELECT
    product_id,
    region_id,
    SUM(sales_amount) AS total_sales,
    GROUPING(product_id) AS is_product_total,
    GROUPING(region_id) AS is_region_total
FROM
    (
        SELECT 1 AS product_id, 1 AS region_id, 100 AS sales_amount FROM dual UNION ALL
        SELECT 1 AS product_id, 2 AS region_id, 150 AS sales_amount FROM dual UNION ALL
        SELECT 2 AS product_id, 1 AS region_id, 200 AS sales_amount FROM dual UNION ALL
        SELECT 2 AS product_id, 2 AS region_id, 250 AS sales_amount FROM dual
    )
GROUP BY ROLLUP (product_id, region_id);

```

{% hint style="info" %}
* `is_product_total` is `1` when the row is a product subtotal.
* `is_region_total` is `1` when the row is a region subtotal.
* Both are `1` when the row is the grand total.
{% endhint %}

<figure><img src="../../../../../.gitbook/assets/image (8) (1).png" alt="" width="482"><figcaption></figcaption></figure>

#### Example 2

```
SELECT
    product_id,
    SUM(sales_amount) AS total_sales,
    GROUPING(product_id) AS is_product_total
FROM
    (
        SELECT 1 AS product_id, 1 AS region_id, 100 AS sales_amount FROM dual UNION ALL
        SELECT 1 AS product_id, 2 AS region_id, 150 AS sales_amount FROM dual UNION ALL
        SELECT 2 AS product_id, 1 AS region_id, 200 AS sales_amount FROM dual UNION ALL
        SELECT 2 AS product_id, 2 AS region_id, 250 AS sales_amount FROM dual
    )
GROUP BY ROLLUP (product_id);
```

<figure><img src="../../../../../.gitbook/assets/image (9) (1).png" alt="" width="315"><figcaption></figcaption></figure>

### ROLLUP Function

The `ROLLUP` function is an extension to the `GROUP BY` clause that creates subtotals and a grand total. It allows you to create aggregate values at multiple levels of a hierarchy.

#### **Syntax**

```sql
SELECT
    columns,
    aggregate_function(column_name)
FROM
    table
GROUP BY ROLLUP (columns);
```

#### ROLLUP vs CUBE

<table data-full-width="true"><thead><tr><th width="223">Feature</th><th>CUBE</th><th>ROLLUP</th></tr></thead><tbody><tr><td>Purpose</td><td>Generates subtotals for all possible combinations of a set of dimensions.</td><td>Generates subtotals and grand totals for a hierarchical set of dimensions.</td></tr><tr><td>Hierarchical Levels</td><td>Covers all combinations of the specified columns, resulting in a full cross-tabulation of subtotals.</td><td>Covers a hierarchy of the specified columns, resulting in subtotal rows at each level of the hierarchy and a grand total.</td></tr><tr><td>Number of Groupings</td><td>2^n (where n is the number of columns). For example, for 3 columns, it generates 8 groupings.</td><td>n+1 (where n is the number of columns). For example, for 3 columns, it generates 4 groupings.</td></tr><tr><td>Subtotals</td><td>Includes subtotals for all possible combinations, including combinations of 1, 2, up to n-1 columns.</td><td>Includes subtotals for each column and progressively fewer columns until only the grand total is left.</td></tr><tr><td>Grand Total</td><td>Included as one of the combinations where all specified columns are set to NULL.</td><td>Included as the final grouping where all specified columns are set to NULL.</td></tr><tr><td>Use Case</td><td>Useful for comprehensive data analysis with all possible dimension combinations.</td><td>Useful for hierarchical data analysis where subtotals are needed at each level of the hierarchy.</td></tr><tr><td>Example Syntax</td><td><code>GROUP BY CUBE (col1, col2, col3)</code></td><td><code>GROUP BY ROLLUP (col1, col2, col3)</code></td></tr></tbody></table>

#### Example 1

```
SELECT
    product_id,
    region_id,
    SUM(sales_amount) AS total_sales
FROM
    (
        SELECT 1 AS product_id, 1 AS region_id, 100 AS sales_amount FROM dual UNION ALL
        SELECT 1 AS product_id, 2 AS region_id, 150 AS sales_amount FROM dual UNION ALL
        SELECT 2 AS product_id, 1 AS region_id, 200 AS sales_amount FROM dual UNION ALL
        SELECT 2 AS product_id, 2 AS region_id, 250 AS sales_amount FROM dual
    )
GROUP BY ROLLUP (product_id, region_id);
```

<figure><img src="../../../../../.gitbook/assets/image (6) (1).png" alt="" width="286"><figcaption></figcaption></figure>

{% hint style="info" %}
* Rows where `region_id` is `NULL` are subtotals for each `product_id`.
* The row where both `product_id` and `region_id` are `NULL` is the grand total.
{% endhint %}

#### Example 2

```
SELECT
    product_id,
    SUM(sales_amount) AS total_sales
FROM
    (
        SELECT 1 AS product_id, 1 AS region_id, 100 AS sales_amount FROM dual UNION ALL
        SELECT 1 AS product_id, 2 AS region_id, 150 AS sales_amount FROM dual UNION ALL
        SELECT 2 AS product_id, 1 AS region_id, 200 AS sales_amount FROM dual UNION ALL
        SELECT 2 AS product_id, 2 AS region_id, 250 AS sales_amount FROM dual
    )
GROUP BY ROLLUP (product_id);
```

<figure><img src="../../../../../.gitbook/assets/image (7) (1).png" alt="" width="202"><figcaption></figcaption></figure>

### CUBE

The `CUBE` function in Oracle SQL is an extension of the `GROUP BY` clause that generates subtotals for all possible combinations of a given set of dimensions. It is useful for producing a cross-tabulation of data and can create a comprehensive result set that includes subtotals and a grand total for multi-dimensional data analysis.

#### Syntax

```sql
SELECT
    column1,
    column2,
    aggregate_function(column3)
FROM
    table
GROUP BY CUBE (column1, column2);
```

#### Example 1

```
SELECT
    product_id,
    region_id,
    SUM(sales_amount) AS total_sales
FROM
    (
        SELECT 1 AS product_id, 1 AS region_id, 100 AS sales_amount FROM dual UNION ALL
        SELECT 1 AS product_id, 2 AS region_id, 150 AS sales_amount FROM dual UNION ALL
        SELECT 2 AS product_id, 1 AS region_id, 200 AS sales_amount FROM dual UNION ALL
        SELECT 2 AS product_id, 2 AS region_id, 250 AS sales_amount FROM dual
    )
GROUP BY CUBE (product_id, region_id);
```

{% hint style="info" %}
* Rows where `region_id` is `NULL` are subtotals for each `product_id`.
* Rows where `product_id` is `NULL` are subtotals for each `region_id`.
* The row where both `product_id` and `region_id` are `NULL` is the grand total.
{% endhint %}

<figure><img src="../../../../../.gitbook/assets/image (151).png" alt="" width="260"><figcaption></figcaption></figure>

#### Example 2

```
SELECT
    product_id,
    SUM(sales_amount) AS total_sales
FROM
    (
        SELECT 1 AS product_id, 1 AS region_id, 100 AS sales_amount FROM dual UNION ALL
        SELECT 1 AS product_id, 2 AS region_id, 150 AS sales_amount FROM dual UNION ALL
        SELECT 2 AS product_id, 1 AS region_id, 200 AS sales_amount FROM dual UNION ALL
        SELECT 2 AS product_id, 2 AS region_id, 250 AS sales_amount FROM dual
    )
GROUP BY CUBE (product_id);
```

<figure><img src="../../../../../.gitbook/assets/image (152).png" alt="" width="189"><figcaption></figcaption></figure>











