# Parameter Naming

## **About**

Parameter naming governs how we label **query parameters**, **path parameters**, and **header parameters** in an API.\
Clear, consistent parameter naming ensures that:

* Developers instantly understand what data they need to send.
* Automated tools like Swagger/OpenAPI can generate accurate SDKs.
* The API avoids ambiguity, typos, and inconsistent styles.

Poor parameter naming leads to **misinterpretation**, incorrect data submissions, and wasted debugging time.

## **Core Rules and Examples**

### **1. Use Lowercase with Hyphens (or Camel Case for JSON Fields)**

* **Lowercase** is standard for query/path parameters.
* **Hyphens** improve readability.
* For JSON request/response bodies, use camelCase (matches most JS-based tooling).

**Bad:**

```
?UserId=123
?user_id=123
```

**Good:**

```
?user-id=123           # Query parameter
{ "userId": 123 }      # JSON property in request body
```

Reasoning: Hyphenated lowercase is more readable in URLs; camelCase is standard in JSON.

### **2. Be Descriptive and Avoid Ambiguity**

Names should convey **what the parameter represents** - avoid single-letter or overly generic names.

**Bad:**

```
?u=123
?id=456
?val=true
```

**Good:**

```
?user-id=123
?order-id=456
?include-details=true
```

Reasoning: Descriptive names reduce confusion and help with auto-generated API docs.

### **3. Match Parameter Names to Domain Terminology**

Keep parameters consistent with the **domain model**.

**Bad:**

```
?customer-id=123   # In our domain model, it's always called "user"
```

**Good:**

```
?user-id=123       # Matches entity naming used in endpoints
```

Reasoning: Inconsistency forces developers to remember multiple names for the same concept.

### **4. Keep Boolean Parameters Clear**

Boolean parameters should clearly indicate their effect, ideally with prefixes like `is-`, `include-`, or `has-`.

**Bad:**

```
?active=true
?full=false
```

**Good:**

```
?is-active=true
?include-details=false
```

Reasoning: Prefixes make the meaning obvious, especially when reading logs or debugging.

### **5. Avoid Encoding Values in Names**

Do not create different parameter names for the same concept based on possible values.

**Bad:**

```
?status-pending=true
?status-completed=true
```

**Good:**

```
?status=pending
?status=completed
```

Reasoning: The parameter name should define the concept; the value defines the state.

### **6. Keep Consistent Ordering (for Documentation & Predictability)**

While parameter order doesn’t matter in HTTP, listing them consistently in docs and examples improves readability.

**Bad:**

```
GET /orders?sort=asc&user-id=123&page=2
GET /orders?page=2&sort=asc&user-id=123
```

**Good:**

```
GET /orders?user-id=123&page=2&sort=asc
```

Reasoning: Consistency aids memory and code generation.

### **7. Avoid Abbreviations Unless Universal**

Use full words unless the abbreviation is globally understood (`id`, `url`, `ip`).

**Bad:**

```
?usr-id=123
?prd-id=456
```

**Good:**

```
?user-id=123
?product-id=456
```

Reasoning: Full words are easier for new developers and API consumers.

### **8. Path Parameters Use Curly Braces**

In documentation and OpenAPI specs, path parameters should be enclosed in `{}`.

**Bad:**

```
/users/user-id/orders
```

**Good:**

```
/users/{user-id}/orders
```

Reasoning: Curly braces clearly indicate a dynamic parameter in the path.

### **9. Keep Header Parameter Names Consistent with HTTP Standards**

Custom headers should be namespaced to avoid clashes.

**Bad:**

```
AuthorizationToken: abc123
ClientId: xyz
```

**Good:**

```
Authorization: Bearer abc123     # Standard
X-Client-Id: xyz                 # Custom
```

Reasoning: Follows HTTP header naming conventions; `X-` prefix is still widely used for custom headers.

## **Special Cases**

### **Pagination**

```
?page=2&limit=50
```

Avoid mixing different pagination patterns (`page/size` in one place, `offset/limit` in another) unless justified.

### **Filtering**

```
?status=active&category=electronics
```

Use multiple query parameters for multiple filters rather than encoding them in one string.

### **Sorting**

```
?sort=price&order=asc
```

Or a single parameter format:

```
?sort=price:asc
```

Be consistent across all endpoints.
