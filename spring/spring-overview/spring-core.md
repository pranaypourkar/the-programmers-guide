# Spring Core

## What is IOC or inversion of control?

Inversion of Control (IoC) is a design principle and a key concept in the Spring Framework. It refers to the process of delegating the control of object creation and management to an external container or framework. In traditional programming, objects typically create and manage their dependencies themselves. However, in IoC, the control is inverted, and the responsibility for creating and managing objects is transferred to a container.

The main idea behind IoC is to decouple the components of a system and promote loose coupling and high cohesion. This leads to more modular, flexible, and maintainable code.

### Implementations of IoC

Inversion of Control (IoC) is a design principle, and there are multiple implementations of IoC in various frameworks and libraries. Some common implementations of IoC include:

1. **Dependency Injection (DI)**: Dependency Injection is a specific implementation of IoC where the control of object creation and management is inverted, and dependencies are injected into objects from an external source. DI frameworks, such as the Spring Framework in Java, manage the lifecycle of objects and handle the injection of dependencies.
2. **Service Locator Pattern**: In the Service Locator pattern, a central registry or service locator is responsible for locating and providing instances of services or components to other parts of the application. Clients request services from the service locator, which manages the instantiation and lifecycle of these services.
3. **Factory Pattern**: The Factory Pattern is a creational design pattern where a factory class is responsible for creating instances of objects based on certain conditions or parameters. Factories can be used to decouple the creation of objects from their usage, promoting loose coupling and flexibility.
4. **Event-Driven Architecture (EDA)**: In Event-Driven Architecture, components communicate with each other through events or messages. The control of execution is inverted, as components respond to events triggered by other components rather than being explicitly called by a central controller. Frameworks such as Apache Kafka and RabbitMQ provide implementations of EDA.
5. **Aspect-Oriented Programming (AOP)**: AOP is a programming paradigm that promotes the separation of cross-cutting concerns from the main business logic of an application. In AOP, aspects are modular units of cross-cutting functionality that can be applied to multiple objects or methods. AOP frameworks, such as AspectJ and Spring AOP, implement IoC by intercepting method calls and applying aspects dynamically.
6. **Template Method Pattern**: The Template Method Pattern is a behavioral design pattern where a base class defines the outline of an algorithm but allows subclasses to provide specific implementations of certain steps. The control of the algorithm's execution is inverted, as the base class dictates the overall structure while allowing subclasses to override specific steps.

### Key concepts of IoC in the context of Spring Framework include:

#### **Dependency Injection (DI)**

Dependency Injection is a specific implementation of IoC where the dependencies of an object are "injected" into it by an external entity, typically the Spring container. Instead of an object creating its dependencies directly, it receives them from an external source. This reduces the coupling between classes and makes them easier to test and maintain. This whole process is also called wiring in Spring and by using annotations it can be done automatically by Spring, referred to as auto-wiring of beans in Spring.

<figure><img src="../../.gitbook/assets/image (315).png" alt="" width="468"><figcaption></figcaption></figure>

**Key Points of Dependency Injection**

1. **Dependency**: A dependency is an object that another object depends on to perform its work. Dependencies can be services, data access objects, configuration settings, or any other object that a class needs to function properly.
2. **Dependent Object (or Client)**: The dependent object is the object that requires a dependency to perform its work. It relies on the dependency to provide certain functionality or services.
3. **Dependency Provider (or Injector)**: The dependency provider is responsible for providing the required dependencies to the dependent object. In the context of Spring, the dependency provider is typically the Spring IoC container.

**Types of Dependency Injection in Spring**

1. **Constructor Injection**: Dependencies are provided to the dependent object through its constructor. This is the most common form of dependency injection in Spring.

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

2. **Setter Injection**: Dependencies are provided to the dependent object through setter methods. This allows for more flexibility as dependencies can be changed at runtime.

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

3. **Field Injection**: Dependencies are injected directly into the fields of the dependent object. While convenient, field injection is generally discouraged in favor of constructor or setter injection due to concerns about testability and encapsulation.

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

#### **Spring Container**

In Spring, the IoC container is responsible for managing the lifecycle of beans (objects) and their dependencies. The container creates, configures, and assembles beans based on the configuration metadata provided, such as XML configuration files, Java annotations, or Java-based configuration classes.

#### **Beans**

In Spring, a bean is an object that is managed by the Spring IoC container. Beans are typically Java objects that are configured and managed by the Spring container. They can be simple POJOs (Plain Old Java Objects) or more complex components such as services, data access objects, or controllers.

#### **Configuration Metadata**

Configuration metadata is used to define how beans should be created, wired together, and managed by the Spring container. This metadata can be specified using XML configuration files, Java annotations, or Java-based configuration classes.

#### **Lifecycle Management**

The Spring container manages the lifecycle of beans, including their creation, initialization, and destruction. It ensures that beans are created and configured correctly and that they are available for use when needed. This helps to ensure that resources are managed efficiently and that memory leaks and other issues are avoided.
