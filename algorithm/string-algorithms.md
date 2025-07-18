# String Algorithms

## Easy

## 1. Word Match

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

