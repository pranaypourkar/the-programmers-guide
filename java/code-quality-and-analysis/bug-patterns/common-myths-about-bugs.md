# Common Myths About Bugs

## About

Many bug patterns persist not because they are difficult to fix, but because they are **protected by widely believed myths**. These myths distort how teams reason about correctness, testing, and risk. Mature engineering requires unlearning them.

## Myth: If the Code Compiles, It Is Correct

Compilation only guarantees syntactic validity, not semantic correctness.

Most serious bug patterns:

* Compile cleanly
* Follow language rules
* Use valid APIs

Compilers do not validate business logic, invariants, or assumptions. Treating compilation success as correctness creates a false baseline that allows bug patterns to persist undetected.

## Myth: Unit Tests Catch Most Bugs

Unit tests validate expected behavior under known conditions. Bug patterns often manifest:

* Under unexpected inputs
* During partial failures
* At scale
* Over time

Tests tend to encode the same assumptions as the code they test. This creates confirmation rather than validation. High coverage does not imply low risk.

## Myth: Bugs Are Caused by Inexperienced Developers

Bug patterns are not a skill problem; they are a complexity problem.

Senior developers introduce:

* Assumption-driven bugs
* Optimization-related bugs
* Abstraction-leakage bugs

Experience reduces trivial mistakes but increases exposure to complex bug patterns. Expertise changes the shape of bugs, not their existence.

## Myth: Bugs Are Isolated Mistakes

Many bugs are symptoms of systemic issues.

Examples:

* Repeated null checks indicate missing invariants
* Frequent retries indicate missing idempotency
* Widespread error handling indicates unclear failure models

Treating bugs as isolated incidents prevents addressing their root causes.

## Myth: Production Bugs Are Rare Edge Cases

Production bugs are not rare; they are **underrepresented during development**.

Reasons include:

* Limited test environments
* Unrealistic load
* Simplified data
* Controlled execution order

Production exposes the full state space. What looks like an edge case is often a common case at scale.

## Myth: Static Analysis Tools Find All Important Bugs

Tools identify patterns they are designed to detect.

They cannot:

* Understand intent
* Validate business rules
* Detect emergent behavior

Overreliance on tools leads to blind spots where undetectable bug patterns accumulate.

## Myth: Garbage Collection Prevents Resource Bugs

Garbage collection manages memory, not resources.

Bug patterns involving:

* File handles
* Network connections
* Threads
* Transactions

Remain fully possible and often invisible until systems degrade under load.

## Myth: Fixing the Bug Fixes the Problem

Fixing a bug instance does not eliminate the bug pattern.

Without addressing:

* Underlying assumptions
* Design constraints
* Repeated logic shapes

The same bug will reappear elsewhere, often in a different form.

## Myth: More Code Reviews Automatically Reduce Bugs

Reviews help only when reviewers understand bug patterns.

Without shared mental models:

* Reviews focus on style
* Logic errors go unnoticed
* Confidence increases without correctness

Quality reviews are pattern-aware, not checklist-driven.

## Myth: Bugs Are Mostly Found Early

Many of the most severe bug patterns are found late because:

* They require specific conditions
* They emerge over time
* They depend on scale and usage

Late discovery does not imply late introduction.
