---
description: Overview about custom annotation.
---

# Custom Annotation

Custom annotations allows us to add metadata to the code. This metadata can then be used by Spring Boot or other frameworks at different stages (compile time, runtime, or both) to enhance functionality and improve code clarity.



**How to create and use custom annotations?**

* **Declaration**: Custom annotations are defined like any other Java interface, with the `@interface` keyword. Annotations can include elements that act as parameters.
* **Annotation Methods**: Custom annotation methods, which is optional, cannot have parameters and cannot throw exceptions. They can only have return types like primitives, String, Class, enums, annotations, or arrays of these types.
* **Target Elements**: Specify where the annotation will be used by annotating the annotation declaration with `@Target`. For example, `ElementType.METHOD` specifies that the annotation can be applied to methods.
* **Retention Policy**: Specify the retention policy for the annotation using `@Retention`. This determines how long the annotation's metadata is kept. `RetentionPolicy.RUNTIME` means the annotation will be available at runtime via reflection.
* **Use the Annotation**: Once defined, custom annotation can be used throughout the Spring Boot application.
* **Processing Custom Annotations:** Reflection or Spring AOP (Aspect-Oriented Programming) can be used to process custom annotations at runtime. Reflection allows to access the annotation information using libraries like `java.lang.reflect`. Spring AOP enables to create aspects that intercept method calls based on the presence of annotations like `@LogExecutionTime`, `@SMSNotification`.



**Use case**

Custom annotations are commonly used in Spring Boot for various purposes like request mapping, security, transaction management, logging, notification and more. They help in making the code more expressive, readable, and maintainable by providing metadata that can be leveraged by frameworks and developers.



**Scenario 1**: Using custom annotation in AOP

Reference[^1]



**Scenario 2**: Using Reflection

Create a custom annotation which can be applied to the methods and available at runtime.

_**Loggable.java**_

```java
package org.example;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface Loggable {
}
```

Create a sample service and apply the custom annotation.

_**SampleService.java**_

```java
package org.example.service;

import lombok.extern.slf4j.Slf4j;
import org.example.Loggable;

@Slf4j
public class SampleService {

    @Loggable
    public void method1() {
        log.info("Inside method1");
    }

    public void method2() {
        log.info("Inside method2");
    }
}
```

Create a class to process the annotation.

_**Logger.java**_

```java
package org.example.reflection;

import lombok.AccessLevel;
import lombok.NoArgsConstructor;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.example.Loggable;

import java.lang.reflect.Method;

@NoArgsConstructor(access = AccessLevel.PRIVATE)
@Slf4j
public class Logger {

    @SneakyThrows
    public static void logMethodEntryExit(Object target) {
        Class<?> clazz = target.getClass();

        Method[] methods = clazz.getDeclaredMethods();
        for (Method method : methods) {
            if (method.isAnnotationPresent(Loggable.class)) {
                log.info("Entering method: {}", method.getName());
                method.invoke(target);
                log.info("Exiting method: {}", method.getName());
            }
        }
    }
}
```

Create a Main application.

_**Application.java**_

```java
package org.example;

import org.example.reflection.Logger;
import org.example.service.SampleService;

public class Application {
    public static void main(String[] args) {
        var sampleService = new SampleService();
        Logger.logMethodEntryExit(sampleService);
    }
}
```

Execute the main program and verify the logs.

<figure><img src="../../.gitbook/assets/image.png" alt=""><figcaption><p>Output</p></figcaption></figure>

[^1]: [https://app.gitbook.com/o/tVyFnk5YBNmGbKUlXJjt/s/Pd6ktrA5pPLsZJktj2fm/\~/changes/30/spring/concepts/spring-aop/before-advice#scenario-1-logging-request-details-using-custom-annotation](../concepts/spring-aop/before-advice.md#scenario-1-logging-request-details-using-custom-annotation)
