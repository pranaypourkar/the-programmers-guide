# boolean

## About

* **Definition:** `boolean` is a primitive data type in Java used to represent one of two values: `true` or `false`.
* **Usage:** It is primarily used for **conditional logic** (e.g., `if` statements, loops, and logical expressions).
* **Size:** `boolean` is **not explicitly defined** to occupy a specific number of bits in memory by the Java specification, though many implementations use **1 byte**.
* **Default Value:** The default value of `boolean` is `false`.
* **Wrapper Class:** `Boolean` is the wrapper class for `boolean` in the `java.lang` package, which allows `boolean` values to be used in collections and provides utility methods.

{% hint style="info" %}
`boolean` is a primitive and does not accept `null`. Use `Boolean` instead.
{% endhint %}

## **Characteristics**

1. **Two Possible Values Only:** The only valid values are `true` and `false`.
2. **Not Numeric:** Unlike C/C++, Java does not allow `boolean` to be treated as an integer (e.g., `true` ≠ `1` and `false` ≠ `0`).
3. **Cannot Be Cast to Other Types:** No direct or indirect casting to/from `boolean` and numeric or other types is allowed.
4. **Control Flow:** It is foundational for control flow constructs (`if`, `while`, `do-while`, `for`, etc.).
5. **Immutable:** The value of a `boolean` variable cannot be altered directly; a new assignment is needed.
6. **Logical Operations Support:** Works with logical operators like `&&`, `||`, and `!` for combining and negating conditions.

## **Memory and Implementation Details**

* **Memory Usage:** Though not standardized, the JVM typically allocates **1 byte** for a `boolean` variable (smallest addressable unit of memory).
* **Boolean Arrays:** Boolean arrays may use **1 bit per value** internally (optimized by JVM), though this varies by implementation.

## **Operations with `boolean`**

### **Logical Operators**

| **Operator** | **Name**    | **Example**     | **Result** |
| ------------ | ----------- | --------------- | ---------- |
| `&&`         | Logical AND | `true && false` | `false`    |
| \`           |             | \`              | Logical OR |
| `!`          | Logical NOT | `!true`         | `false`    |
| `^`          | Logical XOR | `true ^ false`  | `true`     |

### **Comparison Operators**

| **Operator** | **Name**   | **Example** | **Result**                          |
| ------------ | ---------- | ----------- | ----------------------------------- |
| `==`         | Equality   | `a == b`    | Compares two boolean values         |
| `!=`         | Inequality | `a != b`    | Returns true if values are unequal. |

## Examples

### Basic example

```java
boolean isJavaFun = true;
boolean isFishTasty = false;

// Simple If-Else
if (isJavaFun) {
    System.out.println("Java is fun!");
} else {
    System.out.println("Java is not fun.");
}

// Combining Logical Operations
if (isJavaFun && !isFishTasty) {
    System.out.println("Java is fun, but fish isn't tasty.");
}
```

### **Using `boolean` with streams**

```java
import java.util.Arrays;

public class BooleanStreamExample {
    public static void main(String[] args) {
        // Boolean array
        Boolean[] flags = {true, false, true, false};

        // Count `true` values
        long trueCount = Arrays.stream(flags)
                .filter(Boolean::booleanValue)
                .count();
        System.out.println("Number of true values: " + trueCount);
    }
}
```

### **Using `boolean` with array**

```java
public class BooleanArrayExample {
    public static void main(String[] args) {
        boolean[] flags = new boolean[5]; // Default values are false
        flags[0] = true;
        flags[3] = true;

        for (boolean flag : flags) {
            System.out.println(flag);
        }
    }
}
```



