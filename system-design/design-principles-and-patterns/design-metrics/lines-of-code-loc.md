# Lines of Code (LOC)

## About

**Lines of Code (LOC)** is one of the oldest and simplest software metrics.\
It measures the size of a program based on the number of lines in its source code.\
LOC is often used as a rough indicator of:

* Codebase size
* Development effort estimation
* Progress tracking over time

However, LOC **does not directly measure code quality**—a larger codebase does not necessarily mean better functionality, and fewer lines are not always better if they reduce clarity.

LOC is most useful when:

* Comparing modules within the same codebase
* Tracking size changes over time
* Supporting other metrics such as Maintainability Index or productivity analysis

## **Types of LOC**

### **1. Physical LOC (PLOC)**

* Counts every non‑blank, non‑comment line in a file.
* Example: A function with 50 actual lines of code (excluding comments) has PLOC = 50.
* **Pros:** Easy to calculate and standardize.
* **Cons:** Sensitive to formatting (e.g., breaking a statement across lines).

### **2. Logical LOC (LLOC)**

* Counts **statements** rather than physical lines.
*   Example:

    ```java
    if (x > 0) { y = 1; z = 2; }
    ```

    * PLOC = 3 (if, y=1, z=2 are on separate lines)
    * LLOC = 3 (three statements, regardless of formatting)
* **Pros:** More accurate representation of actual logic.
* **Cons:** Harder to measure without tools.

### **3. Comment LOC (CLOC)**

* Measures only comment lines to track documentation coverage.
* Useful for ensuring maintainable and well‑documented code.

## **LOC Interpretation Guidelines for Java**

<table data-header-hidden data-full-width="true"><thead><tr><th width="95.29296875"></th><th width="137.47265625"></th><th width="137.6953125"></th><th width="133.40625"></th><th></th></tr></thead><tbody><tr><td><strong>Scope</strong></td><td><strong>Good / Maintainable</strong></td><td><strong>Warning Zone</strong></td><td><strong>Refactor Alert</strong></td><td><strong>Notes</strong></td></tr><tr><td><strong>Method</strong></td><td>≤ 20 LOC</td><td>21–50 LOC</td><td>> 50 LOC</td><td>Keep methods small and focused; apply Single Responsibility Principle.</td></tr><tr><td><strong>Class</strong></td><td>≤ 200 LOC</td><td>201–500 LOC</td><td>> 500 LOC</td><td>Consider splitting large classes; watch for “God Objects.”</td></tr><tr><td><strong>Java File</strong></td><td>≤ 500 LOC</td><td>501–1000 LOC</td><td>> 1000 LOC</td><td>Large files reduce readability and make merging harder.</td></tr><tr><td><strong>Project Module</strong></td><td>Context‑dependent</td><td>—</td><td>—</td><td>Compare with similar modules in our project for trends.</td></tr></tbody></table>

{% hint style="success" %}
If using **SonarQube**, **Checkstyle**, or **PMD**, configure **per‑method and per‑class LOC thresholds** rather than a single project‑wide limit. This catches problems early without penalizing naturally verbose but well‑structured code.
{% endhint %}

## **Pros**

1. **Easy to Calculate**
   * Simple to measure with basic tools or scripts.
2. **Useful for Trend Tracking**
   * Helps monitor codebase growth or shrinkage over time.
3. **Supports Effort Estimation**
   * When combined with historical data, can help estimate development effort.
4. **Integration with Other Metrics**
   * Works well as an input to metrics like Maintainability Index.

## **Cons**

1. **Not a Quality Metric**
   * More lines do not mean better quality, and fewer lines do not always mean better design.
2. **Language & Style Dependent**
   * Formatting and programming language can skew LOC counts.
3. **Encourages Wrong Behavior**
   * Developers might write unnecessarily verbose code to inflate LOC counts.
4. **Misleading Across Projects**
   * Cannot directly compare LOC between different programming languages or paradigms.

## **Best Practices for Using LOC**

1. **Use LOC as a Supporting Metric, Not a Sole Indicator**
   * Combine it with complexity, maintainability, and defect metrics for better insights.
2. **Track Changes Over Time**
   * Monitor growth to detect potential scope creep or over‑engineering.
3. **Normalize by Language and Context**
   * Avoid comparing LOC directly between projects in different languages.
4. **Exclude Auto‑Generated Code**
   * Generated files (e.g., OpenAPI stubs) can skew LOC statistics.
5. **Include Comment LOC Tracking**
   * Use CLOC to ensure adequate documentation coverage.
