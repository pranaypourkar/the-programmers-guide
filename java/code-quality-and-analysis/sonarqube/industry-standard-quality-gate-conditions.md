# Industry-Standard Quality Gate Conditions

## About

Quality Gates are not about perfection, they are about **risk containment**. Mature organizations use **different gate strategies depending on system age**, because risk profiles are fundamentally different.

There is no single “best” gate. There are **appropriate gates for different lifecycle stages.**

## Case 1: New Service

A **new service** has no legacy burden. This is the one situation where SonarQube can and should be **strict**, because every line of code is written with modern standards and full awareness.

The goal of the Quality Gate for a new service is:

* Prevent correctness and security defects from day one
* Establish quality discipline early
* Avoid accumulating technical debt before the first release
* Make quality expectations explicit and non-negotiable

This is **not about perfection**, but about **zero tolerance for high-risk issues**.

### Guiding Principles for New Services

Before defining conditions, it’s important to understand the philosophy:

* All issues are on _New Code_ by definition
* There is no justification for legacy exceptions
* Developers can still refactor freely because codebase size is small
* Early discipline is exponentially cheaper than later cleanup

For new services, **Quality Gates define the engineering bar**.

### Core Quality Gate Conditions (Industry Standard)

Below is a **commonly adopted, industry-proven Quality Gate** for new services using SonarQube.

<table data-full-width="true"><thead><tr><th width="151.5078125">Category</th><th width="262.0625">Metric</th><th width="106.27734375">Condition</th><th width="124.51171875">Typical Value</th><th>Why This Is Used</th></tr></thead><tbody><tr><td>Reliability</td><td>Reliability Rating (New Code)</td><td>Must be</td><td>A</td><td>Ensures zero Bugs on new code</td></tr><tr><td>Reliability</td><td>Bugs (New Code)</td><td>Must be</td><td>0</td><td>Any bug indicates incorrect behavior</td></tr><tr><td>Security</td><td>Security Rating (New Code)</td><td>Must be</td><td>A</td><td>No exploitable vulnerabilities allowed</td></tr><tr><td>Security</td><td>Vulnerabilities (New Code)</td><td>Must be</td><td>0</td><td>Even one vulnerability is unacceptable</td></tr><tr><td>Security</td><td>Security Hotspots Reviewed</td><td>Must be</td><td>100%</td><td>All security-sensitive code must be reviewed</td></tr><tr><td>Maintainability</td><td>Maintainability Rating (New Code)</td><td>Must be</td><td>A</td><td>Prevents early technical debt</td></tr><tr><td>Maintainability</td><td>Technical Debt Ratio (New Code)</td><td>Must be</td><td>≤ 5%</td><td>Keeps change cost low</td></tr><tr><td>Coverage</td><td>Coverage (New Code)</td><td>Must be</td><td>≥ 80%</td><td>Ensures test discipline without being extreme</td></tr><tr><td>Duplications</td><td>Duplicated Lines (New Code)</td><td>Must be</td><td>≤ 3%</td><td>Prevents copy-paste design</td></tr></tbody></table>

### Why These Values Work in Practice ?

#### Reliability: Zero Tolerance

For new services:

* There is no reason to accept Bugs
* Fixing bugs early is trivial
* Allowing even one sets a dangerous precedent

This is why:

* Reliability Rating = A
* Bugs = 0

#### Security: Strict by Design

Security issues are **never cheaper later**.

Best practice:

* Zero vulnerabilities
* Mandatory review of all security hotspots

Hotspots are not blocked automatically, but **unreviewed hotspots represent unknown risk**, which is unacceptable in greenfield code.

#### Maintainability: Prevent Debt from Day One

New codebases should not accumulate debt immediately.

Why allow _some_ maintainability issues?

* Minor smells are inevitable
* Over-strict gates cause frustration

Why still require Rating A?

* SonarQube’s rating A already allows small, low-impact smells
* It blocks structural degradation, not stylistic issues

#### Coverage: Realistic, Not Dogmatic

80% coverage is widely used because:

* It enforces test writing
* It avoids brittle, test-for-the-sake-of-tests behavior
* It allows flexibility for infrastructure and edge cases

Higher values (90–95%) are rarely worth the tradeoff early.

#### Duplication: Early Architectural Signal

Duplication is a **design smell**, not just a style issue.

Low tolerance early:

* Encourages proper abstractions
* Prevents future refactoring pain
* Is easy to fix when the codebase is small

### What This Gate Does _Not_ Enforce

Intentionally excluded conditions:

* Total number of code smells
* Total technical debt
* Legacy metrics (irrelevant for new services)
* File or class size limits

These are **profile and review concerns**, not gate concerns.

### How This Gate Shapes Team Behavior

A well-configured new-service gate:

* Encourages fixing issues immediately
* Reduces arguments in code reviews
* Sets a clear “definition of done”
* Makes CI failures meaningful, not noisy

Developers quickly learn:

> “If it fails the gate, it genuinely matters.”

### Common Mistakes with New Service Gates

* Requiring 100% coverage
* Blocking builds on all code smells
* Mixing stylistic rules into gates
* Applying legacy-service gates to new projects

These mistakes usually result in bypassing SonarQube entirely.

### When to Relax These Conditions

Only consider relaxing when:

* The service grows significantly
* Integration complexity increases
* Certain modules are intentionally excluded

Even then, relax **gradually**, never all at once.

## Industry-Standard Quality Gate Conditions

### Case 2: Legacy Service Upgrade (Brownfield Project)

A **legacy service** already carries historical design decisions, accumulated technical debt, and constraints that cannot be removed immediately. Applying strict, greenfield-style Quality Gates to such systems is one of the fastest ways to make SonarQube fail culturally.

The goal for a legacy service is **containment and improvement**, not correction of history.

### Core Philosophy for Legacy Services

Before defining conditions, the mindset must change:

* Legacy issues are known, accepted risk
* Immediate cleanup is unrealistic and unsafe
* Quality Gates must **protect the future**, not punish the past
* SonarQube should enable gradual improvement without blocking delivery

For legacy systems, **New Code is the contract**.

### Absolute Rule: New Code Only

For legacy services:

* **All Quality Gate conditions must be scoped to New Code**
* Overall Code metrics must never block builds

Blocking delivery due to legacy findings:

* Encourages bypassing SonarQube
* Leads to blanket “Won’t Fix” usage
* Destroys trust in quality metrics

This is non-negotiable in real-world systems.

### Core Quality Gate Conditions (Industry Standard – Legacy Upgrade)

The following gate is widely used in enterprises modernizing existing services.

<table data-full-width="true"><thead><tr><th width="162.86328125">Category</th><th>Metric</th><th width="139.9375">Condition</th><th width="112.7578125">Typical Value</th><th>Why This Is Used</th></tr></thead><tbody><tr><td>Reliability</td><td>Reliability Rating (New Code)</td><td>Must be</td><td>A</td><td>Prevents introducing new bugs</td></tr><tr><td>Reliability</td><td>Bugs (New Code)</td><td>Must be</td><td>0</td><td>No new correctness regressions</td></tr><tr><td>Security</td><td>Security Rating (New Code)</td><td>Must be</td><td>A</td><td>No new exploitable risk</td></tr><tr><td>Security</td><td>Vulnerabilities (New Code)</td><td>Must be</td><td>0</td><td>Zero tolerance on new security issues</td></tr><tr><td>Security</td><td>Security Hotspots Reviewed (New Code)</td><td>Must be</td><td>100%</td><td>No unreviewed sensitive code</td></tr><tr><td>Maintainability</td><td>Maintainability Rating (New Code)</td><td>Must be</td><td>A</td><td>Avoid adding new technical debt</td></tr><tr><td>Maintainability</td><td>Technical Debt Ratio (New Code)</td><td>Must be</td><td>≤ 5%</td><td>Keeps change cost controlled</td></tr><tr><td>Coverage</td><td>Coverage (New Code)</td><td>Must be</td><td>≥ 80%</td><td>Pragmatic test discipline</td></tr><tr><td>Duplications</td><td>Duplicated Lines (New Code)</td><td>Must be</td><td>≤ 3%</td><td>Prevents compounding design decay</td></tr></tbody></table>

### Why These Values Are Different from New Services ?

#### Coverage

Legacy systems often suffer from:

* Poor testability
* Tight coupling
* Missing seams for unit testing

80%:

* Enforces testing
* Avoids blocking necessary refactoring
* Encourages incremental improvement

Over time, this can be raised module by module.

{% hint style="info" %}
Coverage (New Code) measures:

* Only lines added or changed after the New Code reference point
* Only those lines must be covered by tests
* Existing untested legacy code is ignored by the gate
{% endhint %}

#### Duplication Tolerance

Some duplication may already exist and be unavoidable initially.

Allowing slightly higher duplication:

* Avoids artificial abstractions
* Prevents rushed refactors
* Encourages deliberate design improvements

#### Maintainability Still Requires Rating A

This is intentional.

Maintainability rating A on New Code means:

* SonarQube allows small, low-impact smells
* But blocks structural degradation

This protects future velocity without demanding perfection.

### What This Gate Explicitly Does NOT Enforce

For legacy services, never gate on:

* Total bugs
* Total vulnerabilities
* Total code smells
* Overall technical debt
* Overall coverage

These metrics are **diagnostic**, not **blocking**.

### How This Gate Changes Team Behavior

A well-configured legacy gate:

* Stops new problems from entering
* Makes refactoring safer
* Encourages gradual cleanup
* Avoids developer frustration

Developers learn:

> “I’m not responsible for the past, but I am responsible for what I touch.”

This mindset is critical for modernization success.

### Handling Existing Critical Issues

Existing critical issues should be handled via:

* Backlog items
* Targeted refactoring stories
* Risk acceptance documentation

They should **not** be forced through Quality Gates.

### Gradual Tightening Strategy

A mature approach:

1. Enforce zero new Bugs and Vulnerabilities
2. Enforce Maintainability rating A on New Code
3. Improve coverage thresholds gradually
4. Introduce module-level improvement goals
5. Track trends, not totals

This allows SonarQube to become a **partner in modernization**, not an obstacle.

### Common Anti-Patterns in Legacy Upgrades

* Applying greenfield gates to legacy systems
* Blocking builds on overall metrics
* Forcing mass “Won’t Fix” resolutions
* Using SonarQube as a cleanup mandate

These approaches almost always fail.

## Overall Code Conditions in SonarQube

In **SonarQube**, there is a deliberate and fundamental distinction between:

* **Overall Code metrics** → diagnostic, historical, informational
* **New Code metrics** → contractual, enforceable, forward-looking

Quality Gates are designed to enforce **contracts**, not to judge history.

{% hint style="success" %}
* Quality Gates must only evaluate New Code metrics.
* Overall Code metrics must never be used as blocking conditions, regardless of whether the service is new or legacy.
* Overall Code metrics are intended for diagnostic, trend analysis, and planning purposes only.
{% endhint %}

### Why Overall Code Exists at All ?

Overall Code metrics exist to answer questions like:

* How much technical debt do we have?
* Is the system improving or degrading over time?
* Where are the risk hotspots?
* Which modules are most problematic?

They are **management and planning tools**, not release blockers.

Using Overall Code metrics as gate conditions confuses **visibility** with **enforcement**.

### Why Overall Code Should NOT Block Builds ?

#### 1. Overall Code Is Historical State

Overall Code includes:

* Code written years ago
* Code written under different standards
* Code owned by different teams
* Code that may not even be touched anymore

Blocking delivery because of historical state creates:

* Developer frustration
* Mass “Won’t Fix” marking
* SonarQube bypassing
* Loss of trust in quality metrics

This happens even in well-run organizations.

#### 2. Overall Metrics Do Not Represent Change Risk

Quality Gates exist to answer:

> “Is this change safe to ship?”

Overall Code answers:

> “How healthy is the system in general?”

These are **different questions**.

A change that adds:

* 0 bugs
* 0 vulnerabilities
* Well-tested code

is safe to ship **even if the overall system is imperfect**.

#### 3. Overall Code Conditions Scale Poorly

As systems grow:

* Issue counts grow
* Debt grows
* Metrics fluctuate due to refactoring and churn

This leads to:

* Unstable gate results
* False failures unrelated to the change
* Teams optimizing for metrics instead of quality

This is why mature teams decouple gates from overall metrics.

### Industry Consensus (What Actually Works)

#### For New Services

Even for new services:

* Overall Code == New Code only at the start
* But this changes as soon as:
  * Files are refactored
  * Tests evolve
  * Code is reorganized

Best practice:

* **Do not gate on Overall Code**
* Gate only on New Code
* Track Overall Code trends instead

This avoids future rework of gates as the system evolves.

#### For Legacy Services

For legacy services, this is non-negotiable:

* **Never gate on Overall Code**
* Only gate on New Code

Blocking builds on Overall Code in legacy systems:

* Makes modernization impossible
* Turns SonarQube into an obstacle
* Encourages tool circumvention

Every successful modernization program follows this rule.

### What To Do Instead of Gating on Overall Code ?

Skipping Overall Code in gates does **not** mean ignoring it.

Use Overall Code for:

#### 1. Trend Tracking

* Is technical debt increasing or decreasing?
* Are ratings improving over quarters?
* Are hotspots being reviewed?

#### 2. Risk-Based Planning

* Identify modules with highest debt
* Prioritize refactoring work
* Justify investment in quality improvements

#### 3. Governance and Reporting

* Engineering health dashboards
* Audit and compliance visibility
* Architecture review inputs

This is where Overall Code shines.

### The One Narrow Exception

Some very mature organizations introduce **non-blocking alerts** based on Overall Code, such as:

* Reporting if overall Security rating drops
* Flagging sudden debt spikes

Key point:

* These are **alerts**, not **gates**
* They do not fail builds
* They trigger investigation, not stoppage

This is optional and advanced.
