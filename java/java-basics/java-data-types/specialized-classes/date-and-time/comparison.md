# Comparison

## About

In Java, comparing dates and times is a common task — for example, to check if a deadline has passed, to sort events chronologically, or to filter records within a time range.

Java provides multiple date-time APIs, and the comparison techniques vary slightly based on the API being used.

The most commonly used classes for date and time comparison are:

* `java.util.Date` (legacy)
* `java.time.LocalDate`, `LocalDateTime`, `ZonedDateTime` (Java 8+)

## java.util.Date

**Methods**

* `compareTo(Date anotherDate)`
* `before(Date when)`
* `after(Date when)`
* `equals(Object obj)`

**Example**

```java
import java.util.Date;

Date now = new Date();
Date future = new Date(now.getTime() + 10000); // 10 seconds later

System.out.println(now.before(future));       // true
System.out.println(now.after(future));        // false
System.out.println(now.compareTo(future));    // -1
System.out.println(now.equals(future));       // false
```

## java.util.Calendar

**Methods**

* `compareTo(Calendar other)`
* `before(Object when)`
* `after(Object when)`
* `equals(Object obj)`

**Example**

```java
import java.util.Calendar;

Calendar c1 = Calendar.getInstance();
Calendar c2 = Calendar.getInstance();
c2.add(Calendar.HOUR, 1); // 1 hour later

System.out.println(c1.before(c2));            // true
System.out.println(c1.after(c2));             // false
System.out.println(c1.compareTo(c2));         // -1
```

## java.sql.Timestamp

**Methods**

* Inherits from `java.util.Date`
* Compares including nanoseconds

**Example**

```java
import java.sql.Timestamp;

Timestamp t1 = new Timestamp(System.currentTimeMillis());
Timestamp t2 = new Timestamp(t1.getTime() + 5000); // 5 seconds later

System.out.println(t1.before(t2));             // true
System.out.println(t1.after(t2));              // false
System.out.println(t1.compareTo(t2));          // -1
```

## java.time (Java 8 and later)



### java.time.LocalDate

**Example**

```java
import java.time.LocalDate;

LocalDate d1 = LocalDate.of(2024, 1, 1);
LocalDate d2 = LocalDate.of(2024, 12, 31);

System.out.println(d1.isBefore(d2));          // true
System.out.println(d1.isAfter(d2));           // false
System.out.println(d1.compareTo(d2));         // -1
System.out.println(d1.isEqual(d2));           // false
```

### java.time.LocalTime

**Example**

```java
import java.time.LocalTime;

LocalTime t1 = LocalTime.of(10, 0);
LocalTime t2 = LocalTime.of(14, 30);

System.out.println(t1.isBefore(t2));          // true
System.out.println(t1.isAfter(t2));           // false
System.out.println(t1.compareTo(t2));         // -1
```

### java.time.LocalDateTime

**Example**

```java
import java.time.LocalDateTime;

LocalDateTime dt1 = LocalDateTime.of(2024, 6, 1, 10, 0);
LocalDateTime dt2 = LocalDateTime.of(2024, 6, 1, 12, 0);

System.out.println(dt1.isBefore(dt2));        // true
System.out.println(dt1.compareTo(dt2));       // -1
```

### java.time.ZonedDateTime

**Example**

```java
import java.time.ZonedDateTime;
import java.time.ZoneId;

ZonedDateTime z1 = ZonedDateTime.now(ZoneId.of("UTC"));
ZonedDateTime z2 = ZonedDateTime.now(ZoneId.of("Asia/Kolkata"));

System.out.println(z1.isBefore(z2));          // depends on actual time
System.out.println(z1.compareTo(z2));         // positive or negative
```

### java.time.OffsetDateTime

**Example**

```java
import java.time.OffsetDateTime;
import java.time.ZoneOffset;

OffsetDateTime o1 = OffsetDateTime.now(ZoneOffset.UTC);
OffsetDateTime o2 = OffsetDateTime.now(ZoneOffset.ofHours(5));

System.out.println(o1.isBefore(o2));          // depends on system time
System.out.println(o1.compareTo(o2));         // depends on offset difference
```

### java.time.instant

**Example**

```java
import java.time.Instant;

Instant i1 = Instant.now();
Instant i2 = i1.plusSeconds(60); // 1 minute later

System.out.println(i1.isBefore(i2));          // true
System.out.println(i1.compareTo(i2));         // -1
```

### java.time.duration

**Example**

```java
import java.time.Duration;
import java.time.LocalTime;

LocalTime start = LocalTime.of(9, 0);
LocalTime end = LocalTime.of(11, 0);

Duration d1 = Duration.between(start, end);
Duration d2 = Duration.ofHours(3);

System.out.println(d1.compareTo(d2));         // -1 (2h < 3h)
System.out.println(d1.isZero());              // false
System.out.println(d1.isNegative());          // false
```

### java.time.period

**Example**

```java
import java.time.LocalDate;
import java.time.Period;

LocalDate today = LocalDate.of(2024, 1, 1);
LocalDate future = LocalDate.of(2025, 1, 1);

Period p1 = Period.between(today, future);
Period p2 = Period.ofMonths(6);

System.out.println(p1.compareTo(p2));         // 1 (12 months > 6)
System.out.println(p1.isZero());              // false
System.out.println(p1.isNegative());          // false
```
