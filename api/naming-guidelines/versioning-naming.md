# Versioning Naming

## **About**

Version naming defines **how API versions are represented** in endpoints, documentation, and contracts.\
It ensures:

* **Predictability** → Clients instantly know which version they’re using.
* **Clarity** → Developers can differentiate between versions without confusion.
* **Stability** → Older versions remain accessible while newer versions evolve.

Without clear naming, **breaking changes** become hard to track and clients may unknowingly use deprecated versions.

## **Core Principles**

### **1. Be Explicit About Versions**

Never rely on “hidden” versioning logic - make version identifiers visible in URLs, headers, or media types.

**Bad:**

```
/users
```

(Version unknown - may change without warning)

**Good:**

```
/v1/users
```

(Clear which version is being used)

### **2. Use a Consistent Version Format**

* **Major-only** for large breaking changes: `v1`, `v2`
* **Semantic versioning** (optional for APIs): `v1.2.3`
* **No leading zeros** → Avoid confusion (`v01` is bad)
* Always **lowercase ‘v’** + number for URLs

**Bad:**

```
/Version1/users
/v01/users
```

**Good:**

```
/v1/users
/v2.1/users
```

### **3. Match Version Naming to Versioning Strategy**

* **URI versioning** → `/v1/resource`
* **Query parameter versioning** → `/resource?version=1`
* **Header-based versioning** → `Accept: application/vnd.company.v1+json`
* **Content negotiation versioning** → Embed in media type.

**Example (Header-based):**

```
Accept: application/vnd.myapi.v2+json
```

### **4. Keep Version Naming Short and Clear**

Avoid overly descriptive version strings - the **API docs** should describe the changes, not the version name.

**Bad:**

```
/v1_release_candidate_final/users
```

**Good:**

```
/v1/users
```

### **5. Use Sequential Numbers**

Do not skip version numbers unless there’s a **clear release reason** (e.g., internal version dropped for stability reasons).

## **Version Naming by Strategy**

### **A. URI Versioning**

Most visible and easy to cache.

```
GET /v1/customers
GET /v2/customers
```

**Good for:** Public APIs, long-term support.\
**Bad for:** Clients that need frequent upgrades - changing URIs breaks bookmarks and code.

### **B. Query Parameter Versioning**

```
GET /customers?version=1
```

**Good for:** Prototyping, quick changes.\
**Bad for:** Cache efficiency - versions may get mixed in caches.

### **C. Header Versioning**

```
GET /customers
Accept: application/vnd.company.v1+json
```

**Good for:** Clean URIs, enterprise APIs.\
**Bad for:** Less discoverable, requires good documentation.

### **D. Media Type Versioning**

```
Accept: application/vnd.mycompany.orders-v2+json
```

**Good for:** Highly structured APIs with many data formats.\
**Bad for:** Complexity - can confuse new developers.



## **Versioning Naming with OpenAPI**

* Use **`info.version`** to specify API version.
* Match **OpenAPI version** to **public API version** in docs.
* Avoid mismatch like `/v2/users` but `info.version: 1.0`.

**Example:**

```yaml
openapi: 3.0.0
info:
  title: Customer API
  version: 2.0
paths:
  /v2/customers:
    get:
      summary: Get customers
```
