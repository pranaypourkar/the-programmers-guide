# Java Program

## Number System Conversion&#x20;

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

<figure><img src="../../../../../.gitbook/assets/image (240).png" alt="" width="391"><figcaption></figcaption></figure>

