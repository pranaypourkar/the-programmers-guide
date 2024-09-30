# Best Practice

## Scenario 1: A method logic throwing multiple exceptions

Consider the following code where the logic inside it can throw various exceptions.

```java
public static String encrypt(String plainText, String secretKey) throws InvalidAlgorithmParameterException,
            NoSuchPaddingException, IllegalBlockSizeException, NoSuchAlgorithmException,
            IOException, BadPaddingException, NoSuchProviderException, InvalidKeyException {
   // Some encryption logic             
}
```

Throwing multiple exceptions in a method signature can indicate that the method is handling a wide range of potential issues, which may or may not be a good practice depending on the context.

#### Pros

1. **Explicit Error Handling:** Declaring all potential exceptions makes the method's error handling explicit, allowing the caller to handle each specific case.
2. **Separation of Concerns:** The method handles specific low-level issues (like cryptography errors), keeping the handling separate from the business logic.

#### Cons

1. **Cluttered Signature:** Too many exceptions can make the method signature unwieldy and harder to read.
2. **Poor Abstraction:** Exposing too many implementation details can lead to poor abstraction, making the code harder to maintain and understand.

#### Best practice is to throw a custom exception in this scenario

```java
public class EncryptionException extends Exception {
    public EncryptionException(String message, Throwable cause) {
        super(message, cause);
    }
}

public static String encrypt(String plainText, String secretKey) throws EncryptionException {
    try {
        // encryption logic here
    } catch (InvalidAlgorithmParameterException | NoSuchPaddingException | IllegalBlockSizeException | 
             NoSuchAlgorithmException | IOException | BadPaddingException | 
             NoSuchProviderException | InvalidKeyException e) {
        throw new EncryptionException("Encryption failed", e);
    }
}
```
