# Set 1

## Write a Program to Swap Two Numbers

Approaches based on time and space complexity

1. Creating an temporary variable.

```
int temp = a;
a = b;
b = temp;
```

* **Time Complexity:** O(1) - Constant time. This is because the swapping operation only involves a few assignment statements, which are independent of the input size (number size).
* **Space Complexity:** O(1) - Constant space. Only a single temporary variable is used, regardless of the size of the numbers being swapped.

2. Using maths addition and subtraction (Without Using Third Variable)

```java
a = a+b;
b = a-b;
a = a-b;
```

* **Time Complexity:** O(1) - Constant time. Similar to the temporary variable approach, this method involves a fixed number of operations regardless of the input size.
* **Space Complexity:** O(1) - Constant space. No additional memory is allocated beyond the variables holding the numbers.

3. Using exclusive OR (Bitwise XOR) operator

```
 a = a ^ b;
 b = a ^ b;
 a = a ^ b;
```

{% hint style="info" %}
```
Illustration:
a = 5 = 0101 (In Binary)
b = 7 = 0111 (In Binary)
Bitwise XOR Operation of 5 and 7
  0101
^ 0111
 ________
  0010  = 2 (In decimal)
```

This is the most optimal method as here directly computations are carried on over bits instead of bytes as seen in above two methods
{% endhint %}

* **Time Complexity:** O(1) - Constant time. Like the previous approaches, this method has a fixed number of operations.
* **Space Complexity:** O(1) - Constant space. No extra memory is used beyond the variables holding the numbers.



## Convert Decimal number to Binary number

There are many approaches.

1. **Using Arrays**

<figure><img src="../../../.gitbook/assets/image (1).png" alt="" width="188"><figcaption></figcaption></figure>

```java
public static void decimalToBinary(int n) 
    { 
        // array to store binary number 
        int[] binaryNum = new int[1000]; 
   
        // counter for binary array 
        int i = 0; 
        while (n > 0)  
        { 
            // storing remainder in binary array 
            binaryNum[i] = n % 2; 
            n = n / 2; 
            i++; 
        } 
   
        // printing binary array in reverse order 
        for (int j = i - 1; j >= 0; j--) 
            System.out.print(binaryNum[j]); 
    } 
```

2. **Using Bitwise Operators**

```java
public void decToBinary(int n) 
    { 
        // Size of an integer is assumed to be 32 bits 
        for (int i = 31; i >= 0; i--) { 
            int k = n >> i; 
            if ((k & 1) > 0) 
                System.out.print("1"); 
            else
                System.out.print("0"); 
        } 
    }    
```

{% hint style="info" %}
Bitwise operators work faster than arithmetic operators used in above methods
{% endhint %}

3. **Without using arrays**

```java
public static int decimalToBinary(int decimalNumber) {
    int binaryNumber = 0;
    while (decimalNumber > 0) {
        int remainder = decimalNumber % 2;
        binaryNumber = (binaryNumber * 10) + remainder;
        decimalNumber = decimalNumber / 2;
    }
    return binaryNumber;
}
```



## Convert Binary number to Decimal number

* **Using Math.pow(...) function**

```java
public static int binaryToDecimal(int binaryNumber) {
    int decimalNumber = 0;
    for(int i=0; binaryNumber != 0; i++) {
       int remainder = binaryNumber % 10;
        decimalNumber = decimalNumber + ((int) (Math.pow(2, i)) * remainder);
        binaryNumber = binaryNumber / 10;
    }
    return decimalNumber;
}
```





