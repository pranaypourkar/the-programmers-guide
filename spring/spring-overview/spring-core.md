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

1. **Dependency Injection (DI)**: Dependency Injection is a specific implementation of IoC where the dependencies of an object are "injected" into it by an external entity, typically the Spring container. Instead of an object creating its dependencies directly, it receives them from an external source. This reduces the coupling between classes and makes them easier to test and maintain. This whole process is also called wiring in Spring and by using annotations it can be done automatically by Spring, referred to as auto-wiring of beans in Spring.

<figure><img src="../../.gitbook/assets/image (82).png" alt="" width="468"><figcaption></figcaption></figure>

2. **Spring Container**: In Spring, the IoC container is responsible for managing the lifecycle of beans (objects) and their dependencies. The container creates, configures, and assembles beans based on the configuration metadata provided, such as XML configuration files, Java annotations, or Java-based configuration classes.
3. **Beans**: In Spring, a bean is an object that is managed by the Spring IoC container. Beans are typically Java objects that are configured and managed by the Spring container. They can be simple POJOs (Plain Old Java Objects) or more complex components such as services, data access objects, or controllers.
4. **Configuration Metadata**: Configuration metadata is used to define how beans should be created, wired together, and managed by the Spring container. This metadata can be specified using XML configuration files, Java annotations, or Java-based configuration classes.
5. **Lifecycle Management**: The Spring container manages the lifecycle of beans, including their creation, initialization, and destruction. It ensures that beans are created and configured correctly and that they are available for use when needed. This helps to ensure that resources are managed efficiently and that memory leaks and other issues are avoided.

