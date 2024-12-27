# Bean Lifecycle

## Description

The Spring Bean Lifecycle refers to the well-defined stages a bean goes through in a Spring application, from its creation to its eventual destruction. This lifecycle is managed by the Spring IoC container (BeanFactory) and ensures proper initialization, configuration, and cleanup of beans.

## **Benefits of Managed Bean Lifecycle:**

* **Simplified Development:** Spring handles the complexities of bean creation, configuration, and destruction, allowing us to focus on core application logic.
* **Consistency and Predictability:** Ensures consistent initialization and cleanup behavior across all beans in Spring application.
* **Improved Testability:** By separating bean configuration from bean logic, Spring facilitates easier unit testing of beans.

## Stages

<figure><img src="../../../.gitbook/assets/image (318).png" alt="" width="563"><figcaption><p>Reference - <a href="https://bootcamptoprod.com/spring-bean-life-cycle-explained/">https://bootcamptoprod.com/spring-bean-life-cycle-explained/</a></p></figcaption></figure>

### 1. Bean Instantiation:

The first step in the bean lifecycle is the instantiation of the bean. This occurs when the Spring IoC container reads the bean definition and creates an instance of the bean (corresponding class) based on the configuration metadata provided (e.g., XML configuration, Java annotations, or Java-based configuration). This instantiation can happen through various mechanisms depending on the bean scope (singleton, prototype, etc.).

During this stage, the container creates a new instance of the bean by invoking its constructor. The primary purpose of this stage is to prepare the bean for further initialization.

```java
public class MyBean {
    public MyBean() {
        System.out.println("Instantiation: A new MyBean has been created.");
    }
    // Other methods
}
```

### **2. Bean Population (Property Setting):**

After creating the bean instance, Spring populates its properties with values. This involves, Injecting dependencies using constructor injection or setter injection or field injection(based on configuration) and Setting bean properties defined in the configuration file.

```java
public class MyBean {
    private Item item;

    public void setItem(Item item) {
        this.item = item;
        System.out.println("Population of Properties: Adding item to MyBean");
    }
    // Other methods
}
```

### **3. BeanNameAware: Giving Identity to the Bean** <a href="#id-3-beannameaware-giving-identity" id="id-3-beannameaware-giving-identity"></a>

After instantiation, the bean becomes aware of its assigned name within the Spring container. The `BeanNameAware` interface in Spring provides a way for a bean to be aware of its own bean name, i.e., the identifier used to reference it within the Spring IoC container. Implementing the `BeanNameAware` interface allows a bean to obtain its assigned bean name during initialization.

```java
public class MyBean implements BeanNameAware {
    private String beanName;
    
    @Override
    public void setBeanName(String name) {
        this.beanName = name;
        System.out.println("BeanNameAware: Setting bean name: " + name);
    }
    
    public String getBeanName() {
        return beanName;
    }
    // Other methods
}
```

### 4. **BeanFactoryAware and ApplicationContextAware:** Utilizing Context

The next stage involves the bean gaining awareness of the bean factory or application context it’s part of. This awareness fosters interaction with other beans and resources within the context. It is used when access global context and resources is needed.

Both the `BeanFactoryAware` and `ApplicationContextAware` interfaces in Spring provide a way for a bean to gain access to the Spring IoC container in which it is managed. They allow the bean to interact with the container programmatically, gaining access to the container's features and resources.

#### BeanFactoryAware Interface:

The `BeanFactoryAware` interface is used by beans that need access to the Spring BeanFactory that manages them. When a bean implements this interface, Spring automatically injects the BeanFactory instance into the bean before it is initialized.

#### ApplicationContextAware Interface:

The `ApplicationContextAware` interface is used by beans that need access to the ApplicationContext, which is a specialization of the BeanFactory interface. ApplicationContext provides additional features such as internationalization, event propagation, application context hierarchy, and more. When a bean implements this interface, Spring injects the ApplicationContext instance into the bean before it is initialized.

```java
public class MyBean implements BeanFactoryAware, ApplicationContextAware {

    @Override
    public void setBeanFactory(BeanFactory beanFactory) {
        System.out.println("BeanFactoryAware: Setting bean factory");
    }

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) {
        System.out.println("ApplicationContextAware: Setting application context.");
    }
    // Other methods
}
```

### 5. Bean Post-Processing (Initialization Callbacks):

Once the properties are set, the container calls any registered BeanPostProcessors to perform any necessary post-processing on the bean instance. BeanPostProcessors allow for custom modifications to bean instances <mark style="background-color:yellow;">**before**</mark> and <mark style="background-color:yellow;">**after**</mark> initialization. These are beans that can intercept the lifecycle of other beans and perform additional logic before or after initialization. Two important methods defined in BeanPostProcessor interface are `postProcessBeforeInitialization()` and `postProcessAfterInitialization()`.

```java
public class MyBeanPostProcessor implements BeanPostProcessor {

    @Override
    public Object postProcessBeforeInitialization(Object bean, String beanName) {
        if (bean instanceof MyBean) {
            System.out.println("BeanPostProcessor:postProcessBeforeInitialization for " + ((MyBean) bean).getBeanName());
        }
        return bean;
    }

    @Override
    public Object postProcessAfterInitialization(Object bean, String beanName) {
        if (bean instanceof MyBean) {
            System.out.println("BeanPostProcessor:postProcessAfterInitialization for " + ((MyBean) bean).getBeanName());
        }
        return bean;
    }
}
```

### 6. Customizing Bean Initialization:

After the post-processing phase, the container calls the bean's initialization callbacks to perform custom initialization logic. This can be achieved through:

* Implementing the `InitializingBean` interface (_**org.springframework.beans.factory.InitializingBean**_) and overriding the `afterPropertiesSet()` method.
* Specifying an initialization method using the `init-method` attribute in XML configuration or `@PostConstruct` annotation (_**javax.annotation.PostConstruct**_) in Java configuration.

It’s useful when you need to perform specific actions on the bean right after it’s initialized, such as configuring properties or performing last-minute preparations. One of the use-case can be like after a pod restart, we might want to delete temporary data or expired records from the database or reload cache data from the database to ensure a clean state.

```java
public class MyBean {
    
    @PostConstruct
    public void init() {
         System.out.println("Executing @PostConstruct annotated method");
    }
}
```

Also, this stage provides an opportunity for executing custom setup logic after properties are set and before the bean is ready for use.

```javascript
public class MyBean implements InitializingBean {
    @Override
    public void afterPropertiesSet() {
        System.out.println("InitializingBean:afterPropertiesSet is executed");
    }
    // Other methods
}
```

### 7. **Custom Initialization: For Special Scenario**

In some scenarios, the need arises for specialized initialization steps that go above standard setup. This is where custom initialization methods helps.

```java
public class MyBean {
    public void customInit() {
        System.out.println("Custom Initialization: Executing custom init for MyBean");
    }
    // Other methods
}
```

### 8. Bean Ready for Use:

At this stage, bean is fully initialized and configured, it's ready to be used by other parts of application. Spring manages bean creation and retrieval through its dependency injection mechanisms.

### 9. Bean Destruction:

When the application context is shut down or when the bean is no longer needed, the container calls the bean's destruction callbacks. Destruction callbacks can be implemented by:

* Implementing the `DisposableBean` interface and overriding the `destroy()` method.
* Specifying a destruction method using the `destroy-method` attribute in XML configuration or `@PreDestroy` annotation in Java configuration.

The destruction callbacks are used to perform any cleanup tasks required by the bean before it's destroyed, such as releasing resources or closing connections.

```java
import javax.annotation.PreDestroy;

public class MyBean {

    @PreDestroy
    public void preCleanup() {
        System.out.println("@PreDestroy: MyBean");
    }
}
```

```java
public class MyBean implements DisposableBean {

    @Override
    public void destroy() {
        System.out.println("DisposableBean:destroy method executed");
    }
}
```

**When to Use:**

* Use `@PreDestroy` when we want to define destruction logic in a declarative way using annotations, especially in Java EE or Spring applications.
* Use `DisposableBean` when we need to implement destruction logic programmatically and don't mind the tight coupling with the Spring framework.

{% hint style="warning" %}
Additional dependency will be needed to include in pom.xml for javax annotations

```xml
<dependency>
    <groupId>javax.annotation</groupId>
    <artifactId>javax.annotation-api</artifactId>
</dependency>
```
{% endhint %}

{% hint style="info" %}
Not all stages are mandatory. For instance, a bean might not require custom initialization or destruction logic.
{% endhint %}

## Example

### Structure

<figure><img src="../../../.gitbook/assets/image (317).png" alt="" width="357"><figcaption></figcaption></figure>

### pom.xml dependency

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

### Classes and Methods declaration

#### Item class

```java
package org.example.beans;

public class Item {
    private String name;

    public Item(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }
}
```

#### MyBean class

```java
package org.example.beans;

import org.springframework.beans.factory.*;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;

public class MyBean implements BeanNameAware, ApplicationContextAware, InitializingBean, DisposableBean, BeanFactoryAware {
    private String beanName;
    private Item item;
    private ApplicationContext applicationContext;
    private BeanFactory beanFactory;

    public MyBean() {
        System.out.println("Step 1: Bean Instantiation - Constructor");
    }

    public void setItem(Item item) {
        this.item = item;
        System.out.println("Step 2: Population of Properties: Adding item to MyBean");
    }

    @Override
    public void setBeanName(String name) {
        this.beanName = name;
        System.out.println("Step 3: BeanNameAware: Setting bean name: " + name);
    }

    public String getBeanName() {
        return beanName;
    }

    @Override
    public void setBeanFactory(BeanFactory beanFactory) {
        this.beanFactory = beanFactory;
        System.out.println("Step 4: BeanFactoryAware: Setting bean factory");
    }

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) {
        System.out.println("Step 4: ApplicationContextAware: Setting application context.");
    }

    @PostConstruct
    public void init() {
        System.out.println("Step 6: Executing @PostConstruct annotated method");
    }

    @Override
    public void afterPropertiesSet() {
        System.out.println("Step 6: InitializingBean:afterPropertiesSet is executed");
    }

    public void customInit() {
        System.out.println("Step 7: Custom Initialization: Executing custom init for MyBean");
    }

    @PreDestroy
    public void preCleanup() {
        System.out.println("Step 9: @PreDestroy: MyBean");
    }

    @Override
    public void destroy() {
        System.out.println("Step 9: DisposableBean:destroy method executed");
    }
}
```

#### MyBeanConfig class

```java
package org.example.config;

import org.example.beans.Item;
import org.example.beans.MyBean;
import org.example.processor.MyBeanPostProcessor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class MyBeanConfig {
    @Bean(initMethod = "customInit", destroyMethod = "preCleanup")
    public MyBean myBean() {
        MyBean myBean = new MyBean();
        myBean.setItem(someItem());
        return myBean;
    }

    @Bean
    public Item someItem() {
        return new Item("Some Item");
    }

    @Bean
    public MyBeanPostProcessor myBeanPostProcessor() {
        return new MyBeanPostProcessor();
    }
}
```

#### MyBeanPostProcessor class

```java
package org.example.processor;

import org.example.beans.MyBean;
import org.springframework.beans.factory.config.BeanPostProcessor;

public class MyBeanPostProcessor implements BeanPostProcessor {

    @Override
    public Object postProcessBeforeInitialization(Object bean, String beanName) {
        if (bean instanceof MyBean) {
            System.out.println("Step 5: BeanPostProcessor:postProcessBeforeInitialization for " + ((MyBean) bean).getBeanName());
        }
        return bean;
    }

    @Override
    public Object postProcessAfterInitialization(Object bean, String beanName) {
        if (bean instanceof MyBean) {
            System.out.println("Step 5: BeanPostProcessor:postProcessAfterInitialization for " + ((MyBean) bean).getBeanName());
        }
        return bean;
    }
}

```

#### Main Application class

```java
package org.example;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ConfigurableApplicationContext;

@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        ConfigurableApplicationContext applicationContext = SpringApplication.run(Application.class, args);
        applicationContext.close();
    }
}

```

### Run the application and verify the output

<figure><img src="../../../.gitbook/assets/image (316).png" alt=""><figcaption></figcaption></figure>

## FAQs

#### **Can I use constructor injection and setter injection in the same bean?**

Yes, we can combine constructor injection and setter injection in the same bean, allowing to set mandatory properties through the constructor and optional properties using setter methods.

#### **What happens if a bean fails to initialize during the application startup process?**

If a bean fails to initialize (e.g., due to an exception), Spring usually stops the application startup and provides error messages or exceptions that indicate the problem.

#### **Can I use AOP (Aspect-Oriented Programming) with Spring** [**Bean**](https://bootcamptoprod.com/spring-bean-life-cycle-explained/) **life cycle methods?**

Yes, we can use AOP to apply aspects (cross-cutting concerns) before, after, or around Spring Bean life cycle methods, enabling you to add custom behaviour such as logging or security checks.

#### **Are there any performance considerations when using Spring Bean life cycle methods extensively?**

Extensive use of life cycle methods can affect application startup time. Best to avoid performing costly operations during initialization.
