# Problems - Set 1

## Easy

### FizzBuzz

Given a positive integer A, return an array of strings with all the integers from 1 to N.\
But for multiples of **3** the array should have “Fizz” instead of the number.\
For the multiples of **5**, the array should have “Buzz” instead of the number.\
For numbers which are multiple of **3** and **5** both, the array should have “FizzBuzz” instead of the number.

Example:

```
A = 5
Return: [1 2 Fizz 4 Buzz]
```

#### Method 1 - Using loop and if else

```java
ArrayList<String> list = new ArrayList<>();

for (int i = 1; i <= A; i++) {
    if (i % 3 == 0 && i % 5 == 0) {
        list.add("FizzBuzz");
            } else if (i % 3 == 0) {
        list.add("Fizz");
            } else if (i % 5 == 0) {
        list.add("Buzz");
            } else {
        list.add(String.valueOf(i));
    }
}
```

#### Method 2 - **Using StringBuilder for String Concatenation**

Instead of performing multiple concatenations using `+` inside the `if` conditions, use a `StringBuilder` to construct the strings. This can improve performance when dealing with large datasets.

```java
ArrayList<String> list = new ArrayList<>();

for (int i = 1; i <= A; i++) {
    StringBuilder sb = new StringBuilder();
    if (i % 3 == 0) sb.append("Fizz");
    if (i % 5 == 0) sb.append("Buzz");
    list.add(sb.length() > 0 ? sb.toString() : String.valueOf(i));
}
```

#### Method 3 - **Using Streams (Java 8+)**

If we want to use a more functional programming style, we can leverage Java Streams.

```java
List<String> list = IntStream.rangeClosed(1, A)
    .mapToObj(i -> i % 3 == 0 && i % 5 == 0 ? "FizzBuzz" :
                 i % 3 == 0 ? "Fizz" :
                 i % 5 == 0 ? "Buzz" : String.valueOf(i))
    .collect(Collectors.toList());
```

### Store and calculate mathematical expression

Write a function to add one simple mathematical expressions which are of the form Ax^a + Bx^b + . . . (where the coefficients and exponents can be any positive or negative real number). Store the input values into a proper data structure.

#### Method 1: Bad Implementation

```java
// Store the expression as a single array of doubles, where the kth element
// corresponds to the coefficient of the x^k term in the expression.
// It does not support expressions with negative or non-integer exponents.
int[] sum(double[] expr1) {
    ...
}

// Store the expression as a set of two arrays, c oefficients and exponents
sum(double[] coeffsl, double[] expon1) {
    ...
}
```

#### Method 2: Better Implementation

```java
// Design data structure for the expression
class ExprTerm {
    double coefficient;
    double exponent;
}

ExprTerm[] sum(ExprTerm[] exprl) {
    ...    
}
```







