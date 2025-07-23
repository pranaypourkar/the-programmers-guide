# EnumSet

## **About**

`EnumSet` is a specialized `Set` implementation for use with enum types. It is a high-performance, memory-efficient collection that stores elements of an enumerated type in a bit-vector, enabling operations like iteration and manipulation to be faster compared to other `Set` implementations. All elements in an `EnumSet` must belong to the same enum type.

## **Features**

1. **Enum-Specific**: Works exclusively with enums.
2. **High Performance**: Internally implemented as a bit vector, making operations faster.
3. **Compact Representation**: Uses less memory compared to other `Set` implementations like `HashSet`.
4. **Natural Order**: Maintains elements in their natural order as defined in the enum declaration.
5. **Efficient Range Operations**: Provides methods to create sets based on ranges of enum constants.
6. **No Nulls**: Does not allow `null` values.
7. **Not Thread-Safe**: Requires external synchronization for concurrent access.

## **Internal Working**

### **Bit-Vector Representation**

* The `EnumSet` uses a bit-vector representation internally.
* Each bit in the vector represents a specific constant of the enum type.
* For example, if an enum has three constants, `A`, `B`, and `C`, the bit positions represent `A=1`, `B=2`, and `C=4`.

### **Storage Efficiency**

* For enums with fewer constants, it uses a single `long` to represent the set.
* For enums with a larger number of constants, it switches to an array of `long` values.

### **Underlying Implementations**

* **RegularEnumSet**: Used for enums with fewer constants (fits in a single `long`).
* **JumboEnumSet**: Used for enums with a large number of constants (requires multiple `long` values).

### **Operations**

* Adding an element sets the corresponding bit in the vector.
* Removing an element clears the corresponding bit.
* Checking for an element involves inspecting the bit corresponding to the constant.

## **Key Methods**

<table data-header-hidden data-full-width="true"><thead><tr><th width="341"></th><th></th></tr></thead><tbody><tr><td><strong>Method</strong></td><td><strong>Description</strong></td></tr><tr><td><code>of(E... elements)</code></td><td>Creates an <code>EnumSet</code> containing the specified elements.</td></tr><tr><td><code>allOf(Class&#x3C;E> elementType)</code></td><td>Creates an <code>EnumSet</code> containing all elements of the specified enum type.</td></tr><tr><td><code>noneOf(Class&#x3C;E> elementType)</code></td><td>Creates an empty <code>EnumSet</code> of the specified enum type.</td></tr><tr><td><code>range(E from, E to)</code></td><td>Creates an <code>EnumSet</code> containing elements within the specified range.</td></tr><tr><td><code>add(E e)</code></td><td>Adds the specified element to the set.</td></tr><tr><td><code>addAll(Collection&#x3C;E>)</code></td><td>Adds all elements from the specified collection.</td></tr><tr><td><code>remove(E e)</code></td><td>Removes the specified element from the set.</td></tr><tr><td><code>contains(E e)</code></td><td>Returns <code>true</code> if the set contains the specified element.</td></tr><tr><td><code>size()</code></td><td>Returns the number of elements in the set.</td></tr><tr><td><code>iterator()</code></td><td>Returns an iterator for the set elements.</td></tr><tr><td><code>clone()</code></td><td>Creates a shallow copy of the <code>EnumSet</code>.</td></tr></tbody></table>

## **Big-O for Operations**

| **Operation** | **Time Complexity** |
| ------------- | ------------------- |
| **Add**       | O(1)                |
| **Remove**    | O(1)                |
| **Contains**  | O(1)                |
| **Iteration** | O(n)                |

## **Limitations**

1. **Enum-Only**: Works exclusively with enum types and cannot be used for general objects.
2. **Non-Thread-Safe**: Requires external synchronization for concurrent use.
3. **No Null Values**: Does not support `null` elements.

## **Real-World Usage**

1. **State Tracking**: Tracking states or flags represented by enums.
2. **Permission Management**: Managing access levels or permissions using enums.
3. **Efficient Range Queries**: Selecting subsets of enum constants for processing.
4. **Configuration**: Representing configurations where options are predefined.

## **Examples**

### **1. Basic Operations**

```java
import java.util.EnumSet;

enum Day {
    MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY
}

public class EnumSetExample {
    public static void main(String[] args) {
        EnumSet<Day> workdays = EnumSet.of(Day.MONDAY, Day.TUESDAY, Day.WEDNESDAY, Day.THURSDAY, Day.FRIDAY);

        System.out.println(workdays); // Output: [MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY]

        // Add an element
        workdays.add(Day.SATURDAY);
        System.out.println(workdays); // Output: [MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY]

        // Remove an element
        workdays.remove(Day.MONDAY);
        System.out.println(workdays); // Output: [TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY]

        // Check for an element
        System.out.println(workdays.contains(Day.SUNDAY)); // Output: false
    }
}
```

### **2. Creating from Range**

```java
import java.util.EnumSet;

enum Level {
    LOW, MEDIUM, HIGH, CRITICAL
}

public class RangeExample {
    public static void main(String[] args) {
        EnumSet<Level> criticalAndAbove = EnumSet.range(Level.HIGH, Level.CRITICAL);
        System.out.println(criticalAndAbove); // Output: [HIGH, CRITICAL]
    }
}
```

### **3. Creating Empty and All Elements Set**

```java
import java.util.EnumSet;

enum Color {
    RED, GREEN, BLUE, YELLOW
}

public class AllOfAndNoneOfExample {
    public static void main(String[] args) {
        EnumSet<Color> allColors = EnumSet.allOf(Color.class);
        System.out.println(allColors); // Output: [RED, GREEN, BLUE, YELLOW]

        EnumSet<Color> noColors = EnumSet.noneOf(Color.class);
        System.out.println(noColors); // Output: []

        noColors.add(Color.RED);
        System.out.println(noColors); // Output: [RED]
    }
}
```

### **4. Using Clone Method**

```java
import java.util.EnumSet;

enum Status {
    NEW, IN_PROGRESS, COMPLETED, FAILED
}

public class CloneExample {
    public static void main(String[] args) {
        EnumSet<Status> statuses = EnumSet.of(Status.NEW, Status.IN_PROGRESS);
        EnumSet<Status> clonedStatuses = statuses.clone();

        System.out.println(clonedStatuses); // Output: [NEW, IN_PROGRESS]
    }
}
```

