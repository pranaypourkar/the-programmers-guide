# Cohesion

## About

**Cohesion** refers to how closely related and focused the responsibilities of a single module, class, or component are. A **highly cohesive** module performs one well‑defined task or closely related set of tasks, while a **low‑cohesion** module handles many unrelated responsibilities.

* High cohesion improves clarity, maintainability, and reusability because each module has a clear purpose.
* Low cohesion, on the other hand, leads to "god classes" or overly complex modules that are harder to understand and modify.

In software design, the goal is to achieve **high cohesion** (strong internal focus) along with **low coupling** (minimal external dependency).\
These two metrics complement each other in creating a well‑structured, maintainable system.

## Types of Cohesion

Cohesion is typically classified from **worst (lowest)** to **best (highest)**:

1. **Coincidental Cohesion** _(Worst)_
   * Unrelated tasks are grouped in the same module.
   * Example: A utility class that contains random methods like file parsing, database queries, and logging.
   * **Problem:** No logical connection; makes maintenance harder.
2. **Logical Cohesion**
   * Functions that are related by a broad category but not by a specific task.
   * Example: A module handling all types of input (keyboard, file, network) in one place.
   * **Problem:** Still too general; often requires conditional logic to handle different cases.
3. **Temporal Cohesion**
   * Elements are related by the time they are executed.
   * Example: An initialization module that sets up unrelated resources at startup.
   * **Problem:** The tasks are only related by execution timing, not functionality.
4. **Procedural Cohesion**
   * Functions are related by the sequence of execution.
   * Example: A module that processes an order by first validating, then saving, then sending notifications—all in one method.
   * **Problem:** May still mix unrelated tasks even if they are executed together.
5. **Communicational Cohesion**
   * Functions operate on the same data or contribute to the same output.
   * Example: A report generation module that formats and outputs a given dataset.
   * **Better:** The tasks share the same data context.
6. **Sequential Cohesion**
   * Output from one part of the module becomes input for another part.
   * Example: A data processing pipeline where one function cleans the data and another analyzes it.
   * **Better:** There’s a direct functional link between steps.
7. **Functional Cohesion** _(Best)_
   * Every element in the module contributes to a single, well‑defined task.
   * Example: A `PaymentProcessor` class that handles only payment processing and nothing else.
   * **Best:** Easy to maintain, test, and reuse.

## Measuring Cohesion

Cohesion can be evaluated both **qualitatively** and **quantitatively**.

#### **1. Qualitative Indicators**

Signs of high or low cohesion can be observed during code reviews:

* **High Cohesion:**
  * Each module/class has a clear, single responsibility.
  * Methods in the module operate on the same set of data.
  * Minimal unrelated logic is present.
* **Low Cohesion:**
  * The module contains methods dealing with unrelated tasks.
  * Changes in one responsibility often require touching unrelated parts of the module.
  * Conditional logic exists to handle unrelated scenarios.

#### **2. Quantitative Metrics**

Several metrics attempt to measure cohesion numerically:

* **LCOM (Lack of Cohesion of Methods)**
  * A high LCOM value indicates low cohesion.
  * Various formulas exist, but the core idea is to measure how often methods share common attributes.
* **TCC (Tight Class Cohesion)** and **LCC (Loose Class Cohesion)**
  * TCC measures the percentage of method pairs directly connected through shared attributes.
  * LCC extends this to indirect connections.
* **SRP (Single Responsibility Principle) Adherence**
  * While qualitative in nature, checking adherence to SRP indirectly measures cohesion.

## Impact of Low Cohesion

Low cohesion means that a module handles too many unrelated responsibilities. This creates several long‑term problems:

1. **Poor Maintainability**
   * Changes to one responsibility often risk breaking unrelated functionality in the same module.
   * Developers must understand more unrelated code before making changes.
2. **Reduced Readability**
   * The module’s purpose becomes unclear, making it harder for new team members to understand its role.
3. **Harder Testing**
   * Unit tests become complicated because they must cover multiple, unrelated behaviors in one module.
4. **Increased Risk of Bugs**
   * Unrelated code sharing the same module may unintentionally interfere with each other’s behavior.
5. **Limited Reusability**
   * Modules with mixed responsibilities are harder to reuse in other contexts without bringing in unrelated logic.
6. **Slower Development**
   * Multiple developers working on unrelated parts of the same module may cause merge conflicts and delays.

**In short:** Low cohesion turns a module into a “dumping ground” for unrelated logic, making the system brittle, harder to extend, and more expensive to maintain.

## Benefits of High Cohesion

High cohesion is a strong indicator of good design quality. It provides several advantages:

1. **Clear Purpose**
   * Each module has a single, well‑defined responsibility, making its role easy to understand.
2. **Improved Maintainability**
   * Changes are localized, reducing the chance of introducing unintended side effects.
3. **Better Reusability**
   * Highly cohesive modules can be reused in different systems without pulling in unrelated logic.
4. **Simpler Testing**
   * Unit tests are easier to write and maintain because they target one specific behavior.
5. **Parallel Development**
   * Teams can work on different cohesive modules with minimal interference.
6. **Higher Quality Architecture**
   * High cohesion complements low coupling, resulting in a system that is both modular and adaptable.

## Strategies to Reduce Cohesion

If a module has low cohesion, we can apply the following strategies to improve it:

1. **Apply the Single Responsibility Principle (SRP)**
   * Ensure each module has only one reason to change.
2. **Refactor Large Modules**
   * Break down “god classes” or bloated services into smaller, focused units.
3. **Group Related Behavior and Data**
   * Keep functions and variables that operate on the same data within the same module.
4. **Avoid Mixing Unrelated Logic**
   * Separate different concerns (e.g., data access, business logic, presentation) into distinct layers.
5. **Use Clear Naming**
   * A module’s name should clearly reflect its purpose; rename or split it if the name becomes too broad.
6. **Introduce Domain‑Driven Design (DDD) Boundaries**
   * Align modules with well‑defined business domains or subdomains.
7. **Remove Dead or Unused Code**
   * Old, unused functionality reduces cohesion by adding unrelated responsibilities.

