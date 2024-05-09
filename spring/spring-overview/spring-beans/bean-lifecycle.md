# Bean Lifecycle

## Description

The Spring Bean Lifecycle refers to the well-defined stages a bean goes through in a Spring application, from its creation to its eventual destruction. This lifecycle is managed by the Spring  IoC container (BeanFactory) and ensures proper initialization, configuration, and cleanup of beans.

### Stages

#### 1. Bean Instantiation:

The first step in the bean lifecycle is the instantiation of the bean. This occurs when the Spring IoC container reads the bean definition and creates an instance of the bean (corresponding class) based on the configuration metadata provided (e.g., XML configuration, Java annotations, or Java-based configuration). This instantiation can happen through various mechanisms depending on the bean scope (singleton, prototype, etc.).

#### **2. Bean Population (Property Setting):**

After creating the bean instance, Spring populates its properties with values. This involves, Injecting dependencies using constructor injection or setter injection or field injection(based on configuration) and Setting bean properties defined in the configuration file.

#### 3. Bean Post-Processing (Initialization Callbacks):

Once the properties are set, the container calls any registered BeanPostProcessors to perform any necessary post-processing on the bean instance. BeanPostProcessors allow for custom modifications to bean instances <mark style="background-color:yellow;">**before**</mark> and <mark style="background-color:yellow;">**after**</mark> initialization. These are beans that can intercept the lifecycle of other beans and perform additional logic before or after initialization. Two important methods defined in BeanPostProcessor interface are `postProcessBeforeInitialization()` and `postProcessAfterInitialization()`.

#### 4. Bean Custom Initialization:

After the post-processing phase, the container calls the bean's initialization callbacks to perform custom initialization logic. This can be achieved through:

* Implementing the `InitializingBean` interface (_**org.springframework.beans.factory.InitializingBean**_) and overriding the `afterPropertiesSet()` method.
* Specifying an initialization method using the `init-method` attribute in XML configuration or `@PostConstruct` annotation in Java configuration.

The initialization callbacks are typically used to perform any initialization tasks required by the bean before it's ready for use.

#### 5. Bean Ready for Use:

At this stage, bean is fully initialized and configured, it's ready to be used by other parts of application. Spring manages bean creation and retrieval through its dependency injection mechanisms.

#### 6. Bean Destruction:

When the application context is shut down or when the bean is no longer needed, the container calls the bean's destruction callbacks. Destruction callbacks can be implemented by:

* Implementing the `DisposableBean` interface and overriding the `destroy()` method.
* Specifying a destruction method using the `destroy-method` attribute in XML configuration or `@PreDestroy` annotation in Java configuration.

The destruction callbacks are used to perform any cleanup tasks required by the bean before it's destroyed, such as releasing resources or closing connections.

{% hint style="info" %}
Not all stages are mandatory. For instance, a bean might not require custom initialization or destruction logic.
{% endhint %}

### **Benefits of Managed Bean Lifecycle:**

* **Simplified Development:** Spring handles the complexities of bean creation, configuration, and destruction, allowing us to focus on core application logic.
* **Consistency and Predictability:** Ensures consistent initialization and cleanup behavior across all beans in Spring application.
* **Improved Testability:** By separating bean configuration from bean logic, Spring facilitates easier unit testing of beans.

