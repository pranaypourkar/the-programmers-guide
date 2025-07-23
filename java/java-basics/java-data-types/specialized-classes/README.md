# Specialized Classes - TBU

## About

Specialized classes in Java are designed to address specific use cases, offering functionality beyond basic data manipulation. These classes, part of Java’s standard library, provide advanced features such as handling large numbers, high-precision arithmetic, date and time operations, and more. They simplify complex operations and enhance the robustness of applications.

## **BigInteger**

* Represents arbitrarily large integer values.
* Used in cryptography, mathematical computations, and scenarios requiring precision beyond the range of `int` or `long`.

```java
BigInteger big1 = new BigInteger("9876543210123456789");
BigInteger big2 = new BigInteger("1234567890123456789");
BigInteger result = big1.add(big2);
System.out.println("Result: " + result);
```

## **BigDecimal**

* Handles arbitrary-precision decimal numbers.
* Essential for financial calculations where precision is crucial.

```java
BigDecimal price = new BigDecimal("19.99");
BigDecimal quantity = new BigDecimal("3");
BigDecimal total = price.multiply(quantity).setScale(2, RoundingMode.HALF_UP);
System.out.println("Total: " + total);
```

## **Optional**

* Represents optional values to avoid `null` and prevent `NullPointerException`.
* Encapsulates a value that may or may not be present.
* Provides methods like `isPresent()`, `orElse()`, `orElseThrow()`, and `ifPresent()`.

```java
Optional<String> optionalName = Optional.ofNullable("John");
optionalName.ifPresent(name -> System.out.println("Hello, " + name));
```

## **Math**

* Provides utility methods for basic numeric operations.
* Includes functions for trigonometry, logarithms, rounding, and random number generation.
* Methods are static and easy to use.

```java
double sqrt = Math.sqrt(16);
double random = Math.random();
System.out.println("Square Root: " + sqrt);
System.out.println("Random Number: " + random);
```

## **Date and Time API (java.time)**

* Simplifies date and time manipulation.
* Introduced in Java 8 to address shortcomings of older `Date` and `Calendar` classes.

**Key Classes**

1. **LocalDate**: Represents a date without time.
2. **LocalTime**: Represents time without date.
3. **LocalDateTime**: Combines date and time.
4. **ZonedDateTime**: Includes timezone.

```java
LocalDate today = LocalDate.now();
LocalTime now = LocalTime.now();
LocalDateTime dateTime = LocalDateTime.now();
System.out.println("Today: " + today);
System.out.println("Current Time: " + now);
System.out.println("Date and Time: " + dateTime);
```

## **UUID**

* Generates unique identifiers.
* Commonly used for database primary keys, distributed systems, or identifiers in APIs.
* Provides 128-bit unique identifiers.
* Ensures uniqueness across distributed systems.

```java
UUID uniqueID = UUID.randomUUID();
System.out.println("Unique ID: " + uniqueID);
```

## **Scanner**

* Simplifies reading user input from various sources (console, files, strings).
* Parses primitive types and strings.
* Offers methods like `nextInt()`, `nextLine()`, and `nextDouble()`.

```java
Scanner scanner = new Scanner(System.in);
System.out.println("Enter your name:");
String name = scanner.nextLine();
System.out.println("Hello, " + name);
```

## **Formatter**

* Formats strings, numbers, and dates in a customizable manner.
* Supports format specifiers like `%s`, `%d`, and `%f`.
* Allows localization.

```java
String formatted = String.format("Name: %s, Age: %d", "John", 25);
System.out.println(formatted);
```

## **Properties**

* Used for configuration management by storing key-value pairs.
* Supports file input and output.
* Commonly used for application settings.

```java
Properties properties = new Properties();
properties.setProperty("url", "http://example.com");
properties.setProperty("username", "admin");
System.out.println(properties.getProperty("url"));
```

## **Regex (Pattern and Matcher)**

* Provides pattern matching for strings.
* `Pattern` class compiles regular expressions.
* `Matcher` class matches patterns against inputs.

```java
Pattern pattern = Pattern.compile("\\d+");
Matcher matcher = pattern.matcher("123abc");
if (matcher.find()) {
    System.out.println("Found: " + matcher.group());
}
```

## **Atomic Classes**

* Supports atomic operations on variables for thread-safe programming.
* `AtomicInteger`, `AtomicLong`, `AtomicBoolean`.

```java
AtomicInteger counter = new AtomicInteger(0);
counter.incrementAndGet();
System.out.println("Counter: " + counter);
```

## **Random**

* Generates random numbers.
* Supports customizable random number generation.
* Provides methods like `nextInt()`, `nextDouble()`, and `nextBoolean()`.

```java
Random random = new Random();
int randomNumber = random.nextInt(100);
System.out.println("Random Number: " + randomNumber);
```

