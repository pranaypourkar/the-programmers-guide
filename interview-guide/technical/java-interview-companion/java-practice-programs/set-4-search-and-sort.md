# Set 4 - Search and Sort

## Program for Linear Search <a href="#id-24-write-a-java-program-for-linear-search" id="id-24-write-a-java-program-for-linear-search"></a>

```java
private static int method1(int[] arr, int k) {
        int index = -1;

        for(int i=0; i<arr.length; i++) {
            if (arr[i] == k) {
                index = i;
                break;
            }
        }
        return index;
    }
// BEST CASE TIME COMPLEXITY O(1)
// AVERAGE CASE TIME COMPLEXITY O(N)
// WORST-CASE TIME COMPLEXITY O(N)
// SPACE COMPLEXITY O(1)
```

## Program for Binary Search <a href="#id-24-write-a-java-program-for-linear-search" id="id-24-write-a-java-program-for-linear-search"></a>

Binary search is one of the searching techniques applied when the input is sorted

### Method 1: Iterative Method

```java
// l = 0, r = arr.length-1, x=value to be search
private static int binarySearch(int arr[], int l, int r, int x)
    {
        while (l <= r) {
            int mid = (l + r) / 2;
 
            // If the element is present at the middle itself
            if (arr[mid] == x) {
                return mid;
 
            // If element is smaller than mid, then
            // it can only be present in left subarray
            // so we decrease our r pointer to mid - 1 
            } else if (arr[mid] > x) {
                r = mid - 1;
 
            // Else the element can only be present
            // in right subarray
            // so we increase our l pointer to mid + 1
            } else {
              l = mid + 1;
            }  
        }
 
        // Element is not present in the array
        return -1;
    }
// Time Complexity: O(log N)
// Space Complexity: O(1)
```

### Method 2: Recursive Method

```java
private static int binarySearch(int arr[], int l, int r, int x)
    {
        if (r >= l) {
            int mid = l + (r - l) / 2;
 
            // If the element is present at the middle itself
            if (arr[mid] == x)
                return mid;
 
            // If element is smaller than mid, then
            // it can only be present in left subarray
            if (arr[mid] > x)
                return binarySearch(arr, l, mid - 1, x);
 
            // Else the element can only be present
            // in right subarray
            return binarySearch(arr, mid + 1, r, x);
        }
 
        // Element is not present in array
        return -1;
    }
// Time Complexity: O(log N)
// Space Complexity: O(log N)
```

### Method 3: Inbuild Method

Using Arrays binary search method

```java
private static int method1(int[] arr, int k) {
        return Arrays.binarySearch(arr, k);
    }
// Time Complexity: O(log N)
// Space Complexity: O(1)
```

### Method 4: Binary Search in Collection List

Using Binary Search for List

```java
List<Integer> al = new ArrayList<Integer>();
al.add(1);
al.add(2);
al.add(3);
al.add(10);
al.add(20);
 
// 10 is present at index 3
int key = 10;
int res = Collections.binarySearch(al, key);
 
if (res >= 0)
   System.out.println(key + " found at index = " + res);
else
   System.out.println(key + " Not found");
   
// Time complexity: O(log N)
// Auxiliary space: O(1)   
```



