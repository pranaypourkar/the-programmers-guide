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



