# EnumMap

## **About**

`EnumMap` is a specialized implementation of the `Map` interface designed to work exclusively with **enum keys**. It is part of the Java Collections Framework (`java.util` package). `EnumMap` is highly efficient because it internally uses an array to map enum keys to their corresponding values.

Unlike general-purpose maps like `HashMap` or `TreeMap`, `EnumMap` exploits the unique characteristics of enums to optimize performance and memory usage.

## **Features**

1. **Enum-Only Keys**: Keys must be of a single `enum` type; attempting to use a non-enum key results in a `ClassCastException`.
2. **Highly Efficient**: It is implemented using an internal array indexed by the ordinal values of the enum constants, offering very fast lookups.
3. **Maintains Natural Order**: Keys are maintained in their natural order (the order in which they are declared in the `enum`).
4. **Null Keys Not Allowed**: `EnumMap` does not permit `null` keys but allows `null` values.
5. **Lightweight and Memory Efficient**: Compared to other map implementations, `EnumMap` is very lightweight and compact.
6. **Non-Thread Safe**: `EnumMap` is not synchronized and must be explicitly synchronized for concurrent access.

## **Internal Working**

### **1. Key Storage**

* Internally, `EnumMap` uses an **array** indexed by the ordinal values of the enum constants.
* Each index corresponds directly to an enum constant, and the associated value is stored at that index.

### **2. Initialization**

* When an `EnumMap` is created, it requires the `Class` object of the enum type.
* The size of the internal array is determined by the number of constants in the enum.

### **3. Operations**

* **Put (`put(K key, V value)`)**:
  * The ordinal of the key enum is computed.
  * The value is stored in the corresponding index of the array.
* **Get (`get(Object key)`)**:
  * The key's ordinal is used to retrieve the value from the array.
* **Remove (`remove(Object key)`)**:
  * Sets the array index corresponding to the key’s ordinal to `null`.

### **4. Null Handling**

* While `null` keys are not allowed, `null` values are permitted. If no value is set for a key, the corresponding array index remains `null`.

## **Key Methods**

<table data-header-hidden data-full-width="true"><thead><tr><th width="352"></th><th></th></tr></thead><tbody><tr><td><strong>Method</strong></td><td><strong>Description</strong></td></tr><tr><td><code>put(K key, V value)</code></td><td>Associates the specified value with the specified key.</td></tr><tr><td><code>get(Object key)</code></td><td>Retrieves the value associated with the specified key.</td></tr><tr><td><code>remove(Object key)</code></td><td>Removes the mapping for the specified key.</td></tr><tr><td><code>containsKey(Object key)</code></td><td>Checks if the map contains the specified key.</td></tr><tr><td><code>containsValue(Object value)</code></td><td>Checks if the map contains the specified value.</td></tr><tr><td><code>keySet()</code></td><td>Returns a <code>Set</code> view of the keys (enum constants) in the map.</td></tr><tr><td><code>values()</code></td><td>Returns a <code>Collection</code> view of the values in the map.</td></tr><tr><td><code>entrySet()</code></td><td>Returns a <code>Set</code> view of the key-value pairs.</td></tr><tr><td><code>size()</code></td><td>Returns the number of key-value mappings in the map.</td></tr><tr><td><code>clear()</code></td><td>Removes all mappings from the map.</td></tr></tbody></table>

## **Big-O for Operations**

| **Operation** | **Time Complexity** |
| ------------- | ------------------- |
| **Put**       | O(1)                |
| **Get**       | O(1)                |
| **Remove**    | O(1)                |
| **Iteration** | O(n)                |

## **Limitations**

1. **Enum-Only Keys**: Only enums can be used as keys, which limits its applicability.
2. **Not Thread-Safe**: Requires external synchronization for multi-threaded use.
3. **Initialization Requirement**: Requires the enum class to initialize.

## **Real-World Usage**

1. **Configuration Management**: Storing settings or preferences based on enum constants.
2. **State Machines**: Mapping states (represented as enums) to actions or transitions.
3. **Mapping Constants to Values**: Associating enum constants with additional metadata.

## **Examples**

### **1. Basic Operations**

```java
import java.util.EnumMap;

enum Day {
    MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY
}

public class EnumMapExample {
    public static void main(String[] args) {
        EnumMap<Day, String> schedule = new EnumMap<>(Day.class);

        // Adding entries
        schedule.put(Day.MONDAY, "Gym");
        schedule.put(Day.WEDNESDAY, "Grocery Shopping");
        schedule.put(Day.FRIDAY, "Movie Night");
        System.out.println(schedule); // Output: {MONDAY=Gym, WEDNESDAY=Grocery Shopping, FRIDAY=Movie Night}

        // Accessing an entry
        System.out.println(schedule.get(Day.WEDNESDAY)); // Output: Grocery Shopping

        // Removing an entry
        schedule.remove(Day.FRIDAY);
        System.out.println(schedule); // Output: {MONDAY=Gym, WEDNESDAY=Grocery Shopping}
    }
}
```

### **2. Iteration**

```java
import java.util.EnumMap;

enum Fruit {
    APPLE, BANANA, CHERRY
}

public class IterationExample {
    public static void main(String[] args) {
        EnumMap<Fruit, Integer> fruitPrices = new EnumMap<>(Fruit.class);

        // Adding entries
        fruitPrices.put(Fruit.APPLE, 100);
        fruitPrices.put(Fruit.BANANA, 50);
        fruitPrices.put(Fruit.CHERRY, 200);

        // Iterating over key-value pairs
        for (var entry : fruitPrices.entrySet()) {
            System.out.println(entry.getKey() + " costs " + entry.getValue());
        }
        // Output:
        // APPLE costs 100
        // BANANA costs 50
        // CHERRY costs 200
    }
}
```

### **3. Using with Null Values**

```java
import java.util.EnumMap;

enum Status {
    SUCCESS, FAILURE, PENDING
}

public class NullValueExample {
    public static void main(String[] args) {
        EnumMap<Status, String> messages = new EnumMap<>(Status.class);

        // Adding entries with null values
        messages.put(Status.SUCCESS, "Operation successful");
        messages.put(Status.PENDING, null);

        System.out.println(messages); // Output: {SUCCESS=Operation successful, PENDING=null}

        // Checking for a specific value
        System.out.println(messages.containsValue(null)); // Output: true
    }
}
```



