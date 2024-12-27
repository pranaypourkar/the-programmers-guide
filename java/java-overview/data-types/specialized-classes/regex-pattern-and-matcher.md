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

<table data-header-hidden data-full-width="true"><thead><tr><th width="155"></th><th></th></tr></thead><tbody><tr><td><strong>Symbol</strong></td><td><strong>Description</strong></td></tr><tr><td><strong>.</strong></td><td>Matches any single character except a newline.</td></tr><tr><td><strong>\d</strong></td><td>Matches a digit (equivalent to <code>[0-9]</code>).</td></tr><tr><td><strong>\D</strong></td><td>Matches a non-digit (equivalent to <code>[^0-9]</code>).</td></tr><tr><td><strong>\w</strong></td><td>Matches a word character (alphanumeric or <code>_</code>).</td></tr><tr><td><strong>\W</strong></td><td>Matches a non-word character (opposite of <code>\w</code>).</td></tr><tr><td><strong>\s</strong></td><td>Matches a whitespace character (spaces, tabs, newlines).</td></tr><tr><td><strong>\S</strong></td><td>Matches a non-whitespace character.</td></tr><tr><td><strong>^</strong></td><td>Matches the beginning of a line or string.</td></tr><tr><td><strong>$</strong></td><td>Matches the end of a line or string.</td></tr><tr><td><strong>\b</strong></td><td>Matches a word boundary.</td></tr><tr><td><strong>\B</strong></td><td>Matches a position that is not a word boundary.</td></tr><tr><td><strong>[...]</strong></td><td>Matches any character inside the brackets (e.g., <code>[abc]</code> matches "a", "b", or "c").</td></tr><tr><td><strong>[^...]</strong></td><td>Matches any character NOT inside the brackets (e.g., <code>[^abc]</code> matches anything except "a", "b", or "c").</td></tr><tr><td><strong>?</strong></td><td>Matches 0 or 1 occurrence of the preceding element.</td></tr><tr><td><strong>*</strong></td><td>Matches 0 or more occurrences of the preceding element (greedy).</td></tr><tr><td><strong>+</strong></td><td>Matches 1 or more occurrences of the preceding element (greedy).</td></tr><tr><td><strong>{n}</strong></td><td>Matches exactly <code>n</code> occurrences of the preceding element.</td></tr><tr><td><strong>{n,}</strong></td><td>Matches at least <code>n</code> occurrences of the preceding element.</td></tr><tr><td><strong>{n,m}</strong></td><td>Matches between <code>n</code> and <code>m</code> occurrences of the preceding element.</td></tr><tr><td><strong>(?=...)</strong></td><td>Positive lookahead: Ensures that a certain pattern follows.</td></tr><tr><td><strong>(?!...)</strong></td><td>Negative lookahead: Ensures that a certain pattern does NOT follow.</td></tr><tr><td><strong>(?&#x3C;=...)</strong></td><td>Positive lookbehind: Ensures that a certain pattern precedes.</td></tr><tr><td><strong>(?&#x3C;!...)</strong></td><td>Negative lookbehind: Ensures that a certain pattern does NOT precede.</td></tr><tr><td><strong>\</strong></td><td>Escapes special characters (e.g., <code>\\.</code> matches a literal dot).</td></tr><tr><td>**</td><td>**</td></tr></tbody></table>



