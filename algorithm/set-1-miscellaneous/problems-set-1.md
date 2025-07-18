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

## Medium

### Implement a method rand7() given rand5( )

Given a method that generates a random number between O and 4 (inclusive), write a method that generates a random number between O and 6 (inclusive).

We want to **generate a uniform distribution over 7 numbers (0 to 6)** using a generator that gives us **5 numbers (0 to 4)**.

The basic idea is:

1. Combine two calls to `rand5()` to generate a larger range that includes at least 7 values.
2. Reject values that are outside a clean multiple of 7 to preserve uniformity.

Use **base-5 expansion**:

* `rand5()` gives a **random integer between 0 and 4** (i.e., 5 outcomes).
* `rand7()` should give a **random integer between 0 and 6** (i.e., 7 outcomes).

But 5 can’t divide 7 evenly — so we need **more randomness** than a single call to `rand5()` can give.

By calling `rand5()` twice, we can generate **more combinations**.

Each `rand5()` has 5 values → so two calls give us:

```
Total combinations = 5 * 5 = 25
```

We want to generate a **uniform integer from 0 to 24**, which gives us **25 possible values**.

Now, how do we combine the two `rand5()` calls to get those values?

#### Let’s take this:

```java
int num = 5 * rand5() + rand5();
```

Assume:

* First call to `rand5()` → returns `a` (0 to 4)
* Second call to `rand5()` → returns `b` (0 to 4)

Then:

```java
num = 5 * a + b
```

| a   | b   | 5 \* a + b |
| --- | --- | ---------- |
| 0   | 0   | 0          |
| 0   | 1   | 1          |
| 0   | 2   | 2          |
| 0   | 3   | 3          |
| 0   | 4   | 4          |
| 1   | 0   | 5          |
| 1   | 1   | 6          |
| ... | ... | ...        |
| 4   | 4   | 24         |

So this gives us all numbers **from 0 to 24**, equally likely.

```java
import java.util.Random;

public class Rand7FromRand5 {

    static Random random = new Random();

    // Provided rand5() function (returns 0–4)
    public static int rand5() {
        return random.nextInt(5);
    }

    public static int rand7() {
        while (true) {
            int num = 5 * rand5() + rand5(); // Generates number in range 0 to 24
            if (num < 21) {
                return num % 7; // Maps to 0 to 6 uniformly
            }
            // else, reject and retry
        }
    }

    public static void main(String[] args) {
        int[] count = new int[7];
        for (int i = 0; i < 70000; i++) {
            count[rand7()]++;
        }
        for (int i = 0; i < 7; i++) {
            System.out.println(i + " → " + count[i]);
        }
    }
}
```



