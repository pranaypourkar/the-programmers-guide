# Comments and Documentation

## About

Comments and documentation in code are essential for **communicating intent**, **explaining logic**, and **guiding future developers** through complex areas. Unlike code, which tells the compiler what to do, comments explain **why** the code exists in its current form. Documentation complements this by providing high-level understanding of modules, classes, and APIs.

Comments and documentation **do not replace good code**, but they enhance its readability, especially in large teams or long-term projects.

## Why Comments and Documentation Matter

* **Preserve developer intent:** Explain non-obvious decisions and trade-offs.
* **Aid in onboarding:** Help new developers understand the purpose and flow.
* **Support maintainability:** Guide future debugging, refactoring, or enhancement.
* **Ensure clarity in complex logic:** Especially where business rules or algorithms are involved.
* **Generate API docs:** Javadoc and tools like Swagger use comments to build reference documentation.

## Types of Comments in Java

### 1. **Single-line Comments**

Used to clarify a single line or block of code. Keep them short and relevant.

```java
// Check if the user is already registered
if (userRepository.existsByEmail(email)) {
    throw new DuplicateUserException("Email already exists");
}
```

### 2. **Multi-line Comments**

Used for detailed explanations or block-level comments.

```java
/*
 * This block handles the failover mechanism for the external API.
 * If the primary client fails, it attempts a fallback to the secondary client.
 */
```

### 3. **Javadoc Comments**

Used to document **public classes, methods, fields**, and **APIs**. These are machine-parsable and used in tools like Swagger, IDE popups, and generated docs.

```java
/**
 * Retrieves the user profile for the given ID.
 *
 * @param userId the ID of the user
 * @return the user profile
 * @throws ResourceNotFoundException if the user is not found
 */
public UserProfile getUserProfile(String userId) {
    // ...
}
```

## Commenting Best Practices

### 1. **Explain "Why", not "What"**

Avoid stating the obvious. Focus on intent, reasoning, or business rules.

```java
// Bad: adds no value
// Increment the count
count++;

// Good: explains intent
// Increment retry count after failed attempt
retryCount++;
```

### 2. **Use Complete Sentences with Proper Capitalization and Punctuation**

```java
// Good
// Skip this user if email is invalid or missing.
```

### 3. **Avoid Redundant Comments**

Redundant comments clutter the code.

```java
// Bad: obvious from the method name
// This method calculates the tax
public BigDecimal calculateTax(BigDecimal amount) {
    // ...
}
```

### 4. **Keep Comments Updated**

Outdated comments are worse than no comments. Always update comments when refactoring.

### 5. **Use TODOs and FIXMEs Appropriately**

These should be used sparingly and must include the **reason** and optionally the **developer initials** or **tracking reference**.

```java
// TODO: Optimize the loop to use parallel streams. (Issue #124)
```

### 6. **Avoid Over-commenting**

Don't explain basic Java syntax. Aim for clarity through self-explanatory code, then comment only where necessary.

```java
// Bad
// Declare an integer i
int i = 0;
```

## Javadoc Best Practices

* Use Javadoc for all **public APIs**, especially in libraries or services.
* Describe:
  * Purpose of the class or method.
  * Parameters (`@param`), return value (`@return`), and exceptions (`@throws`).
  * Usage examples (for complex methods or utility classes).
* Avoid implementation details unless crucial.

```java
/**
 * Sends an email using the configured SMTP server.
 *
 * @param to the recipient email address
 * @param subject the email subject
 * @param body the email content
 * @throws MessagingException if sending fails
 */
public void sendEmail(String to, String subject, String body) throws MessagingException {
    // ...
}
```

## Documentation for Spring Boot Projects

### 1. **Controllers and Endpoints**

* Use Javadoc to document each REST endpoint.
* Tools like **Swagger/OpenAPI** use annotations to auto-generate readable API documentation.

```java
/**
 * Retrieves all active users.
 *
 * @return list of active users
 */
@GetMapping("/users/active")
public List<User> getActiveUsers() {
    // ...
}
```

### 2. **Configuration Properties**

Use `@ConfigurationProperties` and provide Javadoc to help understand the use of each property.

```java
/**
 * Configuration properties for connecting to the payment gateway.
 */
@ConfigurationProperties(prefix = "payment.gateway")
public record PaymentGatewayConfig(
    String apiKey,
    String endpointUrl,
    int timeout
) {}
```

### 3. **Domain and Utility Classes**

* Include comments for fields in domain models if their purpose is non-obvious.
* Add Javadoc to utility methods (especially static helpers).

```java
/**
 * Utility class for date conversions between formats.
 */
public class DateUtils {

    /**
     * Converts a local date to ISO 8601 string.
     *
     * @param date the local date
     * @return ISO 8601 formatted string
     */
    public static String toIsoDate(LocalDate date) {
        // ...
    }
}
```
