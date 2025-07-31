# Lambdas and Streams Style

## About

With the introduction of **lambda expressions** and the **Streams API** in Java 8, functional programming constructs became a first-class part of Java. Lambdas and streams make code more expressive and concise—but when misused, they can quickly reduce readability, introduce subtle bugs, or hinder maintainability.

From a **code style** perspective, the goal is to write stream and lambda code that is **clear**, **efficient**, and **consistent**.

## Importance of Styling Lambdas and Streams

* **Improves Readability:** Prevents cryptic or overly condensed code.
* **Encourages Correctness:** Reduces logical bugs from misuse (e.g., side-effects in streams).
* **Supports Consistency:** Ensures a common idiom is followed across the codebase.
* **Boosts Maintainability:** Developers can modify, debug, or extend functional code easily.
* **Promotes Functional Purity:** Encourages declarative and side-effect-free operations.

## Best Practices and Style Guidelines

### 1. **Use Clear and Descriptive Lambda Parameters**

Avoid single-letter or ambiguous variable names unless it's idiomatic (e.g., `e` for exception).

```java
// Bad
list.stream().map(x -> x.getName());

// Good
list.stream().map(user -> user.getName());
```

### 2. **Keep Lambda Expressions Short and Simple**

Long or multi-line lambdas reduce readability. Extract complex logic into separate methods.

```java
// Bad
list.stream().filter(user -> {
    if (user.isActive() && user.getAge() > 18 && !user.isDeleted()) {
        return true;
    }
    return false;
});

// Good
list.stream().filter(this::isEligibleUser);

private boolean isEligibleUser(User user) {
    return user.isActive() && user.getAge() > 18 && !user.isDeleted();
}
```

### 3. **Avoid Side Effects in Streams**

Streams are designed for **functional-style** transformations. Side effects (e.g., logging, mutations) break referential transparency and can introduce bugs.

```java
// Bad
list.stream().map(user -> {
    auditLog(user); // Side effect
    return user.getEmail();
});

// Good
list.stream().map(User::getEmail);
```

### 4. **Use Method References Where Clear**

Prefer method references (`Class::method`) over lambdas when it improves clarity.

```java
// Good
list.stream().map(User::getName);

// Avoid
list.stream().map(user -> user.getName()); // Less concise, more verbose
```

Only use method references when they **don't hide intent**.

### 5. **Avoid Mixing Imperative and Functional Styles**

Do not mix loops or mutable state inside stream pipelines.

```java
// Bad
List<String> result = new ArrayList<>();
list.stream().forEach(item -> result.add(transform(item))); // Mutates result

// Good
List<String> result = list.stream()
    .map(this::transform)
    .collect(Collectors.toList());
```

### 6. **Use `.collect()` and `.toList()` over Manual Accumulation**

From Java 16+, use `Collectors.toUnmodifiableList()` or `stream().toList()` for clarity.

```java
// Good (Java 16+)
List<String> names = users.stream()
    .map(User::getName)
    .toList();
```

### 7. **Chain Calls Indent-Style: One Call per Line**

For long pipelines, break method calls into new lines with consistent indentation.

```java
List<String> emails = users.stream()
    .filter(User::isActive)
    .map(User::getEmail)
    .distinct()
    .sorted()
    .toList();
```

Avoid compacting everything into a single unreadable line.

### 8. **Use `Optional` Chaining Properly**

Avoid excessive `ifPresent` or `orElse` chains. Instead, write Optional code that is declarative and readable.

```java
// Good
userRepository.findById(id)
    .map(User::getEmail)
    .ifPresent(this::sendNotification);
```

### 9. **Prefer `filter().findFirst()` over `findAny().get()`**

```java
// Bad
User user = users.stream()
    .filter(u -> u.getName().equals("John"))
    .findAny()
    .get(); // Risk of NoSuchElementException

// Good
User user = users.stream()
    .filter(u -> u.getName().equals("John"))
    .findFirst()
    .orElseThrow(() -> new UserNotFoundException("User not found"));
```

### 10. **Avoid Over-Nesting of Streams**

Nested `stream().map().flatMap()` chains can become difficult to read. Simplify using intermediate methods.

```java
// Bad
list.stream()
    .flatMap(parent -> parent.getChildren().stream())
    .filter(child -> child.isActive())
    .collect(Collectors.toList());

// Good
list.stream()
    .map(Parent::getChildren)
    .flatMap(Collection::stream)
    .filter(Child::isActive)
    .toList();
```

### 11. **Avoid Terminal Operations That Do Nothing**

```java
// Bad
users.stream().map(User::getName); // No terminal operation

// Good
List<String> names = users.stream().map(User::getName).toList();
```

Every stream must end in a **terminal operation** (`collect`, `forEach`, `count`, `reduce`, etc.).

### 12. **Don’t Overuse Streams for Simple Logic**

If the operation is simple and readable with a loop, prefer that instead of a stream.

```java
// Better as a loop
for (User user : users) {
    if (user.isBlocked()) {
        return true;
    }
}
```

```java
// Fine with stream
return users.stream().anyMatch(User::isBlocked);
```

Use our judgment—**streams are not always better**.
