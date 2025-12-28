# Classification of Bug Patterns

## About

Bug patterns are not random mistakes; they can be systematically classified based on **how and why correctness breaks**. A strong classification helps developers reason about failures, choose appropriate prevention strategies, and understand which classes of bugs are inherently hard to detect. Rather than classifying by language or tool, the most durable classification is based on **the nature of failure in the program’s behavior**.

All programs operate across four fundamental dimensions:

1. Logic and decision-making
2. State and data evolution
3. Execution flow and time
4. Interaction with external systems

Bug patterns emerge when assumptions in one or more of these dimensions are violated. Each class of bug pattern corresponds to a **specific failure mode of reasoning**.

## Logical Bug Patterns

Logical bug patterns arise when the **intended decision logic differs from the implemented decision logic**, even though the code is syntactically correct.

These are among the most common and most dangerous bug patterns because:

* The compiler cannot detect them
* They often pass basic tests
* They look correct during reviews

Typical manifestations include:

* Incorrect boundary conditions
* Partial handling of states
* Incorrect boolean expressions
* Missing negative or exceptional cases

The defining trait of logical bug patterns is **false confidence**: the developer believes the logic is complete, but the program’s decision space is larger than anticipated.

These bugs often surface only when:

* Input ranges expand
* Business rules evolve
* Rare combinations occur

## Data and State Bug Patterns

Data-related bug patterns occur when **program state evolves in unintended ways**.

Programs are state machines, whether explicitly modeled or not. Bug patterns arise when:

* State transitions are incomplete
* Data invariants are violated
* Mutable data is shared unintentionally
* Default values are assumed instead of enforced

This class includes issues such as:

* Null or absent values
* Stale or partially updated state
* Inconsistent object graphs
* Improper lifecycle management

A critical insight: many “logic bugs” are actually **state bugs in disguise**. The logic is correct, but it operates on invalid or unexpected state.

## Control Flow and Execution Bug Patterns

Control flow bug patterns occur when **execution order diverges from the developer’s mental model**.

These bugs are common in:

* Conditional branching
* Loop constructs
* Exception handling
* Early returns and fall-through logic

The core problem is temporal reasoning: developers reason spatially about code, but programs execute temporally.

Examples of failure modes include:

* Skipped execution paths
* Unexpected early termination
* Silent exception swallowing
* Infinite or prematurely terminated loops

These bug patterns often escape detection because reading code does not easily reveal runtime paths.

## Temporal and Concurrency Bug Patterns

Temporal bug patterns emerge when correctness depends on **timing, ordering, or interleaving of operations**.

Concurrency bugs are a subset of this category, but the category itself is broader and includes:

* Order-dependent initialization
* Race conditions
* Visibility problems
* Time-based assumptions

The defining property of these bug patterns is **non-determinism**:

* The same code behaves differently across runs
* Bugs disappear during debugging
* Failures correlate with load, not logic

These bugs challenge even senior developers because they violate intuitive cause-effect reasoning.

## Resource and Lifecycle Bug Patterns

Resource bug patterns occur when **resource lifetime is misaligned with program execution**.

Resources include:

* Memory
* File handles
* Network connections
* Threads
* Transactions

Unlike objects, resources are finite and externally constrained. Bug patterns arise when:

* Acquisition and release are asymmetric
* Exceptional paths bypass cleanup
* Resources outlive their usefulness
* Cleanup relies on garbage collection semantics

These bugs may not cause immediate failure but gradually degrade system health, making them difficult to attribute to a specific code change.

## API Contract and Integration Bug Patterns

These bug patterns occur when **code violates explicit or implicit contracts of an API**.

Key sources include:

* Misunderstood method semantics
* Ignored return values
* Incorrect lifecycle assumptions
* Version compatibility changes

A common trait is misplaced trust:

* “This method always returns a value”
* “This call is idempotent”
* “This API handles retries internally”

Such assumptions work until they don’t, often breaking after upgrades or environment changes.

## Environmental and Configuration Bug Patterns

Not all bug patterns live in code. Some emerge from the **interaction between code and environment**.

These include:

* Incorrect configuration defaults
* Environment-specific behavior
* Dependency version mismatches
* Timezone and locale assumptions

These bug patterns are particularly dangerous because:

* Code reviews won’t catch them
* They vary across environments
* They often appear only in production

## Cross-Cutting Bug Patterns

Some bug patterns do not fit neatly into a single category.

Examples:

* Partial failure handling
* Retry amplification
* Inconsistent error handling
* Assumption of total system success

These patterns cut across logic, state, timing, and integration. They are common in distributed systems and cloud-native applications.
