# DecimalFormat

## About

The **`DecimalFormat`** class in Java, part of the `java.text` package, is used for formatting and parsing decimal numbers in a locale-sensitive and customizable way. It allows precise control over the appearance of numeric values, such as rounding, grouping separators, and digit patterns.

* **`DecimalFormat`** is a concrete subclass of `NumberFormat` specifically designed for formatting decimal numbers.
* It provides pattern-based formatting to define how numbers appear (e.g., decimal places, grouping separators, currency symbols).
* The patterns can include digits, commas, dots, and special characters to create a specific format for numerical values.

## **Features**

1. **Pattern-Based Formatting:** Allows defining custom patterns for numeric formats (e.g., `"#.00"` for two decimal places).
2. **Locale-Sensitive:** Adapts grouping separators and decimal symbols based on the locale.
3. **Customizable Symbols:** Supports setting custom symbols like grouping separators, decimal points, and prefixes.
4. **Rounding Behavior:** Automatically rounds numbers based on the defined pattern.
5. **Parsing Capability:** Can parse formatted strings back into numerical values.
6. **Thread-Safety:** Not thread-safe but can be synchronized or used with thread-local storage.

## **Declaration**

To use `DecimalFormat`, import it from the `java.text` package:

```java
import java.text.DecimalFormat;
```

## **Common Methods**

1. **Formatting:**
   * `String format(double number)`: Formats a `double` into a `String` based on the pattern.
   * `String format(long number)`: Formats a `long` into a `String`.
2. **Parsing:**
   * `Number parse(String source)`: Parses a formatted `String` into a `Number`.
3. **Customization:**
   * `setMaximumFractionDigits(int newValue)`: Sets the maximum number of digits allowed after the decimal point.
   * `setMinimumFractionDigits(int newValue)`: Sets the minimum number of digits required after the decimal point.
   * `setGroupingUsed(boolean newValue)`: Enables or disables the use of grouping separators (commas, spaces, etc.).
4. **Symbols Customization:**
   * `setDecimalFormatSymbols(DecimalFormatSymbols newSymbols)`: Sets custom symbols like decimal points or grouping separators.

## **Usage**

### **Basic Number Formatting**

```java
import java.text.DecimalFormat;

public class DecimalFormatExample {
    public static void main(String[] args) {
        DecimalFormat df = new DecimalFormat("#.00");

        double value = 12345.6789;
        System.out.println("Formatted Value: " + df.format(value));
    }
}
```

**Output:**

```yaml
Formatted Value: 12345.68
```

### **Customizing Patterns**

```java
import java.text.DecimalFormat;

public class CustomPatternExample {
    public static void main(String[] args) {
        DecimalFormat df = new DecimalFormat("#,###.##");

        double value = 1234567.89;
        System.out.println("Custom Pattern: " + df.format(value));
    }
}
```

**Output:**

```mathematica
Custom Pattern: 1,234,567.89
```

### **Parsing Numbers**

```java
import java.text.DecimalFormat;
import java.text.ParseException;

public class ParsingExample {
    public static void main(String[] args) {
        DecimalFormat df = new DecimalFormat("#,###.##");

        String formattedValue = "1,234,567.89";
        try {
            Number number = df.parse(formattedValue);
            System.out.println("Parsed Value: " + number);
        } catch (ParseException e) {
            System.out.println("Error parsing the number.");
        }
    }
}
```

**Output:**

```yaml
Parsed Value: 1234567.89
```

### **Custom Symbols**

```java
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;

public class CustomSymbolsExample {
    public static void main(String[] args) {
        DecimalFormatSymbols symbols = new DecimalFormatSymbols();
        symbols.setDecimalSeparator(',');
        symbols.setGroupingSeparator('.');

        DecimalFormat df = new DecimalFormat("#,###.##", symbols);

        double value = 1234567.89;
        System.out.println("Custom Symbols: " + df.format(value));
    }
}
```

**Output:**

```vbnet
Custom Symbols: 1.234.567,89
```

### **Real-World Example**

```java
import java.text.DecimalFormat;

public class RealWorldExample {
    public static void main(String[] args) {
        DecimalFormat usFormat = new DecimalFormat("$###,###.00");

        double payment = 12324.134;

        // US Formatting
        System.out.println("US: " + usFormat.format(payment));

        // Custom Locale Formatting
        DecimalFormat indiaFormat = new DecimalFormat("Rs.###,###.00");
        System.out.println("India: " + indiaFormat.format(payment));
    }
}
```

**Output:**

```makefile
US: $12,324.13
India: Rs.12,324.13
```
