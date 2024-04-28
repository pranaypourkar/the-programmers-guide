# Bit Manipulation

## Example

### Using Bit Manipulation for Addition of Two Numbers in Java

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

The provided code snippet implements binary addition without using the built-in `+` operator.&#x20;

1. **Identifying Bits Set to 1:**

* Bitwise AND compares the corresponding bits of `a` and `b`.
* It returns 1 only if the bits in both positions of `a` and `b` are 1. Otherwise, it returns 0.

2. &#x20;**Significance in Carry Calculation:**

* In binary addition, a carry is generated when adding two bits that are both 1 (e.g., 1 + 1 = 10, where 1 is the carry bit).
* The `carry = a & b;` line essentially identifies the positions where both `a` and `b` have bits set to 1. These positions will generate a carry bit during the addition.

**Example:**

Let's consider `a = 5 (binary: 101)` and `b = 3 (binary: 011)`.

* `a & b = 001`. Here, only the least significant bit (LSB) position has 1s in both `a` and `b`, indicating a carry will be generated for this bit position.

3. &#x20;**Using Carry for Addition:**

* The subsequent line `a = a ^ b;` performs bitwise XOR (^) on `a` and `b`. XOR is 1 only when the corresponding bits are different.
* This line effectively adds `a` and `b` **without considering the carry** for the current bit position. The carry will be addressed in the next iteration of the loop.

4. **Carry bit is shifted left**

These carry bits are then shifted left in the next line (`b = carry << 1;`) to be added in the subsequent bit positions (next bit position) of `a` and `b`.



