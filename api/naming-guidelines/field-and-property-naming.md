# Field and Property Naming

## **About**

Field and property naming governs how we name the **keys in our JSON/XML payloads**, as well as object properties in request and response bodies.\
These names become the **public contract** of your API. Once released, renaming or changing them can break clients, making naming conventions critical for **compatibility, clarity, and maintainability**.

Well-structured property names:

* Improve **readability** and reduce onboarding time for new developers.
* Ensure **consistency** across services and teams.
* Avoid **breaking changes** in future versions.

## **Core Rules and Examples**

### **1. Use camelCase for JSON**

* Most REST APIs follow camelCase for JSON fields to align with JavaScript/TypeScript usage.
* Avoid snake\_case or PascalCase unless there’s a strong domain-specific reason.

**Bad:**

```json
{ "User_Name": "John" }
{ "user_name": "John" }
```

**Good:**

```json
{ "userName": "John" }
```

Reasoning: camelCase integrates naturally with frontend frameworks and most JSON serializers.

### **2. Use Lowercase for XML Elements (if used)**

If XML is supported, element names are typically lowercase or lowercase-hyphenated.

**Bad:**

```xml
<UserName>John</UserName>
```

**Good:**

```xml
<user-name>John</user-name>
```

Reasoning: Lowercase improves visual consistency and avoids case sensitivity issues in XML parsers.

### **3. Be Descriptive and Unambiguous**

Names should indicate exactly what the field represents.

**Bad:**

```json
{ "value": 100 }
{ "status": "1" }
```

**Good:**

```json
{ "orderTotalAmount": 100 }
{ "orderStatus": "pending" }
```

Reasoning: Self-descriptive names reduce confusion when debugging payloads.

### **4. Maintain Consistency Across Entities**

If the same concept appears in multiple APIs, the name should remain identical everywhere.

**Bad:**

```json
// In /orders API
{ "customerId": 123 }

// In /payments API
{ "userId": 123 }
```

**Good:**

```json
// Consistent in all APIs
{ "customerId": 123 }
```

Reasoning: Consistency enables easy client reuse and avoids mapping headaches.

### **5. Avoid Abbreviations Unless Universal**

Only use abbreviations like `id`, `url`, `ip` that are globally understood.

**Bad:**

```json
{ "custNm": "John" }
```

**Good:**

```json
{ "customerName": "John" }
```

Reasoning: Abbreviations save few characters but cost readability.

### **6. Avoid Encoding Types in Names**

The name should describe the concept, not the data type.

**Bad:**

```json
{ "customerName_str": "John" }
{ "orderAmount_int": 250 }
```

**Good:**

```json
{ "customerName": "John" }
{ "orderAmount": 250 }
```

Reasoning: Type information belongs in the schema, not the field name.

### **7. Use Singular for Field Names**

Field names should represent a single value, even inside arrays.

**Bad:**

```json
{ "itemsList": [ "item1", "item2" ] }
```

**Good:**

```json
{ "items": [ "item1", "item2" ] }
```

Reasoning: Plural form (`items`) makes sense for arrays; avoid redundant suffixes like "List".

### **8. Keep Nested Field Naming Consistent**

When using nested objects, subfields should follow the same rules.

**Bad:**

```json
{
  "customer": {
    "CustID": 123,
    "cust_name": "John"
  }
}
```

**Good:**

```json
{
  "customer": {
    "customerId": 123,
    "customerName": "John"
  }
}
```

Reasoning: Consistent casing and terminology prevent data mapping errors.

### **9. Indicate Booleans with a Clear Prefix**

Boolean properties should start with `is`, `has`, or `can` for readability.

**Bad:**

```json
{ "active": true }
```

**Good:**

```json
{ "isActive": true }
```

Reasoning: Makes the value’s meaning obvious without guessing.

### **10. Avoid Reserved Keywords**

Do not use names that might conflict with programming languages or JSON parsing libraries.

**Bad:**

```json
{ "class": "gold", "default": true }
```

**Good:**

```json
{ "membershipClass": "gold", "isDefault": true }
```

Reasoning: Avoids serialization/deserialization issues.

## **Special Cases**

### **Pagination Fields**

```json
{ "page": 2, "pageSize": 50, "totalPages": 10 }
```

Keep pagination fields consistent across all APIs.

### **Timestamps**

Always use ISO 8601 format (`YYYY-MM-DDTHH:mm:ssZ`) and name clearly:

```json
{ "createdAt": "2025-08-13T14:30:00Z" }
```

### **IDs**

Always suffix with `Id` and keep consistent:

```json
{ "orderId": 456 }
```
