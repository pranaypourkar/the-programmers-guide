---
description: Overview about custom annotation.
---

# Custom Annotation

Custom annotations allows us to add metadata to the code. This metadata can then be used by Spring Boot or other frameworks at different stages (compile time, runtime, or both) to enhance functionality and improve code clarity.



**How to create and use custom annotations?**

* **Declaration**: Custom annotations are defined like any other Java interface, with the `@interface` keyword. Annotations can include elements that act as parameters.
* **Annotation Methods**: Custom annotation methods, which is optional, cannot have parameters and cannot throw exceptions. They can only have return types like primitives, String, Class, enums, annotations, or arrays of these types.

```java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface MyCustomAnnotation {
    String value() default ""; // A method with a String return type
    int number() default 0;    // A method with an int return type
    boolean enabled() default true; // A method with a boolean return type
    Class<?> type() default Void.class; // A method with a Class return type
    Class<? extends SomeFactory> someFactory(); // A method with a Class return type
    MyEnum enumValue() default MyEnum.DEFAULT; // A method with an enum return type
    String[] arrayValue() default {}; // A method with an array return type
}

enum MyEnum {
    DEFAULT,
    OPTION1,
    OPTION2
}
```

{% hint style="info" %}
```java
// SomeFactory class use above can contain several implementation classes used in AOP.
// For eg. we can have custom @Notification annotation which takes the implementation class such as SMSNotification, MailNotification etc.
public abstract class SomeFactory {
    public abstract Event triggerEvent(JoinPoint joinPoint, Object result);
}
```
{% endhint %}

* **Target Elements**: Specify where the annotation will be used by annotating the annotation declaration with `@Target`. For example, `ElementType.METHOD` specifies that the annotation can be applied to methods.

{% hint style="info" %}
Element Types - Applicable Type&#x20;

TYPE -  class, interface or enumeration&#x20;

FIELD -  fields&#x20;

METHOD - methods&#x20;

CONSTRUCTOR - constructors&#x20;

LOCAL\_VARIABLE - local variables&#x20;

ANNOTATION\_TYPE - annotation type&#x20;

PARAMETER - parameter
{% endhint %}

* **Retention Policy**: Specify the retention policy for the annotation using `@Retention`. This determines how long the annotation's metadata is kept. `RetentionPolicy.RUNTIME` means the annotation will be available at runtime via reflection.

{% hint style="info" %}
RetentionPolicy.SOURCE - Refers to the source code, discarded during compilation. It will not be available in the compiled class.

RetentionPolicy.CLASS - Refers to the .class file, available to java compiler but not to JVM. It is included in the class file.&#x20;

RetentionPolicy.RUNTIME - Refers to the runtime, available to java compiler and JVM.
{% endhint %}

* **Use the Annotation**: Once defined, custom annotation can be used throughout the Spring Boot application.
* **Processing Custom Annotations:** Reflection or Spring AOP (Aspect-Oriented Programming) can be used to process custom annotations at runtime. Reflection allows to access the annotation information using libraries like `java.lang.reflect`. Spring AOP enables to create aspects that intercept method calls based on the presence of annotations like `@LogExecutionTime`, `@SMSNotification`.



**Use case**

Custom annotations are commonly used in Spring Boot for various purposes like request mapping, security, transaction management, logging, notification and more. They help in making the code more expressive, readable, and maintainable by providing metadata that can be leveraged by frameworks and developers.



**Scenario 1**: Using custom annotation in AOP

Reference[^1]



**Scenario 2**: Using Reflection&#x20;

<mark style="background-color:purple;">**Case 1**</mark>: With Method level custom annotation

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

<figure><img src="../../../.gitbook/assets/image (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt=""><figcaption><p>Output</p></figcaption></figure>



<mark style="background-color:purple;">**Case 2**</mark>: With Class and Field level custom annotation

Create custom annotation's which can be applied to the class and fields.

_**JsonSerializableField.java**_

```java
package org.example.serialization;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.FIELD)
public @interface JsonSerializableField {
    public String key() default "";
}
```

_**JsonSerializableClass.java**_

```java
package org.example.serialization;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
public @interface JsonSerializableClass {
}
```

Create sample Product class and apply the annotations.

_**Product.java**_

```java
package org.example.model;

import lombok.Builder;
import lombok.Data;
import org.example.serialization.JsonSerializableClass;
import org.example.serialization.JsonSerializableField;

@Builder
@JsonSerializableClass
@Data
public class Product {
    @JsonSerializableField(key = "product_id")
    private String id;

    @JsonSerializableField(key = "product_name")
    private String name;

    @JsonSerializableField(key = "product_description")
    private String description;

    private boolean availability;
}
```

Create reflection class

_**JsonSerializable.java**_

```java
package org.example.reflection;

import lombok.AccessLevel;
import lombok.NoArgsConstructor;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.example.serialization.JsonSerializableClass;
import org.example.serialization.JsonSerializableField;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

@NoArgsConstructor(access = AccessLevel.PRIVATE)
@Slf4j
public class JsonSerializable {

    public static boolean checkSerializable(Object object) {
        if (Objects.isNull(object)) {
            log.error("The object to serialize {} is null", object);
            return Boolean.FALSE;
        }

        Class<?> clazz = object.getClass();
        if (!clazz.isAnnotationPresent(JsonSerializableClass.class)) {
            log.error("The class is not annotated with JsonSerializableClass custom annotation");
            return Boolean.FALSE;
        }

        return Boolean.TRUE;
    }

    @SneakyThrows
    public static String convertToJsonString(Object object) {
        Class<?> clazz = object.getClass();
        Map<String, String> jsonFieldsMap = new HashMap<>();
        for (Field field : clazz.getDeclaredFields()) {
            field.setAccessible(Boolean.TRUE);
            if (field.isAnnotationPresent(JsonSerializableField.class)) {
                jsonFieldsMap.put(getKey(field), (String) field.get(object));
            }
        }

        String jsonString = jsonFieldsMap.entrySet()
                .stream()
                .map(entry -> "\"" + entry.getKey() + "\":\"" + entry.getValue() + "\"")
                .collect(Collectors.joining(","));
        return "{" + jsonString + "}";
    }

    private static String getKey(Field field) {
        var value = field.getAnnotation(JsonSerializableField.class).key();
        return value.isEmpty() ? field.getName() : value;
    }
}
```

Create main application class and execute the program

```java
package org.example;

import lombok.extern.slf4j.Slf4j;
import org.example.model.Product;
import org.example.reflection.JsonSerializable;

@Slf4j
public class Application {
    public static void main(String[] args) {
        var sampleProduct = Product.builder()
                .id("abc-123")
                .name("Chair")
                .description("Sample chair")
                .availability(Boolean.FALSE)
                .build();

        log.info("checkSerializable - {}", JsonSerializable.checkSerializable(sampleProduct));
        log.info("Json - {}", JsonSerializable.convertToJsonString(sampleProduct));
    }
}
```

<figure><img src="../../../.gitbook/assets/image (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

[^1]: [https://app.gitbook.com/o/tVyFnk5YBNmGbKUlXJjt/s/Pd6ktrA5pPLsZJktj2fm/\~/changes/30/spring/concepts/spring-aop/before-advice#scenario-1-logging-request-details-using-custom-annotation](../../../spring/concepts-set-1/spring-aop/before-advice.md#scenario-1-logging-request-details-using-custom-annotation)
