# API Compatibility

## About

**API Compatibility** refers to the ability of an Application Programming Interface (API) to evolve over time **without breaking the interaction between producers (API providers) and consumers (API clients)**. In simple terms, it is the guarantee that changes in an API will not cause existing clients to fail, and that new clients can still work seamlessly with older API versions when necessary.

It is one of the most **critical aspects of API lifecycle management** because APIs are long-lived contracts - once published and adopted, they must be supported without introducing instability or forcing all consumers to upgrade immediately. A well-designed compatibility strategy ensures **predictable evolution**, **consumer trust**, and **operational stability**.

### **Characteristics**

1. **Contract Preservation** – The API specification (endpoints, data formats, behaviors) acts as a _contract_ between producer and consumer. Compatibility ensures this contract remains valid during updates.
2. **Consumer-Centric Design** – The API’s evolution is planned with an understanding of how existing consumers depend on it.
3. **Controlled Change** – Not all changes are equal; some are _non-breaking_ and others are _breaking_. Compatibility management classifies and handles these changes accordingly.
4. **Ecosystem-Wide Impact** – API changes ripple across the ecosystem - impacting mobile apps, backend services, partner integrations, and external developers.

### **Dimensions of API Compatibility**

Compatibility is not just about whether the API still “runs” - it spans multiple dimensions:

* **Interface Compatibility** – Endpoints, methods, and HTTP verbs remain accessible as before.
* **Payload/Schema Compatibility** – Request and response structures remain usable; fields may be added in a backward-compatible way.
* **Behavioral Compatibility** – The business logic and expected outcomes of calls remain consistent.
* **Protocol/Wire Compatibility** – Low-level aspects such as HTTP status codes, gRPC method signatures, or message formats do not cause client failures.
* **Security & Authentication** – Token formats, OAuth flows, and access control remain consistent or evolve gracefully.

### **Compatibility as a Lifecycle Discipline**

API compatibility is **not a one-time decision** - it’s a discipline maintained throughout:

* **Design Phase** – Planning future-proof contracts.
* **Implementation Phase** – Coding with extension points and non-breaking defaults.
* **Testing Phase** – Validating with backward/forward compatibility tests.
* **Deployment Phase** – Rolling out with strategies like canary releases or parallel versioning.
* **Maintenance Phase** – Monitoring usage and planning deprecation carefully.

## Scope of Compatibility

The **scope of API compatibility** defines **which aspects of the API must remain stable** when making changes, and **how those aspects interact with consumers**.\
In other words, it answers the question:

{% hint style="success" %}
_“What parts of my API am I promising not to break, and in what ways?”_
{% endhint %}

Compatibility is **multi-dimensional** - it’s not just about whether the endpoint URL stays the same, but also about request/response structure, business semantics, performance, and security behavior.

### **1. Interface Compatibility**

The external contract that defines _what_ operations are available and _how_ clients invoke them.

* **Key Elements:**
  * **Endpoint Paths & Methods** – `/users`, `/orders/{id}`, etc.
  * **HTTP Verbs** – `GET`, `POST`, `PUT`, `DELETE` for REST; RPC method names for gRPC.
  * **Operation Signatures** – Parameters (query/path), required vs optional fields.
  * **Media Types** – e.g., `application/json`, `application/xml`.
* **Breaking Change Examples:**
  * Removing an endpoint.
  * Changing HTTP verb from `GET` to `POST`.
  * Making an optional parameter required.
* **Non-Breaking Examples:**
  * Adding an optional query parameter.
  * Adding a new endpoint alongside existing ones.

### **2. Payload & Schema Compatibility**

The structure, types, and meaning of the data exchanged.

* **Key Elements:**
  * Request body fields.
  * Response body fields.
  * Data types (string, int, date, enum).
  * Nullability and default values.
* **Breaking Change Examples:**
  * Removing a field from the response.
  * Changing a field’s type (`int` → `string`).
  * Renaming a field without aliasing.
* **Non-Breaking Examples:**
  * Adding new optional fields.
  * Adding new enum values (in tolerant clients).
  * Expanding max length for a string.

### **3. Protocol/Wire Compatibility**

The low-level rules and formats by which API messages are transmitted.

* **Key Elements:**
  * HTTP status codes and semantics.
  * gRPC/Protobuf field numbering.
  * Messaging protocol headers (Kafka, RabbitMQ).
  * TLS versions and cipher suites.
* **Breaking Change Examples:**
  * Changing HTTP status from `200` to `204` when consumers parse the body.
  * Changing Protobuf field IDs.
  * Removing required message headers.
* **Non-Breaking Examples:**
  * Adding a new optional HTTP header.
  * Supporting an additional TLS cipher.

### **4. Behavioral & Semantic Compatibility**

The meaning and side effects of API operations.

* **Key Elements:**
  * Business rules (e.g., how discounts are applied).
  * State changes caused by requests.
  * Ordering guarantees (e.g., events are delivered in sequence).
  * Idempotency expectations.
* **Breaking Change Examples:**
  * Changing how results are calculated (e.g., tax formula changes that affect output).
  * Removing idempotency for a previously idempotent operation.
  * Altering default sorting of results without notice.
* **Non-Breaking Examples:**
  * Adding an alternative calculation option via a new parameter.
  * Offering more accurate results without breaking existing contract assumptions.

### **5. Security & Authentication Compatibility**

The authentication and authorization model used to access APIs.

* **Key Elements:**
  * OAuth2 flows, token types (JWT, opaque).
  * Required scopes/permissions.
  * API key formats.
  * Role-based access control rules.
* **Breaking Change Examples:**
  * Requiring additional scopes for an existing operation.
  * Changing token format without maintaining legacy support.
* **Non-Breaking Examples:**
  * Adding support for a new authentication method in parallel.
  * Increasing token lifetime without breaking policy.

### **6. SLA & Performance Compatibility**

Operational guarantees around latency, throughput, and availability.

* **Key Elements:**
  * Response time limits.
  * Throughput guarantees.
  * Error rate thresholds.
* **Breaking Change Examples:**
  * Increasing response latency significantly.
  * Introducing rate limits without notice.
* **Non-Breaking Examples:**
  * Improving response times.
  * Increasing rate limits.

#### **Why Scope Definition Matters ?**

Clearly defining the scope of compatibility is **foundational** to:

* **Avoiding unintentional breakage** - if teams know what’s “protected,” they can safely evolve other parts.
* **Setting expectations with consumers** - especially for public APIs where breaking changes can cause major disruptions.
* **Enabling safe API evolution** - teams can innovate without fear of hidden regressions.

## Compatibility Types

API compatibility can be classified based on **the direction of compatibility**, **the aspect being preserved**, and **the stage of interaction** (design time vs. runtime).\
These types define **how an API can change without breaking consumers** and which types of changes are considered safe.

{% hint style="success" %}
**Interrelation**

* **Backward** & **Forward** compatibility → Focus on _client-server interaction across versions_.
* **Source** & **Binary** compatibility → Focus on _compile/run behavior_ for library APIs.
* **Wire** & **Behavioral** compatibility → Focus on _runtime communication and semantics_.
{% endhint %}

### **1. Backward Compatibility**

The ability of a **newer version** of the API to work with **clients built for the older version**.

* **Typical Use Case:** We upgrade our API, but old clients still run without changes.
* **Example:**
  *   Old API returned:

      ```json
      { "name": "Alice" }
      ```
  *   New API returns:

      ```json
      { "name": "Alice", "age": 30 }
      ```

      Old clients that ignore unknown fields still work fine.
* **Importance:** Prevents breaking production clients after API updates.

### **2. Forward Compatibility**

The ability of an **older client** to interact with a **newer API** and still function correctly.

* **Typical Use Case:** The client is built to **ignore unknown data** so that it can handle future fields or extensions gracefully.
* **Example:**
  *   API starts including:

      ```json
      { "name": "Bob", "nickname": "Bobby" }
      ```

      A forward-compatible old client ignores `"nickname"` and still processes `"name"`.
* **Importance:** Critical for clients that cannot update frequently (e.g., IoT devices).

### **3. Source Compatibility** _(for SDK/Library-based APIs)_

Code written against the old API **compiles** without errors against the new API version.

* **Typical Use Case:** Java library APIs where we don’t want users to change their source code.
* **Example:**
  *   Old method:

      ```java
      void processData(String input)
      ```
  *   New method added **without removing the old one**:

      ```java
      void processData(String input, boolean trim)
      ```

      Old code still compiles.

### **4. Binary Compatibility**

Compiled code (binaries) that worked with the old version **still runs** with the new version without recompilation.

* **Typical Use Case:** Java `.class` or `.jar` files used across services.
* **Breaking Example:** Changing a method signature without keeping the old one breaks binary compatibility.
* **Non-Breaking Example:** Adding a new method without touching old ones.

### **5. Wire Compatibility**

The **on-the-wire format** (HTTP messages, Protobuf binary format, Kafka message schema) remains compatible.

* **Importance:** Even if the code compiles, if the serialized format changes incompatibly, consumers may fail.
* **Example:**
  * Changing Protobuf field IDs breaks wire compatibility.
  * Adding optional fields in JSON maintains wire compatibility.

### **6. Behavioral Compatibility**

The meaning, side effects, and operational semantics of API calls remain consistent.

* **Example:**
  * If `/orders` always returns results sorted by creation date, suddenly changing to sort by price breaks behavioral compatibility even if the endpoint and schema are unchanged.
* **Importance:** Prevents “silent breakages” where code still runs but produces incorrect results.

### **7. Semantic Versioning Relation**

Compatibility types directly influence **semantic versioning**:

* **Major version bump** → Breaks backward compatibility.
* **Minor version bump** → Adds features but keeps backward compatibility.
* **Patch version bump** → Bug fixes, no compatibility breaks.

## Change Taxonomy

**Change taxonomy** in API design is the structured classification of **all possible changes** that can be made to an API, organized by their **impact on compatibility**.\
It allows teams to predict **whether a change will break existing clients**, remain safe, or require migration strategies.

In practice, changes fall into **three main categories**:

### **1. Additive Changes**

(_Generally Non-Breaking_)\
Additive changes introduce **new elements** without removing or altering existing ones.

* **Impact:** Usually maintain **backward compatibility**, but **may** break forward compatibility if clients cannot ignore unknown data.
* **Examples:**
  * Adding a new optional field in the response.
  * Adding a new API endpoint.
  * Adding a new enum value (safe only if clients handle unknown values).
  * Adding a new HTTP header (optional).
* **Risks:**
  * Clients that strictly validate schemas may reject unknown fields.
  * Adding new required parameters _is not_ additive - it’s breaking.
*   **Example Flow:**

    ```
    V1: GET /users → { "id": 1, "name": "Alice" }
    V2: GET /users → { "id": 1, "name": "Alice", "email": "a@x.com" }
    → Old clients that ignore "email" still work.
    ```

### **2. Subtractive Changes**

(_Always Breaking for Backward Compatibility_)\
Subtractive changes remove or disable parts of the existing API.

* **Impact:** Breaks **backward compatibility** because old clients may depend on removed features.
* **Examples:**
  * Removing a field from the response.
  * Removing an endpoint or changing its path.
  * Removing an enum value in a required field.
  * Removing query parameters.
* **Risks:**
  * Even unused endpoints can break automated integrations.
*   **Example Flow:**

    ```
    V1: GET /orders → { "id": 101, "status": "SHIPPED" }
    V2: GET /orders → { "status": "SHIPPED" }
    → Old client expecting "id" fails.
    ```

### **3. Modifying Changes**

(_Potentially Breaking, Context Dependent_)\
Modifying changes alter **existing elements** in ways that can affect client behavior.

* **Impact:** May break **backward**, **forward**, **wire**, or **behavioral** compatibility depending on scope.
* **Examples:**
  * Changing data type (`int` → `string`).
  * Changing field meaning (repurposing `status` from `ACTIVE/INACTIVE` to `ENABLED/DISABLED`).
  * Changing HTTP status codes (`200` → `204`).
  * Changing default sorting order of results.
* **Risks:**
  * Silent data corruption when meaning changes without error.
  * Schema validation failures.
*   **Example Flow:**

    ```
    V1: GET /products → price: "29.99" (string)
    V2: GET /products → price: 29.99 (number)
    → Old client parsing string fails.
    ```

### **Taxonomy Matrix**

<table data-header-hidden data-full-width="true"><thead><tr><th></th><th></th><th></th><th></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Change Type</strong></td><td><strong>Example</strong></td><td><strong>Backward Compatibility</strong></td><td><strong>Forward Compatibility</strong></td><td><strong>Wire Compatibility</strong></td><td><strong>Behavioral Compatibility</strong></td></tr><tr><td>Add Optional Field</td><td>Add <code>"nickname"</code> to user profile</td><td>Safe</td><td>Depends on parser</td><td>Safe</td><td>Safe</td></tr><tr><td>Remove Field</td><td>Remove <code>"age"</code></td><td>Breaks</td><td>Safe</td><td>Breaks</td><td>Safe</td></tr><tr><td>Change Field Type</td><td><code>int</code> → <code>string</code></td><td>Breaks</td><td>Breaks</td><td>Breaks</td><td>Possible impact</td></tr><tr><td>Add Enum Value</td><td>Add <code>"PENDING_REVIEW"</code>to <code>status</code></td><td>Safe (if tolerant)</td><td>Risk if strict parsing</td><td>Safe</td><td>Safe</td></tr><tr><td>Remove Endpoint</td><td>Remove <code>/orders/{id}</code></td><td>Breaks</td><td>Safe</td><td>Breaks</td><td>Safe</td></tr><tr><td>Change HTTP Status</td><td><code>200 OK</code> → <code>204 No Content</code></td><td>Breaks if body expected</td><td>Breaks</td><td>⚠ Possible impact</td><td>Safe</td></tr><tr><td>Change Business Rule</td><td>Change tax calculation formula</td><td>Safe structurally</td><td>Safe structurally</td><td>Safe structurally</td><td>Breaks behavior</td></tr></tbody></table>

## Breaking vs. Non-Breaking vs. Partial-Breaking Changes

When evolving an API, every change can be classified not only by its type (Additive, Subtractive, Modifying) but also by **its actual effect on client compatibility**.\
This classification is essential for **risk assessment, release planning, and versioning decisions**.

### **1. Breaking Changes**

Changes that **cause existing clients to fail** either at compile time (for strongly typed clients), runtime (due to parsing errors), or logical errors (due to altered business meaning).

**Characteristics**

* Violate **backward compatibility**.
* Require consumers to **update their code** before using the new API.
* Often necessitate **version bumping** (major version in semantic versioning).

**Examples**

* Removing an API endpoint.
* Renaming a JSON field in the response.
* Changing the data type of a field.
* Removing an enum value.
* Changing authentication requirements.

**Impact Flow Example**

```
Before: GET /users → { "id": 1, "name": "Alice" }
After:  GET /users → { "userId": 1, "name": "Alice" }
→ Old clients expecting "id" fail to parse.
```

### **2. Non-Breaking Changes**

Changes that **do not disrupt existing clients** - they can continue working without modification.

**Characteristic**

* Preserve **backward compatibility**.
* May or may not maintain **forward compatibility** depending on client tolerance to unknowns.
* Safe to deploy without forcing upgrades.

**Examples:**

* Adding a new optional field to the response.
* Adding a new endpoint while keeping existing ones.
* Adding new query parameters that are optional.
* Adding a new enum value (safe if clients ignore unknown values).

**Impact Flow Example:**

```
Before: GET /users → { "id": 1, "name": "Alice" }
After:  GET /users → { "id": 1, "name": "Alice", "email": "a@x.com" }
→ Old clients still work because "email" is ignored.
```

### **3. Partial-Breaking Changes**

Changes that **work for some clients but break others**, depending on how strictly they validate or rely on certain behaviors.\
This is the _gray zone_ that often causes **unexpected production issues**.

**Characteristics**

* Backward compatibility **may appear intact** in tests but fails for stricter consumers.
* Often caused by schema extensions, enum changes, or subtle behavior alterations.
* Risk grows in **heterogeneous ecosystems** with many client implementations.

**Examples**

* Adding a new enum value (breaks if clients have strict enum handling).
* Changing sorting order of results (breaks if clients depend on old order).
* Adding optional fields to XML responses (breaks if clients use strict XML schemas).
* Changing default pagination size.

**Impact Flow Example**

```
Before: status = ["ACTIVE", "INACTIVE"]
After:  status = ["ACTIVE", "INACTIVE", "PENDING_REVIEW"]

→ Clients with flexible parsing: OK  
→ Clients with hardcoded enum checks: Fail
```

## Flow of Change Assessment

1. **Identify Change Type** → Additive, Subtractive, or Modifying.
2. **Map to Compatibility Types** → Backward, Forward, Wire, Behavioral.
3. **Evaluate Consumer Impact** → Schema validation, parsing rules, business workflows.
4. **Decide Mitigation Strategy**:
   * Versioning (URL or media type).
   * Deprecation periods.
   * Dual API support.

## Why Compatibility Matters ?

API compatibility is not just a technical constraint - it is a **strategic necessity** in modern software ecosystems.\
The moment an API is exposed to consumers (internal microservices, partner systems, or public developers), it becomes a **long-term contract**. Breaking this contract without a well-managed compatibility strategy can result in **system failures, operational chaos, customer dissatisfaction, and direct financial loss**.

#### **1. Protecting Consumer Trust**

* **APIs as Commitments** – Once we publish an API, we implicitly commit to supporting the ways consumers use it.
* **Predictability** – Stable, predictable APIs foster trust between teams, companies, and developers.
* **Avoiding “Integration Fatigue”** – Frequent breaking changes force consumers into a never-ending cycle of upgrades, damaging relationships.

**Example:**\
If a payment gateway changes its response format without notice, every integrated e-commerce platform could fail checkout in production - instantly eroding trust.

#### **2. Reducing Business Risk**

* **Operational Stability** – APIs that evolve without breaking clients reduce the risk of production outages.
* **Compliance & Regulatory Adherence** – In industries like healthcare, finance, or telecommunications, sudden API changes may violate legal agreements or SLAs.
* **Revenue Continuity** – For APIs tied to billing or customer-facing functionality, downtime caused by incompatibility directly impacts revenue.

**Real-world impact:**\
In 2016, a major social media platform made breaking API changes without enough migration time resulting in hundreds of third-party apps failing overnight.

#### **3. Enabling Product Velocity**

* **Continuous Delivery Without Chaos** – Compatibility ensures we can release API updates without coordinating massive synchronized client updates.
* **Parallel Innovation** – Teams can add new features or endpoints without breaking existing ones, allowing consumers to upgrade at their own pace.
* **Reduced Dependency Bottlenecks** – Microservices can evolve independently, avoiding complex dependency freeze cycles.

#### **4. Cost Optimization**

* **Less Rework for Consumers** – Breaking changes force multiple client teams to rework and retest their integrations.
* **Lower Support Costs** – Stable APIs reduce support tickets, emergency patches, and migration assistance overhead.
* **Avoiding Hidden Migration Costs** – Even small breaking changes can require extensive downstream regression testing and certification.

#### **5. Ecosystem Growth**

* **Encouraging Third-Party Development** – Developers are more likely to adopt an API if they can trust it won’t break frequently.
* **Marketplace & Partner Stability** – Stable APIs enable long-term partner integrations, fostering a healthy ecosystem.
* **Backward-Compatible Innovation** – We can release new features while keeping old consumers fully functional, expanding our reach.

### **Compatibility Breakage Ripple Effect**

Here’s how a breaking API change can cascade through an organization:

```
Breaking Change in API  →  Immediate Consumer Failures  
  →  Hotfix Requests  →  Delayed Roadmaps  
  →  Customer Churn / SLA Breach  →  Loss of Trust & Revenue
```

In microservices:

```
Service A changes API  →  Service B fails → Service C fails  
→ Partial System Outage → Incident Response & Rollback
```

### **Compatibility as a Competitive Advantage**

Organizations that maintain **long-lived, backward-compatible APIs** gain:

* **Stronger developer loyalty**
* **Higher integration adoption rates**
* **Lower churn and downtime**
* **Faster feature rollout without fear**
