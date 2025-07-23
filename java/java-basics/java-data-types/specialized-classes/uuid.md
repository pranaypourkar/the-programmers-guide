# UUID

## About

The **`UUID`** (Universally Unique Identifier) class in Java provides a way to generate unique identifiers. It is part of the `java.util` package and is commonly used in applications where globally unique IDs are required, such as in distributed systems, database keys, or unique identifiers for entities.

* A **UUID** is a 128-bit value that is highly likely to be unique across all systems and contexts.
* It adheres to the RFC 4122 standard, ensuring consistency and compatibility with other systems that use UUIDs.
* UUIDs are represented as a 36-character string in hexadecimal format, separated into five groups: `8-4-4-4-12` (e.g., `550e8400-e29b-41d4-a716-446655440000`).
* Common use cases include identifying resources in a distributed environment, assigning unique database keys, and tagging data entities.

## **Features**

1. **Global Uniqueness:**
   * Each UUID is designed to be unique, even if generated on different machines or at different times.
2. **Different Types of UUIDs:**
   * **Version 1:** Based on timestamp and MAC address.
   * **Version 3:** Based on a namespace and a name, using MD5 hashing.
   * **Version 4:** Randomly generated UUIDs.
   * **Version 5:** Based on a namespace and a name, using SHA-1 hashing.
3. **Compact Representation:**
   * Despite their uniqueness, UUIDs are compactly represented as a string or a byte array.
4. **Thread-Safe:**
   * UUID generation methods are thread-safe and can be safely used in multi-threaded environments.
5. **Wide Compatibility:**
   * UUIDs are widely used across programming languages, databases, and distributed systems.

## **Declaration**

The `UUID` class is part of the `java.util` package. To use it, you simply import the class:

```java
import java.util.UUID;
```

## **Methods Available**

### **UUID Generation:**

* `UUID.randomUUID()`: Generates a random UUID (Version 4).
* `UUID.nameUUIDFromBytes(byte[] name)`: Generates a UUID based on the specified byte array (Version 3 or 5).

### **Get UUID Components:**

* `long getMostSignificantBits()`: Returns the most significant 64 bits of the UUID.
* `long getLeastSignificantBits()`: Returns the least significant 64 bits of the UUID.

### **UUID Parsing:**

* `UUID.fromString(String uuid)`: Creates a UUID from its string representation.

### **Utility Methods:**

* `int version()`: Returns the version number of the UUID.
* `int variant()`: Returns the variant number of the UUID.
* `String toString()`: Converts the UUID to its standard string representation.
* `boolean equals(Object obj)`: Checks if two UUIDs are equal.
* `int hashCode()`: Returns the hash code of the UUID.

## **Usage**

### **Basic UUID Generation**

```java
import java.util.UUID;

public class UUIDExample {
    public static void main(String[] args) {
        UUID uuid = UUID.randomUUID(); // Generate a random UUID
        System.out.println("Random UUID: " + uuid);
    }
}
```

### **Parsing a UUID String**

```java
String uuidString = "550e8400-e29b-41d4-a716-446655440000";
UUID uuid = UUID.fromString(uuidString);
System.out.println("Parsed UUID: " + uuid);
```

### **Generating UUID from Namespace and Name**

```java
import java.util.UUID;

public class UUIDFromNamespaceExample {
    public static void main(String[] args) {
        byte[] nameBytes = "example-name".getBytes();
        UUID uuid = UUID.nameUUIDFromBytes(nameBytes);
        System.out.println("Name-based UUID: " + uuid);
    }
}
```

### **Getting UUID Components**

```java
UUID uuid = UUID.randomUUID();
System.out.println("UUID: " + uuid);
System.out.println("Most Significant Bits: " + uuid.getMostSignificantBits());
System.out.println("Least Significant Bits: " + uuid.getLeastSignificantBits());
System.out.println("Version: " + uuid.version());
System.out.println("Variant: " + uuid.variant());
```

### **Using UUID as a Database Key**

```java
public class Entity {
    private String id;

    public Entity() {
        this.id = UUID.randomUUID().toString();
    }

    public String getId() {
        return id;
    }
}
```

## **Applications and Real-World Usage**

1. **Database Keys:** UUIDs are often used as primary keys in distributed databases to avoid key collisions.
2. **Distributed Systems:** Used to identify resources, nodes, or messages uniquely in a network of distributed systems.
3. **File or Data Tagging:** UUIDs are assigned to files or records for tracking and identification purposes.
4. **Session and Token Generation:** UUIDs can be used to generate unique session IDs or authentication tokens.
5. **Debugging and Logging:** UUIDs provide a way to uniquely identify and track events or requests in logs.
