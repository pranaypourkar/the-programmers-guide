# NumberUtils

## About

`NumberUtils` is a utility class in the Apache Commons Lang library that provides static methods to **safely and efficiently work with numbers**.

It simplifies tasks like:

* **Parsing strings to numbers**
* **Checking if a string is numeric**
* **Comparing numbers**
* **Finding min/max values**
* **Handling null-safe conversions**

Java’s standard libraries require verbose or exception-prone code for number operations, especially when parsing strings. `NumberUtils` helps reduce boilerplate, improve readability, and avoid unnecessary exceptions.

## Characteristics

* All methods are **static**.
* Provides **null-safe**, **exception-safe**, and **type-flexible** APIs.
* Works with **primitives**, **boxed types**, and **strings**.
* Helps avoid common pitfalls in string-to-number parsing.

## Maven Dependency & Import

```xml
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-lang3</artifactId>
    <version>3.12.0</version> <!-- or latest -->
</dependency>
```

```java
import org.apache.commons.lang3.math.NumberUtils;
```

## Common Categories of Methods

### 1. Safe Parsing

| Method                              | Description                                      |
| ----------------------------------- | ------------------------------------------------ |
| `toInt(String str)`                 | Parses string to int or returns `0` if invalid   |
| `toInt(String str, int defaultVal)` | Parses string to int, or default if invalid      |
| `toLong(String str)`                | Parses string to long or returns `0L` if invalid |
| `toFloat(String str)`               | Parses string to float                           |
| `toDouble(String str)`              | Parses string to double                          |
| `toBigDecimal(String str)`          | Converts to `BigDecimal`                         |

**Example:**

```java
int value = NumberUtils.toInt("123", -1); // returns 123
int fallback = NumberUtils.toInt("abc", -1); // returns -1
```

### 2. Checking Numeric Strings

<table><thead><tr><th width="238.68316650390625">Method</th><th>Description</th></tr></thead><tbody><tr><td><code>isDigits(String str)</code></td><td>Returns true if the string contains only digits</td></tr><tr><td><code>isParsable(String str)</code></td><td>Returns true if string can be parsed to a number</td></tr><tr><td><code>isCreatable(String str)</code></td><td>Returns true if string can be converted to any number type (int, float, hex, scientific, etc.)</td></tr></tbody></table>

**Examples:**

```java
NumberUtils.isDigits("12345") // true
NumberUtils.isDigits("123a")  // false

NumberUtils.isParsable("3.14") // true
NumberUtils.isCreatable("0xFF") // true
NumberUtils.isCreatable("1e10") // true
```

### 3. Finding Min and Max

| Method                     | Description               |
| -------------------------- | ------------------------- |
| `max(int... array)`        | Returns the maximum value |
| `min(double... array)`     | Returns the minimum value |
| `max(long, long, long)`    | Max of three longs        |
| `min(float, float, float)` | Min of three floats       |

**Example:**

```java
int max = NumberUtils.max(1, 5, 3);  // returns 5
double min = NumberUtils.min(1.2, 0.9, 3.4);  // returns 0.9
```

### 4. Number Conversion

| Method                         | Description                                |
| ------------------------------ | ------------------------------------------ |
| `createNumber(String str)`     | Converts string to appropriate number type |
| `createInteger(String str)`    | Converts to `Integer`                      |
| `createLong(String str)`       | Converts to `Long`                         |
| `createFloat(String str)`      | Converts to `Float`                        |
| `createDouble(String str)`     | Converts to `Double`                       |
| `createBigDecimal(String str)` | Converts to `BigDecimal`                   |

**Example:**

```java
Number num = NumberUtils.createNumber("42"); // returns Integer
Number hex = NumberUtils.createNumber("0x1F"); // returns Integer
```

### 5. Comparison Utilities

| Method                        | Description                              |
| ----------------------------- | ---------------------------------------- |
| `compare(int a, int b)`       | Returns 0 if equal, -1 if a\<b, 1 if a>b |
| `compare(double a, double b)` | Same for doubles                         |

These can be used instead of `Integer.compare()` (Java 7+), especially for older codebases.

## Why Use `NumberUtils` Over Plain Java?

<table data-header-hidden data-full-width="true"><thead><tr><th width="191.2916259765625"></th><th width="302.25872802734375"></th><th></th></tr></thead><tbody><tr><td>Concern</td><td>Plain Java</td><td><code>NumberUtils</code> Advantage</td></tr><tr><td>Safe parsing</td><td><code>Integer.parseInt</code> throws exception</td><td>Returns default value instead of exception</td></tr><tr><td>Type flexibility</td><td>Requires multiple overloads</td><td>Unified handling of int, float, long, etc.</td></tr><tr><td>Hex/scientific input</td><td>Manual checks and parsing</td><td>Handled by <code>createNumber()</code> and <code>isCreatable()</code></td></tr><tr><td>Min/max logic</td><td>Custom loops or <code>Math</code> class</td><td>Cleaner with arrays and multiple args</td></tr></tbody></table>

