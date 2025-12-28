# Injection & Interpretation Risks

## About

**Injection risks** occur when untrusted input is **interpreted or executed as code or commands**, often leading to **arbitrary behavior**. From a code-quality perspective, these are **structural weaknesses in how code handles input and executes logic**, not just runtime bugs.

Injection arises when:

* Code constructs executable statements (SQL, OS commands, XPath, expressions) dynamically
* Input is concatenated, interpolated, or otherwise embedded
* Input validation or encoding is missing or incomplete

Even if the system functions correctly under expected input, **malicious input can change program behavior**, violating integrity, confidentiality, or availability.

## Common Injection Types

1. **SQL Injection**
   * Unsanitized user input in database queries
   * Risk: data leakage, unauthorized modification
2. **Command Injection**
   * Input passed to system commands or scripts
   * Risk: full system compromise
3. **XPath / Expression Injection**
   * Input used in XML queries, scripting, or template engines
   * Risk: bypassing access control or data exposure
4. **Deserialization / Object Injection**
   * Arbitrary input deserialized into objects
   * Risk: code execution or state manipulation
5. **Template Injection**
   * Input rendered in dynamic templates
   * Risk: execution of arbitrary code in templates or views

## Why Injection Is a Code-Quality Issue ?

Injection risks are **structural mistakes in code logic**:

* Mixing data and instructions violates separation of concerns
* Defensive assumptions about inputs are implicit, not enforced
* Code readability and maintainability suffer when input handling is ad-hoc

High-quality code enforces **clear boundaries between input data and execution logic**.

## Prevention Principles

1. **Use Safe APIs / Parameterization**
   * e.g., prepared statements for SQL
   * avoids direct concatenation
2. **Validate and Encode Input**
   * Ensure input conforms to expected type, format, and context
   * Encode input before interpreting it
3. **Minimal Privilege Execution**
   * Limit the effect of any injected input
   * Reduce blast radius
4. **Centralize Handling of External Input**
   * Easier to audit, maintain, and test

## Conceptual Insight

Injection risks illustrate a **latent disconnect between code assumptions and reality**:

* Code assumes input is safe, but input can be adversarial
* Even “working” code may silently allow dangerous behaviors
* Prevention requires **structural discipline**, not just runtime checks

