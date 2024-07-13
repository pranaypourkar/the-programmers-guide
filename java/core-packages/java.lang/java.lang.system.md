# java.lang.System

## About

The `java.lang.System` class is a crucial part of the Java Standard Library, providing a collection of static methods and fields that allow interaction with the environment in which the Java application is running.

The `System` class cannot be instantiated. It provides various useful class fields and methods to handle standard input, output, and error streams; access to system properties and environment variables; and utility methods for array copying, garbage collection, and time measurement.

## Standard Streams

The `System` class provides three standard I/O stream objects:

* `System.in`: Standard input stream (an instance of `InputStream`).
* `System.out`: Standard output stream (an instance of `PrintStream`).
* `System.err`: Standard error stream (an instance of `PrintStream`).

## System Properties

System properties are key-value pairs that provide information about the runtime environment. These properties can be accessed and modified using the `System.getProperty`, `System.setProperty`, and `System.getProperties` methods.

### Commonly Used System Properties

<table data-full-width="true"><thead><tr><th width="362">Property Key</th><th>Description</th></tr></thead><tbody><tr><td><code>java.version</code></td><td>Java Runtime Environment version</td></tr><tr><td><code>java.vendor</code></td><td>Java Runtime Environment vendor</td></tr><tr><td><code>java.vendor.url</code></td><td>Java vendor URL</td></tr><tr><td><code>java.home</code></td><td>Java installation directory</td></tr><tr><td><code>java.vm.specification.version</code></td><td>Java Virtual Machine specification version</td></tr><tr><td><code>java.vm.specification.vendor</code></td><td>Java Virtual Machine specification vendor</td></tr><tr><td><code>java.vm.specification.name</code></td><td>Java Virtual Machine specification name</td></tr><tr><td><code>java.vm.version</code></td><td>Java Virtual Machine implementation version</td></tr><tr><td><code>java.vm.vendor</code></td><td>Java Virtual Machine implementation vendor</td></tr><tr><td><code>java.vm.name</code></td><td>Java Virtual Machine implementation name</td></tr><tr><td><code>java.specification.version</code></td><td>Java Runtime Environment specification version</td></tr><tr><td><code>java.specification.vendor</code></td><td>Java Runtime Environment specification vendor</td></tr><tr><td><code>java.specification.name</code></td><td>Java Runtime Environment specification name</td></tr><tr><td><code>java.class.version</code></td><td>Java class format version number</td></tr><tr><td><code>java.class.path</code></td><td>Java class path</td></tr><tr><td><code>java.library.path</code></td><td>List of paths to search when loading libraries</td></tr><tr><td><code>java.io.tmpdir</code></td><td>Default temp file path</td></tr><tr><td><code>java.compiler</code></td><td>Name of JIT compiler to use</td></tr><tr><td><code>java.ext.dirs</code></td><td>Path of extension directory or directories</td></tr><tr><td><code>os.name</code></td><td>Operating system name</td></tr><tr><td><code>os.arch</code></td><td>Operating system architecture</td></tr><tr><td><code>os.version</code></td><td>Operating system version</td></tr><tr><td><code>file.separator</code></td><td>File separator ("/" on UNIX, "" on Windows)</td></tr><tr><td><code>path.separator</code></td><td>Path separator (":" on UNIX, ";" on Windows)</td></tr><tr><td><code>line.separator</code></td><td>Line separator ("\n" on UNIX, "\r\n" on Windows)</td></tr><tr><td><code>user.name</code></td><td>User account name</td></tr><tr><td><code>user.home</code></td><td>User home directory</td></tr><tr><td><code>user.dir</code></td><td>User's current working directory</td></tr></tbody></table>

### Accessing System Properties

We can access and modify system properties using the following methods:

* `System.getProperty(String key)`: Returns the value of the specified system property.
* `System.getProperty(String key, String defaultValue)`: Returns the value of the specified system property, or the default value if the property is not found.
* `System.setProperty(String key, String value)`: Sets the system property to the specified value.
* `System.getProperties()`: Returns a `Properties` object containing all system properties.
* `System.setProperties(Properties props)`: Sets the system properties to the specified `Properties` object.

### Example: Accessing System Properties

```java
public class SystemPropertiesExample {
    public static void main(String[] args) {
        // Accessing common system properties
        System.out.println("Java Version: " + System.getProperty("java.version"));
        System.out.println("OS Name: " + System.getProperty("os.name"));
        System.out.println("User Name: " + System.getProperty("user.name"));

        // Setting and getting a custom property
        System.setProperty("my.custom.property", "customValue");
        System.out.println("Custom Property: " + System.getProperty("my.custom.property"));
    }
}
```

## Environment Variables

We can access environment variables using the `System.getenv` method:

* `System.getenv(String name)`: Returns the value of the specified environment variable.
* `System.getenv()`: Returns a map of all environment variables.

### Example: Accessing Environment Variables

```java
public class EnvironmentVariablesExample {
    public static void main(String[] args) {
        // Accessing a specific environment variable
        String path = System.getenv("PATH");
        System.out.println("PATH: " + path);

        // Accessing all environment variables
        Map<String, String> env = System.getenv();
        for (String envName : env.keySet()) {
            System.out.println(envName + " = " + env.get(envName));
        }
    }
}
```

## Utility Methods

### **Array Copying**

* `System.arraycopy(Object src, int srcPos, Object dest, int destPos, int length)`: Copies elements from one array to another.

### **Garbage Collection**

* `System.gc()`: Suggests that the JVM performs garbage collection.

### **Current Time**

* `System.currentTimeMillis()`: Returns the current time in milliseconds since the epoch (January 1, 1970, 00:00:00 GMT).
* `System.nanoTime()`: Returns the current value of the running JVM's high-resolution time source, in nanoseconds.

### Example: Using Utility Methods

```java
public class SystemUtilityMethodsExample {
    public static void main(String[] args) {
        // Array copying
        int[] sourceArray = {1, 2, 3, 4, 5};
        int[] destinationArray = new int[5];
        System.arraycopy(sourceArray, 0, destinationArray, 0, sourceArray.length);
        System.out.println("Copied Array: " + java.util.Arrays.toString(destinationArray));

        // Getting current time in milliseconds
        long currentTimeMillis = System.currentTimeMillis();
        System.out.println("Current Time (ms): " + currentTimeMillis);

        // Getting current time in nanoseconds
        long currentNanoTime = System.nanoTime();
        System.out.println("Current Time (ns): " + currentNanoTime);

        // Suggesting garbage collection
        System.gc();
        System.out.println("Garbage collection suggested.");
    }
}
```

## Exiting the JVM

* `System.exit(int status)`: Terminates the currently running JVM. A non-zero status code indicates abnormal termination, while a zero status code indicates normal termination.

### Example: Exiting the JVM

```java
public class ExitExample {
    public static void main(String[] args) {
        System.out.println("Exiting the program with status 0.");
        System.exit(0);
    }
}
```

