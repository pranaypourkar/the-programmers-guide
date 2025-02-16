# Access Modifiers

## About

Access modifiers in Java **control the visibility** of classes, methods, variables, and constructors. They determine **who can access** a particular member of a class.

## **Types of Access Modifiers**

<table data-full-width="true"><thead><tr><th width="242">Modifier</th><th>Accessible Within Class</th><th>Accessible Within Package</th><th>Accessible in Subclasses</th><th>Accessible Outside Package</th></tr></thead><tbody><tr><td><code>private</code></td><td>✅ Yes</td><td>❌ No</td><td>❌ No</td><td>❌ No</td></tr><tr><td><code>default</code> (no modifier)</td><td>✅ Yes</td><td>✅ Yes</td><td>❌ No</td><td>❌ No</td></tr><tr><td><code>protected</code></td><td>✅ Yes</td><td>✅ Yes</td><td>✅ Yes</td><td>❌ No</td></tr><tr><td><code>public</code></td><td>✅ Yes</td><td>✅ Yes</td><td>✅ Yes</td><td>✅ Yes</td></tr></tbody></table>

### **1. Private Access Modifier (`private`)**

**Scope:** Accessible **only within the same class**.\
**Use case:** Used for **data hiding** and **encapsulation**.

#### **Example:**

```java
class Example {
    private int secretCode = 1234;  // Private variable

    private void displaySecret() {  // Private method
        System.out.println("Secret Code: " + secretCode);
    }

    public void show() {  // Public method to access private members
        displaySecret();
    }
}

public class Main {
    public static void main(String[] args) {
        Example obj = new Example();
        // obj.secretCode = 5678;  // Error: Cannot access private variable
        // obj.displaySecret();    // Error: Cannot access private method
        obj.show();  // Allowed: Indirect access through public method
        // Secret Code: 1234
    }
}
```

### **2. Default (No Modifier) Access (Package-Private)**

**Scope:** Accessible **within the same package only**.\
**Use case:** Used when members should be **shared within a package** but not outside.

#### **Example:**

```java
class PackageExample {
    int packageVariable = 42;  // Default access modifier

    void display() {  // Default method
        System.out.println("Package Variable: " + packageVariable);
    }
}

public class Main {
    public static void main(String[] args) {
        PackageExample obj = new PackageExample();
        obj.display();  // Allowed: Same package
    }
}
```

### **3. Protected Access Modifier (`protected`)**

**Scope:** Accessible **within the same package** and **in subclasses** (even in different packages).\
**Use case:** Used for **inheritance** to allow controlled access to subclasses.

#### **Example:**

```java
class Parent {
    protected String message = "Hello from Parent!";  // Protected variable
}

class Child extends Parent {
    void showMessage() {
        System.out.println(message);  // Allowed: Accessible in subclass
    }
}

public class Main {
    public static void main(String[] args) {
        Child child = new Child();
        child.showMessage();
        // Hello from Parent!
    }
}
```

### **4. Public Access Modifier (`public`)**

**Scope:** **Accessible everywhere** (within and outside the package).\
**Use case:** Used when members should be **fully accessible**.

#### **Example:**

```java
class PublicExample {
    public String message = "Public Access!";  // Public variable

    public void showMessage() {  // Public method
        System.out.println(message);
    }
}

public class Main {
    public static void main(String[] args) {
        PublicExample obj = new PublicExample();
        obj.showMessage();  // Allowed: Public access
        // Public Access!
    }
}
```

## **Access Modifier Usage with Classes**

| Modifier    | Class         | Method | Variable | Constructor |
| ----------- | ------------- | ------ | -------- | ----------- |
| `private`   | ❌ Not allowed | ✅ Yes  | ✅ Yes    | ✅ Yes       |
| `default`   | ✅ Yes         | ✅ Yes  | ✅ Yes    | ✅ Yes       |
| `protected` | ❌ Not allowed | ✅ Yes  | ✅ Yes    | ✅ Yes       |
| `public`    | ✅ Yes         | ✅ Yes  | ✅ Yes    | ✅ Yes       |

#### **Example:**

```java
// Allowed: Public class
public class Car {
    private String engine;  // Private variable
    protected int speed;    // Protected variable
    public String model;    // Public variable

    // Constructor
    public Car(String model, int speed) {
        this.model = model;
        this.speed = speed;
    }

    private void startEngine() {  // Private method
        System.out.println("Engine started!");
    }

    protected void accelerate() {  // Protected method
        System.out.println(model + " is accelerating.");
    }

    public void displayInfo() {  // Public method
        System.out.println("Car Model: " + model + ", Speed: " + speed);
    }
}
```

## **When to Use Which Access Modifier?**

<table><thead><tr><th width="499">Use Case</th><th>Best Access Modifier</th></tr></thead><tbody><tr><td>Hide internal implementation</td><td><code>private</code></td></tr><tr><td>Allow subclass access but hide from external classes</td><td><code>protected</code></td></tr><tr><td>Allow access within the same package</td><td><code>default</code> (no modifier)</td></tr><tr><td>Make it accessible to everyone</td><td><code>public</code></td></tr></tbody></table>
