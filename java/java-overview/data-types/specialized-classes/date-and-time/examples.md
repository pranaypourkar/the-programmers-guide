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



