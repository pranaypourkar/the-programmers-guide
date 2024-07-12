# Number System

## About

Number systems are methods for representing numbers in a consistent manner. They are essential for various fields, including mathematics, computer science, and engineering. There are 4 commonly used system i.e. Decimal, Binary, Octal, and Hexadecimal.

## Decimal Number System (Base 10)

### **Overview:**

* The most common number system used in daily life.
* Base 10 system, which means it has 10 digits: 0, 1, 2, 3, 4, 5, 6, 7, 8, and 9.
* Each digit's position in a number has a value that is a power of 10.

### **Example:**

* The number 345 in decimal can be expressed as:&#x20;

<figure><img src="../../../../.gitbook/assets/image.png" alt="" width="266"><figcaption></figcaption></figure>

### **Usage:**

* Used universally in everyday arithmetic and counting.

### Conversion:

<figure><img src="../../../../.gitbook/assets/image (4).png" alt="" width="563"><figcaption></figcaption></figure>

## Binary Number System (Base 2)

### **Overview:**

* Used primarily in computing and digital electronics.
* Base 2 system, with only two digits: 0 and 1.
* Each digit's position in a number has a value that is a power of 2.

### **Example:**

* The binary number 1011 can be expressed as

<figure><img src="../../../../.gitbook/assets/image (1).png" alt="" width="461"><figcaption></figcaption></figure>

### **Usage:**

* Binary code is the fundamental language of computers.
* Used in digital circuits and data representation in computers.

### Conversion:

<figure><img src="../../../../.gitbook/assets/image (8).png" alt="" width="563"><figcaption></figcaption></figure>

## Octal Number System (Base 8)

### **Overview:**

* Base 8 system, with eight digits: 0, 1, 2, 3, 4, 5, 6, and 7.
* Each digit's position in a number has a value that is a power of 8.
* Group by 3 bits i.e. (2^3 = 8) in a binary number.

### **Example:**

* The octal number 345 can be expressed as:

<figure><img src="../../../../.gitbook/assets/image (2).png" alt="" width="400"><figcaption></figcaption></figure>

### **Usage:**

* Sometimes used in computing as a more compact representation of binary-coded values.
* Historically significant in early computing systems.

### Conversion:

<figure><img src="../../../../.gitbook/assets/image (6).png" alt="" width="563"><figcaption></figcaption></figure>

## Hexadecimal Number System (Base 16)

### **Overview:**

* Base 16 system, with sixteen digits: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, A, B, C, D, E, and F.
* Each digit's position in a number has a value that is a power of 16.
* Group by 4 bits i.e. (2^4 = 16) in a binary number.

### **Example:**

* The hexadecimal number 1A3 can be expressed as:

<figure><img src="../../../../.gitbook/assets/image (3).png" alt="" width="458"><figcaption></figcaption></figure>

### **Usage:**

* Widely used in computer science and programming.
* Handy for representing large binary values compactly, such as memory addresses and color codes in web design.

### Conversion:

<figure><img src="../../../../.gitbook/assets/image (7).png" alt="" width="563"><figcaption></figcaption></figure>

## Java Code for Number System Conversion&#x20;

```java
public class NumberSystemConverter {

    // Decimal to Binary, Octal, Hexadecimal
    public static void decimalToOtherSystems(int decimal) {
        String binary = Integer.toBinaryString(decimal);
        String octal = Integer.toOctalString(decimal);
        String hexadecimal = Integer.toHexString(decimal).toUpperCase();

        System.out.println("Decimal: " + decimal);
        System.out.println("Binary: " + binary);
        System.out.println("Octal: " + octal);
        System.out.println("Hexadecimal: " + hexadecimal);
    }

    // Binary to Decimal, Octal, Hexadecimal
    public static void binaryToOtherSystems(String binary) {
        int decimal = Integer.parseInt(binary, 2);
        int octal = Integer.parseInt(binary, 2);
        String hexadecimal = Integer.toHexString(decimal).toUpperCase();

        System.out.println("Binary: " + binary);
        System.out.println("Decimal: " + decimal);
        System.out.println("Octal: " + Integer.toOctalString(octal));
        System.out.println("Hexadecimal: " + hexadecimal);
    }

    // Octal to Decimal, Binary, Hexadecimal
    public static void octalToOtherSystems(String octal) {
        int decimal = Integer.parseInt(octal, 8);
        String binary = Integer.toBinaryString(decimal);
        String hexadecimal = Integer.toHexString(decimal).toUpperCase();

        System.out.println("Octal: " + octal);
        System.out.println("Decimal: " + decimal);
        System.out.println("Binary: " + binary);
        System.out.println("Hexadecimal: " + hexadecimal);
    }

    // Hexadecimal to Decimal, Binary, Octal
    public static void hexadecimalToOtherSystems(String hexadecimal) {
        int decimal = Integer.parseInt(hexadecimal, 16);
        String binary = Integer.toBinaryString(decimal);
        String octal = Integer.toOctalString(decimal);

        System.out.println("Hexadecimal: " + hexadecimal);
        System.out.println("Decimal: " + decimal);
        System.out.println("Binary: " + binary);
        System.out.println("Octal: " + octal);
    }

    public static void main(String[] args) {
        // Example conversions
        System.out.println("--- Decimal to Binary, Octal, Hexadecimal ---");
        decimalToOtherSystems(26);
        System.out.println();

        System.out.println("--- Binary to Decimal, Octal, Hexadecimal ---");
        binaryToOtherSystems("10110");
        System.out.println();

        System.out.println("--- Octal to Decimal, Binary, Hexadecimal ---");
        octalToOtherSystems("32");
        System.out.println();

        System.out.println("--- Hexadecimal to Decimal, Binary, Octal ---");
        hexadecimalToOtherSystems("1A");
    }
}
```

<figure><img src="../../../../.gitbook/assets/image (240).png" alt="" width="391"><figcaption></figcaption></figure>



