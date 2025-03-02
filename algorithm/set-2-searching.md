# Searching

## 1. **Linear Search**

**Description:** Linear search is the simplest search algorithm. It checks each element of the list until the target element is found or the list ends.

* **Time Complexity:**
  * Worst Case: O(n)
  * Best Case: O(1)
  * Average Case: O(n)
* **Space Complexity:** O(1) (iterative version)
* **Use Cases:**
  * When the list is <mark style="background-color:green;">unsorted</mark>.
  * Small datasets where the overhead of more complex algorithms isn't justified.

{% hint style="info" %}
**Algorithm:**

1. **Initialize:**
   * Define the list or array to search through and the target element.
   * Set an index variable to keep track of the current position in the list (usually starts at 0).
2. **Iteration and Comparison:**
   * Loop through the list:
     * Compare the current element with the target element.
     * If they are equal, the target is found, return the current index.
3. **Not Found:**
   * If the loop finishes iterating through the entire list without finding a match, the target element is not present. Return -1 (or any indicator for not found).
{% endhint %}

**Example:**

```java
public class LinearSearch {
    public static int linearSearch(int[] arr, int key) {
        for (int i = 0; i < arr.length; i++) {
            if (arr[i] == key) {
                return i;
            }
        }
        return -1;
    }
}
```

## 2. **Binary Search**

**Description:** Binary search is used on a sorted array. It works by repeatedly dividing the search interval in half. If the value of the search key is less than the item in the middle of the interval, narrow the interval to the lower half. Otherwise, narrow it to the upper half.

* **Time Complexity:**
  * Worst Case: O(log⁡n)
  * Best Case: O(1)
  * Average Case: O(log⁡n)
* **Space Complexity:**
  * Iterative version: O(1)
  * Recursive version: O(log⁡n)
* **Use Cases:**
  * When the list is <mark style="background-color:purple;">sorted</mark>.
  * Large datasets where performance is critical.

{% hint style="info" %}
**Algorithm:**

1. **Initialize:**
   * Define the sorted array to search through and the target element.
   * Set `low` and `high` indices to represent the beginning and end of the search interval (initially the entire array).
2. **Iteration and Comparison:**
   * While `low` is less than or equal to `high`:
     * Calculate the middle index: `mid = (low + high) // 2`
     * Compare the target element with the element at the middle index:
       * If they are equal, the target is found, return the middle index.
       * If the target is less than the middle element, search the left half of the array by setting `high` to `mid - 1`.
       * If the target is greater than the middle element, search the right half of the array by setting `low` to `mid + 1`.
3. **Not Found:**
   * If the loop exits without finding a match (`low` becomes greater than `high`), the target element is not present. Return -1 (or any indicator for not found).
{% endhint %}

**Example:**

```java
public class BinarySearch {
    public static int binarySearch(int[] arr, int key) {
        int left = 0, right = arr.length - 1;
        while (left <= right) {
            int mid = left + (right - left) / 2;
            if (arr[mid] == key) {
                return mid;
            }
            if (arr[mid] < key) {
                left = mid + 1;
            } else {
                right = mid - 1;
            }
        }
        return -1;
    }
}
```

## 3. **Jump Search**

**Description:** Jump search works on a sorted array. It jumps ahead by fixed steps and checks if the element is present, if not, it performs a linear search between the last jumped index and the current index.

* **Time Complexity:**
  * Worst Case: O(√n)
  * Best Case: O(1)
  * Average Case: O(√n)
* **Space Complexity:** O(1)
* **Use Cases:**
  * Faster than linear search for large sorted arrays (time complexity of O(√n)).
  * Easier to implement compared to some advanced search algorithms like binary search.
  * Suitable for large datasets where binary search overhead is significant.
  * Only works for <mark style="background-color:purple;">sorted</mark> arrays.

{% hint style="info" %}
**Algorithm:**

1. **Initialize:**
   * Define the sorted array and the element to search for.
   * Calculate the jump step size (often the square root of the array length).
2. **Jumping through Blocks:**
   * Start at the beginning of the array (index 0).
   * Keep jumping ahead by the calculated step size until:
     * The current element is greater than the target element, or
     * You reach the end of the array.
3. **Linear Search within Block:**
   * If the jump landed past the target element, go back one step.
   * Perform a linear search within the current sub-array (from the previous jump index to the current element or end of the array) to find the target element.
4. **Element Found or Not Found:**
   * If the target element is found within the sub-array, return its index.
   * If the search completes the sub-array traversal without finding the element, it's not present in the array, so return -1 (or any indicator for not found).
{% endhint %}

**Example:**

```java
public class JumpSearch {
    public static int jumpSearch(int[] arr, int key) {
        int n = arr.length;
        // Calculate jump step size
        int step = (int) Math.floor(Math.sqrt(n));
        int prev = 0;
        
        // Search by jumping through blocks
        while (arr[Math.min(step, n) - 1] < key) {
            prev = step;
            step += (int) Math.floor(Math.sqrt(n));
            if (prev >= n) {
                return -1;
            }
        }
        // Linear search within the final block
        while (arr[prev] < key) {
            prev++;
            if (prev == Math.min(step, n)) {
                return -1;
            }
        }
        if (arr[prev] == key) {
            return prev;
        }
        return -1;
    }
}
```

## 4. **Interpolation Search**

**Description:** Interpolation search is another searching algorithm for sorted arrays. It improves upon binary search by making an educated guess about the target element's position based on its value and the distribution of elements in the array. This guess, calculated using a formula, can significantly reduce the search space compared to simply going to the middle element like binary search.

* **Time Complexity:**
  * Worst Case: O(n)
  * Best Case: O(1)
  * Average Case: O(log⁡log⁡n)
* **Space Complexity:** O(1)
* **Use Cases:**
  * Faster than binary search for **uniformly distributed** sorted arrays (average time complexity of O(log(log(n)))).
  * Can be more efficient than binary search in specific scenarios.
  * Suitable for large datasets with uniform distribution.
  * Not as efficient as binary search for non-uniformly distributed data (worst-case time complexity of O(n)).
  * Requires the array to be <mark style="background-color:purple;">sorted</mark>.

{% hint style="info" %}
**Algorithm:**

1. **Initialize:**
   * Define the sorted array and the element to search for.
2. **Calculate Probe Position:**
   * Use a formula to estimate the potential index of the target element within the array based on its value and the range of values in the sorted array. This formula leverages the assumption of a uniform distribution.
3. **Comparison and Refinement:**
   * Compare the target element with the element at the calculated index.
   * If they are equal, the target element is found, return its index.
   * If the target element is less, repeat steps 2 and 3 but within the sub-array to the left of the current index.
   * If the target element is greater, repeat steps 2 and 3 but within the sub-array to the right of the current index.
4. **Element Found or Not Found:**
   * If the search exhausts the sub-arrays without finding the element, it's not present in the array, so return -1 (or any indicator for not found).
{% endhint %}

{% hint style="warning" %}
Example of sorted and uniformly distributed array

<pre><code><strong>arr = [5, 10, 15, 17, 20, 22, 23, 25, 28, 29]
</strong></code></pre>

In this example:

* The array is sorted, with values increasing gradually.
* The difference between most adjacent elements is relatively small (around 2-3 gain), suggesting a somewhat even spread of values.
* Uniform distribution doesn't guarantee perfectly equal differences between elements. There can be slight variations.
{% endhint %}

**Example:**

```java
public class InterpolationSearch {
    public static int interpolationSearch(int[] arr, int key) {
        int lo = 0, hi = arr.length - 1;
        while (lo <= hi && key >= arr[lo] && key <= arr[hi]) {
            if (lo == hi) {
                if (arr[lo] == key) {
                    return lo;
                }
                return -1;
            }
            // Calculate probe position using interpolation formula
            int pos = lo + (((hi - lo) / (arr[hi] - arr[lo])) * (key - arr[lo]));
            if (arr[pos] == key) {
                return pos;
            }
            if (arr[pos] < key) {
                lo = pos + 1;
            } else {
                hi = pos - 1;
            }
        }
        return -1;
    }
}
```

## 5. **Exponential Search**

**Description:** Exponential search involves two steps: finding the range where the element may be present and then using binary search within that range.

* **Time Complexity:**
  * Worst Case: O(log⁡n)
  * Best Case: O(1)
  * Average Case: O(log⁡n)
* **Space Complexity:**
  * Iterative version: O(1)
  * Recursive version: O(log⁡n)
* **Use Cases:**
  * When the list is <mark style="background-color:purple;">sorted</mark>.
  * Faster than linear search for sorted arrays with a sparse distribution of elements (time complexity of O(log i), where i is the index of the target element).
  * Suitable for unbounded/infinite lists.
  * Not as efficient as binary search, which has a time complexity of O(log n) for all cases.

{% hint style="info" %}
**Algorithm:**

* **Initialize:**
  * Define the sorted array and the element to search for.
* **Exponential Jump:**
  * Start with an index `i` set to 1.
  * Repeatedly double `i` until either `i` is greater than or equal to the array length or the value at index `i` is greater than or equal to the target element.
* **Narrow Down Search Range:**
  * If `i` went past the array length, reduce `i` to the last element index (`n-1`).
* **Binary Search within Sub-array:**
  * Perform a binary search within the sub-array from index 0 to `i/2` (avoiding overflow) to find the target element.
* **Element Found or Not Found:**
  * If the binary search finds the target element, return its index.
  * If the search completes without finding the target element, it's not present in the array, so return -1 (or any indicator for not found).
{% endhint %}

**Example:**

```java
class ExponentialSearch {
    public static int exponentialSearch(int[] arr, int key) {
        if (arr[0] == key) {
            return 0;
        }
        int i = 1;
        while (i < arr.length && arr[i] <= key) {
            i *= 2;
        }
        return binarySearch(arr, key, i / 2, Math.min(i, arr.length - 1));
    }

    private static int binarySearch(int[] arr, int key, int left, int right) {
        while (left <= right) {
            int mid = left + (right - left) / 2;
            if (arr[mid] == key) {
                return mid;
            }
            if (arr[mid] < key) {
                left = mid + 1;
            } else {
                right = mid - 1;
            }
        }
        return -1;
    }
}
```

## Comparison table

<table data-header-hidden data-full-width="true"><thead><tr><th></th><th></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Algorithm</strong></td><td><strong>Time Complexity</strong></td><td><strong>Space Complexity</strong></td><td><strong>Use Cases</strong></td></tr><tr><td><strong>Linear Search</strong></td><td>Worst: O(n)</td><td>O(1)</td><td>Unsorted lists, small datasets.</td></tr><tr><td></td><td>Best: O(1)</td><td></td><td></td></tr><tr><td></td><td>Average: O(n)</td><td></td><td></td></tr><tr><td><strong>Binary Search</strong></td><td>Worst: O(log⁡n)</td><td>O(1)(iterative)</td><td>Sorted lists, large datasets where performance is critical.</td></tr><tr><td></td><td>Best: O(1)</td><td>O(log⁡n)(recursive)</td><td></td></tr><tr><td></td><td>Average: O(log⁡n)</td><td></td><td></td></tr><tr><td><strong>Jump Search</strong></td><td>Worst: O(n)</td><td>O(1)</td><td>Sorted lists, large datasets where binary search overhead is significant.</td></tr><tr><td></td><td>Best: O(1)</td><td></td><td></td></tr><tr><td></td><td>Average: O(n)</td><td></td><td></td></tr><tr><td><strong>Interpolation Search</strong></td><td>Worst: O(n)</td><td>O(1)</td><td>Sorted and uniformly distributed lists, large datasets with uniform distribution.</td></tr><tr><td></td><td>Best: O(1)</td><td></td><td></td></tr><tr><td></td><td>Average: O(log⁡log⁡n)</td><td></td><td></td></tr><tr><td><strong>Exponential Search</strong></td><td>Worst: O(log⁡n)</td><td>O(1)(iterative)</td><td>Sorted lists, unbounded/infinite lists.</td></tr><tr><td></td><td>Best: O(1)</td><td>O(log⁡n)(recursive)</td><td></td></tr><tr><td></td><td>Average: O(log⁡n)</td><td></td><td></td></tr></tbody></table>
