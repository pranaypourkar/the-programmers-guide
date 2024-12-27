# Regex (Pattern and Matcher)

## **About Regex**

**Regex** (Regular Expression) is a sequence of characters that forms a search pattern. It is widely used for:

* Validating inputs (e.g., email, phone numbers).
* Searching and extracting text from larger strings.
* Replacing patterns in text.
* Splitting strings.

## **Terminology**

### **1. Literals**

Literals in regex are characters that match themselves exactly. They are the simplest building blocks of a regex pattern.

* **Example**:
  * Pattern: `abc`
  * Matches: The string "abc" exactly, no variations.
  * Does not match: "ab" or "abcd".
* **Use Case**: Used when you want to match static text exactly as it appears.

### **2. Meta-characters**

Meta-characters are special characters in regex that have a unique meaning or functionality. They are used to define patterns beyond literal characters.

<table data-header-hidden data-full-width="true"><thead><tr><th width="157"></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Meta-character</strong></td><td><strong>Meaning</strong></td><td><strong>Example</strong></td></tr><tr><td><code>.</code></td><td>Matches any single character (except newline).</td><td>Pattern: <code>a.c</code> → Matches: "abc", "a3c".</td></tr><tr><td><code>^</code></td><td>Matches the beginning of a string.</td><td>Pattern: <code>^abc</code> → Matches: "abc" at the start of the string.</td></tr><tr><td><code>$</code></td><td>Matches the end of a string.</td><td>Pattern: <code>abc$</code> → Matches: "abc" at the end of the string.</td></tr><tr><td><code>[]</code></td><td>Denotes a character set.</td><td>Pattern: <code>[a-z]</code> → Matches any lowercase letter.</td></tr><tr><td><code>\</code></td><td>Escapes meta-characters to treat them as literals.</td><td>Pattern: <code>\.</code> → Matches a literal dot (".").</td></tr></tbody></table>

### **3. Quantifiers**

Quantifiers define the number of occurrences of a character or group that must match for a pattern to be valid.

<table data-header-hidden data-full-width="true"><thead><tr><th width="144"></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Quantifier</strong></td><td><strong>Meaning</strong></td><td><strong>Example</strong></td></tr><tr><td><code>*</code></td><td>Matches 0 or more occurrences.</td><td>Pattern: <code>ab*</code> → Matches: "a", "ab", "abb", "abbb".</td></tr><tr><td><code>+</code></td><td>Matches 1 or more occurrences.</td><td>Pattern: <code>ab+</code> → Matches: "ab", "abb", "abbb".</td></tr><tr><td><code>?</code></td><td>Matches 0 or 1 occurrence.</td><td>Pattern: <code>ab?</code> → Matches: "a", "ab".</td></tr><tr><td><code>{n}</code></td><td>Matches exactly <code>n</code> occurrences.</td><td>Pattern: <code>a{2}</code> → Matches: "aa".</td></tr><tr><td><code>{n,}</code></td><td>Matches at least <code>n</code> occurrences.</td><td>Pattern: <code>a{2,}</code> → Matches: "aa", "aaa", "aaaa".</td></tr><tr><td><code>{n,m}</code></td><td>Matches between <code>n</code> and <code>m</code> occurrences.</td><td>Pattern: <code>a{2,4}</code> → Matches: "aa", "aaa", "aaaa".</td></tr></tbody></table>

### **4. Groups**

Groups are portions of a regex enclosed in parentheses `()` that allow:

* Capturing and extracting parts of a match.
* Applying quantifiers to an entire group.

#### **Types of Groups**:

1. **Capturing Groups**:
   * Regular parentheses `( )` are used to capture matched sub-patterns.
   * Example:
     * Pattern: `(a|b)c`
     * Matches: "ac" or "bc"
     * Captures: "a" or "b".
2. **Non-Capturing Groups**:
   * `(?: )` are used for grouping without capturing.
   * Example:
     * Pattern: `(?:a|b)c`
     * Matches: "ac" or "bc"
     * Captures: None.

### **5. Flags**

Flags are optional modifiers that change the behavior of a regex. They are typically passed as the second argument to `Pattern.compile()` in Java.

<table data-header-hidden data-full-width="true"><thead><tr><th width="213"></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Flag</strong></td><td><strong>Description</strong></td><td><strong>Code</strong></td></tr><tr><td><code>CASE_INSENSITIVE</code></td><td>Makes the pattern case-insensitive.</td><td><code>Pattern.CASE_INSENSITIVE</code></td></tr><tr><td><code>MULTILINE</code></td><td>Makes <code>^</code> and <code>$</code> match the start/end of each line.</td><td><code>Pattern.MULTILINE</code></td></tr><tr><td><code>DOTALL</code></td><td>Makes <code>.</code> match newlines as well.</td><td><code>Pattern.DOTALL</code></td></tr><tr><td><code>UNICODE_CASE</code></td><td>Enables Unicode-aware case-insensitive matching.</td><td><code>Pattern.UNICODE_CASE</code></td></tr><tr><td><code>UNIX_LINES</code></td><td>Matches only  as a line terminator.</td><td><code>Pattern.UNIX_LINES</code></td></tr></tbody></table>

**Example**:

```java
Pattern pattern = Pattern.compile("abc", Pattern.CASE_INSENSITIVE);
Matcher matcher = pattern.matcher("ABC");  // Matches "ABC" due to case-insensitivity.
```

### **6. Anchors**

Anchors are zero-width assertions that specify positions in the string (not actual characters).

<table data-header-hidden data-full-width="true"><thead><tr><th width="122"></th><th width="324"></th><th></th></tr></thead><tbody><tr><td><strong>Anchor</strong></td><td><strong>Meaning</strong></td><td><strong>Example</strong></td></tr><tr><td><code>^</code></td><td>Matches the start of a string.</td><td>Pattern: <code>^abc</code> → Matches: "abc" at the start.</td></tr><tr><td><code>$</code></td><td>Matches the end of a string.</td><td>Pattern: <code>abc$</code> → Matches: "abc" at the end.</td></tr><tr><td><code>\b</code></td><td>Matches a word boundary.</td><td>Pattern: <code>\bword\b</code> → Matches "word" as a whole word.</td></tr><tr><td><code>\B</code></td><td>Matches non-word boundaries.</td><td>Pattern: <code>\Bword\B</code> → Matches "word" inside another word.</td></tr></tbody></table>

### **7. Escaping**

Since some characters (meta-characters) have special meanings in regex, they must be escaped with a backslash (`\`) to be treated literally.

| **Meta-character** | **Escaped Form** | **Description**              |
| ------------------ | ---------------- | ---------------------------- |
| `.`                | `\.`             | Matches a literal dot.       |
| `*`                | `\*`             | Matches a literal asterisk.  |
| `(`, `)`           | `\(`, `\)`       | Matches literal parentheses. |

**Example**:

* Pattern: `3\.14`
  * Matches: "3.14".
  * Does not match: "314".

### **8. Assertions**

Assertions are zero-width patterns that check for specific conditions without consuming any characters.

<table data-header-hidden data-full-width="true"><thead><tr><th width="216"></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Assertion</strong></td><td><strong>Meaning</strong></td><td><strong>Example</strong></td></tr><tr><td><strong>Lookahead</strong></td><td>Matches if a pattern exists ahead.</td><td>Pattern: <code>foo(?=bar)</code> → Matches: "foo" if "bar" follows.</td></tr><tr><td><strong>Negative Lookahead</strong></td><td>Matches if a pattern does NOT exist ahead.</td><td>Pattern: <code>foo(?!bar)</code> → Matches: "foo" if "bar" does NOT follow.</td></tr><tr><td><strong>Lookbehind</strong></td><td>Matches if a pattern exists behind.</td><td>Pattern: <code>(?&#x3C;=bar)foo</code> → Matches: "foo" if "bar" precedes.</td></tr><tr><td><strong>Negative Lookbehind</strong></td><td>Matches if a pattern does NOT exist behind.</td><td>Pattern: <code>(?&#x3C;!bar)foo</code> → Matches: "foo" if "bar" does NOT precede.</td></tr></tbody></table>

### **9. Greedy, Reluctant, and Possessive Quantifiers**

Quantifiers in regex can control how much text they try to match:

| **Type**       | **Symbol**          | **Behavior**                                      |
| -------------- | ------------------- | ------------------------------------------------- |
| **Greedy**     | `*`, `+`, `?`, `{}` | Matches as much as possible (default).            |
| **Reluctant**  | `*?`, `+?`, `??`    | Matches as little as possible.                    |
| **Possessive** | `*+`, `++`, `?+`    | Matches as much as possible without backtracking. |

**Example**:

* Pattern: `a.*b` (Greedy)
  * Matches: "a123b456b" (entire string).
* Pattern: `a.*?b` (Reluctant)
  * Matches: "a123b" (stops after first "b").

## **Pattern**

### **About Pattern**

The `Pattern` class represents a compiled regex. It is immutable and thread-safe, meaning a single `Pattern` instance can be shared across threads.

### **Advantages**:

* Pre-compiling a regex with `Pattern.compile()` improves performance for repeated use.
* `Pattern` provides advanced regex features like flags and Unicode support.

### **Features**

<table data-header-hidden data-full-width="true"><thead><tr><th width="277"></th><th></th></tr></thead><tbody><tr><td><strong>Feature</strong></td><td><strong>Description</strong></td></tr><tr><td><strong>Pre-compilation</strong></td><td>Compiles a regex once to avoid re-compilation in repeated use.</td></tr><tr><td><strong>Flags</strong></td><td>Enable special behavior like case-insensitivity or dotall mode.</td></tr><tr><td><strong>Group Extraction</strong></td><td>Supports capturing groups using parentheses for extracting matched sub-patterns.</td></tr><tr><td><strong>Unicode Support</strong></td><td>Supports Unicode-aware character classes and case folding.</td></tr><tr><td><strong>Advanced Assertions</strong></td><td>Provides zero-width assertions like lookaheads and lookbehinds.</td></tr><tr><td><strong>Performance Optimization</strong></td><td>Supports possessive quantifiers and atomic groups to reduce backtracking.</td></tr><tr><td><strong>Escaping Characters</strong></td><td>Allows matching meta-characters as literals (e.g., <code>\\.</code> to match a dot).</td></tr></tbody></table>

### **Supported Methods in Pattern**

<table data-header-hidden data-full-width="true"><thead><tr><th width="196"></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Feature Group</strong></td><td><strong>Method</strong></td><td><strong>Description</strong></td></tr><tr><td><strong>Compilation</strong></td><td><code>Pattern compile(String regex)</code></td><td>Compiles a regex into a pattern.</td></tr><tr><td></td><td><code>Pattern compile(String regex, int flags)</code></td><td>Compiles a regex with specific flags.</td></tr><tr><td><strong>Flags</strong></td><td><code>int flags()</code></td><td>Returns the flags used when compiling the pattern.</td></tr><tr><td><strong>Matching</strong></td><td><code>boolean matches(String regex, CharSequence input)</code></td><td>Matches the input string against the regex.</td></tr><tr><td><strong>Pattern Retrieval</strong></td><td><code>String pattern()</code></td><td>Returns the regex pattern as a string.</td></tr><tr><td><strong>Splitting Strings</strong></td><td><code>String[] split(CharSequence input)</code></td><td>Splits the input string around matches of the pattern.</td></tr><tr><td></td><td><code>String[] split(CharSequence input, int limit)</code></td><td>Splits the input string around matches, with a limit on splits.</td></tr><tr><td><strong>Unicode Support</strong></td><td><code>Pattern UNICODE_CASE</code></td><td>Enables Unicode-aware case folding.</td></tr><tr><td></td><td><code>Pattern UNICODE_CHARACTER_CLASS</code></td><td>Enables Unicode-aware character classes.</td></tr></tbody></table>

### **Some Regex Symbols**

<table data-header-hidden data-full-width="true"><thead><tr><th width="155"></th><th></th></tr></thead><tbody><tr><td><strong>Symbol</strong></td><td><strong>Description</strong></td></tr><tr><td><strong>.</strong></td><td>Matches any single character except a newline.</td></tr><tr><td><strong>\d</strong></td><td>Matches a digit (equivalent to <code>[0-9]</code>).</td></tr><tr><td><strong>\D</strong></td><td>Matches a non-digit (equivalent to <code>[^0-9]</code>).</td></tr><tr><td><strong>\w</strong></td><td>Matches a word character (alphanumeric or <code>_</code>).</td></tr><tr><td><strong>\W</strong></td><td>Matches a non-word character (opposite of <code>\w</code>).</td></tr><tr><td><strong>\s</strong></td><td>Matches a whitespace character (spaces, tabs, newlines).</td></tr><tr><td><strong>\S</strong></td><td>Matches a non-whitespace character.</td></tr><tr><td><strong>^</strong></td><td>Matches the beginning of a line or string.</td></tr><tr><td><strong>$</strong></td><td>Matches the end of a line or string.</td></tr><tr><td><strong>\b</strong></td><td>Matches a word boundary.</td></tr><tr><td><strong>\B</strong></td><td>Matches a position that is not a word boundary.</td></tr><tr><td><strong>[...]</strong></td><td>Matches any character inside the brackets (e.g., <code>[abc]</code> matches "a", "b", or "c").</td></tr><tr><td><strong>[^...]</strong></td><td>Matches any character NOT inside the brackets (e.g., <code>[^abc]</code> matches anything except "a", "b", or "c").</td></tr><tr><td><strong>?</strong></td><td>Matches 0 or 1 occurrence of the preceding element.</td></tr><tr><td><strong>*</strong></td><td>Matches 0 or more occurrences of the preceding element (greedy).</td></tr><tr><td><strong>+</strong></td><td>Matches 1 or more occurrences of the preceding element (greedy).</td></tr><tr><td><strong>{n}</strong></td><td>Matches exactly <code>n</code> occurrences of the preceding element.</td></tr><tr><td><strong>{n,}</strong></td><td>Matches at least <code>n</code> occurrences of the preceding element.</td></tr><tr><td><strong>{n,m}</strong></td><td>Matches between <code>n</code> and <code>m</code> occurrences of the preceding element.</td></tr><tr><td><strong>(?=...)</strong></td><td>Positive lookahead: Ensures that a certain pattern follows.</td></tr><tr><td><strong>(?!...)</strong></td><td>Negative lookahead: Ensures that a certain pattern does NOT follow.</td></tr><tr><td><strong>(?&#x3C;=...)</strong></td><td>Positive lookbehind: Ensures that a certain pattern precedes.</td></tr><tr><td><strong>(?&#x3C;!...)</strong></td><td>Negative lookbehind: Ensures that a certain pattern does NOT precede.</td></tr><tr><td><strong>\</strong></td><td>Escapes special characters (e.g., <code>\\.</code> matches a literal dot).</td></tr></tbody></table>

## **Matcher**

### **About Matcher**

The `Matcher` class in Java represents an engine that performs match operations on a character sequence using a `Pattern`. It works as a stateful iterator, allowing for complex matching, group extraction, and replacement operations. The `Matcher`is **not thread-safe**, so each thread must use its own instance if concurrency is required.

### **Features**

<table data-header-hidden data-full-width="true"><thead><tr><th width="260"></th><th></th></tr></thead><tbody><tr><td><strong>Feature</strong></td><td><strong>Description</strong></td></tr><tr><td><strong>Stateful Matching</strong></td><td>Allows iteration through matches in a target string using <code>find()</code>.</td></tr><tr><td><strong>Group Extraction</strong></td><td>Extracts specific parts of the matched text using capturing groups <code>( )</code>.</td></tr><tr><td><strong>Position Tracking</strong></td><td>Tracks the start and end positions of matches within the input string.</td></tr><tr><td><strong>Regex Replacement</strong></td><td>Performs targeted replacement using regex patterns with <code>replaceAll()</code> and <code>replaceFirst()</code>.</td></tr><tr><td><strong>Anchored Matching</strong></td><td>Matches from the beginning of the string with <code>matches()</code> or <code>lookingAt()</code>.</td></tr><tr><td><strong>Region Matching</strong></td><td>Limits matching to a specific substring of the input.</td></tr><tr><td><strong>Reset Functionality</strong></td><td>Allows resetting the <code>Matcher</code> with a new input or pattern.</td></tr></tbody></table>

### **Supported Methods in Matcher**

<table data-header-hidden data-full-width="true"><thead><tr><th width="145"></th><th width="318"></th><th></th></tr></thead><tbody><tr><td><strong>Feature Group</strong></td><td><strong>Method</strong></td><td><strong>Description</strong></td></tr><tr><td><strong>Matching</strong></td><td><code>boolean matches()</code></td><td>Attempts to match the entire input sequence against the pattern.</td></tr><tr><td></td><td><code>boolean lookingAt()</code></td><td>Attempts to match the input sequence from the beginning.</td></tr><tr><td></td><td><code>boolean find()</code></td><td>Finds the next subsequence that matches the pattern.</td></tr><tr><td></td><td><code>boolean find(int start)</code></td><td>Starts the search at the specified index and finds the next match.</td></tr><tr><td><strong>Group Extraction</strong></td><td><code>String group()</code></td><td>Returns the matched subsequence from the last match.</td></tr><tr><td></td><td><code>String group(int group)</code></td><td>Returns the specified capturing group's matched subsequence.</td></tr><tr><td></td><td><code>int groupCount()</code></td><td>Returns the number of capturing groups in the pattern.</td></tr><tr><td></td><td><code>int start()</code></td><td>Returns the start index of the last match.</td></tr><tr><td></td><td><code>int start(int group)</code></td><td>Returns the start index of the specified group in the last match.</td></tr><tr><td></td><td><code>int end()</code></td><td>Returns the end index (exclusive) of the last match.</td></tr><tr><td></td><td><code>int end(int group)</code></td><td>Returns the end index (exclusive) of the specified group in the last match.</td></tr><tr><td><strong>Replacement</strong></td><td><code>String replaceAll(String replacement)</code></td><td>Replaces every subsequence that matches the pattern with the replacement string.</td></tr><tr><td></td><td><code>String replaceFirst(String replacement)</code></td><td>Replaces the first subsequence that matches the pattern with the replacement string.</td></tr><tr><td></td><td><code>Matcher appendReplacement(StringBuffer sb, String replacement)</code></td><td>Appends a replacement to the <code>StringBuffer</code>.</td></tr><tr><td></td><td><code>StringBuffer appendTail(StringBuffer sb)</code></td><td>Appends the remaining input after the last match to the <code>StringBuffer</code>.</td></tr><tr><td><strong>Position Tracking</strong></td><td><code>int start()</code></td><td>Returns the starting position of the last match.</td></tr><tr><td></td><td><code>int end()</code></td><td>Returns the ending position of the last match.</td></tr><tr><td><strong>Region Matching</strong></td><td><code>Matcher region(int start, int end)</code></td><td>Sets the bounds of the region within which matches are searched.</td></tr><tr><td></td><td><code>boolean hasTransparentBounds()</code></td><td>Checks if the matcher uses transparent bounds.</td></tr><tr><td></td><td><code>Matcher useTransparentBounds(boolean b)</code></td><td>Sets whether the matcher uses transparent bounds.</td></tr><tr><td></td><td><code>boolean hasAnchoringBounds()</code></td><td>Checks if the matcher uses anchoring bounds.</td></tr><tr><td></td><td><code>Matcher useAnchoringBounds(boolean b)</code></td><td>Sets whether the matcher uses anchoring bounds.</td></tr><tr><td><strong>Reset</strong></td><td><code>Matcher reset()</code></td><td>Resets the matcher, clearing any previous match state.</td></tr><tr><td></td><td><code>Matcher reset(CharSequence input)</code></td><td>Resets the matcher with a new input sequence.</td></tr></tbody></table>

### **Named Capturing Groups**

**Named Capturing Groups** allow us to assign names to specific groups in a regex pattern. This makes it easier to extract data without relying on the group index.

#### **Syntax**

* Use the format `(?<name>...)` to define a named group.
* Use `Matcher.group("name")` to retrieve the content of the named group.

#### **Example**

```java
Pattern pattern = Pattern.compile("(?<day>\\d{2})-(?<month>\\d{2})-(?<year>\\d{4})");
Matcher matcher = pattern.matcher("15-08-2023");
if (matcher.matches()) {
    System.out.println("Day: " + matcher.group("day"));    // Output: 15
    System.out.println("Month: " + matcher.group("month")); // Output: 08
    System.out.println("Year: " + matcher.group("year"));   // Output: 2023
}
```

#### **Advantages**:

* Improves code readability.
* Reduces errors caused by incorrect group indices.

### **Atomic Groups**

**Atomic Groups** are used to prevent backtracking within a group. Once a group is matched, the regex engine will not revisit it, even if the match fails later.

#### **Syntax**

* Use the format `(?>...)` to define an atomic group.

#### **Example**

```java
Pattern pattern = Pattern.compile("(?>a|aa)b");
Matcher matcher = pattern.matcher("aab");
System.out.println(matcher.matches()); // Output: false
```

**Explanation**:

* `(?>a|aa)` matches "a" first (atomic group), but when it fails to match "b" after it, the regex engine does not backtrack to try "aa".

#### **Use Cases**:

* **Performance Optimization**: Reduces backtracking for large or complex patterns.
* **Matching Efficiency**: Ensures certain patterns are matched only once.

#### **When to Use**:

* When matching rules within a group are strict and should not allow any backtracking.
* When the regex is suffering from performance issues due to excessive backtracking.

## **How Pattern and Matcher Work Together ?**

The `Pattern` and `Matcher` classes in Java's `java.util.regex` package work together to provide a mechanism for regular expression processing.

### **Relationship Between Pattern and Matcher**

* **`Pattern`**: Represents the compiled version of a regular expression. It is immutable and thread-safe. You create a `Pattern` once and reuse it across multiple matching operations.
* **`Matcher`**: Represents the engine that performs match operations against a specific input string using the `Pattern`. It is stateful and not thread-safe.

### **Workflow**

1. **Compile the Regex**: A `Pattern` object is created using `Pattern.compile(String regex)`. This compiles the regex for better performance.
2. **Create a Matcher**: A `Matcher` object is created from the `Pattern` using `Pattern.matcher(CharSequence input)`.
3. **Perform Matching Operations**: The `Matcher` is used to perform operations like `find()`, `matches()`, or `replaceAll()` on the input string.

```java
import java.util.regex.*;

public class RegexExample {
    public static void main(String[] args) {
        // Step 1: Compile the regex
        Pattern pattern = Pattern.compile("\\d{3}-\\d{2}-\\d{4}");
        
        // Step 2: Create a matcher for the input string
        Matcher matcher = pattern.matcher("123-45-6789");
        
        // Step 3: Perform matching operations
        if (matcher.matches()) {
            System.out.println("The input matches the pattern."); //The input matches the pattern.
        } else {
            System.out.println("The input does not match the pattern.");
        }
    }
}
```

{% hint style="info" %}
* The regex `\\d{3}-\\d{2}-\\d{4}` is compiled into a `Pattern`.
* The `Pattern` is used to create a `Matcher` for the input string `"123-45-6789"`.
* The `matches()` method checks if the entire input matches the regex.
{% endhint %}

{% hint style="warning" %}
* **Reuse of Pattern**: The `Pattern` can be reused to create multiple `Matcher` instances for different input strings.
* **Statefulness of Matcher**: The `Matcher` retains state during operations (e.g., the position of the last match).
* **Thread-Safety**:
  * `Pattern`: Thread-safe and reusable.
  * `Matcher`: Not thread-safe; each thread should use its own `Matcher` instance.
{% endhint %}

## **Performance Optimization Techniques**

Regex operations can sometimes be computationally expensive. Below are techniques to optimize the performance of `Pattern` and `Matcher`:

### **1. Compile the Pattern Once**

* **Problem**: Re-compiling the regex repeatedly can be expensive.
* **Solution**: Compile the regex once using `Pattern.compile()` and reuse the `Pattern` object across multiple matching operations.

```java
// Compile once
Pattern pattern = Pattern.compile("\\d{3}-\\d{2}-\\d{4}");

// Reuse Pattern for multiple inputs
Matcher matcher1 = pattern.matcher("123-45-6789");
Matcher matcher2 = pattern.matcher("987-65-4321");
```

### **2. Use Lazy Quantifiers When Appropriate**

* **Problem**: Greedy quantifiers (`*`, `+`, `?`) can cause excessive backtracking, especially with large input strings.
* **Solution**: Use lazy quantifiers (`*?`, `+?`, `??`) to minimize unnecessary matching attempts.

```java
// Greedy
Pattern greedyPattern = Pattern.compile(".*b");

// Lazy
Pattern lazyPattern = Pattern.compile(".*?b");
```

### **3. Avoid Catastrophic Backtracking**

* **Problem**: Nested quantifiers can lead to exponential backtracking, causing performance issues.
* **Solution**:
  * Use atomic groups (`(?>...)`) to prevent backtracking.
  * Simplify regex patterns to reduce complexity.

```java
// Problematic regex
Pattern pattern = Pattern.compile("(a+)+b");

// Optimized with atomic groups
Pattern atomicPattern = Pattern.compile("(?>(a+))+b");
```

### **4. Use Predefined Character Classes**

* **Problem**: Defining custom character classes like `[a-zA-Z0-9_]` can make regex verbose and less efficient.
* **Solution**: Use predefined character classes like `\\w` (word character), `\\d` (digit), or `\\s` (whitespace).

```java
// Custom character class
Pattern custom = Pattern.compile("[a-zA-Z0-9_]");

// Predefined character class
Pattern predefined = Pattern.compile("\\w");
```

### **5. Limit the Region for Matching**

* **Problem**: Searching the entire string when only a portion is relevant can waste time.
* **Solution**: Use `Matcher.region(int start, int end)` to limit matching to a specific substring.

```java
Matcher matcher = pattern.matcher("123-45-6789");
matcher.region(4, 9); // Search only within "45-6789"
```

### **6. Use Anchors for Efficiency**

* **Problem**: Matching without specifying start (`^`) or end (`$`) anchors can lead to unnecessary scanning.
* **Solution**: Use anchors to match at specific positions in the input.

```java
// Match only if the entire input is a number
Pattern pattern = Pattern.compile("^\\d+$");
```

### **7. Optimize Replacement Operations**

* **Problem**: Using complex patterns for replacement can be inefficient.
* **Solution**:
  * Use `Matcher.appendReplacement()` and `Matcher.appendTail()` for fine-grained control.
  * Precompile the `Pattern` for repeated replacements.

### **8. Profile and Benchmark Regex**

* Use tools like JMH (Java Microbenchmark Harness) to benchmark regex operations.
* Analyze the runtime behavior of regex patterns and optimize accordingly.

### **9. Avoid Using Regex When Simpler Solutions Exist**

* Regex is powerful but can be overkill for simple operations. For example:
  * Use `String.contains()` for simple substring checks.
  * Use `String.split()` for basic splitting instead of regex patterns.

