# Iterative Design Process

## About

The **Iterative Design Process** is an approach to system design where solutions are **developed, tested, and refined in cycles** rather than being built all at once.\
Instead of assuming we can design the perfect system from the start, we **build a version, validate it, learn from it, and improve it in the next cycle**.

In **System Design**, this approach reduces risk, accommodates changing requirements, and allows teams to evolve a system based on **real-world feedback** rather than just theoretical planning.

## Why It Matters in System Design ?

* **Minimizes the Cost of Mistakes**
  * Detects design flaws early before they become expensive to fix.
* **Adapts to Evolving Requirements**
  * Business needs, user behavior, and technology trends change—iteration keeps the design relevant.
* **Incorporates Feedback Loops**
  * Stakeholders and users can validate functionality before the system is fully built.
* **Supports Continuous Improvement**
  * Allows incremental performance tuning, scalability improvements, and feature optimization.
* **Encourages Experimentation**
  * Teams can test multiple design approaches without committing to a single path too early.

## Phases of the Iterative Design Process

While different teams may name them differently, the **core flow** in iterative design follows a predictable rhythm.\
Each phase feeds into the next, and the cycle repeats until the system meets the desired goals.\
In **system design**, these phases must account for both **functional correctness** and **non-functional demands** like scalability, resilience, and security.

### **1. Define Objectives (The North Star)**

Every iteration begins with **clear, measurable goals**. Without them, teams risk endless changes without knowing if progress is being made.\
Objectives should -

* Tie directly to **problem framing**
* Be small enough to test within a cycle
* Be measurable with concrete success metrics

**System Design Example**

* Goal: “Reduce API latency from 1.5s to under 500ms at peak load.”
* Metric: p95 latency measurement under 2,000 concurrent requests.

**Why this phase matters ?**\
If the “why” isn’t clear, the “how” will drift.

### **2. Create the Initial Design (Blueprint Stage)**

Translate the objective into a **design hypothesis -** our best current idea for solving the problem.\
This is not about making it perfect - it’s about making it **testable**.\
Activities here include:

* Sketching **system architecture diagrams**
* Drafting **data flow and sequence diagrams**
* Choosing the **minimum viable technology changes** to validate the approach

**System Design Example**

* Hypothesis: Introducing a Redis cache between the API and database will cut latency by at least 40%.
* Design: Cache read-heavy queries, invalidate on writes.

**Why this phase matters ?**\
It forces us to **commit an idea to paper/code** so it can be evaluated objectively.

### **3. Build and Implement (Execution with Boundaries)**

In iterative design, **we don’t build everything -** we build just enough to test our hypothesis.\
Key principles -

* Keep the scope narrow (avoid boiling the ocean)
* Maintain **feature flags** so changes can be rolled out safely
* Ensure **instrumentation and monitoring** are part of the build to measure results

**System Design Example**

* Implement Redis cache layer only for product detail queries
* Add cache hit/miss metrics to observability stack

**Why this phase matters ?**\
It transforms abstract architecture into something measurable.

### **4. Test and Evaluate (Reality Check)**

This is where we validate our design against real-world or simulated conditions.\
Tests should cover -&#x20;

* **Functional correctness** – Does it work as intended?
* **Performance under load** – Does it meet latency, throughput, and concurrency goals?
* **Resilience** – How does it behave under partial failures?
* **Security** – Does it introduce vulnerabilities?

**System Design Example**

* Load test shows p95 latency now 600ms (improvement but still short of 500ms target)
* Error rate reduced from 1% to 0.3%

**Why this phase matters ?**\
Without empirical validation, iteration becomes **guesswork**.

### **5. Gather Feedback (Reality Meets Perspective)**

Numbers tell part of the story; **human feedback** tells the rest.\
We should collect input from -&#x20;

* **End users** – Usability, perceived speed, reliability
* **Stakeholders** – Business priorities and risk tolerance
* **Technical teams** – Maintainability and operational concerns

**System Design Example**

* Users report system “feels” faster even though metrics missed target slightly
* DevOps team warns that cache invalidation logic is complex and could cause stale reads

**Why this phase matters ?**\
Design must work **both technically and operationally**.

### **6. Refine and Repeat (Continuous Evolution)**

The learnings from the previous steps guide the **next iteration**.\
We might -&#x20;

* Fine-tune parameters (e.g., cache TTL values)
* Swap out technologies if they fail to meet goals
* Reframe the objective if deeper problems are revealed

**System Design Example**

* Iteration 2: Add asynchronous background refresh for cache to eliminate stale data issue
* Iteration 3: Move some read queries entirely to pre-computed views in a read replica

**Why this phase matters ?**\
It acknowledges that **perfection is emergent**, not pre-planned.

## Example Iterative Cycle in System Design

Let’s walk through a **real-world style** example to see how the iterative process works in practice.

#### **Scenario:** Improving Search Performance in an E‑Commerce Platform

**Iteration 1 – Hypothesis:**

* **Goal:** Reduce search query latency by at least 30%.
* **Design:** Add a database index to optimize filtering on product category.
* **Build:** Create composite index and redeploy search service.
* **Test:** Latency drops by 22%—improvement, but short of target.
* **Feedback:** DevOps reports CPU usage on DB increased under peak load.

**Iteration 2 – Hypothesis**

* **Goal:** Reduce latency without overloading DB.
* **Design:** Introduce in‑memory caching for popular queries.
* **Build:** Implement Redis cache for top 100 most frequent queries.
* **Test:** Latency drops by additional 25% (total 43%), CPU load normal.
* **Feedback:** Marketing team notes better conversion during sales events.

**Iteration 3 – Hypothesis**

* **Goal:** Make search horizontally scalable for future growth.
* **Design:** Migrate to Elasticsearch cluster.
* **Build:** Implement Elasticsearch with relevant analyzers, sync with product DB.
* **Test:** Latency drops to <200ms for 95% of requests; can handle 10x current traffic.
* **Feedback:** Stakeholders agree objective achieved, move to maintenance mode.

**Takeaway**\
This process didn’t jump directly to Elasticsearch from the start. Each iteration **reduced uncertainty** while improving performance, avoiding unnecessary complexity until it was justified.

## Best Practices

1. **Define Measurable Success Criteria for Each Iteration**
   * Without metrics, we can’t objectively decide if an iteration succeeded.
2. **Keep Scope Small**
   * Large changes hide cause‑and‑effect; small iterations reveal what works.
3. **Test Under Realistic Conditions**
   * Simulate real-world load, failure patterns, and security constraints.
4. **Include Observability from Day One**
   * Add logging, metrics, and tracing in each iteration to guide decisions.
5. **Validate with Multiple Stakeholders**
   * Engineers see technical trade‑offs; business sees ROI; users see usability.
6. **Document Iterations**
   * Keep a record of hypotheses, changes, results, and lessons learned for future teams.
7. **Be Ready to Roll Back**
   * Feature flags and staged rollouts reduce risk if an iteration fails.
8. **Accept That Some Iterations Will “Fail”**
   * Failure is data - it tells us which paths **not** to take.
