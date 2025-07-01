# REGEX

## About

Regular Expressions (regex) are **patterns used to match sequences of characters**. In Spring applications, regex plays an important role across various modules such as:

* Web request routing
* Data validation
* Security rules
* Conditional bean creation
* Service-layer logic

Regex increases flexibility by allowing **dynamic pattern matching** rather than relying on hardcoded values.

## 1. REGEX in Controller URL Mapping

Spring allows the use of regex in path variables to restrict the format of dynamic URL segments. This is useful for building routes that **only match specific patterns**, such as numeric IDs, usernames, UUIDs, or custom tokens.

#### Syntax

In `@GetMapping`, `@RequestMapping`, or `@PostMapping`, regex can be added inside `{variable:regex}`.

#### Example

```java
@GetMapping("/product/{id:[0-9]+}")
public ResponseEntity<String> getProductById(@PathVariable String id) {
    return ResponseEntity.ok("Valid product ID: " + id);
}
```

* This endpoint matches `/product/123`, but not `/product/abc`.
* Regex used: `[0-9]+` (one or more digits).

#### Use Case Scenarios

* Enforce numeric-only IDs in URLs
* Match slugs (e.g., `{slug:[a-z0-9-]+}`)
* Route based on specific formats like dates or UUIDs

## 2. REGEX in Bean Validation using `@Pattern`

Spring Boot integrates with Jakarta Bean Validation (JSR 380, formerly JSR 303), which includes `@Pattern` annotation to validate strings using regex. This is typically used in DTOs, forms, and REST request bodies.

#### Example

```java
public class UserRequest {

    @Pattern(regexp = "^[a-zA-Z]{3,20}$", message = "Name must contain only letters and be 3 to 20 characters long")
    private String name;

    @Pattern(regexp = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$", message = "Invalid email format")
    private String email;
}
```

* This ensures name and email follow the required patterns.
* Annotate the controller method with `@Valid` or `@Validated`.

```java
@PostMapping("/register")
public ResponseEntity<String> register(@Valid @RequestBody UserRequest userRequest) {
    return ResponseEntity.ok("User Registered");
}
```

#### Why Use It?

* Avoids manual validation logic
* Centralizes format rules
* Makes validation declarative and reusable

## 3. REGEX in Spring Security (`regexMatchers`)

Spring Security allows us to apply access control based on **URL patterns using regex**. This provides **fine-grained control** over access to endpoints.

#### Example

```java
@Override
protected void configure(HttpSecurity http) throws Exception {
    http
        .authorizeRequests()
        .regexMatchers("/admin/[0-9]{4}").hasRole("ADMIN")
        .regexMatchers("/user/[a-z]+").hasRole("USER")
        .anyRequest().authenticated();
}
```

* `/admin/1234` will be accessible only to users with `ADMIN` role.
* `/user/john` will be accessible only to users with `USER` role.

#### Why Use It?

* More flexible than Ant-style (`/admin/**`)
* Enables dynamic access rules based on format (e.g., only allow numeric IDs)

## 4. REGEX in Spring Expressions (`@ConditionalOnExpression`)

Spring Expression Language (SpEL) can use regex for **conditional logic**, such as loading beans only if a property matches a pattern.

#### Example

```java
@ConditionalOnExpression("#{systemProperties['env'] matches 'dev|qa'}")
@Bean
public DataSource testDataSource() {
    return new HikariDataSource();
}
```

* This bean is only loaded when the system property `env` is set to `dev` or `qa`.

#### Benefits

* Enables environment-specific configuration using patterns
* Helps in feature toggling or staged deployment logic

## 5. REGEX in Property Files (External Config)

We can define regex patterns in `application.properties` or `application.yml` and inject them for use in validation or pattern matching in services.

#### Example

**application.properties:**

```properties
regex.email=^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$
```

**Service:**

```java
@Value("${regex.email}")
private String emailRegex;

public boolean isValid(String email) {
    return Pattern.matches(emailRegex, email);
}
```

This allows updating validation rules **without changing code**.

## 6. REGEX Using `java.util.regex.Pattern` in Services

We can manually use regex for advanced matching in service-layer logic, especially for scenarios not covered by annotations.

#### Example

```java
public boolean isPhoneNumberValid(String number) {
    Pattern pattern = Pattern.compile("^\\+91[0-9]{10}$");
    Matcher matcher = pattern.matcher(number);
    return matcher.matches();
}
```

This is useful when:

* Building custom validation logic
* Processing or filtering large text inputs
* Integrating regex in business rules

## 7. REGEX with Apache Commons `RegexValidator`

Apache Commons Validator provides a reusable, thread-safe way to use regex in our services.

#### Example

```java
RegexValidator validator = new RegexValidator("^[0-9]{6}$");
if (validator.isValid("560001")) {
    System.out.println("Valid PIN code");
}
```

## 8. REGEX in File Parsing and Text Processing

Regular expressions (regex) are essential for **extracting**, **filtering**, **transforming**, and **validating** patterns in text. In Spring Boot (or any Java application), when reading files or processing strings, regex provides a powerful and flexible way to work with content dynamically.

#### Key Use Cases

* Searching for specific lines in a file (e.g., error logs)
* Extracting structured data (e.g., phone numbers, email addresses)
* Replacing or cleaning unwanted characters or formats
* Parsing logs, CSVs, and configuration files
* Validating structured inputs like dates, IDs, codes

Regex is especially helpful when:

* File formats are not standardized (e.g., free text logs)
* We need to process large text files line by line
* We want to apply complex pattern-based rules

### 1. Filtering Lines that Match a Pattern

We may want to process only lines that contain a specific keyword or pattern from a large file (like logs or reports).

#### Example – Extract lines containing "ERROR"

```java
try (Stream<String> lines = Files.lines(Paths.get("app.log"))) {
    lines.filter(line -> line.matches(".*ERROR.*"))
         .forEach(System.out::println);
}
```

* `.*ERROR.*` matches any line containing the word "ERROR".
* Efficient for scanning and reporting.

### 2. Extracting Data from a Line (Pattern Matching)

Use regex groups to extract specific parts of a line. Ideal for logs, delimited text, or loosely structured content.

#### Example – Extract timestamp and level from a log line

Log line:

```
[2024-06-21 14:23:45] INFO - Payment completed
```

```java
String line = "[2024-06-21 14:23:45] INFO - Payment completed";
Pattern pattern = Pattern.compile("\\[(.*?)\\]\\s+(INFO|ERROR|DEBUG)\\s+-\\s+(.*)");
Matcher matcher = pattern.matcher(line);

if (matcher.matches()) {
    String timestamp = matcher.group(1);
    String level = matcher.group(2);
    String message = matcher.group(3);

    System.out.println("Time: " + timestamp);
    System.out.println("Level: " + level);
    System.out.println("Message: " + message);
}
```

This approach is excellent for structured log analysis or custom reporting tools.

### 3. Replacing or Cleaning Text

Regex is often used to sanitize data by removing unwanted characters, trimming patterns, or replacing formats.

#### Example – Remove all special characters from a string

```java
String input = "Hello@Spring#2025!";
String cleaned = input.replaceAll("[^a-zA-Z0-9 ]", "");
System.out.println(cleaned); // Output: HelloSpring2025
```

#### Example – Replace all multiple spaces with a single space

```java
String messy = "This   is    Spring Boot";
String normalized = messy.replaceAll("\\s+", " ");
```

Useful for normalizing inconsistent inputs.

### 4. Validating Each Line in a File

Apply validation rules to each line (e.g., is it a valid email, phone number, or ID).

#### Example – Check if all lines are valid email addresses

```java
Pattern emailPattern = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");

try (BufferedReader reader = Files.newBufferedReader(Paths.get("emails.txt"))) {
    String line;
    while ((line = reader.readLine()) != null) {
        if (!emailPattern.matcher(line).matches()) {
            System.out.println("Invalid email: " + line);
        }
    }
}
```

This technique helps validate file-based input in batch jobs, ETL processes, or user uploads.

### 5. Extracting All Occurrences from a Single Line

Use `find()` method to match multiple occurrences of a pattern in the same string.

#### Example – Extract all numbers from a sentence

```java
String input = "Order 123 has 3 items and costs 450 rupees";
Pattern pattern = Pattern.compile("\\d+");
Matcher matcher = pattern.matcher(input);

while (matcher.find()) {
    System.out.println("Number: " + matcher.group());
}
```

Use this in analytics, reporting, or transformation scenarios.

### 6. Parsing Delimited Files with Optional Validation

While CSVs can be parsed with libraries (like OpenCSV), regex helps when we have inconsistent or semi-structured files.

#### Example – Parse and validate simple CSV manually

```
john,25,john@example.com
mary,abc,mary@example
```

```java
Pattern linePattern = Pattern.compile("^\\w+,(\\d+),([A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+)$");

try (Stream<String> lines = Files.lines(Paths.get("users.csv"))) {
    lines.forEach(line -> {
        if (linePattern.matcher(line).matches()) {
            System.out.println("Valid: " + line);
        } else {
            System.out.println("Invalid: " + line);
        }
    });
}
```

### 7. Detecting Sensitive Information in Logs

Regex can be used to detect and redact sensitive fields such as passwords, keys, tokens, or credit card numbers before logging.

#### Example – Mask password field in a string

```java
String logLine = "username=admin&password=secret123&token=abc";
String masked = logLine.replaceAll("password=[^&]+", "password=****");
System.out.println(masked);
```

This is useful for log filtering and compliance with security standards.

### 8. Custom Regex Utility Method

#### Example – Generic reusable utility

```java
public class RegexUtils {
    public static boolean matches(String pattern, String input) {
        return Pattern.compile(pattern).matcher(input).matches();
    }

    public static List<String> extractAll(String pattern, String input) {
        Matcher matcher = Pattern.compile(pattern).matcher(input);
        List<String> results = new ArrayList<>();
        while (matcher.find()) {
            results.add(matcher.group());
        }
        return results;
    }
}
```

Usage:

```java
RegexUtils.matches("^\\d{4}$", "2025"); // true
RegexUtils.extractAll("\\d+", "Amount 300 paid on 2024-06-21");
```
