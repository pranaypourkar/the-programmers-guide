# Date Time Formatter

### SimpleDateFormat

`SimpleDateFormat` is a class in the `java.text` package that provides formatting and parsing capabilities for dates and times in Java. It allows you to convert a `Date` object into a human-readable string representation according to a specific format pattern and vice versa.

`SimpleDateFormat` is not thread-safe. If we need thread-safe date formatting, consider using the newer `DateTimeFormatter` class from the `java.time` API.

{% hint style="info" %}
For more details visit official site: [https://docs.oracle.com/javase/7/docs/api/java/text/SimpleDateFormat.html](https://docs.oracle.com/javase/7/docs/api/java/text/SimpleDateFormat.html)
{% endhint %}

```java
@SneakyThrows
public static void main(String[] args) {
    // Formatting a Date object
    Date date = new Date();
    SimpleDateFormat simpleDateFormatter = new SimpleDateFormat("MM/dd/yyyy");
    String formattedDate = simpleDateFormatter.format(date);
    log.info("Formatted date: {}", formattedDate); // Formatted date: 03/10/2024

    // Parsing a String representation of a date
    String dateString = "2024-03-09";
    SimpleDateFormat simpleDateFormatter2 = new SimpleDateFormat("yyyy-MM-dd");
    Date parsedDate = simpleDateFormatter2.parse(dateString);
    log.info("Parsed date: {}", parsedDate); // Parsed date: Sat Mar 09 00:00:00 IST 2024

    // Other formatting examples
    SimpleDateFormat sdf = new SimpleDateFormat();

    // Format current date with default pattern
    log.info("Date: {}", sdf.format(date)); // Date: 10/03/24, 7:49 am

    //Format current date with custom pattern
    sdf.applyPattern("yyyy-MM-dd");
    log.info("Date: {}", sdf.format(date)); // Date: 2024-03-10

    //Format current time with custom pattern
    sdf.applyPattern("HH:mm:ss");
    log.info("Time: {}", sdf.format(date)); // Time: 07:49:15

    // Format current date and time with custom pattern
    sdf.applyPattern("yyyy-MM-dd HH:mm:ss");
    log.info("Datetime: {}", sdf.format(date)); // Datetime: 2024-03-10 07:49:15

    // Format a specific date
    Date specificDate = new Date(1234567890000L); // 2009-02-13 23:31:30
    log.info("Date: {}", sdf.format(specificDate)); // Date: 2009-02-14 05:01:30

    // Format a date without time
    sdf.applyPattern("yyyy-MM-dd");
    log.info("Date: {}", sdf.format(specificDate)); // Date: 2009-02-14

    // Format a date with day of week
    sdf.applyPattern("EEEE, MMMM dd, yyyy");
    log.info("Date: {}", sdf.format(specificDate)); // Date: Saturday, February 14, 2009

    // Format a date with time zone
    sdf.applyPattern("yyyy-MM-dd HH:mm:ss zzz");
    log.info("Date: {}", sdf.format(specificDate)); // Date: 2009-02-14 05:01:30 IST

    // Format a date with milliseconds
    sdf.applyPattern("yyyy-MM-dd HH:mm:ss.SSS");
    log.info("Date: {}", sdf.format(specificDate)); // Date: 2009-02-14 05:01:30.000

    // Format a date with ordinal day
    sdf.applyPattern("yyyy-MM-dd D");
    log.info("Date: {}", sdf.format(specificDate)); // Date: 2009-02-14 45

    // Format a date with week in year
    sdf.applyPattern("yyyy-'W'ww");
    log.info("Date: {}", sdf.format(specificDate)); // Date: 2009-W07

    // Format a date with week in month
    sdf.applyPattern("yyyy-MM-'W'W");
    log.info("Date: {}", sdf.format(specificDate)); // Date: 2009-02-W2

    // Format a date with time zone offset
    sdf.applyPattern("yyyy-MM-dd HH:mm:ss Z");
    log.info("Date: {}", sdf.format(specificDate)); // Date: 2009-02-14 05:01:30 +0530

    // Format a date with short month and year
    sdf.applyPattern("MMM yy");
    log.info("Date: {}", sdf.format(specificDate)); // Date: Feb 09

    // Format a date with era
    sdf.applyPattern("yyyy-MM-dd G");
    log.info("Date: {}", sdf.format(specificDate)); // Date: 2009-02-14 AD

    // Format a date with day of year
    sdf.applyPattern("yyyy-DDD");
    log.info("Date: {}", sdf.format(specificDate)); // Date: 2009-045

    // Format a date with short day name
    sdf.applyPattern("yyyy-MM-dd E");
    log.info("Date: {}", sdf.format(specificDate)); // Date: 2009-02-14 Sat

    // Format a date with short year
    sdf.applyPattern("yy-MM-dd");
    log.info("Date: {}", sdf.format(specificDate)); // Date: 09-02-14

    // Format a date with custom pattern
    sdf.applyPattern("dd/MMM/yyyy HH:mm:ss");
    log.info("Date: {}", sdf.format(specificDate)); // Date: 14/Feb/2009 05:01:30
}
```







