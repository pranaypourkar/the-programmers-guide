# Problems

## **Prime Number**

### Apply Sieve of Eratosthenes Algorithm

```java
import java.util.ArrayList;

public class SieveOfEratosthenes {

    public static ArrayList<Integer> findPrimes(int n) {
        // Step 1: Initialize a boolean array to keep track of prime numbers
        boolean[] isPrime = new boolean[n + 1];
        for (int i = 2; i <= n; i++) {
            isPrime[i] = true; // Assume all numbers from 2 to n are prime initially
        }

        // Step 2: Apply the sieve algorithm
        for (int p = 2; p * p <= n; p++) {
            if (isPrime[p]) {
                // Mark all multiples of p as non-prime
                for (int multiple = p * p; multiple <= n; multiple += p) {
                    isPrime[multiple] = false;
                }
            }
        }

        // Step 3: Collect all prime numbers into an ArrayList
        ArrayList<Integer> primes = new ArrayList<>();
        for (int i = 2; i <= n; i++) {
            if (isPrime[i]) {
                primes.add(i); // Add prime number to the list
            }
        }

        return primes; // Return the sorted ArrayList of primes
    }

    public static void main(String[] args) {
        int n = 50; // Example: Find all primes up to 50
        ArrayList<Integer> primes = findPrimes(n);
        System.out.println("Prime numbers up to " + n + ": " + primes);
    }
}
```

## Program to Swap Two Numbers

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

### **Using Arrays**

<figure><img src="../../.gitbook/assets/image (166).png" alt="" width="188"><figcaption></figcaption></figure>

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

### **Using Bitwise Operators**

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

### **Without using arrays**

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

### Using inbuit method

```java
long binary1 = 10L, binary2 = 11L;
int binary3 = 123;
String binaryStr1 = Long.toBinaryString(binary1); // 1010
String binaryStr2 = Long.toBinaryString(binary2); // 1011
String binaryStr3 = Integer.toBinaryString(binary3);
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

## Binary Arithmetic

### Add two binary numbers given in long format

Input first binary number: 10\
Input second binary number: 11

_Expected Output:_ Sum of two binary numbers: 101

#### Method 1: Using inbuilt method

```java
long binary1 = 10L, binary2 = 11L;

// Parse binary strings as BigIntegers
BigInteger num1 = new BigInteger(String.valueOf(binary1), 2); // 2
BigInteger num2 = new BigInteger(String.valueOf(binary2), 2); // 3

// Add the two BigIntegers
BigInteger sum = num1.add(num2);

// Convert the result to binary string
String result = sum.toString(2);

// Print the result
System.out.println("Sum of two binary numbers: " + result);
```

#### Method 2: Using Modulo Division

```java
  // Declare variables to store two binary numbers, an index, and a remainder
  long binary1, binary2;
  int i = 0, remainder = 0;
  
  // Create an array to store the sum of binary digits
  int[] sum = new int[20];
  
  // Create a Scanner object to read input from the user
  Scanner in = new Scanner(System.in);

  // Prompt the user to input the first binary number
  System.out.print("Input first binary number: ");
  binary1 = in.nextLong();
  
  // Prompt the user to input the second binary number
  System.out.print("Input second binary number: ");
  binary2 = in.nextLong();

  // Perform binary addition while there are digits in the binary numbers
  while (binary1 != 0 || binary2 != 0) 
  {
   // Calculate the sum of binary digits and update the remainder
   sum[i++] = (int)((binary1 % 10 + binary2 % 10 + remainder) % 2);
   remainder = (int)((binary1 % 10 + binary2 % 10 + remainder) / 2);
   binary1 = binary1 / 10;
   binary2 = binary2 / 10;
  }
  
  // If there is a remaining carry, add it to the sum
  if (remainder != 0) {
   sum[i++] = remainder;
  }
  
  // Decrement the index to prepare for printing
  --i;
  
  // Display the sum of the two binary numbers
  System.out.print("Sum of two binary numbers: ");
  while (i >= 0) {
   System.out.print(sum[i--]);
  }
```

### Multiply two binary numbers given in long format

Input first binary number: 10\
Input second binary number: 11

_Expected Output:_ Sum of two binary numbers: 110

#### Method 1: Using inbuilt method

```java
long longBinary1 = 10L, longBinary2 = 11L;

BigInteger binary1 = new BigInteger(String.valueOf(longBinary1),2); // 2
BigInteger binary2 = new BigInteger(String.valueOf(longBinary2),2); // 3

BigInteger result = binary1.multiply(binary2);

System.out.println(result.toString(2)); // 110
System.out.println(result.toString(10)); // 6
```

#### Method 2: Using Modulo operation

```java
public static void main(String[] args) {
        long longBinary1 = 10L, longBinary2 = 11L;
        int sum, idx=0, position=0;
        int[] result = new int[16]; // Assume max 16 bit

        while(longBinary2!=0) {
            sum = (int) (longBinary1*(longBinary2%10));
            position = add(result, sum, idx);

            idx++;
            longBinary2 = longBinary2/10;
        }

        position--;
        while(position>=0) {
            System.out.print(result[position]);
            position--;
        }
    }

    private static int add(int[] result, int sum, int idx) {
        sum = (int) (sum*Math.pow(10,idx));
        int j = 0, carry = 0;
        while (sum != 0) {
            int tmp = result[j] + sum%10 + carry;
            result[j] = tmp%2;
            carry = tmp/2;

            j++;
            sum = sum/10;
        }
        return j;
    }
```

## Factorial of a number

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

A factorial of 100 has 158 digits and it is not possible to store these many digits even if we use **long int.**
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
**Auxiliary Space:** O(1)

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

<figure><img src="../../.gitbook/assets/image (288).png" alt="" width="231"><figcaption></figcaption></figure>

### Using nCr formula

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

<figure><img src="../../.gitbook/assets/image (290).png" alt=""><figcaption><p>Output</p></figcaption></figure>

**Time complexity**: O(2n) due to recursive method

**Auxiliary Space**: O(n) due to recursive stack space

### Using Binomial Coefficient

#### Method 1:

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

The ‘A’th entry in a line number _line_ is Binomial Coefficient _C(line, a)_ and all lines start with value 1. The idea is to calculate C(line, a) using C(line, a-1).

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

## Print number triangle

<figure><img src="../../.gitbook/assets/image (294).png" alt=""><figcaption></figcaption></figure>

<pre class="language-java"><code class="lang-java"><strong>        int n = 4;
</strong>
        for(int line=1;line&#x3C;=n;line++){

            // Print spaces
            for (int k=1; k&#x3C;=n-line; k++) {
                // First number space
                System.out.print(" ");
                // 2 Spaces between number
                System.out.print("  ");
            }

            int columns = 2*line-1;
            int value = line;
            for(int i=1; i&#x3C;=columns; i++){
                System.out.print("  " + value);
                if(i &#x3C;= columns/2) {
                    value++;
                } else {
                    value--;
                }
            }
            // Go to new line
            System.out.println();
        }
</code></pre>

<figure><img src="../../.gitbook/assets/image (295).png" alt=""><figcaption></figcaption></figure>

## Find Transpose of Matrix

### Square Matrix

#### Method 1: Using additional array

```java
static void transpose(int A[][], int B[][]) 
    { 
        int i, j; 
        for (i = 0; i < N; i++) 
            for (j = 0; j < N; j++) 
                B[i][j] = A[j][i]; 
    } 
```

#### Method 2: WIthout using additional array

```java
for (int row=0;row<arr.length;row++){
    for (int column=row;column<arr.length;column++){
        int tmp = arr[row][column];
        arr[row][column] = arr[column][row];
        arr[column][row] = tmp;
    }
}
```

### Rectangular Matrix

```java
        int[][] arr = {{1,2,3},{4,5,6}};
        int rows = 2;
        int columns = 3;
        int[][] transpose = new int[columns][rows];

        // Print
        for (int[] i : arr) {
            for (int j : i) {
                System.out.print(j + " ");
            }
            System.out.println();
        }

        for (int row=0;row<rows;row++){
            for (int column=0;column<columns;column++){
                transpose[column][row] = arr[row][column];
            }
        }

        // Print
        for (int[] i : transpose) {
            for (int j : i) {
                System.out.print(j + " ");
            }
            System.out.println();
        }
```

<figure><img src="../../.gitbook/assets/image (300).png" alt=""><figcaption></figcaption></figure>

## GCD or HCF of two numbers

<figure><img src="../../.gitbook/assets/image (153).png" alt=""><figcaption></figcaption></figure>

### Using Iteration

```java
int gcd(int a, int b) {
    int result = Math.min(a,b);
    while(result>0){
        if (a%result==0 && b%result==0) {
            return result;
        }
        result--;
    }
    return 1;
}
```

**Time Complexity:** O(min(a,b))\
**Auxiliary Space:** O(1)

### Using Euclidean algorithm for GCD of two numbers (Involves Recursion)

<figure><img src="../../.gitbook/assets/image (154).png" alt=""><figcaption></figcaption></figure>

```java
    // Recursive function to return gcd of a and b
    int gcd(int a, int b)
    {
        // All divides 0
        if (a == 0)
            return b;
        if (b == 0)
            return a;
 
        // Base case
        if (a == b)
            return a;
 
        // a is greater
        if (a > b)
            return gcd(a - b, b);
        return gcd(a, b - a);
    }
```

**Time Complexity:** O(min(a,b))\
**Auxiliary Space:** O(1) No space is used as it is a tail recursion i.e. no extra space is used apart from the space needed for the function call stack.

### **Optimization** Euclidean algorithm **by checking divisibility**

<figure><img src="../../.gitbook/assets/image (155).png" alt="" width="563"><figcaption></figcaption></figure>

```java
int gcd(int a, int b)
{
    // Everything divides 0
    if (a == 0)
        return b;
    if (b == 0)
        return a;
 
    // Base case
    if (a == b)
        return a;
 
    // a is greater
    if (a > b) {
        if (a % b == 0)
            return b;
        return gcd(a - b, b);
    }
    if (b % a == 0)
        return a;
    return gcd(a, b - a);
}
```

**Time Complexity:** O(min(a, b))\
**Auxiliary Space:** O(1)

### **Optimization using division**

Instead of the Euclidean algorithm by subtraction, a better approach is that we don’t perform subtraction but continuously divide the bigger number by the smaller number.

```java
// Recursive function to return gcd of a and b
    int gcd(int a, int b)
    {
      if (b == 0)
        return a;
      return gcd(b, a % b); 
    }
```

**Time Complexity:** O(log(min(a,b)))

**Auxiliary Space:** O(log(min(a,b))

### **Iterative implementation using Euclidean Algorithm**

```java
int gcd(int a, int b)
    {
        while (a > 0 && b > 0) {
            if (a > b) {
                a = a % b;
            }
            else {
                b = b % a;
            }
        }
        if (a == 0) {
            return b;
        }
        return a;
    }
```

**Time Complexity:** O(log(min(a,b)))\
**Auxiliary Space:** O(1)

### **Using in-built function in Java for BigIntegers**

```java
public static int gcd(int a, int b)
    {
        BigInteger bigA = BigInteger.valueOf(Math.abs(a));
        BigInteger bigB = BigInteger.valueOf(Math.abs(b));
        BigInteger gcd = bigA.gcd(bigB);
        return gcd.intValue();
    }
```

**Time Complexity:** O(log(min(a, b)))\
**Auxiliary Space:** O(1)

## LCM of two numbers

LCM (Least Common Multiple) of two numbers is the smallest number which can be divided by both numbers.

For example, LCM of 15 and 20 is 60, and LCM of 5 and 7 is 35.

### Using GCD of 2 numbers and Formula

```java
int gcd(int a, int b) 
    { 
        if (a == 0) 
            return b;  
        return gcd(b % a, a);  
    } 
      
// Return LCM of two numbers 
int lcm(int a, int b) 
    { 
        return (a / gcd(a, b)) * b; 
    } 
```

**Time Complexity:** O(log(min(a,b))\
**Auxiliary Space:** O(log(min(a,b))

### Using Iterative method

```java
int findLCM(int a, int b) 
    { 
        int greater = Math.max(a, b); 
        int smallest = Math.min(a, b); 
        for (int i = greater;; i += greater) { 
            if (i % smallest == 0) 
                return i; 
        } 
    }
```

**Time Complexity:** O(min(a,b))\
**Auxiliary Space:** O(1)

## Find All Factors of a Number

```java
public static List<Integer> getAllFactors(int number) {
        List<Integer> factors = new ArrayList<>();
        for (int i = 1; i <= Math.sqrt(number); i++) {
            if (number % i == 0) {
                factors.add(i); // Add the smaller factor
                if (i != number / i) {
                    factors.add(number / i); // Add the larger factor
                }
            }
        }
        factors.sort(Integer::compareTo); // Sort factors in ascending order
        return factors;
    }
```



