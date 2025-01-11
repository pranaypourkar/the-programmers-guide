# Math

## About

The **`Math`** library in Java provides a set of methods and constants for performing mathematical operations. It is part of the `java.lang` package and does not require an explicit import. The `Math` class contains static methods, making it easy to perform basic and advanced mathematical computations without creating an instance of the class.

* The **`Math`** class was introduced in Java 1.0 to provide essential mathematical functions like trigonometry, logarithms, square roots, and more.
* It is a utility class with only static methods, meaning its methods can be invoked without creating an object.
* Common use cases include performing arithmetic, rounding, finding absolute values, generating random numbers, and trigonometric computations.
* The class also provides two constants:
  * **`Math.PI`**: Represents the value of π (3.14159...).
  * **`Math.E`**: Represents the base of the natural logarithm (2.718...).

## **Features**

1. **Static Methods:** All methods are static, allowing direct access without instantiating the class.
2. **Precision:** High precision for floating-point operations, supporting both `double` and `float`.
3. **Range of Functions:** Offers a wide variety of mathematical operations, from basic arithmetic to complex trigonometric functions.
4. **Platform Independence:** Methods are implemented in a platform-independent way, ensuring consistent results across environments.
5. **Efficient Implementations:** Provides efficient implementations optimized for performance.
6. **Random Number Generation:** Includes methods for generating random numbers for use in simulations and algorithms.

## **Methods Available**

### **Arithmetic Operations**

* `Math.abs(x)` - Returns the absolute value of `x`.
* `Math.max(x, y)` - Returns the maximum of `x` and `y`.
* `Math.min(x, y)` - Returns the minimum of `x` and `y`.
* `Math.addExact(x, y)` - Returns the sum of `x` and `y`, throwing an exception if the result overflows.
* `Math.subtractExact(x, y)` - Returns the difference of `x` and `y`, throwing an exception if the result overflows.
* `Math.multiplyExact(x, y)` - Returns the product of `x` and `y`, throwing an exception if the result overflows.
* `Math.negateExact(x)` - Returns the negation of `x`.

### **Exponential and Logarithmic Functions**

* `Math.exp(x)` - Returns `e^x`.
* `Math.log(x)` - Returns the natural logarithm (base e) of `x`.
* `Math.log10(x)` - Returns the base-10 logarithm of `x`.
* `Math.pow(x, y)` - Returns `x` raised to the power of `y`.
* `Math.sqrt(x)` - Returns the square root of `x`.
* `Math.cbrt(x)` - Returns the cube root of `x`.

### **Rounding and Precision**

* `Math.ceil(x)` - Rounds `x` upward to the nearest integer.
* `Math.floor(x)` - Rounds `x` downward to the nearest integer.
* `Math.round(x)` - Rounds `x` to the nearest integer.
* `Math.rint(x)` - Returns the integer that is closest to `x`.

### **Trigonometric Functions**

* `Math.sin(x)` - Returns the sine of `x` (in radians).
* `Math.cos(x)` - Returns the cosine of `x` (in radians).
* `Math.tan(x)` - Returns the tangent of `x` (in radians).
* `Math.asin(x)` - Returns the arc sine of `x` (in radians).
* `Math.acos(x)` - Returns the arc cosine of `x` (in radians).
* `Math.atan(x)` - Returns the arc tangent of `x` (in radians).
* `Math.atan2(y, x)` - Returns the angle θ from the conversion of rectangular coordinates `(x, y)` to polar coordinates `(r, θ)`.

### **Random Numbers**

* `Math.random()` - Returns a random number between `0.0` (inclusive) and `1.0` (exclusive).

### **Other Utility Methods**

* `Math.signum(x)` - Returns the sign of `x` (-1.0, 0.0, or 1.0).
* `Math.hypot(x, y)` - Returns √(x² + y²) without intermediate overflow or underflow.
* `Math.toRadians(x)` - Converts degrees to radians.
* `Math.toDegrees(x)` - Converts radians to degrees.
* `Math.ulp(x)` - Returns the size of the unit of least precision (ULP) of `x`.

## **Declaration and Usage**

### **Declaration:**

The `Math` class is part of `java.lang` and is automatically available in any Java program without explicit import.

**Using Math Methods:**

1.  **Basic Usage:**

    ```java
    int max = Math.max(10, 20);       // Returns 20
    double sqrt = Math.sqrt(49);     // Returns 7.0
    double sinValue = Math.sin(Math.toRadians(90)); // Returns 1.0
    ```
2.  **Generating Random Numbers:**

    ```java
    double random = Math.random();   // Returns a random value between 0.0 and 1.0
    ```
3.  **Complex Calculations:**

    ```java
    double hypot = Math.hypot(3, 4); // Returns 5.0 (Pythagoras theorem: √(3² + 4²))
    double power = Math.pow(2, 10);  // Returns 1024.0
    ```
4.  **Trigonometry:**

    ```java
    double angleInRadians = Math.toRadians(45);
    double cosine = Math.cos(angleInRadians); // Returns cosine of 45 degrees
    ```
5.  **Rounding Values:**

    ```java
    double roundedValue = Math.round(10.6);  // Returns 11
    double floorValue = Math.floor(10.6);   // Returns 10.0
    double ceilValue = Math.ceil(10.6);     // Returns 11.0
    ```

### **Usage**

1. **Scientific Computations:** Used for trigonometric calculations, power functions, and logarithmic operations.
2. **Gaming Applications:** Generating random numbers for simulations, dice rolls, or other stochastic processes.
3. **Financial Calculations:** Rounding off currency values, calculating interest rates, or performing statistical operations.
4. **Graphics and Geometry:** Used in computer graphics for angle calculations, distance computations, and vector manipulations.
5. **Data Science and Machine Learning:** Commonly used in mathematical modeling, optimization algorithms, and statistical functions.
