# Security

## About

**Security**, as a quality metric, measures how well a codebase **preserves its intended behavior under adversarial conditions**. Unlike reliability, which focuses on failure under stress, security focuses on **failure under attack**.

From a code-quality perspective, security is not an add-on; it is **correctness in the presence of malicious intent**.

## Security as a Property of Correctness

Security is often treated as separate from correctness, but this is misleading.

A system is insecure because:

* It behaves correctly for honest users
* But behaves incorrectly for attackers

This means security failures are **conditional correctness failures**, triggered when assumptions about usage, input, or behavior are violated intentionally.

High-quality code makes fewer assumptions and enforces more invariants.

## Security vs Reliability in Quality Terms

Reliability asks:

* What happens when things go wrong accidentally?

Security asks:

* What happens when someone tries to make things go wrong?

The mechanisms overlap:

* Input validation
* Error handling
* Resource control
* State consistency

But the intent differs. Security assumes **hostile inputs and sequences**, not just unexpected ones.

## Sources of Security Weakness in Code

Security degradation in code often comes from:

* Implicit trust assumptions
* Over-permissive logic
* Inconsistent enforcement of checks
* Hidden side effects
* Scattered security decisions

These weaknesses are rarely obvious. They accumulate gradually and surface when systems gain exposure or value.

## Security as a Negative Space Metric

Unlike performance or coverage, security is often measured by **absence**:

* Absence of exploitable paths
* Absence of unintended information flows
* Absence of privilege escalation

This makes security difficult to prove and easy to underestimate.

From a quality lens, security improves when:

* Code paths are constrained
* Capabilities are explicit
* Behavior is predictable under misuse

## Security and Change

Security is highly sensitive to change.

Code that was secure yesterday may become insecure when:

* New features expose internal paths
* Integrations change trust boundaries
* Dependencies evolve
* Data sensitivity increases

This makes security a **dynamic quality metric**, not a static one.

High-quality systems anticipate this by:

* Centralizing security logic
* Making assumptions explicit
* Limiting blast radius of changes

## Security Debt

Just like technical debt, systems accumulate **security debt**:

* Known but unaddressed weaknesses
* Deferred fixes
* Accepted risks without documentation

Security debt compounds because:

* Attack techniques evolve
* Exposure increases
* Fixing later is harder and riskier

From a quality perspective, unmanaged security debt is a leading indicator of future incidents.
