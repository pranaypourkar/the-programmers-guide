# Cyclomatic Complexity

## About

**Cyclomatic Complexity (CC)** is a quantitative metric that measures the number of **independent execution paths** through a program’s source code.\
It was introduced by Thomas J. McCabe in 1976 as a way to assess the complexity of a program’s control flow.

The higher the cyclomatic complexity, the more potential paths exist, which usually means:

* The code is harder to understand.
* More test cases are needed to achieve full branch coverage.
* The risk of defects increases.

Cyclomatic Complexity is particularly useful in **unit testing, refactoring decisions, and maintainability assessments**.\
It is language‑agnostic and can be applied to any procedural or object‑oriented code.

{% hint style="success" %}
High cyclomatic complexity is a signal to simplify our logic, break down large functions, or restructure control flow for better maintainability.
{% endhint %}

## **How to Calculate Cyclomatic Complexity ?**

The general formula is:

`M = E – N + 2P`

Where:

* **M** = Cyclomatic Complexity
* **E** = Number of edges in the control flow graph
* **N** = Number of nodes in the control flow graph
* **P** = Number of connected components (typically 1 for a single function/module)

**Simplified approach in practice:**\
Count:

* **1** for the default path
* **+1** for each decision point (if, else-if, case, for, while, catch, etc.)

**Example:**

```java
int findMax(int a, int b, int c) {
    if (a > b && a > c)      // +1
        return a;
    else if (b > c)          // +1
        return b;
    else                     // no new branch
        return c;
}
```

* Base path = 1
* First `if` = +1
* `else if` = +1
* **Cyclomatic Complexity = 3**

## **Interpretation & Acceptable Ranges**

Cyclomatic Complexity values can be interpreted as follows:

<table data-header-hidden><thead><tr><th width="108.97265625"></th><th width="307.0546875"></th><th></th></tr></thead><tbody><tr><td><strong>CC Value</strong></td><td><strong>Interpretation</strong></td><td><strong>Recommended Action</strong></td></tr><tr><td>1–10</td><td>Simple, easy to understand and test.</td><td>No action needed.</td></tr><tr><td>11–20</td><td>Moderate complexity.</td><td>Refactor if possible to simplify.</td></tr><tr><td>21–50</td><td>High complexity.</td><td>Strongly consider refactoring; test coverage must be thorough.</td></tr><tr><td>>50</td><td>Very high complexity.</td><td>Code is extremely difficult to maintain or test; redesign is recommended.</td></tr></tbody></table>

**Note:** While thresholds may vary by team or project, most static analysis tools (like SonarQube) raise warnings when CC exceeds 10–15 for a method.

## **Impact of High Cyclomatic Complexity**

When cyclomatic complexity is too high, the following issues often arise:

1. **Reduced Readability**
   * Developers struggle to understand all possible paths and conditions.
2. **Increased Testing Effort**
   * More independent paths mean more test cases are needed for full coverage.
3. **Higher Risk of Bugs**
   * Complex branching increases the likelihood of missing edge cases.
4. **Difficult Maintenance**
   * Small changes may affect many paths, making updates risky.
5. **Slower Development**
   * More time is spent understanding code before making changes.
6. **Refactoring Resistance**
   * Highly complex code discourages improvements due to fear of breaking functionality.

## **Strategies to Reduce Cyclomatic Complexity**

Lowering cyclomatic complexity improves readability, testability, and maintainability.\
Here are proven approaches:

1. **Break Down Large Functions**
   * Split long methods with multiple decision points into smaller, focused methods.
2. **Use Guard Clauses**
   * Instead of deeply nested `if` statements, return early when a condition is not met.
   *   Example:

       ```java
       if (!isValid(input)) return;
       process(input);
       ```
3. **Replace Conditionals with Polymorphism**
   * Use object-oriented design to replace long conditional chains with class hierarchies or strategy patterns.
4. **Leverage Switch/Map Lookups**
   * Replace repetitive conditional checks with lookup tables or maps when possible.
5. **Apply the Single Responsibility Principle (SRP)**
   * Ensure each function or class does one thing; split responsibilities to reduce branching logic.
6. **Use Meaningful Abstractions**
   * Extract complex decision logic into descriptive methods or helper classes.
7. **Adopt Functional Constructs** _(where applicable)_
   * Use streams, filters, and lambdas to simplify control flow instead of loops and nested conditionals.
8. **Refactor Repeated Logic**
   * Consolidate duplicated code paths into a single reusable function.
