# Big O Notation

## About

In computer science, complexity is a measure of the resources required for an algorithm to solve a problem. The two most commonly analyzed types of complexity are:

1. **Time Complexity**: How the runtime of an algorithm increases with the size of the input.
2. **Space Complexity**: How the memory usage of an algorithm increases with the size of the input.

Both time and space complexity are often expressed using Big O notation, which describes the upper bound of an algorithm's growth rate.

<figure><img src="../../.gitbook/assets/2.png" alt="" width="563"><figcaption></figcaption></figure>

{% hint style="success" %}
The general order of growth rates is:

O(1) < O(log⁡n) < O(n) < O(nlog⁡n) < O(n^k) \<O(n^log⁡n) \<O(k^n) \<O(n!) \<O(n^n)

Constant → Logarithmic → Linear → Linearithmic → Polynomial → Super-Polynomial → Exponential → Factorial.
{% endhint %}

{% hint style="info" %}
When we say **"algorithm X is asymptotically more efficient than algorithm Y"**, we are comparing the growth rates of their time or space complexity as the size of the input (N) becomes very large (approaches infinity). **The growth rate of X's runtime (or space usage) is smaller than Y's runtime (or space usage) as N→∞.** So X will always be a better choice for large inputs.
{% endhint %}

### Comparing Different Complexities

The following table compares the growth of various time complexities with different input sizes n:

<table data-header-hidden data-full-width="true"><thead><tr><th width="139"></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th></tr></thead><tbody><tr><td>n</td><td>O(1)</td><td>O(log n)</td><td>O(n)</td><td>O(n log n)</td><td>O(n²)</td><td>O(n³)</td><td>O(2ⁿ)</td></tr><tr><td>1</td><td>1</td><td>0</td><td>1</td><td>0</td><td>1</td><td>1</td><td>2</td></tr><tr><td>10</td><td>1</td><td>1</td><td>10</td><td>10</td><td>100</td><td>1000</td><td>1024</td></tr><tr><td>100</td><td>1</td><td>2</td><td>100</td><td>200</td><td>10,000</td><td>1,000,000</td><td>1.27e30</td></tr><tr><td>1,000</td><td>1</td><td>3</td><td>1,000</td><td>3,000</td><td>1,000,000</td><td>1.0e9</td><td>1.07e301</td></tr><tr><td>10,000</td><td>1</td><td>4</td><td>10,000</td><td>40,000</td><td>1.0e8</td><td>1.0e12</td><td>-</td></tr><tr><td>100,000</td><td>1</td><td>5</td><td>100,000</td><td>500,000</td><td>1.0e10</td><td>1.0e15</td><td>-</td></tr><tr><td>1,000,000</td><td>1</td><td>6</td><td>1,000,000</td><td>6,000,000</td><td>1.0e12</td><td>1.0e18</td><td>-</td></tr></tbody></table>

{% hint style="success" %}
#### **Amortized Time Complexity**

Amortized time complexity refers to the **average time per operation** over a **sequence of operations**, rather than analyzing the worst case for each individual operation.

It helps when an expensive operation happens **occasionally**, but most operations are **cheap**. Instead of considering the worst-case for each operation, we spread the cost across multiple operations to get a more realistic average cost.

#### **Example: Dynamic Array Doubling (ArrayList in Java)**

**Scenario**

* Suppose we use a **dynamic array** (like `ArrayList` in Java).
* If an array is full, we **double its size** (e.g., from 4 to 8 elements).
* Copying elements to a new array seems expensive, but it happens **infrequently**.

**Operation Complexity**\
Insert (when space is available) - O(1)\
Insert (when resizing) - O(n) (copying `n` elements)\
\
**Amortized Analysis**

* Let’s analyze `n` insertions.
* Every `i`-th resizing operation takes `O(i)`, but it occurs rarely.
* Total cost across `n` operations is **O(n)**.
* Amortized cost per operation = **O(1)**.

Thus, while a single **resize** is **O(n)**, the **amortized time** per insertion remains **O(1)**.
{% endhint %}

## Time Complexity

### Constant Time - O(1)

An algorithm runs in constant time if its runtime does not change with the input size.

Example: **Accessing an array element by index**.

```java
int getElement(int[] arr, int index) {
    return arr[index]; // O(1)
}
```

### Logarithmic Time - O(log n)

An algorithm runs in logarithmic time if its runtime grows logarithmically with the input size. These algorithms reduce the problem size by a fraction (typically half) at each step. This means that as the input size increases, the number of steps needed grows logarithmically rather than linearly.

**What is the base of log used here ?**

All logarithmic functions with different bases can be represented as O(log(n)) in Big O notation.

<figure><img src="../../.gitbook/assets/image (454).png" alt="" width="518"><figcaption></figcaption></figure>

Example: **Binary search**.

```java
int binarySearch(int[] arr, int target) {
    int left = 0, right = arr.length - 1;
    while (left <= right) {
        int mid = left + (right - left) / 2;
        if (arr[mid] == target) return mid;
        if (arr[mid] < target) left = mid + 1;
        else right = mid - 1;
    }
    return -1; // O(log n)
}
```

{% hint style="info" %}
**Logarithmic Growth**

For an array of size n, the number of times you can halve the array before you are left with a single element is log⁡2(n). This is why the time complexity of binary search is O(log n).

* For n=16, the steps are:
  * Step 1: 16 elements
  * Step 2: 8 elements
  * Step 3: 4 elements
  * Step 4: 2 elements
  * Step 5: 1 element
  * Total steps: 5 (which is approximately log⁡2(16))
{% endhint %}

### Linear Time - O(n)

An algorithm runs in linear time if its runtime grows linearly with the input size.

Example: **Finding the maximum element in an array.**

```java
int findMax(int[] arr) {
    int max = arr[0];
    for (int i = 1; i < arr.length; i++) {
        if (arr[i] > max) {
            max = arr[i];
        }
    }
    return max; // O(n)
}
```

### Linearithmic Time - O(n log n)

An algorithm runs in linearithmic time if its runtime grows in proportion to nlog⁡n. It describes algorithms whose running time grows linearly with the size of the input 𝑛 n but also includes an additional logarithmic factor

Example: **Efficient sorting algorithms like Merge Sort and Quick Sort.**

```java
 void mergeSort(int[] arr, int left, int right) {
        if (left < right) {
            int mid = (left + right) / 2;
            mergeSort(arr, left, mid);
            mergeSort(arr, mid + 1, right);
            merge(arr, left, mid, right);
        }
    }

    void merge(int[] arr, int left, int mid, int right) {
        int n1 = mid - left + 1;
        int n2 = right - mid;

        int[] leftArr = new int[n1];
        int[] rightArr = new int[n2];

        // Copy data to temp arrays
        System.arraycopy(arr, left, leftArr, 0, n1);
        System.arraycopy(arr, mid + 1, rightArr, 0, n2);

        int i = 0, j = 0, k = left;

        // Merge the temporary arrays back into arr
        while (i < n1 && j < n2) {
            if (leftArr[i] <= rightArr[j]) {
                arr[k] = leftArr[i];
                i++;
            } else {
                arr[k] = rightArr[j];
                j++;
            }
            k++;
        }

        // Copy remaining elements of leftArr[]
        while (i < n1) {
            arr[k] = leftArr[i];
            i++;
            k++;
        }

        // Copy remaining elements of rightArr[]
        while (j < n2) {
            arr[k] = rightArr[j];
            j++;
            k++;
        }
    }

    public static void main(String[] args) {
        int[] arr = {12, 11, 13, 5, 6, 7};
        MergeSortExample sorter = new MergeSortExample();
        System.out.println("Original array: " + Arrays.toString(arr));
        sorter.mergeSort(arr, 0, arr.length - 1);
        System.out.println("Sorted array: " + Arrays.toString(arr));
    }
```

{% hint style="info" %}
**Linearithmic Growth**

For an array of size n, the total time to sort the array is the number of levels of division (logarithmic) multiplied by the time to process each level (linear).

* **Levels of Division**: log⁡n
* **Processing Each Level**: n
* **Total Time Complexity**: nlog⁡n
{% endhint %}

{% hint style="success" %}
<pre class="language-java"><code class="lang-java"><strong>arraycopy(sourceArray, sourceStartIndex, destinationArray, destinationStartIndex, length);
</strong></code></pre>

* `sourceArray` → The array to copy from.
* `sourceStartIndex` → The starting index in the source array.
* `destinationArray` → The array to copy into.
* `destinationStartIndex` → The starting index in the destination array.
* `length` → The number of elements to copy.
{% endhint %}



### Polynomial (Quadratic Time) - O(n²)

An algorithm runs in quadratic time if its runtime grows proportionally to the square of the input size.

Example: **Simple sorting algorithms like Bubble Sort, Selection Sort.**

```java
void bubbleSort(int[] arr) {
    int n = arr.length;
    for (int i = 0; i < n - 1; i++) {
        for (int j = 0; j < n - 1 - i; j++) {
            if (arr[j] > arr[j + 1]) {
                int temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }
    } // O(n²)
}
```

### Polynomial (Cubic Time) - O(n³)

An algorithm runs in cubic time if its runtime grows proportionally to the cube of the input size.

Example: **Certain dynamic programming algorithms.**

```java
void exampleCubic(int n) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            for (int k = 0; k < n; k++) {
                // Some operations
            }
        }
    } // O(n³)
}
```

### **Super-Polynomial Growth (O(n^log⁡n)**

It is between polynomial and exponential growth. Examples include algorithms involving combinatorics or recursion trees. Significant growth—slower than exponential but faster than any polynomial.

```java
public class SuperPolynomialExample {
    public static void main(String[] args) {
        int n = 10; // Input size
        superPolynomialAlgorithm(n);
    }

    public static void superPolynomialAlgorithm(int n) {
        for (int i = 1; i <= n; i++) {
            for (int j = 1; j <= Math.pow(i, Math.log(n)); j++) {
                System.out.println("i: " + i + ", j: " + j);
            }
        }
    }
}
```

### Exponential Time - O(2ⁿ)

An algorithm runs in exponential time if its runtime doubles with each additional input element. Example: Solving the traveling salesman problem using brute force.

```java
int tsp(int[][] graph, boolean[] visited, int currPos, int n, int count, int cost, int ans) {
    if (count == n && graph[currPos][0] > 0) {
        return Math.min(ans, cost + graph[currPos][0]);
    }
    for (int i = 0; i < n; i++) {
        if (!visited[i] && graph[currPos][i] > 0) {
            visited[i] = true;
            ans = tsp(graph, visited, i, n, count + 1, cost + graph[currPos][i], ans);
            visited[i] = false;
        }
    }
    return ans; // O(2ⁿ)
}
```

## Space Complexity

### Constant Space - O(1)

An algorithm uses constant space if the amount of memory it requires does not change with the input size. Example: Swapping two variables.

```java
void swap(int[] arr, int i, int j) {
    int temp = arr[i];
    arr[i] = arr[j];
    arr[j] = temp; // O(1)
}
```

### Linear Space - O(n)

An algorithm uses linear space if the amount of memory it requires grows linearly with the input size. Example: Creating a copy of an array.

```java
int[] copyArray(int[] arr) {
    int[] copy = new int[arr.length];
    for (int i = 0; i < arr.length; i++) {
        copy[i] = arr[i];
    }
    return copy; // O(n)
}
```

### Quadratic Space - O(n²)

An algorithm uses quadratic space if the amount of memory it requires grows proportionally to the square of the input size. Example: Creating a 2D array.

```java
int[][] create2DArray(int n) {
    int[][] array = new int[n][n];
    // Initialize array
    return array; // O(n²)
}
```

### Logarithmic Space - O(log n)

An algorithm uses logarithmic space if the amount of memory it requires grows logarithmically with the input size. Example: Recursive algorithms that divide the problem in half at each step.

```java
void recursiveLogarithmic(int n) {
    if (n <= 1) return;
    recursiveLogarithmic(n / 2);
} // O(log n)
```

## Comparison

### Searching Algorithms

<figure><img src="../../.gitbook/assets/3 (1).png" alt=""><figcaption></figcaption></figure>

### Data Structure Operations

<figure><img src="../../.gitbook/assets/4 (1).png" alt=""><figcaption></figcaption></figure>

<figure><img src="../../.gitbook/assets/image (7).png" alt="" width="563"><figcaption></figcaption></figure>

### Array Sorting Algorithms

<figure><img src="../../.gitbook/assets/5 (1).png" alt=""><figcaption></figcaption></figure>
