# Bit Manipulation

## About

Bit manipulation in Java refers to the process of working with individual bits within an integer data type. This allows to perform operations on data at a very fundamental level, which can be useful for optimization, low-level programming, and implementing specific algorithms. Bitwise operators are good for saving space and sometimes to cleverly remove dependencies.

<mark style="background-color:yellow;">Java, like many other programming languages and systems, uses a system called two's complement to represent signed numerical values in bits.</mark>

## **Bitwise Operators**

Java provides several bitwise operators that perform operations on corresponding bits of two integers.

These operators include:

### **1.  Bitwise AND ( & )**

Performs a bit-by-bit AND operation. The resulting bit is 1 only if the corresponding bits in both operands are 1.

`int result = 5 & 3; // result = 1 (binary: 101 & 011 = 001)`

#### **Significance**

* **Filtering:** AND operation acts as a filter to identify bits that are set to 1 in both operands. It allows us to select specific bits based on a pattern.
* **Checking Conditions:** We can use AND to check if certain conditions are met by examining specific bit positions.
* **Data Masking:** By using AND with a specific mask (a binary number with specific bits set to 0 or 1), we can isolate or clear certain bits in a data value.

#### **Applications**

Here are some common uses of Bitwise AND in programming:

* **Extracting bits:** We can extract specific bits from a data value by performing AND with a mask that has 1s in the desired bit positions and 0s elsewhere.
  * Example: Extracting the lower 4 bits of a byte value (`byte data = 25; byte lowerNibble = data & 0b1111; // 0b1111 is a mask with only the lower 4 bits set to 1`)
* **Checking Flag Bits:** In some data structures or status registers, specific bits represent flags (on/off indicators). AND can be used to check if a particular flag is set by comparing it with a mask that has 1 only in the corresponding bit position.
  * Example: Checking if a file is marked as read-only (`int fileStatus = 16; // Assuming read-only flag is at bit position 4 boolean isReadOnly = (fileStatus & 0b00010000) != 0; // Check if bit 4 is set`)
* **Clearing Bits:** By performing AND with a mask that has 0s in the positions you want to clear, we can effectively set those bits to 0 in the resulting value.
  * Example: Clearing the lower 2 bits of a byte (`byte data = 25; data &= 0b11111100; // Clears the lower 2 bits`)
* **Combining Bit Patterns:** We can combine specific bit patterns from two operands by performing AND with appropriate masks to isolate the desired bits and then OR them together.

### **2. Bitwise OR ( | )**

Performs a bit-by-bit OR operation. The resulting bit is 1 if at least one of the corresponding bits in the operands is 1.

`int result = 5 | 3; // result = 7 (binary: 101 | 011 = 111)`

### **3. Bitwise XOR ( ^ )**

Performs a bit-by-bit XOR operation. The resulting bit is 1 if the corresponding bits in the operands are different.

`int result = 5 ^ 3; // result = 6 (binary: 101 ^ 011 = 110)`

### **4. Bitwise NOT or COMPLEMENT ( \~ )**

Performs a one's complement operation on a single operand. Inverts all the bits (0 becomes 1 and vice versa).

`int result = ~6; // result = -7`

{% hint style="info" %}
In Java, integers are signed by default. This means the leftmost bit (most significant bit) represents the sign: 0 for positive and 1 for negative. Two's complement is a common way to represent signed integers in computers.

The value of 6 in binary is: **0000 0110**

By applying the complement operator, the result will be **0000 0110 -> 1111 1001**

This is the one’s complement of the decimal number 6. And since the first (leftmost) bit is 1 in binary, it means that the **sign is negative** for the number that is stored.

Since the numbers are stored as 2’s complement, first we need to find its 2’s complement and then convert the resultant binary number into a decimal number

**1111 1001 -> 0000 0110 + 1 -> 0000 0111**

**0000 0111** is 7 in decimal. Since the sign bit was 1 as highlighted above, the resulting answer is **-7**
{% endhint %}

## **Shift Operators:**

Java also has shift operators that move the bits of an integer left or right.

### **1. Left Shift ( << )**

Left shift operator (`<<`) moves all the bits of the operand to the **left** by a specified number of positions. Zeros are filled in on the **right** side of the operand to occupy the vacated positions. This operation effectively multiplies the number by 2 raised to the power of the shift amount (but performs a bitwise shift instead of a multiplication).

**Sign Doesn't Matter:** Left shift treats the operand as an unsigned value, regardless of whether it's originally positive, negative, or zero. Since there's no sign bit to consider, there's no concept of replication/copying during the shift. The operation simply moves all the bits left and fills the right side with zeros.

Let's perform a left shift by 2 positions (<< 2) on two different numbers:

**Positive Number:** 20 (Binary representation: 00000000 00010100)

**Negative Number:** -20 (Binary representation: 11111111 11111100) - Remember, negative numbers are represented in two's complement in Java.

**Positive Number:**

-> Original: 00000000 00010100 (20)

-> Shifted Left: 00000000 00101000 (80)

All the bits in the original binary representation (00000000 00010100) are shifted two positions to the left. The vacated bits on the right (two in this case) are filled with zeros. The resulting binary representation (00000000 00101000) corresponds to 80 in decimal, which shows a simple multiplication by 4 (2 raised to the power of the shift amount, 2^2).

**Negative Number:**

-> Original: 11111111 11111100 (-20)

-> Shifted Left: 11111111 11101000 (-80)

All the bits in the original binary representation (11111111 11111100) are shifted two positions to the left. The vacated bits on the right (two in this case) are filled with zeros, similar to the positive number case.

Even though the original numbers had different signs (positive and negative), the left shift operation treats them the same way.

### **2. Right Shift ( >> )**

The right shift operator (`>>`) performs a **signed right shift**. This means it shifts the bits of the operand to the **right** by the specified number of positions, but the behaviour for filling the vacated bits on the left side depends on the sign of the original number:

**-> Positive Numbers:** Similar to the unsigned right shift, zeros are filled in on the left side. This effectively divides the positive number by 2 raised to the power of the shift amount.

**-> Negative Numbers:** The sign bit (leftmost bit) is replicated to fill the vacated positions. This keeps the result negative.

Let's perform a signed right shift on two different numbers by 2 positions (>> 2):

**Positive Number:** 20 (Binary representation: 00000000 00010100)

-> Original: 00000000 00010100 (20)

-> Shifted Right: 00000000 00000101 (5)

All the bits in the original binary representation (00000000 00010100) are shifted two positions to the right. The vacated bits on the left (two in this case) are filled with zeros because it's a positive number. The resulting binary representation (00000000 00000101) corresponds to 5 in decimal, which effectively divides the original number by 4 (2 raised to the power of the shift amount, 2^2).

**Negative Number:** -20 (Binary representation: 11111111 11111100) - Remember, negative numbers are represented in two's complement in Java.

-> Original: 11111111 11101100 (-20)

-> Shifted Right: 11111111 11111011 (-5)

**Explanation:**

1. All the bits in the original binary representation (11111111 11111100) are shifted two positions to the right.
2. To preserve the negative sign, the leftmost bit (1) is replicated to fill the vacated bits on the left (two in this case).
3. The resulting binary representation (11111111 11111011) corresponds to -5 in decimal. Replicating the sign bit ensures the result remains negative after the shift.
4. **Unsigned Right Shift (`>>>`):** Shifts the bits of the operand to the **right** by the specified number of positions. Zeros are filled in on the **left** side of the operand (unlike signed right shift which uses the sign bit). This operation treats the operand as an unsigned integer, so the sign bit is ignored. Effectively, it divides the number by 2 raised to the power of the shift amount (but performs a bitwise shift instead of a division).

`int shiftedRight = 20 >>> 2; // 10100 >>> 2 Output: 5 (Binary: 0101)`



#### Arithmetic and Logical Right Shift

In Java, there are two types of right shifts:

<table><thead><tr><th width="215">Shift Type</th><th width="100">Operator</th><th>Behavior</th></tr></thead><tbody><tr><td><strong>Arithmetic Right Shift</strong></td><td><code>>></code></td><td>Fills the leftmost bits with the sign bit (preserves sign). Used for signed numbers. This has the effect of (roughly) dividing by two.</td></tr><tr><td><strong>Logical Right Shift</strong></td><td><code>>>></code></td><td>Fills the leftmost bits with <code>0</code>. Used for unsigned operations.</td></tr></tbody></table>

#### Example: Arithmetic vs. Logical Right Shift

```java
int x = -8; // Binary: 1111 1000 (Two's complement for -8)
System.out.println(x >> 2);  // Output: -2  (Arithmetic shift, keeps sign)
System.out.println(x >>> 2); // Output: 1073741822 (Logical shift, fills with 0s)
```

Explanation:

1. **Arithmetic Right Shift (`>>`)**:
   * Preserves the sign by filling the leftmost bits with the sign bit (1 for negative numbers, 0 for positive).
   * `-8 >> 2` → `1111 1000` → `1111 1110` (still negative, -2 in decimal).
2. **Logical Right Shift (`>>>`)**:
   * Always fills leftmost bits with `0`, regardless of sign.
   * `-8 >>> 2` → `0011 1110` (becomes a large positive number in decimal).



### Comparison

<table data-header-hidden data-full-width="true"><thead><tr><th width="181"></th><th></th><th></th><th></th></tr></thead><tbody><tr><td>Feature</td><td><strong>Left Shift (<code>&#x3C;&#x3C;</code>)</strong></td><td><strong>Right Shift (<code>>></code>)</strong></td><td><strong>Unsigned Right Shift (<code>>>></code>)</strong></td></tr><tr><td><strong>Operation</strong></td><td>Shifts bits to the left by a specified number of positions.</td><td>Shifts bits to the right, preserving the sign bit.</td><td>Shifts bits to the right, filling with zeros (unsigned).</td></tr><tr><td><strong>Bit Filling</strong></td><td>Vacant bits on the right are filled with <code>0</code>.</td><td>Vacant bits on the left are filled with the sign bit (<code>0</code> for positive, <code>1</code> for negative).</td><td>Vacant bits on the left are filled with <code>0</code>.</td></tr><tr><td><strong>Effect on Value</strong></td><td>Multiplies the number by 2n2n, where <code>n</code> is the number of shifts.</td><td>Divides the number by 2n2n, rounding down towards negative infinity.</td><td>Divides the number by 2n2n, rounding down towards zero.</td></tr><tr><td><strong>Sign Bit Handling</strong></td><td>Sign bit is not preserved; works only on unsigned values.</td><td>Preserves the sign bit for signed integers.</td><td>Does not preserve the sign bit, treating numbers as unsigned.</td></tr><tr><td><strong>Use Cases</strong></td><td>Efficient multiplication by powers of 2.</td><td>Efficient signed division by powers of 2.</td><td>Efficient unsigned division by powers of 2.</td></tr><tr><td><strong>Example (Positive Input)</strong></td><td>For <code>8 &#x3C;&#x3C; 2</code> (binary <code>00001000</code>): <br>Result = <code>32</code> (binary <code>00100000</code>).</td><td>For <code>8 >> 2</code> (binary <code>00001000</code>): <br>Result = <code>2</code> (binary <code>00000010</code>).</td><td>For <code>8 >>> 2</code> (binary <code>00001000</code>): <br>Result = <code>2</code> (binary <code>00000010</code>).</td></tr><tr><td><strong>Example (Negative Input)</strong></td><td>For <code>-8 &#x3C;&#x3C; 2</code> (binary <code>11111000</code>): <br>Result = <code>-32</code> (binary <code>11100000</code>).</td><td>For <code>-8 >> 2</code> (binary <code>11111000</code>): <br>Result = <code>-2</code> (binary <code>11111110</code>).</td><td>For <code>-8 >>> 2</code> (binary <code>11111000</code>): <br>Result = <code>1073741822</code> (binary <code>00111110...</code>).</td></tr></tbody></table>

## **Common Bit Manipulation Techniques**

<table data-full-width="true"><thead><tr><th width="133">Expression</th><th width="229">Result</th><th>Explanation</th></tr></thead><tbody><tr><td><code>X ^ 0</code></td><td><code>X</code></td><td>XOR with <code>0</code> leaves the number unchanged.</td></tr><tr><td><code>X ^ 1</code></td><td><code>~X</code></td><td>XOR with <code>1</code> flips all bits (bitwise NOT).</td></tr><tr><td><code>X ^ X</code></td><td><code>0</code></td><td>XOR of the same number results in <code>0</code>.</td></tr><tr><td><code>X &#x26; 0</code></td><td><code>0</code></td><td>AND with <code>0</code> always results in <code>0</code>.</td></tr><tr><td><code>X &#x26; 1</code></td><td><code>X</code> (LSB)</td><td>AND with <code>1</code> keeps the least significant bit (LSB).</td></tr><tr><td><code>X &#x26; X</code></td><td><code>X</code></td><td>AND with itself results in the same number.</td></tr><tr><td><code>X | 0</code></td><td><code>X</code></td><td>OR with 0 returns the original number</td></tr><tr><td><code>X | 1</code></td><td><code>1</code></td><td>OR with 1 returns 1</td></tr><tr><td><code>X | X</code></td><td><code>X</code></td><td>OR with same number returns the original number</td></tr></tbody></table>



<table data-header-hidden data-full-width="true"><thead><tr><th width="249"></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Problem</strong></td><td><strong>Technique</strong></td><td><strong>Example</strong></td></tr><tr><td><strong>Check if a number is odd</strong></td><td><code>(n &#x26; 1) == 1</code></td><td><code>5 &#x26; 1 == 1</code> (True, 5 is odd)</td></tr><tr><td><strong>Check if a number is even</strong></td><td><code>(n &#x26; 1) == 0</code></td><td><code>4 &#x26; 1 == 0</code> (True, 4 is even)</td></tr><tr><td><strong>Set the ith bit</strong></td><td><code>num = num | (1&#x3C;&#x3C;i)</code></td><td><p>num = 5 (<code>0101)</code>, i = 2 </p><p><code>0101 | 0100</code> → <code>1101</code> </p></td></tr><tr><td><strong>Clear the ith bit</strong></td><td><code>num = num &#x26; ~(1 &#x3C;&#x3C; i)</code></td><td>Clear 2nd bit of <code>13</code> (binary <code>1101</code>): <code>13 &#x26; ~(1 &#x3C;&#x3C; 2)</code> → <code>0101</code> (5 in decimal)</td></tr><tr><td><strong>Toggle the ith bit</strong></td><td><code>num = num ^ (1 &#x3C;&#x3C; i)</code></td><td>Toggle 1st bit of <code>5</code> (binary <code>0101</code>): <code>5 ^ (1 &#x3C;&#x3C; 1)</code> → <code>0111</code>(7 in decimal)</td></tr><tr><td><strong>Check if the ith bit is set</strong></td><td><code>(num &#x26; (1 &#x3C;&#x3C; i)) != 0</code></td><td>Check 2nd bit of <code>5</code> (binary <code>0101</code>): <code>(5 &#x26; (1 &#x3C;&#x3C; 2)) != 0</code>→ <code>True</code></td></tr><tr><td><strong>Count the number of set bits</strong></td><td>Use <strong>Brian Kernighan's Algorithm</strong>: <br><code>while (n != 0) { count++; n &#x26;= (n - 1); }</code></td><td>Count set bits in <code>13</code> (binary <code>1101</code>): Iteratively reduces to <code>1100</code>, <code>1000</code>, <code>0000</code>, count = 3</td></tr><tr><td><strong>Find the rightmost set bit</strong></td><td><code>n &#x26; -n</code></td><td>For <code>12</code> (binary <code>1100</code>): <code>12 &#x26; -12</code> → <code>0004</code> (4 in decimal)</td></tr><tr><td><strong>Turn off the rightmost set bit</strong></td><td><code>n &#x26; (n - 1)</code></td><td>For <code>12</code> (binary <code>1100</code>): <code>12 &#x26; (12 - 1)</code> → <code>1000</code> (8 in decimal)</td></tr><tr><td><strong>Isolate the ith bit</strong></td><td><code>(num >> i) &#x26; 1</code></td><td>Extract 3rd bit of <code>13</code> (binary <code>1101</code>): <code>(13 >> 3) &#x26; 1</code> → <code>1</code></td></tr><tr><td><strong>Check if a number is a power of 2</strong></td><td><code>(n &#x26; (n - 1)) == 0</code> and <code>n > 0</code></td><td>For <code>8</code> (binary <code>1000</code>): <code>(8 &#x26; (8 - 1)) == 0</code> → <code>True</code></td></tr><tr><td><strong>Swap two numbers without temp</strong></td><td><code>a ^= b; b ^= a; a ^= b;</code></td><td>Swap <code>a = 3</code> and <code>b = 5</code>: After operations, <code>a = 5</code> and <code>b = 3</code></td></tr><tr><td><strong>Reverse bits of a number</strong></td><td>Use a loop to reverse: <br>`while (n > 0) { reversed = (reversed &#x3C;&#x3C; 1)</td><td>(n &#x26; 1); n >>= 1; }`</td></tr><tr><td><strong>Get ith Bit</strong></td><td><code>(( num &#x26; (1 &#x3C;&#x3C; i)) != 0)</code></td><td>Shifts 1 over by i bits, creating a value that looks like 00010000. By performing an AND with num, we clear all bits other than the bit at bit i. Finally, we compare that to 0. If that new value is not zero, then bit i must have a 1. Otherwise, biti is a 0.</td></tr></tbody></table>

## Applications

* **Efficient storage of data:** Bitwise algorithms play a role in data compression techniques like Huffman coding. They can efficiently represent and process compressed data by manipulating bits directly.
* **Bit manipulation (setting, clearing, toggling bits):** Bitwise operators are frequently used to manipulate individual bits of numbers. This includes tasks such as setting bits (using OR), clearing bits (using AND with the complement), toggling bits (using XOR with 1), and checking the value of a specific bit.
* **Cryptography:** Many cryptographic algorithms, such as AES (Advanced Encryption Standard), DES (Data Encryption Standard), and SHA (Secure Hash Algorithm), utilize bitwise operations for encryption, decryption, and hashing. Bitwise XOR, in particular, is commonly used in encryption algorithms for its simplicity and effectiveness.
* **Networking and Protocol Handling:** Bitwise algorithms are used in networking protocols for tasks like IP address manipulation, subnet masking, and packet parsing. For example, bitwise AND is used in subnet masking to determine the network address from an IP address and subnet mask.
* **Low-Level System Programming:** Bitwise operations are essential in low-level system programming for tasks such as device control, memory management, and bit-level I/O operations. They are used to manipulate hardware registers, set/clear flags, and optimize code for performance.
* **Error Detection and Correction:** Bitwise algorithms are employed in error detection and correction techniques, such as CRC (Cyclic Redundancy Check) and Hamming codes. These algorithms use bitwise XOR and other operations to detect and correct errors in transmitted data.
