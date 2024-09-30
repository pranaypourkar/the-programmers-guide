# Multiline String

## 1. Using Text Blocks (Java 15 and above)

```java
String s = """
           text
           text
           text
           """;
```

## 2. Using + Operator

```java
String s = "Some text 1,\n"
         + "Some text 2,\n"
         + "Some text 3,\n"
         + "Some text 4,\n"
         + "Some text 5,\n"
         + "Some text 6";
```

## 3. Using StringBuilder

```java
String s = new StringBuilder()
           .append("Some text 1,\n")
           .append("Some text 2,\n")
           .append("Some text 3,\n")
           .append("Some text 5,\n")
           .append("Some text 6,\n")
           .append("Some text 7")
           .toString();
```

## 4. Using String.format()

```java
String s = String.format("%s\n%s\n%s\n%s\n%s\n%s"
         , "Some text 1,"
         , "Some text 2,"
         , "Some text 3,"
         , "Some text 4,"
         , "Some text 5,"
         , "Some text 6"
);
```

## 5. Using String.join()

```java
String s = String.join("\n"
         , "Some text 1,"
         , "Some text 2,"
         , "Some text 3,"
         , "Some text 4,"
         , "Some text 5,"
         , "Some text 6"
);
```

## 6. Using String.concat()

```java
String s= "This is a\n"
           .concat("multiline string\n")
           .concat("using String.concat().");
```



## Comparison

<table data-full-width="true"><thead><tr><th width="201">Method</th><th width="240">Scenario</th><th>Use Case</th></tr></thead><tbody><tr><td><strong>Text Blocks (Java 15+)</strong></td><td>Readability, ease of use, avoiding escape characters</td><td>Defining long, static, multiline strings such as SQL queries, HTML content, JSON, or configuration settings. Ideal for one-time definitions.</td></tr><tr><td><strong>+ Operator</strong></td><td>Simple concatenation, small multiline strings</td><td>Quick concatenation in simple cases, such as building a small multiline string inside a method or loop for logging purposes.</td></tr><tr><td><strong>StringBuilder</strong></td><td>Performance, especially in loops and iterations</td><td>Building multiline strings in loops, iterative concatenation where performance is critical. Use for dynamically constructing strings in iterative processes.</td></tr><tr><td><strong>String.format()</strong></td><td>Formatting with variable substitution</td><td>Creating formatted strings with variables, especially when readability is important. Useful for constructing strings with embedded variables.</td></tr><tr><td><strong>String.join()</strong></td><td>Joining multiple lines from a collection</td><td>Joining multiple strings from a collection or array, often used in cases where you have a list of strings that need to be joined with a delimiter.</td></tr><tr><td><strong>String.concat()</strong></td><td>Chaining method calls, small multiline strings</td><td>Simple chaining of strings when constructing small multiline strings in method chains. Suitable for cases where the number of lines is small and readability is not a major concern.</td></tr></tbody></table>
