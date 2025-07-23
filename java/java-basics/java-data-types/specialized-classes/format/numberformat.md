# NumberFormat

## About

The **`NumberFormat`** class in Java is part of the `java.text` package and provides a framework for formatting and parsing numbers according to different locales. It is commonly used for formatting numbers, currencies, and percentages in a locale-sensitive manner.

* **`NumberFormat`** is an abstract class that formats and parses numbers for any locale.
* It simplifies handling of number-related formatting tasks like currency representation, percentage formatting, or custom patterns.
* The class supports both formatting (conversion of numbers to strings) and parsing (conversion of strings to numbers).

## **Features**

1. **Locale-Sensitive Formatting:** Adapts number formats to the conventions of a specific locale, such as decimal separators, grouping separators, and currency symbols.
2. **Predefined Number Styles:** Includes predefined methods to create number formatters for **default numbers**, **currencies**, and **percentages**.
3. **Customizability:** Can be customized using sub-classes like `DecimalFormat` for more advanced formatting.
4. **Parsing Support:** Converts formatted strings back into numbers, ensuring consistency in applications where numbers need to be read back from user input or data files.
5. **Thread-Safe Instances:** Instances of `NumberFormat` can be used in multi-threaded applications.

## **Declaration**

To use the `NumberFormat` class, we must import it from the `java.text` package:

```java
import java.text.NumberFormat;
import java.util.Locale;
```

## **Common Methods**

1. **Static Factory Methods:**
   * `getInstance()`: Returns a general-purpose number formatter for the default locale.
   * `getCurrencyInstance()`: Returns a currency formatter for the default locale.
   * `getPercentInstance()`: Returns a percentage formatter for the default locale.
   * `getNumberInstance()`: Returns a formatter for numbers.
   * `getInstance(Locale locale)`: Returns a formatter for a specific locale.
2. **Formatting Methods:**
   * `format(double number)`: Formats a `double` as a `String`.
   * `format(long number)`: Formats a `long` as a `String`.
3. **Parsing Methods:**
   * `parse(String source)`: Parses a `String` into a `Number`.
4. **Customization:**
   * `setMaximumFractionDigits(int newValue)`: Sets the maximum number of fraction digits.
   * `setMinimumFractionDigits(int newValue)`: Sets the minimum number of fraction digits.
   * `setGroupingUsed(boolean newValue)`: Enables or disables grouping separators (e.g., commas).
5. **Other Utility Methods:**
   * `setCurrency(Currency currency)`: Sets the currency for currency formatting.
   * `getCurrency()`: Retrieves the currency used for formatting.

## **Usage**

### **Formatting Numbers**

```java
import java.text.NumberFormat;

public class NumberFormatExample {
    public static void main(String[] args) {
        double number = 12345.6789;

        // Default number format
        NumberFormat numberFormat = NumberFormat.getNumberInstance();
        System.out.println("Default Format: " + numberFormat.format(number));

        // Customizing the format
        numberFormat.setMaximumFractionDigits(2);
        System.out.println("Customized Format: " + numberFormat.format(number));
    }
}
```

### **Formatting Currency for Different Locales**

```java
import java.text.NumberFormat;
import java.util.Locale;

public class CurrencyFormatExample {
    public static void main(String[] args) {
        double payment = 12324.134;

        // US Locale
        NumberFormat usFormat = NumberFormat.getCurrencyInstance(Locale.US);

        // India Locale
        Locale indiaLocale = new Locale("en", "IN");
        NumberFormat indiaFormat = NumberFormat.getCurrencyInstance(indiaLocale);

        System.out.println("US: " + usFormat.format(payment));
        System.out.println("India: " + indiaFormat.format(payment));
    }
}
```

**Output:**

```makefile
US: $12,324.13
India: Rs.12,324.13
```

### **Formatting Percentages**

```java
import java.text.NumberFormat;

public class PercentageFormatExample {
    public static void main(String[] args) {
        double fraction = 0.85;

        // Percentage format
        NumberFormat percentFormat = NumberFormat.getPercentInstance();
        System.out.println("Percentage: " + percentFormat.format(fraction));
    }
}
```

**Output:**

```makefile
Percentage: 85%
```

### **Parsing Numbers**

```java
import java.text.NumberFormat;
import java.text.ParseException;

public class NumberParsingExample {
    public static void main(String[] args) {
        String numberString = "12,345.67";
        NumberFormat numberFormat = NumberFormat.getNumberInstance();

        try {
            Number number = numberFormat.parse(numberString);
            System.out.println("Parsed Number: " + number);
        } catch (ParseException e) {
            System.out.println("Error parsing the number.");
        }
    }
}
```

**Output:**

```javascript
Parsed Number: 12345.67
```

## **Applications and Real-World Usage**

1. **Currency Display in E-Commerce:** Display prices in local currencies based on the user’s locale.
2. **Percentage Calculations:** Format percentages in analytics dashboards or reports.
3. **Locale-Sensitive Input and Output:** Format and parse numbers in applications that support multiple regions or languages.
4. **Finance Applications:** Display monetary values with appropriate separators, currency symbols, and decimal precision.
5. **Data Visualization:** Format numerical data for graphs, charts, and tables.

