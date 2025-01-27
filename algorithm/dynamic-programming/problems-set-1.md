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

### **Time Complexity**

* **Recursive**: O(2^max(m,n)), exponential due to overlapping subproblems. m and n are the lengths of the strings.
*   **Tabulation**: O(m×n): Two nested loops iterate through the strings.&#x20;

    **Space Complexity**: O(m×n): DP table size.

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

### **Time Complexity**

* **Recursive**: O(2^n), exponential due to overlapping subproblems.
* **Tabulation**: O(n×capacity).



## 3. Longest Palindromic Subsequence

Given a string s, find the length of its longest palindromic subsequence. A subsequence is a sequence derived from another sequence by deleting some or no elements without changing the order of the remaining elements.

#### **Example**

**Input**:\
String s="bbbab"

**Output**:\
Longest Palindromic Subsequence Length = **4**\
Explanation: The LPS is "bbbb".

### **Recursive Approach**

1. **Key Idea**:
   * If the first and last characters match:
     * The result is 2+LPS(s,l+1,r−1) (include both characters and find LPS for the inner substring).
   * Otherwise:
     * Take the maximum of:
       * Excluding the first character: LPS(s,l+1,r).
       * Excluding the last character: LPS(s,l,r−1).
2. **Base Case**:
   * If l>r: Return 0 (invalid substring).
   * If l==r: Return 1 (a single character is a palindrome).

```java
public class LongestPalindromicSubsequenceRecursive {
    public int lps(String s) {
        return lpsHelper(s, 0, s.length() - 1);
    }

    private int lpsHelper(String s, int l, int r) {
        // Base case: If pointers cross
        if (l > r) {
            return 0;
        }

        // Base case: Single character
        if (l == r) {
            return 1;
        }

        // If characters match
        if (s.charAt(l) == s.charAt(r)) {
            return 2 + lpsHelper(s, l + 1, r - 1);
        }

        // Otherwise, take the maximum excluding one of the characters
        return Math.max(lpsHelper(s, l + 1, r), lpsHelper(s, l, r - 1));
    }

    public static void main(String[] args) {
        LongestPalindromicSubsequenceRecursive solution = new LongestPalindromicSubsequenceRecursive();
        String s = "bbbab";
        System.out.println("Longest Palindromic Subsequence Length: " + solution.lps(s)); // Output: 4
    }
}
```

### **Tabulation Method (Bottom-Up DP)**

1. **DP Table Definition**:
   * Let dp\[i]\[j] represent the length of the LPS in the substring s\[i....j].
   * Initialize dp\[i]\[i]=1 (single-character palindromes).
2. **Transition**:
   * If s\[i]==s\[j]:\
     dp\[i]\[j]=2+dp\[i+1]\[j−1]
   * Otherwise:\
     dp\[i]\[j]=max⁡(dp\[i+1]\[j],dp\[i]\[j−1])
3. **Result**:
   * dp\[0]\[n−1] contains the length of the LPS for the entire string.

```java
public class LongestPalindromicSubsequenceTabulation {
    public int lps(String s) {
        int n = s.length();
        int[][] dp = new int[n][n];

        // Base case: Single-character palindromes
        for (int i = 0; i < n; i++) {
            dp[i][i] = 1;
        }

        // Build the DP table
        for (int length = 2; length <= n; length++) { // Length of the substring
            for (int i = 0; i <= n - length; i++) {
                int j = i + length - 1; // Endpoint of the substring
                if (s.charAt(i) == s.charAt(j)) {
                    dp[i][j] = 2 + dp[i + 1][j - 1];
                } else {
                    dp[i][j] = Math.max(dp[i + 1][j], dp[i][j - 1]);
                }
            }
        }

        return dp[0][n - 1];
    }

    public static void main(String[] args) {
        LongestPalindromicSubsequenceTabulation solution = new LongestPalindromicSubsequenceTabulation();
        String s = "bbbab";
        System.out.println("Longest Palindromic Subsequence Length: " + solution.lps(s)); // Output: 4
    }
}
```

### **Time Complexity**

* **Recursive**: O(2^n), exponential due to overlapping subproblems.
* **Tabulation**: O(n^2), for the nested loops.



## 4. Coin Change Problem

Given a set of coin denominations coins\[] and a target amount target, determine the minimum number of coins required to make up the target amount. If it is not possible to make the amount, return -1.

#### **Example**

**Input**:\
Coins = \[1,2,5]\
Target = 11

**Output**:\
Minimum Coins Required = **3**\
Explanation:\
The combination of coins is 5,5,1 or 1,1,1,2,2,2,2 (minimum is 3 coins).

### **Recursive Approach**

1. **Key Idea**:
   * For each coin in coins\[], reduce the target amount by the coin's value and recursively solve for the remaining amount.
   * If the target becomes zero, the minimum number of coins required is zero for that base case.
   * If the target becomes negative, it means this path is invalid.
2. **Recursive Formula**:
   * For target: minCoins(target)=min⁡(minCoins(target−coins\[i]))+1
3. **Base Case**:
   * target=0: Return 0 (no coins needed).
   * target<0: Return ∞ (invalid case).

```java
import java.util.Arrays;

public class CoinChangeRecursive {
    public int coinChange(int[] coins, int target) {
        int result = helper(coins, target);
        return result == Integer.MAX_VALUE ? -1 : result;
    }

    private int helper(int[] coins, int target) {
        // Base case: Exact match
        if (target == 0) {
            return 0;
        }

        // Base case: No solution
        if (target < 0) {
            return Integer.MAX_VALUE;
        }

        // Recursive case
        int minCoins = Integer.MAX_VALUE;
        for (int coin : coins) {
            int res = helper(coins, target - coin);
            if (res != Integer.MAX_VALUE) {
                minCoins = Math.min(minCoins, res + 1);
            }
        }
        return minCoins;
    }

    public static void main(String[] args) {
        CoinChangeRecursive solution = new CoinChangeRecursive();
        int[] coins = {1, 2, 5};
        int target = 11;
        System.out.println("Minimum Coins Required: " + solution.coinChange(coins, target)); // Output: 3
    }
}
```

### **Tabulation Method (Bottom-Up DP)**

1. **DP Table Definition**:
   * Let dp\[i] represent the minimum number of coins required to make up the amount i.
   * Initialize dp\[0]=0 (0 coins needed for amount 0).
2. **Transition**:
   * For each coin in coins\[]:
     * Update dp\[i] as: dp\[i]=min⁡(dp\[i],dp\[i−coin]+1)
3. **Result**:
   * If dp\[target] is ∞, return -1 (not possible).
   * Otherwise, return dp\[target].

```java
import java.util.Arrays;

public class CoinChangeTabulation {
    public int coinChange(int[] coins, int target) {
        int[] dp = new int[target + 1];
        Arrays.fill(dp, Integer.MAX_VALUE);
        dp[0] = 0; // Base case: 0 coins for amount 0

        // Build the DP table
        for (int coin : coins) {
            for (int i = coin; i <= target; i++) {
                if (dp[i - coin] != Integer.MAX_VALUE) {
                    dp[i] = Math.min(dp[i], dp[i - coin] + 1);
                }
            }
        }

        return dp[target] == Integer.MAX_VALUE ? -1 : dp[target];
    }

    public static void main(String[] args) {
        CoinChangeTabulation solution = new CoinChangeTabulation();
        int[] coins = {1, 2, 5};
        int target = 11;
        System.out.println("Minimum Coins Required: " + solution.coinChange(coins, target)); // Output: 3
    }
}
```

### **Time and Space Complexity**

1. **Recursive Approach**:
   * Time Complexity: O(coins^n), where n is the target amount.
   * Space Complexity: O(n), for the recursion stack.
2. **Tabulation**:
   * Time Complexity: O(coins×target), as we iterate through coins and the target.
   * Space Complexity: O(target), for the DP array.

## 5. Unique Paths

You are given a m×n grid. You are standing at the top-left corner of the grid (cell (0,0), and you want to reach the bottom-right corner (cell (m−1,n−1)). You can only move either **right** or **down** at any point.\
Find the total number of unique paths to reach the destination.



## 6. Minimum Path Sum



## 7. Subset Sum Problem



