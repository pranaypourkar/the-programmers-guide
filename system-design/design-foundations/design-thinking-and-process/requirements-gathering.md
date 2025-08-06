# Requirements Gathering

## About

**Requirements Gathering** is the process of **collecting, clarifying, and documenting what a system must do** to meet business needs and user expectations.\
It ensures that **all stakeholders have a shared understanding** of what is to be built—before any design or development starts.

In **System Design**, this is critical because architecture decisions—databases, scaling strategies, security measures—depend directly on **knowing exactly what the system is supposed to achieve**.

## Why It Matters in System Design ?

1. **Avoids Costly Rework**
   * Fixing a misunderstood requirement in the design phase is far cheaper than after development or deployment.
2. **Sets a Clear Scope**
   * Prevents scope creep by defining exactly what is in and out of the project.
3. **Aligns Business and Technical Teams**
   * Requirements become a **contract** between stakeholders and engineering teams.
4. **Drives Architecture Decisions**
   * Non-functional requirements (scalability, availability, security) have a huge impact on system design choices.
5. **Supports Testing and Validation**
   * Test cases can be directly mapped from documented requirements.

## Types of Requirements

In **System Design**, requirements are not just a “to-do list” for developers—they’re **the foundation that shapes architecture, technology choices, scaling strategies, and operational practices**.\
They can be broadly divided into **Functional Requirements**, **Non-Functional Requirements (NFRs)**, and **Constraints**.

### **1. Functional Requirements**

Describe **what the system should do**—the features, interactions, and behaviors that fulfill the user’s or business’s needs.

**Important Points**

* Directly derived from business objectives and user needs.
* Define capabilities and services the system must provide.
* Drive feature scope in design and development.

**Sub-categories in System Design Context**

* **Core Business Functions** – Example: “Allow users to transfer funds between accounts.”
* **System Interactions** – Example: “API must accept payment requests from partner services.”
* **Data Handling** – Example: “Store transaction records for 7 years.”
* **Error Handling** – Example: “Display clear error messages for failed uploads.”

**Example**\
For a ride-hailing system, functional requirements may include:

* Register as a driver or rider.
* Request a ride from a specific pickup location.
* Automatically match rider with nearest driver.

### **2. Non-Functional Requirements (NFRs)**

Describe **how well** the system should perform rather than what it does.\
These often define **system qualities** that directly impact architecture.

**Why They’re Critical in System Design ?**

* A system with perfect features but poor performance, scalability, or security will fail in production.
* NFRs often **determine the architecture** more than functional requirements.

**Common Categories of NFRs**

<table data-full-width="true"><thead><tr><th width="142.26953125">NFR Type</th><th>Description</th><th>Example</th></tr></thead><tbody><tr><td><strong>Performance</strong></td><td>How fast the system responds under a given workload.</td><td>“Process checkout requests in &#x3C;500ms for 95% of cases.”</td></tr><tr><td><strong>Scalability</strong></td><td>Ability to handle growth in users, data, or transactions.</td><td>“Support 10x increase in active users without redesign.”</td></tr><tr><td><strong>Availability</strong></td><td>Percentage of uptime over a period.</td><td>“Achieve 99.99% uptime annually.”</td></tr><tr><td><strong>Reliability</strong></td><td>Ability to operate correctly over time without failures.</td><td>“No more than 1 unplanned outage per quarter.”</td></tr><tr><td><strong>Security</strong></td><td>Protection against threats, unauthorized access, and data breaches.</td><td>“Encrypt all sensitive data at rest and in transit.”</td></tr><tr><td><strong>Compliance</strong></td><td>Adherence to laws, regulations, or standards.</td><td>“Must comply with GDPR and PCI-DSS.”</td></tr><tr><td><strong>Maintainability</strong></td><td>Ease of updating and modifying the system.</td><td>“Deploy new features without downtime.”</td></tr><tr><td><strong>Usability</strong></td><td>How easily users can interact with the system.</td><td>“Onboarding process should take less than 2 minutes.”</td></tr><tr><td><strong>Observability</strong></td><td>How easily the system can be monitored and debugged.</td><td>“Provide distributed tracing for all microservices calls.”</td></tr></tbody></table>

### **3. Constraints**

Explicit limitations that the system design must work within—**boundaries that cannot be crossed**.

**Why They Matter ?**

* Constraints can drastically influence architecture decisions.
* Sometimes constraints are **non-negotiable** (e.g., legal compliance, tech stack mandates).

**Types of Constraints**

* **Technical** – Technology choices, existing infrastructure, platform restrictions.\
  Example: “Must be deployed on AWS using Kubernetes.”
* **Business** – Budget, timeline, resource limits.\
  Example: “Go-live in 3 months with existing 4-person team.”
* **Compliance** – Legal, regulatory, or industry standards.\
  Example: “Data must remain within EU data centers.”
* **Integration** – Dependencies on external systems or APIs.\
  Example: “Must integrate with legacy SAP system.”

### **Relationship Between the Three ?**

* **Functional requirements** define **what to build**.
* **Non-functional requirements** define **how it should perform**.
* **Constraints** define **the boundaries** in which we must design the solution.

{% hint style="success" %}
In System Design, the interaction between these three often determines whether an architecture is viable or doomed to fail.
{% endhint %}

## The Requirements Gathering Process

In **System Design**, gathering requirements is not a one-time activity it’s an **iterative, collaborative process** that ensures the architecture we design will actually solve the real-world problem.

#### **Step 1 – Identify and Engage Stakeholders**

**Why ?**\
Different stakeholders have different perspectives and priorities. Missing one early can lead to incomplete or conflicting requirements.

**Who to include ?**

* **Business stakeholders** – Define business goals and ROI expectations.
* **Product managers** – Represent user needs and priorities.
* **End users** – Provide real usage patterns and pain points.
* **Engineering teams** – Understand technical feasibility.
* **Ops/DevOps/SRE** – Ensure operational reliability and scalability.
* **Compliance/security** – Address regulatory and risk considerations.

**Example**\
In a payments platform, compliance teams may add PCI-DSS encryption requirements that significantly impact database and infrastructure design.

#### **Step 2 – Gather Raw Requirements**

**Why ?**\
Capturing all possible needs—before filtering—ensures nothing is overlooked.

**Techniques**

* **Interviews** – One-on-one sessions to uncover detailed needs.
* **Workshops** – Collaborative brainstorming to align vision.
* **Observation** – Watching how users interact with existing systems.
* **Surveys** – Collecting structured feedback at scale.
* **Document Analysis** – Reviewing past system docs, logs, incident reports.

**Example**\
Observing call center agents might reveal that response times must be under 2 seconds to maintain service quality—an NFR that wouldn’t appear in a generic requirements list.

#### **Step 3 – Categorize Requirements**

**Why ?**\
Organizing requirements into categories ensures clarity and reduces misinterpretation.

**Categories**

* **Functional Requirements** – What the system must do.
* **Non-Functional Requirements (NFRs)** – How well the system must perform.
* **Constraints** – Boundaries the design must respect.

**Example**\
In a streaming service:

* FR: “Allow users to download videos for offline viewing.”
* NFR: “Downloads must complete within 5 minutes for 95% of users.”
* Constraint: “Must support offline mode on both iOS and Android.”

#### **Step 4 – Prioritize Requirements**

**Why ?**\
Resources are limited—prioritization ensures the most critical needs are addressed first.

**Methods**

* **MoSCoW** – Must Have, Should Have, Could Have, Won’t Have.
* **Kano Model** – Basic, Performance, and Delight features.
* **Weighted Scoring** – Assign scores based on business value, user impact, and technical complexity.

**Example**\
In an MVP for a food delivery app:

* Must Have: Placing orders and payment processing.
* Should Have: Order tracking.
* Could Have: Loyalty points system.

#### **Step 5 – Specify in Detail**

**Why ?**\
Ambiguity leads to architecture that doesn’t match needs. Requirements should be precise, measurable, and testable.

**Tips**

* Replace vague terms like “fast” with measurable metrics.
* Document preconditions, workflows, and postconditions.
* Use **acceptance criteria** to define success.

**Example**\
Instead of: “System should be secure”\
Write: “All sensitive user data must be encrypted with AES-256 at rest and TLS 1.3 in transit, with quarterly penetration testing.”

#### **Step 6 – Validate with Stakeholders**

**Why ?**\
Validation ensures everyone agrees on the definition before design begins.

**How ?**

* Review requirement documents with all stakeholders.
* Use visual aids (use case diagrams, flowcharts) for clarity.
* Get **formal sign-off** to freeze the agreed-upon scope.

**Example**\
In a banking app, validating with compliance early prevents costly redesign later when legal regulations are missed.

#### **Step 7 – Maintain as a Living Document**

**Why ?**\
Requirements evolve as new constraints, risks, and opportunities are discovered.

**Best Practices**

* Store in a **version-controlled** repository.
* Update after major discoveries or changes in scope.
* Link each requirement to relevant design decisions and test cases.

**Example**\
If traffic projections double after a marketing campaign, update scalability NFRs to ensure the design can handle the new load.

## **Best Practices**

In **System Design**, requirements gathering is not just a business exercise it’s a **technical foundation**. The quality of our requirements directly determines the quality, scalability, and maintainability of our architecture.

#### **1. Link Every Requirement to a Business Goal**

* **Why:** Prevents building features that don’t serve the business.
* **Example:** “Add real-time chat” should link to a goal like “Increase customer engagement during support interactions.”

#### **2. Separate Functional, Non-Functional, and Constraints**

* **Why:** NFRs (like latency or uptime) and constraints often have a bigger architectural impact than features.
* **Example:** Knowing “latency must be under 200ms globally” will push us toward a CDN and geo-distributed architecture.

#### **3. Use Measurable Language**

* Avoid vague words like _fast_, _secure_, or _scalable_.
* Instead, set **quantifiable targets**.
* **Bad:** “System should handle high load.”
* **Good:** “System should support 20,000 concurrent users with <1% error rate.”

#### **4. Capture Both Current and Future Needs**

* **Why:** Designing only for today’s load or features will lead to expensive redesigns.
* **Example:** If marketing expects a 5x traffic spike in six months, plan horizontal scaling now.

#### **5. Involve Cross-Functional Teams Early**

* **Why:** Developers think differently from product managers, and both think differently from ops or compliance.
* **Example:** Compliance might require EU-only data storage, influencing database hosting choices.

#### **6. Validate with Multiple Stakeholder Reviews**

* Conduct **at least two rounds** of validation:
  * One for completeness (are we missing anything?)
  * One for accuracy (did we understand correctly?).
* Use diagrams, mockups, and sample flows to aid understanding.

#### **7. Document Acceptance Criteria for Every Requirement**

* **Why:** Ensures we can objectively confirm when a requirement is met.
* **Example:** For “Fast API responses” → “p95 latency under 300ms for 95% of requests, measured under production load.”

#### **8. Keep Requirements Solution-Agnostic Initially**

* **Why:** Jumping to solutions too soon may lock us into suboptimal tech.
* **Example:** Write “System should support global low-latency streaming” instead of “Use AWS CloudFront for streaming.”

#### **9. Store in a Version-Controlled Repository**

* **Why:** Requirements evolve—tracking changes avoids misalignment.
* Use Git or a wiki with change history.

#### **10. Treat Requirements as a Living Document**

* Revisit after:
  * Major incidents
  * Market shifts
  * New regulations
* **Example:** A new GDPR amendment may require a “right to be forgotten” feature.
