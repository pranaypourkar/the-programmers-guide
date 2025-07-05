# RandomStringUtils

## About

`RandomStringUtils` is a utility class from **Apache Commons Lang** that provides **static methods for generating random strings**.

It is useful for:

* Generating random IDs
* Temporary passwords
* Test data
* Nonces or tokens
* Unique filenames

Unlike `java.util.Random` or `UUID`, `RandomStringUtils` allows **full control over the characters used**, the **length of the string**, and whether to include **letters**, **numbers**, or a **custom character set**.

## Characteristics

* All methods are **static**.
* Allows control over **string length**, **character composition**, and **custom characters**.
* Works well for **mock data generation**, **test automation**, and **security use-cases**.
* Internally uses `java.util.Random`, not cryptographically secure.

## Maven Dependency & Import

```xml
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-lang3</artifactId>
    <version>3.12.0</version> <!-- or latest -->
</dependency>
```

```java
import org.apache.commons.lang3.RandomStringUtils;
```

## Common Methods

### 1. `random(int count)`

Generates a random string of given length, using letters and numbers.

```java
String result = RandomStringUtils.random(10);
// Example: "aK93LdX0tY"
```

### 2. `randomAlphabetic(int count)`

Generates a string with only **alphabetic** characters (A–Z, a–z).

```java
String name = RandomStringUtils.randomAlphabetic(8);
// Example: "htRkLoXi"
```

### 3. `randomAlphanumeric(int count)`

Generates a string with **letters and digits**.

```java
String token = RandomStringUtils.randomAlphanumeric(16);
// Example: "f3hL9skD3wPq7BzM"
```

### 4. `randomNumeric(int count)`

Generates a string with **only digits**.

```java
String otp = RandomStringUtils.randomNumeric(6);
// Example: "827349"
```

### 5. `randomAscii(int count)`

Generates a string with printable **ASCII characters (32–126)**.

```java
String ascii = RandomStringUtils.randomAscii(10);
// Example: "+f#xG9!%P@"
```

### 6. `random(int count, char[] chars)`

Generates a random string using **custom character set**.

```java
char[] charset = {'A', 'B', 'C', '1', '2', '3'};
String custom = RandomStringUtils.random(5, charset);
// Example: "2CB1A"
```

### 7. `random(int count, boolean letters, boolean numbers)`

Generates a string with option to include only letters, only numbers, or both.

```java
String id = RandomStringUtils.random(8, true, false); // only letters
String code = RandomStringUtils.random(6, false, true); // only numbers
String mix = RandomStringUtils.random(10, true, true); // both
```

## Important Notes

1. It is **not cryptographically secure**. Do not use it for secure password generation or tokenization.

**What it means:**

* `RandomStringUtils` uses a regular random number generator under the hood (`java.util.Random`), which is **fast but predictable**.
* If someone knows how it generates values, they could **guess or reproduce** the random strings.
* This makes it **unsafe for sensitive data** such as:
  * Passwords
  * Access tokens
  * Session IDs
  * API keys
  * Encryption keys

**Why it's a problem:**

* In a secure system, these values must be **unpredictable and unique**, even if someone knows the logic.
* Using a weak random generator could allow attackers to **guess valid values**, leading to security breaches.



2. For secure use cases, prefer `java.security.SecureRandom` or `UUID.randomUUID()`.

**What to use instead:**

1. **`SecureRandom`**
   * It’s designed for **cryptographic use** and generates random numbers that are **hard to predict**.
   *   Example:

       ```java
       SecureRandom secureRandom = new SecureRandom();
       byte[] bytes = new byte[16];
       secureRandom.nextBytes(bytes);
       String secureToken = Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
       ```
   * Use cases:
     * Token generation
     * Password reset links
     * Secure OTPs
     * Any sensitive data
2. **`UUID.randomUUID()`**
   * Generates a **universally unique identifier** (UUID) using cryptographically strong random values (on most JVMs).
   *   Example:

       ```java
       String uuid = UUID.randomUUID().toString();
       ```
   * Safe for:
     * Unique IDs
     * Tracking identifiers
     * Public reference codes
   * Not ideal for:
     * Short random strings
     * Human-friendly formats (too long and complex)

## Comparison: `RandomStringUtils` vs Alternatives

<table data-header-hidden data-full-width="true"><thead><tr><th></th><th></th><th></th><th></th></tr></thead><tbody><tr><td>Feature</td><td><code>RandomStringUtils</code></td><td><code>UUID</code></td><td><code>SecureRandom</code></td></tr><tr><td>Custom length</td><td>Yes</td><td>No (always 36 chars)</td><td>Yes</td></tr><tr><td>Custom characters</td><td>Yes</td><td>No</td><td>Yes (manual)</td></tr><tr><td>Letters/numbers only</td><td>Yes</td><td>No</td><td>Yes (manual)</td></tr><tr><td>Cryptographically secure</td><td>No</td><td>Yes</td><td>Yes</td></tr><tr><td>Simple and quick</td><td>Yes</td><td>Yes</td><td>No (more code required)</td></tr></tbody></table>

