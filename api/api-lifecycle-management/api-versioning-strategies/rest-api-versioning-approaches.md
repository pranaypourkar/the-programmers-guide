# REST API Versioning Approaches

## About

REST APIs are the backbone of many modern applications and microservice architectures. They are often consumed by **multiple independent client types** - web apps, mobile apps, partner integrations, IoT devices, and even other microservices.

Because REST follows a **uniform interface principle**, ideally the resource identifiers (URLs) should remain stable. However, evolving business requirements, performance considerations, and technology upgrades inevitably introduce changes that can **break compatibility**.\
Versioning is the **contract management mechanism** that ensures old clients continue to function while allowing new features and changes to be introduced.

## Approaches

### **1. URI Path Versioning (Most Common)**

**Example:**

```
GET /api/v1/customers
GET /api/v2/customers
```

**How It Works:**\
The version is embedded in the URI path, usually right after the base path (`/api`), acting as a top-level differentiator for routing. API gateways or routers can use this prefix to route requests to the correct codebase or microservice deployment.

**Advantages:**

* **High discoverability** — The version is visible in every request.
* **Simplified routing** — Easy to configure in API gateways and load balancers.
* **Parallel deployments** — Allows multiple versions to run concurrently.

**Disadvantages:**

* **URL churn** — Every version change requires clients to update endpoints.
* **Resource identity change** — Technically, versioning in the URI breaks REST’s principle that the resource identifier should remain stable over time.

**Architectural Notes:**

* Works well with **blue/green deployments** where v1 and v2 are entirely separate services.
* Often combined with **separate Swagger/OpenAPI docs per version**.
* Should be avoided for **minor backward-compatible updates**, to prevent version inflation.

### **2. Query Parameter Versioning**

**Example:**

```
GET /api/customers?version=2
```

**How It Works:**\
Version is passed as a query string parameter, making it part of the request metadata without altering the main path.

**Advantages:**

* **Non-invasive** — Doesn’t require restructuring existing endpoint paths.
* **Easy fallback** — Clients that omit the parameter get the default version.
* **Fast to implement** for small services.

**Disadvantages:**

* **Reduced discoverability** — Less obvious to developers browsing documentation.
* **Caching complexity** — Some proxies and CDNs may cache incorrectly if not configured to consider query parameters.

**Architectural Notes:**

* Good for **feature-gated beta releases** — clients opt in via query params.
* Should be combined with **explicit API documentation** to avoid hidden behavior.

### **3. Header-Based Versioning**

**Example:**

```
GET /api/customers
X-API-Version: 2
```

**How It Works:**\
The client specifies the version in a **custom HTTP header**, keeping the URL stable and letting version negotiation happen entirely in metadata.

**Advantages:**

* **URL stability** — Clients can switch versions without changing endpoints.
* **Separation of concerns** — Versioning stays in metadata, not resource identifiers.

**Disadvantages:**

* **Hidden in browser calls** — Not visible when simply pasting the URL in a browser.
* **Discovery dependency** — Developers must read documentation to know which headers to send.

**Architectural Notes:**

* Works well with **API gateways** that can inspect headers for routing.
* Fits internal APIs better than public APIs where discoverability is crucial.

### **4. Media Type (Content Negotiation) Versioning**

**Example:**

```
GET /api/customers
Accept: application/vnd.mycompany.customer-v2+json
```

**How It Works:**\
Version is part of the `Accept` header value, which also specifies format and vendor name.\
The server negotiates the correct representation based on this header.

**Advantages:**

* **Standards-compliant** — Leverages HTTP’s built-in content negotiation.
* **Fine-grained control** — Different resources can have independent versioning.

**Disadvantages:**

* **Higher complexity** — Requires advanced server-side parsing logic.
* **Poor tool support** — Browsers don’t allow setting headers without developer tools.

**Architectural Notes:**

* Best suited for **API-first organizations** with strong API governance.
* Common in **hypermedia-driven APIs (HATEOAS)** where representation details matter.

### **5. Hybrid Versioning**

**Example:**

```
GET /api/v2/customers
X-Feature-Toggle: new-filter
```

**How It Works:**\
Mixes strategies — e.g., path versioning for **major breaking changes**, header or query parameters for **minor experimental changes**.

**Advantages:**

* **Layered version control** — Separate major vs. minor version handling.
* **Flexible rollout** — Can A/B test features while maintaining mainline stability.

**Disadvantages:**

* **Operational complexity** — More rules for routing and API governance.
* **Increased documentation burden**.

**Architectural Notes:**

* Often used in **multi-tenant SaaS platforms** where clients are on different upgrade tracks.
* Works well with **feature flag frameworks**.

## **Semantic Versioning (SemVer)**

Semantic Versioning (**SemVer**) is a **three-part number format** used to clearly communicate the **impact of a new release**to consumers.\
It’s written as:

```
MAJOR.MINOR.PATCH
```

Each part has a **specific meaning**:

1. **MAJOR** → Breaking changes (consumers must modify their code to adapt).
2. **MINOR** → Backward-compatible new features (no breaking changes).
3. **PATCH** → Backward-compatible bug fixes or improvements (no API shape change).

When applied to APIs, **SemVer doesn’t dictate&#x20;**_**where**_**&#x20;we put the version** (path, header, query param) - it just dictates **how we number and increment it**.

For example, we could have:

```
GET /api/v2.1.0/users
```

or

```
GET /api/users?version=2.1.0
```

**Pros:**

* Widely understood in software engineering.
* Makes version intent clear - consumers know whether upgrading is safe.
* Can be applied to **any versioning method** above (path, query, header).

**Cons:**

* Can lead to too many versions if incrementing aggressively.
* Still requires a transport mechanism (path, header, etc.).

**Best for:** Teams with **mature release processes** and multiple simultaneous consumers.
