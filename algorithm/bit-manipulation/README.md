# Bit Manipulation - TBU

## Theory

1 byte comprises of 8 bits and any integer or character can be represented using bits in computers, which we call its binary form(contains only 1 or 0) or in its base 2 form.

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

### **Unsigned Binary Numbers**

Using unsigned binary number representation, only positive binary numbers can be represented. For n-bit unsigned binary numbers, all n-bits are used to represent the magnitude of the number.

For example, if we represent decimal 12 in 5- bit unsigned number form then (12)10 = (01100)2. Here all 5 bit are used to represent the magnitude of the number

### **Signed Binary Numbers**

Using signed binary number representation both positive and negative numbers can be represented.

In signed binary number representation the most significant bit (MSB) of the number is a sign bit. For positive numbers, the sign bit is 0 and for negative number, the sign bit is 1.

There are three different ways the signed binary numbers can be represented.

1. Signed Magnitude Form
2. 1’s Complement Form
3. 2’s Complement Form

#### **Sign Magnitude Representation**

In sign-magnitude representation, the Most Significant bit of the number is a sign bit and the remaining bit represents the magnitude of the number in a true binary form. For example, if some signed number is represented in the 8-bit sign-magnitude form then MSB is a sign bit and the remaining 7 bits represent the magnitude of the number in a true binary form.

<figure><img src="../../.gitbook/assets/image (277).png" alt="" width="254"><figcaption></figcaption></figure>

Here is the representation of + 34 and -34 in a 8-bit sign-magnitude form.

<figure><img src="../../.gitbook/assets/image (279).png" alt="" width="326"><figcaption></figcaption></figure>

Since the magnitude of both numbers is the same, the first 7 bits in the representation are the same for both numbers. For +34, the MSB is 0, and for -34, the MSB or sign bit is 1.

Using n-bits, the range of numbers that can be represented in Sign Magnitude Representation is from **– (2^(n-1) – 1) to (2^(n -1) – 1)**.

* Positive range: `0` to `(2^(n-1) - 1)`
* Negative range: `-1` to `-(2^(n-1) - 1)`

#### **1’s Complement Representation**

In 1’s complement representation, the representation of the positive number is same as the negative number. But the representation of the negative number is different.

For example, if we want to represent -34 in 8-bit 1’s complement form, then first write the positive number (+34). And invert all 1s in that number by 0s and 0s by 1s in that number. The corresponding inverted number represents the -34 in 1’s complement form. It is also called 1s complement of the number +34.

<figure><img src="../../.gitbook/assets/image (280).png" alt="" width="563"><figcaption></figcaption></figure>

Using n-bits, the range of numbers that can be represented in 1’s complement form is from **– (2^(n-1) – 1) to (2^(n -1) – 1)**.

#### **2’s Complement Representation**

In 2’s complement representation also, the representation of the positive number is same as 1’s complement and sign-magnitude form.

<figure><img src="../../.gitbook/assets/image (281).png" alt="" width="563"><figcaption></figcaption></figure>

But the representation of the negative number is different. For example, if we want to represent -34 in 2’s complement form then

1. Write the number corresponding to +34.
2. Find 1’s complement of +34
3. Add ‘1’ to the 1’s complement number
4. The resultant is 2’s complement representation of -34

### Comparison

<table data-header-hidden data-full-width="true"><thead><tr><th width="184"></th><th></th><th></th><th></th></tr></thead><tbody><tr><td>Feature</td><td><strong>Sign Magnitude Representation</strong></td><td><strong>1st Complement</strong></td><td><strong>2nd Complement</strong></td></tr><tr><td><strong>Representation of Sign</strong></td><td>The most significant bit (MSB) represents the sign: <br><code>0</code> for positive, <code>1</code> for negative.</td><td>MSB represents the sign, similar to Sign Magnitude.</td><td>MSB represents the sign, similar to Sign Magnitude.</td></tr><tr><td><strong>Positive Numbers</strong></td><td>Represented as usual binary. Example: <code>+5</code> in 4-bit: <code>0101</code>.</td><td>Represented as usual binary. Example: <code>+5</code> in 4-bit: <code>0101</code>.</td><td>Represented as usual binary. Example: <code>+5</code> in 4-bit: <code>0101</code>.</td></tr><tr><td><strong>Negative Numbers</strong></td><td>Invert the MSB to <code>1</code>, rest is unchanged. <br>Example: <code>-5</code> in 4-bit: <code>1101</code>.</td><td>Invert all bits of the positive number. <br>Example: <code>-5</code> in 4-bit: <code>1010</code>.</td><td>Invert all bits of the positive number and add <code>1</code>. <br>Example: <code>-5</code> in 4-bit: <code>1011</code>.</td></tr><tr><td><strong>Zero Representation</strong></td><td>Two representations: <code>+0</code>(<code>0000</code>) and <code>-0</code> (<code>1000</code>).</td><td>Two representations: <code>+0</code> (<code>0000</code>) and <code>-0</code>(<code>1111</code>).</td><td>Single representation: <code>0000</code>.</td></tr><tr><td><strong>Arithmetic Operations</strong></td><td>Requires separate handling of sign and magnitude.</td><td>Simple addition/subtraction but requires end-around carry for correctness.</td><td>Simplifies addition/subtraction, no need for special rules.</td></tr><tr><td><strong>Range of Values</strong></td><td><p>For <code>n</code> bits: <br><code>-2^(n-1) + 1</code> to <code>2^(n-1) - 1</code>.</p><ul><li>Positive: <code>0</code> to <code>2^(n-1) - 1</code>.</li><li>Negative: <code>-1</code> to <code>-(2^(n-1) - 1)</code>.</li></ul></td><td><p>For <code>n</code> bits: <br><code>-2^(n-1) + 1</code> to <code>2^(n-1) - 1</code>.</p><ul><li>Positive: <code>0</code> to <code>2^(n-1) - 1</code>.</li><li>Negative: <code>-1</code> to <code>-(2^(n-1) - 1)</code>.</li></ul></td><td><p>For <code>n</code> bits: <br><code>-2^(n-1)</code> to <code>2^(n-1) - 1</code>.</p><ul><li>Positive: <code>0</code> to <code>2^(n-1) - 1</code>.</li><li>Negative: <code>-2^(n-1)</code> to <code>-1</code>.</li></ul></td></tr><tr><td><strong>Example (4 bits)</strong></td><td><p></p><ul><li>Positive range: <code>0000 (0)</code> to <code>0111 (+7)</code>.</li><li>Negative range: <code>1000 (-0)</code> to <code>1111 (-7)</code>.</li><li><strong>Range</strong>: <code>-7</code> to <code>+7</code> (but with <strong>two zeros</strong>, <code>+0</code> and <code>-0</code>).</li></ul></td><td><p></p><ul><li>Positive range: <code>0000 (0)</code> to <code>0111 (+7)</code>.</li><li>Negative range: <code>1111 (-0)</code> to <code>1000 (-7)</code>.</li><li><strong>Range</strong>: <code>-7</code> to <code>+7</code> (but with <strong>two zeros</strong>, <code>+0</code> and <code>-0</code>).</li></ul></td><td><p></p><ul><li>Positive range: <code>0000 (0)</code> to <code>0111 (+7)</code>.</li><li>Negative range: <code>1000 (-8)</code> to <code>1111 (-1)</code>.</li><li><strong>Range</strong>: <code>-8</code> to <code>+7</code> (no extra zeros).</li></ul></td></tr><tr><td><strong>Advantages</strong></td><td>Simple to understand and implement.</td><td>Easy to compute negative values.</td><td>Ideal for arithmetic operations and eliminates ambiguity with zero.</td></tr><tr><td><strong>Disadvantages</strong></td><td>Complex arithmetic; two representations for zero.</td><td>Requires handling end-around carry.</td><td>Slightly more complex to compute negative values initially.</td></tr></tbody></table>



## Bit manipulation in Java

Bit manipulation in Java refers to the process of working with individual bits within an integer data type. This allows to perform operations on data at a very fundamental level, which can be useful for optimization, low-level programming, and implementing specific algorithms. Bitwise operators are good for saving space and sometimes to cleverly remove dependencies.

<mark style="background-color:yellow;">Java, like many other programming languages and systems, uses a system called two's complement to represent signed numerical values in bits.</mark>

## **Bitwise Operators**

Java provides several bitwise operators that perform operations on corresponding bits of two integers.

These operators include:

### **1.  Bitwise AND ( & )**

Performs a bit-by-bit AND operation. The resulting bit is 1 only if the corresponding bits in both operands are 1.

`int result = 5 & 3; // result = 1 (binary: 101 & 011 = 001)`

**Significance**

* **Filtering:** AND operation acts as a filter to identify bits that are set to 1 in both operands. It allows us to select specific bits based on a pattern.
* **Checking Conditions:** We can use AND to check if certain conditions are met by examining specific bit positions.
* **Data Masking:** By using AND with a specific mask (a binary number with specific bits set to 0 or 1), we can isolate or clear certain bits in a data value.

**Applications**

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

The right shift operator (`>>`) performs a **signed right shift**. This means it shifts the bits of the operand to the **right** by the specified number of positions, but the behavior for filling the vacated bits on the left side depends on the sign of the original number:

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





## Applications

* **Efficient storage of data:** Bitwise algorithms play a role in data compression techniques like Huffman coding. They can efficiently represent and process compressed data by manipulating bits directly.
* **Bit manipulation (setting, clearing, toggling bits):** Bitwise operators are frequently used to manipulate individual bits of numbers. This includes tasks such as setting bits (using OR), clearing bits (using AND with the complement), toggling bits (using XOR with 1), and checking the value of a specific bit.
* **Cryptography:** Many cryptographic algorithms, such as AES (Advanced Encryption Standard), DES (Data Encryption Standard), and SHA (Secure Hash Algorithm), utilize bitwise operations for encryption, decryption, and hashing. Bitwise XOR, in particular, is commonly used in encryption algorithms for its simplicity and effectiveness.
* **Networking and Protocol Handling:** Bitwise algorithms are used in networking protocols for tasks like IP address manipulation, subnet masking, and packet parsing. For example, bitwise AND is used in subnet masking to determine the network address from an IP address and subnet mask.
* **Low-Level System Programming:** Bitwise operations are essential in low-level system programming for tasks such as device control, memory management, and bit-level I/O operations. They are used to manipulate hardware registers, set/clear flags, and optimize code for performance.
* **Error Detection and Correction:** Bitwise algorithms are employed in error detection and correction techniques, such as CRC (Cyclic Redundancy Check) and Hamming codes. These algorithms use bitwise XOR and other operations to detect and correct errors in transmitted data.
