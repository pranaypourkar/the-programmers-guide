---
description: >-
  Overview of various classes and libraries available for working with dates,
  times, and timestamps in Java.
---

# Date and Time

### `java.util.Date`

**Description:** It is used to represent a specific point in time, including both date and time information. It has been around since the early days of Java, but it has limitations and potential issues.

**Limitations:**

* **Thread-unsafe:** Accessing or modifying a `Date` object from multiple threads concurrently can lead to unexpected behavior due to its mutable nature.
* **Limited date and time manipulation:** Working with specific date or time components can be cumbersome and error-prone.
* **Timezone issues:** `Date` objects represent time in UTC by default, and handling timezones can be complex and error-prone.
* **Deprecated methods:** Many methods of `Date` are deprecated in favor of the newer and more robust `java.time` API introduced in Java 8.

**Potential Use case**: In legacy java codebase but cautious of its limitations and consider migrating to the `java.time` API when feasible.&#x20;

{% hint style="info" %}
For new development, it is recommended to use the `java.time` API. It offers classes like `LocalDate`, `LocalTime`, and `LocalDateTime` for more specific and thread-safe date and time handling.
{% endhint %}

**Example:**&#x20;

```java
package org.example;

import lombok.extern.slf4j.Slf4j;
import java.util.Date;

@Slf4j
public class Application {

    public static void main(String[] args) {
        Date date = new Date();
        log.info("Current Date and Time: {}", date);
        // timestamp (milliseconds since January 1, 1970, 00:00:00 GMT)
        log.info("Current Time in timestamp: {}", date.getTime());

        Date specificDate = new Date(124, 0, 1); // Year 2024, Month 0 (January), Day 1
        log.info("Specific Date and Time: {}", specificDate);

        // Compare the two dates
        int comparison = date.compareTo(specificDate);

        // Print the result of comparison
        if (comparison < 0) {
            log.info("Current date is before specificDate");
        } else if (comparison > 0) {
            log.info("Current date is after specificDate");
        } else {
            log.info("Current date is equal to specificDate");
        }
    }
}
```

<figure><img src="../../.gitbook/assets/image (1).png" alt=""><figcaption><p>Output</p></figcaption></figure>



### `java.util.Calendar`

**Description:** It is an abstract class that provides functionalities for working with dates and times. Since it is abstract, it cannot be directly created as a `Calendar` object using a constructor. Instead, use the static method `Calendar.getInstance()` to get an instance based on the current time, default locale, and time zone. It is mutable and able to modify the date and time represented by a `Calendar` object by setting its field values.

**Limitations:**

* **Complexity:** Working with specific date or time components using `Calendar` can be cumbersome and involve multiple method calls.
* **Timezone handling:** While `Calendar` supports timezones, it can be complex to manage them effectively, especially in multi-threaded environments.
* **Thread-unsafe:** Similar to `Date`, accessing or modifying a `Calendar` object from multiple threads concurrently can lead to issues. It's recommended to use thread-safe alternatives when necessary.

**Potential Use case**: In legacy java codebase.

{% hint style="info" %}
Similar to `Date`, `java.util.Calendar` is considered a legacy class. For new development in Java 8 and above, it is recommended to use the `java.time` API. It offers more intuitive, thread-safe, and timezone-aware classes for date and time handling.
{% endhint %}

**Example:**&#x20;

```java
package org.example;

import lombok.extern.slf4j.Slf4j;

import java.util.Calendar;
import java.util.GregorianCalendar;

@Slf4j
public class Application {

    public static void main(String[] args) {
        Calendar calendar = Calendar.getInstance();

        // Get current date and time
        log.info("Current date and time: " + calendar.getTime());

        // Get specific calendar fields
        log.info("Year: {}", calendar.get(Calendar.YEAR));
        log.info("Month: {}", calendar.get(Calendar.MONTH) + 1); // Month is 0-based
        log.info("Day: {}", calendar.get(Calendar.DAY_OF_MONTH));

        // Add or subtract time
        calendar.add(Calendar.DAY_OF_MONTH, 5); // Add 5 days
        log.info("Date after adding 5 days: {}", calendar.getTime());

        // Check for leap year
        int year = 2024;
        // GregorianCalendar class is a concrete subclass of Calendar
        GregorianCalendar gregorianCalendar = new GregorianCalendar();

        if (gregorianCalendar.isLeapYear(year)) {
            log.info("{} is a leap year.", year);
        } else {
            log.info("{} is not a leap year.", year);
        }
    }
}
```

<figure><img src="../../.gitbook/assets/image (1) (1).png" alt=""><figcaption><p>Output</p></figcaption></figure>



### `java.time` (Java 8 and later)

**Description:** The `java.time` API, introduced in Java 8, provides a modern and improved set of classes for working with dates, times, and timezones. It addresses the limitations and complexities of the older `java.util.Date` and `java.util.Calendar` classes, offering improved design, thread-safety, and timezone handling.

It includes:&#x20;

* **Immutable classes:** Objects representing dates, times, and durations are immutable, meaning their state cannot be changed after creation. This ensures thread-safety and simplifies reasoning about your code.
* **Timezone support:** The API provides built-in support for handling timezones through the `ZoneId` class and related functionalities.
* **Wide range of classes:** It offers various classes for different date and time representations, including `LocalDate`, `LocalTime`, `LocalDateTime`, `Instant`, `Duration`, etc. catering to different use cases.

**Potential Use case**:

* **Date and time calculations:** Perform calculations like adding or subtracting days, weeks, months, etc., from a specific date or time.
* **Date and time formatting:** Format dates and times according to different locales and patterns.
* **Parsing date and time strings:** Convert strings representing dates and times into corresponding `java.time` objects.
* **Time zone handling:** Manage time zones effectively, considering different time zone offsets and rules.

**Classes:**

* **java.time.**<mark style="background-color:yellow;">**LocalDate**</mark>

The `LocalDate` class in the `java.time` API represents a date without time and timezone information. It's an immutable class, meaning its state cannot be changed after creation. It represents a date in the ISO-8601 calendar system.

> **Thread-safe:** Unlike `java.util.Date`, `LocalDate` is thread-safe, making it suitable for concurrent programming.&#x20;
>
> **Immutable:** Its immutability simplifies reasoning about your code and avoids accidental modifications.

**Example:**

```java
package org.example;

import lombok.extern.slf4j.Slf4j;
import java.time.LocalDate;
import java.time.Period;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

@Slf4j
public class Application {

    public static void main(String[] args) {
        // Get current date
        LocalDate currentDate = LocalDate.now();
        log.info("Current date: {}", currentDate);

        // Create a specific date
        LocalDate specificDate = LocalDate.of(2024, 12, 25);
        log.info("Specific date: {}", specificDate);

        // Get specific components of the date
        log.info("Year: {}", specificDate.getYear());
        log.info("Month value: {}", specificDate.getMonthValue());
        log.info("Month: {}", specificDate.getMonth().toString());
        log.info("Day of month: {}", specificDate.getDayOfMonth());
        log.info("Chronology: {}", specificDate.getChronology());
        log.info("Day of Week: {}", specificDate.getDayOfWeek());
        log.info("Day of Year: {}", specificDate.getDayOfYear());
        log.info("Era: {}", specificDate.getEra());

        // Check if a year is a leap year
        if (specificDate.isLeapYear()) {
            log.info("{} is a leap year.", specificDate);
        } else {
            log.info("{} is not a leap year.", specificDate);
        }

        // Add or subtract days, months, or years
        log.info("Date after adding 1 month: {}", specificDate.plusMonths(1));
        log.info("Date after subtracting 1 year: {}", specificDate.minusYears(1));

        // Compare dates
        if (currentDate.isBefore(specificDate)) {
            log.info("currentDate is before specificDate");
        } else if (currentDate.isEqual(specificDate)) {
            log.info("currentDate is equal specificDate");
        } else {
            log.info("currentDate is after specificDate");
        }

        // Calculate the period between two dates
        Period period = Period.between(currentDate, specificDate);
        log.info("Period between dates: {} years, {} months, {} days", period.getYears(), period.getMonths(), period.getDays());

        // Format dates to different locales
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM/dd/yyyy", Locale.ENGLISH);
        String formattedDate = specificDate.format(formatter);
        log.info("Formatted Data: {}", formattedDate);

        // Parse dates from strings
        String dateString = "2023-12-25";
        DateTimeFormatter isoFormatter = DateTimeFormatter.ISO_LOCAL_DATE;
        LocalDate parsedDate = LocalDate.parse(dateString, isoFormatter);
        log.info("Parsed Date: {}", parsedDate);
    }
}
```

<figure><img src="../../.gitbook/assets/image (2).png" alt=""><figcaption></figcaption></figure>



* j**ava.time.**<mark style="background-color:yellow;">**LocalTime**</mark>

The `LocalTime` class in the `java.time` API represents a time without a date or timezone information. It's an immutable class, meaning its state cannot be changed after creation. It represents a time in the 24-hour format (e.g., 10:15:30).

> **Thread-safe:** Unlike `java.util.Date`, `LocalTime` is thread-safe, making it suitable for concurrent programming.
>
> **Immutable:** Its immutability simplifies reasoning about your code and avoids accidental modifications.

**Example:**

```java
package org.example;

import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class Application {

    public static void main(String[] args) {
        // Get the current time
        LocalTime now = LocalTime.now();
        log.info("Current time: {}", now);

        // Create a specific time
        LocalTime specificTime = LocalTime.of(10, 30, 0); // 10:30 AM
        log.info("Specific time: {}", specificTime);

        // Get specific components of the time
        log.info("Hour: {}", specificTime.getHour());
        log.info("Minute: {}", specificTime.getMinute());
        log.info("Second: {}", specificTime.getSecond());

        // Add or subtract hours, minutes, or seconds
        LocalTime startTime = LocalTime.of(9, 0);
        LocalTime endTime = startTime.plusHours(2); // Add 2 hours
        LocalTime earlierTime = startTime.minusMinutes(30); // Subtract 30 minutes

        log.info("End time: {}", endTime);
        log.info("30 minutes earlier: {}", earlierTime);

        // Compare times
        if (startTime.isBefore(endTime)) {
            log.info("Start time is before end time");
        } else {
            log.info("Start time is after end time");
        }

        // Format times to different locales (eg US, FR)
        // Format in US English locale (12-hour format with AM/PM)
        DateTimeFormatter usFormatter = DateTimeFormatter.ofPattern("h:mm a", Locale.US);
        String formattedTimeUS  = now.format(usFormatter);
        log.info("Formatted current time (US English): {}", formattedTimeUS);

        // Format in French locale (24-hour format)
        DateTimeFormatter frenchFormatter = DateTimeFormatter.ofPattern("HH:mm", Locale.FRANCE);
        String formattedTimeFR = now.format(frenchFormatter);
        log.info("Formatted current time (French): {}", formattedTimeFR);

        // Parse times from strings
        String timeString = "18:30:00";
        DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_TIME;
        LocalTime parsedTime = LocalTime.parse(timeString, formatter);
        log.info("Parsed LocalTime object: {}", parsedTime);
    }
}
```

<figure><img src="../../.gitbook/assets/image (3).png" alt=""><figcaption><p>Output</p></figcaption></figure>



* j**ava.time.**<mark style="background-color:yellow;">**LocalDateTime**</mark>

The `java.time.LocalDateTime` class in Java combines the functionalities of `LocalDate` and `LocalTime` classes, representing both date and time information without timezone data. It's also an immutable class, ensuring thread-safety and simplifying reasoning about your code. Represents a date and time without timezone information (e.g., 2024-03-07T21:51:24)

**Example:**

```java
package org.example;

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class Application {

    public static void main(String[] args) {
        // Get the current date and time
        LocalDateTime now = LocalDateTime.now();
        log.info("Current date and time: {}", now);

        // Create a specific date and time
        LocalDateTime specificDatetime = LocalDateTime.of(2024, 12, 15, 10, 30);
        log.info("Specific date and time: {}", specificDatetime);

        // Combine a date with a specific time
        LocalDate date = LocalDate.of(2023, 12, 25);
        LocalTime time = LocalTime.of(12, 0);
        LocalDateTime datetime = LocalDateTime.of(date, time);
        log.info("Combined Datetime: {}", datetime);

        // Compare LocalDateTime objects
        if(now.isBefore(specificDatetime)) {
            log.info("Current datetime is before specific datetime");
        } else {
            log.info("Current datetime is after specific datetime");
        }

        // Calculate the duration between two LocalDateTime objects
        Duration duration = Duration.between(now, specificDatetime);
        log.info("Duration: {}", duration);

        // Format LocalDateTime objects to different formats
        DateTimeFormatter isoFormatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;
        String isoFormattedDateTime = now.format(isoFormatter);
        log.info("Formatted date and time (ISO): {}", isoFormattedDateTime);

        DateTimeFormatter customFormatter = DateTimeFormatter.ofPattern("dd-MM-yyyy hh:mm a");
        String customFormattedDateTime = now.format(customFormatter);
        log.info("Formatted date and time (custom): {}", customFormattedDateTime);

        // Parsing from a string
        String dateTimeString = "27-03-2024 11:30:13.998 pm";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy hh:mm:ss.SSS a");
        LocalDateTime parsedDateTime = LocalDateTime.parse(dateTimeString, formatter);
        log.info("Parsed LocalDateTime object: {}", parsedDateTime);
    }
}
```

<figure><img src="../../.gitbook/assets/image (7).png" alt=""><figcaption><p>Output</p></figcaption></figure>

{% hint style="info" %}
**Supported patterns in `DateTimeFormatter.ofPattern(...)`:**

* **d:** Day of the month, as a decimal number (1-31)
* **M:** Month of the year, as a decimal number (1-12)
* **y:** Year without a century, as a decimal number (00-99)
* **yyyy:** Year with century, as a decimal number (e.g., 2024)
* **HH:** Hour in 24-hour format (00-23)
* **h:** Hour in 12-hour format (1-12)
* **m:** Minutes, as a zero-padded decimal number (00-59)
* **a:** Meridian indicator (am or pm)
* **dd:** Represents the day of the month with two digits (01-31)
* **MM:** Represents the month as a number with two digits (01-12)
* **mm:** Represents the minutes with two digits (00-59)
* **ss:** Represents the seconds with two digits (00-59)
* **S:** Represent fractional seconds of a time value



&#x20;Refer to the Java documentation for more details - [https://docs.oracle.com/javase/8/docs/api/java/time/format/DateTimeFormatter.html](https://docs.oracle.com/javase/8/docs/api/java/time/format/DateTimeFormatter.html)
{% endhint %}



```java
String[] patterns = {
        "yyyy-MM-dd HH:mm:ss",
        "yyyy-MM-dd HH:mm:ss.S",
        "yyyy-MM-dd HH:mm:ss.SS",
        "yyyy-MM-dd HH:mm:ss.SSS",
        "yyyy-MM-dd HH:mm:ss.SSSS",
        "yyyy-MM-dd HH:mm:ss.SSSSSSSSS"
};

// Get the current date and time
LocalDateTime now = LocalDateTime.now();

for (String pattern : patterns) {
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern(pattern);
    log.info("Current date and time: {}", now.format(formatter));
}
```

<figure><img src="../../.gitbook/assets/image.png" alt=""><figcaption></figcaption></figure>



* **java.time.ZonedDateTime**

`ZonedDateTime` is a class introduced in Java 8 that represents a date and time with a time zone offset. It combines the functionalities of `LocalDateTime` (date and time without zone) and `ZoneId` (identifier for a time zone). Unlike `LocalDateTime`, `ZonedDateTime` is aware of the time zone context, making it useful for scenarios where time zone information is crucial. It stores date, time, and time zone information in a single object.

**Example:**

```java
package org.example;

import lombok.extern.slf4j.Slf4j;

import java.time.ZoneId;
import java.time.ZoneOffset;
import java.time.ZonedDateTime;

@Slf4j
public class Application {
    public static void main(String[] args) {
        // Creating ZonedDateTime from current system time (India)
        ZonedDateTime currentDateTime = ZonedDateTime.now();
        log.info("Current Date and Time in India: {}", currentDateTime);

        // Creating ZonedDateTime with a specific time zone
        ZonedDateTime dateTimeInNewYork = ZonedDateTime.now(ZoneId.of("America/New_York"));
        log.info("Date and Time in New York: {}", dateTimeInNewYork);

        // Creating ZonedDateTime with a UTC time zone
        ZonedDateTime dateTimeInUTC = ZonedDateTime.now(ZoneOffset.UTC);
        log.info("Date and Time in UTC: {}", dateTimeInUTC);
    }
}
```

<figure><img src="../../.gitbook/assets/image (15).png" alt=""><figcaption><p>Output</p></figcaption></figure>

{% hint style="info" %}
"T" serves as a separator between the date and time components according to the ISO 8601 standard format for representing date and time.
{% endhint %}

{% hint style="info" %}
**`ChronoUnit`**`:`&#x20;
{% endhint %}







