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

## ZonedDateTime

### 1. Get current UTC time in yyyy-MM-dd'T'HH:mm:ss.SSSZ format

```java
ZonedDateTime utcNow = ZonedDateTime.now(ZoneOffset.UTC);
DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSSZ");
String formatted = utcNow.format(formatter);
System.out.println(formatted);  // Example: 2025-06-21T07:33:46.115+0000
```

### 2. Convert the current time to **Saudi Arabia time**, which is in the `Asia/Riyadh` time zone, and yyyy-MM-dd'T'HH:mm:ss.SSSZ format

```java
ZonedDateTime ksaTime = ZonedDateTime.now(ZoneId.of("Asia/Riyadh"));
DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSSZ");
String formatted = ksaTime.format(formatter);
System.out.println(formatted);  // Example: 2025-06-21T10:33:46.123+0300
```

## OffsetDateTime

### 1. Convert a given String OffsetDateTime to different Timezone

```java
import java.time.OffsetDateTime;
import java.time.ZoneId;

public class TimeZoneExample {
    public static void main(String[] args) {
        // Example OffsetDateTime
        OffsetDateTime dateTime = OffsetDateTime.parse("2023-05-15T07:08:59.077561Z");

        // Convert to a different time zone
        ZoneId desiredTimeZone = ZoneId.of("America/New_York");
        OffsetDateTime convertedDateTime = dateTime.withOffsetSameInstant(desiredTimeZone.getRules().getOffset(dateTime.toInstant()));

        System.out.println("Original DateTime: " + dateTime);
        System.out.println("Converted DateTime: " + convertedDateTime);
    }
}
```

### 2. OffsetDateTime to LocalDate

```java
import java.time.OffsetDateTime;
import java.time.LocalDate;

public class LocalDateExample {
    public static void main(String[] args) {
        // Example OffsetDateTime
        OffsetDateTime dateTime = OffsetDateTime.parse("2023-05-15T07:08:59.077561Z");

        // Extract the date component
        LocalDate localDate = dateTime.toLocalDate();

        System.out.println("Original DateTime: " + dateTime); // Original DateTime: 2023-05-15T07:08:59.077561Z
        System.out.println("Extracted Date: " + localDate); // Extracted Date: 2023-05-15
    }
}
```

### 3. OffsetDateTime to ZonedDateTime

```java
import java.time.OffsetDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;

public class TimeZoneExample {
    public static void main(String[] args) {
        // Example OffsetDateTime
        OffsetDateTime dateTime = OffsetDateTime.parse("2023-05-15T07:08:59.077561Z");

        // Convert to the KSA time zone (Arabia Standard Time)
        ZoneId ksaTimeZone = ZoneId.of("Asia/Riyadh");
        ZonedDateTime convertedDateTime = dateTime.atZoneSameInstant(ksaTimeZone);

        System.out.println("Original DateTime: " + dateTime);
        System.out.println("Converted DateTime (KSA): " + convertedDateTime);
    }
}
```

### 4. OffsetDateTime to String

```java
import java.time.OffsetDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;

public class TimeZoneExample {
    public static final ZoneId ZONEID_ASIA_RIYADH = ZoneId.of("Asia/Riyadh");
    public static final String DATE_FORMAT = "yyyy-MM-dd";
    public static final String TIME_FORMAT = "HH:mm:ss";

    public static void main(String[] args) {
        // Example OffsetDateTime
        OffsetDateTime paymentDateTime = OffsetDateTime.parse("2023-05-15T07:08:59.077561Z");

        // Convert to the "Asia/Riyadh" time zone and format the date and time components separately
        String formattedDate = paymentDateTime
                .atZoneSameInstant(ZONEID_ASIA_RIYADH)
                .format(DateTimeFormatter.ofPattern(DATE_FORMAT));

        String formattedTime = paymentDateTime
                .atZoneSameInstant(ZONEID_ASIA_RIYADH)
                .format(DateTimeFormatter.ofPattern(TIME_FORMAT));

        System.out.println("Original DateTime: " + paymentDateTime);
        System.out.println("Formatted Date: " + formattedDate);
        System.out.println("Formatted Time: " + formattedTime);
    }
}
```







