# Set 2 - Arrays

## Integer

### Sum of Array Elements

<figure><img src="../../../.gitbook/assets/image (74).png" alt="" width="563"><figcaption></figcaption></figure>

#### Method 1: Using iteration

```java
int[] arr = {2,4,6,7,9};
int sum = 0;
for(int i=0; i<arr.length; i++){
    sum = sum+arr[i];
}
System.out.println(sum); // output - 28

sum = 0;
for(int a : arr){
    sum = sum + a;
}
System.out.println(sum); // output - 28
```

**Time Complexity**: O(n)

**Auxiliary Space**: O(1)



#### Method 2: Using Streams

```java
int[] arr = {2,4,6,7,9};
int sum;
sum = Arrays.stream(arr).sum();
System.out.println(sum); // output - 28
```

**Time Complexity:** O(n)

**Auxiliary Space:** O(1)



#### Method 3: Using Recursion

```java
public static void main(String[] args) {
    int[] arr = {2,4,6,7,9};
    int sum;

    sum = arraySum(arr, arr.length-1);
    System.out.println(sum); // output - 28
}

static int arraySum(int[] arr, int index){
    if (index == 0) {
        return arr[index];
    }
    return arr[index] + arraySum(arr, --index);
}
```

**Time Complexity: O(n)**

**Auxiliary Space: O(n)**



### &#x20;Largest element in an array

<figure><img src="../../../.gitbook/assets/image (2) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

#### Method 1: Using iteration

```java
int[] arr = {2,4,6,7,9};
int max = Integer.MIN_VALUE;

for (int a : arr) {
    if (max < a) {
        max = a;
    }
}
```

**Time Complexity:** O(n), where n represents the size of the given array.\
**Auxiliary Space:** O(1), no extra space is required, so it is a constant.



#### Method 2: Using streams

```java
int[] arr = {2,4,6,7,9};
int max = Arrays.stream(arr).max().getAsInt();
```

**Time Complexity:** O(n), where n represents the size of the given array.\
**Auxiliary Space:** O(1), no extra space is required, so it is a constant.



#### Method 3: Using manual sorting

Sorting the array using Insertion Sort and returning last element from the sorted array

```java
static int largest(int arr[],int n)
    {
      for (int i = 1; i < n; ++i) {
          int key = arr[i];
          int j = i - 1;
 
          while (j >= 0 && arr[j] > key) {
              arr[j + 1] = arr[j];
              j = j - 1;
          }
          arr[j + 1] = key;
      }
 
      return arr[n-1];
    }
```

**Time Complexity:** O(n logn), where n represents the size of the given array.\
**Auxiliary Space:** O(1), no extra space is required, so it is a constant.

#### Method 4: Using sorting via Arrays.sort(..)

```java
int[] arr = {8,4,6,7,9};
Arrays.sort(arr);
int max = arr[arr.length-1];
```

**Time Complexity:** O(n logn), where n represents the size of the given array.\
**Auxiliary Space:** O(1), no extra space is required, so it is a constant.

#### Method 5: Using Collections.max()

```java
int[] arr = {8,4,6,7,9};
int max;

// Convert array to arraylist via streams
List<Integer> arrayList = new ArrayList<>(Arrays.asList(Arrays.stream(arr).boxed().toArray(Integer[]::new)));
max = Collections.max(arrayList);

// Convert array to arraylist manually iterating each array element
List<Integer> list = new ArrayList<>();
for (int j : arr) {
    list.add(j);
}
max = Collections.max(list);
```



### &#x20;Array Rotation

<figure><img src="../../../.gitbook/assets/image (5) (1) (1).png" alt=""><figcaption></figcaption></figure>

#### Method 1: Using additional array

```java
for (int a=0; a<arr.length; a++) {
    if (a-d < 0) {
        result[a-d+arr.length] = arr[a];
    } else {
        result[a-d] = arr[a];
    }
}
```

**Time complexity:** O(N) \
**Auxiliary Space:** O(N)

#### Method 2: Using rotation one by one

```java
int[] arr = {1,2,3,4,5,6,7};
int d = 2;

for (int i=1;i<=d;i++) {
    int tmp = arr[0];
    for (int j=1;j<arr.length;j++) {
        arr[j-1] = arr[j];
    }
    arr[arr.length-1] = tmp;
}
```

**Time Complexity:** O(N \* d)\
**Auxiliary Space:** O(1)

#### Method 3:  Using Juggling algorithm for array rotation

Refer to this page -> [https://pranaypourkar.gitbook.io/java-knowledge-base/java/algorithm/set-1#juggling-algorithm-for-array-rotation](https://pranaypourkar.gitbook.io/java-knowledge-base/java/algorithm/set-1#juggling-algorithm-for-array-rotation)



### Remove duplicate elements from an Array

**Input:** arr\[] = {2, 1, 2, 2, 3, 4, 4, 4, 5, 5}\
**Output:** arr\[] = {1, 2, 3, 4, 5}

#### Method 1: Using Set

```java
        int[] arr = { 1, 2, 2, 3, 3, 3, 4, 5 };
        System.out.println(Arrays.toString(arr));

        // Using Set
        Set<Integer> set = new HashSet<>();
        for (int element : arr) {
            set.add(element);
        }

        // Convert set to array
        int[] result = set.stream().mapToInt(Integer::intValue).toArray();
        System.out.println(Arrays.toString(result));
```

**Time Complexity:** O(n) (iterating through the array once)\
**Auxiliary Space:** O(n) (to store unique elements in the Set)

#### Method 2: Using ArrayList

```java
        int[] arr = { 1, 2, 2, 3, 3, 3, 4, 5 };
        System.out.println(Arrays.toString(arr));

        // Using ArrayList
        List<Integer> arrList = new ArrayList<>();
        for (int element : arr) {
            if (!arrList.contains(element)) {
                arrList.add(element);
            }
        }
        int[] result2 = arrList.stream().mapToInt(Integer::intValue).toArray();
        System.out.println(Arrays.toString(result2));
```

**Time Complexity**: O(n^2) in the worst case (nested loop with contains() method)\
**Auxiliary Space**: O(n) (to store unique elements in the ArrayList)

#### Method 3: Using Sorting

Sort the array and use the approaches given below.



### Remove duplicate elements from a SortedArray

#### Method 1: Using Iteration and Sorting

```java
public class Application {
    public static void main(String[] args) {
        int[] arr = { 1, 2, 2, 3, 3, 3, 4, 5 };
        System.out.println(Arrays.toString(arr));

        int uniqueArraySize = removeDuplicates(arr);
        for (int i=0; i<uniqueArraySize; i++) {
            System.out.print(arr[i] + " ");
        }
    }

    static int removeDuplicates(int arr[])
    {
        int n = arr.length;

        // Return, if array is empty or
        // contains a single element
        if (n == 0 || n == 1)
            return n;

        int[] temp = new int[n];

        // Start traversing elements
        int j = 0;
        for (int i = 0; i < n - 1; i++)

            // If current element is not equal to next
            // element then store that current element
            if (arr[i] != arr[i + 1])
                temp[j++] = arr[i];

        // Store the last element as whether it is unique or
        // repeated, it hasn't stored previously
        temp[j++] = arr[n - 1];

        // Modify original array
        for (int i = 0; i < j; i++)
            arr[i] = temp[i];

        return j;
    }
}
```

**Time Complexity:** O(N) \
**Auxiliary Space:** O(N)

#### Method 2: Maintaining a separate index for unique elements

**Steps**

* Traverse input array from **i = 0 to N**:
  * Keep track of the count of unique elements. Let this count be **j**.
  * Swap **arr\[j]** with **arr\[i]**.
* At last, return **j**.

```java
public class Application {
    public static void main(String[] args) {
        int[] arr = { 1, 2, 2, 3, 3, 3, 4, 5, 7 };
        System.out.println(Arrays.toString(arr));

        int n = removeDuplicates(arr);

        // Print updated array
        for (int i=0; i<n; i++)
            System.out.print(arr[i] + " ");
    }

    static int removeDuplicates(int arr[])
    {
        int n = arr.length;
        if (n == 0 || n == 1)
            return n;

        // Store index of next unique element
        int j = 0;

        // Iterate and update the index
        for (int i = 0; i < n-1; i++)
            if (arr[i] != arr[i+1])
                arr[j++] = arr[i];

        arr[j++] = arr[n-1];

        return j;
    }
}
```

**Time Complexity:** O(N) \
**Auxiliary Space:** O(1)



### Remove all occurrences of an element from Array

<figure><img src="../../../.gitbook/assets/image (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt="" width="530"><figcaption></figcaption></figure>

#### Method 1: Using iteration

```java
static int[] removeOccurrencesOfAnElement(int[] arr, int key) {
    int i = 0;
    for (int a : arr) {
        if (a != key) {
            arr[i++] = a;
        }
    }
    return Arrays.copyOfRange(arr, 0, i);
}
```

**Time Complexity:** O(n)\
**Space Complexity:** O(n)

#### Method 2: Using Streams

```java
int[] result = Arrays.stream(arr)
                .filter(num -> num != key)
                .toArray();
```

* **Time Complexity**: O(n)

The `Arrays.stream(arr)` operation takes O(n) time, where n is the length of the input array `arr`. The `filter()` operation iterates through each element of the stream and applies the predicate `num -> num != key`. In the worst case, this operation also takes O(n) time. The `toArray()` operation collects the elements of the stream into an array, which takes O(n) time.

* **Space Complexity**: O(n)

The space complexity is O(n) because we are creating a new array to store the filtered elements. The size of this array is equal to the number of elements that pass the filter condition, which could be up to n elements in the worst case.

#### Method 3: Using List

```java
List<Integer> arrList = IntStream.of(arr)
        .boxed()
        .collect(Collectors.toList());

int[] result = arrList.stream()
        .mapToInt(Integer::intValue)
        .filter(element -> element != key)
        .toArray();
```

* **Time Complexity**: O(n)

Creating the list `arrList` from the array `arr` using `IntStream.of(arr).boxed().collect(Collectors.toList())` takes O(n) time, where n is the length of the input array `arr`. Remaining is same as above Method.

* **Space Complexity**: O(n)



## String





## Char
