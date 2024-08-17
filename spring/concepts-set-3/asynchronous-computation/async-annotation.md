# @Async annotation

## About

The `@Async` annotation in Spring allows to run methods asynchronously in a separate thread, rather than executing them in the main thread. It’s commonly used to improve application performance by offloading long-running tasks or non-blocking operations.

{% hint style="info" %}
**What is Asynchronous Programming?**

Asynchronous programming allows to execute tasks in the background without blocking the main thread. This can significantly improve the responsiveness of an application, especially in web applications where blocking the main thread can delay response times.
{% endhint %}

{% hint style="success" %}
**Some Points to Note**

**Calling `@Async` Methods within the Same Class**

If we call an `@Async` method from within the same class, it won’t work as expected because the AOP proxy mechanism Spring uses will not intercept the call. A workaround is to call the async method from a different bean or through self-injection.

**Handling Return Values Properly**

Since `@Async` methods return immediately, we should be careful when expecting a return value. Ensure that the calling code handles `Future` or `CompletableFuture` appropriately, especially for exception handling and timeout scenarios.

**5.3. Overloading the Thread Pool**

Ensure that the thread pool configuration matches the application's load. An improperly configured thread pool can either lead to resource exhaustion (too many threads) or poor performance (too few threads).
{% endhint %}

## How to use it?

### **1. Basic Setup**

To enable asynchronous processing, we need to configure our Spring application.

1. **Enable Asynchronous Processing**:

```java
@Configuration
@EnableAsync
public class AsyncConfig {
}
```

2. **Use `@Async` in Methods**:

```java
@Service
public class MyAsyncService {

    @Async
    public void asyncMethod() {
        System.out.println("Execute method asynchronously - "
            + Thread.currentThread().getName());
    }
}
```

3. **Calling Asynchronous Methods**:&#x20;

When we call `asyncMethod()`, it will run in a different thread than the caller thread.

### 2. **Return Type of Asynchronous Methods**

* **Void Return Type**: If we don't need to return anything, the method can simply have a `void` return type.
*   **Future Return Type**: If we need to return a result, can use `java.util.concurrent.Future`.

    ```java
    @Async
    public Future<String> asyncMethodWithReturnType() {
        // Simulate a long-running task
        return new AsyncResult<>("Hello from Async!");
    }
    ```
*   **CompletableFuture**: As of Java 8, `CompletableFuture` can be used as a more flexible alternative to `Future`.

    ```java
    @Async
    public CompletableFuture<String> asyncMethodWithCompletableFuture() {
        // Simulate a long-running task
        return CompletableFuture.completedFuture("Hello from Async!");
    }
    ```

### 3. Using Custom Thread Pools

By default, Spring uses a `SimpleAsyncTaskExecutor`, but in production, we may want to customize the thread pool to control the number of threads, queue size, etc.

1.  **Define a Custom Executor**:

    ```java
    @Configuration
    @EnableAsync
    public class AsyncConfig {

        @Bean(name = "taskExecutor")
        public Executor taskExecutor() {
            ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
            executor.setCorePoolSize(2);
            executor.setMaxPoolSize(5);
            executor.setQueueCapacity(500);
            executor.setThreadNamePrefix("Async-");
            executor.initialize();
            return executor;
        }
    }
    ```
2.  **Specify the Executor**: We can specify which executor to use for a particular method.

    ```java
    @Async("taskExecutor")
    public void asyncMethodWithCustomExecutor() {
        // method implementation
    }
    ```

### **4. Exception Handling in Async Methods**

Unhandled exceptions in asynchronous methods are not propagated to the calling thread. We need to handle exceptions within the method or provide a custom `AsyncUncaughtExceptionHandler`.

1.  **Custom Async Exception Handler**:

    ```java
    @Configuration
    @EnableAsync
    public class AsyncConfig implements AsyncConfigurer {

        @Override
        public Executor getAsyncExecutor() {
            return new ThreadPoolTaskExecutor();
        }

        @Override
        public AsyncUncaughtExceptionHandler getAsyncUncaughtExceptionHandler() {
            return new CustomAsyncExceptionHandler();
        }
    }

    public class CustomAsyncExceptionHandler implements AsyncUncaughtExceptionHandler {

        @Override
        public void handleUncaughtException(Throwable ex, Method method, Object... params) {
            System.out.println("Exception message - " + ex.getMessage());
            System.out.println("Method name - " + method.getName());
            for (Object param : params) {
                System.out.println("Parameter value - " + param);
            }
        }
    }
    ```

### **5. Chaining Asynchronous Calls**

Using `CompletableFuture`, we can chain asynchronous calls, making it easier to compose complex asynchronous workflows.

```java
@Async
public CompletableFuture<String> findUser() {
    // Simulate a long-running task
    return CompletableFuture.supplyAsync(() -> "User1");
}

@Async
public CompletableFuture<String> findUserOrders(String user) {
    // Simulate a long-running task
    return CompletableFuture.supplyAsync(() -> "Order1, Order2");
}

@Async
public CompletableFuture<String> findUserOrderDetails(String order) {
    // Simulate a long-running task
    return CompletableFuture.supplyAsync(() -> "OrderDetails");
}

public void getUserOrderDetails() {
    findUser()
        .thenCompose(this::findUserOrders)
        .thenCompose(this::findUserOrderDetails)
        .thenAccept(System.out::println);
}
```

### **6. Integration with Spring Events**

We can combine `@Async` with Spring’s event-driven programming model. By using `@Async` on event listeners, we can handle events asynchronously.

```java
@Component
public class MyEventListener {

    @Async
    @EventListener
    public void handleEvent(MyCustomEvent event) {
        // handle event asynchronously
    }
}
```



