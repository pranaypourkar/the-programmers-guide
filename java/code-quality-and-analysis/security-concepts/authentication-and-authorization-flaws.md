# Authentication & Authorization Flaws

## About

**Authentication** verifies **who** is interacting with the system.\
**Authorization** determines **what that entity is allowed to do**.

Flaws in either compromise core security, often without producing immediate functional errors, making them subtle yet critical from a code-quality perspective.

## Authentication Flaws

Authentication flaws occur when the system **fails to correctly verify identity**.

Common root causes in code:

* Weak or predictable password handling
* Insecure token or session management
* Bypassing authentication checks in certain paths
* Poor multi-factor implementation
* Hardcoded credentials or secrets

Consequences:

* Unauthorized access
* Identity impersonation
* Elevated privileges when combined with other weaknesses

Conceptual insight: authentication flaws are **latent correctness violations**, where the code accepts entities it should not trust.

## Authorization Flaws

Authorization flaws occur when **permissions are misapplied**, even after identity is verified.

Typical patterns:

* Missing checks on sensitive operations
* Over-permissive default roles or access levels
* Inconsistent enforcement across APIs or modules
* Hardcoded logic that does not scale with roles

Consequences:

* Privilege escalation
* Data leakage
* Critical action exposure (e.g., modifying system state without permission)

Conceptual insight: authorization flaws reflect **assumption gaps** in how code enforces invariants across entities.

## Why They Are Hard to Detect ?

* Code may appear logically correct
* Flaws depend on **combinatorial context** (user, role, state, resource)
* Many checks are implicit, relying on developer discipline
* Automated analysis tools often underreport them unless patterns are clear

## Connection to Code Quality

From a code-quality lens:

* Authentication/authorization logic must be **centralized, explicit, and testable**
* Scattered or duplicated checks increase risk of inconsistencies
* Clear invariants and defensive programming reduce latent flaws

High-quality code integrates **security constraints into core logic**, not as an afterthought.
