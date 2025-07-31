# Naming Convention

## About

Naming conventions are a fundamental part of code style that define how developers name variables, classes, methods, packages, constants, and other identifiers in a program. These conventions are not enforced by the compiler, but when followed consistently, they make code easier to read, maintain, and collaborate on.

Consistent naming conveys meaning, intent, and structure — and helps developers understand what the code is doing without needing extensive documentation. A good naming convention makes it easier to onboard new team members, reduce bugs, improve code reviews, and communicate intent across teams.

In Java, naming conventions are well-established and supported by most IDEs and tools. Adhering to these conventions signals professionalism, enhances productivity, and ensures better compatibility with third-party libraries and frameworks.

## Java Naming Conventions

### 1. **Package Names**

* Use all **lowercase** letters.
* Use your organization’s **reverse domain name** as the root.
* Avoid underscores and camelCase.
* Use meaningful package names representing features, not technical details.

{% hint style="success" %}

{% endhint %}

**Example:**

```java
// Good
com.example.billing.invoice
org.companyname.product.module.submodule
com.uber.payment.gateway
org.example.hr.attendance

// Bad
com.Example.HRModule
com.uber_Payment
```

### 2. **Class and Interface Names**

* Use **PascalCase** (a.k.a. UpperCamelCase).
* Should be **nouns** representing entities or concepts.
* Interfaces typically describe a capability (e.g., `Readable`, `Sortable`).
* Avoid using prefixes like `I` (e.g., `IUserService`) — unnecessary in Java.

{% hint style="success" %}
**Character Length Guidelines**

Ideally between **3 to 30 characters**.

* Too short names (e.g., `Usr`, `Mgr`) can be cryptic.
* Too long names (>30) become unwieldy, e.g., `CustomerAccountManagementServiceImpl`.
* Use meaningful compound words with camel case to keep clarity.
{% endhint %}

**Example:**

```java
// Good
public class UserAccount { ... }
public interface PaymentGateway { ... }
public class OrderProcessor { }
public interface Auditable { }

// Bad
public class orderprocessor { }  // Starts with lowercase
public interface IAuditable { } // 'I' prefix is not Java idiomatic
```

### 3. **Enum Names and Constants**

* Enum type: **PascalCase**
* Enum constants: **ALL\_UPPERCASE** with underscores between words.

**Example:**

```java
public enum OrderStatus {
    PENDING,
    APPROVED,
    REJECTED
}
```

### 4. **Method Names**

* Use **camelCase**.
* Should be **verbs** or verb phrases that clearly state the method’s action.
* Prefer clarity over brevity.
* Should describe the result or behavior, not the implementation.

{% hint style="success" %}
**Character Length Guidelines**

Typically **3 to 40 characters**.

* Should express the action clearly.
* Keep names concise but descriptive enough to avoid guessing.
* Examples:
  * Good: `calculateInterestRate()`, `isUserAuthorized()`
  * Too long: `calculateAnnualPercentageRateBasedOnUserCreditScore()`
{% endhint %}

**Examples:**

<pre class="language-java"><code class="lang-java"><strong>// Good
</strong><strong>public void processPayment() { ... }
</strong>public String getCustomerEmail() { ... }
public void updateCustomerAddress() { }
public boolean hasActiveSubscription() { }

// Bad
public void doThing(); // unclear
public void doIt(); // Unclear intent
</code></pre>

### 5. **Variable Names**

* Use **camelCase**.
* Should be **short but descriptive**.
* Avoid non-standard abbreviations and single letters (except loop counters).
* Should reflect the **purpose or contents**.

{% hint style="success" %}
**Character Length Guidelines**

Between **1 to 20 characters**, depending on scope.

* Short variables (like `i`, `j`, `k`) acceptable in small loops or anonymous usage.
* Otherwise, use descriptive names like `customerEmail`, `retryCount`.
* Avoid excessively long names that reduce code readability.
{% endhint %}

**Examples:**

```java
// Good
int totalItems;
String customerName;
List<Order> unpaidOrders;
String customerName;
int retryCount;
List<Order> pendingOrders;

// Bad
int t; // unclear
String nm; // abbreviated
```

### 6. **Boolean Variables**

* Prefix with **is**, **has**, **can**, or **should** to convey truthy meaning.

**Examples:**

```java
// Good
boolean isActive;
boolean hasPermission;
boolean canRetry;
boolean shouldRetry;
boolean isVerified;
boolean hasUnpaidInvoices;

// Bad
boolean retryFlag; // unclear intent
boolean verifiedStatus; // Less clear when used in conditions
```

### 7. **Constants**

* Use **ALL\_UPPERCASE** with underscores.
* Should be `public static final`.
* Names should be meaningful and reflect fixed values.

**Examples:**

```java
public static final int MAX_RETRY_ATTEMPTS = 3;
public static final String DEFAULT_CURRENCY = "USD";
```

### 8. **Generic Type Parameters**

* Single uppercase letters by convention:
  * `T` – Type
  * `E` – Element
  * `K`, `V` – Key, Value (for Maps)
  * `R` – Return type

For better readability in domain-specific contexts, descriptive names like `Payload`, `Response`, or `Request` can be used.

**Examples:**

```java
public interface Repository<T> { ... }

public class ApiResponse<Payload> { ... }
```

### **9. Test Method Naming**

* Should describe **what is being tested** and **under what condition**.
* Use **camelCase** or `snake_case` for readability.
* Avoid vague names like `test1()` or `testMethod()`.

**Examples:**

```java
shouldThrowExceptionWhenAmountIsNegative()
calculateTax_shouldReturnZeroForEmptyOrder()
```

### 10. **Layer-Specific Naming Conventions (Optional but Helpful)**

Adopting a **suffix-based naming strategy** for layered components enhances clarity:

<table><thead><tr><th width="149.5546875">Layer</th><th width="290.5859375">Naming Pattern</th><th>Example</th></tr></thead><tbody><tr><td>Controller</td><td>Ends with <code>Controller</code></td><td><code>CustomerController</code></td></tr><tr><td>Service</td><td>Ends with <code>Service</code></td><td><code>NotificationService</code></td></tr><tr><td>Repository/DAO</td><td>Ends with <code>Repository</code></td><td><code>OrderRepository</code>, <code>UserDAO</code></td></tr><tr><td>DTO</td><td>Ends with <code>Dto</code> or <code>Request/Response</code></td><td><code>UserRequestDto</code>, <code>OrderResponse</code></td></tr><tr><td>Entity</td><td>Ends with <code>Entity</code></td><td><code>InvoiceEntity</code></td></tr></tbody></table>

## General Guidelines

### 1. Avoiding Abbreviations and Acronyms

* Avoid abbreviations unless:
  * They are widely recognized (e.g., `URL`, `HTTP`, `ID`).
  * They enhance clarity without causing confusion.
* When using acronyms, follow casing rules:
  * Acronyms in class names: capitalize first letter only: `XmlParser` (not `XMLParser`)
  * Acronyms in constants: all uppercase `MAX_URL_LENGTH`
* Examples:
  * Good: `userId`, `httpRequest`
  * Bad: `usrId`, `htpReq`

### 2. Reserved Keywords and Avoiding Collisions

* Never use Java reserved keywords as identifiers (`class`, `int`, `package`, etc.).
* Avoid names that collide with standard library classes (e.g., naming a class `String` or `List`).

### 3. Naming and Readability Trade-offs

*   Avoid **overly descriptive names** that break readability:

    ```java
    // Too verbose and hard to read:
    int numberOfTimesUserHasAttemptedLoginFailureAndWasBlocked;

    // Better:
    int loginFailureCount;
    ```
* Balance descriptiveness with brevity.

### 4. Maximum Identifier Length in Java

* Java language specification does not enforce strict max length for identifiers.
* However, JVM implementations or tools may have limits (usually large, e.g., 65535 bytes).
* In practice, keep identifiers **under 255 characters** for compatibility and tooling ease.

### 5. Unicode and Non-ASCII Characters

* Java supports Unicode in identifiers.
* **Avoid** using non-ASCII characters for identifiers, even if allowed, to ensure:
  * Code portability
  * Ease of typing and sharing
  * Compatibility with various tools and editors
