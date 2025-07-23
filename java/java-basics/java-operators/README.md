# Operators

## About

Operators in Java are special symbols or keywords that perform operations on variables and values. They are the building blocks of expressions and help in performing tasks such as arithmetic, comparison, assignment, logical evaluation, and more.

Operators are used in almost every Java program — from simple mathematical calculations to complex logical evaluations. Understanding them is essential for writing correct and efficient code.

## **Key Points**

* Java automatically handles **operator precedence**, but we can use parentheses to control evaluation order.
* `==` compares values for primitives, and object references for objects. Use `.equals()` for object content comparison.
* Avoid using bitwise operators unless we understand binary operations.
* Ternary operators can reduce code but should be used for simple conditions only.

#### **Types of Operators in Java**

Java provides several categories of operators:

## **1. Arithmetic Operators**

Used to perform basic mathematical operations.

| Operator | Description        | Example | Result         |
| -------- | ------------------ | ------- | -------------- |
| `+`      | Addition           | `a + b` | Sum of a and b |
| `-`      | Subtraction        | `a - b` | Difference     |
| `*`      | Multiplication     | `a * b` | Product        |
| `/`      | Division           | `a / b` | Quotient       |
| `%`      | Modulo (Remainder) | `a % b` | Remainder      |

**Example:**

```java
int a = 10, b = 3;
System.out.println(a + b); // 13
System.out.println(a % b); // 1
```

## **2. Relational (Comparison) Operators**

Used to compare two values and return a boolean (`true` or `false`).

| Operator | Description      | Example  |
| -------- | ---------------- | -------- |
| `==`     | Equal to         | `a == b` |
| `!=`     | Not equal to     | `a != b` |
| `>`      | Greater than     | `a > b`  |
| `<`      | Less than        | `a < b`  |
| `>=`     | Greater or equal | `a >= b` |
| `<=`     | Less or equal    | `a <= b` |

**Example:**

```java
int age = 20;
System.out.println(age >= 18); // true
```

## **3. Logical Operators**

Used to combine multiple boolean expressions.

| Operator | Description | Example           |
| -------- | ----------- | ----------------- |
| `&&`     | Logical AND | `a > 5 && b < 10` |
| `!`      | Logical NOT | `!(a > 5)`        |

**Example:**

```java
boolean isAdult = age >= 18;
boolean hasLicense = true;
System.out.println(isAdult && hasLicense); // true
```

## **4. Assignment Operators**

Used to assign values to variables.

| Operator | Description         | Example  | Meaning       |
| -------- | ------------------- | -------- | ------------- |
| `=`      | Assign              | `a = 5`  | Assign 5 to a |
| `+=`     | Add and assign      | `a += 3` | `a = a + 3`   |
| `-=`     | Subtract and assign | `a -= 2` | `a = a - 2`   |
| `*=`     | Multiply and assign | `a *= 4` | `a = a * 4`   |
| `/=`     | Divide and assign   | `a /= 2` | `a = a / 2`   |
| `%=`     | Modulo and assign   | `a %= 3` | `a = a % 3`   |

**Example:**

```java
int a = 10;
a += 5; // a is now 15
```

## **5. Unary Operators**

Operate on a single operand.

| Operator | Description        | Example      |
| -------- | ------------------ | ------------ |
| `+`      | Unary plus         | `+a`         |
| `-`      | Unary minus        | `-a`         |
| `++`     | Increment          | `a++`, `++a` |
| `--`     | Decrement          | `a--`, `--a` |
| `!`      | Logical complement | `!flag`      |

**Note:**

* `a++` (post-increment) returns the value then increments
* `++a` (pre-increment) increments then returns the value

## **6. Bitwise Operators**

Used for bit-level operations on integers.

| Operator | Description          | Example   |
| -------- | -------------------- | --------- |
| `&`      | Bitwise AND          | `a & b`   |
| `\|`     | Bitwise OR           | `a \| b`  |
| `^`      | Bitwise XOR          | `a ^ b`   |
| `~`      | Bitwise complement   | `~a`      |
| `<<`     | Left shift           | `a << 2`  |
| `>>`     | Right shift          | `a >> 2`  |
| `>>>`    | Unsigned right shift | `a >>> 2` |

**Example:**

```java
int a = 5;  // 0101 in binary
int b = 3;  // 0011 in binary
System.out.println(a & b); // 1
```

## **7. Ternary Operator**

A shorthand form of if-else condition.

| Operator | Description         | Example         |
| -------- | ------------------- | --------------- |
| `? :`    | Ternary conditional | `a > b ? a : b` |

**Example:**

```java
int max = (a > b) ? a : b;
```

## **8. instanceof Operator**

Checks if an object is an instance of a specific class or interface.

**Example:**

```java
String name = "John";
System.out.println(name instanceof String); // true
```

## **9. Type Cast Operator**

Used to convert one data type to another.

**Example:**

```java
double price = 99.99;
int intPrice = (int) price; // 99
```
