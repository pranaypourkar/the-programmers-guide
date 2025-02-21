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

* **Decreased Testability**: Field Injection makes it difficult to write unit tests, as dependencies are directly injected into fields without explicit setters, making it challenging to mock dependencies for testing.
* **Encapsulation Issues**: Field Injection exposes internal dependencies directly as public fields, violating the principle of encapsulation and making it harder to enforce class contracts.
* **Implicit Dependencies**: Field Injection hides dependencies from the class's interface, making it less clear and explicit which dependencies are required for the class to function properly.
* **Tighter Coupling**: Field Injection creates tighter coupling between classes, as dependencies are directly accessed through fields, making it harder to swap implementations or change dependencies without modifying the class itself.
* **Runtime Errors**: Field Injection can lead to NullPointerExceptions at runtime if dependencies are not properly initialized, as there is no guarantee that dependencies will be injected before they are accessed.
