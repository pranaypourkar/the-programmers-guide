# Bit Manipulation

## Theory:

1 byte comprises of 8 bits and any integer or character can be represented using bits in computers, which we call its binary form(contains only 1 or 0) or in its base 2 form.\


**Example**:

```
1) 14 (Decimal form) = {1110} (Binary form)
= 1 * 2^3 + 1 * 2^2 + 1 * 2^1 + 0 * 2^0
= 14.

2) 20 (Decimal form) = {10100} (Binary form)
= 1 * 2^4 + 0 * 2^3 + 1 * 2^2 + 0 * 2^1 + 0 * 2^0
= 20.
```

{% hint style="info" %}
**Integers**: Integers can be represented using binary numbers, where each bit represents a power of 2. For example, the decimal number 5 can be represented as `0000 0101` in binary (8 bits).

**Characters**: Characters can be represented using character encodings such as ASCII (American Standard Code for Information Interchange) or Unicode. In ASCII, each character is represented by a unique 7-bit binary number, allowing for 128 different characters to be represented. Unicode extends this to accommodate a much larger set of characters using variable-length encoding schemes, typically using 8, 16, or 32 bits per character.
{% endhint %}

In general, the binary number can be represented in two ways.

1. Unsigned Binary Numbers
2. Signed Binary Numbers

**Unsigned Binary Numbers**

Using unsigned binary number representation, only positive binary numbers can be represented. For n-bit unsigned binary numbers, all n-bits are used to represent the magnitude of the number.

For example, if we represent decimal 12 in 5- bit unsigned number form then (12)10 = (01100)2. Here all 5 bit are used to represent the magnitude of the number

**Signed Binary Numbers**

Using signed binary number representation both positive and negative numbers can be represented.

In signed binary number representation the most significant bit (MSB) of the number is a sign bit. For positive numbers, the sign bit is 0 and for negative number, the sign bit is 1.

There are three different ways the signed binary numbers can be represented.

1. Signed Magnitude Form
2. 1’s Complement Form
3. 2’s Complement Form

**Sign Magnitude Representation**

In sign-magnitude representation, the Most Significant bit of the number is a sign bit and the remaining bit represents the magnitude of the number in a true binary form. For example, if some signed number is represented in the 8-bit sign-magnitude form then MSB is a sign bit and the remaining 7 bits represent the magnitude of the number in a true binary form.

<figure><img src="../../.gitbook/assets/image (55).png" alt="" width="254"><figcaption></figcaption></figure>

Here is the representation of + 34 and -34 in a 8-bit sign-magnitude form.

<figure><img src="../../.gitbook/assets/image (57).png" alt="" width="326"><figcaption></figcaption></figure>

Since the magnitude of both numbers is the same, the first 7 bits in the representation are the same for both numbers. For +34, the MSB is 0, and for -34, the MSB or sign bit is 1.

Using n-bits, the range of numbers that can be represented in Sign Magnitude Representation is from **– (2n-1 – 1) to (2n -1 – 1)**.



**1’s Complement Representation**

In 1’s complement representation, the representation of the positive number is same as the negative number. But the representation of the negative number is different.

For example, if we want to represent -34 in 8-bit 1’s complement form, then first write the positive number (+34). And invert all 1s in that number by 0s and 0s by 1s in that number. The corresponding inverted number represents the -34 in 1’s complement form. It is also called 1s complement of the number +34.

<figure><img src="../../.gitbook/assets/image (58).png" alt="" width="563"><figcaption></figcaption></figure>

Using n-bits, the range of numbers that can be represented in 1’s complement form is from **– (2n-1 – 1) to (2n -1 – 1)**.&#x20;



**2’s Complement Representation**

In 2’s complement representation also, the representation of the positive number is same as 1’s complement and sign-magnitude form.

<figure><img src="../../.gitbook/assets/image (59).png" alt="" width="563"><figcaption></figcaption></figure>

But the representation of the negative number is different. For example, if we want to represent -34 in 2’s complement form then

1. Write the number corresponding to +34.
2. Find 1’s complement of +34
3. Add ‘1’ to the 1’s complement number
4. The resultant is 2’s complement representation of -34



## Bit manipulation in Java

Bit manipulation in Java refers to the process of working with individual bits within an integer data type. This allows to perform operations on data at a very fundamental level, which can be useful for optimization, low-level programming, and implementing specific algorithms. Bitwise operators are good for saving space and sometimes to cleverly remove dependencies.

<mark style="background-color:yellow;">Java, like many other programming languages and systems, uses a system called two's complement to represent signed numerical values in bits.</mark>

## **Bitwise Operators:**

Java provides several bitwise operators that perform operations on corresponding bits of two integers. These operators include:

* **Bitwise AND ( & )**: Performs a bit-by-bit AND operation. The resulting bit is 1 only if the corresponding bits in both operands are 1.

`int result = 5 & 3; // result = 1 (binary: 101 & 011 = 001)`

* **Bitwise OR ( | )**: Performs a bit-by-bit OR operation. The resulting bit is 1 if at least one of the corresponding bits in the operands is 1.

`int result = 5 | 3; // result = 7 (binary: 101 | 011 = 111)`

* **Bitwise XOR ( ^ )**: Performs a bit-by-bit XOR operation. The resulting bit is 1 if the corresponding bits in the operands are different.

`int result = 5 ^ 3; // result = 6 (binary: 101 ^ 011 = 110)`

* **Bitwise NOT or COMPLEMENT  ( \~ )**: Performs a one's complement operation on a single operand. Inverts all the bits (0 becomes 1 and vice versa).

`int result = ~6; // result = -7`&#x20;

{% hint style="info" %}
In Java, integers are signed by default. This means the leftmost bit (most significant bit) represents the sign: 0 for positive and 1 for negative. Two's complement is a common way to represent signed integers in computers.&#x20;



The value of 6 in binary is: **0000 0110**

By applying the complement operator, the result will be **0000 0110 -> 1111 1001**

This is the one’s complement of the decimal number 6. And since the first (leftmost) bit is 1 in binary, it means that the **sign is negative** for the number that is stored.

Since the numbers are stored as 2’s complement, first we need to find its 2’s complement and then convert the resultant binary number into a decimal number

**1111 1001 -> 0000 0110 + 1 -> 0000 0111**

**0000 0111** is 7 in decimal. Since the sign bit was 1 as highlighted above, the resulting answer is **-7**
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

* **Efficient storage of data:** Bitwise algorithms play a role in data compression techniques like Huffman coding. They can efficiently represent and process compressed data by manipulating bits directly.
* **Bit manipulation (setting, clearing, toggling bits):** Bitwise operators are frequently used to manipulate individual bits of numbers. This includes tasks such as setting bits (using OR), clearing bits (using AND with the complement), toggling bits (using XOR with 1), and checking the value of a specific bit.
* **Cryptography:** Many cryptographic algorithms, such as AES (Advanced Encryption Standard), DES (Data Encryption Standard), and SHA (Secure Hash Algorithm), utilize bitwise operations for encryption, decryption, and hashing. Bitwise XOR, in particular, is commonly used in encryption algorithms for its simplicity and effectiveness.
* **Networking and Protocol Handling:** Bitwise algorithms are used in networking protocols for tasks like IP address manipulation, subnet masking, and packet parsing. For example, bitwise AND is used in subnet masking to determine the network address from an IP address and subnet mask.
* **Low-Level System Programming:** Bitwise operations are essential in low-level system programming for tasks such as device control, memory management, and bit-level I/O operations. They are used to manipulate hardware registers, set/clear flags, and optimize code for performance.
* **Error Detection and Correction:** Bitwise algorithms are employed in error detection and correction techniques, such as CRC (Cyclic Redundancy Check) and Hamming codes. These algorithms use bitwise XOR and other operations to detect and correct errors in transmitted data.



## Example

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



