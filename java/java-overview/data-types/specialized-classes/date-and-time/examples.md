# Examples

## LocalDate

### 1. Extract day of week

Given input is year, monthe and day. Find the day of week.

```java
public String getDay(int day, int month, int year) {
    LocalDate localDate = LocalDate.of(year, month, day);
    return  localDate.getDayOfWeek().name(); // Example: WEDNESDAY
}
```

## LocalDateTime

### 1. Given a date and time in string. Attach a timezone to it.

```java
LocalDateTime date = LocalDateTime.parse("2023-09-11T11:40");
```

This `LocalDateTime` **has no timezone information** — it just means _"11:40 on Sept 11th, 2023"_, but not in any particular zone.

```java
// System default: UTC
ZonedDateTime utcZoned = date.atZone(ZoneId.of("UTC"));

// KSA: Asia/Riyadh (UTC+3)
ZonedDateTime ksaZoned = date.atZone(ZoneId.of("Asia/Riyadh"));

System.out.println("UTC Zoned: " + utcZoned.toInstant()); // UTC Zoned: 2023-09-11T11:40:00Z
System.out.println("KSA Zoned: " + ksaZoned.toInstant()); // KSA Zoned: 2023-09-11T08:40:00Z

// Convert to Date
Date ksaDate = Date.from(ksaZoned.toInstant());
Date utcDate = Date.from(utcZoned.toInstant());
```

{% hint style="info" %}
Notice: **same `LocalDateTime`, different `Instant`** based on the zone.
{% endhint %}

