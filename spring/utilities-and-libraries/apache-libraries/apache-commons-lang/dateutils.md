# DateUtils

## About

`DateUtils` is a utility class provided by **Apache Commons Lang** to simplify working with `java.util.Date`. It provides **null-safe**, **immutable**, and **convenient** methods for:

* Date comparison
* Date truncation and rounding
* Adding or subtracting time units
* Setting specific fields of a date
* Calculating ranges (start of day/week/month)
* Iterating over date ranges

## Characteristics

* Works primarily with `java.util.Date` (not `java.time.*`)
* All methods are **static**
* Provides **safe and readable** alternatives to manual `Calendar` manipulations
* Often used in legacy systems still relying on `Date` instead of `LocalDate` or `ZonedDateTime`

## Maven Dependency & Import

```xml
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-lang3</artifactId>
    <version>3.12.0</version> <!-- or latest -->
</dependency>
```

```java
import org.apache.commons.lang3.time.DateUtils;
```

## Common Methods

### 1. Date Comparison

<table data-full-width="true"><thead><tr><th>Method</th><th>Description</th></tr></thead><tbody><tr><td><code>isSameDay(Date d1, Date d2)</code></td><td>Checks if both dates fall on the same day</td></tr><tr><td><code>isSameInstant(Date d1, Date d2)</code></td><td>Checks if both dates represent the same instant</td></tr><tr><td><code>isSameLocalTime(Date d1, Date d2)</code></td><td>Checks if both dates have the same local time</td></tr><tr><td><code>truncatedEquals(Date d1, Date d2, int field)</code></td><td>Checks equality after truncating to a field</td></tr></tbody></table>

**Example:**

```java
Date today = new Date();
Date another = DateUtils.addHours(today, 2);
boolean sameDay = DateUtils.isSameDay(today, another); // true
```

### 2. Truncation and Rounding

| Method                           | Description                                   |
| -------------------------------- | --------------------------------------------- |
| `truncate(Date date, int field)` | Resets lower fields to zero (e.g., time part) |
| `round(Date date, int field)`    | Rounds up/down to the nearest field boundary  |
| `ceiling(Date date, int field)`  | Rounds up to the next unit                    |

**Example:**

```java
Date truncated = DateUtils.truncate(new Date(), Calendar.DAY_OF_MONTH);
// Returns date at 00:00:00 of the same day
```

### 3. Adding or Subtracting

| Method                          | Description               |
| ------------------------------- | ------------------------- |
| `addDays(date, int days)`       | Adds or subtracts days    |
| `addHours(date, int hours)`     | Adds or subtracts hours   |
| `addMinutes(date, int minutes)` | Adds or subtracts minutes |
| `addMonths(date, int months)`   | Adds or subtracts months  |
| `addWeeks(date, int weeks)`     | Adds or subtracts weeks   |
| `addYears(date, int years)`     | Adds or subtracts years   |

**Example:**

```java
Date future = DateUtils.addDays(new Date(), 7); // 7 days later
Date past = DateUtils.addMonths(new Date(), -1); // 1 month ago
```

### 4. Setting Fields

| Method                          | Description            |
| ------------------------------- | ---------------------- |
| `setYears(date, int year)`      | Sets the year field    |
| `setHours(date, int hour)`      | Sets the hour field    |
| `setMinutes(date, int minutes)` | Sets the minutes field |

**Example:**

```java
Date updated = DateUtils.setHours(new Date(), 15); // sets to 3 PM
```

### 5. Date Range Utilities

<table data-full-width="true"><thead><tr><th width="450.95745849609375">Method</th><th>Description</th></tr></thead><tbody><tr><td><code>iterator(Date start, Date end, int rangeStyle)</code></td><td>Iterates over date ranges (e.g., by day/week)</td></tr></tbody></table>

**Example:**

```java
Iterator<?> days = DateUtils.iterator(new Date(), DateUtils.RANGE_WEEK_CENTER);
while (days.hasNext()) {
    System.out.println(days.next());
}
```

## Why Use `DateUtils` Instead of Raw Java?

<table data-header-hidden data-full-width="true"><thead><tr><th></th><th></th><th></th></tr></thead><tbody><tr><td>Task</td><td>Without <code>DateUtils</code></td><td>With <code>DateUtils</code></td></tr><tr><td>Compare two dates (same day)</td><td>Complex <code>Calendar</code> logic</td><td><code>DateUtils.isSameDay(d1, d2)</code></td></tr><tr><td>Truncate to midnight</td><td>Manual time setting to zero</td><td><code>DateUtils.truncate(date, Calendar.DATE)</code></td></tr><tr><td>Add 1 week</td><td><code>Calendar.add(...)</code></td><td><code>DateUtils.addWeeks(date, 1)</code></td></tr><tr><td>Iterate through days</td><td>Manual loops and increment</td><td><code>DateUtils.iterator(...)</code></td></tr></tbody></table>



