# Bit Manipulation

## Description:

Bit manipulation in Java refers to the process of working with individual bits within an integer data type. This allows to perform operations on data at a very fundamental level, which can be useful for optimization, low-level programming, and implementing specific algorithms.

## **Bitwise Operators:**

Java provides several bitwise operators that perform operations on corresponding bits of two integers. These operators include:

* **Bitwise AND ( & )**: Performs a bit-by-bit AND operation. The resulting bit is 1 only if the corresponding bits in both operands are 1.

`int result = 5 & 3; // result = 1 (binary: 101 & 011 = 001)`

* **Bitwise OR ( | )**: Performs a bit-by-bit OR operation. The resulting bit is 1 if at least one of the corresponding bits in the operands is 1.

`int result = 5 | 3; // result = 7 (binary: 101 | 011 = 111)`

* **Bitwise XOR ( ^ )**: Performs a bit-by-bit XOR operation. The resulting bit is 1 if the corresponding bits in the operands are different.

`int result = 5 ^ 3; // result = 6 (binary: 101 ^ 011 = 110)`

* **Bitwise NOT ( \~ )**: Performs a one's complement operation on a single operand. Inverts all the bits (0 becomes 1 and vice versa).

`int result = ~5; // result = -6 (binary: ~101 = 111...111110)`

{% hint style="info" %}
In Java, integers are signed by default. This means the leftmost bit (most significant bit) represents the sign: 0 for positive and 1 for negative. Two's complement is a common way to represent signed integers in computers. To find the negative of a number in two's complement, we need to invert all the bits (bitwise NOT) and add 1.

**Steps to get -6:**

1. **Bitwise NOT**: We have `0101` (binary representation of 5). Performing bitwise NOT inverts all bits, resulting in `1010`.
2. **Two's Complement**: Here's how we find the two's complement representation of -6:
   * Invert `1010`: We get `0101`.
   * Add 1: `0101` + 1 = `0110`.
{% endhint %}

## **Shift Operators:**

Java also has shift operators that move the bits of an integer left or right.

*   **Left Shift ( << )**: Left shift operator (`<<`) moves all the bits of the operand to the **left** by a specified number of positions. Zeros are filled in on the **right** side of the operand to occupy the vacated positions. This operation effectively multiplies the number by 2 raised to the power of the shift amount (but performs a bitwise shift instead of a multiplication).

    **Sign Doesn't Matter:** Left shift treats the operand as an unsigned value, regardless of whether it's originally positive, negative, or zero. Since there's no sign bit to consider, there's no concept of replication/copying during the shift. The operation simply moves all the bits left and fills the right side with zeros.

`int result = 5 << 2; // result = 20 (binary: 101 << 2 = 10100)`

* **Right Shift ( >> )**: The right shift operator (`>>`) performs a **signed right shift**. This means it shifts the bits of the operand to the **right** by the specified number of positions, but the behavior for filling the vacated bits on the left side depends on the sign of the original number:
  * **Positive Numbers:** Similar to the unsigned right shift, zeros are filled in on the left side. This effectively divides the positive number by 2 raised to the power of the shift amount.
  * **Negative Numbers:** The sign bit (leftmost bit) is replicated to fill the vacated positions. This keeps the result negative.

```java
// Positive number
int positiveNum = 20; // Binary representation: 00000000 00010100
int positiveShiftedRight = positiveNum >> 2; // Shift right by 2 positions
System.out.println(positiveShiftedRight); // Output: 5 (Binary: 00000000 00000101) - Effectively divided by 4

// Negative number
int negativeNum = -20; // Binary representation (two's complement): 11111111 11111100
int negativeShiftedRight = negativeNum >> 2; // Shift right by 2 positions
System.out.println(negativeShiftedRight); // Output: -5 (Binary: 11111111 11111011) - Sign bit replicated
```

* **Unsigned Right Shift (`>>>`):** Shifts the bits of the operand to the **right** by the specified number of positions. Zeros are filled in on the **left** side of the operand (unlike signed right shift which uses the sign bit). This operation treats the operand as an unsigned integer, so the sign bit is ignored. Effectively, it divides the number by 2 raised to the power of the shift amount (but performs a bitwise shift instead of a division).

`int shiftedRight = 20 >>> 2; // 10100 >>> 2 Output: 5 (Binary: 0101)`



## Applications

### Using Bit Manipulation for Addition of Two Numbers in Java

```
// Java Program to implement
// Bit Manipulation to Find 
// the Sum of two Numbers
import java.io.*;

// Driver Class
class GFG {
	// function to find sum
	public static int sum(int num1, int num2)
	{
		if (num2 == 0) return num1;
		return sum(num1 ^ num2, (num1 & num2) << 1);
	}
	
	// main function
	public static void main(String[] args)
	{
		GFG ob = new GFG();
		int res = ob.sum(28, 49);
		System.out.println(res);
	}
}

```



