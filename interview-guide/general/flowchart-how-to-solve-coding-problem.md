# Flowchart - How to Solve Coding Problem?

## About

This section explains the stepwise thought process interviewers expect: understanding the problem, clarifying constraints, writing brute force first, then optimizing. Questions help reinforce this structure with examples.

Reference - [https://www.crackingthecodinginterview.com/](https://www.crackingthecodinginterview.com/)

<figure><img src="../../.gitbook/assets/cracking_the_coding_skills_-_v6_page-0001.jpg" alt=""><figcaption></figcaption></figure>

## Example 1

### **Problem**

Given an array of distinct integer values, count the number of pairs of integers that have difference k. For example, given the array { 1, 7, 5, 9, 2, 12, 3} and the difference k = 2, there are four pairs with difference as 2 i.e. (1, 3), (3, 5), (5, 7), (7, 9).

### **Step 1: Understand the Problem**

We need to count **distinct pairs** `(a, b)` in an array such that:

∣a−b∣=k

Given:

* An **array of distinct integers**.
* An **integer k (positive difference)**.
* We count **unordered pairs** (e.g., `(1,3)` is the same as `(3,1)`).

### **Step 2: Explore Examples**

Example:

```java
Input:  { 1, 7, 5, 9, 2, 12, 3 }, k = 2
Output: 4
```

Valid pairs: `(1,3)`, `(3,5)`, `(5,7)`, `(7,9)`

Edge cases:

* **Empty array?** → Return `0`
* **Single element?** → Return `0`
* **No valid pairs?** → Return `0`
* **Negative k?** → Not allowed (problem states "difference k")
* **Already sorted?** → Optimize accordingly

### **Step 3: Brute Force Approach**

A naïve solution checks **every pair** `(i, j)`:

```java
for (int i = 0; i < arr.length; i++) {
    for (int j = i + 1; j < arr.length; j++) {
        if (Math.abs(arr[i] - arr[j]) == k) {
            count++;
        }
    }
}
```

**Time Complexity:**

* **O(N²)** (Nested loop) – Too slow for large inputs.

### **Step 4: Optimize**

We can use a **HashSet** to check for pairs in **O(N)** time.

#### **Optimized Approach:**

1. **Insert all numbers into a HashSet** (O(N) time)
2. **For each number x, check if (x + k) exists in the set**
   * `(x, x+k)` is a valid pair
   * No need to check both `(x, x-k)` since it’s already handled by previous elements

**Time Complexity:** O(N)\
**Space Complexity:** O(N)

### **Step 5: Write Clean Code**

```java
import java.util.HashSet;

public class PairDifference {
    public static int countPairsWithDifference(int[] arr, int k) {
        if (arr == null || arr.length == 0 || k < 0) return 0;

        HashSet<Integer> set = new HashSet<>();
        int count = 0;

        // Store all numbers in HashSet
        for (int num : arr) {
            set.add(num);
        }

        // Check for (num + k) in HashSet
        for (int num : arr) {
            if (set.contains(num + k)) {
                count++;
            }
        }

        return count;
    }

    public static void main(String[] args) {
        int[] arr = {1, 7, 5, 9, 2, 12, 3};
        int k = 2;
        System.out.println(countPairsWithDifference(arr, k)); // Output: 4
    }
}
```

### **Step 6: Test the Solution**

✔ **Base case:** `[] → 0`\
✔ **Single element:** `[5] → 0`\
✔ **No valid pairs:** `[10, 20, 30]` with `k = 5 → 0`\
✔ **Large input:** Handles efficiently in O(N)

## Example 2

### Problem

Print all positive integer solutions to the equation a3 + b3 and d are integers between 1 and 1000.

### **Understanding the Problem**

We need to **find all positive integer solutions** for the equation:

a^3+b^3=c^3+d^3

where a,b,c,d are integers between **1 and 1000**.

This means we need to find **pairs (a, b) and (c, d) such that their cubes sum to the same value**.

### **Brute Force Approach (O(N⁴))**

A simple approach is to iterate through **all possible values of (a, b, c, d)** and check if they satisfy the equation.

```java
for (int a = 1; a <= 1000; a++) {
    for (int b = 1; b <= 1000; b++) {
        for (int c = 1; c <= 1000; c++) {
            for (int d = 1; d <= 1000; d++) {
                if (Math.pow(a, 3) + Math.pow(b, 3) == Math.pow(c, 3) + Math.pow(d, 3)) {
                    System.out.println(a + "^3 + " + b + "^3 = " + c + "^3 + " + d + "^3");
                }
            }
        }
    }
}
```

**Correct but VERY slow**: O(N⁴) ≈ **10¹² iterations**, which is impractical.

### **Optimized Approach using HashMap (O(N²))**

1. Instead of iterating over **four nested loops**, we can use a **HashMap** to store sums of cube pairs.
2. We iterate over **(a, b) pairs first**, compute a^3 + b^3, and store it in a **HashMap**.
3. Then, for each **(c, d) pair**, we check if the sum exists in the HashMap.

**Time Complexity:**

* **O(N²)** for precomputing all (a, b) pairs.
* **O(N²)** for checking (c, d) pairs.
* **Total: O(N²) ≈ 10⁶ iterations**, which is feasible.

### **Optimized Java Implementation**

```java
import java.util.*;

public class CubePairEquation {
    public static void findCubePairs(int limit) {
        // HashMap to store sum of cubes and corresponding (a, b) pairs
        Map<Integer, List<int[]>> cubeSumMap = new HashMap<>();

        // Step 1: Compute all pairs (a, b) and store in HashMap
        for (int a = 1; a <= limit; a++) {
            for (int b = a; b <= limit; b++) { // Avoid duplicate pairs
                int sum = (a * a * a) + (b * b * b);
                
                // Store pairs with the same sum
                cubeSumMap.computeIfAbsent(sum, k -> new ArrayList<>())
                    .add(new int[]{a, b});
            }
        }

        // Step 2: Iterate over the map and print valid (a, b) and (c, d) pairs
        for (Map.Entry<Integer, List<int[]>> entry : cubeSumMap.entrySet()) {
            List<int[]> pairs = entry.getValue();
            for (int i = 0; i < pairs.size(); i++) {
                for (int j = i + 1; j < pairs.size(); j++) {
                    int[] firstPair = pairs.get(i);
                    int[] secondPair = pairs.get(j);
                    System.out.println(firstPair[0] + "^3 + " + firstPair[1] + "^3 = "
                            + secondPair[0] + "^3 + " + secondPair[1] + "^3");
                }
            }
        }
    }

    public static void main(String[] args) {
        findCubePairs(1000); // Find all solutions for numbers from 1 to 1000
    }
}
```

### **Explanation of Optimized Approach**

1. **Precompute cube sums:**
   * We iterate over **(a, b) pairs** and compute a^3 + b^3.
   * Store these values in a **HashMap**, where key = sum of cubes, and value = list of (a, b) pairs.
2. **Find matching pairs efficiently:**
   * If multiple (a, b) pairs have the same cube sum, they form valid `(c, d)` pairs.
   * This eliminates **two nested loops**, making the solution **O(N²)**.

#### **Time & Space Complexity**

**Time Complexity:** **O(N²)** (Better than O(N⁴))\
**Space Complexity:** **O(N²)** (Stores sum mappings)

#### **Example Output (Partial)**

```
1^3 + 12^3 = 9^3 + 10^3
2^3 + 16^3 = 9^3 + 15^3
...
```

