# Format

## About

In Java, the `java.text.Format` class is an abstract class designed for formatting and parsing objects. It serves as the base class for various concrete classes such as `NumberFormat`, `DecimalFormat`, `DateFormat`, and `MessageFormat`. `Format` is a part of the `java.text` package, which provides internationalization support for various types of data such as numbers, dates, and messages.

## **Purpose**

`Format` is intended for converting objects to and from string representations. It can be used for:

* Formatting objects into strings (e.g., formatting a `Date` into a readable string).
* Parsing strings into objects (e.g., converting a string like `"2024-12-27"` back into a `Date` object).

The `Format` class provides a mechanism for converting objects of a particular type to and from strings in a locale-sensitive way, and it forms the basis of other specialized formatters.

## **Key Methods**

The `Format` class provides two primary methods for its concrete subclasses:

* **`format(Object obj)`**: This method is used to format an object into a string representation. The object passed to this method must be of the type that the specific subclass of `Format` can handle (e.g., `Date`, `Number`).

```java
public String format(Object obj)
```

* **`parse(String source)`**: This method is used to parse a string back into an object. The string is expected to follow the format rules defined by the subclass. It may throw a `ParseException` if the string does not match the expected format.

```java
public Object parse(String source) throws ParseException
```

## **Concrete Subclasses of `Format`**

* **`DateFormat`**:`DateFormat` is used for formatting and parsing dates. It can handle both the `Date` object and string representations of dates.
* **`DecimalFormat`**:`DecimalFormat` is used to format numbers. It allows for setting patterns for numeric formatting, such as specifying the number of decimal places.
* **`MessageFormat`**:`MessageFormat` is used for formatting messages with placeholders (similar to string interpolation). It is often used in internationalization scenarios where dynamic messages are generated.

## **Locale Sensitivity**

`Format` classes in Java are typically locale-sensitive. This means they adjust their behavior based on the locale settings (language, country, and variant). For example, the way numbers are formatted differs based on whether you're in the US, France, or Germany:

* In the US, a decimal point (`.`, e.g., `123.45`).
* In many European countries, a comma (`,`, e.g., `123,45`).

This is handled by `DateFormat`, `DecimalFormat`, and other concrete classes that inherit from `Format`. Locale can be specified explicitly or determined from the default locale:

```java
Locale locale = Locale.FRANCE;
DecimalFormat df = (DecimalFormat) DecimalFormat.getInstance(locale);
```

## **Pattern-Based Formatting**

Concrete `Format` classes like `DecimalFormat` and `SimpleDateFormat` allow us to specify patterns for formatting objects. These patterns define how the formatting should appear.

*   **For numbers**: A pattern in `DecimalFormat` might look like `"#,###.##"` (for thousands separator and decimal places).

    ```java
    DecimalFormat df = new DecimalFormat("#,###.##");
    String formattedNumber = df.format(1234567.89);  // Output: "1,234,567.89"
    ```
*   **For dates**: A pattern in `SimpleDateFormat` might look like `"yyyy-MM-dd"`.

    ```java
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    String formattedDate = sdf.format(new Date());  // Output: "2024-12-27"
    ```

## **Error Handling in Parsing**

When parsing a string, `Format` subclasses throw a `ParseException` if the input string cannot be parsed into the expected object. This exception provides information about where the parsing failed, making error handling more transparent.

```java
try {
    DecimalFormat df = new DecimalFormat("#.##");
    Number number = df.parse("1234.56");
} catch (ParseException e) {
    e.printStackTrace();
}
```

## **Custom Format Classes**

We can extend the `Format` class to create our own custom formatters. This involves implementing the `format` and `parse`methods to handle specific types of data in a way that meets your needs.

```java
public class MyCustomFormat extends Format {
    @Override
    public StringBuffer format(Object obj, StringBuffer toAppendTo, FieldPosition pos) {
        // Custom formatting logic
    }

    @Override
    public Object parse(String source, ParsePosition pos) {
        // Custom parsing logic
    }
}
```

## **Thread-Safety**

`Format` and its subclasses (like `DecimalFormat`, `SimpleDateFormat`) are not thread-safe by default. If we're using them in multi-threaded applications, we need to either:

* Use `ThreadLocal` to maintain separate instances for each thread.
* Use `DateFormat` and `DecimalFormat` in a synchronized block or create separate instances for each thread.

```java
ThreadLocal<DecimalFormat> threadLocalFormat = ThreadLocal.withInitial(() -> new DecimalFormat("#,###.##"));
```
