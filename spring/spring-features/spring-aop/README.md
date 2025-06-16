---
description: >-
  Overview of Aspect Oriented Programming (AOP) framework along with practical
  example.
---

# Spring AOP

One of the core components of Spring Framework is the Aspect Oriented Programming (AOP) framework.

{% hint style="info" %}
AOP is a way for adding behavior to existing code without modifying that code.
{% endhint %}

Many enterprise level applications have some common cross-cutting concerns that are applicable to different types of objects and modules. Some of the most common cross-cutting concerns are logging, transaction management, data validation, security, authentication etc. In _**Object Oriented Programming (OOP), modularity of application is achieved by Classes**_ whereas in _**Aspect Oriented Programming application modularity is achieved by Aspects**_ and they are configured to cut across different classes. Spring AOP takes out the direct dependency of crosscutting tasks from classes that we can’t achieve through normal object oriented programming model. For example, we can have a separate class for logging but again the functional classes will have to call these methods to achieve logging across the application.

{% hint style="info" %}
A cross-cutting concern is a concern that can affect the whole application and should be centralized in one location in code as possible. It is conceptually separate from the main application business logic.
{% endhint %}

Spring AOP provides a way to modularize cross-cutting concerns in application by defining aspects. Aspects are like classes, but they define cross-cutting behavior. Spring AOP can intercept method calls, perform actions before or after the method invocation, or even replace the method invocation with different behavior.

{% hint style="info" %}
Dependency Injection helps in decoupling application objects from each other, while AOP helps in decoupling cross-cutting concerns from the objects that they affect.
{% endhint %}

Let's understand why AOP will be needed in the application by considering below example.

Suppose there are 5+ methods in a class as given below:

```
class Sample {  
    public void test1() {...}  
    public void test2() {...}  
    public void test3() {...}  
    public void test4() {...}  
    public void method1() {...}  
    public void method2() {...}  
    public void method3() {...}  
    public void method4() {...}  
} 
```

There are 4 method names that starts from `test` and 4 methods that starts from `method.` Suppose there is a need to maintain log and send notification after calling methods that starts from `test`.

**Solution without AOP** includes calling methods (that maintains log and sends notification) from the methods starting with `test`. In such case, code needs to written in all methods with `test`. But, if there is a requirement in future to remove send notification logic, change to all the methods will be needed. It leads to the maintenance problem.

**Solution with AOP** does not include calling methods from the method. Additional concerns can be defined like maintaining log, sending notification etc. in the form of custom annotation on the method of a class. In future, if there is a need to remove the notifier functionality, only change in the annotation will be needed. So, maintenance is easy in AOP. AOP provides a pluggable way to dynamically add the additional concern before, after or around the actual logic.

**AOP Terminologies**

* **Join point**

Join point is any point during the execution of a program such as method execution, exception handling, field access etc. _**Spring AOP supports only method execution join point**_.

* **Advice**

Advice represents an action taken by an aspect at a particular join point. In Spring, an Advice is modelled as an interceptor, maintaining a chain of interceptors around the Joinpoint. Different types of advices include:

> * Before Advice: It executes before a join point. Use **@Before** annotation to mark an advice type as Before advice.
> * After Returning Advice: It executes after a joint point completes normally. Use **@AfterReturning** annotation to mark a method as after returning advice.
> * After Throwing Advice: It executes if method exits by throwing an exception. Use **@AfterThrowing** annotation for this type of advice.
> * After (finally) Advice: It executes after a join point regardless of join point exit whether normally or exceptional return. Use **@After** annotation to mark an advice type as After advice.
> * Around Advice: It executes before and after a join point. Use **@Around** annotation to create around advice methods.

* **Pointcut**

It is an expression language of AOP that matches join points to determine whether advice needs to be executed or not. It is a predicate that helps match an Advice to be applied by an Aspect at a particular JoinPoint.

Some of the supported pointcut designators are given below.

> **execution**: Matches method execution join points.
>
> ```java
> @Before("execution(* com.example.service.*.*(..))")
> ```
>
> **within**: Matches join points within certain types (classes or interfaces).
>
> ```java
> @Before("within(com.example.service.*)")
> ```
>
> **this**: Matches join points where the target object is an instance of a certain type.
>
> ```java
> @Before("this(com.example.service.MyService)")
> ```
>
> **target**: Matches join points where the target object being advised is an instance of a certain type.
>
> ```java
> @Before("target(com.example.service.MyService)")
> ```
>
> **args**: Matches join points where the arguments passed to the method match the specified types.
>
> ```java
> @Before("args(String, int)")
> ```
>
> **@annotation**: Matches join points where the subject has the specified annotation.
>
> ```java
> @Before("@annotation(org.springframework.transaction.annotation.Transactional)")
> @Before("@annotation(LogRequest)")
> ```

{% hint style="info" %}
Wildcard

**`.*`**: This wildcard matches any sequence of characters in a package name or class name. It's often used to specify a package or class name with a specific prefix followed by any number of characters.

Example:

`com.example.service.*` matches all classes in the `com.example.service` package.

`com.example.*.*Service` matches all classes in packages like `com.example.service` and `com.example.util` whose names end with "Service".

**`..`**: This wildcard matches any number of subpackages or classes. It's often used to specify a package or class name along with all of its subpackages or subclasses. (..) matches any number of parameters (zero or more)

Example:

`com.example..*` matches all classes in the `com.example` package and all of its subpackages.

`com.example.service..*` matches all classes in the `com.example.service` package and all of its subpackages.

**`*`**: This wildcard matches any single item in a package name, class name, or method signature. It's often used to specify a single package, class, or method name.

Example:

`com.example.service.*Service` matches classes whose names end with "Service" in the `com.example.service` package.

`*Controller` matches classes whose names end with "Controller" in any package.

Combining these wildcards allows to create flexible pointcut expressions that match specific parts of method signatures or package/class names. For example,

`execution(* com.example.service.*.*(..))` matches all method executions in classes in the `com.example.service` package, regardless of the method name or parameters.

`execution(* com.example..*.*(..))` matches all method executions in the `com.example` package and all of its sub-packages.
{% endhint %}

{% hint style="info" %}
Pointcut expressions can be combined using '&&', '||' and '!'. It is also possible to refer to pointcut expressions by name.

```java
@Pointcut("execution(public * *(..))")
private void anyPublicOperation() {}

@AfterThrowing(value = anyPublicOperation, throwing = "exception")
```
{% endhint %}

* **Target Object**

It is the object which is being advised by one or more aspects. It is also known as proxied object in spring because Spring AOP is implemented using runtime proxies.

* **Aspect**

An aspect is a class that implements enterprise application concerns that cut across multiple classes, such as transaction management, logging and contains advices, joinpoints etc.

* **Interceptor**

It is an aspect that contains only one advice.

* **AOP Proxy**

It is used to implement aspect contracts, created by AOP framework. It will be a JDK dynamic proxy or CGLIB proxy in spring framework.

* **Weaving**

It is the process of linking aspect with other application types or objects to create an advised object. Weaving can be done at compile time, load time or runtime. Spring AOP performs weaving at runtime.

**Sample Diagram of AOP process**

<div><figure><img src="../../../.gitbook/assets/image (228).png" alt="" width="422"><figcaption></figcaption></figure> <figure><img src="../../../.gitbook/assets/image (215).png" alt="" width="445"><figcaption></figcaption></figure></div>

> * **Application**: Application containing the business logic.
> * **Target Object**: Object containing the business logic methods.
> * **Aspect Object**: Object containing the cross-cutting concerns (e.g., logging, security).
> * **Proxy Object**: Spring AOP dynamically generates proxy objects around the target objects. The proxy intercepts method invocations.
> * **Advice**: Action taken by an aspect at a particular join point. It represents the cross-cutting behavior.
> * **Join Point**: A point during the execution of a program, such as method execution, exception handling, etc.
> * **Aspect Weaving**: The process of applying aspects to the target object to create the advised object. This happens dynamically at runtime.

Let's see the advantages and disadvantages of AOP

<table><thead><tr><th>Advantage</th><th>Disadvantage</th><th data-hidden></th></tr></thead><tbody><tr><td><strong>Modularity</strong>: AOP allows you to modularize cross-cutting concerns, such as logging, security, and transaction management, improving code organization and maintainability.</td><td><strong>Performance Overhead</strong>: Dynamic proxy-based AOP can introduce performance overhead, especially for heavily-intercepted methods, due to the extra method invocations and object creations involved.</td><td></td></tr><tr><td><strong>Reusability</strong>: Aspects can be reused across multiple components, reducing code duplication and promoting a more DRY (Don't Repeat Yourself) approach.</td><td><strong>Limited to Method Interception</strong>: Spring AOP primarily focuses on method interception, which may not cover all cross-cutting concerns, such as field access or object creation.</td><td></td></tr><tr><td><strong>Separation of Concerns</strong>: AOP separates core business logic from cross-cutting concerns, making it easier to understand and maintain the codebase.</td><td><strong>Complexity</strong>: AOP introduces additional complexity to the codebase, especially for developers unfamiliar with the concept, which may lead to difficulties in debugging and troubleshooting.</td><td></td></tr><tr><td><strong>Dynamic Proxy</strong>: Spring AOP uses dynamic proxies, which means that aspects can be applied at runtime without modifying the original code, providing flexibility and reducing coupling.</td><td><strong>Potential Abuse</strong>: AOP can be misused, leading to overly complex and hard-to-maintain code if cross-cutting concerns are scattered across the application without proper organization.</td><td></td></tr><tr><td><strong>Declarative Programmin</strong>g: AOP allows you to declare aspects using annotations or XML configuration, promoting a declarative programming style that is often easier to understand and maintain.</td><td><strong>Aspect Dependencies</strong>: Aspects may introduce dependencies between modules or layers of an application, making it harder to reason about the flow of control and increasing coupling if not managed carefully.</td><td></td></tr><tr><td></td><td>Since final classes or methods cannot be extended, they cannot be proxied. Because of the proxy implementation, Spring AOP only applies to <strong>public, non-static methods on Spring Beans</strong>. If there is an internal method call from one method to another within the same class, the advice will never be executed for the internal method call.</td><td></td></tr></tbody></table>

**AOP Implementations**

1. **AspectJ**: AspectJ is a powerful and widely-used AOP framework for Java. It provides a rich set of features for aspect-oriented programming, including support for both compile-time and runtime weaving. AspectJ offers a comprehensive set of pointcut expressions and advice types, making it suitable for complex AOP scenarios.
2. **Spring AOP**: Spring AOP is a lightweight AOP framework provided by the Spring Framework. It integrates seamlessly with Spring IoC container and other Spring features. Spring AOP uses dynamic proxies to apply aspects at runtime, primarily focusing on method interception. While it may not be as feature-rich as AspectJ, it provides a more lightweight and easy-to-use AOP solution for common use cases.
3. **JBoss AOP**: JBoss AOP is an AOP framework provided by JBoss, now part of the larger Red Hat ecosystem. It was developed specifically for the JBoss application server but can be used in standalone Java applications as well. JBoss AOP offers features similar to AspectJ and Spring AOP but is tailored for use within the JBoss environment.

**Ways to Use Spring AOP**

1. **Spring 1.2 Old Style (DTD Based)**: In older versions of Spring (prior to version 2.5), AOP configuration was typically done using XML-based configuration with DTD-based syntax. This approach involved defining aspects, pointcuts, and advice in XML files.
2. **AspectJ Annotation-Style**: This is the preferred and widely-used approach for using Spring AOP. With this approach, you can use AspectJ annotations (`@Aspect`, `@Pointcut`, `@Before`, `@After`, etc.) to define aspects and advice directly in your Java classes. This style offers a more concise and readable way to configure AOP.
3. **Spring XML Configuration-Style (Schema Based)**: Spring AOP can also be configured using XML-based configuration with schema-based syntax. This approach is similar to the old style but uses XML schemas (`<aop:config>`, `<aop:aspect>`, `<aop:before>`, `<aop:after>`, etc.) for defining aspects and advice.

While all three approaches are supported by Spring AOP, the AspectJ annotation-style approach is the most commonly used and recommended due to its simplicity, more control, and alignment with modern Java development practices.

**Spring Maven Dependency**

```
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-aop</artifactId>
</dependency>
```
