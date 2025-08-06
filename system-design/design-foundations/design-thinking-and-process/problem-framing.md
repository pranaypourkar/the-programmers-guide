# Problem Framing

## About

**Problem Framing** is the process of **defining the real challenge that needs to be solved** before jumping into architectural decisions.\
It’s the **foundation layer** of the entire design process—if we get this wrong, every decision that follows will be based on **faulty assumptions**.

In system design, problems often arrive as **high-level business requests**:

* “We need the application to be faster.”
* “We want to move to microservices.”
* “We need to handle more users.”

The issue?\
These are **solution-leaning statements** that don’t fully explain **what’s broken, how it’s affecting users, or what constraints must be considered**.

Proper problem framing transforms these vague requests into **clear, measurable, and actionable design challenges**.

{% hint style="success" %}
In system design, a well-framed problem is half-solved. The clearer the problem definition, the easier it is to design a solution that is **scalable, maintainable, and cost-effective**.
{% endhint %}

## Why Problem Framing is Critical ?

Problem framing is **not** a soft skill - it’s an **engineering necessity**.\
In large-scale systems, **the cost of solving the wrong problem can be enormous**—both in time and money.\
Poorly framed problems lead to **over-engineering**, **misaligned priorities**, and **solutions that fail in production**.

Here’s why it’s so critical:

#### **1. It Prevents Misaligned Solutions**

In many organizations, problems are presented as **pre-baked solutions**:

* “We should switch to microservices.”
* “We need to add caching.”
* “Let’s use Kafka for this.”

Without reframing, engineers may implement these **assumed solutions** without validating if they actually solve the root cause.\
Problem framing forces the team to **step back and ask**:

* What are we truly trying to fix?
* Is this a symptom of something deeper?
* Are there simpler, cheaper alternatives?

#### **2. It Anchors Design Decisions in Reality**

Every system design decision—choice of architecture, database, scaling strategy—should be driven by **clear, measurable objectives**.\
Without a framed problem:

* Success criteria become vague (“Make it faster”).
* Trade-offs are hard to justify (“Why did we choose horizontal scaling instead of optimizing the DB?”).
* The system may be “better” in theory but **fails to solve the intended business problem**.

#### **3. It Guides Prioritization**

When resources are limited (time, budget, team size), problem framing clarifies **what matters most**:

* Should we optimize latency or focus on uptime?
* Should we design for millions of users now, or support moderate growth first?
* Should we meet compliance requirements before adding new features?

Framing prevents teams from **wasting effort** on low-impact improvements.

#### **4. It Improves Communication Across Roles**

System design often involves **cross-functional collaboration**—developers, architects, product managers, DevOps, QA, and even compliance teams.\
A well-framed problem acts as a **shared reference point**, so:

* Engineers know _what_ to build
* Product managers know _why_ it matters
* Stakeholders can agree on _when_ it’s done

#### **5. It Reduces Risk in Complex Systems**

Distributed systems are full of **interdependencies**—changes in one area can break others.\
If we frame the problem incorrectly:

* We might “fix” one bottleneck but create a bigger one elsewhere.
* We might introduce unnecessary complexity (new services, queues, or databases) when a simpler fix would work.

Good problem framing **maps the impact zone** of the change before any code is written.

#### **6. It Protects Against Scope Creep**

Poorly defined problems invite **endless additions**:

* “Since we’re touching the API, can we also add this feature?”
* “Can we also make it work for another business unit?”

Framing the problem **with explicit boundaries** allows teams to reject unrelated work without appearing uncooperative.

#### **7. It Saves Time and Money**

Industry studies consistently show that **fixing an issue in production can cost 10–100x more** than fixing it in the design stage.\
By framing the problem:

* We avoid wasted implementation cycles
* We prevent costly rollbacks or re-architecture
* We deliver **faster, more effective solutions**

## The Problem Framing Process

Problem framing in system design is not a one-off step—it’s a **structured, iterative process**.\
Each stage brings clarity, narrows focus, and ensures that the **final solution aligns with real needs** rather than assumptions.

### **Step 1 – Understand the Context**

Before touching architecture diagrams, first **zoom out** and understand the **environment** the problem lives in.\
Ask

* What is the **business goal** driving this request?
* Which **users** or **stakeholders** are impacted?
* How does this system fit into the **broader technical ecosystem**?
* Are there **external constraints** (compliance, legal, security)?

**Example**\
A payment service needs scaling. Context reveals this is for **Black Friday sales**, which means sudden **traffic spikes**, **transaction security**, and **zero tolerance for downtime**.

### **Step 2 – Identify the Core Problem**

Separate **symptoms** from **root causes**.

* Use **data** (logs, metrics, user reports) rather than opinions.
* Ask **“Why?”** repeatedly (5 Whys Technique) until we uncover the fundamental issue.

**Example**\
Symptom: “Checkout is slow.”\
Root cause: “The checkout API spends 70% of its time waiting for inventory service responses during high traffic.”

### **Step 3 – Define Success Criteria**

The problem statement must have **measurable outcomes**.\
This ensures everyone knows when the problem is truly solved.

* **Functional goals:** “Handle 2,000 concurrent requests.”
* **Non-functional goals:** “Latency < 500ms for 95% of requests.”
* **Business goals:** “Maintain conversion rate above 90% during peak traffic.”

### **Step 4 – Clarify Scope and Boundaries**

Document

* What’s **in scope** (components, APIs, data flows to be addressed)
* What’s **out of scope** (features, unrelated services, edge cases not impacting core goals)

This prevents **scope creep** and keeps the design effort focused.

### **Step 5 – Challenge Assumptions**

Stakeholders often present problems **pre-loaded with a solution**:

* “We need to use Kafka.”
* “We should switch to microservices.”

Challenge these respectfully

* Is this the **only** way to solve the problem?
* Is there a **simpler, lower-risk approach**?
* Will this introduce **new bottlenecks** or **maintenance costs**?

### **Step 6 – Frame the Problem Statement**

Now, consolidate our findings into a **clear, precise, and measurable** statement.

**Formula**

> **\[System/Feature]** is **\[failing/underperforming in specific metric]** under **\[conditions]**, which impacts **\[business or user goal]**.\
> The solution must **\[meet defined success criteria]** within **\[constraints like cost, time, compliance]**.

**Example**

> “Our checkout API experiences >2s latency for 20% of transactions when concurrent users exceed 500 during flash sales, leading to a 7% drop in conversions. We need to reduce latency to <500ms for 95% of requests at up to 2,000 concurrent users without exceeding a 20% infrastructure cost increase.”

### **Step 7 – Validate with Stakeholders**

Before moving forward:

* Share the framed problem statement.
* Ensure **all stakeholders agree**.
* Adjust based on feedback and newly surfaced constraints.

Only **after this agreement** should the design phase proceed.

## Framing Examples

Framing is about **sharpening the problem statement** so it’s clear, measurable, and solution-agnostic.\
Below are examples showing how vague or misleading problem descriptions can be reframed into actionable design challenges.

#### **Example 1 – Performance Issue**

**Vague problem**

> “The system is slow.”

**Framed problem**

> “The checkout API’s p95 latency exceeds 2 seconds during peak hours when concurrent user requests exceed 500, causing a 7% drop in completed transactions. We need to reduce latency to under 500ms for 95% of requests at up to 2,000 concurrent users, without exceeding a 20% increase in infrastructure cost.”

**Why this works ?**

* Specifies which system (checkout API)
* Defines when the problem occurs (peak hours, >500 concurrent users)
* States impact (conversion drop)
* Sets clear success metrics (latency target, concurrency goal, cost constraint)

#### **Example 2 – Scalability Request**

**Vague problem**

> “We need to scale the system.”

**Framed problem**

> “Our current reporting service can process 10,000 records per hour before exceeding 90% CPU usage, leading to delays in generating daily financial reports. We must handle 100,000 records per hour while keeping CPU utilization below 70% and ensuring report delivery by 6 AM daily.”

**Why this works ?**

* Identifies **current limitation** (CPU bottleneck at 10k records/hour)
* Specifies **required scale** (100k records/hour)
* Includes **operational constraint** (reports by 6 AM)

#### **Example 3 – Reliability Problem**

**Vague problem**

> “The system keeps going down.”

**Framed problem**

> “The authentication service experiences an average of 3 outages per month, each lasting 10–20 minutes, due to database connection pool exhaustion. This impacts 100% of login attempts during downtime. We must reduce outages to fewer than 1 per quarter and recovery time to under 2 minutes.”

**Why this works ?**

* Quantifies **frequency and duration** of failures
* Identifies **root cause** (connection pool exhaustion)
* States **target reliability** (outages <1 per quarter, recovery <2 minutes)

#### **Example 4 – Feature Request with Hidden Problem**

**Vague request (solution-leaning)**

> “We need to migrate to microservices.”

**Framed problem**

> “Our monolithic application requires 2+ hours to deploy changes due to full application restarts and long regression test cycles. This delays critical bug fixes and feature rollouts. We must reduce deployment time to under 10 minutes while maintaining full test coverage and minimizing downtime.”

**Why this works ?**

* Avoids assuming microservices is the only answer
* Focuses on **real pain point** (slow deployments)
* Sets measurable **deployment target** (under 10 minutes)

#### **Example 5 – Compliance Requirement**

**Vague problem**

> “We need better security.”

**Framed problem**

> “Our payment processing service currently stores credit card data in plain text logs, violating PCI-DSS requirements. We must ensure no sensitive data is logged in any environment, with automated checks preventing non-compliant deployments.”

**Why this works ?**

* Clearly identifies the **specific security gap**
* References **compliance standards** (PCI-DSS)
* Sets **verification requirement** (automated compliance checks)

## Techniques for Better Problem Framing

Framing a problem well is a skill that improves with practice.\
Below are proven techniques that help engineers, architects, and product teams move from **vague requests** to **clear, actionable design challenges**.

### **1. The 5 Whys Method**

Ask “Why?” repeatedly (usually five times) until we uncover the root cause of a problem.

**Why it works ?**\
It forces teams to **dig past surface symptoms** and find the **real issue**.

**Example in System Design**

* Problem: “The API is slow.”
* Why? → “The database queries are taking too long.”
* Why? → “They are missing indexes.”
* Why? → “Indexes were dropped during a schema change.”
* Why? → “The schema change process lacks review.”
* Why? → “No automated regression checks for indexes exist.”\
  **Root cause:** Lack of schema change governance—not just slow queries.

### **2. Metrics-Driven Analysis**

Use real data (logs, APM tools, metrics dashboards) to validate the existence, frequency, and scale of the problem.

**Why it works ?**\
Removes **guesswork** and prevents optimizing for **non-issues**.

**Example**\
Stakeholders claim “Users are complaining about slow search.”\
Metrics show:

* p95 latency is fine during normal load but spikes when >200 concurrent requests hit the search index.
* Root problem: Search service lacks horizontal scaling under peak load.

### **3. Stakeholder Alignment Workshops**

Bring technical and non-technical stakeholders together to agree on the **problem definition** before discussing solutions.

**Why it works ?**\
Prevents **misaligned priorities** and ensures everyone works toward **the same goal**.

**Example**\
Ops team says “We need better uptime.” Product says “We need more features.”\
Workshop reveals:

* Feature delivery is slowed by downtime.
* Improving uptime indirectly enables faster feature delivery.

### **4. Impact Mapping**

A visual method to map **business goals → actors → impacts → deliverables**.

**Why it works ?**\
Links technical work directly to **business value**.

**Example**\
Goal: Increase checkout completion rate.\
Actors: Users, payment gateway.\
Impacts: Users drop off during payment failures.\
Deliverables: Retry mechanism, payment status tracking.

### **5. Constraint Listing**

List **all constraints** (technical, legal, operational, cost-related) before designing.

**Why it works ?**\
Ensures the solution is **realistic and viable** in the given environment.

**Example**\
Scaling API traffic to 10x is feasible—\
but if the system must also run on-prem for certain clients (compliance), the scaling solution must be **hardware-aware**.

### **6. Problem Reframing**

Write the problem in **three different ways -** focusing on:

* User perspective
* Business perspective
* Technical perspective

**Why it works ?**\
Reveals **hidden assumptions** and ensures we are solving the **same core issue** from all angles.

**Example**

* User view: “The site crashes during checkout.”
* Business view: “We lose revenue during peak sale events.”
* Technical view: “Memory limits on the checkout service cause container restarts.”

### **7. Pre-Mortem Analysis**

Imagine we implemented a solution and it **failed badly**. Then, ask **why**.

**Why it works ?**\
Surfaces **risks early**, so we can address them in the problem definition phase.

**Example**\
We solved API slowness with aggressive caching—\
Pre-mortem reveals potential **cache inconsistency issues** during critical updates, making the solution risky.
