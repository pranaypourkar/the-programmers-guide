# Base Encoding Decoding Examples

## 1. Encoding Image to an BASE64 format so that it can be shared to web application via Backend Rest API.

### Step 1: Download any image and place it in a folder accessible to java project

<figure><img src="../../../../.gitbook/assets/arrows.jpg" alt="" width="375"><figcaption><p>arrows.jpg</p></figcaption></figure>

<figure><img src="../../../../.gitbook/assets/image (226).png" alt="" width="563"><figcaption></figcaption></figure>

### Step 2: Run the below Java Code to generate Base64 content of the above image

```java
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Base64;

public class ImageToBase64Conversion {

    public static void main(String[] args) throws IOException {
        // Path to our image file
        String imageBasePath = "/Users/pranayp/Documents/Project/Personal/sample-java-project/src/main/resources/image/";
        String arrowImage = imageBasePath + "arrows.jpg";

        try {
            // Convert image to Base64
            String base64Image = encodeImageToBase64(arrowImage);

            // Print the Base64 string
            System.out.println("--------------------");
            System.out.println(base64Image);
            System.out.println("--------------------");

        } catch (IOException e) {
            System.err.println("Exception occurred: " + e.getMessage());
        }
    }

    /**
     * Encodes the image at the given path to a Base64 string.
     *
     * @param imagePath the path of the image file to encode
     * @return the Base64-encoded string representation of the image
     * @throws IOException if an I/O error occurs during file reading
     */
    public static String encodeImageToBase64(String imagePath) throws IOException {
        // Create a File object from the given image path
        File file = new File(imagePath);

        // Allocate a byte array large enough to hold the entire file content
        byte[] imageBytes = new byte[(int) file.length()];

        // Use try-with-resources to ensure the FileInputStream is closed automatically
        try (FileInputStream fileInputStream = new FileInputStream(file)) {
            // Read the file content into the byte array
            fileInputStream.read(imageBytes);
        }

        // Encode the byte array to a Base64 string and return it
        return Base64.getEncoder().encodeToString(imageBytes);
    }
}

```

**Output**

{% file src="../../../../.gitbook/assets/Output (1).txt" %}

### Step 3: Copy the Base64 content to any online website which converts base64 to image in order to verify the encoded image

Sample Website: [https://base64.guru/converter/decode/image](https://base64.guru/converter/decode/image)

<figure><img src="../../../../.gitbook/assets/image (227).png" alt=""><figcaption></figcaption></figure>
