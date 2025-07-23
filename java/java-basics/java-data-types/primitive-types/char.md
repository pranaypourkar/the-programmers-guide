# char

## About

* **Definition:** `char` is a Java primitive data type used to store **single 16-bit Unicode characters**.
* **Size:** Occupies **2 bytes** (16 bits) of memory.
  * This is because Java uses the **UTF-16 encoding** to support a wide range of Unicode characters.
* **Value Range:** `char` can represent any **unsigned** value between `0` and `65535` (`'\u0000'` to `'\uffff'`).
* **Default Value:** The default value for `char` is `'\u0000'` (null character).
* **Wrapper Class:** The wrapper class for `char` is `Character`, located in `java.lang`.

## **Characteristics**

1. **Single Character Representation:**
   * Can represent any character, including alphabets, digits, symbols, or special Unicode characters.
   * E.g., `'A'`, `'1'`, `'#'`, `'\n'`.
2. **Integral Type (Unsigned):** Internally treated as an **unsigned integer** and can participate in arithmetic operations.
3. **Immutable:** Once assigned, the value of a `char` cannot be altered unless explicitly reassigned.
4. **Unicode Compatibility:**
   * Fully supports **16-bit Unicode** for global character representation.
   * Allows the use of **escape sequences** like `'\uXXXX'` to define characters.
5.  **Integral Representation:** Each `char` is a numeric value. For example:

    ```java
    char c = 'A'; // 65 in ASCII
    char d = (char) (c + 1); // 'B'
    ```
6. **Control Characters:** Special characters like `'\n'` (newline), `'\t'` (tab), and `'\r'` (carriage return).
7. **Memory Usage:** Fixed at **2 bytes** because it uses **UTF-16** encoding.
8. **Char Arrays:** Arrays of `char` are commonly used for string manipulation.

## **Operations with `char`**

<table data-header-hidden data-full-width="true"><thead><tr><th width="239"></th><th width="238"></th><th></th></tr></thead><tbody><tr><td><strong>Operation</strong></td><td><strong>Example</strong></td><td><strong>Description</strong></td></tr><tr><td>Arithmetic Operations</td><td><code>'A' + 1</code></td><td>Results in <code>'B'</code> (Numeric addition).</td></tr><tr><td>Comparison Operations</td><td><code>'A' > 'a'</code></td><td>Compares the Unicode values of characters.</td></tr><tr><td>Type Casting to Int</td><td><code>(int) 'A'</code></td><td>Converts <code>char</code> to its Unicode integer value.</td></tr><tr><td>Escape Sequences</td><td><code>'\n'</code>, <code>'\t'</code>, <code>'\u0041'</code></td><td>Represents special or Unicode characters.</td></tr></tbody></table>

## **Conversion Methods**

<table data-header-hidden data-full-width="true"><thead><tr><th width="241"></th><th width="349"></th><th></th></tr></thead><tbody><tr><td><strong>Conversion</strong></td><td><strong>Method</strong></td><td><strong>Example</strong></td></tr><tr><td><code>char</code> to <code>String</code></td><td><code>Character.toString(c)</code> or <code>String.valueOf(c)</code></td><td><code>String.valueOf('A')</code> → <code>"A"</code></td></tr><tr><td><code>String</code> to <code>char</code></td><td><code>string.charAt(index)</code></td><td><code>"Hello".charAt(0)</code> → <code>'H'</code></td></tr><tr><td><code>char</code> to <code>int</code></td><td><code>(int) c</code></td><td><code>(int) 'A'</code> → <code>65</code></td></tr><tr><td><code>int</code> to <code>char</code></td><td><code>(char) i</code></td><td><code>(char) 65</code> → <code>'A'</code></td></tr><tr><td>Upper/Lower Case Conversion</td><td><code>Character.toUpperCase(c)</code> / <code>toLowerCase(c)</code></td><td><code>Character.toLowerCase('A')</code> → <code>'a'</code></td></tr></tbody></table>

### **Wrapper Class `Character`**

The `Character` class provides utilities for working with `char`.

**Key Features:**

1. **Constants:**
   * `Character.MIN_VALUE`: `'\u0000'`.
   * `Character.MAX_VALUE`: `'\uffff'`.
2. **Static Methods:**
   * `Character.isDigit(char c)`: Checks if the character is a digit.
   * `Character.isLetter(char c)`: Checks if the character is a letter.
   * `Character.isUpperCase(char c)`: Checks if it’s uppercase.
   * `Character.isWhitespace(char c)`: Checks if it’s a whitespace character.

## **Common Mistakes**

1. **Using Strings Instead of `char`:**
   * `'A'` (char) ≠ `"A"` (String).
2. **Casting Beyond Valid Range:** Casting large integers to `char` can lead to unexpected results due to wrapping.
3. **Treating `char` as Boolean:** Avoid using characters like `'Y'` or `'N'` as substitutes for `true`/`false`

## Examples

### Basic example

```java
char letter = 'A';
char digit = '5';
char symbol = '#';

System.out.println("Letter: " + letter);
System.out.println("Digit: " + digit);
System.out.println("Symbol: " + symbol);

// Arithmetic operation
System.out.println("Next letter: " + (char) (letter + 1)); // 'B'
```

### **Using `char` with Loops**

```java
public class CharLoopExample {
    public static void main(String[] args) {
        for (char c = 'A'; c <= 'Z'; c++) {
            System.out.print(c + " ");
        }
    }
}
```

### **Working with Unicode Characters**

```java
public class UnicodeExample {
    public static void main(String[] args) {
        char smiley = '\u263A'; // Unicode for ☺
        System.out.println("Smiley: " + smiley);
    }
}
```

### **Using `char` in Arrays**

```java
public class CharArrayExample {
    public static void main(String[] args) {
        char[] vowels = {'A', 'E', 'I', 'O', 'U'};

        for (char vowel : vowels) {
            System.out.println(vowel);
        }
    }
}
```

### **String Manipulation with `char`**

```java
public class StringCharExample {
    public static void main(String[] args) {
        String name = "Hello";
        char firstChar = name.charAt(0);
        System.out.println("First Character: " + firstChar);
    }
}
```

### **Using `char` with Streams**

```java
import java.util.stream.IntStream;

public class CharStreamExample {
    public static void main(String[] args) {
        String text = "Hello World";
        text.chars()
            .mapToObj(c -> (char) c)
            .forEach(System.out::println);
    }
}
```

### **Custom Character Validation**

```java
public class CharValidation {
    public static void main(String[] args) {
        char c = '9';

        if (Character.isDigit(c)) {
            System.out.println(c + " is a digit.");
        } else if (Character.isLetter(c)) {
            System.out.println(c + " is a letter.");
        } else {
            System.out.println(c + " is neither a digit nor a letter.");
        }
    }
}
```







