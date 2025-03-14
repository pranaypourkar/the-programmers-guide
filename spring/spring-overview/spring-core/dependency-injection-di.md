# Dependency Injection (DI)

## **About**

Dependency Injection is a specific implementation of IoC where the dependencies of an object are "injected" into it by an external entity, typically the Spring container. Instead of an object creating its dependencies directly, it receives them from an external source. This reduces the coupling between classes and makes them easier to test and maintain. This whole process is also called wiring in Spring and by using annotations it can be done automatically by Spring, referred to as auto-wiring of beans in Spring.

<figure><img src="../../../.gitbook/assets/image (304).png" alt="" width="468"><figcaption></figcaption></figure>

**Points of Dependency Injection**

1. **Dependency**: A dependency is an object that another object depends on to perform its work. Dependencies can be services, data access objects, configuration settings, or any other object that a class needs to function properly.
2. **Dependent Object (or Client)**: The dependent object is the object that requires a dependency to perform its work. It relies on the dependency to provide certain functionality or services.
3. **Dependency Provider (or Injector)**: The dependency provider is responsible for providing the required dependencies to the dependent object. In the context of Spring, the dependency provider is typically the Spring IoC container.

## **Types of Dependency Injection in Spring**

### **1. Constructor Injection**

Dependencies are provided to the dependent object through its constructor. This is the most common form of dependency injection in Spring.

```java
public class UserService {
    private final UserRepository userRepository;

    // Constructor injection
    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    // Business logic method
    public void registerUser(User user) {
        userRepository.save(user);
    }
}
```

In this example, `UserService` class has a dependency on `UserRepository`. The `UserRepository` dependency is injected into the `UserService` class through its constructor. Constructor Injection promotes immutability and ensures that all required dependencies are provided at the time of object creation.

{% hint style="success" %}
Always prefer Constructor Injection for better testability, maintainability, and reliability.
{% endhint %}

### **2. Setter Injection**

Dependencies are provided to the dependent object through setter methods. This allows for more flexibility as dependencies can be changed at runtime.

```java
public class UserService {
    private UserRepository userRepository;

    // Setter method for UserRepository
    public void setUserRepository(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    // Business logic method
    public void registerUser(User user) {
        userRepository.save(user);
    }
}
```

In this example, `UserService` class has a setter method `setUserRepository()` to set the `UserRepository` dependency. The dependency is injected into the class by calling this setter method. Setter Injection provides flexibility as dependencies can be changed at runtime.

### **3. Field Injection**

Dependencies are injected directly into the fields of the dependent object. While convenient, field injection is generally discouraged in favor of constructor or setter injection due to concerns about testability and encapsulation.

```java
public class UserService {
    @Autowired
    private UserRepository userRepository;

    // Business logic method
    public void registerUser(User user) {
        userRepository.save(user);
    }
}
```

In this example, `UserService` class uses Field Injection to inject the `UserRepository` dependency directly into the `userRepository` field. The `@Autowired` annotation instructs the Spring IoC container to inject the dependency into the field. While convenient, Field Injection is generally discouraged due to following reasons.

{% hint style="danger" %}
Field Injection (`@Autowired` on private fields) is widely discouraged in Spring applications due to multiple design and maintainability issues.
{% endhint %}

## Why Field Injection is discouraged in Spring applications ?

Field Injection (`@Autowired` on private fields) is widely discouraged in Spring applications due to multiple design and maintainability issues.

### **1. Decreased Testability**

**How does Field Injection make testing harder?**

* With **Field Injection**, dependencies are injected directly into private fields, making it impossible to manually set mocks in unit tests.
* Since there are no constructors or setter methods available, the only way to inject mocks is through **reflection**, which adds unnecessary complexity.

**Example: Why is this a problem?**

```java
public class UserService {
    @Autowired
    private UserRepository userRepository;

    public void registerUser(User user) {
        userRepository.save(user);
    }
}
```

In a unit test, if we try to mock `UserRepository` using Mockito:

```java
@ExtendWith(MockitoExtension.class)
class UserServiceTest {
    
    @Mock
    private UserRepository userRepository;
    
    @InjectMocks
    private UserService userService;  // Won't work correctly due to Field Injection

    @Test
    void testRegisterUser() {
        User user = new User("John");
        userService.registerUser(user); // NullPointerException may occur

        verify(userRepository).save(user);
    }
}
```

**Why does it fail?**

* `@InjectMocks` **only works for Constructor or Setter Injection**.
* Since `userRepository` is `private` and lacks a setter or constructor, it remains **uninitialized**, leading to **NullPointerException**.

**How to fix it?**&#x20;

Use **Constructor Injection** instead

```java
public class UserService {
    private final UserRepository userRepository;

    @Autowired
    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public void registerUser(User user) {
        userRepository.save(user);
    }
}
```

Now, the test will work correctly:

```java
@ExtendWith(MockitoExtension.class)
class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private UserService userService;  // Works correctly now

    @Test
    void testRegisterUser() {
        User user = new User("John");
        userService.registerUser(user);

        verify(userRepository).save(user);
    }
}
```

### **2. Encapsulation Issues**

**How does Field Injection violate encapsulation?**

* In **Object-Oriented Programming (OOP)**, encapsulation means **hiding internal implementation details** and exposing only necessary functionality.
* Field Injection **exposes dependencies as class-level fields**, breaking encapsulation principles.
* Even though fields are marked as `private`, Spring **still modifies them via reflection**, bypassing standard OOP practices.

**Example:**

```java
public class UserService {
    @Autowired
    private UserRepository userRepository;
}
```

This class **depends on Spring to inject `userRepository`**, making it **tightly coupled** to the framework.

**How to fix it?**

With **Constructor Injection**, dependencies remain **immutable** and are enforced at object creation:

```java
public class UserService {
    private final UserRepository userRepository;

    @Autowired
    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }
}
```

Now, `userRepository` **cannot be modified** after object creation, improving encapsulation.

### **3. Implicit Dependencies**

**How does Field Injection hide dependencies?**

* Dependencies injected via `@Autowired` **are not visible in the class's public API**.
* It’s unclear **which dependencies the class needs**, making it harder to maintain and use.

**Example:**

```java
public class UserService {
    @Autowired
    private UserRepository userRepository;
}
```

A developer looking at this class cannot tell what dependencies are required without inspecting the field or checking the application context.

**How to fix it?**

Using Constructor Injection makes dependencies **explicit**:

```java
public class UserService {
    private final UserRepository userRepository;

    @Autowired
    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }
}
```

Now, anyone reading this class knows exactly what it depends on, improving code clarity.

## **4. Tighter Coupling**

**How does Field Injection increase coupling?**

* `@Autowired` makes dependencies **hardcoded into the class**, making them **difficult to replace** or **swap with alternative implementations**.
* This goes against the **Dependency Inversion Principle (DIP)**, where high-level modules should not depend on low-level implementations.

**Example:**

```java
public class UserService {
    @Autowired
    private UserRepository userRepository;
}
```

* `UserService` depends directly on `UserRepository`, making it hard to switch to another implementation (e.g., `MockUserRepository` for testing).
* If we later introduce a caching layer (`CachedUserRepository`), we must modify the class.

**How to fix it?**

Using **Constructor Injection with Interfaces** allows easy swapping:

```java
public class UserService {
    private final UserRepository userRepository;

    @Autowired
    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }
}
```

* Now, `UserRepository` can be replaced **without modifying `UserService`**.
* A different implementation (e.g., `CachedUserRepository`) can be injected instead.

### **5. Runtime Errors (NullPointerException)**

**How does Field Injection cause runtime errors?**

* If dependencies are not correctly initialized by Spring, accessing them results in **NullPointerException**.
* This problem occurs especially in **unit tests**, **manual object creation**, or **misconfigured Spring Beans**.

**Example of a failing case:**

```java
public class UserService {
    @Autowired
    private UserRepository userRepository;

    public void registerUser(User user) {
        userRepository.save(user);  // May throw NullPointerException if not injected
    }
}
```

If this class is instantiated **manually** (outside Spring context):

```java
UserService userService = new UserService();
userService.registerUser(new User("Alice"));  // Throws NullPointerException
```

The `userRepository` field is **never initialized**, causing **NullPointerException**.

**How to fix it?**

With Constructor Injection, the dependency **must be provided**:

```java
public class UserService {
    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }
}
```

Now, manual instantiation **requires a valid dependency**, avoiding runtime errors:

```java
UserRepository repo = new InMemoryUserRepository();
UserService userService = new UserService(repo);  // Works correctly
```

