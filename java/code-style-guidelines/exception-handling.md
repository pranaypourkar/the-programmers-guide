# Exception Handling

## About

Exception handling in Java allows programs to detect, handle, and recover from runtime anomalies without crashing. From a **code style** perspective, how exceptions are named, structured, thrown, and logged plays a crucial role in making the code **clean**, **understandable**, and **maintainable**.

Consistent and thoughtful exception handling improves readability, debuggability, and developer communication. It’s not just about catching errors but doing so in a **clear**, **predictable**, and **meaningful** way.

## Importance of Exception Handling in Code Style

* **Improves Readability:** Clearly indicates failure scenarios and system boundaries.
* **Aids Debugging:** With consistent logging and message structure, issues are easier to trace.
* **Supports Maintainability:** Uniform exception style makes changes and reviews predictable.
* **Prevents Over-Catching or Silent Failures:** Encourages meaningful error propagation.
* **Establishes Intent:** Exceptions are a form of documentation for what can go wrong.

## General Best Practices

### 1. **Use Specific Exception Types**

Always prefer **custom or specific standard exceptions** over generic ones like `Exception`, `Throwable`, or `RuntimeException`.

```java
// Good
throw new InvalidAccountStateException("Account is already closed.");

// Avoid
throw new RuntimeException("Something went wrong.");
```

### 2. **Meaningful Exception Naming**

Custom exceptions should follow the `SomethingException` naming pattern and clearly describe the cause.

Examples:

* `UserNotFoundException`
* `InsufficientBalanceException`
* `InvalidTokenException`

### 3. **Avoid Empty Catch Blocks**

Do not swallow exceptions silently. If we catch an exception, **handle it or rethrow it**. An empty catch block is a major anti-pattern.

```java
// Bad
try {
    processUser();
} catch (Exception e) {
    // silently ignored
}

// Good
try {
    processUser();
} catch (UserNotFoundException e) {
    log.warn("User not found: {}", e.getMessage());
    throw e;
}
```

### 4. **Use `try-with-resources` for Closables**

Always use `try-with-resources` to automatically close resources like streams or DB connections.

```java
try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
    // read file
} catch (IOException e) {
    log.error("Failed to read file", e);
    throw new FileProcessingException("Could not read file", e);
}
```

### 5. **Avoid Catching `Exception` or `Throwable` Broadly**

Unless at the **application boundary**, avoid catching `Exception` or `Throwable`. It hides the actual error and risks catching things we shouldn't (like `OutOfMemoryError`).

```java
// Acceptable only at global handlers
@ExceptionHandler(Exception.class)
public ResponseEntity<ErrorResponse> handleAll(Exception e) {
    // generic fallback handler
}
```

### 6. **Always Log with Context**

When logging an exception, always include contextual information like entity ID, operation, or parameters, along with the stack trace.

```java
log.error("Failed to update user with ID {}", userId, ex);
```

### 7. **Use Exception Chaining (`cause`)**

Always preserve the original cause of the exception when wrapping it.

```java
try {
    paymentService.charge(card);
} catch (PaymentGatewayException ex) {
    throw new TransactionFailedException("Payment failed for order " + orderId, ex);
}
```

### 8. **Avoid Logic in Catch Blocks**

Use catch blocks to **log, rethrow, or translate** exceptions—not to hide or continue critical logic.

```java
try {
    inventoryService.reserve(productId, quantity);
} catch (OutOfStockException ex) {
    log.warn("Out of stock: {}", productId);
    throw ex;
}
```

### 9. **Do Not Use Exceptions for Flow Control**

Throwing and catching exceptions is expensive and semantically wrong for regular control flow.

```java
// Bad
try {
    Integer.parseInt(input);
} catch (NumberFormatException e) {
    return 0;
}

// Better
if (StringUtils.isNumeric(input)) {
    return Integer.parseInt(input);
} else {
    return 0;
}
```

### 10. **Centralize Exception Translation**

For Spring Boot apps, use a **ControllerAdvice** to handle and format exceptions globally.

```java
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(UserNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleUserNotFound(UserNotFoundException ex) {
        return ResponseEntity
            .status(HttpStatus.NOT_FOUND)
            .body(new ErrorResponse("USER_NOT_FOUND", ex.getMessage()));
    }
}
```

## Exception Class Code Style Guidelines

* Extend `RuntimeException` for unchecked exceptions (common in Spring apps).
* Include both message and cause constructors.
* Use `final` if not meant to be extended further.

```java
public class UserNotFoundException extends RuntimeException {
    public UserNotFoundException(String message) {
        super(message);
    }

    public UserNotFoundException(String message, Throwable cause) {
        super(message, cause);
    }
}
```

