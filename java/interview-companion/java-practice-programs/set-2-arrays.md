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

<figure><img src="../../../.gitbook/assets/image.png" alt=""><figcaption></figcaption></figure>

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





## String





## Char
