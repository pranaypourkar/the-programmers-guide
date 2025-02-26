# Recursion

## About

Recursion is a fundamental programming technique where a function calls itself to solve smaller instances of the same problem. It is widely used in various algorithmic paradigms, including divide and conquer, dynamic programming, and backtracking.

A recursive function typically consists of:

1. **Base Case:** The stopping condition that prevents infinite recursion.
2. **Recursive Case:** The function calls itself with a reduced or simpler input.

## **How Recursion Works**

When a recursive function is called, the following happens:

1. The function's **current execution state** (parameters, local variables, return address) is pushed onto the **call stack**.
2. A new function instance is invoked with the updated parameters.
3. This process continues until the base case is reached.
4. The function starts **returning values** and **popping** previous calls from the call stack.

### **Example: Factorial using Recursion**

```java
public static int factorial(int n) {
    if (n == 0) return 1; // Base case
    return n * factorial(n - 1); // Recursive case
}
```

**Execution Flow for `factorial(4)`**

```
factorial(4)
→ 4 * factorial(3)
→ 4 * (3 * factorial(2))
→ 4 * (3 * (2 * factorial(1)))
→ 4 * (3 * (2 * (1 * factorial(0))))
→ 4 * 3 * 2 * 1 * 1
→ 24
```

## **Recursion vs Iteration**

<table data-full-width="true"><thead><tr><th width="244">Feature</th><th>Recursion</th><th>Iteration</th></tr></thead><tbody><tr><td><strong>Definition</strong></td><td>A function calls itself until a base condition is met.</td><td>Uses loops (<code>for</code>, <code>while</code>, <code>do-while</code>) to repeat code.</td></tr><tr><td><strong>Termination</strong></td><td>Stops when the base case is reached.</td><td>Stops when loop condition fails.</td></tr><tr><td><strong>Memory Usage</strong></td><td>Uses <strong>stack memory</strong> for each recursive call.</td><td>Uses <strong>constant memory</strong> (<code>O(1)</code>) unless extra storage is needed.</td></tr><tr><td><strong>Execution Speed</strong></td><td>Slower due to function call overhead.</td><td>Faster as it avoids function call overhead.</td></tr><tr><td><strong>Readability</strong></td><td>More intuitive for problems like tree traversal.</td><td>More efficient but can be harder to follow for complex loops.</td></tr><tr><td><strong>Risk of Stack Overflow</strong></td><td>Yes, if recursion depth is too high.</td><td>No stack overflow risk unless excessive memory is used.</td></tr><tr><td><strong>Optimization</strong></td><td>Can use <strong>memoization</strong> and <strong>tail recursion</strong>.</td><td>Generally efficient without additional optimization.</td></tr><tr><td><strong>Common Use Cases</strong></td><td>Tree traversal, Divide and Conquer, Backtracking.</td><td>Iterating over arrays, searching, summing numbers.</td></tr></tbody></table>

## **Types of Recursion**

Recursion can be classified into different types based on the function's call pattern.

### **1. Direct Recursion**

A function calls itself directly.

```java
void directRecursion(int n) {
    if (n == 0) return;
    directRecursion(n - 1);
}
```

### **2. Indirect Recursion**

A function calls another function, which in turn calls the original function.

```java
void functionA(int n) {
    if (n <= 0) return;
    functionB(n - 1);
}

void functionB(int n) {
    if (n <= 0) return;
    functionA(n - 2);
}
```

### **3. Tail Recursion**

Recursive call is the last operation before returning a result.\
Optimized by **Tail Call Optimization (TCO)** in some languages.

```java
void tailRecursion(int n) {
    if (n == 0) return;
    System.out.println(n);
    tailRecursion(n - 1);
}
```

### **4. Non-Tail Recursion**

Recursive call is **not** the last operation.

```java
int nonTailRecursion(int n) {
    if (n == 0) return 0;
    return n + nonTailRecursion(n - 1);
}
```

### **5. Multiple Recursion**

A function calls itself multiple times. Example: Fibonacci series

```java
int fibonacci(int n) {
    if (n <= 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}
```

## **Advantages and Disadvantages of Recursion**

#### **Advantages**

1. **Simplifies Complex Problems:** Makes problems like tree traversal and backtracking easier to implement.
2. **Readable Code:** Reduces unnecessary loops and conditional statements.
3. **Used in Divide and Conquer Algorithms:** Essential for **Merge Sort, Quick Sort, and Binary Search**.

#### **Disadvantages**

1. **High Memory Usage:** Each recursive call consumes stack memory, leading to potential **stack overflow**.
2. **Slower Execution:** Function calls add overhead compared to loops.
3. **Difficult Debugging:** Tracing recursive calls is harder than debugging iterative code.

## **When to Use Recursion vs Iteration**

<table data-full-width="true"><thead><tr><th width="618">Situation</th><th>Preferred Approach</th></tr></thead><tbody><tr><td><strong>Tree and Graph Traversal</strong></td><td>Recursion</td></tr><tr><td><strong>Divide and Conquer (Merge Sort, Quick Sort)</strong></td><td>Recursion</td></tr><tr><td><strong>Backtracking (Sudoku, N-Queens)</strong></td><td>Recursion</td></tr><tr><td><strong>Mathematical Computations (Factorial, Fibonacci)</strong></td><td>Recursion (but optimized versions exist)</td></tr><tr><td><strong>Large Iterations (Summing a Large Array, Finding Max/Min)</strong></td><td>Iteration</td></tr><tr><td><strong>Memory-Efficient Operations</strong></td><td>Iteration</td></tr></tbody></table>

```java
// Recursion
public static int factorialRecursive(int n) {
    if (n == 0) return 1; // Base case
    return n * factorialRecursive(n - 1); // Recursive case
}

Time Complexity: O(n)
Space Complexity: O(n) (Call Stack)

// Iteration
public static int factorialIterative(int n) {
    int result = 1;
    for (int i = 2; i <= n; i++) {
        result *= i;
    }
    return result;
}

Time Complexity: O(n)
Space Complexity: O(1)
```
