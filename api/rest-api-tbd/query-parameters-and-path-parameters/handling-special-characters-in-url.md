# Handling Special Characters in URL

## About

When working with REST APIs, it's common to pass data in the URL using path parameters or query parameters. However, certain characters are **reserved** or have special meaning in URLs. If not handled properly, these characters can cause errors or change the meaning of the URL.

## Why It Matters

Some characters are reserved in URLs, such as:

* `/` (used to separate path segments)
* `?` (starts query string)
* `&` (separates query parameters)
* `#` (fragment identifier)
* `%` (used for encoding)
* `+`, `=`, `:`, `@`, and others

If these appear in data we are passing as part of the URL, they must be **encoded** to avoid breaking the URL structure.

## Allowed Characters in a URL (Unencoded)

According to the URI specification (RFC 3986), only a specific set of characters are allowed **unencoded** in a URL. These characters are considered **safe** or **unreserved**, and everything else should be **percent-encoded**.

### 1. **Unreserved Characters** (Allowed Anywhere in URL)

These are always safe to use in URLs without encoding:

* **Alphanumeric characters**:\
  `A–Z`, `a–z`, `0–9`
* **Special characters**:\
  `-` (hyphen), `_` (underscore), `.` (period), `~` (tilde)

These characters have **no special meaning** in the URL structure.

### **2. Reserved Characters** (Allowed but Must Be Encoded if Used as Data)

These characters are **allowed in a URL**, but they have **special meanings**, so they **must be encoded if used as literal data**

### 3. **Examples of a Valid URL (Unencoded parts only)**

```
https://example.com/users/john_doe
```

* `https` → uses unreserved letters
* `/users/john_doe` → uses `/`, letters, `_`
* No special characters like `&`, `@`, or `=` are present unencoded

## Special Characters which are Not Allowed

Technically, **URLs can contain only a specific set of characters**. Other characters must be **percent-encoded** using URL encoding (also known as percent-encoding). These characters are either:

1. **Reserved characters** – used to control URL structure
2. **Unsafe characters** – cause parsing issues or are not allowed
3. **Non-ASCII characters** – must always be encoded

### 1. Reserved Characters (Need Encoding if Used as Data)

These characters have special meaning in URLs and must be **encoded when used as data** (e.g., in path or query parameter values):

| Character | Purpose                     | Encoded As |
| --------- | --------------------------- | ---------- |
| `:`       | Protocol delimiter or port  | `%3A`      |
| `/`       | Path separator              | `%2F`      |
| `?`       | Begins query string         | `%3F`      |
| `#`       | Fragment identifier         | `%23`      |
| `[`       | IPv6 literal                | `%5B`      |
| `]`       | IPv6 literal                | `%5D`      |
| `@`       | User info (before hostname) | `%40`      |
| `!`       | Sub-delimiter               | `%21`      |
| `$`       | Sub-delimiter               | `%24`      |
| `&`       | Query param separator       | `%26`      |
| `'`       | Often used in queries       | `%27`      |
| `(`       | Grouping                    | `%28`      |
| `)`       | Grouping                    | `%29`      |
| `*`       | Wildcard                    | `%2A`      |
| `+`       | Space in query params       | `%2B`      |
| `,`       | Multiple values separator   | `%2C`      |
| `;`       | Params in paths             | `%3B`      |
| `=`       | Assigning values in query   | `%3D`      |

### 2. Unsafe Characters (Always Encode)

These characters are either control characters or not valid in URLs at all:

| Character | Reason                  | Encoded As        |
| --------- | ----------------------- | ----------------- |
| `<`       | Unsafe in HTML          | `%3C`             |
| `>`       | Unsafe in HTML          | `%3E`             |
| `"`       | Delimiter in attributes | `%22`             |
| `{`       | Not valid in URLs       | `%7B`             |
| `}`       | Not valid in URLs       | `%7D`             |
| \`        | \`                      | Not valid in URLs |
| `\`       | Escape character        | `%5C`             |
| `^`       | Not valid in URLs       | `%5E`             |
| `` ` ``   | Not valid in URLs       | `%60`             |
| space     | Breaks URLs             | `%20` or `+`      |

### 3. Non-ASCII Characters (Always Encode)

Any character **outside the ASCII range (0–127)**, such as:

* Accented letters: `é`, `ü`, `ç`
* Non-English letters: `ñ`, `ø`, `å`
* Symbols and emojis: `©`, `✓`, `🚀`

These must be **percent-encoded using UTF-8**.

Example:

```java
URLEncoder.encode("naïve café", StandardCharsets.UTF_8)
// Result: naive+caf%C3%A9
```

## Path Parameters and Special Characters

### Scenario

We are building a REST endpoint to fetch user details by username. Usernames can include special characters like `@`, `+`, or even slashes in some systems.

#### Example API

```http
GET /users/{username}
```

Now, suppose the username is:

```
john.doe+admin@example.com
```

### Problem

If we make a request like:

```http
GET /users/john.doe+admin@example.com
```

It may not work as expected because:

* `+` could be interpreted as a space
* `@` has special meaning in URLs
* If the username has `/`, the server may interpret it as a path separator

### Solution: Encode the Path Parameter

Before placing the value in the URL, it must be **URL-encoded**.

#### Example in Java (client-side)

```java
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

String rawUsername = "john.doe+admin@example.com";
String encoded = URLEncoder.encode(rawUsername, StandardCharsets.UTF_8);
// Result: john.doe%2Badmin%40example.com
```

Use the encoded value in the URL:

```http
GET /users/john.doe%2Badmin%40example.com
```

#### Example in Java (Spring Controller)

```java
@GetMapping("/users/{username}")
public ResponseEntity<User> getUser(@PathVariable String username) {
    return ResponseEntity.ok(userService.findByUsername(username));
}
```

Spring automatically decodes the path parameter, so in the above case, `username` will be `"john.doe+admin@example.com"`.

## Query Parameters and Special Characters

Query parameters are more forgiving, but encoding is still important. For example:

```http
GET /search?query=coffee & cream
```

This is invalid due to the space and `&` in the value.

#### Correct Version

```http
GET /search?query=coffee%20%26%20cream
```
