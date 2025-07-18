# String Algorithms

## Easy

### Word Match

Design a method to find the frequency of occurrences of any given word in a book.

#### Approach 1: Using string split (One time)

```java
package algo;

public class Problem1 {
    public static void main(String[] args) {
        String bookText = "Java is great. Java is powerful. Java is everywhere!";
        String word = "Java";

        int freq = getWordFrequency(bookText, word);  // Output: 3
        System.out.println(freq);

    }

    public static int getWordFrequency(String bookText, String word) {
        if (bookText == null || word == null || word.isEmpty()) {
            return 0;
        }

        String[] words = bookText.toLowerCase().split("\\W+"); // split on non-word characters
        int count = 0;

        for (String w : words) {
            if (w.equals(word.toLowerCase())) {
                count++;
            }
        }
        return count;
    }
}
```

#### Approach 2:  Using StringUtils method

```java
package algo;

import org.apache.commons.lang3.StringUtils;

public class Problem1 {
    public static void main(String[] args) {
        String bookText = "Java is great. Java is powerful. Java is everywhere!";
        String word = "java";
        
        System.out.println(StringUtils.countMatches(bookText.toLowerCase(), word.toLowerCase()));
    }
}

```

#### Approach 3:  Optimized for Multiple Calls

Preprocess the book text **once** into a frequency map. Then lookups are fast.

```java
package algo;

import java.util.HashMap;
import java.util.Map;

public class WordFrequencyAnalyser {
    private final Map<String, Integer> wordFrequencyMap;

    public WordFrequencyAnalyser(String bookText) {
        wordFrequencyMap = new HashMap<>();
        preprocess(bookText);
    }

    private void preprocess(String bookText) {
        if (bookText == null) {
            return;
        }

        String[] words = bookText.toLowerCase().split("\\W+"); // non-word character split

        for (String word : words) {
            if (!word.isEmpty()) {
                wordFrequencyMap.put(word, wordFrequencyMap.getOrDefault(word, 0) + 1);
            }
        }
    }

    public int getFrequency(String word) {
        if (word == null || word.isEmpty()) {
            return 0;
        }
        return wordFrequencyMap.getOrDefault(word.toLowerCase(), 0);
    }

}
```

```java
package algo;

public class Problem1 {
    public static void main(String[] args) {
        String bookText = "Java is great. Java is powerful. Java is everywhere!";
        WordFrequencyAnalyser analyzer = new WordFrequencyAnalyser(bookText);

        System.out.println(analyzer.getFrequency("java"));       // Output: 3
        System.out.println(analyzer.getFrequency("is"));         // Output: 3
        System.out.println(analyzer.getFrequency("powerful"));   // Output: 1
        System.out.println(analyzer.getFrequency("python"));     // Output: 0
    }
}
```

## Medium

### Pattern Matching

We are given:

* A **pattern** string, e.g., `"aabab"`
* A **value** string, e.g., `"catcatgocatgo"`

We need to return **true** if we can **map each unique character (`a` or `b`) in the pattern to a non-empty substring** in the value so that replacing the pattern with its mapped substrings gives the original value.

#### Example

* Pattern: `"aabab"`
* Value: `"catcatgocatgo"`

Let’s say

* `'a' = "cat"`
* `'b' = "go"`

Substituting:\
Pattern → `"a a b a b"` → `"cat cat go cat go"` → matches value → return `true`.

#### Constraints

* Each `a` and `b` must map to **one consistent substring** throughout the pattern.
* `a` and `b` must be **different** (but may be of any length).
* We can’t have `a = ""` or `b = ""` (empty string is not allowed).

#### Approach

1. Count how many times `a` and `b` appear in the pattern.
2. Try all **possible lengths** of the substring assigned to `a`.
3. For each possible length of `a`, calculate the length of `b` (from remaining length of value).
4. Try assigning substrings to `a` and `b` and check if the pattern reconstructs to the value.
5. If we find a match, return `true`. Otherwise return `false`.

```java
public class PatternMatcher {

    public static boolean doesMatch(String pattern, String value) {
        if (pattern.length() == 0) return value.length() == 0;

        // Normalize pattern so that it starts with 'a'
        char firstChar = pattern.charAt(0);
        boolean isSwapped = false;
        if (firstChar != 'a') {
            pattern = swapPattern(pattern);
            isSwapped = true;
        }

        int countA = countOf(pattern, 'a');
        int countB = pattern.length() - countA;

        int maxLenA = value.length() / Math.max(1, countA); // Avoid divide by zero

        for (int lenA = 0; lenA <= maxLenA; lenA++) {
            int remainingLength = value.length() - lenA * countA;

            if (countB == 0) {
                if (remainingLength != 0) continue;
                if (isMatch(pattern, value, lenA, 0, isSwapped)) return true;
            } else if (remainingLength % countB == 0) {
                int lenB = remainingLength / countB;
                if (isMatch(pattern, value, lenA, lenB, isSwapped)) return true;
            }
        }
        return false;
    }

    private static boolean isMatch(String pattern, String value, int lenA, int lenB, boolean isSwapped) {
        int index = 0;
        String aStr = null;
        String bStr = null;

        for (char c : pattern.toCharArray()) {
            int len = (c == 'a') ? lenA : lenB;

            if (index + len > value.length()) return false;
            String sub = value.substring(index, index + len);

            if (c == 'a') {
                if (aStr == null) aStr = sub;
                else if (!aStr.equals(sub)) return false;
            } else {
                if (bStr == null) bStr = sub;
                else if (!bStr.equals(sub)) return false;
            }

            index += len;
        }

        if (aStr != null && aStr.equals(bStr)) return false;
        return true;
    }

    private static int countOf(String pattern, char c) {
        int count = 0;
        for (char ch : pattern.toCharArray()) {
            if (ch == c) count++;
        }
        return count;
    }

    private static String swapPattern(String pattern) {
        char[] swapped = new char[pattern.length()];
        for (int i = 0; i < pattern.length(); i++) {
            swapped[i] = pattern.charAt(i) == 'a' ? 'b' : 'a';
        }
        return new String(swapped);
    }

    public static void main(String[] args) {
        System.out.println(doesMatch("aabab", "catcatgocatgo")); // true
        System.out.println(doesMatch("aaaa", "catcatcatcat"));   // true
        System.out.println(doesMatch("abab", "redblueredblue")); // true
        System.out.println(doesMatch("aabb", "xyzabcxzyabc"));   // false
    }
}
```
