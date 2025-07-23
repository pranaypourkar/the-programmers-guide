# Class Structure

## About

Class structure refers to the **standardized layout and organization** of elements inside a Java class — such as fields, constructors, methods, and nested types. A clean, consistent class structure significantly improves **readability**, **maintainability**, and **navigability** for all developers working on the codebase.

Following a predictable structure ensures that anyone reviewing or maintaining the code can quickly understand its purpose and behavior without unnecessary scanning or confusion.

## Importance of Consistent Class Structure

* **Improves Readability:** Readers know where to look for fields, constructors, and logic.
* **Supports Maintainability:** Makes future refactors safer and faster.
* **Encourages Logical Separation:** Helps prevent mixing unrelated concerns in one place.
* **Simplifies Code Review:** Clear layout reduces the mental effort needed to understand changes.
* **Promotes Consistency:** Across modules, teams, and contributors.

## Recommended Order of Class Members

A typical Java class should follow this structure (each section separated by a blank line):

```
1. Class-level Javadoc / annotations
2. Constant fields (static final)
3. Static fields
4. Instance fields
5. Constructors
6. Public methods
7. Protected methods
8. Private methods
9. Getters and setters (if applicable)
10. Inner/nested types (if any)
```

## Class-Level Guidelines

### 1. **Class Declaration**

* Use meaningful names that reflect the class responsibility.
* Add class-level JavaDoc for public and core classes.
* Apply annotations (`@Service`, `@Component`, etc.) before the class.

```java
/**
 * Handles business logic for managing customer accounts.
 */
@Service
public class CustomerAccountService {
    // ...
}
```

### 2. **Constants First**

All `static final` constants should come first, grouped and optionally commented.

```java
public class TokenService {

    private static final int TOKEN_EXPIRY_MINUTES = 15;
    private static final String TOKEN_PREFIX = "Bearer ";

    // ...
}
```

### 3. **Static Fields and Initializers**

Next come non-final static fields (if any), e.g., `Logger` or shared caches.

```java
private static final Logger logger = LoggerFactory.getLogger(TokenService.class);
```

### 4. **Instance Variables (Fields)**

* Declare private by default.
* Use clear naming (`userRepository`, `cacheService`).
* Group by type or functionality (e.g., dependencies together, configuration together).

```java
private final UserRepository userRepository;
private final CacheService cacheService;
private String currentToken;
```

### 5. **Constructors**

* Use constructor injection in Spring for mandatory dependencies.
* Avoid logic in constructors other than field assignment.

```java
public TokenService(UserRepository userRepository, CacheService cacheService) {
    this.userRepository = userRepository;
    this.cacheService = cacheService;
}
```

### 6. **Public Methods**

Public methods are typically business methods (e.g., `generateToken()`, `validateToken()`).

* Group logically (e.g., CRUD operations together).
* Add JavaDoc if the behavior is non-obvious.
* Keep method size small and cohesive.

### 7. **Protected Methods**

Use for extensibility if necessary. For abstract or base classes, put template methods here.

### 8. **Private Methods**

Used to encapsulate helper or breakdown logic. Place private methods after the public logic they support (top-down readability).

### 9. **Getters and Setters**

If using Lombok, prefer `@Getter`, `@Setter`, or `@Data` only where needed. Otherwise, place them at the bottom unless part of an interface contract.

### 10. **Inner Classes / Enums / Interfaces**

If needed, place them at the end of the file. Use sparingly, and only if tightly coupled with the outer class.

```java
public enum TokenType {
    ACCESS,
    REFRESH
}
```

## Example

```java
/**
 * Service responsible for managing user notifications.
 * <p>
 * This service handles the creation, queuing, and sending of notifications
 * via various channels like email and SMS. It relies on external client services
 * to dispatch messages and logs audit information for traceability.
 *
 * <p>Dependencies are injected via constructor. This service is stateless.
 *
 * @author
 * @since 1.0
 */
@Service
@Validated
public class NotificationService {

    // === Constants ===
    public static final String EMAIL_CHANNEL = "EMAIL";
    public static final String SMS_CHANNEL = "SMS";

    // === Static Fields ===
    private static final Logger logger = LoggerFactory.getLogger(NotificationService.class);

    // === Instance Fields ===
    private final EmailClient emailClient;
    private final SmsClient smsClient;
    private final AuditService auditService;

    // Used only for testing or fallback scenarios
    protected boolean isSimulationEnabled = false;

    private int retryCount = 3;

    // === Constructor ===

    /**
     * Constructs the notification service with required dependencies.
     *
     * @param emailClient   client to send emails
     * @param smsClient     client to send SMS
     * @param auditService  service to log audit trails
     */
    public NotificationService(
        EmailClient emailClient,
        SmsClient smsClient,
        AuditService auditService
    ) {
        this.emailClient = emailClient;
        this.smsClient = smsClient;
        this.auditService = auditService;
    }

    // === Public Methods ===

    /**
     * Sends a notification message through the specified channel.
     *
     * @param message the message to be sent
     * @param channel the communication channel (EMAIL or SMS)
     */
    public void sendNotification(String message, String channel) {
        logger.info("Preparing to send message via {}", channel);

        switch (channel) {
            case EMAIL_CHANNEL -> sendEmail(message);
            case SMS_CHANNEL -> sendSms(message);
            default -> throw new UnsupportedOperationException("Unsupported channel: " + channel);
        }

        auditService.logAction("NOTIFICATION_SENT", Map.of("channel", channel));
    }

    /**
     * Enables simulation mode for non-production environments.
     */
    public void enableSimulation() {
        this.isSimulationEnabled = true;
    }

    // === Protected Methods ===

    /**
     * Adjusts retry count dynamically during integration testing or under load.
     */
    protected void setRetryCount(int count) {
        this.retryCount = count;
    }

    // === Private Methods ===

    private void sendEmail(String message) {
        if (isSimulationEnabled) {
            logger.warn("Simulation: Email message not actually sent.");
            return;
        }
        emailClient.send(message);
        logger.debug("Email sent successfully.");
    }

    private void sendSms(String message) {
        if (isSimulationEnabled) {
            logger.warn("Simulation: SMS message not actually sent.");
            return;
        }
        smsClient.send(message);
        logger.debug("SMS sent successfully.");
    }

    // === Inner Enums ===

    public enum NotificationType {
        WELCOME,
        PASSWORD_RESET,
        ALERT
    }
}
```
