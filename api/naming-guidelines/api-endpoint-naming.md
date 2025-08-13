# API Endpoint Naming

## About

API endpoint naming refers to the **structured approach** of defining resource paths in an API so that they are **predictable, meaningful, and easy to understand**.\
Well-named endpoints follow **RESTful principles** (if applicable) and communicate intent through **nouns** representing resources, not verbs representing actions.

Endpoints are often the **first touchpoint** between API consumers and our system. Poorly named endpoints lead to:

* Higher onboarding time
* Increased reliance on documentation
* Risk of breaking changes during refactoring

A consistent endpoint naming strategy ensures **clarity, scalability, and long-term maintainability**.

## Core Principles

### **1. Use Nouns for Resources, Not Verbs**

Endpoints represent **resources** (things) rather than **actions**.

**Bad:**

```
GET /getUserDetails
POST /createUser
DELETE /removeUser
```

Problems:

* Redundant verbs duplicate HTTP method meaning.
* Harder to maintain if actions expand (e.g., `updateUserDetails`).

**Good:**

```
GET /users/{id}         # Retrieve user details
POST /users             # Create new user
DELETE /users/{id}      # Delete user
```

Reasoning: The HTTP method (GET, POST, DELETE) already implies the action; the path should just identify the resource.

### **2. Use Lowercase and Hyphen-Separated Words**

* URLs are **case-sensitive** in many systems.
* Lowercase avoids confusion.
* Hyphens improve readability compared to underscores.

**Bad:**

```
/UserProfiles
/user_profiles
```

**Good:**

```
/user-profiles
```

Reasoning: Hyphens are more natural for reading multi-word segments and are standard in most API guidelines.

### **3. Use Plural for Collections**

Collections (lists of resources) should be plural, individual resources singular via ID.

**Bad:**

```
GET /user         # Is this one user or many?
GET /order-list   # Custom naming, not predictable
```

**Good:**

```
GET /users        # List of users
GET /users/{id}   # Single user
GET /orders       # List of orders
```

Reasoning: Pluralization clarifies that the endpoint is a collection, and keeps it consistent across entities.

### **4. Follow Hierarchical Relationships**

If a resource only exists in the context of another, make it a sub-resource.

**Bad:**

```
GET /orders-items         # Not clear which order
GET /items?orderId=123    # Breaks natural hierarchy
```

**Good:**

```
GET /orders/{orderId}/items
```

Reasoning: Nested paths express ownership and dependency in a human-readable way.

### **5. Avoid Verb Actions in Path**

If an operation is not CRUD but still a valid action, model it as a **sub-resource** or **action keyword**, not a verb on the main path.

**Bad:**

```
POST /approveOrder
POST /cancelInvoice
```

**Good:**

```
POST /orders/{id}/approval
POST /invoices/{id}/cancellation
```

Reasoning: Keeps paths consistent; special actions look like part of the resource model.

### **6. Keep Endpoints Predictable**

Similar resource types should follow the same structure everywhere.

**Bad:**

```
GET /users/{id}/transactions
GET /merchants/{id}/sales
```

Reasoning: Mixing naming (`transactions` vs. `sales`) makes it harder to guess endpoints.

**Good:**

```
GET /users/{id}/transactions
GET /merchants/{id}/transactions
```

Reasoning: Consistent naming improves discoverability and reduces documentation lookup.

### **7. Avoid Redundancy**

Don’t repeat resource names unnecessarily.

**Bad:**

```
/users/{userId}/user-orders
```

**Good:**

```
/users/{userId}/orders
```

Reasoning: Redundancy clutters the path and adds no new meaning.

### **8. Use Query Parameters for Filtering, Sorting, Pagination**

Filters, sorts, and pagination parameters **belong in the query string**, not the path.

**Bad:**

```
GET /users/active/sort/name
GET /orders/pending/page/2
```

**Good:**

```
GET /users?status=active&sort=name
GET /orders?status=pending&page=2
```

Reasoning: Path segments should identify a resource; query parameters define **how** we want it.

### **9. Keep Versioning Consistent (If in URL)**

If we use URL-based versioning, keep it at the **root** and apply consistently.

**Bad:**

```
/users/v1
/v1/orders/v2
```

**Good:**

```
/v1/users
/v1/orders
```

Reasoning: Mixing version positions creates confusion and migration pain.

### **10. Plan for Special Actions Carefully**

Some operations don’t fit CRUD - use **clear action nouns**.

**Bad:**

```
POST /resetPassword
```

**Good:**

```
POST /users/{id}/reset-password
```

Reasoning: Ties the action to the resource, making context explicit.

## **Example: E-Commerce API**

```
GET    /products                      # List products
POST   /products                      # Create product
GET    /products/{id}                  # Get product
PUT    /products/{id}                  # Update product
DELETE /products/{id}                  # Delete product

GET    /products/{id}/reviews          # Reviews for a product
POST   /products/{id}/reviews          # Add a review

GET    /orders                         # List orders
POST   /orders                         # Create order
GET    /orders/{id}                    # Get order
POST   /orders/{id}/cancellation       # Cancel order

GET    /users/{id}/orders              # Orders by a user
```
