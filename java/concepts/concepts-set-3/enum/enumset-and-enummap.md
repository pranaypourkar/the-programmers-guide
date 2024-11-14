# EnumSet and EnumMap

## **EnumSet**

`EnumSet` is a **Set** implementation specifically designed for use with **enum types**. It is a highly optimized collection that is more efficient than `HashSet` when dealing with enums.

### **Features of `EnumSet`**

* **Specialized for Enums**: It can only store enum values.
* **Efficient**: It uses bit vectors internally, making it much faster and more memory efficient than `HashSet` when working with enums.
* **No Null Values**: It does not allow `null` elements. Attempting to add `null` will throw a `NullPointerException`.
* **Order**: The order of the enum constants in the `EnumSet` is determined by their **natural order** (the order in which the constants are declared in the enum class). We can also use a specific ordering by providing a comparator.

```java
import java.util.EnumSet;

public enum LogLevel {
    ERROR, WARNING, INFO, DEBUG;
}

public class EnumSetExample {
    public static void main(String[] args) {
        // Create an EnumSet containing some enum constants
        EnumSet<LogLevel> logLevels = EnumSet.of(LogLevel.ERROR, LogLevel.WARNING);
        
        // Print the EnumSet
        System.out.println("Log levels: " + logLevels);

        // Add more values
        logLevels.add(LogLevel.INFO);
        System.out.println("After adding INFO: " + logLevels);

        // Remove a value
        logLevels.remove(LogLevel.WARNING);
        System.out.println("After removing WARNING: " + logLevels);

        // Create an EnumSet with all values
        EnumSet<LogLevel> allLogLevels = EnumSet.allOf(LogLevel.class);
        System.out.println("All log levels: " + allLogLevels);
    }
}
```

```less
Log levels: [ERROR, WARNING]
After adding INFO: [ERROR, WARNING, INFO]
After removing WARNING: [ERROR, INFO]
All log levels: [ERROR, WARNING, INFO, DEBUG]
```

### **Methods in `EnumSet`:**

* **`EnumSet.of(E... elements)`**: Creates an `EnumSet` with the specified enum constants.
* **`EnumSet.allOf(Class<E> elementType)`**: Creates an `EnumSet` containing all constants of the specified enum class.
* **`EnumSet.noneOf(Class<E> elementType)`**: Creates an empty `EnumSet`.
* **`EnumSet.copyOf(Collection<? extends E> c)`**: Creates an `EnumSet` containing all of the elements in the specified collection that are also enum constants of the same type.

## **EnumMap**

`EnumMap` is a **Map** implementation that uses **enum constants** as keys. It is optimized for use with enums as keys and provides superior performance over regular `HashMap` when the keys are enums.

### **Features of `EnumMap`:**

* **Specialized for Enums**: The keys in an `EnumMap` must be enum constants.
* **Efficient**: It is faster and uses less memory than a `HashMap` when the keys are enums, because it internally stores the mappings in an array, making lookups and insertions much faster.
* **Ordering**: The map is **ordered** based on the natural order of the enum constants (the order in which the constants are defined).
* **Null Keys Not Allowed**: It does not allow `null` keys. However, `null` values are allowed.

```java
import java.util.EnumMap;

public enum LogLevel {
    ERROR, WARNING, INFO, DEBUG;
}

public class EnumMapExample {
    public static void main(String[] args) {
        // Create an EnumMap where the key is LogLevel, and the value is a description
        EnumMap<LogLevel, String> logLevelDescriptions = new EnumMap<>(LogLevel.class);

        // Add entries to the EnumMap
        logLevelDescriptions.put(LogLevel.ERROR, "Critical error");
        logLevelDescriptions.put(LogLevel.WARNING, "Warning message");
        logLevelDescriptions.put(LogLevel.INFO, "Informational message");

        // Print the EnumMap
        System.out.println("Log level descriptions: " + logLevelDescriptions);

        // Retrieve a value
        System.out.println("INFO level description: " + logLevelDescriptions.get(LogLevel.INFO));
    }
}
```

```vbnet
Log level descriptions: {ERROR=Critical error, WARNING=Warning message, INFO=Informational message}
INFO level description: Informational message
```

### **Methods in `EnumMap`:**

* **`EnumMap(Class<K> keyType)`**: Creates an empty `EnumMap` with the specified enum type as the key.
* **`EnumMap.put(K key, V value)`**: Adds a key-value pair to the map.
* **`EnumMap.get(Object key)`**: Retrieves the value associated with the given key.
* **`EnumMap.remove(Object key)`**: Removes the entry for the specified key.

#### Comparison of `EnumSet` vs `EnumMap`:

<table data-header-hidden data-full-width="true"><thead><tr><th width="188"></th><th></th><th></th></tr></thead><tbody><tr><td>Feature</td><td><code>EnumSet</code></td><td><code>EnumMap</code></td></tr><tr><td><strong>Type</strong></td><td>A <code>Set</code> of enum values</td><td>A <code>Map</code> where keys are enum values</td></tr><tr><td><strong>Null Handling</strong></td><td>Does not allow <code>null</code> elements</td><td>Does not allow <code>null</code> keys, but allows <code>null</code> values</td></tr><tr><td><strong>Usage</strong></td><td>Used when you need a collection of enum values without duplicates</td><td>Used when you need to associate values with enum constants</td></tr><tr><td><strong>Efficiency</strong></td><td>More memory-efficient and faster than <code>HashSet</code></td><td>More memory-efficient and faster than <code>HashMap</code> for enums as keys</td></tr><tr><td><strong>Ordering</strong></td><td>Follows the natural order of enum constants</td><td>Follows the natural order of enum constants</td></tr></tbody></table>

