# Error Codes and Messages

## **About**

Error codes and messages form the **error-handling contract** between our API and its consumers.\
They must be:

* **Predictable** → Clients can programmatically respond to errors.
* **Descriptive** → Developers can quickly debug issues.
* **Consistent** → Same structure across all endpoints.

Poorly designed error codes make debugging painful, increase support load, and can lead to **silent failures** if clients can’t interpret the meaning.

## **Core Principles**

## **1. Separate Machine-Readable and Human-Readable Data**

* **Machine-readable**: Error code (numeric or string key) → for programmatic handling.
* **Human-readable**: Descriptive message → for developer/operator clarity.

**Bad:**

```json
{ "error": "Something went wrong" }
```

**Good:**

```json
{
  "errorCode": "ORDER_NOT_FOUND",
  "errorMessage": "Order with ID 12345 does not exist."
}
```

Reasoning: Codes allow clients to take specific action without parsing free text.

### **2. Use Consistent Code Format**

* **String constants** (e.g., `USER_NOT_FOUND`) → easier to read and log.
* Or **numeric ranges** mapped to error domains (e.g., `1001` for auth errors, `2001` for payment errors).
* Avoid mixing both in an inconsistent way.

**Bad:**

```json
{ "errorCode": 123 }
{ "errorCode": "InvalidOrder" }
```

**Good:**

```json
{ "errorCode": "ORDER_INVALID" }
```

Reasoning: Uniform format helps in filtering and searching logs.

### **3. Align with HTTP Status Codes**

* **HTTP code** → high-level category of error.
* **Custom code** → specific cause.

**Example:**

```json
{
  "httpStatus": 404,
  "errorCode": "USER_NOT_FOUND",
  "errorMessage": "User with ID 789 was not found."
}
```

Reasoning: HTTP status tells _what class of error_, custom code tells _why_.

### **4. Avoid Ambiguous Messages**

Messages must **clearly state the cause** and, if safe, suggest resolution steps.

**Bad:**

```json
{ "errorMessage": "Invalid data" }
```

**Good:**

```json
{ "errorMessage": "Email format is invalid. Please provide a valid email address." }
```

Reasoning: Specificity reduces guesswork.

### **5. Never Leak Sensitive Data**

Error messages must never expose stack traces, SQL queries, or internal file paths.

**Bad:**

```json
{ "errorMessage": "java.sql.SQLException: Invalid column index at com.example.db..." }
```

**Good:**

```json
{ "errorMessage": "Database error occurred while processing the request." }
```

Reasoning: Protects against information leakage attacks.

### **6. Include a Correlation ID**

When errors occur, provide a unique identifier for tracing in logs.

**Example:**

```json
{
  "errorCode": "PAYMENT_DECLINED",
  "errorMessage": "Payment was declined by the bank.",
  "correlationId": "abc123-456xyz"
}
```

### **7. Keep Error Payload Structure Consistent**

Across all endpoints, the error object should have the **same fields** in the **same order**.

**Bad:**

```json
// From one API
{ "code": "USER_NOT_FOUND", "message": "User missing" }

// From another API
{ "errorCode": "AUTH_FAILED", "errorMessage": "Token expired" }
```

**Good:**

```json
{
  "errorCode": "USER_NOT_FOUND",
  "errorMessage": "User missing",
  "correlationId": "xyz123"
}
```

Reasoning: Consistency allows clients to parse errors without branching logic.

## **Error Code Naming Guidelines**

<table data-full-width="true"><thead><tr><th width="154.55078125">Rule</th><th>Bad Example</th><th>Good Example</th><th>Reason</th></tr></thead><tbody><tr><td>Uppercase with underscores</td><td><code>"userNotFound"</code></td><td><code>"USER_NOT_FOUND"</code></td><td>Easy to read, standard in APIs</td></tr><tr><td>Domain prefix</td><td><code>"INVALID"</code></td><td><code>"ORDER_INVALID"</code></td><td>Prevents conflicts between domains</td></tr><tr><td>Avoid generic words</td><td><code>"ERROR_1"</code></td><td><code>"PRODUCT_OUT_OF_STOCK"</code></td><td>Specific and meaningful</td></tr></tbody></table>

## **Sample JSON Error Format**

```json
{
  "httpStatus": 400,
  "errorCode": "INVALID_INPUT",
  "errorMessage": "The 'email' field must be a valid email address.",
  "correlationId": "c0a80123-4567-89ab-cdef-0123456789ab",
  "timestamp": "2025-08-13T10:15:30Z",
  "details": [
    { "field": "email", "message": "Invalid email format" },
    { "field": "password", "message": "Password must be at least 8 characters" }
  ]
}
```
