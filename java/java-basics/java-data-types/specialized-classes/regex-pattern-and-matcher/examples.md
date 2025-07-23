# Examples

## Check a given string regex pattern is valid or not

```java
 try {
    // Try to compile the regex pattern
    Pattern.compile(patternString);
    System.out.println("Valid");
 } catch (PatternSyntaxException e) {
    // If there's a syntax error, catch it and print Invalid
    System.out.println("Invalid");
 }
```

## Simple Matching

### **Matching a phone number**

* Regex: `\\d{3}-\\d{3}-\\d{4}`

```java
import java.util.regex.*;

public class SimpleMatchingExample {
    public static void main(String[] args) {
        Pattern pattern = Pattern.compile("\\d{3}-\\d{3}-\\d{4}");
        Matcher matcher = pattern.matcher("My phone number is 123-456-7890.");
        
        if (matcher.find()) {
            System.out.println("Phone number found: " + matcher.group()); //Phone number found: 123-456-7890
        } else {
            System.out.println("No phone number found.");
        }
    }
}
```

### Lookaheads and Lookbehinds

{% hint style="success" %}
Lookahead and lookbehind are zero-width assertions that allow you to match patterns based on what comes before or after a string without consuming characters.

* **Lookahead** (`(?=...)`): Ensures a match is followed by a specific pattern.
* **Negative Lookahead** (`(?!...)`): Ensures a match is not followed by a specific pattern.
* **Lookbehind** (`(?<=...)`): Ensures a match is preceded by a specific pattern.
* **Negative Lookbehind** (`(?<!...)`): Ensures a match is not preceded by a specific pattern.
{% endhint %}

#### **Lookahead Example**

Match a word that is followed by a specific pattern (e.g., match the word "apple" only if it’s followed by "pie").

```java
Pattern pattern = Pattern.compile("apple(?= pie)");
Matcher matcher = pattern.matcher("I like apple pie and apple juice.");

while (matcher.find()) {
    System.out.println("Matched: " + matcher.group()); //Matched: apple
}
```

**Negative Lookahead Example**

Match the word "apple" only if it is **not** followed by "pie".

```java
Pattern pattern = Pattern.compile("apple(?! pie)");
Matcher matcher = pattern.matcher("I like apple pie and apple juice.");

while (matcher.find()) {
    System.out.println("Matched: " + matcher.group()); //Matched: apple
}
```

**Lookbehind Example**

Match a word that is preceded by a specific pattern (e.g., match "pie" only if it is preceded by "apple").

```java
Pattern pattern = Pattern.compile("(?<=apple )pie");
Matcher matcher = pattern.matcher("I like apple pie and apple juice.");

while (matcher.find()) {
    System.out.println("Matched: " + matcher.group()); //Matched: pie
}
```

**Negative Lookbehind Example**

Match "pie" only if it is **not** preceded by "apple".

```java
Pattern pattern = Pattern.compile("(?<!apple )pie");
Matcher matcher = pattern.matcher("I like cherry pie and apple pie.");

while (matcher.find()) {
    System.out.println("Matched: " + matcher.group()); //Matched: pie
}
```



## Capturing Groups

{% hint style="success" %}
Capturing groups allow us to extract specific portions of a matched string.
{% endhint %}

### Match a date in the format `MM/DD/YYYY` and extract the month, day, and year.

```java
Pattern pattern = Pattern.compile("(\\d{2})/(\\d{2})/(\\d{4})");
Matcher matcher = pattern.matcher("The date is 12/25/2024.");

if (matcher.find()) {
    System.out.println("Month: " + matcher.group(1)); //12
    System.out.println("Day: " + matcher.group(2)); //25
    System.out.println("Year: " + matcher.group(3)); //2024
}
```

### Named Capturing Groups to extract month, day, and year.

We can name capturing groups for easier access.

```java
Pattern pattern = Pattern.compile("(?<month>\\d{2})/(?<day>\\d{2})/(?<year>\\d{4})");
Matcher matcher = pattern.matcher("The date is 12/25/2024.");

if (matcher.find()) {
    System.out.println("Month: " + matcher.group("month")); //12
    System.out.println("Day: " + matcher.group("day")); //25
    System.out.println("Year: " + matcher.group("year")); //2024
}
```

### Nested Capturing Groups to extract first and last names from full name

Match a full name and extract first and last names.

```java
Pattern pattern = Pattern.compile("(\\w+) (\\w+)");
Matcher matcher = pattern.matcher("John Doe");

if (matcher.find()) {
    System.out.println("First Name: " + matcher.group(1)); //John
    System.out.println("Last Name: " + matcher.group(2)); //Doe
}
```

## Replacing Text

{% hint style="success" %}
The `Matcher.replaceAll()` and `Matcher.replaceFirst()` methods allow us to replace matched text in the input string.
{% endhint %}

### Replace all instances of the word "apple" with "orange"

```java
Pattern pattern = Pattern.compile("apple");
Matcher matcher = pattern.matcher("I like apple pie and apple juice.");

String result = matcher.replaceAll("orange");
System.out.println(result); // I like orange pie and orange juice.
```

### Using Groups in Replacement to reverse the order of the first and last names

```java
Pattern pattern = Pattern.compile("(\\w+) (\\w+)");
Matcher matcher = pattern.matcher("John Doe");

String result = matcher.replaceAll("$2, $1");
System.out.println(result); //Doe, John
```

### **Conditional Replacement with a Function to** transform the text

Using `replaceAll()` with a function, we can conditionally transform the text.

```java
Pattern pattern = Pattern.compile("\\d+");
Matcher matcher = pattern.matcher("I have 12 apples and 5 bananas.");

String result = matcher.replaceAll(match -> {
    return Integer.parseInt(match.group()) * 2 + "";
});
System.out.println(result); //I have 24 apples and 10 bananas.
```

## Practical Use Cases

### **1. Validating Email Addresses**

A common use case is validating whether an email address is in a valid format.

```java
Pattern pattern = Pattern.compile("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$");
Matcher matcher = pattern.matcher("test@example.com");

if (matcher.matches()) {
    System.out.println("Valid email address."); //Valid email address.
} else {
    System.out.println("Invalid email address.");
}
```

### **2. Parsing URLs**

Extract different components from a URL, such as the protocol, domain, and path.

```java
Pattern pattern = Pattern.compile("(https?)://([a-zA-Z0-9.-]+)(/[^\\s]*)?");
Matcher matcher = pattern.matcher("https://www.example.com/path/to/resource");

if (matcher.find()) {
    System.out.println("Protocol: " + matcher.group(1)); //https
    System.out.println("Domain: " + matcher.group(2)); //www.example.com
    System.out.println("Path: " + matcher.group(3)); ///path/to/resource
}
```

### **3. Data Extraction from Logs**

Extract specific error codes from log files.

```java
Pattern pattern = Pattern.compile("ERROR \\[(\\d{3})\\]");
Matcher matcher = pattern.matcher("ERROR [404] Not Found");

if (matcher.find()) {
    System.out.println("Error Code: " + matcher.group(1)); //Error Code: 404
}
```

### **4. Extracting Dates from Text**

Find and extract all dates from a text that follow the pattern `MM-DD-YYYY`.

```java
Pattern pattern = Pattern.compile("(\\d{2})-(\\d{2})-(\\d{4})");
Matcher matcher = pattern.matcher("Important dates: 12-25-2024, 01-01-2025, and 05-15-2025.");

while (matcher.find()) {
    System.out.println("Found date: " + matcher.group());
}
```

**Output:**

```bash
Found date: 12-25-2024
Found date: 01-01-2025
Found date: 05-15-2025
```

