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



### DateTimeFormatter

Introduced in Java 8 with the `java.time` API, `DateTimeFormatter` provides a more modern and versatile approach to formatting and parsing dates, times, and date-time objects. It offers greater flexibility, thread-safety, and a wider range of formatting options compared to the older `SimpleDateFormat` class.

{% hint style="info" %}
Compared to `SimpleDateFormat`, it provides:

* **Thread-safe:** Unlike `SimpleDateFormat`, `DateTimeFormatter` instances are thread-safe, making them suitable for concurrent applications.
* **Flexibility:** Supports various formatting options, including locale-specific formatting and custom patterns. `DateTimeFormatter` offers features like handling different calendar systems and zones, not readily available in `SimpleDateFormat`
* **Integration with `java.time` API:** Designed to work seamlessly with the `java.time` classes for dates, times, and durations.
{% endhint %}



**Example:**

```java
LocalDate localDate = LocalDate.now();
LocalTime localTime = LocalTime.now();
LocalDateTime localDateTime = LocalDateTime.now();

// Format current date with default pattern
log.info("LocalDate: {}", DateTimeFormatter.ISO_DATE.format(localDate));
// LocalDate: 2024-03-10

// Format current date with custom pattern
DateTimeFormatter customDateFormatter = DateTimeFormatter.ofPattern("yyyy-dd-MM");
log.info("LocalDate: {}", customDateFormatter.format(localDate));
// LocalDate: 2024-10-03

// Format current time with default pattern
log.info("LocalTime: {}", DateTimeFormatter.ISO_TIME.format(localTime));
// LocalTime: 08:14:08.2149193

// Format current date and time with custom pattern
DateTimeFormatter customDateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
log.info("LocalDateTime: {}", customDateTimeFormatter.format(localDateTime));
// LocalDateTime: 2024-03-10 08:14:08

// Format a specific date
LocalDate specificDate = LocalDate.of(2023, 10, 15);
log.info("Specific Date: {}", customDateFormatter.format(specificDate));
// Specific Date: 2023-15-10

// Format a date with day of week
DateTimeFormatter dayOfWeekFormatter = DateTimeFormatter.ofPattern("EEEE, MMMM dd, yyyy");
log.info("Formatted Date with day of week: {}", dayOfWeekFormatter.format(specificDate));
// Formatted Date with day of week: Sunday, October 15, 2023

// Format a date with time zone
ZonedDateTime specificDateTime = ZonedDateTime.now(ZoneId.of("Europe/Paris"));
DateTimeFormatter zonedDateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss zzz");
log.info("Formatted Date with time zone: {}", zonedDateTimeFormatter.format(specificDateTime));
// Formatted Date with time zone: 2024-03-10 03:44:08 CET

// Format a date with milliseconds
LocalDateTime specificDateTimeWithMillis = LocalDateTime.of(2023, 10, 15, 12, 30, 15, 500_000_000);
DateTimeFormatter millisFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS");
log.info("Formatted date with milliseconds: {}", millisFormatter.format(specificDateTimeWithMillis));
// Formatted date with milliseconds: 2023-10-15 12:30:15.500

// Format a date with ordinal day
DateTimeFormatter ordinalDayFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd D");
log.info("Formatted date with ordinal day: {}", ordinalDayFormatter.format(specificDate));
// Formatted date with ordinal day: 2023-10-15 288

// Format a date with week in year
DateTimeFormatter weekInYearFormatter = DateTimeFormatter.ofPattern("yyyy-'W'ww");
log.info("Formatted date with week in year: {}", weekInYearFormatter.format(specificDate));
// Formatted date with week in year: 2023-W42

// Format a date with week in month
DateTimeFormatter weekInMonthFormatter = DateTimeFormatter.ofPattern("yyyy-MM-'W'W");
log.info("Formatted date with week in month: {}", weekInMonthFormatter.format(specificDate));
// Formatted date with week in month: 2023-10-W3

// Format a date with time zone offset
DateTimeFormatter offsetDateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss Z");
log.info("Formatted date with time zone offset: {}", offsetDateTimeFormatter.format(specificDateTime));
// Formatted date with time zone offset: 2024-03-10 03:44:08 +0100

// Format a date with short month and year
DateTimeFormatter shortMonthYearFormatter = DateTimeFormatter.ofPattern("MMM yy");
log.info("Formatted date with short month and year: {}", shortMonthYearFormatter.format(specificDate));
// Formatted date with short month and year: Oct 23

// Format a date with era
DateTimeFormatter eraFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd G");
log.info("Formatted date with era: {}", eraFormatter.format(specificDate));
// Formatted date with era: 2023-10-15 AD

// Format a date with quarter
DateTimeFormatter quarterFormatter = DateTimeFormatter.ofPattern("yyyy-'Q'Q");
log.info("Formatted date with quarter: {}", quarterFormatter.format(specificDate));
// Formatted date with quarter: 2023-Q4

// Format a date with day of year
DateTimeFormatter dayOfYearFormatter = DateTimeFormatter.ofPattern("yyyy-DDD");
log.info("Formatted date with day of year: {}", dayOfYearFormatter.format(specificDate));
// Formatted date with day of year: 2023-288

// Format a date with short day name
DateTimeFormatter shortDayNameFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd E");
log.info("Formatted date with short day name: {}", shortDayNameFormatter.format(specificDate));
// Formatted date with short day name: 2023-10-15 Sun

// Format a date with short year
DateTimeFormatter shortYearFormatter = DateTimeFormatter.ofPattern("yy-MM-dd");
log.info("Formatted date with short year: {}", shortYearFormatter.format(specificDate));
// Formatted date with short year: 23-10-15

// Format a date with custom pattern
DateTimeFormatter customPatternFormatter = DateTimeFormatter.ofPattern("dd/MMM/yyyy HH:mm:ss");
log.info("Formatted date with custom pattern: {}", customPatternFormatter.format(specificDateTime));
// Formatted date with custom pattern: 10/Mar/2024 03:44:08
```



