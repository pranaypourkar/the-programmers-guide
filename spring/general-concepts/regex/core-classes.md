# Core Classes

## About

Regex (Regular Expressions) is a declarative syntax for **matching patterns in strings**. In Java, regex support is provided in the `java.util.regex` package, which includes two key classes:

* `Pattern` – represents the compiled regex expression
* `Matcher` – applies the pattern to a given input string

These classes offer robust methods to match, extract, validate, and transform strings based on specific patterns.

## 1. Class: `java.util.regex.Pattern`

Used to **compile** a regex string into a `Pattern` object that can be reused for matching against multiple inputs.

#### Common Methods

<table><thead><tr><th width="277.20745849609375">Method</th><th>Description</th></tr></thead><tbody><tr><td><code>compile(String regex)</code></td><td>Compiles a regular expression</td></tr><tr><td><code>compile(String regex, flags)</code></td><td>Compiles regex with modifiers (e.g., case-insensitive)</td></tr><tr><td><code>matcher(CharSequence input)</code></td><td>Returns a <code>Matcher</code> for input</td></tr><tr><td><code>split(CharSequence input)</code></td><td>Splits a string using the pattern</td></tr><tr><td><code>splitAsStream(CharSequence)</code></td><td>Splits string and returns a stream (Java 8+)</td></tr><tr><td><code>pattern()</code></td><td>Returns the regex string used to compile the pattern</td></tr></tbody></table>

#### Example:

```java
Pattern pattern = Pattern.compile("\\d+");
Matcher matcher = pattern.matcher("Order 123 shipped on 2024-06-21");
```

## 2. Class: `java.util.regex.Matcher`

Applies a `Pattern` to a specific input and provides methods to **check matches**, **extract groups**, and **replace content**.

#### Common Methods

<table><thead><tr><th width="216.9600830078125">Method</th><th>Description</th></tr></thead><tbody><tr><td><code>matches()</code></td><td>Returns true if entire input matches pattern</td></tr><tr><td><code>find()</code></td><td>Returns true if any subsequence matches pattern</td></tr><tr><td><code>group()</code></td><td>Returns the last matched group</td></tr><tr><td><code>group(int)</code></td><td>Returns specific capturing group</td></tr><tr><td><code>start()</code></td><td>Start index of current match</td></tr><tr><td><code>end()</code></td><td>End index of current match</td></tr><tr><td><code>replaceAll(String)</code></td><td>Replaces all matches with given replacement</td></tr><tr><td><code>replaceFirst(String)</code></td><td>Replaces first match</td></tr><tr><td><code>lookingAt()</code></td><td>Returns true if beginning of input matches pattern</td></tr><tr><td><code>reset()</code></td><td>Resets matcher for a new input</td></tr></tbody></table>

#### Key Concepts

#### `matches()` vs `find()` vs `lookingAt()`

<table><thead><tr><th width="264.8116455078125">Method</th><th>Description</th></tr></thead><tbody><tr><td><code>matches()</code></td><td>Checks if the <strong>entire string</strong> matches the pattern</td></tr><tr><td><code>find()</code></td><td>Finds <strong>next matching subsequence</strong></td></tr><tr><td><code>lookingAt()</code></td><td>Checks if the <strong>start of the string</strong> matches</td></tr></tbody></table>

#### Examples

#### 1. Check Full Match

```java
Pattern pattern = Pattern.compile("hello");
Matcher matcher = pattern.matcher("hello");
System.out.println(matcher.matches()); // true
```

#### 2. Find Substring Matches

```java
Pattern pattern = Pattern.compile("\\d+");
Matcher matcher = pattern.matcher("Order123 and Ref456");

while (matcher.find()) {
    System.out.println("Found number: " + matcher.group());
}
```

#### 3. Extract Groups

```java
String text = "Name: John, Age: 30";
Pattern pattern = Pattern.compile("Name: (\\w+), Age: (\\d+)");
Matcher matcher = pattern.matcher(text);

if (matcher.find()) {
    System.out.println("Name: " + matcher.group(1));
    System.out.println("Age: " + matcher.group(2));
}
```

#### 4. Replace All

```java
Pattern pattern = Pattern.compile("\\d+");
Matcher matcher = pattern.matcher("Order 123 and 456");
String result = matcher.replaceAll("###");
System.out.println(result); // "Order ### and ###"
```

## 3. Flags (Modifiers)

`Pattern.compile(regex, flag)` allows you to control behavior.

<table><thead><tr><th width="107.337646484375">Flag</th><th>Constant</th><th>Purpose</th></tr></thead><tbody><tr><td><code>(?i)</code></td><td><code>Pattern.CASE_INSENSITIVE</code></td><td>Ignore case</td></tr><tr><td><code>(?m)</code></td><td><code>Pattern.MULTILINE</code></td><td><code>^</code> and <code>$</code> match line start/end</td></tr><tr><td><code>(?s)</code></td><td><code>Pattern.DOTALL</code></td><td><code>.</code> matches newlines</td></tr><tr><td><code>(?x)</code></td><td><code>Pattern.COMMENTS</code></td><td>Ignore whitespace in pattern</td></tr></tbody></table>

#### Example:

```java
Pattern pattern = Pattern.compile("hello", Pattern.CASE_INSENSITIVE);
```

## 4. Utility Methods using Regex (outside Matcher)

### String.matches()

```java
boolean valid = "12345".matches("\\d+"); // true
```

* Equivalent to: `Pattern.compile(regex).matcher(input).matches()`

### String.replaceAll()

```java
String clean = "abc123".replaceAll("\\d", ""); // "abc"
```

### String.split()

```java
String[] parts = "A,B,C".split(",");
```

## Common Use Cases in String Processing

<table><thead><tr><th width="202.58074951171875">Task</th><th>Method</th></tr></thead><tbody><tr><td>Validate input</td><td><code>Pattern.matcher().matches()</code></td></tr><tr><td>Extract values</td><td><code>Matcher.find()</code> and <code>group()</code></td></tr><tr><td>Sanitize text</td><td><code>String.replaceAll()</code></td></tr><tr><td>Search in logs</td><td><code>Files.lines().filter(line -> line.matches())</code></td></tr><tr><td>Conditional parsing</td><td>Use groups for logic-based extraction</td></tr><tr><td>Masking sensitive data</td><td><code>replaceAll("password=.*", "password=***")</code></td></tr></tbody></table>
