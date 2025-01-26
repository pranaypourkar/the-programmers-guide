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

### **Example**:

Input: `A = "abcde"`, `B = "ace"`\
Output: `3`\
Explanation: The longest common subsequence is "ace".

### **Approach**:

1. Define `dp[i][j]` as the length of the LCS of `A[0...i-1]` and `B[0...j-1]`.
2. If `A[i-1] == B[j-1]`, then `dp[i][j] = dp[i-1][j-1] + 1`.
3. Otherwise, `dp[i][j] = max(dp[i-1][j], dp[i][j-1])`.

<figure><img src="../../.gitbook/assets/dp-1 (1).png" alt="" width="375"><figcaption></figcaption></figure>

### **Java Solution**:

```java
public class LongestCommonSubsequence {
    public int lcs(String A, String B) {
        int m = A.length();
        int n = B.length();
        int[][] dp = new int[m + 1][n + 1];

        for (int i = 1; i <= m; i++) {
            for (int j = 1; j <= n; j++) {
                if (A.charAt(i - 1) == B.charAt(j - 1)) {
                    dp[i][j] = dp[i - 1][j - 1] + 1;
                } else {
                    dp[i][j] = Math.max(dp[i - 1][j], dp[i][j - 1]);
                }
            }
        }
        return dp[m][n];
    }

    public static void main(String[] args) {
        LongestCommonSubsequence solution = new LongestCommonSubsequence();
        System.out.println(solution.lcs("abcde", "ace")); // Output: 3
    }
}
```
