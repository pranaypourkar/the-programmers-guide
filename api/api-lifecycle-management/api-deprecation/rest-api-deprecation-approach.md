# REST API Deprecation Approach

## About

Deprecation in REST APIs is a **managed transition process** that allows API providers to phase out outdated endpoints, parameters, or behaviors **without abruptly breaking existing clients**.\
Unlike internal service changes, REST API deprecation is **public-facing**, meaning it requires **technical, communication, and operational planning**.

## **What Can Be Deprecated in a REST API ?**

* **Endpoints** (e.g., `/v1/orders` → `/v2/orders`)
* **HTTP Methods** (e.g., removing `PUT` support for a resource)
* **Request Fields** (e.g., removing `oldField` from `POST` payload)
* **Response Fields** (e.g., removing `deprecatedValue` in JSON)
* **Header Parameters** (custom headers or authentication mechanisms)
* **Behavior Changes** (e.g., changing pagination defaults, sorting rules)

## **REST API Deprecation Lifecycle**

#### **Phase 1 – Deprecation Planning**

* Identify feature usage through **access logs** or **API analytics**.
* Assess **consumer impact** and plan migration paths.
* Define **deprecation timeline** (announcement → removal).
* Update **OpenAPI specifications** to mark deprecated fields/endpoints.

#### **Phase 2 – Deprecation Announcement**

* **Documentation Update** – Mark affected endpoints and fields with "Deprecated" tags.
*   **API Response Metadata** – Include deprecation warnings:

    ```http
    Deprecation: true
    Sunset: Wed, 31 Dec 2025 23:59:59 GMT
    Link: <https://api.example.com/docs/deprecations/orders-v1>; rel="deprecation"
    ```
* **Developer Portal Announcement** – Blog posts, newsletters, or changelogs.
* **Internal Stakeholder Communication** – Notify internal teams that rely on the API.

#### **Phase 3 – Coexistence Period**

* Keep **both old and new endpoints** functional during migration.
* Encourage consumers to switch early through:
  * Warning headers in REST responses.
  * Email notifications to API key owners.
  * Targeted outreach to high-traffic consumers.
* Implement **feature flag controls** for easy rollback if migration issues arise.

#### **Phase 4 – Progressive Decommissioning**

* Apply staged removal:
  1. **Non-production block** (test/staging).
  2. **Partial production block** for select API keys.
  3. **Full production removal** after migration window closes.

#### **Phase 5 – Complete Removal**

* Remove deprecated code from production.
* Delete related tests and monitoring.
* Update API documentation to eliminate outdated references.

## **Deprecation Communication Techniques in REST**

### **A. HTTP Headers**

* **`Deprecation` header** (RFC 8594)\
  Indicates that the endpoint or field is deprecated.
* **`Sunset` header**\
  Communicates the date after which the resource will no longer be available.
* **`Link` header** with `rel="deprecation"`\
  Provides a URL to documentation.

Example:

```http
Deprecation: true
Sunset: Wed, 31 Dec 2025 23:59:59 GMT
Link: <https://api.example.com/docs/deprecations/orders-v1>; rel="deprecation"
```

### **B. Response Body Warnings**

Add warnings inside the JSON payload:

```json
{
  "data": {...},
  "warnings": [
    {
      "code": "DEPRECATED_ENDPOINT",
      "message": "The /v1/orders endpoint is deprecated. Please use /v2/orders."
    }
  ]
}
```

### **C. API Documentation**

* Clearly **strike-through or mark deprecated items** in Swagger / OpenAPI UI.
* Provide **examples** of the replacement.

### **D. Client SDK Support**

If we publish API client libraries:

* Include deprecation notices in README/changelog.
* Annotate deprecated methods with `@Deprecated` (Java), `@deprecated` (JavaScript/TypeScript), or equivalent in other languages.

### **E. OpenAPI Specification `deprecated` Tag**

OpenAPI supports a `deprecated: true` flag for endpoints, parameters, or schema properties:

```yaml
paths:
  /v1/orders:
    get:
      summary: Get order by ID
      deprecated: true
      description: |
        This endpoint is deprecated and will be removed on 2025-12-31.
        Use /v2/orders instead.
```

* When **`deprecated: true`** is set:
  * Swagger UI will visually strike through or highlight the endpoint.
  * Generated client SDKs can show compile-time warnings.
* Works at **path**, **operation**, and **parameter** level.
* Can be combined with **`x-sunset-date`** or vendor extensions to indicate exact removal dates.

### **F. Code-Level Annotations (`@Deprecated`)**

Marking controller methods, DTO fields, or SDK methods with `@Deprecated` signals deprecation to developers **at compile time**.

```java
@RestController
@RequestMapping("/v1/orders")
public class OrderController {

    @Deprecated
    @GetMapping("/{id}")
    public Order getOrderById(@PathVariable Long id) {
        return orderService.getOrderById(id);
    }

    @GetMapping("/details/{id}")
    public OrderDetails getOrderDetails(@PathVariable Long id) {
        return orderService.getOrderDetails(id);
    }
}
```

* In **server code** – Useful for internal teams to avoid adding new code against old endpoints.
* In **generated SDKs** – External developers get IDE warnings when calling deprecated methods.
* Should be **combined** with OpenAPI `deprecated: true` so SDK generators also propagate the warning.
