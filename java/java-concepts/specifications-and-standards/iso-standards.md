# ISO Standards

## ISO-8601 calendar system

The ISO-8601 calendar system, also known as the International Standard Organization (ISO) 8601 Data and time - Representation and exchange, is an international standard for the representation of dates and times. It defines a well-defined, unambiguous way to exchange date and time information across different countries and cultures, avoiding confusion and misinterpretation.

Key characteristics of the ISO-8601 calendar system:

* **Basic format:** The basic format for representing a date is **YYYY-MM-DD**, where:
  * **YYYY** represents the **four-digit year** (e.g., 2024 for the current year)
  * **MM** represents the **two-digit month** (01 for January, 02 for February, etc.)
  * **DD** represents the **two-digit day of the month** (01 for the first day, 31 for the last day, etc.)
* **Time representation:** Time is typically represented in **24-hour format** using **hours-minutes-seconds** notation, separated by colons (e.g., 15:08:23).
* **Optional components:** The standard allows for optional components like:
  * **Milliseconds:** Can be added after seconds with a decimal point (e.g., 15:08:23.123).
  * **Timezone offset:** Can be specified using the `Z` character for UTC or the plus/minus symbol followed by the offset in hours and minutes (e.g., 2024-03-05T15:08:23+05:30 for a time 5 hours and 30 minutes ahead of UTC).
* **Week dates:** The standard also defines a format for representing dates based on the week number and day of the week (e.g., 2024-W10-5 for the fifth day of the tenth week in 2024).
* **Ordinal dates:** Dates can be represented based on the day of the year (e.g., 2024-064 for the 64th day of 2024).

**Benefits of using ISO-8601:**

* **Universality:** It's an internationally recognized standard, avoiding confusion and ensuring accurate data exchange across borders.
* **Machine-readable:** The structured format makes it easy for computers to parse and interpret dates and times.
* **Sorting:** Dates in ISO-8601 format can be easily sorted chronologically due to their numerical representation.

**Examples:**

* **Date only:** 2024-03-05 (today's date)
* **Date and time:** 2024-03-05T15:08:23 (today's date and time at 3:08 PM)
* **Date and time with timezone:** 2024-03-05T15:08:23Z (today's date and time in UTC)
* **Date and time with offset:** 2024-03-05T15:08:23+05:30 (today's date and time 5 hours and 30 minutes ahead of UTC)

## ISO-4217 currency codes

**ISO 4217** is the international standard for defining _currency codes_. It was established by the International Organization for Standardization (ISO). Each currency is assigned a **three-letter alphabetic code**, a **three-digit numeric code**, and usually a **minor unit** (i.e., number of decimal places).

ISO 4217 defines:

* **Alphabetic Code** (e.g., `USD`, `INR`, `EUR`) – Used in programming, APIs, banking systems.
* **Numeric Code** (e.g., `840` for USD) – Used for processing and data interchange.
* **Minor Units** – Number of decimal places (e.g., `2` for USD, `0` for JPY).

{% hint style="info" %}
- Currency is tied to a **Locale**, so use `Currency.getInstance(Locale)` when displaying to users.
- Not all currencies have a minor unit (e.g., JPY has 0 fraction digits).
- You cannot create a custom currency using this class. It strictly follows ISO 4217.
{% endhint %}

**List of Common ISO 4217 Currency Codes**

| Code | Country        | Symbol | Numeric | Fraction Digits |
| ---- | -------------- | ------ | ------- | --------------- |
| USD  | United States  | $      | 840     | 2               |
| INR  | India          | ₹      | 356     | 2               |
| EUR  | Eurozone       | €      | 978     | 2               |
| JPY  | Japan          | ¥      | 392     | 0               |
| GBP  | United Kingdom | £      | 826     | 2               |
| AED  | UAE            | د.إ    | 784     | 2               |

Java provides built-in support for ISO 4217 via the `java.util.Currency` class.

<table data-full-width="true"><thead><tr><th width="416.14410400390625">Method</th><th>Description</th></tr></thead><tbody><tr><td><code>Currency.getInstance(String currencyCode)</code></td><td>Gets a <code>Currency</code> instance for a given ISO 4217 code like <code>"USD"</code></td></tr><tr><td><code>Currency.getInstance(Locale locale)</code></td><td>Gets currency by country locale, e.g., <code>Locale.US</code></td></tr><tr><td><code>getCurrencyCode()</code></td><td>Returns the 3-letter ISO 4217 currency code</td></tr><tr><td><code>getSymbol()</code></td><td>Returns the symbol (like <code>$</code> or <code>₹</code>)</td></tr><tr><td><code>getSymbol(Locale locale)</code></td><td>Returns the symbol based on locale</td></tr><tr><td><code>getDefaultFractionDigits()</code></td><td>Returns the minor unit (like 2 for USD, 0 for JPY)</td></tr><tr><td><code>getNumericCode()</code> <em>(Java 19+)</em></td><td>Returns the numeric ISO 4217 code</td></tr></tbody></table>

**Example Code**

```java
import java.util.Currency;
import java.util.Locale;

public class CurrencyExample {
    public static void main(String[] args) {
        Currency usd = Currency.getInstance("USD");
        System.out.println("Currency Code: " + usd.getCurrencyCode());        // USD
        System.out.println("Currency Symbol: " + usd.getSymbol());            // $
        System.out.println("Default Fraction Digits: " + usd.getDefaultFractionDigits()); // 2

        Currency inr = Currency.getInstance(Locale.forLanguageTag("en-IN"));
        System.out.println("Currency Code: " + inr.getCurrencyCode());        // INR
        System.out.println("Currency Symbol: " + inr.getSymbol());            // ₹
    }
}
```

**Limitations**

* `Currency.getAvailableCurrencies()` returns a static list. It does not update dynamically with latest ISO changes unless the JDK is updated.
* Custom or virtual currencies like `BTC` (Bitcoin) are not included unless officially added by ISO.

