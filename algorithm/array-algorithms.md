# Array Algorithms

## Easy

### Rotate Array

Rotate the array A by B positions

```java
ArrayList<Integer> result = new ArrayList<Integer>();
  for (int i = 0; i < A.size(); i++) {
  result.add( A.get( (i + B) % A.size() ) );
}
```

### Swap to Equal Sum

We are given two arrays of integers. Our task is to **find a pair of values**, one from each array, that we can **swap** so that **both arrays have the same sum after the swap**.

Example

```
Array A = {4, 1, 2, 1, 1, 2}
Array B = {3, 6, 3, 3}
```

**Output**: `{1, 3}`\
This means: swap `1` from A and `3` from B → now the sums of both arrays will be equal.

Let:

* `sumA` = sum of array A
* `sumB` = sum of array B

After swapping a pair `a` (from A) and `b` (from B), the new sums would be:

* A's new sum: `sumA - a + b`
* B's new sum: `sumB - b + a`

We want both sums to be **equal**:

```
sumA - a + b = sumB - b + a
```

Simplify:

```
2(b - a) = sumB - sumA
```

So the required condition is:

```
b - a = (sumB - sumA) / 2
```

Let’s call that `delta = (sumB - sumA) / 2`

sumA = 4 + 1 + 2 + 1 + 1 + 2 = 11\
sumB = 3 + 6 + 3 + 3 = 15

delta = (15 - 11) / 2 = 2

We need to find a pair (a, b) such that b - a = 2\
So, iterate over A, and for each a, check if a + delta exists in B.

```java
import java.util.*;

public class SwapToEqualSum {

    public static int[] findSwapValues(int[] A, int[] B) {
        int sumA = Arrays.stream(A).sum();
        int sumB = Arrays.stream(B).sum();
        
        int delta = sumB - sumA;
        if (delta % 2 != 0) return null; // no solution if delta is odd
        delta /= 2;

        Set<Integer> setB = new HashSet<>();
        for (int b : B) setB.add(b);

        for (int a : A) {
            int target = a + delta;
            if (setB.contains(target)) {
                return new int[]{a, target};
            }
        }

        return null;
    }

    public static void main(String[] args) {
        int[] A = {4, 1, 2, 1, 1, 2};
        int[] B = {3, 6, 3, 3};

        int[] result = findSwapValues(A, B);
        if (result != null) {
            System.out.println("Swap: " + Arrays.toString(result));
        } else {
            System.out.println("No swap can equalize the arrays.");
        }
        // Swap: [1, 3]
    }
}
```



## Medium

### Maximum Subarray Sum

Given an array of integers (both positive and negative). Find the contiguous sequence with the largest sum. Return the sum.

Example

lnput: 2, -8, 3, -2, 4, -10

Output: 5 ( i. e • , { 3, -2, 4})

**Kadane’s Algorithm** is a famous and efficient algorithm used to solve the **"Maximum Subarray Problem"** that is, to find the contiguous subarray within a one-dimensional array of numbers which has the **largest sum**.

Idea is instead of checking every subarray, move through the array while tracking the maximum sum ending at the current index and updating the global maximum sum.

* Keep two variables:
  * `maxSoFar`: the global maximum sum found so far.
  * `currentMax`: the maximum subarray sum ending at the current position.
*   At each index `i`, calculate:

    ```
    currentMax = max(array[i], currentMax + array[i])
    maxSoFar = max(maxSoFar, currentMax)
    ```
* If `currentMax` becomes less than the current element, start a new subarray.

Explanation

Given:\
`[2, -8, 3, -2, 4, -10]`

Start with:\
`currentMax = maxSoFar = 2`

Now go through the rest:

* `-8`: `currentMax = max(-8, 2 + (-8)) = -6`, `maxSoFar = max(2, -6) = 2`
* `3`: `currentMax = max(3, -6 + 3) = 3`, `maxSoFar = max(2, 3) = 3`
* `-2`: `currentMax = max(-2, 3 + (-2)) = 1`, `maxSoFar = 3`
* `4`: `currentMax = max(4, 1 + 4) = 5`, `maxSoFar = 5`
* `-10`: `currentMax = max(-10, 5 + (-10)) = -5`, `maxSoFar = 5`&#x20;

Final result:\
`maxSoFar = 5`&#x20;

<table data-header-hidden><thead><tr><th width="110.81512451171875"></th><th width="111.353271484375"></th><th></th><th></th></tr></thead><tbody><tr><td>Index</td><td>Element</td><td>Current Sum (<code>curSum</code>)</td><td>Max Sum (<code>maxSum</code>)</td></tr><tr><td>0</td><td>2</td><td>2</td><td>2</td></tr><tr><td>1</td><td>-8</td><td>-6</td><td>2</td></tr><tr><td>2</td><td>3</td><td>3</td><td>3</td></tr><tr><td>3</td><td>-2</td><td>1</td><td>3</td></tr><tr><td>4</td><td>4</td><td>5</td><td>5 </td></tr><tr><td>5</td><td>-10</td><td>-5</td><td>5</td></tr></tbody></table>

→ Max sum = **5**, subarray = `[3, -2, 4]`

```java
public static int[] maxSubArrayWithIndices(int[] arr) {
    int maxSum = Integer.MIN_VALUE, curSum = 0;
    int start = 0, end = 0, tempStart = 0;

    for (int i = 0; i < arr.length; i++) {
        curSum += arr[i];

        if (curSum > maxSum) {
            maxSum = curSum;
            start = tempStart;
            end = i;
        }

        if (curSum < 0) {
            curSum = 0;
            tempStart = i + 1;
        }
    }

    System.out.println("Subarray with max sum: " + Arrays.toString(Arrays.copyOfRange(arr, start, end + 1)));
    return new int[]{maxSum};
}
```

