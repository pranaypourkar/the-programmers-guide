# GraphQL API Versioning Approaches

## About

Unlike REST, GraphQL **discourages explicit version numbers** in the API endpoint. Instead, the philosophy is to **evolve the schema incrementally** while maintaining backward compatibility.\
In GraphQL, the endpoint typically remains fixed (e.g., `/graphql`), and all version control is managed within the **schema and resolver logic**.

The reasoning:

* GraphQL clients explicitly request only the fields they need.
* Adding new fields or types is non-breaking.
* Deprecated fields can be gradually phased out without breaking existing clients.

However, schema evolution **must be managed carefully**, and there are still situations where more drastic versioning approaches are needed.

## Approaches

### **1. Schema Evolution without Endpoint Changes (Preferred)**

**Example:**

```graphql
# Existing field
type Customer {
  id: ID!
  name: String!
}

# Adding new field (non-breaking)
type Customer {
  id: ID!
  name: String!
  email: String # newly added
}
```

**How It Works:**

* Fields are added in a **backward-compatible** way.
* No fields or types are removed abruptly.
* Deprecated fields remain available until safe removal.

**Advantages:**

* **Single endpoint** — no proliferation of `/v1`, `/v2` URLs.
* **Client-driven upgrades** — clients can adopt new fields at their own pace.
* **Reduced operational complexity**.

**Disadvantages:**

* Requires **strict discipline** to avoid breaking changes.
* Removal of deprecated fields must be coordinated with all client teams.

**Operational Notes:**

* Use `@deprecated(reason: "...")` annotations for old fields.
* Establish **deprecation timelines** and communicate via release notes.

### **2. Field Deprecation and Sunset Policy**

**Example:**

```graphql
type Customer {
  id: ID!
  fullName: String! @deprecated(reason: "Use 'firstName' and 'lastName'")
  firstName: String!
  lastName: String!
}
```

**How It Works:**

* Fields that should not be used are marked with `@deprecated`.
* Clients are expected to stop querying these fields before removal.
* Deprecation reason is visible in schema introspection tools (e.g., GraphiQL).

**Advantages:**

* **In-schema communication** — Developers discover deprecations directly via schema inspection.
* **Smooth migration path** for clients.

**Disadvantages:**

* Clients may ignore deprecation notices.
* No enforcement until the field is actually removed.

**Governance Notes:**

* Combine deprecation annotations with **external announcements**.
* Define **minimum deprecation periods** (e.g., 6 months) before removal.

### **3. Separate Schemas for Major Breaks**

While GraphQL prefers evolving one schema, some scenarios justify **separate schema versions**:

* Major architectural changes (e.g., switching from relational DB to event-sourced model).
* Complete redesign of resource structures.
* Compliance or security-driven changes requiring a clean slate.

**Approaches:**

*   **Endpoint separation**:

    ```
    POST /graphql/v1
    POST /graphql/v2
    ```
* **Schema separation inside the same endpoint**:
  * Namespacing types (`V2Customer`, `V2Order`).
  * Using directives to separate execution paths.

**Advantages:**

* Allows radical redesigns without impacting old clients.
* Enables running **parallel resolvers**.

**Disadvantages:**

* Defeats some of GraphQL’s **single-source-of-truth** appeal.
* Higher maintenance cost — two schemas must be updated independently.

### **4. Experimental Feature Flags**

Sometimes new fields or types are introduced only for **beta testers**:

* Implement **server-side feature toggles**.
* Hide or expose fields based on **user roles** or **API key metadata**.

**Advantages:**

* Enables incremental rollout of risky features.
* Allows internal testing before public release.

**Disadvantages:**

* Can complicate schema introspection results.
* Risk of **inconsistent API experiences** if flags are not aligned across environments.

## **Change Monitoring and Governance**

To manage GraphQL versioning effectively:

1. **Schema Change Tracking** — Use tools like Apollo Studio or GraphQL Inspector to detect breaking changes before deployment.
2. **Backward Compatibility Contracts** — Define what counts as a breaking change (e.g., removing a field, changing a field’s type, making a nullable field non-nullable).
3. **Automated Schema Diffing** — Run CI/CD jobs that compare the current schema against the last released schema.
4. **Consumer-Driven Contracts (CDC)** — Align with client teams before making changes.

## **When Explicit Versioning is Unavoidable ?**

While GraphQL promotes schema evolution over explicit version numbers, explicit endpoint versioning may be required when:

* **Breaking business model changes** make old queries meaningless.
* **API governance rules** mandate freezing old schemas for regulatory reasons.
* **Contractual obligations** require keeping an untouched "v1" for certain partners.
