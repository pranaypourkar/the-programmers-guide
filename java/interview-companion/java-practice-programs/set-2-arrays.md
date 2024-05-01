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



## String





## Char
