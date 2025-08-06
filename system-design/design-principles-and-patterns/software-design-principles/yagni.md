# YAGNI

## About

**YAGNI** stands for **“You Aren’t Gonna Need It”** and is a software design principle popularized in Extreme Programming (XP).\
It advises developers to **only implement features, functionality, or optimizations when they are actually needed -** not when they are merely anticipated.

The idea behind YAGNI is that speculative development leads to wasted effort, increased complexity, and unnecessary maintenance.\
Many “future-proofing” features are never used, yet they still consume developer time, increase the codebase size, and introduce potential bugs.

YAGNI is closely related to **KISS** (Keep It Simple, Stupid) and complements the **Agile** philosophy of delivering small, incremental changes based on real user needs rather than assumptions.

{% hint style="success" %}
**Rule of Thumb**

Implement for today’s needs **unless** we have **high certainty** that the future requirement will arrive _and_ the cost of adding it later will be significantly higher than adding it now.
{% endhint %}

## Why It Matters ?

Violating YAGNI often results in **over‑engineering**, where code is written for scenarios that may never occur. This has multiple negative effects:

* **Wasted Development Time** – Effort spent building unused features could have gone into delivering real, current requirements.
* **Increased Maintenance Burden** – Every additional feature must be tested, documented, and maintained—even if it’s unused.
* **Reduced Agility** – Large, speculative designs are harder to change when actual requirements arrive.
* **Hidden Bugs** – Code that isn’t used today might not be well tested, leading to production issues if it’s suddenly activated later.
* **Delayed Delivery** – Building for hypothetical scenarios slows down delivering value to users now.

By following YAGNI, teams focus on **solving today’s problems today**, ensuring that code is lean, maintainable, and driven by verified needs rather than speculation.

## Common Violations

* **Future‑Proofing Without a Requirement**
  * Building features for hypothetical future use cases without confirmed need.
  * Example: Adding multi‑currency support in an app that currently only operates in one country.
* **Premature Optimization**
  * Writing highly complex algorithms or performance tuning before knowing if performance is an actual issue.
* **Over‑Generalizing Code**
  * Creating generic frameworks or utilities “just in case” they’re needed in other projects.
* **Complex Configuration Systems**
  * Adding numerous configurable options for a feature that could have been hard‑coded until there was proven demand.
* **Unused Integration Points**
  * Designing APIs or hooks for integrations that aren’t currently planned or requested.
* **Extra Abstraction Layers**
  * Wrapping code in multiple layers of interfaces, adapters, or factories for scenarios that may never exist.

## How to Apply YAGNI ?

#### **1. Work Iteratively**

* Adopt an incremental delivery model (Agile, Scrum, Kanban).
* Focus on delivering small, working features that meet _current_ requirements.

#### **2. Validate Needs Before Building**

* Ask: _“Who asked for this? Do we have proof it’s needed now?”_
* Use customer feedback, analytics, or business goals to justify new features.

#### **3. Build for Today’s Requirements Only**

* Implement the simplest solution that satisfies _today’s_ use case.
* Delay building additional options or extensibility until the requirement is real.

#### **4. Defer Decisions**

* Use design flexibility (not pre‑built complexity) to adapt when new requirements come in.
* Leave placeholders or clear extension points rather than implementing full functionality prematurely.

#### **5. Avoid Premature Optimization**

* Measure performance first—only optimize when a bottleneck is proven.
* Resist replacing simple O(n) solutions with advanced algorithms without evidence.

#### **6. Control “Nice‑to‑Have” Requests**

* During planning, separate “must‑have” requirements from “nice‑to‑have” ideas.
* Push back on low‑value features until they become business priorities.

#### **7. Review Code for Unused Features**

* Use static analysis or code coverage tools to find unused code paths.
* Remove dead code rather than keeping it “just in case.”

## Example

**Violation (YAGNI Breach)**

```java
public class PaymentProcessor {

    public void processPayment(double amount, String currency) {
        if ("USD".equals(currency)) {
            processUSD(amount);
        } else if ("EUR".equals(currency)) {
            processEUR(amount);
        } else if ("JPY".equals(currency)) {
            processJPY(amount);
        } else {
            throw new UnsupportedOperationException("Currency not supported yet");
        }
    }

    private void processUSD(double amount) { /* Logic */ }
    private void processEUR(double amount) { /* Logic */ }
    private void processJPY(double amount) { /* Logic */ }
}
```

**Issues:**

* Multiple currencies supported in code even though the business only processes USD.
* Extra code increases testing, maintenance, and potential for bugs.

**Applied YAGNI**

```java
public class PaymentProcessor {

    public void processPayment(double amount) {
        processUSD(amount); // Only handle USD for now
    }

    private void processUSD(double amount) { /* Logic */ }
}
```

**Benefits**

* Less code to maintain.
* Faster to test and deploy.
* Easier to extend **when** other currencies are actually needed.

## When Not to Apply YAGNI ?

While YAGNI promotes minimalism, there are situations where anticipating future needs is justified.

#### **1. When Changing Later Would Be Extremely Costly**

If adding functionality later requires a **massive rewrite** or architectural overhaul, it may be worth doing some upfront design.\
Example: Choosing a database technology that scales poorly when we already expect huge future growth.

#### **2. When Legal or Compliance Requirements Demand It**

We may need to implement certain audit, encryption, or logging capabilities now, even if they aren’t actively used, to stay compliant.

#### **3. When Integration Points Must Be Ready from Day One**

Some third‑party or partner systems expect specific APIs or protocols from the start, and missing them could block adoption.

#### **4. When Safety Is a Factor**

In systems like aviation or healthcare, it’s better to include safeguards and redundancies up front rather than waiting for a need to arise.

#### **5. When Strategic Business Goals Are Confirmed**

If the business has a committed roadmap with guaranteed upcoming features, building certain shared foundations early may be efficient.
