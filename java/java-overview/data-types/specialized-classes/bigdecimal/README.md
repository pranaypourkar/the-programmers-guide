# BigDecimal

## **About**

The `BigDecimal` class is designed to handle real numbers with **arbitrary precision and scale**. Unlike floating-point types (`float` and `double`), `BigDecimal` eliminates rounding errors and ensures precise representation of decimal values. This makes it ideal for computations involving money, tax, and measurements.

Internally, `BigDecimal` represents numbers as a combination of:

1. **Unscaled Value**: A `BigInteger` representing the number without its decimal point.
2. **Scale**: An integer indicating the number of digits to the right of the decimal point.

Example:

* `BigDecimal("123.45")` is stored as:
  * Unscaled Value: `12345`
  * Scale: `2`

### **Features**

1. **Arbitrary Precision**: Supports numbers with virtually unlimited digits, restricted only by memory.
2. **Immutable**: `BigDecimal` objects are immutable, ensuring that any modification creates a new object.
3. **Exact Arithmetic**: Offers precise control over rounding behavior with `RoundingMode`.
4. **Support for Scaling**: Provides methods to set and adjust the scale of numbers.
5. **Extensive Arithmetic Operations**: Supports addition, subtraction, multiplication, division, modulus, power, and more.
6. **Integration with MathContext**: Allows control over precision and rounding for calculations.

### **How BigDecimal Differs from Primitive Types ?**

<table data-header-hidden data-full-width="true"><thead><tr><th width="176"></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Feature</strong></td><td><strong>Primitive Types (<code>float</code>, <code>double</code>)</strong></td><td><strong>BigDecimal</strong></td></tr><tr><td><strong>Precision</strong></td><td>Limited by IEEE 754 (approx. 7–16 digits)</td><td>Arbitrary precision</td></tr><tr><td><strong>Accuracy</strong></td><td>Prone to rounding and representation errors</td><td>Exact representation</td></tr><tr><td><strong>Mutability</strong></td><td>Mutable (values can change)</td><td>Immutable</td></tr><tr><td><strong>Operations</strong></td><td>Basic arithmetic</td><td>Advanced (e.g., scaling, rounding)</td></tr><tr><td><strong>Performance</strong></td><td>Faster (hardware-supported operations)</td><td>Slower (software-based)</td></tr><tr><td><strong>Thread-Safety</strong></td><td>Not inherently thread-safe</td><td>Thread-safe</td></tr></tbody></table>

### **How Immutability Works in BigDecimal**

`BigDecimal` is **immutable**, meaning its state cannot be changed once created. Any arithmetic or scale-altering operation returns a new `BigDecimal` object.

**Mechanisms Ensuring Immutability**

1. **Final Fields**: Key fields (`intCompact`, `intVal`, `scale`) are declared `final` and cannot be reassigned after initialization.
2. **Defensive Copies**: When constructors or methods accept mutable objects (like arrays), `BigDecimal` creates a defensive copy to prevent external modification.
3. **Return New Instances**: Arithmetic methods (`add`, `multiply`, etc.) return new objects without altering the original.

**Example of Immutability**

```java
BigDecimal value1 = new BigDecimal("10.5");
BigDecimal value2 = value1.add(new BigDecimal("2.5"));

System.out.println(value1); // Outputs 10.5 (unchanged)
System.out.println(value2); // Outputs 13.0 (new object)
```

{% hint style="info" %}
In the **`BigDecimal`** class, the key fields **`intCompact`**, **`intVal`**, and **`scale`** are used internally to represent the number in an efficient manner.

**`intCompact`**:

* This is an **optimized internal representation** of small numbers.
* If the value of the `BigDecimal` can fit into a `long` (64-bit integer), the number is stored directly in the `intCompact`field.
* This avoids the overhead of using a `BigInteger` for simple, small numeric values.
* If the number is too large to fit into a `long`, this field is set to `Long.MIN_VALUE`, and the `intVal` field is used instead.

**Example:**

```java
BigDecimal smallValue = new BigDecimal("12345");
```

**`intVal`**:

* This is a **`BigInteger` representation** of the number when the number cannot be stored in `intCompact`.
* Used for numbers that are too large or have arbitrary precision beyond the limits of a `long` (greater than ±9,223,372,036,854,775,807).
* If `intCompact` is used (for small numbers), this field is `null`.

**Example:**

```java
BigDecimal largeValue = new BigDecimal("123456789123456789123456789");
// intVal = BigInteger representing 123456789123456789123456789
```

**`scale`**:

* The **scale** determines the number of digits to the **right of the decimal point**.
* A positive scale indicates the fractional part, while a negative scale implies trailing zeroes in the integer part.

**Examples:**

* `BigDecimal("123.45")` → scale = 2

Methods like `setScale(int newScale, RoundingMode roundingMode)` can be used to modify the scale of a `BigDecimal`.
{% endhint %}

### **When and Why to Use BigDecimal**

**When?**

* When calculations demand **exact precision**, such as:
  * Financial transactions
  * Scientific measurements
  * Tax calculations

**Why?**

* **Avoids Rounding Errors**: Unlike floating-point types, `BigDecimal` accurately represents decimal numbers without approximation errors.
* **Precision Control**: Allows fine-tuned control over scale and rounding.
* **Thread Safety**: Safe to use in multi-threaded environments.

## **Creating a BigDecimal Object**

We can create a `BigDecimal` object using:

1.  **String Constructor (Preferred)**:

    ```java
    BigDecimal bigDecimal = new BigDecimal("123.45");
    ```

    * This avoids floating-point conversion errors.
2.  **Using `valueOf`**:

    ```java
    BigDecimal bigDecimal = BigDecimal.valueOf(123.45);
    ```

    * Converts `double` to a `BigDecimal` while preserving accuracy.
3.  **From Integers or Longs**:

    ```java
    BigDecimal bigDecimal = BigDecimal.valueOf(123L);
    ```

## **Operations on BigDecimal**

1. **Arithmetic Operations**:
   * `add(BigDecimal)` – Addition
   * `subtract(BigDecimal)` – Subtraction
   * `multiply(BigDecimal)` – Multiplication
   * `divide(BigDecimal, RoundingMode)` – Division with specified rounding mode
2. **Scaling and Rounding**:
   * `setScale(int scale, RoundingMode roundingMode)`
   * `round(MathContext mc)`
3. **Comparison**:
   * `compareTo(BigDecimal)` – Compares two `BigDecimal` values.
4. **Conversion**:
   * `toString()`, `toPlainString()`, `doubleValue()`, `longValue()`, etc.
5. **Mathematical Operations**:
   * `abs()`, `negate()`, `pow(int n)`

## Example

```java
import java.math.BigDecimal;
import java.math.RoundingMode;

public class BigDecimalExample {
    public static void main(String[] args) {
        BigDecimal value1 = new BigDecimal("10.50");
        BigDecimal value2 = new BigDecimal("2.30");

        // Addition
        BigDecimal sum = value1.add(value2);

        // Multiplication
        BigDecimal product = value1.multiply(value2);

        // Division with rounding
        BigDecimal quotient = value1.divide(value2, 2, RoundingMode.HALF_UP);

        // Scaling
        BigDecimal scaledValue = value1.setScale(3, RoundingMode.HALF_UP);

        System.out.println("Sum: " + sum);
        System.out.println("Product: " + product);
        System.out.println("Quotient: " + quotient);
        System.out.println("Scaled Value: " + scaledValue);
    }
}
```



## **Limitations of BigDecimal**

1. **Performance**: Slower than primitive types due to software-based implementation.
2. **Complex Syntax**: Operations require explicit method calls, unlike simple operators for primitive types.
3. **Memory Overhead**: Larger memory footprint compared to primitive types.
4. **Overhead of Immutability**: Frequent object creation can lead to increased garbage collection.

## **Use Cases**

1. **Financial Applications**: Precise currency calculations, avoiding rounding errors.
2. **Scientific Calculations**: Modeling data that requires high precision.
3. **Tax and Interest Rate Calculations**: Where fractions of pennies or percentage points matter.
4. **Cryptography**: Accurate mathematical computations for secure algorithms.

