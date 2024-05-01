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

<figure><img src="../../../.gitbook/assets/image (1) (1) (1) (1).png" alt="" width="188"><figcaption></figcaption></figure>

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





## Factorial of a number

<figure><img src="../../../.gitbook/assets/image (2).png" alt=""><figcaption></figcaption></figure>

### Small number

#### **Iterative Solution**

```java
static int findFactorial(int n) {
    int factorial = 1;
    while (n > 0) {
        factorial = factorial * n;
        n--;
    }
    return factorial;
}
```

**Time Complexity**: O(n)\
**Auxiliary Space**: O(1)



#### **Using Recursive Method**

```java
static int findFactorialUsingRecursiveMethod(int n) {
        if (n == 0) {
            return 1;
        }
        return findFactorialUsingRecursiveMethod(n-1)*n;
    }
```

**Time Complexity**: O(n)\
**Auxiliary Space**: O(n)



{% hint style="info" %}
The above solutions cause overflow for large numbers.

A factorial of 100 has 158 digits and it is not possible to store these many digits even if we use **long int.**&#x20;
{% endhint %}



### Large number

#### Using BigIntegers

```java
static BigInteger findFactorialOfLargeNumber(int a) {
    BigInteger bigInteger = BigInteger.ONE;
    for(int i=2; i<=a; i++){
        bigInteger = bigInteger.multiply(BigInteger.valueOf(i));
    }
    return bigInteger;
}
```

**Time Complexity:** O(N)\
**Auxiliary Space:** O(1)&#x20;



#### Using Basic Maths Operation with the help of array i.e. storing digits in array and considering carry which helps in increasing size of array.

```java
static String findFactorialOfLargeNumber(int a) {
    int[] result = new int[400];
    result[0] = 1;
    int result_size = 1;

    for(int i=2; i<=a; i++) {
        int carry = 0;
        for(int j=0; j<result_size; j++) {
            int product = result[j]*i + carry;
            result[j] = product%10;
            carry = product/10;
        }

        while(carry != 0) {
            result[result_size] = carry%10;
            carry = carry/10;
            result_size++;
        }
    }

    String reverseFactorial = Arrays.stream(result)
            .mapToObj(String::valueOf)
            .limit(result_size)
            .collect(Collectors.joining());
    return new StringBuilder(reverseFactorial).reverse().toString();
}
```

**Time Complexity**: O(N log (N!)), where O(N) is for loop and O(log N!) is for nested while loop\
**Auxiliary Space:** O(max(digits in factorial))





## Print Pascal Triangle

<figure><img src="../../../.gitbook/assets/image (66).png" alt="" width="231"><figcaption></figcaption></figure>

### Using nCr formula

* In this approach, we directly calculate the combinations using the formula $$𝑛!/(𝑟!*(𝑛−𝑟))$$.
* Each entry in Pascal's Triangle corresponds to a specific combination $$𝑛𝐶𝑟nCr$$, where $$𝑛n$$ is the row number and $$𝑟r$$ is the position within the row.

<figure><img src="../../../.gitbook/assets/image (67).png" alt=""><figcaption><p>Theory</p></figcaption></figure>

```java
package src.main.java;

public class Application {
    public static void main(String[] args) {
        int n = 5;
        printPascalTriangle(n);
    }

    static void printPascalTriangle(int n) {
        for (int i=0; i<=n; i++) {
            // Print initial whitespace
            for (int j=i; j<n; j++) {
                System.out.print(" ");
            }

            for (int k=0; k<=i; k++) {
                int value = factorial(i)/(factorial(k)*factorial(i-k));
                System.out.print(" " + value);
            }
            System.out.println();
        }
    }

    static int factorial(int a) {
        if (a <= 1) {
            return 1;
        }
        return a*factorial(a-1);
    }
}
```

<figure><img src="../../../.gitbook/assets/image (68).png" alt=""><figcaption><p>Output</p></figcaption></figure>

**Time complexity**: O(2n) due to recursive method

**Auxiliary Space**: O(n) due to recursive stack space



### Using Binomial Coefficient

<figure><img src="../../../.gitbook/assets/image (70).png" alt=""><figcaption></figcaption></figure>



#### Method 1:

<figure><img src="../../../.gitbook/assets/image (71).png" alt=""><figcaption></figcaption></figure>

<pre class="language-java"><code class="lang-java"><strong>    // Function to calculate binomial coefficient C(n, k)
</strong>    public static int binomialCoefficient(int n, int k) {
        if (k == 0 || k == n) {
            return 1;
        }
        return binomialCoefficient(n - 1, k - 1) + binomialCoefficient(n - 1, k);
    }

    // Function to generate Pascal's Triangle
    public static void generatePascalsTriangle(int numRows) {
        for (int i = 0; i &#x3C; numRows; i++) {
            for (int j = 0; j &#x3C;= i; j++) {
                System.out.print(binomialCoefficient(i, j) + " ");
            }
            System.out.println();
        }
    }

    public static void main(String[] args) {
        int numRows = 5; // Number of rows to generate
        generatePascalsTriangle(numRows);
    }
</code></pre>



#### Method 2:

Using C = C \* (line - a) / a

The ‘A’th entry in a line number _line_ is Binomial Coefficient _C(line, a)_ and all lines start with value 1. The idea is to calculate C(line, a) using C(line, a-1). &#x20;

```java
public static void printPascal(int k)
    {
        for (int line = 1; line <= k; line++) {
            for (int b = 0; b <= k - line; b++) {
 
                // Print whitespace for left spacing
                System.out.print(" ");
            }
 
            // Variable used to represent C(line, i)
            int C = 1;
 
            for (int a = 1; a <= line; a++) {
 
                // The first value in a line is always 1
                System.out.print(C + " ");
               
                C = C * (line - a) / a;
            }
 
            // By now, we are done with one row so
            // a new line is required
            System.out.println();
        }
    }
```

**Time complexity**: O(n^2) where n is given input for no of rows of pascal triangle

**Auxiliary Space:** O(1)





## Print fibonacci series

<figure><img src="../../../.gitbook/assets/image.png" alt=""><figcaption></figcaption></figure>

### Using Iterative Method

```java
public static void printFibonacci(int n) {
        int a = 0, b = 1;
        for (int i = 0; i < n; i++) {
            System.out.print(a + " ");
            int sum = a + b;
            a = b;
            b = sum;
        }
    }
```

### Using Recursive Method

```java
 public static int fibonacci(int n) {
        if (n <= 1)
            return n;
        return fibonacci(n - 1) + fibonacci(n - 2);
    }

public static void printFibonacci(int n) {
        for (int i = 0; i < n; i++) {
            System.out.print(fibonacci(i) + " ");
        }
    }
```







