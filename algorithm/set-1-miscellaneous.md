# Set 1

## &#x20;Juggling algorithm for array rotation

The Juggling Algorithm is an efficient method for rotating an array of elements to the left or right by a given number of positions. It is particularly useful when you need to rotate an array in-place without using extra space. The algorithm achieves this by moving elements of the array in cycles, where each cycle involves moving one set of elements to their correct positions.

### Steps of the Juggling Algorithm with Explanation

1. **Calculate GCD**:
   * Calculate the Greatest Common Divisor (GCD) of the array length `n` and the number of positions `d`. This step determines the number of cycles needed to rotate all elements.
2. **Perform Cyclic Rotations**:
   * Divide the array into `gcd` cycles, each starting from a specific index `i`.
   * For each cycle:
     * Initialize a temporary variable `temp` to hold the value of the current index `i`.
     * Initialize the current index `j` to `i`.
     * While true:
       * Calculate the new index `k` by adding the rotation distance `d` to `j`.
       * Handle wrap-around if `k` is greater than or equal to the length of the array `n` by subtracting `n` from `k`.
       * Check if `k` equals the initial index `i`. If true, break out of the loop as the cycle has completed.
       * Copy the element at index `arr[k]` to index `arr[j]`, effectively moving the element to its new position within the rotation cycle.
       * Update the current index `j` to `k` to prepare for the next iteration of the loop within the cycle.
     * After completing the cycle, assign the value of `temp` (initial element of the cycle) to the last index `j`. This step ensures that the entire cycle is properly rotated.

### Code

```java
package src.main.java;

public class ArrayRotation {
    // Function to calculate GCD of two numbers
    private static int gcd(int a, int b) {
        if (b == 0)
            return a;
        return gcd(b, a % b);
    }

    // Function to left rotate array by d positions
    private static void leftRotate(int[] arr, int d) {
        int n = arr.length;
        int gcd = gcd(n, d);

        for (int i = 0; i < gcd; i++) {
            int temp = arr[i];
            int j = i;
            while (true) {
                int k = j + d;
                if (k >= n)
                    k = k - n;
                if (k == i)
                    break;
                arr[j] = arr[k];
                j = k;
            }
            arr[j] = temp;
        }
    }

    // Utility function to print an array
    private static void printArray(int[] arr) {
        for (int num : arr) {
            System.out.print(num + " ");
        }
        System.out.println();
    }

    public static void main(String[] args) {
        int[] arr = {1, 2, 3, 4, 5, 6, 7, 8};
        int d = 2;

        System.out.println("Original array:");
        printArray(arr);

        leftRotate(arr, d);

        System.out.println("Array after left rotation by " + d + " positions:");
        printArray(arr);
    }
}
```





