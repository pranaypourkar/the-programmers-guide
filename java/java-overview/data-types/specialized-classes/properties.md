# Properties

## About

The **`Properties`** class in Java is a part of the `java.util` package and provides a framework for managing application configuration through key-value pairs. It is particularly useful for reading and writing configuration files, especially `.properties` files.

* The `Properties` class is a subclass of `Hashtable` that is specifically designed to handle string-based key-value pairs.
* Commonly used for managing application settings, localization, and configuration in Java programs.
* It supports persistent storage, allowing properties to be saved to or loaded from input/output streams.
* Frequently used in combination with Java's resource bundles for internationalization.

## **Features**

1. **Key-Value Pair Management:** Stores configuration as string-based key-value pairs.
2. **Persistent Storage:** Can read from and write to files using input/output streams.
3. **Integration with I18N:** Often used for internationalization by loading localized `.properties` files.
4. **Backward Compatibility:** Inherits methods from `Hashtable`, making it versatile and compatible with legacy code.
5. **Ease of Use:** Simplifies reading and writing configuration properties.

## **Declaration**

To use the `Properties` class, it needs to be imported:

```java
import java.util.Properties;
```

## **Methods Available**

### **1. Loading Properties**

* `load(InputStream inStream)`: Loads properties from an input stream.
* `load(Reader reader)`: Loads properties from a character stream.

### **2. Saving Properties**

* `store(OutputStream out, String comments)`: Writes properties to an output stream with optional comments.
* `store(Writer writer, String comments)`: Writes properties to a character stream with optional comments.

### **3. Getting and Setting Properties**

* `getProperty(String key)`: Retrieves the property value associated with the key.
* `setProperty(String key, String value)`: Sets a property key-value pair.
* `getOrDefault(Object key, Object defaultValue)`: Returns the property value or a default value if the key is not found.

### **4. Listing Properties**

* `list(PrintStream out)`: Prints all properties to a print stream.
* `list(PrintWriter out)`: Prints all properties to a print writer.

### **5. Removing and Checking Keys**

* `remove(Object key)`: Removes the property associated with the specified key.
* `containsKey(Object key)`: Checks if a property key exists.

### **6. Default Properties**

* A `Properties` object can be constructed with a default `Properties` object, enabling a fallback mechanism for properties.

## **Usage**

### **1. Basic Loading and Retrieving Properties**

```java
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;

public class PropertiesExample {
    public static void main(String[] args) {
        Properties properties = new Properties();

        try (FileInputStream fis = new FileInputStream("config.properties")) {
            properties.load(fis);
        } catch (IOException e) {
            e.printStackTrace();
        }

        // Retrieve properties
        String host = properties.getProperty("host");
        String port = properties.getProperty("port", "8080"); // Default value
        System.out.println("Host: " + host);
        System.out.println("Port: " + port);
    }
}
```

### **2. Writing Properties to a File**

```java
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Properties;

public class PropertiesWriteExample {
    public static void main(String[] args) {
        Properties properties = new Properties();

        properties.setProperty("host", "localhost");
        properties.setProperty("port", "8080");
        properties.setProperty("timeout", "30");

        try (FileOutputStream fos = new FileOutputStream("config.properties")) {
            properties.store(fos, "Application Configuration");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

### **3. Using Default Properties**

```java
import java.util.Properties;

public class DefaultPropertiesExample {
    public static void main(String[] args) {
        Properties defaultProps = new Properties();
        defaultProps.setProperty("host", "localhost");
        defaultProps.setProperty("port", "8080");

        Properties appProps = new Properties(defaultProps);
        appProps.setProperty("timeout", "30");

        System.out.println("Host: " + appProps.getProperty("host")); // Defaults to "localhost"
        System.out.println("Port: " + appProps.getProperty("port")); // Defaults to "8080"
        System.out.println("Timeout: " + appProps.getProperty("timeout")); // "30"
    }
}
```

### **4. Loading Properties from Classpath**

```java
import java.io.IOException;
import java.util.Properties;

public class ClasspathPropertiesExample {
    public static void main(String[] args) {
        Properties properties = new Properties();

        try (var inputStream = ClasspathPropertiesExample.class.getClassLoader()
                .getResourceAsStream("config.properties")) {
            if (inputStream == null) {
                System.out.println("Properties file not found.");
                return;
            }
            properties.load(inputStream);
        } catch (IOException e) {
            e.printStackTrace();
        }

        System.out.println(properties.getProperty("app.name"));
    }
}
```

## **Applications and Real-World Usage**

1. **Application Configuration:** Store and manage application settings, such as database configurations, API keys, and server details.
2. **Internationalization (I18N):** Load localized strings from `.properties` files for multi-language support.
3. **Default and Fallback Mechanism:** Set default properties to ensure fallback values when specific properties are not provided.
4. **Environment-Specific Configurations:** Use different `.properties` files for development, staging, and production environments.
5. **Test Data:** Store reusable test data or configuration for automated tests.
