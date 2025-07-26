# Types of Anti-Patterns

## About

Anti-patterns can be classified based on **where** they appear in software development from low-level code issues to large-scale architectural problems. Understanding their types helps identify problems early and guide effective refactoring.

## 1. **Code-Level Anti-Patterns**

These anti-patterns occur in the implementation of logic and syntax. They often result from rushed development, lack of refactoring, or misunderstanding of language features.

<table><thead><tr><th width="227.81512451171875">Anti-Pattern</th><th>Description</th></tr></thead><tbody><tr><td><strong>Magic Numbers/Strings</strong></td><td>Using hardcoded values in code instead of named constants, making code difficult to understand or change.</td></tr><tr><td><strong>Copy-Paste Programming</strong></td><td>Repeating the same code across multiple places instead of reusing methods or abstractions.</td></tr><tr><td><strong>Long Methods</strong></td><td>Functions that do too much, reducing readability and reusability.</td></tr><tr><td><strong>Commented-Out Code</strong></td><td>Leaving large chunks of old code commented instead of removing it cleanly.</td></tr><tr><td><strong>Excessive Logging</strong></td><td>Filling code with unnecessary or verbose log statements, obscuring useful information.</td></tr></tbody></table>

## 2. **Design Anti-Patterns**

These are poor object-oriented design decisions that lead to tightly coupled, fragile systems and hinder extensibility.

<table><thead><tr><th width="229.1085205078125">Anti-Pattern</th><th>Description</th></tr></thead><tbody><tr><td><strong>God Object / Blob</strong></td><td>A class that knows too much or does too many things, violating the Single Responsibility Principle.</td></tr><tr><td><strong>Lava Flow</strong></td><td>Code that’s outdated or redundant but remains in the system out of fear of breaking things.</td></tr><tr><td><strong>Poltergeist</strong></td><td>Short-lived, unnecessary objects (often created just to call another object).</td></tr><tr><td><strong>Overuse of Inheritance</strong></td><td>Relying on deep inheritance hierarchies instead of favoring composition.</td></tr><tr><td><strong>Circular Dependencies</strong></td><td>Classes or modules that directly or indirectly depend on each other, making code brittle and hard to maintain.</td></tr></tbody></table>

## 3. **Architectural Anti-Patterns**

These affect the high-level structure of systems and often emerge due to poor planning or lack of clear architectural vision.

<table><thead><tr><th width="229.72052001953125">Anti-Pattern</th><th>Description</th></tr></thead><tbody><tr><td><strong>Big Ball of Mud</strong></td><td>A system with no discernible structure, where everything is interconnected and difficult to maintain.</td></tr><tr><td><strong>Golden Hammer</strong></td><td>Applying a familiar tool or pattern to every problem, regardless of its suitability.</td></tr><tr><td><strong>Stovepipe System</strong></td><td>Independent systems or modules with little to no integration or reuse.</td></tr><tr><td><strong>Reinventing the Wheel</strong></td><td>Creating custom solutions for problems already solved by mature libraries or tools.</td></tr><tr><td><strong>Vendor Lock-in</strong></td><td>Overdependence on a single vendor’s technologies, reducing flexibility and portability.</td></tr></tbody></table>

## 4. **Concurrency Anti-Patterns**

These appear in multi-threaded or asynchronous programming and can lead to serious performance or correctness issues.

<table><thead><tr><th width="230.072021484375">Anti-Pattern</th><th>Description</th></tr></thead><tbody><tr><td><strong>Busy Waiting</strong></td><td>Continuously checking a condition in a loop, wasting CPU cycles instead of using efficient wait mechanisms.</td></tr><tr><td><strong>Thread-Per-Request</strong></td><td>Spawning a new thread for every task, which does not scale well under load.</td></tr><tr><td><strong>Unsafe Publication</strong></td><td>Sharing objects between threads without proper synchronization, leading to visibility problems.</td></tr><tr><td><strong>Double-Checked Locking (Pre-Java 5)</strong></td><td>Incorrectly implemented lazy initialization in a multithreaded context.</td></tr></tbody></table>

## 5. **Project & Process Anti-Patterns**

These deal with team practices, software processes, and development workflows that undermine software quality over time.

<table><thead><tr><th width="229.98956298828125">Anti-Pattern</th><th>Description</th></tr></thead><tbody><tr><td><strong>Premature Optimization</strong></td><td>Focusing on performance improvements before correctness or clear need.</td></tr><tr><td><strong>Design by Committee</strong></td><td>Too many stakeholders making conflicting design decisions, leading to diluted outcomes.</td></tr><tr><td><strong>Cargo Cult Programming</strong></td><td>Using patterns or frameworks without understanding why or how they work.</td></tr><tr><td><strong>Over-Engineering</strong></td><td>Designing systems with unnecessary flexibility or complexity that’s never used.</td></tr><tr><td><strong>Failure to Refactor</strong></td><td>Accumulating technical debt due to fear or laziness in cleaning up messy code.</td></tr></tbody></table>
