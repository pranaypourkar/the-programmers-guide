# Naming Guidelines

## About

In software development and especially in API design, **names are the interface between humans and the system**.\
Whether it’s an endpoint path (`/users/{id}`), a JSON field (`createdAt`), or an error code (`USER_404`), the name chosen determines:

* **How easily developers can understand the system** without diving into the code.
* **How consistently the API behaves across services and teams.**
* **How maintainable and extensible the system becomes over time.**

Unlike implementation details that can be hidden, **naming is always exposed** to clients, documentation readers, SDK consumers, and sometimes even to end-users.\
Once published, names are extremely **difficult to change** without breaking backward compatibility.

**In APIs, naming is not a cosmetic concern - it is a contract.**

### **Characteristics of Good Naming in APIs**

1. **Clarity** – The name should convey exactly what it represents (`/orders` is clearer than `/data`).
2. **Consistency** – Similar concepts should follow the same pattern (`/users` & `/orders`, not `/users` & `/purchaseList`).
3. **Predictability** – Developers should be able to guess names for related endpoints without documentation.
4. **Stability** – Names should be future-proof and avoid trendy or ambiguous terms that might age poorly.
5. **Alignment with Standards** – Align with REST conventions, JSON naming practices, and organizational style guides.

### **Naming Across the API Lifecycle**

* **Design Phase** – Sets the initial tone and developer expectations.
* **Implementation Phase** – Guides code structure, DTO naming, and database mapping.
* **Documentation Phase** – Influences readability, searchability, and onboarding speed.
* **Maintenance Phase** – Reduces the risk of inconsistencies and accidental breaking changes.

By treating naming as a **first-class design decision**, teams avoid ambiguity, misinterpretation, and costly refactoring later.

## **Why Naming Matters ?**

In API design, **names are more than labels** - they are **permanent entry points** into the functionality of our system. Every endpoint name, query parameter, field, and error code becomes part of the **public contract** between our service and its consumers.

Changing these names is **not trivial** because:

* They are referenced in **client applications**.
* They appear in **documentation** and **integration guides**.
* They may be **hardcoded** in scripts, automation tools, or SDKs.

A poorly chosen name can **spread quickly** across multiple consuming systems, making later fixes expensive and risky.

{% hint style="success" %}
Good naming practices reduce cognitive load, prevent ambiguity, and help APIs scale across teams and versions without breaking compatibility.
{% endhint %}

#### **1. Naming Directly Affects Developer Experience (DX)**

* **Good names** make an API self-explanatory and reduce dependency on documentation.
* **Bad names** create confusion, forcing developers to constantly cross-check references.
* A clear name shortens onboarding time for new developers integrating with our API.

**Example:**

```http
GET /orders/{id}     # Clear - fetching a specific order
GET /orderInfo/{id}  # Less consistent - breaks expected plural form
```

#### **2. Naming is a Key Part of API Consistency**

Consistency allows **predictable exploration** of an API.\
If developers learn how one part is named, they can infer the rest.

**Example:**

* Good: `/users/{id}/orders` → `/users/{id}/payments`
* Bad: `/users/{id}/orders` → `/customer/{id}/payments`

#### **3. Naming Impacts Searchability and Documentation Quality**

* Consistent, descriptive names make it easier to **search through code** and **API references**.
* Clear naming improves **OpenAPI/Swagger documentation readability**.
* Misleading names often require **extra clarifications** in docs, increasing maintenance effort.

#### **4. Naming Influences Cross-Team Collaboration**

When multiple teams work on services, naming guidelines **create a shared vocabulary**.\
Without them:

* One team may call it `customerId`, another `cust_id`, and another `userId`.
* This inconsistency increases mapping overhead in integrations.

#### **5. Naming Shapes Long-Term Maintainability**

Once deployed, names become **sticky**. Removing or renaming a public field or endpoint may:

* Require **versioning** (e.g., `/v2` just to fix a name).
* Cause **breaking changes** for downstream systems.
* Require **deprecation cycles** to give clients time to adapt.

## **Common Pitfalls Without Guidelines**

Without a **formal naming convention**, API design can quickly devolve into a patchwork of inconsistent terms, formats, and structures.\
These inconsistencies **confuse consumers**, slow down development, and often lead to costly refactoring.

{% hint style="success" %}
Inconsistent, unclear, or misleading names erode trust in the API.\
They force clients to rely heavily on documentation instead of intuition, increasing the **cost of integration** and **risk of breaking changes**.
{% endhint %}

Below are the most common pitfalls when naming is left to ad-hoc decisions.

#### **1. Inconsistent Terminology**

Different developers or teams might use different names for the same concept:

* `customerId` vs `cust_id` vs `userId`
* `invoiceNumber` vs `inv_no`

**Impact:**

* Forces consumers to remember multiple variations of the same thing.
* Causes unnecessary field mapping in integrations.

#### **2. Mixed Casing and Formatting Styles**

When casing is inconsistent:

* `firstName` (camelCase) in one endpoint
* `first_name` (snake\_case) in another
* `FirstName` (PascalCase) in yet another

**Impact:**

* Breaks JSON parsing consistency.
* Forces clients to implement conversion logic.
* Leads to accidental data mismatches in serialization/deserialization.

#### **3. Unclear or Ambiguous Names**

Some names fail to convey their purpose:

* `/data` (vague - what kind of data?)
* `status` (is it HTTP status, order status, or payment status?)
* `info` (too generic to be useful)

**Impact:**

* Requires extra documentation to clarify intent.
* Increases onboarding time for new developers.

#### **4. Overloaded Terms**

When a single word is reused for different meanings:

* `id` used for both user ID and product ID in the same request body.
* `type` used for both API resource type and user role type.

**Impact:**

* Creates confusion when reading payloads.
* Makes debugging and tracing harder.

#### **5. Resource and Action Mismatch**

REST APIs should name **resources** in nouns and avoid verbs in endpoints:

* Bad: `/getUserDetails` (mixes RPC style into REST)
* Good: `/users/{id}` (resource-oriented)

**Impact:**

* Breaks RESTful conventions.
* Makes API harder to predict and integrate with REST clients.

#### **6. Inconsistent Pluralization**

* `/users` and `/order` in the same API.
* Some endpoints pluralize resources, others don’t.

**Impact:**

* Developers can’t guess resource names without checking docs.
* Auto-generated SDKs may have unpredictable method names.

#### **7. No Version Naming Discipline**

Without clear version naming:

* New endpoints get appended with `new` or `vFinal` instead of proper versioning (`/v2/orders`).
* Breaking changes sneak into existing endpoints without notice.

**Impact:**

* Client applications break unexpectedly.
* Backward compatibility is violated.

## Benefits of Enforcing Naming Guidelines

A well-defined and enforced naming standard in APIs provides **predictability, clarity, and long-term maintainability**.\
It transforms the API from a loosely connected set of endpoints into a **cohesive, predictable system** that developers can navigate with confidence.

{% hint style="success" %}
Enforcing naming guidelines is not about bureaucracy - it’s about **reducing friction, avoiding ambiguity, and future-proofing the API design**.\
A small investment in naming standards today prevents **expensive rework and consumer frustration** tomorrow.
{% endhint %}

#### **1. Improved Developer Experience (DX)**

* Developers can **intuitively guess** endpoint names, parameter formats, and field conventions without constantly checking documentation.
* Reduces onboarding time for new developers - both internal teams and external partners.
* Encourages **self-discoverable APIs** where predictable patterns allow exploration without trial-and-error.

**Example:**\
If `/users/{id}/orders` exists, developers can easily infer `/users/{id}/payments` without needing explicit docs.

#### **2. Consistency Across Teams and Services**

* Teams working on different microservices can **share a common vocabulary** for resource names, fields, and actions.
* Prevents mismatched terminology (`customerId` in one service, `userId` in another for the same concept).
* Encourages **cross-team interoperability** and reduces translation overhead.

#### **3. Reduced Risk of Breaking Changes**

* Consistent naming reduces the need to **rename fields or endpoints later**, avoiding unnecessary version bumps or deprecations.
* New features can **extend existing patterns** without breaking existing clients.

#### **4. Easier Documentation and Tooling**

* API documentation (Swagger/OpenAPI) becomes **cleaner and more structured**.
* Consistent naming helps in **automatic code generation** for SDKs, reducing manual cleanup.
* Improves **searchability** in both codebases and API references.

#### **5. Enhanced Maintainability and Scalability**

* As the API evolves, **new endpoints fit naturally** into the existing naming hierarchy.
* Makes **refactoring safer** because naming rules guide where and how changes should be made.
* Supports **future-proofing** - new developers can pick up the project without deep tribal knowledge.

#### **6. Better Consumer Trust and Adoption**

* Predictable APIs increase confidence for integrators.
* Consistency signals **maturity and professionalism**, which is critical when our API is a product.
* Consumers are more willing to **invest in long-term integrations** when they see stable and well-thought-out naming patterns.

#### **7. Alignment with Industry Best Practices**

* Follows **RESTful principles** and established API style guides (Google, Microsoft, Stripe, GitHub, etc.).
* Reduces learning curve for developers familiar with other high-quality APIs.
