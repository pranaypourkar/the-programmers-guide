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
-- Output -> bnn

SELECT FIRST_NAME, TRANSLATE(FIRST_NAME, 'ae', 'oi') AS new_name
FROM employees;
```

## LENGTH

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
