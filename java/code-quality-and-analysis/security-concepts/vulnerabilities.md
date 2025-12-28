# Vulnerabilities

## About

A **vulnerability** is a weakness in code or design that can be **intentionally exploited** to violate security properties such as confidentiality, integrity, or availability. The defining trait is _exploitability_, not failure.

A bug becomes a vulnerability **only when an attacker can control conditions to their advantage**.

## What Makes a Vulnerability Different from a Bug ?

All vulnerabilities are bugs, but most bugs are not vulnerabilities.

A **bug**:

* Breaks correctness
* May cause crashes or wrong behavior
* Is often accidental and context-limited

A **vulnerability**:

* Enables attacker-controlled misuse
* Operates under adversarial intent
* Has security impact even if functionality appears correct

This distinction is critical. A system can be functionally correct and still insecure.

## Security Properties Violated by Vulnerabilities

Vulnerabilities exist because code fails to preserve one or more core security properties.

#### Confidentiality

Data intended to be private becomes observable. This often happens through:

* Improper access checks
* Overexposed responses
* Logging sensitive information

#### Integrity

Data or behavior can be altered without authorization. This includes:

* Tampering with inputs
* Manipulating state transitions
* Bypassing validation

#### Availability

Systems become unavailable or degraded through:

* Resource exhaustion
* Infinite loops triggered externally
* Amplified retries or expensive operations

A single vulnerability can violate multiple properties simultaneously.

## Exploitability as the Core Criterion

Exploitability is what elevates a weakness into a vulnerability.

A vulnerability exists when:

* An attacker can influence inputs, state, or timing
* The system responds in a predictable, controllable way
* The outcome benefits the attacker

This means:

* Internal bugs with no external control are usually not vulnerabilities
* The same code can be a vulnerability in one deployment and harmless in another

Security is contextual.

## Trust Assumptions and Attack Surface

Vulnerabilities arise where **trust boundaries are crossed incorrectly**.

Common incorrect assumptions:

* Input is trusted because it comes from an internal system
* Users will follow intended flows
* APIs are called only in expected sequences

Every trust assumption expands the attack surface. Vulnerabilities are often invisible until an attacker violates an assumption developers did not realize they were making.

## Why Vulnerabilities Are Hard to Reason About ?

Developers reason in terms of:

* Valid use cases
* Expected behavior
* Cooperative users

Attackers reason in terms of:

* Edge cases
* Invalid sequences
* Abuse of guarantees

This asymmetry explains why vulnerabilities persist even in well-reviewed, well-tested code.

## Vulnerabilities Without Crashes or Errors

Some of the most severe vulnerabilities:

* Do not crash systems
* Do not log errors
* Do not fail tests

They operate silently by:

* Returning more data than intended
* Accepting actions without proper checks
* Preserving system stability while violating policy

Security failures often look like successful executions.

## Vulnerabilities and Code Quality

From a code quality perspective, vulnerabilities indicate:

* Missing invariants
* Weak enforcement of contracts
* Over-permissive logic
* Poor separation of responsibility

High-quality code is not just readable and maintainable; it **actively constrains misuse**.

Security quality is a subset of correctness under adversarial conditions.

## Lifecycle of a Vulnerability

Vulnerabilities often:

* Originate during design
* Are implemented during development
* Are discovered long after deployment
* Are exploited before detection

This delayed lifecycle makes prevention far more valuable than detection.

## Why Vulnerabilities Deserve Separate Treatment

Unlike general bugs:

* Vulnerabilities can be weaponized
* Impact is not limited to users
* Disclosure timing matters
* Fixes may require coordinated response

This is why vulnerabilities are treated with higher urgency and stricter prioritization in code analysis.
