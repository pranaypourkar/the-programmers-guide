---
description: Overview of built-in Enum provided in Java.
---

# Pre-Defined Enum

## About

A **Predefined Enum** refers to an enum that is commonly used or provided by a library or framework (such as Java's own standard enums). These enums provide frequently-used constants, such as `TimeUnit` or `DayOfWeek` in Java, that offer built-in methods and functionality based on the type.

## Examples of Predefined Enums in Java

### java.time.temporal.ChronoUnit

It is an enum in the `java.time.temporal` package in Java, introduced in Java 8 as part of the `java.time` package for date and time manipulation. It represents units of time, such as days, hours, minutes, seconds, etc., and provides a way to perform date and time arithmetic. `ChronoUnit` constants can be used along with methods like `plus` and `minus` to add or subtract a specified amount of time from a date-time object.

Here are some commonly used `ChronoUnit` constants:

> * `NANOS`: Nanoseconds
> * `MICROS`: Microseconds
> * `MILLIS`: Milliseconds
> * `SECONDS`: Seconds
> * `MINUTES`: Minutes
> * `HOURS`: Hours
> * `DAYS`: Days
> * `WEEKS`: Weeks
> * `MONTHS`: Months
> * `YEARS`: Years
> * `DECADES`: Decades
> * `CENTURIES`: Centuries
> * `MILLENNIA`: Millennia
> * `ERAS`: Eras

```java
ZonedDateTime currentDateTime = ZonedDateTime.now();
ZonedDateTime futureDateTime = currentDateTime.plus(3, ChronoUnit.HOURS);
ZonedDateTime pastDateTime = currentDateTime.minus(1, ChronoUnit.DAYS);
```

### java.util.concurrent.TimeUnit

Used for specifying time durations in multithreaded code.

Constants include `NANOSECONDS`, `MICROSECONDS`, `MILLISECONDS`, `SECONDS`, `MINUTES`, `HOURS`, and `DAYS`.

```java
long duration = TimeUnit.SECONDS.toMillis(10); // Converts 10 seconds to milliseconds
```

### java.time.DayOfWeek

Part of the `java.time` package, this enum represents days of the week.

Constants include `MONDAY`, `TUESDAY`, `WEDNESDAY`, etc.

Built-in methods like `.plus(int days)` make it easy to calculate future or past days.

```java
DayOfWeek today = DayOfWeek.MONDAY;
DayOfWeek tomorrow = today.plus(1); // Returns TUESDAY
```

### java.nio.file.StandardOpenOption

Provides options for file operations, such as `READ`, `WRITE`, `APPEND`, and `CREATE`.

These options are used in file I/O to specify how the file should be handled.

```java
Files.write(path, data, StandardOpenOption.APPEND);
```



