# Cryptography Misuse

## About

**Cryptography misuse** occurs when cryptographic mechanisms are **implemented, configured, or applied incorrectly**, undermining security guarantees even though cryptography is present. In many systems, cryptography exists but **fails to protect anything meaningful** due to misuse.

From a code-quality perspective, cryptography misuse represents **false security**: code appears secure while being fundamentally weak.

## Cryptography as a Contract, Not a Feature

Cryptography is not a checkbox or a library call. It is a **contract** that must hold under adversarial conditions.

Misuse occurs when developers:

* Treat cryptography as a black box
* Focus on “using encryption” rather than “what is protected and why”
* Confuse obfuscation with security

Correctness here is binary: either the guarantees hold, or they don’t.

## Common Forms of Cryptography Misuse

**Weak or Outdated Algorithms**\
Using algorithms that are broken or no longer considered secure. The code still works, but the security assumption is invalid.

**Incorrect Modes or Parameters**\
Choosing insecure modes of operation, small key sizes, or predictable initialization vectors. The algorithm may be strong, but the configuration breaks it.

**Custom Cryptography Implementations**\
Reimplementing encryption, hashing, or key derivation logic. This almost always introduces subtle flaws.

**Improper Key Management**\
Hardcoding keys, reusing keys, or storing keys insecurely. Cryptography without proper key handling offers little protection.

**Misuse of Hashing vs Encryption**\
Using encryption where hashing is required, or vice versa. This leads to reversible secrets or unverifiable data.

## Why Cryptography Misuse Is Hard to Detect ?

* Code compiles and runs correctly
* Encrypted data “looks random”
* Failures do not surface during normal operation
* Tests validate functionality, not security guarantees

This makes cryptography misuse one of the most deceptive security problems from a quality perspective.

## Cryptography Misuse as a Quality Problem

From a code-quality lens, misuse indicates:

* Poor understanding of invariants
* Implicit security assumptions not enforced in code
* Overconfidence in libraries without understanding usage contracts

High-quality code treats cryptography as:

* Centralized
* Explicit
* Minimal
* Well-documented

Scattered cryptographic logic is a strong quality smell.

## Lifecycle Risk

Cryptography misuse often survives:

* Code reviews
* Testing
* Early production use

It becomes critical when:

* Attack models evolve
* Systems gain exposure
* Data value increases over time

Fixing cryptography misuse later is expensive and risky, especially when data has already been stored or transmitted insecurely.

## Relationship to Other Security Concepts

Cryptography misuse often compounds:

* Data protection failures
* Authentication weaknesses
* Information exposure through logs or errors

It rarely exists in isolation and frequently amplifies the impact of other bugs.
