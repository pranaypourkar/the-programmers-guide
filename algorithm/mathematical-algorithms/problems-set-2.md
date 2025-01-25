# Problems - Set 2

## Easy

### Circular Problem

Determine the position where the A-th item will be delivered in a circle of size B, starting from position C.

{% hint style="success" %}
* **Understanding the Circle Behavior:**
  * The positions are numbered from 1 to B, forming a circle.
  * After B, the numbering wraps around to 1.
*   **Determine the Position:**

    * Starting at position C, we deliver items sequentially.
    * The A-th item is delivered at the position calculated as:

    Position=(C+A−1)%B

    * If the result of the modulo operation is 0, it means the position wraps around to B.
{% endhint %}

```java
public static int findPosition(int A, int B, int C) {
        // Calculate the position
        int position = (C + A - 1) % B;

        // If position is 0, it means we are at the last position in the circle
        return position == 0 ? B : position;
    }
```

### Number Divisibility

Given a  number represent in the form of an integer array **A**, where each element is a digit. We have to find whether there exists any permutation of the array **A** such that the number becomes divisible by 60. Return 1 if it exists, 0 otherwise.

{% hint style="info" %}
#### **Approach**

1. **Check for 0 (Divisibility by 5 and 2)**
   1. The number must contain at least one 0 because the last digit must be 0 for divisibility by 60.
2. **Check for Divisibility by 3:**
   1. Compute the sum of the digits in A.
   2. If the sum is divisible by 3, this condition is satisfied.
3. **Check for an Additional Even Digit:**
   1. Besides the 0 required for divisibility by 5, ensure there is at least one more even digit (2,4,6,8) to satisfy divisibility by 2.
4. Check for edge case like all number 0
{% endhint %}

```java
public static int isDivisibleBy60(int[] A) {
        boolean hasZero = false; // To check if 0 is present
        int sumOfDigits = 0; // Sum of all digits
        int evenCount = 0; // Count of even digits (including 0)
        int nonZeroCount = 0; // Count of non-zero digits

        // Iterate through the array
        for (int digit : A) {
            if (digit == 0) {
                hasZero = true; // Mark that 0 is found
            } else {
                nonZeroCount++; // Count non-zero digits
            }
            if (digit % 2 == 0) {
                evenCount++; // Count even digits
            }
            sumOfDigits += digit; // Add the digit to the sum
        }

        // Special case: All zeros
        if (nonZeroCount == 0) {
            return 1; // A number like 0 or 00 is divisible by 60
        }

        // General case: Check all conditions for divisibility by 60
        if (hasZero && sumOfDigits % 3 == 0 && evenCount > 1) {
            return 1; // A permutation exists that is divisible by 60
        }

        return 0; // No valid permutation exists
    }
```





## Medium



## Difficult

### Powerful Divisors

Given an integer array **A** of length **N**.\
For every integer **X** in the array, we have to find out the number of integers **Y**, such that **1 <= Y <= X**, and the number of divisors of Y is a power of 2.

For example, 6 has the following divisors - \[1, 2, 3, 6]. This is equal to 4, which is a power of 2.\
On the other hand, 9 has the following divisors \[1, 3, 9] which is 3, which is not a power of 2. Return an array containing the answer for every X in the given array.

{% hint style="info" %}
**Example**\
Input 1: A = \[1, 4]

Output 1: \[1, 3]

Input 2: A = \[5, 10]

Output 2: \[4, 8]
{% endhint %}

{% hint style="info" %}
Optimized Approach

We can optimize the code by:

1. Precomputing the divisor counts for all numbers up to the maximum value in the input list.
2. Using a single array to store the count of "powerful divisors" for each number.
3. Reusing computed results instead of recalculating them.
{% endhint %}

```java
import java.util.ArrayList;
import java.util.List;

public class PowerfulDivisors {

    public static List<Integer> powerfulDivisors(ArrayList<Integer> A) {
        // Find the maximum number in the input array
        int maxNumber = A.stream().max(Integer::compare).orElse(0);

        // Precompute divisor counts for all numbers up to maxNumber
        int[] divisorCounts = new int[maxNumber + 1];
        for (int i = 1; i <= maxNumber; i++) {
            for (int j = i; j <= maxNumber; j += i) {
                divisorCounts[j]++;
            }
        }

        // Precompute whether a divisor count is a power of 2
        boolean[] isPowerful = new boolean[maxNumber + 1];
        for (int i = 1; i <= maxNumber; i++) {
            if (isPowerOfTwo(divisorCounts[i])) {
                isPowerful[i] = true;
            }
        }

        // Compute the number of "powerful divisors" for each number using cumulative approach
        int[] powerfulDivisorCounts = new int[maxNumber + 1];
        for (int i = 1; i <= maxNumber; i++) {
            powerfulDivisorCounts[i] = powerfulDivisorCounts[i - 1] + (isPowerful[i] ? 1 : 0);
        }

        // Generate the result for the input array
        List<Integer> result = new ArrayList<>();
        for (int num : A) {
            result.add(powerfulDivisorCounts[num]);
        }

        return result;
    }

    private static boolean isPowerOfTwo(int n) {
        return n > 0 && (n & (n - 1)) == 0;
    }

    public static void main(String[] args) {
        ArrayList<Integer> input = new ArrayList<>(List.of(10, 15, 20));
        System.out.println(powerfulDivisors(input)); // Output: [8, 11, 15]
    }
}

```



