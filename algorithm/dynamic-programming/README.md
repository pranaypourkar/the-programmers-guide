# Dynamic Programming

## About

Dynamic Programming (DP) is a powerful technique in computer science and mathematics used to solve problems by breaking them down into simpler subproblems and solving each subproblem only once, storing its result for future use. This approach avoids redundant computations, making it highly efficient for problems with overlapping subproblems and optimal substructure properties.

### **Core Principles**

* **Optimal Substructure**: A problem exhibits optimal substructure if the optimal solution to the problem can be constructed from the optimal solutions of its subproblems.
* **Overlapping Subproblems**: The problem can be broken down into subproblems that are solved multiple times during recursion.

## **Approaches to Solve DP**

There are two main approaches to implementing DP:

1. **Top-Down Approach (Memoization)**
2. **Bottom-Up Approach (Tabulation)**

### **Top-Down Approach (Memoization)**

* Solves the problem **recursively** and stores results of subproblems in a **lookup table (memoization)** to avoid redundant calculations.
* **Breaks the problem down first**, then builds up solutions.
* Uses **recursion + caching** to store previously computed values.

#### **Steps:**

1. Start solving from the **main problem**.
2. Break it into **subproblems** recursively.
3. Store the result of each subproblem in a **cache (array/map)**.
4. Before computing a subproblem, check if it's already solved (memoization).

### **Bottom-Up Approach (Tabulation)**

* Solves the problem **iteratively** by solving smaller subproblems first and building up to the final solution.
* Uses **loops** instead of recursion.
* Stores intermediate results in a **table (array or list)**.

#### **Steps:**

1. Identify the **smallest subproblems** and solve them first.
2. Use their results to build solutions for **larger subproblems**.
3. Store all computed values in a **table (array or map)**.
4. Return the final solution after computing all subproblems.

## Techniques in Dynamic Programming

Dynamic Programming (DP) techniques revolve around solving complex problems by breaking them into overlapping subproblems, solving each subproblem only once, and storing its results to avoid redundant calculations.

### **1. Memoization (Top-Down Approach)**

* **Definition**: Solve the problem recursively while caching (memoizing) the results of subproblems to avoid redundant computations.
* **Characteristics**:
  * Recursive structure.
  * Suitable for problems where the recursive relation is straightforward.
  * Requires extra space for the memoization table.
*   **Example**:

    * Fibonacci sequence:

    ```java
    import java.util.HashMap;
    import java.util.Map;

    public class FibonacciMemoization {
        private Map<Integer, Integer> memo = new HashMap<>();

        public int fib(int n) {
            if (n <= 1) return n;

            if (!memo.containsKey(n)) {
                memo.put(n, fib(n - 1) + fib(n - 2));
            }
            return memo.get(n);
        }

        public static void main(String[] args) {
            FibonacciMemoization fibCalc = new FibonacciMemoization();
            System.out.println(fibCalc.fib(10)); // Output: 55
        }
    }
    ```

### **2. Tabulation (Bottom-Up Approach)**

* **Definition**: Build a DP table iteratively from the smallest subproblems to larger subproblems.
* **Characteristics**:
  * Iterative structure.
  * Often more space-efficient than memoization.
  * Preferred for problems where it’s easier to define and build a DP table iteratively.
*   **Example**:

    * Fibonacci sequence:

    ```java
    public class FibonacciTabulation {
        public int fib(int n) {
            if (n <= 1) return n;

            int[] dp = new int[n + 1];
            dp[0] = 0;
            dp[1] = 1;

            for (int i = 2; i <= n; i++) {
                dp[i] = dp[i - 1] + dp[i - 2];
            }
            return dp[n];
        }

        public static void main(String[] args) {
            FibonacciTabulation fibCalc = new FibonacciTabulation();
            System.out.println(fibCalc.fib(10)); // Output: 55
        }
    }
    ```

### **3. Space Optimization**

* **Definition**: Reduce the space complexity of the DP solution by using only the minimum required storage.
* **Technique**:
  * Instead of storing all states, keep only the last few states needed for computation.
*   **Example**:

    * Space-optimized Fibonacci:

    ```java
    public class FibonacciSpaceOptimized {
        public int fib(int n) {
            if (n <= 1) return n;

            int prev1 = 1, prev2 = 0;

            for (int i = 2; i <= n; i++) {
                int current = prev1 + prev2;
                prev2 = prev1;
                prev1 = current;
            }
            return prev1;
        }

        public static void main(String[] args) {
            FibonacciSpaceOptimized fibCalc = new FibonacciSpaceOptimized();
            System.out.println(fibCalc.fib(10)); // Output: 55
        }
    }
    ```

## **Types of DP Problems**

### **1D DP**

* Problems where the state depends on one variable.
* **Examples**: Fibonacci numbers, climbing stairs, house robber.

### **2D DP**

* Problems with a two-dimensional state space.
* **Examples**: Grid-based pathfinding (e.g., unique paths, minimum path sum), 0/1 Knapsack.

### **Interval DP**

* Problems where solutions depend on intervals within an array.
* **Examples**: Matrix chain multiplication, palindrome partitioning.

### **String DP**

* Problems related to strings.
* **Examples**: Longest Common Subsequence (LCS), Longest Palindromic Subsequence, Edit Distance.

### **Subset DP**

* Problems involving subsets or combinations.
* **Examples**: Subset sum, partition problem, knapsack.

### **Tree/Graph DP**

* Problems on trees or graphs.
* **Examples**: Maximum path sum in a tree, longest path in a directed acyclic graph



