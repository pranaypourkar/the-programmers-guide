# Spring Beans

## About

**Spring Beans** are the central components of a Spring application. In the Spring Framework, a _bean_ is simply an object that is managed by the Spring _Inversion of Control (IoC)_ container. When you use Spring, instead of manually instantiating objects with `new`, Spring creates and manages those objects for you. These objects are called **beans**.

Think of a Spring bean as a **building block** of your application: it could be a service, a data access object, a utility class, or even a controller - anything that Spring manages and wires into other parts of your code.

## Why Spring Beans Matter ?

Spring’s entire architecture revolves around beans:

* They **promote loose coupling** through dependency injection.
* They **centralize object management**, improving testability and reusability.
* They allow **configuration flexibility** using Java config, XML, or annotations.
* Beans form the **backbone of Spring modules** like Spring MVC, Spring Data, Spring Security, and more.

Without understanding beans, you miss the core benefit Spring provides: **object management with minimal boilerplate**.

## How Spring Creates and Manages Beans ?

When Spring starts up, it:

1. Scans for classes annotated with bean-related annotations (like `@Component`, `@Service`, etc.).
2. Instantiates those classes and registers them in the **ApplicationContext**.
3. Resolves dependencies between beans and injects them where needed.
4. Manages their **lifecycle**, including initialization and destruction (optional hooks like `@PostConstruct`, `@PreDestroy`).

## Use Cases of Spring Beans ?

* Defining **services** that contain business logic
* Managing **repositories** for database access
* Creating **configuration beans** for third-party integrations
* Injecting **utility components** across multiple classes
* Ensuring **reusability** and **testability** by letting Spring manage objects
