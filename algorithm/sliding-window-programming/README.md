# Sliding Window Programming

## About

**Sliding Window** is a powerful and commonly used technique for solving problems related to **arrays** or **strings**, especially when we are dealing with **contiguous (continuous) subarrays or substrings**.

The basic idea is:

* Instead of checking every possible subarray (which takes a lot of time), we move a **window** (a part of the array) across the input.
* We **slide** this window by moving its **start** and **end** pointers, depending on the problem.

This approach helps us reduce time complexity from **O(n²)** to **O(n)** in many cases.

## Why Use Sliding Window ?

Sliding Window is useful when:

* We need to find or calculate something in a **subarray** or **substring** of fixed or variable length.
* Problems require **efficient scanning** over a portion of the input while keeping track of some condition (like sum, frequency, count, etc.)

It avoids recomputing results from scratch for every subarray and instead **updates the result as the window moves**.

## How It Works ?

There are **two types** of sliding windows:

### **1. Fixed Size Window**

* The window size is known and does not change.
* Example: Find the maximum sum of any subarray of size `k`.

**Steps:**

* Start with a window of size `k`.
* Move the window one step at a time (i.e., shift both start and end pointers).
* Update the result (sum, max, etc.) by subtracting the outgoing element and adding the new incoming element.

### **2. Variable Size Window**

* The window size changes depending on some condition (like sum ≤ K, all unique characters, etc.)
* Example: Find the longest substring with no repeating characters.

**Steps:**

* Expand the window by moving the end pointer.
* If the condition breaks, move the start pointer to shrink the window.
* Keep updating the result based on the current valid window.

## Use Case 1: Maximum Sum of Subarray of Size K

Given an array of integers and a number `k`, find the maximum sum of any contiguous subarray of size `k`.

#### **Example**

Input:

```java
arr = [2, 1, 5, 1, 3, 2], k = 3
```

Output:

```
9
```

Explanation:

* Subarrays of size 3:
  * \[2, 1, 5] → sum = 8
  * \[1, 5, 1] → sum = 7
  * \[5, 1, 3] → sum = 9 ← max
  * \[1, 3, 2] → sum = 6
* Maximum sum is **9**

### Brute Force (O(n²)) Approach

Generate all subarrays of size `k`, calculate the sum, and find the maximum.

```java
int maxSum = Integer.MIN_VALUE;

for (int i = 0; i <= arr.length - k; i++) {
    int sum = 0;
    for (int j = i; j < i + k; j++) {
        sum += arr[j];  // Add each element in the window
    }
    maxSum = Math.max(maxSum, sum);
}
System.out.println(maxSum);
```

#### **Time Complexity**

* Outer loop runs (n - k + 1) times
* Inner loop runs k times
* **Total = O((n - k + 1) \* k) = O(n \* k)**
* If k ≈ n, this becomes O(n²)

### Optimized Sliding Window (O(n)) Approach

Use a window of size `k`. Instead of recalculating the sum every time:

* Subtract the element that’s **leaving** the window
* Add the element that’s **entering** the window

```java
int maxSum = 0;
int windowSum = 0;

// Step 1: Calculate sum of first window
for (int i = 0; i < k; i++) {
    windowSum += arr[i];
}
maxSum = windowSum;

// Step 2: Slide the window
for (int i = k; i < arr.length; i++) {
    windowSum += arr[i] - arr[i - k];  // Add new, remove old
    maxSum = Math.max(maxSum, windowSum);
}

System.out.println(maxSum);
```

#### **Step-by-Step Example**

Array = \[2, 1, 5, 1, 3, 2], k = 3

* First window \[2, 1, 5] → sum = 8
* Slide to \[1, 5, 1] → sum = 8 - 2 + 1 = 7
* Slide to \[5, 1, 3] → sum = 7 - 1 + 3 = 9 ← max
* Slide to \[1, 3, 2] → sum = 9 - 5 + 2 = 6

Final result = **9**

#### **Time Complexity**

* One full pass through array → O(n)

