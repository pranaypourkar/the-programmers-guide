# Encapsulation & Abstraction

## About

**Encapsulation** and **Abstraction** are two closely related but distinct **object‑oriented design principles** that work together to reduce complexity, improve maintainability, and enforce clean boundaries in a system’s design.

## Encapsulation

Encapsulation is about **bundling data (state) and methods (behavior) that operate on that data into a single unit**—typically a class—while restricting direct access to the internal details.\
It uses **access modifiers** (private, protected, public) to control visibility, ensuring that an object’s internal state can only be modified in controlled ways.

_Example_: A `BankAccount` class hides its balance field and only allows deposits and withdrawals through defined methods.

Key goals of Encapsulation:

* **Information hiding** – Keep internal representation private to avoid accidental misuse.
* **Controlled access** – Expose only the operations that make sense for the object.
* **Reduced coupling** – Changes to internal implementation do not require changes in external code.

### **Common Violations**

1. **Public Fields (Data Exposure)**
   * Exposing class variables directly instead of controlling access through getters/setters or methods.
   *   Example:

       ```java
       public class User {
           public String name; // Anyone can modify directly
       }
       ```
2. **Setters That Break Invariants**
   * Providing setters that allow the object’s state to be changed to invalid values.
3. **Excessive Getters/Setters**
   * Making every field accessible with public getters and setters defeats the purpose of encapsulation.
4. **Leaking Internal References**
   * Returning references to internal mutable objects, allowing external modification.
   * Example: Returning a modifiable `List` from a getter without defensive copying.
5. **Mixing Multiple Responsibilities**
   * A class that contains unrelated data and logic, making it hard to protect and reason about internal state.
6. **Bypassing Access Control**
   * Using reflection or package-private hacks to manipulate internal state inappropriately.

### **How to Apply Encapsulation ?**

#### **1. Identify the Boundaries of Responsibility**

* Define clear ownership of data and logic within each module, class, or service.
* Example: In a microservices architecture, each service encapsulates its own database and exposes data only through APIs.

#### **2. Use Access Modifiers Properly**

* Mark internal state as `private` or `protected`.
* Expose only the operations required by external code.

#### **3. Control State Through Public Methods**

* Use methods that enforce business rules when changing the state instead of giving direct access to variables.

#### **4. Avoid Exposing Internal Representations**

* Return copies of mutable collections or wrap them in read‑only views instead of exposing them directly.

#### **5. Encapsulate External System Interactions**

* Wrap external APIs, databases, or message queues in dedicated classes to hide integration details from the rest of the system.

#### **6. Protect Domain Logic from Infrastructure**

* Keep persistence logic (ORM, SQL) separate from business rules.
* Example: Use a repository layer to abstract away database operations.

#### **7. Maintain Stable Interfaces**

* Even if the internal implementation changes, the public interface should remain consistent to avoid breaking dependencies.

### **Example**

**Bad Example (Encapsulation Violation)**

```java
public class BankAccount {
    public double balance; // Public field - anyone can change it directly
}

public class Main {
    public static void main(String[] args) {
        BankAccount account = new BankAccount();
        account.balance = -1000; // Invalid state possible
    }
}
```

**Problems**

* Internal state (`balance`) is exposed.
* No control over valid or invalid operations.

**Good Example (Encapsulation Applied)**

```java
public class BankAccount {
    private double balance;

    public void deposit(double amount) {
        if (amount <= 0) {
            throw new IllegalArgumentException("Deposit must be positive");
        }
        balance += amount;
    }

    public boolean withdraw(double amount) {
        if (amount > balance) {
            return false; // insufficient funds
        }
        balance -= amount;
        return true;
    }

    public double getBalance() {
        return balance; // read-only access
    }
}

public class Main {
    public static void main(String[] args) {
        BankAccount account = new BankAccount();
        account.deposit(500);
        account.withdraw(200);
        System.out.println(account.getBalance()); // 300
    }
}
```

**Benefits**

* Internal state is protected from invalid modifications.
* All changes to state go through controlled methods.
* Business rules are enforced at the point of modification.

## Abstraction

Abstraction is about **hiding unnecessary details while exposing only the essential features** of an object or system. It focuses on _what_ an object does rather than _how_ it does it.

_Example_: A `List` interface allows us to add, remove, and retrieve elements without revealing the underlying implementation (ArrayList, LinkedList, etc.).

Key goals of Abstraction:

* **Simplification** – Reduce complexity by providing a clear interface.
* **Flexibility** – Allow different implementations without affecting the client code.
* **Focus on behavior, not implementation** – Encourages thinking in terms of responsibilities, not mechanics.

### **Common Violations**

1. **Leaking Implementation Details**
   * Interfaces or APIs reveal how something works internally instead of focusing on _what_ it does.
   * Example: An API returning a specific database record format instead of a domain model.
2. **Too Much Detail in Public Contracts**
   * Public methods require knowledge of internal workings to be used correctly.
3. **Over‑Abstraction**
   * Creating unnecessary layers of abstract classes or interfaces when there is no foreseeable variation.
4. **Inconsistent Abstractions**
   * Mixing high-level and low-level operations in the same interface.
5. **Tight Coupling to a Specific Implementation**
   * Claiming to be abstract but forcing consumers to know about a concrete class.
6. **Exposing Internal Models Directly**
   * Returning raw entity objects from persistence layers instead of mapping to DTOs or view models.

### **How to Apply Abstraction ?**

#### **1. Define Clear Interfaces**

* Create interfaces or abstract classes that describe _what_ a component does, not _how_ it does it.
* Example: A `PaymentProcessor` interface with `processPayment()` method, implemented differently for PayPal, Stripe, etc.

#### **2. Hide Implementation Details**

* Keep the internal workings of a module private and expose only the necessary methods.
* Example: A search API that hides whether it uses SQL, Elasticsearch, or an in‑memory search.

#### **3. Use Dependency Inversion**

* Depend on abstractions (interfaces) rather than concrete implementations.
* This makes swapping implementations easier without changing dependent code.

#### **4. Apply Layered Design**

* Separate the **what** (API, service contracts) from the **how** (internal algorithms, data structures).

#### **5. Keep Public APIs Minimal**

* Expose only the essential operations—avoid adding “just in case” methods that reveal too much about the internals.

#### **6. Support Multiple Implementations**

* Ensure that the abstraction can be implemented in different ways without breaking existing code.

#### **7. Combine with Encapsulation**

* Abstraction defines the contract; encapsulation protects the implementation details behind it.

### **Example**

**Bad Example (Abstraction Violation)**

```java
public class FileStorage {
    public void saveFile(String path, byte[] content) throws IOException {
        FileOutputStream fos = new FileOutputStream("/var/data/" + path);
        fos.write(content);
        fos.close();
    }
}

public class Main {
    public static void main(String[] args) throws IOException {
        FileStorage storage = new FileStorage();
        storage.saveFile("report.txt", "Hello".getBytes());
    }
}
```

**Problems:**

* Calling code is tied to a specific file system storage implementation.
* If storage moves to the cloud (e.g., AWS S3), all client code must be rewritten.

**Good Example (Abstraction Applied)**

```java
public interface StorageService {
    void save(String filename, byte[] content) throws IOException;
}

public class LocalFileStorage implements StorageService {
    public void save(String filename, byte[] content) throws IOException {
        FileOutputStream fos = new FileOutputStream("/var/data/" + filename);
        fos.write(content);
        fos.close();
    }
}

public class S3Storage implements StorageService {
    public void save(String filename, byte[] content) {
        // AWS S3 upload logic
    }
}

public class Main {
    public static void main(String[] args) throws IOException {
        StorageService storage = new LocalFileStorage(); // Could be swapped to S3Storage
        storage.save("report.txt", "Hello".getBytes());
    }
}
```

**Benefits**

* Code depends on the `StorageService` abstraction, not a specific implementation.
* Swapping from local storage to cloud storage requires **no changes** in calling code.
* Implementation details are hidden from clients.
