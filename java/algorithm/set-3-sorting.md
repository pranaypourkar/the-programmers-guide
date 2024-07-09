# Set 3 - Sorting

## 1. **Bubble Sort**

**Description:** Bubble Sort repeatedly steps through the list, compares adjacent elements, and swaps them if they are in the wrong order. This process is repeated until the list is sorted.

**Time Complexity:**

* Best Case: O(n) (when the array is already sorted)
* Average Case: O(n^2)
* Worst Case: O(n^2)

**Space Complexity:** O(1) (in-place sort)

**Use Cases:**

* Simple and easy to implement but is not very efficient for large datasets.
* Useful for small datasets or educational purposes to understand sorting concepts

{% hint style="info" %}
**Algorithm**:

1. **Initialization:**
   * Define the array to be sorted.
   * Set two variables, `i` and `j`, used for iterating through the array.
2. **Outer Loop:**
   * Use a `for` loop (or similar iteration construct) to iterate through the array `n-1` times (`n` being the length of the array). This outer loop controls the number of passes required to sort the entire list.
3. **Inner Loop:**
   * Within the outer loop, use another `for` loop to iterate from the beginning of the array (index 0) up to `i`(excluding the last element in the current pass). This inner loop compares adjacent elements.
4. **Comparison and Swap:**
   * Inside the inner loop, compare the current element at index `j` with the next element at index `j + 1`.
   * If the current element (`arr[j]`) is greater than the next element (`arr[j + 1]`), swap their positions in the array.
5. **Continue Looping:**
   * The inner loop continues iterating and swapping elements until it reaches the `i`th position, effectively "bubbling" the largest element to the end of the sub-array in each pass.
6. **Reduced Range in Subsequent Passes:**
   * Since the largest element is likely in its correct position after each pass, the outer loop variable `i` is decremented by 1 in the next iteration. This reduces the range of elements compared in subsequent passes, as the larger elements are already sorted at the end.
7. **Sorted When No Swaps Occur:**
   * The sorting process continues until no swaps are made in a complete pass through the array (inner loop). This indicates that the list is sorted, and the algorithm terminates.
{% endhint %}

#### Example

```java
public class BubbleSort {
    void bubbleSort(int arr[]) {
        int n = arr.length;
        for (int i = 0; i < n - 1; i++) {
            for (int j = 0; j < n - i - 1; j++) {
                if (arr[j] > arr[j + 1]) {
                    // swap arr[j+1] and arr[j]
                    int temp = arr[j];
                    arr[j] = arr[j + 1];
                    arr[j + 1] = temp;
                }
            }
        }
    }
}
```

## 2. **Selection Sort**

**Description:** Selection sort is a sorting technique that divides the unordered list into two sub-arrays: sorted and unsorted. In each pass, it finds the minimum (or maximum for descending order) element in the unsorted sub-array and swaps it with the first element of the unsorted sub-array. This process continues until the entire list is sorted.

**Time Complexity:**

* Best Case: O(n^2)
* Average Case: O(n^2)
* Worst Case: O(n^2)

**Space Complexity:** O(1) (in-place sort)

**Use Cases:**

* Similar to bubble sort, the number of comparisons grows quadratically with the size of the array. Selection sort is inefficient for large datasets.
* Useful for small datasets

{% hint style="info" %}
**Algorithm:**

1. **Initialization:**
   * Define the array to be sorted.
   * Set two variables:
     * `i` (outer loop counter) iterates through the positions of the sorted sub-array.
     * `minIndex` (used to track the index of the minimum element within the unsorted sub-array).
2. **Outer Loop:**
   * Use a `for` loop (or similar iteration construct) with `i` iterating from 0 to `n-2` (`n` being the length of the array).This loop controls the number of passes needed to sort the list.
3. **Finding Minimum Element:**
   * Inside the outer loop, initialize `minIndex` to the current position `i`.
   * Iterate through the unsorted sub-array (starting from `i+1` to `n-1`) to find the index of the minimum element.Compare the element at `minIndex` with each element in the unsorted sub-array. If a smaller element is found,update `minIndex` to store its index.
4. **Swapping Minimum Element:**
   * After finding the minimum element's index (`minIndex`), swap the element at `i` (the beginning of the unsorted sub-array) with the element at `minIndex`. This places the minimum element in its correct position within the sorted sub-array.
5. **Sorted Sub-array Grows:**
   * By the end of each iteration, the first `i+1` elements become the sorted sub-array, and the remaining elements form the unsorted sub-array that shrinks with each pass.
6. **Loop Continues:**
   * The outer loop (`for i`) continues iterating, finding the minimum element in the shrinking unsorted sub-array and placing it at the beginning of the sorted sub-array.
7. **Sorted When Loop Completes:**
   * After `n-1` iterations (outer loop completes), the entire list becomes sorted, with the smallest element at the beginning and elements increasing (or decreasing for descending order) towards the end.
{% endhint %}

#### Example

```java
public class SelectionSort {
    void selectionSort(int arr[]) {
        int n = arr.length;
        for (int i = 0; i < n - 1; i++) {
            int minIdx = i;
            for (int j = i + 1; j < n; j++) {
                if (arr[j] < arr[minIdx]) {
                    minIdx = j;
                }
            }
            // Swap the found minimum element with the first element
            int temp = arr[minIdx];
            arr[minIdx] = arr[i];
            arr[i] = temp;
        }
    }
}
```

## 3. **Insertion Sort**

**Description:** Insertion Sort builds the final sorted array one item at a time. It removes an element from the input data, finds the location it belongs to within the sorted list, and inserts it there.

**Time Complexity:**

* Best Case: O(n) (when the array is already sorted)
* Average Case: O(n^2)
* Worst Case: O(n^2)

**Space Complexity:** O(1) (in-place sort)

**Use Cases:**

* Efficient for small or partially sorted datasets due to its linear average-case time complexity.
* In-place sorting algorithm, meaning it sorts the data within the original array without requiring additional memory allocation.
* Adaptive: efficient for data that is already substantially sorted
* Used in hybrid sorting algorithms like Timsort
* Becomes inefficient for large datasets due to its worst-case quadratic time complexity.
* Not as efficient as Merge Sort or Quick Sort for general sorting purposes.

{% hint style="info" %}
**Algorithm:**

The concept behind insertion sort is similar to arranging playing cards in your hand. You start with an empty sorted sub-array and iteratively insert each element from the unsorted sub-array into its correct position within the sorted sub-array.

**Steps:**

1. **Initialization:**
   * Define the array to be sorted.
   * Set a variable `i` (outer loop counter) to iterate through the unsorted sub-array.
2. **Outer Loop:**
   * Use a `for` loop (or similar iteration construct) with `i` iterating from 1 to `n-1` (`n` being the length of the array).This loop controls the number of elements inserted into the sorted sub-array.
3. **Current Element:**
   * Inside the outer loop, the element at index `i` becomes the current element to be inserted.
4. **Shifting in Sorted Sub-array:**
   * Iterate backward through the sorted sub-array (starting from `i-1`) as long as the current element (`arr[i]`) is less than the element at the previous index (`arr[i-1]`). This creates a space in the sorted sub-array for the current element.
5. **Shifting Operation:**
   * Within the backward iteration, shift each element in the sorted sub-array that is greater than the current element one position to the right. This makes space for the current element at its correct position.
6. **Insertion:**
   * Once the backward iteration stops (either reaching the beginning of the sorted sub-array or finding an element less than the current element), insert the current element (`arr[i]`) at the vacated index (`i`).
7. **Sorted Sub-array Grows:**
   * After each iteration, the first `i` elements become the sorted sub-array, and the remaining elements form the unsorted sub-array that shrinks with each pass.
8. **Loop Continues:**
   * The outer loop (`for i`) continues iterating, picking the next element from the unsorted sub-array and inserting it into its correct position within the growing sorted sub-array.
9. **Sorted When Loop Completes:**
   * After `n-1` iterations (outer loop completes), the entire list becomes sorted, with elements in increasing order (or decreasing order for modifications).
{% endhint %}

**Example**

```java
public class InsertionSort {
    void insertionSort(int arr[]) {
        int n = arr.length;
        for (int i = 1; i < n; ++i) {
            int key = arr[i];
            int j = i - 1;

            // Move elements of arr[0..i-1], that are greater than key,
            // to one position ahead of their current position
            while (j >= 0 && arr[j] > key) {
                arr[j + 1] = arr[j];
                j = j - 1;
            }
            arr[j + 1] = key;
        }
    }
}
```

## 4. **Merge Sort**

**Description:** Merge Sort is a divide and conquer algorithm that splits the list into halves, recursively sorts each half, and then merges the sorted halves.

{% hint style="info" %}
**Merge Sort Algorithm:**

1. **Base Case:**
   * If the array has only one element (or is empty), it's already sorted. Return the array itself.
2. **Divide:**
   * Divide the array into two roughly equal sub-arrays (can be⌊n/2⌋ and ⌈n/2⌋ for even and odd lengths n).
3. **Conquer:**
   * Recursively call Merge Sort on each sub-array. This divides the problem of sorting a large array into sorting two smaller sub-arrays.
4. **Merge:**
   * After both sub-arrays are sorted individually, merge them back together into a single sorted array. This is the key step where the sorted sub-arrays are combined while maintaining the overall order.
{% endhint %}

**Time Complexity:**

* Best Case: O(nlog⁡n)
* Average Case: O(nlog⁡n)
* Worst Case: O(nlog⁡n)

**Space Complexity:** O(n) (not in-place)

**Use Cases:**

* Sorting linked lists
* External sorting (e.g., sorting large data sets stored on disk)

{% hint style="info" %}
**Merging Process:**

* Create a temporary array large enough to hold the merged elements.
* Initialize two index variables, one for each sub-array, and a third index for the merged array.
* Compare the elements at the current heads of the sub-arrays.
  * If the element from the first sub-array is less than or equal to the element from the second sub-array:
    * Add the element from the first sub-array to the merged array and increment its index.
  * Otherwise:
    * Add the element from the second sub-array to the merged array and increment its index.
* Continue comparing and adding elements until one of the sub-arrays is empty.
* Copy the remaining elements from the non-empty sub-array to the merged array.
* **Return Merged Array:**
  * The final merged array contains the elements in sorted order. Return this merged array.
{% endhint %}

**Example**

```java
public class MergeSort {

    public static void mergeSort(int[] arr, int left, int right) {
        if (left < right) {
            // Find the middle point
            int mid = left + (right - left) / 2;

            // Sort first and second halves
            mergeSort(arr, left, mid);
            mergeSort(arr, mid + 1, right);

            // Merge the sorted halves
            merge(arr, left, mid, right);
        }
    }

    private static void merge(int[] arr, int left, int mid, int right) {
        int n1 = mid - left + 1;
        int n2 = right - mid;

        // Create temporary sub-arrays
        int[] leftArray = new int[n1];
        int[] rightArray = new int[n2];

        // Copy data to temporary arrays
        System.arraycopy(arr, left, leftArray, 0, n1);
        System.arraycopy(arr, mid + 1, rightArray, 0, n2);

        // Merge the temporary arrays
        int i = 0, j = 0, k = left;
        while (i < n1 && j < n2) {
            if (leftArray[i] <= rightArray[j]) {
                arr[k] = leftArray[i];
                i++;
            } else {
                arr[k] = rightArray[j];
                j++;
            }
            k++;
        }

        // Copy the remaining elements
        while (i < n1) {
            arr[k] = leftArray[i];
            i++;
            k++;
        }

        while (j < n2) {
            arr[k] = rightArray[j];
            j++;
            k++;
        }
    }

    public static void main(String[] args) {
        int[] arr = {6, 5, 3, 1, 8, 7, 2, 4};
        mergeSort(arr, 0, arr.length - 1);

        System.out.println("Sorted array:");
        for (int i : arr) {
            System.out.print(i + " ");
        }
    }
}
```

## 5. **Quick Sort**

**Description:** Quick Sort is a divide and conquer algorithm that picks an element as a pivot, partitions the array around the pivot, and recursively sorts the partitions.

**Time Complexity:**

* Best Case: O(nlog⁡n)
* Average Case: O(nlog⁡n)
* Worst Case: O(n^2) (rare, can be mitigated with good pivot selection strategies like randomized or median-of-three)

**Space Complexity:** O(log⁡n) (in-place)

**Use Cases:**

* Generally faster in practice compared to other O(nlog⁡n) algorithms
* Used in systems and applications where average-case performance matters.
* Efficient for large datasets due to its average O(n log n) time complexity.
* In-place sorting algorithm, meaning it sorts the data within the original array without requiring significant additional memory allocation.
* Pivot selection strategy can significantly impact performance.

{% hint style="info" %}
**Algorithm**:

**Steps:**

1. **Base Case:**
   * If the array has only one element (or is empty), it's already sorted. Return the array itself.
2. **Choose Pivot:**
   * Select a pivot element from the array. This can be the first, last, or a randomly chosen element.
3. **Partitioning:**
   * Rearrange the array elements such that all elements less than the pivot are placed to its left side, and all elements greater than the pivot are placed to its right side. The pivot itself can be placed at its final sorted position.
4. **Recursive Calls:**
   * Recursively call Quick Sort on the sub-array containing elements less than the pivot.
   * Recursively call Quick Sort on the sub-array containing elements greater than the pivot.

**Partitioning Process:**

* Two indices (`i` and `j`) are used to traverse the array.
* `i` starts at the leftmost index (excluding the pivot) and iterates towards the right.
* `j` starts at the rightmost index (excluding the pivot) and iterates towards the left.
* If `arr[i]` is greater than the pivot, swap `arr[i]` with the element at the next position (`j+1`) and increment `j`.
* If `arr[j]` is less than the pivot, decrement `j`.
* Continue iterating until `i` and `j` meet or cross.
* Swap the pivot element with the element at index `j` (which now holds the correct position for the pivot).
{% endhint %}

**Example**

```java
public class QuickSort {

    public static void quickSort(int[] arr, int low, int high) {
        if (low < high) {
            // pi is partitioning index, arr[pi] is now at right place
            int pi = partition(arr, low, high);

            // Recursively sort elements before and after partition
            quickSort(arr, low, pi - 1);
            quickSort(arr, pi + 1, high);
        }
    }

    private static int partition(int[] arr, int low, int high) {
        int pivot = arr[high];
        int i = (low - 1); // index of smaller element

        for (int j = low; j <= high - 1; j++) {
            // If current element is smaller than the pivot
            if (arr[j] < pivot) {
                i++;
                swap(arr, i, j);
            }
        }
        swap(arr, i + 1, high);
        return (i + 1);
    }

    private static void swap(int[] arr, int i, int j) {
        int temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
    }

    public static void main(String[] args) {
        int[] arr = {10, 7, 8, 9, 1, 5};
        int n = arr.length;
        quickSort(arr, 0, n - 1);
}    
```

## 6. **Heap Sort**

**Description:** Heap Sort is a sorting technique that leverages the properties of a heap data structure to efficiently sort an array. It involves converting the input array into a max-heap (where the root element has the largest value), and then repeatedly removing the largest element (root) and placing it at the end of the sorted sub-array. This process continues until the entire array is sorted.

**Time Complexity:**

* Best Case: O(nlog⁡n)
* Average Case: O(nlog⁡n)
* Worst Case: O(nlog⁡n)

**Space Complexity:** O(1) (in-place)

**Use Cases:**

* Situations where space complexity matters
* Embedded systems where memory usage is constrained

{% hint style="info" %}
**Algorithm:**

1. **Build Heap:**
   * Rearrange the array elements to create a max-heap. This can be done using techniques like bottom-up heapification or heapify for each element.
2. **Extract Maximum:**
   * Remove the root element (largest element in a max-heap) from the heap and swap it with the last element of the unsorted sub-array.
3. **Heapify Down:**
   * Maintain the heap property (largest element at the root) by applying heapify down operation on the sub-array excluding the last element (now sorted).
4. **Repeat:**
   * Repeat steps 2 and 3 until there are no elements left in the heap (which signifies a sorted array).
{% endhint %}

**Example**

```java
public class HeapSort {

    public static void heapSort(int[] arr) {
        int n = arr.length;

        // Build a max heap
        for (int i = n / 2 - 1; i >= 0; i--) {
            heapify(arr, n, i);
        }

        // Extract one by one from heap
        for (int i = n - 1; i > 0; i--) {
            // Move current root to end
            swap(arr, 0, i);

            // call max heapify on the reduced heap
            heapify(arr, i, 0);
        }
    }

    private static void heapify(int[] arr, int n, int i) {
        int largest = i; // Initialize largest as root
        int left = 2 * i + 1; // left = 2*i + 1
        int right = 2 * i + 2; // right = 2*i + 2

        // If left child is larger than root
        if (left < n && arr[left] > arr[largest])
            largest = left;

        // If right child is larger than largest so far
        if (right < n && arr[right] > arr[largest])
            largest = right;

        // If largest is not root
        if (largest != i) {
            swap(arr, i, largest);

            // Recursively heapify the affected sub-tree
            heapify(arr, n, largest);
        }
    }

    private static void swap(int[] arr, int i, int j) {
        int temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
    }

    public static void main(String[] args) {
        int[] arr = {12, 11, 13, 5, 6, 7};
        int n = arr.length;

        heapSort(arr);

        System.out.println("Sorted array:");
        for (int i : arr) System.out.print(i + " ");
    }
}
```

## 7. **Radix Sort**

**Description:** Radix sort is a non-comparative sorting technique that works efficiently for integers by sorting digits individually, from the least significant digit (LSD) to the most significant digit (MSD). It leverages the concept of place value to group elements based on their digits and then sorts them within those groups.

**Time Complexity:**

* Best Case: O(nk)O(nk)
* Average Case: O(nk)O(nk)
* Worst Case: O(nk)O(nk)

**Space Complexity:** O(n+k)O(n+k)

**Use Cases:**

* Sorting integers or strings
* Useful for large datasets where comparison-based sorting algorithms are inefficient
* Efficient for sorting integers with a fixed number of digits or limited range.
* Stable sorting algorithm, meaning it preserves the original order of equal elements.
* Non-comparative sorting, offering advantages for specific hardware architectures.
* Not as efficient for sorting strings or data with variable-length keys.
* Requires additional space for buckets during sorting.

{% hint style="info" %}
**Algorithm:**

1. **Initialize:**
   * Define the array of integers to be sorted.
   * Find the maximum value in the array to determine the number of passes required (number of digits in the maximum value).
2. **Iteration through Digits (LSD to MSD):**
   * Iterate through each digit position (from the least significant digit to the most significant digit).
3. **Grouping by Digits:**
   * Use a stable sorting algorithm (like counting sort) to distribute elements into buckets based on the current digit position. This groups elements with the same digit value.
4. **Merging Buckets:**
   * After grouping by each digit, combine the elements from the buckets back into the original array in a stable order. This effectively sorts the array partially based on the current digit position.
5. **Repeat for Significant Digits:**
   * Repeat steps 2-4 for each subsequent digit position (moving towards the most significant digit) until the entire array is sorted.
{% endhint %}

**Example**

```java
public class RadixSort {

    public static void radixSort(int[] arr) {
        int max = getMax(arr); // Find the maximum value

        for (int exp = 1; max / exp > 0; exp *= 10) {
            countSort(arr, exp);
        }
    }

    private static void countSort(int[] arr, int exp) {
        int n = arr.length;
        int[] output = new int[n]; // Output array
        int[] count = new int[10]; // Count array for digits

        // Store count of occurrences in count[]
        for (int i = 0; i < n; i++) {
            count[(arr[i] / exp) % 10]++;
        }

        // Cumulative count
        for (int i = 1; i < 10; i++) {
            count[i] += count[i - 1];
        }

        // Build the output array
        for (int i = n - 1; i >= 0; i--) {
            output[count[(arr[i] / exp) % 10] - 1] = arr[i];
            count[(arr[i] / exp) % 10]--;
        }

        // Copy the sorted elements back to original array
        System.arraycopy(output, 0, arr, 0, n);
    }

    private static int getMax(int[] arr) {
        int max = arr[0];
        for (int i = 1; i < arr.length; i++) {
            if (arr[i] > max) {
                max = arr[i];
            }
        }
        return max;
    }

    public static void main(String[] args) {
        int[] arr = {170, 45, 75, 90, 802, 24, 2, 66};
        radixSort(arr);

        System.out.println("Sorted array:");
        for (int i : arr) System.out.print(i + " ");
    }
}
```

## 8. **Bucket Sort**

**Description:** Bucket Sort distributes the elements into a number of buckets, sorts each bucket individually (often using another sorting algorithm or recursively), and then concatenates the sorted buckets.

**Time Complexity:**

* Best Case: O(n+k)O(n+k)
* Average Case: O(n+k)O(n+k)
* Worst Case: O(n2)O(n2)

**Space Complexity:** O(n+k)O(n+k)

**Use Cases:**

* Sorting uniformly distributed data
* Useful when input is drawn from a known distribution

#### 9. **Counting Sort**

**Description:** Counting Sort is a non-comparison-based sorting algorithm that counts the number of occurrences of each distinct element and uses this information to place elements into the sorted array.

**Time Complexity:**

* Best Case: O(n+k)O(n+k)
* Average Case: O(n+k)O(n+k)
* Worst Case: O(n+k)O(n+k)

**Space Complexity:** O(k)O(k)

**Use Cases:**

* Sorting integers within a small range
* Efficient for datasets where range of the elements is not significantly larger than the number of elements

## Comparison Table

<table data-full-width="true"><thead><tr><th>Algorithm</th><th>Best Case</th><th>Average Case</th><th>Worst Case</th><th>Space Complexity</th><th>Use Cases</th></tr></thead><tbody><tr><td>Bubble Sort</td><td>O(n)O(n)</td><td>O(n2)O()</td><td>O(n2)O(n2)</td><td>O(1)O(1)</td><td>Small datasets, educational purposes</td></tr><tr><td>Selection Sort</td><td>O(n2)O(n2)</td><td>O(n2)O(n2)</td><td>O(n2)O(n2)</td><td>O(1)O(1)</td><td>Small datasets</td></tr><tr><td>Insertion Sort</td><td>O(n)O(n)</td><td>O(n2)O(n2)</td><td>O(n2)O(n2)</td><td>O(1)O(1)</td><td>Small datasets, adaptive sorting</td></tr><tr><td>Merge Sort</td><td>O(nlog⁡n)O(nlogn)</td><td>O(nlog⁡n)O(nlogn)</td><td>O(nlog⁡n)O(nlogn)</td><td>O(n)O(n)</td><td>Linked lists, external sorting</td></tr><tr><td>Quick Sort</td><td>O(nlog⁡n)O(nlogn)</td><td>O(nlog⁡n)O(nlogn)</td><td>O(n2)O(n2)</td><td>O(log⁡n)O(logn)</td><td>General-purpose, fast average performance</td></tr><tr><td>Heap Sort</td><td>O(nlog⁡n)O(nlogn)</td><td>O(nlog⁡n)O(nlogn)</td><td>O(nlog⁡n)O(nlogn)</td><td>O(1)O(1)</td><td>Space-constrained environments</td></tr><tr><td>Radix Sort</td><td>O(nk)O(nk)</td><td>O(nk)O(nk)</td><td>O(nk)O(nk)</td><td>O(n+k)O(n+k)</td><td>Large datasets, integer/strings</td></tr><tr><td>Bucket Sort</td><td>O(n+k)O(n+k)</td><td>O(n+k)O(n+k)</td><td>O(n2)O(n2)</td><td>O(n+k)O(n+k)</td><td>Uniformly distributed data</td></tr><tr><td>Counting Sort</td><td>O(n+k)O(n+k)</td><td>O(n+k)O(n+k)</td><td>O(n+k)O(n+k)</td><td>O(k)O(k)</td><td>Small range integers</td></tr></tbody></table>
