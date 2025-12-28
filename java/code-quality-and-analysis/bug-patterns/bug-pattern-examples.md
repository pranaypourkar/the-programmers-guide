# Bug Pattern Examples

## About

Examples are critical because bug patterns are best understood through **behavioral failure**, not definitions. Each example below represents a _class of bugs_, not a single mistake. The goal is to recognize the shape of the problem so it can be identified even when the code looks different.

## Boundary and Edge Condition Bugs

These bug patterns occur when logic correctly handles the “normal” case but fails at the edges of the input space.

Typical causes:

* Incorrect comparison operators
* Missing inclusive or exclusive bounds
* Assumptions about minimum or maximum values

Why they are dangerous:

* They often pass most tests
* They trigger only for specific values
* They are commonly discovered by users, not developers

Conceptual failure:\
The developer reasons about _typical values_, while the program must handle _all valid values_.

## Partial State Handling Bugs

These arise when a system supports multiple states, but logic is written assuming only a subset.

Examples include:

* Handling success and failure but not partial success
* Updating one part of state without updating dependent state
* Assuming objects are fully initialized when they are not

Why they persist:

* State transitions are implicit
* State invariants are undocumented
* Code appears correct in isolation

Conceptual failure:\
The system is a state machine, but it is not treated as one.

## Temporal Order Bugs

These bug patterns depend on the order of execution rather than the logic itself.

Typical scenarios:

* Initialization order dependencies
* Cleanup occurring too early or too late
* Operations that must be sequential but are assumed to be independent

Why they are hard:

* Code reading does not reveal execution order clearly
* Bugs appear only under certain timing conditions

Conceptual failure:\
The developer assumes order does not matter when it does.

## Concurrency and Interleaving Bugs

These bugs occur when multiple execution paths interact in unintended ways.

Common manifestations:

* Race conditions
* Lost updates
* Visibility issues
* Deadlocks

Why they escape detection:

* They are non-deterministic
* They may disappear during debugging
* They depend on load and timing

Conceptual failure:\
Reasoning is sequential, but execution is concurrent.

## Resource Lifecycle Bugs

These occur when resource management is incomplete or asymmetric.

Examples:

* Acquiring a resource without guaranteed release
* Cleanup skipped during exceptional flows
* Resources tied to object lifetime incorrectly

Why they surface late:

* Systems work initially
* Degradation is gradual
* Failures appear far from the root cause

Conceptual failure:\
Confusing memory management with resource management.

## API Contract Violation Bugs

These bug patterns arise when code violates explicit or implicit API contracts.

Examples:

* Ignoring return values
* Misinterpreting error semantics
* Assuming backward compatibility
* Treating remote calls as local

Why they are common:

* Contracts are poorly documented
* Examples are misleading
* APIs evolve over time

Conceptual failure:\
Trusting behavior instead of validating contracts.

## Silent Failure Bugs

These occur when failures are swallowed, ignored, or logged but not acted upon.

Typical cases:

* Empty catch blocks
* Logging without propagation
* Default fallbacks masking errors

Why they are severe:

* Systems appear stable
* Data may be corrupted silently
* Debugging becomes extremely difficult

Conceptual failure:\
Optimizing for stability over correctness.

## Assumption-Based Bugs

These bugs arise from beliefs about the system that are not enforced.

Examples:

* “This will never be null”
* “This service always responds”
* “This configuration will never change”

Why they persist:

* Assumptions hold true initially
* Violations are rare
* Failures are blamed on “unexpected scenarios”

Conceptual failure:\
Confusing probability with impossibility.

## Partial Failure Handling Bugs

These bugs occur when systems assume all-or-nothing behavior.

Examples:

* Retrying without idempotency
* Ignoring partial success responses
* Inconsistent rollback behavior

Why they dominate distributed systems:

* Partial failure is the norm, not the exception
* Network and service failures are inevitable

Conceptual failure:\
Modeling distributed systems like single-process programs.
