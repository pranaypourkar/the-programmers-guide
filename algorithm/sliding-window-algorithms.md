# Sliding Window Algorithms

## Problem 1

Given a smaller string `s` and a bigger string `b`, find all permutations of `s` within `b` and print their starting indices.

#### **Example**

**Input:**

`s = "abc"`\
`b = "cbabcacab"`

**Output:**

`[0, 3, 5]`\
Explanation:

* `"cba"` (index `0-2`) is a permutation of `"abc"`.
* `"bac"` (index `3-5`) is a permutation of `"abc"`.
* `"cab"` (index `5-7`) is a permutation of `"abc"`.

#### **Approach**

1. **Use the Sliding Window Technique with Frequency Counting**:
   * Maintain a frequency count (hash map or array) of characters in `s`.
   * Use a window of size `len(s)` in `b` and check if the frequency of characters in this window matches that of `s`.
   * Slide the window across `b`, updating the character counts efficiently.
2. **Steps**:
   * Compute the frequency of characters in `s` using an array `sFreq` of size 26 (for lowercase letters).
   * Maintain a `windowFreq` array to store the frequency of characters in the current window of `b`.
   * Initialize `windowFreq` with the first `len(s)` characters of `b`.
   * Compare `sFreq` and `windowFreq`. If they match, store the starting index.
   * Slide the window by:
     * Removing the leftmost character count.
     * Adding the new rightmost character count.
   * Continue this until the end of `b`.

#### **Time & Space Complexity**

* **Time Complexity:**
  * Initializing the frequency arrays: `O(N)`, where `N = len(s)`.
  * Sliding the window and updating the frequency count: `O(M)`, where `M = len(b)`.
  * Overall: **O(M + N) ≈ O(M)** (since `N` is small compared to `M`).
* **Space Complexity:**
  * `O(1)`, since we use fixed-size arrays (`sFreq` and `windowFreq` of size 26).

#### **Code**

```java
import java.util.*;

public class PermutationIndicesFinder {
    public static List<Integer> findPermutationIndices(String s, String b) {
        List<Integer> result = new ArrayList<>();
        if (s.length() > b.length()) return result;

        int[] sFreq = new int[26];
        int[] windowFreq = new int[26];

        // Populate frequency array for s
        for (char c : s.toCharArray()) {
            sFreq[c - 'a']++;
        }

        int sLen = s.length();
        int bLen = b.length();

        // Populate initial window frequency for first sLen characters
        for (int i = 0; i < sLen; i++) {
            windowFreq[b.charAt(i) - 'a']++;
        }

        // Check if the first window matches
        if (Arrays.equals(sFreq, windowFreq)) {
            result.add(0);
        }

        // Slide the window across b
        for (int i = sLen; i < bLen; i++) {
            // Remove leftmost character of previous window
            windowFreq[b.charAt(i - sLen) - 'a']--;

            // Add new rightmost character
            windowFreq[b.charAt(i) - 'a']++;

            // Compare both frequency arrays
            if (Arrays.equals(sFreq, windowFreq)) {
                result.add(i - sLen + 1);
            }
        }

        return result;
    }

    public static void main(String[] args) {
        String s = "abc";
        String b = "cbabcacab";

        List<Integer> indices = findPermutationIndices(s, b);
        System.out.println(indices); // Output: [0, 3, 5]
    }
}
```
