# Unnamed Variables & Patterns

## About

We often have to define variables that we don’t even need. Common examples include exceptions, lambda parameters, and patterns. In Java, unnamed variables and patterns are features introduced to make the code more concise, readable, and expressive.

In the following example, we do not use some of the variables.

```java
try {
  int number = Integer.parseInt(someString);
} catch (NumberFormatException e) {
  System.err.println("Not a number my friend");
}
```

```java
map.computeIfAbsent(key, k -> new ArrayList<>()).add(value);
```

```java
if (object instanceof Path(Position(int x1, int y1), Position pos)) {
  System.out.printf("object is a path starting at x = %d, y = %d%n", x1, y1));
}
```

## Unnamed Variables

Unnamed variables, sometimes referred to as "var placeholders" or "underscore variables," are used to ignore certain values in destructuring patterns or lambda expressions where the values are not needed. This feature is inspired by similar capabilities in other languages like Python and Scala.

### Example of Unnamed Variables

```java
import java.util.List;

public class UnnamedVariableExample {
    public static void main(String[] args) {
        List.of("John", "Doe", "Jane", "Smith")
            .forEach((var _) -> System.out.println("Hello, World!"));
    }
}
```

```java
try {
  int number = Integer.parseInt(someString);
} catch (NumberFormatException _) {
  System.err.println("Not a number my friend");
}
```

```java
map.computeIfAbsent(key, _ -> new ArrayList<>()).add(value);
```

## Patterns

Patterns in Java are a part of the broader pattern matching feature, which aims to enhance Java's ability to decompose data structures and make decisions based on their contents. Pattern matching simplifies the process of querying complex data structures and applying transformations.

### **Example of Patterns**

Pattern matching for `instanceof` was introduced in Java 16, which allows to match a value against a type and, if the match is successful, bind it to a variable.

#### **Traditional `instanceof` Check:**

```java
Object obj = "Hello, World!";
if (obj instanceof String) {
    String str = (String) obj;
    System.out.println(str.toUpperCase());
}
```

#### Pattern Matching `instanceof`:

```java
Object obj = "Hello, World!";
if (obj instanceof String str) {
    System.out.println(str.toUpperCase());
}
```

In this example, the `instanceof` check not only checks if `obj` is an instance of `String` but also binds it to the variable `str` if the check passes.

#### Benefits of Patterns:

1. **Conciseness**: Reduces boilerplate code by eliminating the need for explicit casting.
2. **Readability**: Improves readability by clearly indicating the type check and variable binding in a single line.
3. **Safety**: Reduces the risk of `ClassCastException` by combining type checking and casting.
