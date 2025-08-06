# DRY

## About

The **DRY** principle, short for **Don’t Repeat Yourself**, was introduced by Andy Hunt and Dave Thomas in their book _The Pragmatic Programmer_.\
It states:

> **"**&#x45;very piece of knowledge must have a single, unambiguous, authoritative representation within a system."

In simpler terms, **if we find the same knowledge or logic expressed in multiple places, consolidate it into one place and reuse it**.\
This could mean avoiding duplicate code, duplicate business rules, or even duplicate documentation.

DRY is **not** just about cutting down on copy‑pasted code—it’s about reducing duplication of **knowledge** in any form:

* Business rules
* Database schemas
* API contracts
* Configuration values
* Documentation

## Why It Matters ?

Duplicate logic in software systems is a major source of maintenance problems. If a rule or formula changes in the future, every copy must be updated—if one is missed, the system becomes inconsistent and unreliable.\
When applied well, DRY brings:

* **Maintainability** – We only need to change logic in one place.
* **Consistency** – The same rules always produce the same results.
* **Reduced Bugs** – Less chance of missing an update in a copy.
* **Smaller Codebase** – More concise, easier to read.

## Common Violations

1. **Copy-Paste Programming** – Copying the same block of code into multiple modules.
2. **Multiple Sources of Truth** – Same business rule defined in UI, backend, and database separately.
3. **Hardcoded Constants in Multiple Places** – e.g., `3.14159` scattered throughout instead of one `PI` constant.
4. **Duplicated Configurations** – Having the same setting in multiple files without a shared configuration.
5. **Duplicated Documentation** – Multiple wiki pages explaining the same process separately.

## How to Apply DRY ?

Applying DRY effectively requires thinking about **where** duplication exists, **why** it exists, and **how** to centralize or eliminate it without making the system overly complex.\
It’s not just about reducing code size - it’s about creating a **single source of truth** for each piece of knowledge in our system.

### **1. Identify Duplication Early**

Before applying DRY, we must **spot** where repetition happens. Duplication can be:

* **Code Duplication** – Same logic appears in multiple methods, classes, or services.
* **Knowledge Duplication** – Business rules, formulas, or workflows described in more than one place.
* **Data Duplication** – Same dataset stored in multiple systems without a single master source.
* **Configuration Duplication** – Same setting repeated in multiple files or environments.
* **Documentation Duplication** – The same concept explained in multiple documents or wikis.

{% hint style="warning" %}
**Tip:** Use code analysis tools (e.g., SonarQube, PMD, Checkstyle) to detect repetitive patterns automatically.
{% endhint %}

### **2. Abstract Repeated Logic**

When two or more sections of code do the same thing, **extract** the logic into:

* **A shared method/function**
  * Instead of rewriting the same calculation, move it into one method and call it where needed.
* **A utility/helper class**
  * Centralize shared functions like string formatting, date handling, or number conversions.
* **A reusable module/package**
  * If the same logic is used across multiple services, create a shared library.

**Example:**\
Instead of repeating validation logic in multiple controllers:

```java
public boolean isValidEmail(String email) {
    return email.matches(EMAIL_REGEX);
}
```

Put it into a **ValidationUtils** class.

### **3. Centralize Constants and Configurations**

Avoid scattering constant values or settings across different files. Use:

* **Configuration files** (application.properties, YAML, JSON)
* **Environment variables** for deployment-specific values
* **Constants classes** for shared static values
* **Feature flags** for conditional behavior instead of hardcoded switches

### **4. Reuse Data Models**

If multiple parts of our application define the same object structure, create a **shared model**:

* **DTOs (Data Transfer Objects)** – Avoid redefining the same request/response schema in multiple services.
* **Database schema single ownership** – Ensure only one service controls the schema to avoid drift.

### **5. Leverage Inheritance and Composition Wisely**

Instead of duplicating fields and methods:

* Use **inheritance** for “is-a” relationships.
* Use **composition** for “has-a” relationships.
* Extract shared logic into abstract base classes where appropriate.

### **6. Unify Business Rules**

If the same business rule is enforced in the UI, API, and database separately, make sure:

* It is **defined once** (e.g., in backend service)
* Other layers simply **consume** the result or call the shared validation service
* Avoid “multiple truths” where one layer says a request is valid but another rejects it

### **7. Refactor Regularly**

Duplication creeps in naturally during development. Regularly:

* **Review PRs for repetition**
* **Schedule refactoring sprints**
* Use automated detection tools to flag common patterns
*   Encourage a team culture where developers question:

    > "Do we already have this implemented somewhere?"

### **8. Apply DRY Beyond Code**

DRY also applies to **non-code artifacts**:

* **Documentation** – Link to a single page instead of rewriting the same information in multiple wikis.
* **Test cases** – Avoid testing the same logic in multiple ways without purpose.
* **Build pipelines** – Parameterize build jobs instead of duplicating them for different environments.

### **9. Beware of Premature DRY**

Not all duplication should be removed immediately—sometimes similarities are **accidental** and will diverge later.\
Apply DRY when:

* The duplication is **exact** or highly similar
* The logic is **unlikely to diverge** in the future
* The cost of abstraction is **less than the cost of maintaining multiple copies**

## Example

**Violation**

```java
double calculateCircleArea(double radius) {
    return 3.14159 * radius * radius; // Pi hardcoded
}

double calculateCylinderVolume(double radius, double height) {
    return 3.14159 * radius * radius * height; // Pi hardcoded again
}
```

**Refactored (DRY Applied)**

```java
private static final double PI = Math.PI;

double calculateCircleArea(double radius) {
    return PI * radius * radius;
}

double calculateCylinderVolume(double radius, double height) {
    return PI * radius * radius * height;
}
```

Now, if the calculation changes (e.g., precision), only **one line** needs updating.

## When Not to Apply DRY ?

While the **DRY** principle is powerful, applying it blindly can harm code clarity, introduce unnecessary complexity, and create over‑engineered abstractions.\
This phenomenon is sometimes called **“Over-DRYing”** or **“Premature Abstraction.”**

{% hint style="success" %}
Rule of Thumb

**“Three strikes and we refactor.”**\
If we see something duplicated once, it might be coincidence. Twice—consider refactoring. Thrice—almost certainly time to extract it.\
But always weigh **future maintainability** against **current clarity**.
{% endhint %}

#### **1. When Similarity is Accidental, Not Fundamental**

Sometimes two pieces of code _look_ similar now, but they serve different purposes and will evolve in different directions.\
If we merge them too early into a shared function or class:

* Future changes to one will affect the other unexpectedly.
* We create **tight coupling** between unrelated components.

> **Example:**\
> Two APIs both format addresses today, but one follows US postal rules and the other international standards. They may diverge quickly—keeping them separate avoids unnecessary dependencies.

#### **2. When It Reduces Readability**

If extracting shared code results in:

* Many parameters
* Generic method names that hide intent
* Indirection that forces the reader to “jump” around files

…then we have made the design less readable, even if it’s technically DRY.

#### **3. During Early Prototyping**

In the initial stages of a project:

* Requirements are still unclear.
* Features may be discarded entirely.
* Code is likely to change significantly.

In these cases, **duplication is cheaper** than building abstractions that might be thrown away later.

> Follow the idea: **“Make it work, then make it right, then make it fast.”**

#### **4. When Performance Is a Priority**

Sometimes in performance-critical code:

* Inlining logic instead of calling a shared function can reduce method call overhead.
* Avoiding extra abstraction can allow for better optimization.

In such cases, **controlled duplication** is acceptable for performance gains (but must be documented).

#### **5. When the Cost of Abstraction Outweighs the Benefit**

Every abstraction:

* Has to be learned by new developers.
* Can introduce complexity in debugging.
* Might require dependency management.

If removing duplication results in **complex generic code** that’s harder to maintain than the duplication itself, it’s better to leave the duplication.

#### **6. For Documentation Tailored to Different Audiences**

While DRY applies to documentation, sometimes separate versions are needed for:

* Developers
* Business users
* Compliance officers

These documents might repeat core concepts but must be worded differently.

#### **7. Test Cases That Validate the Same Logic in Different Contexts**

Some duplication in tests:

* Improves clarity
* Makes it obvious what’s being tested without having to read shared utility methods

Too much DRY in tests can hide the **story** the test is telling.
