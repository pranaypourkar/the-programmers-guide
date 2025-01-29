# Problems - Set 1

## Easy

### 1. Addition of Two Numbers

```java
public static int add(int a, int b) {
        while (b != 0) {
            int carry = a & b; // Calculate the carry by performing bitwise AND
            a = a ^ b; // Perform bitwise XOR to add the numbers without carry
            b = carry << 1; // Left shift the carry to perform addition with the next bit
        }
        return a;
}

public static void main(String[] args) {
        int num1 = 2;
        int num2 = 3;
        int sum = add(num1, num2);
        System.out.println("Sum of " + num1 + " and " + num2 + " is: " + sum);
}
```

The provided code snippet implements binary addition without using the built-in `+` operator.

1. **Identifying Bits Set to 1:**

* Bitwise AND compares the corresponding bits of `a` and `b`.
* It returns 1 only if the bits in both positions of `a` and `b` are 1. Otherwise, it returns 0.

2. **Significance in Carry Calculation:**

* In binary addition, a carry is generated when adding two bits that are both 1 (e.g., 1 + 1 = 10, where 1 is the carry bit).
* The `carry = a & b;` line essentially identifies the positions where both `a` and `b` have bits set to 1. These positions will generate a carry bit during the addition.

**Example:**

Let's consider `a = 5 (binary: 101)` and `b = 3 (binary: 011)`.

* `a & b = 001`. Here, only the least significant bit (LSB) position has 1s in both `a` and `b`, indicating a carry will be generated for this bit position.

3. **Using Carry for Addition:**

* The subsequent line `a = a ^ b;` performs bitwise XOR (^) on `a` and `b`. XOR is 1 only when the corresponding bits are different.
* This line effectively adds `a` and `b` **without considering the carry** for the current bit position. The carry will be addressed in the next iteration of the loop.

4. **Carry bit is shifted left**

These carry bits are then shifted left in the next line (`b = carry << 1;`) to be added in the subsequent bit positions (next bit position) of `a` and `b`.

### 2. Swapping the 2 numbers

```java
public static void main(String[] args) {
    int a = 2;
    int b = 3;
    System.out.println("Number before swap: a = " + a + " b = " + b);
    // Logic of XOR operator
    a = a ^ b;
    b = a ^ b;
    a = a ^ b;
    System.out.println("Number after swap: a = " + a + " b = " + b);
}
```

<figure><img src="../../.gitbook/assets/image (165).png" alt=""><figcaption></figcaption></figure>

### 3. Convert Decimal to Binary Conversion

```java
    // Function that convert Decimal to binary 
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

By iterating through each bit position and checking its value using the right shift and bitwise AND operations, the code determines whether each bit in the binary representation of `n` is 0 or 1.

### 4. **Check if a Number is Power of Two**

Given a number `n`, check if it is a power of two.

```
Input: n = 8
Output: true

Input: n = 7
Output: false
```

**Approach**

A number is a power of two if it has **only one bit set to 1** in its binary representation.\
For example:

* 1 → `0001` ( 2^0 )&#x20;
* 2 → `0010` ( 2^1 )&#x20;
* 4 → `0100` ( 2^2 )&#x20;
* 8 → `1000` ( 2^3 )&#x20;

{% hint style="info" %}
Let's take n=8 (`1000` in binary).

* n−1=7 (`0111` in binary)
* n&(n−1) = 1000&0111 = 0000

For a non-power of two, like n=6 (`0110` in binary):

* n−1=5 (`0101` in binary)
* n&(n−1) = 0110&0101 = 0100≠0
{% endhint %}

```java
public class PowerOfTwo {
    public static boolean isPowerOfTwo(int n) {
        return n > 0 && (n & (n - 1)) == 0;
    }

    public static void main(String[] args) {
        System.out.println(isPowerOfTwo(8)); // true
        System.out.println(isPowerOfTwo(7)); // false
    }
}
```

### **5. Count the Number of Set Bits (Hamming Weight)**

Given an integer, count the number of `1`s in its binary representation.

```makefile
Input: n = 9  (1001)
Output: 2
```

**Approach:** Use `n & (n - 1)` to remove the lowest set bit in a loop.

```java
public class CountSetBits {
    public static int countSetBits(int n) {
        int count = 0;
        while (n > 0) {
            count++;
            n = n & (n - 1); // Remove the last set bit
        }
        return count;
    }

    public static void main(String[] args) {
        System.out.println(countSetBits(9)); // 2
    }
}
```

### **6. Find the Single Non-Repeating Element (XOR Trick)**

Given an array where every element appears twice except for one, find the single element.

```makefile
Input: [4, 3, 2, 4, 2, 3, 5]
Output: 5
```

**Approach:**

* XORing a number with itself results in `0` (`a ^ a = 0`).
* XORing all numbers cancels out the duplicates, leaving only the unique number.

```java
public class SingleNumber {
    public static int findSingleNumber(int[] nums) {
        int res = 0;
        for (int num : nums) {
            res ^= num;
        }
        return res;
    }

    public static void main(String[] args) {
        int[] nums = {4, 3, 2, 4, 2, 3, 5};
        System.out.println(findSingleNumber(nums)); // 5
    }
}
```



## Medium

### 1. **Reverse Bits of an Integer**

Given a 32-bit integer, reverse its bits.

```makefile
Input:  00000010100101000001111010011100
Output: 00111001011110000010100101000000
```

**Approach:**

* Iterate through the bits, shifting the result left and adding the last bit of `n` to it.

**Java Solution:**

```java
public class ReverseBits {
    public static int reverseBits(int n) {
        int result = 0;
        for (int i = 0; i < 32; i++) {
            result <<= 1; // Shift left
            result |= (n & 1); // Add the last bit of n
            n >>= 1; // Shift right n
        }
        return result;
    }

    public static void main(String[] args) {
        int n = 0b00000010100101000001111010011100;
        System.out.println(Integer.toBinaryString(reverseBits(n)));
    }
}
```

### **2. Find the Missing Number**

**Problem Statement:**

Given an array of size `n` containing numbers from `0` to `n` with one missing, find the missing number.

```makefile
Input: [3, 0, 1]
Output: 2
```

**Approach:** Use XOR: `missing = (0 ^ 1 ^ 2 ^ ... ^ n) ^ (arr[0] ^ arr[1] ^ ... ^ arr[n-1])`

```java
public class MissingNumber {
    public static int findMissingNumber(int[] nums) {
        int n = nums.length;
        int xor = 0;

        for (int i = 0; i <= n; i++) {
            xor ^= i;
        }

        for (int num : nums) {
            xor ^= num;
        }

        return xor;
    }

    public static void main(String[] args) {
        int[] nums = {3, 0, 1};
        System.out.println(findMissingNumber(nums)); // 2
    }
}
```

## Difficult

