# Array

## About

An array is a container object that holds a fixed number of elements of a single data type. Each element can be accessed by its index.

* **Fixed Size:** The size of the array is defined when it is created and cannot be changed later.
* **Indexed Access:** Elements are accessed using zero-based indexing.
* **Homogeneous Data:** Arrays can only store elements of the same data type.
* **Efficient Memory Access:** Arrays provide contiguous memory allocation, making access efficient.

## Declaration and Initialization of Arrays

### Declaration

```java
dataType[] arrayName;  // Recommended
dataType arrayName[];  // Also valid but less common
```

### Initialization

#### 1. Separate Declaration and Initialization:

```java
int[] numbers;
numbers = new int[5];  // Allocates memory for 5 integers
```

#### 2. Combined Declaration and Initialization:

```java
int[] numbers = new int[5];
```

#### 3. Array Literals:

```java
int[] numbers = {1, 2, 3, 4, 5};  // Automatically initializes and determines size
```

## Accessing and Modification of Array Elements

### **Accessing**

```java
System.out.println(numbers[0]);  // Access the first element
```

### **Modifying**

```java
numbers[0] = 10;  // Set the first element to 10
```

### **Iterating Through an Array**

1. **For Loop:**

```java
for (int i = 0; i < numbers.length; i++) {
    System.out.println(numbers[i]);
}
```

1. **Enhanced For Loop:**

```java
for (int number : numbers) {
    System.out.println(number);
}
```

## **Types of Arrays**

### **1D Array**

A single row of elements.

```java
int[] numbers = {1, 2, 3, 4, 5};
```

### **2D Array**

An array of arrays, useful for matrices

```java
int[][] matrix = {
    {1, 2, 3},
    {4, 5, 6},
    {7, 8, 9}
};
System.out.println(matrix[1][2]);  // Accesses element in 2nd row, 3rd column (6)
```

### **Jagged Array**

An array with rows of varying lengths.

```java
int[][] jaggedArray = {
    {1, 2},
    {3, 4, 5},
    {6}
};
System.out.println(jaggedArray[1][2]);  // Output: 5
```





