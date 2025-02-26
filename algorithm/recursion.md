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



