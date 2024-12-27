# Encoding and Decoding in Java

## Converting character to ASCII value, vice versa

```java
public class Ascii {
    public static void main(String [] args) {

        // Getting ASCII Value/Code of a Character
        char ch1 = 'A';
        int asciiValue1 = (int) ch1;
        System.out.println("ASCII value of " + ch1 + " is: " + asciiValue1);

        // Getting Character from ASCII Value/Code
        int asciiValue2 = 65;
        char ch2 = (char) asciiValue2;
        System.out.println("Character for ASCII value " + asciiValue2 + " is: " + ch2);

    }
}
```

<figure><img src="../../../../../../.gitbook/assets/image (61).png" alt="" width="500"><figcaption></figcaption></figure>
