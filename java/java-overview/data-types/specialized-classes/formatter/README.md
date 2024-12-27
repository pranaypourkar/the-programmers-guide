# Formatter

## **About**

`Formatter` is a class in Java that provides a way to format strings and other types of data. It can be used to generate formatted output (like printf-style formatting) and format data for various types, such as numbers, dates, and strings. It is part of the `java.util` package and offers functionality similar to `String.format()` and `System.out.printf()` but with more flexibility and control.

## **Features**

* **Customizable Formatting**: The `Formatter` class supports custom format specifiers that allow for precise control over output formatting. This includes number formatting, date/time formatting, and string alignment.
* **Support for Multiple Locale Formats**: It supports localization for formatting numbers, dates, and other data types based on the current locale or a specified locale.
* **Formatted Output to Streams**: `Formatter` can be used to format data to different output streams such as `OutputStream`, `Writer`, or `PrintWriter`.
* **Memory Management**: It uses a buffer to format strings, which helps in reducing memory allocation overhead during repetitive formatting tasks.
* **Exception Handling**: It can throw a `FormatterClosedException` if formatting operations are performed after the formatter has been closed.

{% hint style="info" %}
**Internally uses `String.format()`**: `Formatter` is essentially a more advanced version of `String.format()` because it allows us to specify a destination (where the formatted output will be written), control locales, and handle complex format scenarios.

**Exception Handling**: If we attempt to perform formatting after closing the `Formatter`, it throws a `FormatterClosedException`. This exception must be handled appropriately.

**Buffering**: `Formatter` buffers the output in memory, which means it can be more efficient for multiple format operations compared to direct formatting methods like `String.format()`.

**Locale-specific Formatting**: We can pass a `Locale` when creating a `Formatter` instance, allowing you to use locale-specific conventions for number formatting, date formatting, etc.
{% endhint %}

## **Declaration Syntax**

To use a `Formatter`, we can use no-argument constructor to instantiate it or with an `Appendable` object (e.g., `StringBuilder`, `File`, `OutputStream`, etc.) where the formatted output will be written.

```java
Formatter formatter = new Formatter();
```

```java
Formatter formatter = new Formatter(Appendable destination);
```

Alternatively, we can also specify a locale

```java
Formatter formatter = new Formatter(Appendable destination, Locale locale);
```

To format to a `String` (using `StringBuilder` as the destination):

```java
Formatter formatter = new Formatter(new StringBuilder());
```

## **Supported Methods**

<table data-full-width="true"><thead><tr><th width="324">Method</th><th>Description</th></tr></thead><tbody><tr><td><code>void close()</code></td><td>Closes the <code>Formatter</code> object, releasing any resources associated with it. After this, no further formatting can be done.</td></tr><tr><td><code>Formatter format(String format, Object... args)</code></td><td>Formats the specified arguments using the provided format string. Returns the <code>Formatter</code> object itself for chaining.</td></tr><tr><td><code>String toString()</code></td><td>Returns the formatted output as a string. This is useful when you want to get the formatted result as a <code>String</code>.</td></tr><tr><td><code>Appendable out()</code></td><td>Returns the <code>Appendable</code> destination object that was passed to the <code>Formatter</code>constructor.</td></tr><tr><td><code>Locale locale()</code></td><td>Returns the locale used by the <code>Formatter</code> instance.</td></tr><tr><td><code>int hashCode()</code></td><td>Returns the hash code for the <code>Formatter</code> object.</td></tr><tr><td><code>boolean equals(Object obj)</code></td><td>Checks if two <code>Formatter</code> objects are equal, i.e., have the same formatting locale and destination.</td></tr><tr><td><code>Formatter append(CharSequence csq)</code></td><td>Appends the given <code>CharSequence</code> to the formatted output.</td></tr><tr><td><code>Formatter append(CharSequence csq, int start, int end)</code></td><td>Appends a subsequence of the given <code>CharSequence</code> to the formatted output.</td></tr><tr><td><code>Formatter append(char c)</code></td><td>Appends the given character to the formatted output.</td></tr></tbody></table>

## **Use Cases**

* **Logging**: `Formatter` can be used to create structured log messages where the format of the log entries varies depending on the log level, time, and message content.
* **Generating Reports**: When we need to generate reports or tabular data, `Formatter` can be used to neatly format data into columns.
* **Custom Output Formatting**: When we need to format complex output (e.g., strings, numbers, and dates) in a consistent way, `Formatter` gives you more flexibility than `String.format()`.
* **Formatting Data for File Writing**: We can use `Formatter` to write formatted data directly to a file or output stream, which is often needed in data export or logging systems.
* **Locale-based Formatting**: If we're working with financial data, monetary amounts, or dates that need to follow specific cultural conventions (like currency symbols, date formats, etc.), `Formatter` allows us to specify the `Locale`.

## Format Specifiers Symbols

In Java's `Formatter`, there are several symbols used for formatting various types of data. These symbols allow us to control how the data is formatted, such as setting width, precision, alignment, and the type of data (strings, numbers, dates, etc.).&#x20;

### **General Syntax of Format Specifiers**

A format specifier has the following general structure:

```java
%[flags][width][.precision][conversion]
```

### **Flags**

* `-` : Left-justifies the result within the given width.
* `+` : Always prints a sign for numeric types (positive or negative).
* `0` : Pads the output with leading zeros instead of spaces.
* `#` : Specifies alternate forms (e.g., adding `0x` for hexadecimal, `0` for octal).
* `,` : Includes grouping separators for numbers (e.g., thousands separators).
* `(` : Encloses negative numbers in parentheses.
* `' '` : Inserts a space for positive numbers and a minus sign for negative numbers.

### **Width**

* A number specifying the minimum width of the output. The result is padded with spaces (or zeros) to match the width.

### **Precision**

* A number specifying the maximum number of characters for strings or the number of decimal places for floating-point numbers.

### **Conversions**

1. **String Format Specifiers**

* `%s` : Formats a string. If the string is longer than the specified width, it is truncated.
* `%S` : Formats a string in uppercase.
* `%c` : Formats a character.

2. **Integer Format Specifiers**

* `%d` : Formats a decimal (base 10) integer.
* `%o` : Formats an octal (base 8) integer.
* `%x` : Formats a hexadecimal (base 16) integer in lowercase (e.g., `1a`).
* `%X` : Formats a hexadecimal integer in uppercase (e.g., `1A`).
* `%b` : Formats a boolean as `true` or `false`.

3. **Floating-Point Format Specifiers**

* `%f` : Formats a floating-point number (e.g., `123.456`).
* `%e` : Formats a floating-point number in scientific notation (e.g., `1.23456e+02`).
* `%E` : Formats a floating-point number in scientific notation (uppercase `E`, e.g., `1.23456E+02`).
* `%g` : Formats a floating-point number in the most compact form, either `%f` or `%e`, depending on the value and precision.
* `%G` : Formats a floating-point number in the most compact form, either `%F` or `%E`, depending on the value and precision.
* `%a` : Formats a floating-point number in hexadecimal scientific notation.
* `%A` : Formats a floating-point number in hexadecimal scientific notation (uppercase `A`).

4. **Date/Time Format Specifiers**&#x20;

* `%t` : Used for formatting date and time. This is followed by a letter indicating the specific date/time component:
* `%tY` : Year (e.g., `2024`).
* `%tM` : Month (e.g., `12`).
* `%td` : Day of the month (e.g., `27`).
* `%tH` : Hour (24-hour format) (e.g., `14`).
* `%tI` : Hour (12-hour format) (e.g., `2`).
* `%tM` : Minute (e.g., `30`).
* `%tS` : Second (e.g., `59`).
* `%tL` : Millisecond (e.g., `123`).
* `%tz` : Time zone offset from UTC (e.g., `+0200`).
* `%tp` : AM/PM marker (e.g., `AM`).
* `%tZ` : Time zone abbreviation (e.g., `GMT`).

5. **Special Characters and Escape Sequences**

* `%%` : Prints a literal `%` character.
* `\n` : Newline character (if used in strings).
* `\t` : Tab character (if used in strings).
