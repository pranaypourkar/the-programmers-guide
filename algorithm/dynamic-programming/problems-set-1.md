# Problems - Set 1

## 1. **Longest Common Subsequence (LCS)**

Given two strings `A` and `B`, find the length of the longest subsequence that is present in both strings.&#x20;

{% hint style="info" %}
A subsequence is obtained by deleting zero or more elements from a sequence without rearranging the order of the remaining elements. For example, for the string `ABCD`, the subsequences include `A`, `ACD`, `BCD`, etc. Empty value is not a subsequence.

Example:

* Sequence 1: `ABCD`
* Sequence 2: `ACBAD`
* Common Subsequences: `A`, `AB`, `ACD`, etc.
{% endhint %}

**Example**:

Input: `A = "abcde"`, `B = "ace"`\
Output: `3`\
Explanation: The longest common subsequence is "ace".

Input: `A = ""`, `B = "ace"`\
Output: 0\
Explanation: The longest common subsequence of empty and non-empty string is 0.

### **Tabulation Approach**:

1. Create a 2D DP table, `dp[m+1][n+1]`, where m and n are the lengths of `text1` and `text2`.
2. `dp[i][j]` represents the length of the LCS of the first `i` characters of `text1` and the first `j` characters of `text2`.
3. Fill the DP table iteratively:
   * If `text1[i-1] == text2[j-1]`, then `dp[i][j] = dp[i-1][j-1] + 1`.
   * Otherwise, `dp[i][j] = max(dp[i-1][j], dp[i][j-1])`.
4. The result is stored in `dp[m][n]`.

```java
public class LCSTabulation {
    public int longestCommonSubsequence(String text1, String text2) {
        int m = text1.length();
        int n = text2.length();
        int[][] dp = new int[m + 1][n + 1];

        // Fill the DP table
        for (int i = 1; i <= m; i++) {
            for (int j = 1; j <= n; j++) {
                if (text1.charAt(i - 1) == text2.charAt(j - 1)) {
                    dp[i][j] = dp[i - 1][j - 1] + 1;
                } else {
                    dp[i][j] = Math.max(dp[i - 1][j], dp[i][j - 1]);
                }
            }
        }
        return dp[m][n];
    }

    public static void main(String[] args) {
        LCSTabulation solution = new LCSTabulation();
        String text1 = "abcde";
        String text2 = "ace";
        System.out.println("Length of LCS: " + solution.longestCommonSubsequence(text1, text2)); // Output: 3
    }
}
```

### Recursive Approach

1. Compare the characters from the end of both strings.
2. If the characters match, the result is `1 + LCS of remaining strings`.
3. If the characters don't match, the result is the maximum of:
   * LCS of the first string with the second string reduced by one character.
   * LCS of the second string with the first string reduced by one character.
4. Base Case: If either string is empty, the LCS is `0`.

<figure><img src="../../.gitbook/assets/dp-1 (3).png" alt="" width="563"><figcaption></figcaption></figure>

```java
public class LCSRecursive {
    public int longestCommonSubsequence(String text1, String text2) {
        return lcsHelper(text1, text2, text1.length(), text2.length());
    }

    private int lcsHelper(String text1, String text2, int m, int n) {
        // Base case: If either string is empty, LCS is 0
        if (m == 0 || n == 0) {
            return 0;
        }

        // If last characters match, include it in LCS and reduce both strings
        if (text1.charAt(m - 1) == text2.charAt(n - 1)) {
            return 1 + lcsHelper(text1, text2, m - 1, n - 1);
        }

        // If last characters do not match, take the maximum of two possibilities
        return Math.max(
            lcsHelper(text1, text2, m - 1, n),
            lcsHelper(text1, text2, m, n - 1)
        );
    }

    public static void main(String[] args) {
        LCSRecursive solution = new LCSRecursive();
        String text1 = "abcde";
        String text2 = "ace";
        System.out.println("Length of LCS: " + solution.longestCommonSubsequence(text1, text2)); // Output: 3
    }
}
```

## 2. Knapsack Problem (**0/1)**

Given `n` items, each with a weight w\[i] and a value v\[i], and a knapsack with a maximum capacity W, determine the maximum value that can be achieved by selecting a subset of items, such that the total weight does not exceed W. You can either include an item (1) or exclude it (0).

**Example**

Items: weights=`[1,2,3]`, values=`[6,10,12]`

Knapsack Capacity: 5

Output: Maximum Value = 22\
Explanation: Include items with weights `2` and `3` (values `10` and `12`).

**Example**

Items: Weights = \[`1, 3, 4, 5]`, Values: \[`1, 4, 5, 7]`\
Capacity: `7`

Output: 9\
Explanation: Pick items with weights 3 and 4.

### **Recursive Approach**

1. **Choices**:
   * If the weight of the current item is greater than the remaining capacity, skip the item.
   * Otherwise, choose between:
     * Including the item (add its value and reduce capacity by its weight).
     * Excluding the item.
   * Take the maximum value of these choices.
2. **Base Case**:
   * If no items are left or the capacity becomes 0, return 0.

```java
public class KnapsackRecursive {
    public int knapsack(int[] weights, int[] values, int capacity) {
        return knapsackHelper(weights, values, capacity, weights.length);
    }

    private int knapsackHelper(int[] weights, int[] values, int capacity, int n) {
        // Base case: No items left or no capacity
        if (n == 0 || capacity == 0) {
            return 0;
        }

        // If the weight of the nth item is greater than capacity, skip it
        if (weights[n - 1] > capacity) {
            return knapsackHelper(weights, values, capacity, n - 1);
        }

        // Include the item or exclude it, take the max value
        return Math.max(
            values[n - 1] + knapsackHelper(weights, values, capacity - weights[n - 1], n - 1),
            knapsackHelper(weights, values, capacity, n - 1)
        );
    }

    public static void main(String[] args) {
        KnapsackRecursive solution = new KnapsackRecursive();
        int[] weights = {1, 2, 3};
        int[] values = {6, 10, 12};
        int capacity = 5;
        System.out.println("Maximum Value: " + solution.knapsack(weights, values, capacity)); // Output: 22
    }
}
```

### **Tabulation Method (Bottom-Up DP)**

1. **DP Table Definition**:
   * Use a 2D DP table, `dp[n+1][capacity+1]`.
   * `dp[i][j]` represents the maximum value achievable with the first `i` items and capacity `j`.
2. **Transition**:
   * If the current item's weight weights\[i-1] exceeds j, exclude it:\
     dp\[i]\[j]=dp\[i−1]\[j]
   * Otherwise, choose the maximum value between excluding or including the item:\
     dp\[i]\[j]=max⁡( dp\[i−1]\[j], values\[i-1] + dp\[i−1]\[j−weights\[i-1]] )
3. **Result**:
   * The maximum value is stored in dp\[n]\[capacity].

```java
public class KnapsackTabulation {
    public int knapsack(int[] weights, int[] values, int capacity) {
        int n = weights.length;
        int[][] dp = new int[n + 1][capacity + 1];

        // Build the DP table
        for (int i = 1; i <= n; i++) {
            for (int j = 1; j <= capacity; j++) {
                if (weights[i - 1] > j) {
                    dp[i][j] = dp[i - 1][j]; // Exclude item
                } else {
                    dp[i][j] = Math.max(dp[i - 1][j], values[i - 1] + dp[i - 1][j - weights[i - 1]]); // Include or exclude
                }
            }
        }
        return dp[n][capacity];
    }

    public static void main(String[] args) {
        KnapsackTabulation solution = new KnapsackTabulation();
        int[] weights = {1, 2, 3};
        int[] values = {6, 10, 12};
        int capacity = 5;
        System.out.println("Maximum Value: " + solution.knapsack(weights, values, capacity)); // Output: 22
    }
}
```





## 3. Longest Palindromic Subsequence





## 4. Coin Change Problem



## 5. Partition Equal Subset Sum

## 6. Unique Paths

## 7. Minimum Path Sum

## 8. Subset Sum Problem

