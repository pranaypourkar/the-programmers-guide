# StringUtils

## About

`StringUtils` is a utility class provided by **Apache Commons Lang** that contains a large number of static helper methods for **working with strings**.

Unlike the standard Java `String` class, which is immutable and provides limited methods, `StringUtils` makes string manipulation **simpler**, **safer**, and **less error-prone**, especially when dealing with **null** values or empty strings.

## Characteristics

* All methods are **static**, and the class cannot be instantiated.
* Designed to be **null-safe**: methods do not throw `NullPointerException` if input is `null`.
* Includes **checks**, **transformation**, **comparison**, **abbreviation**, **joining**, **splitting**, and more.
* Very commonly used in **enterprise Java applications**, especially with Spring Boot.

## Maven Dependency & Import

If we don’t already have it:

```xml
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-lang3</artifactId>
    <version>3.12.0</version> <!-- or latest stable -->
</dependency>
```

```java
import org.apache.commons.lang3.StringUtils;
```

## Common Categories of Methods

Here are the most commonly used method categories:

### 1. Null and Empty Checks

| Method                       | Description                                                   |
| ---------------------------- | ------------------------------------------------------------- |
| `isEmpty(String str)`        | Returns true if the string is null or empty                   |
| `isNotEmpty(String str)`     | Opposite of `isEmpty()`                                       |
| `isBlank(String str)`        | Returns true if the string is null, empty, or whitespace only |
| `isNotBlank(String str)`     | Opposite of `isBlank()`                                       |
| `defaultIfEmpty(str, "N/A")` | Returns a default value if string is empty or null            |

**Example:**

```java
String input = null;
if (StringUtils.isBlank(input)) {
    // safe to check without NullPointerException
}
```

### 2. Trimming and Removing

| Method                  | Description                                 |
| ----------------------- | ------------------------------------------- |
| `strip(str)`            | Trims whitespace (null-safe)                |
| `stripToEmpty(str)`     | Trims and returns `""` instead of `null`    |
| `stripToNull(str)`      | Trims and returns `null` if result is empty |
| `remove(str, char)`     | Removes all occurrences of a character      |
| `deleteWhitespace(str)` | Removes all whitespace characters           |

### 3. Comparison

| Method                         | Description                               |
| ------------------------------ | ----------------------------------------- |
| `equals(str1, str2)`           | Null-safe equals comparison               |
| `equalsIgnoreCase(str1, str2)` | Null-safe equals comparison ignoring case |
| `compare(str1, str2)`          | Null-safe lexicographical comparison      |
| `startsWith(str, prefix)`      | Null-safe prefix check                    |
| `endsWith(str, suffix)`        | Null-safe suffix check                    |

### 4. Substring and Search

| Method                               | Description                                     |
| ------------------------------------ | ----------------------------------------------- |
| `substringBetween(str, open, close)` | Gets substring between two markers              |
| `contains(str, search)`              | Checks if a string contains a sequence          |
| `countMatches(str, sub)`             | Counts how many times a substring appears       |
| `indexOfDifference(str1, str2)`      | Finds first differing index between two strings |

### 5. Join and Split

| Method                                  | Description                                |
| --------------------------------------- | ------------------------------------------ |
| `join(array, separator)`                | Joins array of strings with a delimiter    |
| `split(str, separator)`                 | Splits a string into an array by delimiter |
| `splitByWholeSeparator(str, separator)` | Splits by whole string separator           |

### 6. Capitalization and Case

| Method              | Description                         |
| ------------------- | ----------------------------------- |
| `capitalize(str)`   | Capitalizes the first character     |
| `uncapitalize(str)` | Makes the first character lowercase |
| `swapCase(str)`     | Swaps case of all characters        |

### 7. Abbreviation and Padding

| Method                         | Description                           |
| ------------------------------ | ------------------------------------- |
| `abbreviate(str, maxWidth)`    | Shortens a string and appends "..."   |
| `leftPad(str, size, padChar)`  | Pads from left to reach desired size  |
| `rightPad(str, size, padChar)` | Pads from right to reach desired size |
| `repeat(str, count)`           | Repeats the string multiple times     |

### 8. Replacing

| Method                                    | Description               |
| ----------------------------------------- | ------------------------- |
| `replace(str, search, replace)`           | Replaces all occurrences  |
| `replaceEach(str, search[], replace[])`   | Replaces multiple strings |
| `replacePattern(str, regex, replacement)` | Regex-based replacement   |

## Why Use `StringUtils` Instead of Java String Methods?

<table data-header-hidden><thead><tr><th width="156.4132080078125"></th><th width="215.69012451171875"></th><th></th></tr></thead><tbody><tr><td>Concern</td><td>Java String</td><td><code>StringUtils</code> Advantage</td></tr><tr><td>Null handling</td><td>Throws exceptions</td><td>Null-safe</td></tr><tr><td>Common tasks</td><td>Manual/verbose</td><td>Simple static methods</td></tr><tr><td>Consistency</td><td>Varies</td><td>Centralized utility approach</td></tr><tr><td>Readability</td><td>Lower</td><td>More expressive method names</td></tr></tbody></table>



