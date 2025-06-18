# Code Smells to Avoid

## About

A **code smell** is a surface-level symptom in the code that may indicate deeper problems in structure, readability, or maintainability. In the context of **code style**, code smells refer to patterns that make the code harder to read, understand, test, or evolve—even if the code “works.”

Recognizing and avoiding these smells leads to cleaner, more professional code that’s easier to review, maintain, and extend.

## Importance of Identifying Style-Based Code Smells

* **Improves Code Quality:** Enforces clarity and prevents errors caused by ambiguity.
* **Enhances Maintainability:** Clean, smell-free code is easier to modify without breaking.
* **Simplifies Reviews:** Code reviewers can focus on logic instead of formatting or cleanup.
* **Promotes Team Consistency:** Everyone follows the same principles, reducing friction.
* **Facilitates Onboarding:** New developers can quickly understand code structure and intent.

## Common Code Style Smells to Avoid

### 1. **Long Methods**

**Symptom:** A single method spans dozens or hundreds of lines.

**Why It’s a Smell:**

* Violates Single Responsibility Principle (SRP).
* Hard to read and test.

**Preferred Style:**

* Break into smaller, well-named private methods.

```java
// Bad
public void processRequest(Request request) {
    // dozens of lines...
}

// Good
public void processRequest(Request request) {
    validate(request);
    enrich(request);
    persist(request);
}
```

### 2. **Inconsistent Indentation or Spacing**

**Symptom:** Mixed tabs and spaces, irregular line breaks, or misaligned code blocks.

**Why It’s a Smell:**

* Reduces readability.
* Causes noise in diffs.

**Preferred Style:**

* Use 4-space indentation.
* Apply auto-formatting tools consistently.

### 3. **Excessive Inline Comments for Obvious Code**

**Symptom:** Comments explaining what a clearly named method or variable already implies.

```java
// Bad
int age = 18; // user's age
processData(); // call the process data method

// Good
int userAge = 18;
processUserData();
```

**Why It’s a Smell:**

* Adds noise, clutters code.
* Indicates poor naming rather than a need for a comment.

### 4. **Magic Numbers and Strings**

**Symptom:** Hard-coded literals scattered in logic.

```java
// Bad
if (statusCode == 500) {
    retry();
}

// Good
private static final int SERVER_ERROR = 500;
```

**Why It’s a Smell:**

* Reduces readability.
* Makes changes error-prone.

### 5. **Poor Naming Conventions**

**Symptom:** Non-descriptive, inconsistent, or abbreviated variable and method names.

```java
// Bad
int x; // what's x?
void doStuff() {}


// Good
int retryAttempts;
void calculateTransactionTotal() {}
```

**Why It’s a Smell:**

* Makes intent unclear.
* Slows down understanding and maintenance.

### 6. **Duplicated Code Blocks**

**Symptom:** Identical or very similar logic repeated in multiple places.

**Why It’s a Smell:**

* Violates DRY (Don’t Repeat Yourself).
* Increases risk of bugs during updates.

**Preferred Style:**

* Extract common code into a shared method.

### 7. **Empty Catch Blocks**

**Symptom:** Catching an exception and doing nothing or just adding a comment.

```java
// Bad
try {
    callService();
} catch (Exception e) {
    // ignored
}
```

**Why It’s a Smell:**

* Silently swallows errors.
* Makes debugging nearly impossible.

**Fix:**

* Log the error or rethrow it with context.

### 8. **Deep Nesting**

**Symptom:** Excessive levels of `if`, `for`, or `try` blocks.

```java
// Bad
if (user != null) {
    if (user.getProfile() != null) {
        if (user.getProfile().getAddress() != null) {
            ...
        }
    }
}
```

**Why It’s a Smell:**

* Reduces readability.
* Increases cognitive load.

**Preferred Style:**

* Use guard clauses and null-safe methods (e.g., `Optional`).

### 9. **Large Classes (“God Classes”)**

**Symptom:** A class doing too many unrelated things.

**Why It’s a Smell:**

* Difficult to understand, test, or reuse.

**Preferred Style:**

* Split by responsibility.
* Use service decomposition, interfaces, or helper classes.

### 10. **Unnecessary Comments or TODOs Left Behind**

**Symptom:** Outdated or vague comments that no longer match the code.

```java
// TODO: Fix this later
processOrder();  // Already fixed

// Bad
// This function adds two numbers
public int add(int a, int b) {
    return a + b;
}
```

**Why It’s a Smell:**

* Misleads readers.
* Adds clutter and confusion.

### 11. **Overuse of Static Utility Methods**

**Symptom:** Everything in a utility class is static, even if state or configuration might be needed.

**Why It’s a Smell:**

* Reduces testability and flexibility.
* Can violate object-oriented principles.

**Preferred Style:**

* Use dependency injection where appropriate.

### 12. **Non-Descriptive Test Names**

**Symptom:** Unit tests with names like `test1()`, `validateSomething()`, or `shouldWork()`.

**Why It’s a Smell:**

* Test purpose is unclear.
* Hard to diagnose failures.

**Preferred Style:**

```java
@Test
void shouldReturnValidTokenWhenCredentialsAreCorrect() {
    // ...
}
```



