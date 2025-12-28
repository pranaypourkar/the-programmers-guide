# Insecure Coding Practices

## About

**Insecure coding practices** are patterns in code that **weaken security guarantees** and increase the likelihood of vulnerabilities. Unlike vulnerabilities, they are **not immediately exploitable**, but they **create conditions that make exploitation easier**.

From a code-quality perspective, insecure coding practices are akin to **latent technical debt for security**.

## Why Insecure Coding Practices Matter ?

Even in well-reviewed and tested code, insecure practices:

* Violate assumptions about correctness under attack
* Amplify the impact of bugs
* Increase maintenance and review burden
* Accumulate risk silently over time

They act as **fertile ground for vulnerabilities**, especially during code evolution or integration.

## Common Forms of Insecure Coding Practices

1. **Hardcoded Secrets**
   * Credentials, keys, tokens embedded in code
   * Risk: Compromise if source is leaked or shared
2. **Weak or Misused Cryptography**
   * Using outdated algorithms or weak parameters
   * Risk: Encryption fails to protect confidentiality
3. **Over-Permissive Defaults**
   * Granting broad access or disabling validation
   * Risk: Users or modules gain unintended privileges
4. **Improper Input Handling**
   * Partial validation, blind trust of input
   * Risk: Injection, tampering, or corruption
5. **Unchecked External Calls**
   * Ignoring return values or error codes
   * Risk: Silent failures or inconsistent state
6. **Improper Logging**
   * Writing sensitive data to logs
   * Risk: Data leakage
7. **Bypassing Standard Security APIs**
   * Custom authentication or authorization logic
   * Risk: Inconsistent or flawed enforcement

## Conceptual Nature

Insecure coding practices are **behavioral weaknesses in code logic or design intent**:

* They do not always fail
* They rely on assumptions that may be violated later
* They become vulnerabilities when exposed to adversarial inputs

From a developer’s perspective:

* A bug is a mistake
* An insecure practice is a **weak decision point**
* A vulnerability is the realized risk

## Lifecycle Perspective

These practices often persist because:

* They are tolerated in early development
* They simplify coding under time pressure
* Their danger is invisible until exploitation occurs

Over time, accumulation leads to:

* High-risk hotspots
* Increased code review effort
* Greater potential for vulnerabilities

## Why Insecure Practices Are Code Quality Issues

From a code-quality lens:

* They reduce maintainability (e.g., secrets scattered across code)
* They obscure reasoning about correctness (e.g., inconsistent validation)
* They create fragile systems that break silently

High-quality code **limits insecure practices proactively**, not reactively.
