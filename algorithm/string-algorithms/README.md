# String Algorithms

## Rabin-Karp Substring Search Algorithm

Given two strings:

* **Text (T)** of length `n`
* **Pattern (P)** of length `m`

The goal is to **find all occurrences** of the pattern `P` in the text `T`.

{% hint style="success" %}
Brute-force substring search compares the pattern at every position in the text. Its worst-case time is `O(n * m)`.

**Rabin-Karp** improves this by using **hashing**. It compares hashes instead of characters, so multiple character comparisons are replaced by simple number comparisons.
{% endhint %}

* Convert the **pattern** and **substrings of the text** to numbers using a **hash function**.
* Instead of comparing strings, compare their **hashes**.
* Only do full character comparison if the hashes match (to confirm the match, in case of hash collisions).

This gives us **average-case linear time**, and it's especially useful when:

* We are searching for **multiple patterns**.
* We want a fast filtering technique.

### How the Hash Works

The pattern and substrings are treated as numbers in a base (commonly base 256, for ASCII).

**Example (simplified):**

Assume base = 10.

* String "abc" → hash = a × 10² + b × 10¹ + c × 10⁰
* If a = 1, b = 2, c = 3 → hash = 1×100 + 2×10 + 3 = 123

We use a **rolling hash** to compute the next substring's hash in constant time, using the previous hash:

```
bashCopyEdithash(i+1) = (base × (hash(i) - T[i] × base^(m-1)) + T[i+m]) % prime
```

A **prime number** is used to mod the hash to prevent overflow and reduce collisions.

### Step-by-Step Algorithm

1. Choose:
   * A base (like 256)
   * A large prime number (say, 101)
2. Compute the **hash of the pattern**.
3. Compute the **hash of the first window** (first m characters) of the text.
4. Slide the window:
   * At each step, compare the **hash of the window** with the **pattern hash**.
   * If they match, compare the actual substrings (to avoid false matches due to collisions).
   * Use **rolling hash** to compute next window’s hash efficiently.

### Implementation

Find all occurrences of a **pattern** string in a **text** string.

**Text:** `"abedabcabcabcde"`\
**Pattern:** `"abc"`

#### 1. Brute Force Approach

* Slide the pattern over the text one character at a time.
* At each position, compare the entire pattern with the substring from the text.
* If all characters match, we found an occurrence.

```java
public class BruteForceSearch {
    public static void search(String text, String pattern) {
        int n = text.length();
        int m = pattern.length();

        for (int i = 0; i <= n - m; i++) {
            int j = 0;
            // Compare character by character
            while (j < m && text.charAt(i + j) == pattern.charAt(j)) {
                j++;
            }
            // If full pattern matched
            if (j == m) {
                System.out.println("Pattern found at index " + i);
            }
        }
    }

    public static void main(String[] args) {
        String text = "abedabcabcabcde";
        String pattern = "abc";
        search(text, pattern);
    }
}
```

#### Output

```
Pattern found at index 4  
Pattern found at index 7  
Pattern found at index 10
```

#### Rabin-Karp Approach

* Convert the pattern and substrings of the text into hash values.
* Slide a window and compare hash values.
* If hashes match, do a character-level comparison (to handle collisions).
* Use rolling hash to compute the next window hash in `O(1)` time.

```java
public class RabinKarpSearch {
    public static void search(String text, String pattern) {
        int base = 256;             // For ASCII characters
        int prime = 101;            // A prime number to reduce hash collisions
        int n = text.length();
        int m = pattern.length();

        int patternHash = 0;        // Hash of the pattern
        int windowHash = 0;         // Hash of current window in text
        int h = 1;

        // Compute base^(m-1) % prime, used in removing the first digit
        for (int i = 0; i < m - 1; i++) {
            h = (h * base) % prime;
        }

        // Calculate hash for pattern and first window
        for (int i = 0; i < m; i++) {
            patternHash = (base * patternHash + pattern.charAt(i)) % prime;
            windowHash = (base * windowHash + text.charAt(i)) % prime;
        }

        // Slide the window
        for (int i = 0; i <= n - m; i++) {
            // If hash matches, check characters one by one
            if (patternHash == windowHash) {
                boolean match = true;
                for (int j = 0; j < m; j++) {
                    if (text.charAt(i + j) != pattern.charAt(j)) {
                        match = false;
                        break;
                    }
                }
                if (match) {
                    System.out.println("Pattern found at index " + i);
                }
            }

            // Compute hash for next window
            if (i < n - m) {
                windowHash = (base * (windowHash - text.charAt(i) * h) + text.charAt(i + m)) % prime;

                // Handle negative hash
                if (windowHash < 0) {
                    windowHash += prime;
                }
            }
        }
    }

    public static void main(String[] args) {
        String text = "abedabcabcabcde";
        String pattern = "abc";
        search(text, pattern);
    }
}
```

#### Output

```
Pattern found at index 4  
Pattern found at index 7  
Pattern found at index 10
```

### Time and Space Complexity

<table><thead><tr><th width="127.5806884765625">Case</th><th width="138.12060546875">Time Complexity</th><th>Why</th></tr></thead><tbody><tr><td>Best/Average</td><td>O(n + m)</td><td>Because of rolling hash and few hash matches</td></tr><tr><td>Worst</td><td>O(n * m)</td><td>Too many hash collisions lead to full comparisons</td></tr><tr><td>Space</td><td>O(1) or O(m)</td><td>For hash calculation</td></tr></tbody></table>
