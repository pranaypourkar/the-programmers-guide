# Method Guidelines

## About

In Java, methods define the core behavior of your classes and services. Clean and consistent method design is crucial to code readability, maintainability, and collaboration. Good method practices help ensure clarity of purpose, ease of debugging, and long-term sustainability of the codebase.

## Importance of Method Design in Code Style

* **Improves readability and predictability**: Clear, consistent method names make code self-explanatory.
* **Encourages reusability**: Well-scoped, single-responsibility methods are easier to test and reuse.
* **Enforces separation of concerns**: Keeps business logic organized and modular.
* **Facilitates unit testing**: Smaller and well-defined methods are easier to test in isolation.
* **Supports long-term maintenance**: Clean method structure prevents accidental misuse or duplication.

## Method Naming Conventions

* Method names should be **verbs** or **verb phrases**, describing what the method does.
* Use **camelCase**: `calculateTax`, `getCustomerDetails`, `saveInvoice`.
* Be explicit; avoid abbreviations and unclear terms.

**Examples**:

```java
public void processPayment() {}
public String fetchCustomerByEmail(String email) {}
public boolean isUserAuthorized(User user, Action action) {}
```

## Method Length and Responsibility

* A method should **do one thing and do it well**.
* Prefer **short methods (5–20 lines)**. If a method is too long or performs multiple tasks, break it down.
* If a method name requires "and", consider splitting it.

```java
// Too much responsibility
public void validateAndSaveUser(User user) { ... }

// Better
public void validateUser(User user) { ... }
public void saveUser(User user) { ... }
```

#### **General Recommendations**

* **Ideal**: 10–20 lines (excluding blank lines and comments).
* **Acceptable upper bound**: \~30 lines (for methods like controller handlers or config methods).
* **Warning zone**: >30 lines should be carefully reviewed and likely refactored.
* **Red flag**: >50 lines is almost always a sign the method is doing too much.

## Method Visibility

* Use the **lowest necessary visibility**.
* Avoid public methods unless needed outside the class or component.
* Use `private` for internal helpers, `protected` for subclasses, and `package-private` for internal package APIs.

## Method Parameters

* Limit parameters to **three or fewer**. If more are needed, encapsulate them in a parameter object or DTO.
* Ensure parameter names are meaningful and follow camelCase.

```java
// Not ideal
public void createUser(String name, int age, String email, String address) { ... }

// Better
public void createUser(UserDto userDto) { ... }
```

## Return Types

* Return meaningful data — avoid returning `null` if possible. Prefer `Optional<T>` for optional values.
* Be explicit in return types. Avoid returning raw `Map`, `List`, or `Object`.

```java
// Prefer
public Optional<User> findUserById(String id);

// Avoid
public User getData(); // unclear what data is
```

## Method Documentation

* Use **Javadoc** for public methods and libraries.
* Comment only when the method’s behavior isn’t obvious from the name and signature.
* Avoid redundant comments that repeat the method name.

```java
/**
 * Calculates the net salary after applying tax deductions.
 *
 * @param grossSalary Total income before deductions.
 * @return Net salary.
 */
public BigDecimal calculateNetSalary(BigDecimal grossSalary) { ... }
```

## Method Overloading

* Use overloading judiciously. Ensure overloaded methods serve the same logical purpose and vary only by input types or parameters.

```java
public void log(String message) { ... }
public void log(String message, Throwable throwable) { ... }
```

## Avoid Side Effects

* Methods should do what their names suggest — no surprises.
* Avoid modifying external state unless clearly intended.

```java
// Avoid
public List<User> fetchUsersAndUpdateCache() { ... }

// Better
public List<User> fetchUsers() { ... }
public void updateUserCache(List<User> users) { ... }
```

## Consistent Method Ordering

Follow a logical structure in classes:

1. Public methods first
2. Then protected
3. Then package-private
4. Private methods last
5. Helper methods below the main logic

Example in a service class:

```java
public void processTransaction() { ... }

private boolean isAccountValid(Account account) { ... }

private void notifyUser(User user) { ... }
```

## Boolean Methods

* Use `is`, `has`, `can`, or `should` prefixes for boolean-returning methods.

```java
public boolean isEligibleForDiscount() { ... }
public boolean hasSufficientBalance() { ... }
```
