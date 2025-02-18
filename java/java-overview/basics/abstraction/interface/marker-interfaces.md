# Marker Interfaces

## **About**

A **marker interface** is an interface that does not contain any methods or fields. Its purpose is purely to mark a class that it is associated with some specific behavior. It is used to indicate that a class has some special property or should be treated in a specific way by the JVM or other frameworks.

## **Why use Marker Interfaces?**

Marker interfaces **convey intent** at the design level. They are primarily used in situations where:

1. A class needs **special handling** at runtime (e.g., serialization, cloning).
2. A framework or API needs to **check the presence** of a characteristic before performing an operation.
3. We want to use **`instanceof`** to verify if a class implements a certain behavior.

## **Examples of Marker Interfaces**

Java provides several built-in marker interfaces:

### **1. `Serializable` (Used for Object Serialization)**

```java
import java.io.Serializable;

class Person implements Serializable { 
    String name;
}
```

* **Purpose:** Marks classes whose objects can be converted into a byte stream (serialization).
* **Usage:** The JVM checks if a class implements `Serializable` before allowing serialization.

### **2. `Cloneable` (Used for Cloning Objects)**

```java
class Person implements Cloneable {
    String name;

    @Override
    protected Object clone() throws CloneNotSupportedException {
        return super.clone();
    }
}
```

* **Purpose:** Marks classes that allow cloning via `Object.clone()`.
* **Usage:** If a class **does not** implement `Cloneable`, calling `clone()` on its object throws `CloneNotSupportedException`.

### **3. `Remote` (Used in Java RMI)**

```java
import java.rmi.Remote;

interface MyRemoteService extends Remote { }
```

* **Purpose:** Marks interfaces meant for **Remote Method Invocation (RMI)**.
* **Usage:** Ensures that only remote objects can be used in RMI calls.

## Can Marker Interfaces Be Replaced by Annotations?

While annotations could theoretically replace marker interfaces, marker interfaces still offer a few benefits. They can be used in `instanceof` checks at runtime, which annotations cannot. Marker interfaces also signify intent at the design level, signaling that a class supports specific behavior. However, in cases where additional metadata is required, annotations can provide more flexibility.

<table><thead><tr><th width="365">Feature</th><th width="223">Marker Interface</th><th>Annotation</th></tr></thead><tbody><tr><td>Checked at runtime with <code>instanceof</code></td><td>Yes</td><td>No</td></tr><tr><td>Enforced at compile-time (static checking)</td><td>Yes</td><td>No</td></tr><tr><td>Expresses intent clearly in class definition</td><td>Yes</td><td>Yes</td></tr><tr><td>Can store additional metadata</td><td>No</td><td>Yes</td></tr><tr><td>Requires reflection for checking</td><td>No</td><td>Yes</td></tr></tbody></table>

**Example: Using an Annotation Instead of a Marker Interface**

```java
@interface Serializable { }

@Serializable
class Person { }
```

However, this cannot be checked using `instanceof`, so we would need **reflection**:

```java
boolean isSerializable = Person.class.isAnnotationPresent(Serializable.class);
```

In contrast, with a **marker interface**, we can simply do:

```java
if (obj instanceof Serializable) { }
```

This is **more efficient** than reflection.

### **When to Use Marker Interfaces vs. Annotations?**

**Use Marker Interfaces** when:

* We need to check the behavior **at runtime** using `instanceof`.
* We want to **enforce type safety** at compile-time.
* we don't need additional metadata.

**Use Annotations** when:

* We need to **store extra metadata**.
* We need **flexibility** beyond just marking (e.g., @Deprecated, @Override).
* We don’t need to check using `instanceof`.

## **Custom Marker Interface Example**

**Example:** Creating a Custom Marker Interface Auditable

```java
interface Auditable { }

class User implements Auditable {
    String name;
}
```

**Checking for Marker Interface at Runtime**

```java
public class MarkerInterfaceTest {
    public static void main(String[] args) {
        User user = new User();

        if (user instanceof Auditable) {
            System.out.println("User is auditable!");
        } else {
            System.out.println("User is NOT auditable!");
        }
        
        // User is auditable!
    }
}
```
