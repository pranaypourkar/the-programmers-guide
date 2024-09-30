---
description: Overview of built-in Enum provided in Java.
---

# Pre-Defined Enum

### ChronoUnit

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

