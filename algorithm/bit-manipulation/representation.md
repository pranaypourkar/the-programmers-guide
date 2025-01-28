# Representation

## About

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

## **Unsigned Binary Numbers**

Using unsigned binary number representation, only positive binary numbers can be represented. For n-bit unsigned binary numbers, all n-bits are used to represent the magnitude of the number.

For example, if we represent decimal 12 in 5- bit unsigned number form then (12)10 = (01100)2. Here all 5 bit are used to represent the magnitude of the number

## **Signed Binary Numbers**

Using signed binary number representation both positive and negative numbers can be represented.

In signed binary number representation the most significant bit (MSB) of the number is a sign bit. For positive numbers, the sign bit is 0 and for negative number, the sign bit is 1.

There are three different ways the signed binary numbers can be represented.

1. Signed Magnitude Form
2. 1’s Complement Form
3. 2’s Complement Form

### **Sign Magnitude Representation**

In sign-magnitude representation, the Most Significant bit of the number is a sign bit and the remaining bit represents the magnitude of the number in a true binary form. For example, if some signed number is represented in the 8-bit sign-magnitude form then MSB is a sign bit and the remaining 7 bits represent the magnitude of the number in a true binary form.

<figure><img src="../../.gitbook/assets/image (277).png" alt="" width="254"><figcaption></figcaption></figure>

Here is the representation of + 34 and -34 in a 8-bit sign-magnitude form.

<figure><img src="../../.gitbook/assets/image (279).png" alt="" width="326"><figcaption></figcaption></figure>

Since the magnitude of both numbers is the same, the first 7 bits in the representation are the same for both numbers. For +34, the MSB is 0, and for -34, the MSB or sign bit is 1.

Using n-bits, the range of numbers that can be represented in Sign Magnitude Representation is from **– (2^(n-1) – 1) to (2^(n -1) – 1)**.

* Positive range: `0` to `(2^(n-1) - 1)`
* Negative range: `-1` to `-(2^(n-1) - 1)`

### **1’s Complement Representation**

In 1’s complement representation, the representation of the positive number is same as the negative number. But the representation of the negative number is different.

For example, if we want to represent -34 in 8-bit 1’s complement form, then first write the positive number (+34). And invert all 1s in that number by 0s and 0s by 1s in that number. The corresponding inverted number represents the -34 in 1’s complement form. It is also called 1s complement of the number +34.

<figure><img src="../../.gitbook/assets/image (280).png" alt="" width="563"><figcaption></figcaption></figure>

Using n-bits, the range of numbers that can be represented in 1’s complement form is from **– (2^(n-1) – 1) to (2^(n -1) – 1)**.

### **2’s Complement Representation**

In 2’s complement representation also, the representation of the positive number is same as 1’s complement and sign-magnitude form.

<figure><img src="../../.gitbook/assets/image (281).png" alt="" width="563"><figcaption></figcaption></figure>

But the representation of the negative number is different. For example, if we want to represent -34 in 2’s complement form then

1. Write the number corresponding to +34.
2. Find 1’s complement of +34
3. Add ‘1’ to the 1’s complement number
4. The resultant is 2’s complement representation of -34

### Comparison

<table data-header-hidden data-full-width="true"><thead><tr><th width="184"></th><th></th><th></th><th></th></tr></thead><tbody><tr><td>Feature</td><td><strong>Sign Magnitude Representation</strong></td><td><strong>1st Complement</strong></td><td><strong>2nd Complement</strong></td></tr><tr><td><strong>Representation of Sign</strong></td><td>The most significant bit (MSB) represents the sign: <br><code>0</code> for positive, <code>1</code> for negative.</td><td>MSB represents the sign, similar to Sign Magnitude.</td><td>MSB represents the sign, similar to Sign Magnitude.</td></tr><tr><td><strong>Positive Numbers</strong></td><td>Represented as usual binary. Example: <code>+5</code> in 4-bit: <code>0101</code>.</td><td>Represented as usual binary. Example: <code>+5</code> in 4-bit: <code>0101</code>.</td><td>Represented as usual binary. Example: <code>+5</code> in 4-bit: <code>0101</code>.</td></tr><tr><td><strong>Negative Numbers</strong></td><td>Invert the MSB to <code>1</code>, rest is unchanged. <br>Example: <code>-5</code> in 4-bit: <code>1101</code>.</td><td>Invert all bits of the positive number. <br>Example: <code>-5</code> in 4-bit: <code>1010</code>.</td><td>Invert all bits of the positive number and add <code>1</code>. <br>Example: <code>-5</code> in 4-bit: <code>1011</code>.</td></tr><tr><td><strong>Zero Representation</strong></td><td>Two representations: <code>+0</code>(<code>0000</code>) and <code>-0</code> (<code>1000</code>).</td><td>Two representations: <code>+0</code> (<code>0000</code>) and <code>-0</code>(<code>1111</code>).</td><td>Single representation: <code>0000</code>.</td></tr><tr><td><strong>Arithmetic Operations</strong></td><td>Requires separate handling of sign and magnitude.</td><td>Simple addition/subtraction but requires end-around carry for correctness.</td><td>Simplifies addition/subtraction, no need for special rules.</td></tr><tr><td><strong>Range of Values</strong></td><td><p>For <code>n</code> bits: <br><code>-2^(n-1) + 1</code> to <code>2^(n-1) - 1</code>.</p><ul><li>Positive: <code>0</code> to <code>2^(n-1) - 1</code>.</li><li>Negative: <code>-1</code> to <code>-(2^(n-1) - 1)</code>.</li></ul></td><td><p>For <code>n</code> bits: <br><code>-2^(n-1) + 1</code> to <code>2^(n-1) - 1</code>.</p><ul><li>Positive: <code>0</code> to <code>2^(n-1) - 1</code>.</li><li>Negative: <code>-1</code> to <code>-(2^(n-1) - 1)</code>.</li></ul></td><td><p>For <code>n</code> bits: <br><code>-2^(n-1)</code> to <code>2^(n-1) - 1</code>.</p><ul><li>Positive: <code>0</code> to <code>2^(n-1) - 1</code>.</li><li>Negative: <code>-2^(n-1)</code> to <code>-1</code>.</li></ul></td></tr><tr><td><strong>Example (4 bits)</strong></td><td><p></p><ul><li>Positive range: <code>0000 (0)</code> to <code>0111 (+7)</code>.</li><li>Negative range: <code>1000 (-0)</code> to <code>1111 (-7)</code>.</li><li><strong>Range</strong>: <code>-7</code> to <code>+7</code> (but with <strong>two zeros</strong>, <code>+0</code> and <code>-0</code>).</li></ul></td><td><p></p><ul><li>Positive range: <code>0000 (0)</code> to <code>0111 (+7)</code>.</li><li>Negative range: <code>1111 (-0)</code> to <code>1000 (-7)</code>.</li><li><strong>Range</strong>: <code>-7</code> to <code>+7</code> (but with <strong>two zeros</strong>, <code>+0</code> and <code>-0</code>).</li></ul></td><td><p></p><ul><li>Positive range: <code>0000 (0)</code> to <code>0111 (+7)</code>.</li><li>Negative range: <code>1000 (-8)</code> to <code>1111 (-1)</code>.</li><li><strong>Range</strong>: <code>-8</code> to <code>+7</code> (no extra zeros).</li></ul></td></tr><tr><td><strong>Advantages</strong></td><td>Simple to understand and implement.</td><td>Easy to compute negative values.</td><td>Ideal for arithmetic operations and eliminates ambiguity with zero.</td></tr><tr><td><strong>Disadvantages</strong></td><td>Complex arithmetic; two representations for zero.</td><td>Requires handling end-around carry.</td><td>Slightly more complex to compute negative values initially.</td></tr></tbody></table>

