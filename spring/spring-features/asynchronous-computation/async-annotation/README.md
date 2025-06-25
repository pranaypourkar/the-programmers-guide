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

## When to Use `@Async` ?

### **1. Simple Asynchronous Execution**:

* **Background Tasks**: Use `@Async` when you want to offload simple, non-blocking tasks to a background thread. For example, sending an email, logging, or processing a file in the background without blocking the main thread.
* **Fire-and-Forget**: If the method doesn't need to return a result or you don't care about the outcome (like sending notifications or logging), `@Async` is a good fit.

### **2. Declarative Asynchronous Programming**:

* **Spring Integration**: If you are already using Spring and want a simple declarative approach to make a method asynchronous, `@Async` is an easy-to-use annotation that fits naturally within the Spring ecosystem.

### **3. Event-Driven Asynchrony**:

* **Handling Events Asynchronously**: When combined with Spring's event mechanism, `@Async` can make event listeners execute asynchronously, which is useful in systems where you need to decouple event processing from the main application flow.

### **4. Simple Configurations**:

* **Thread Pool Management**: If you need basic thread pool management but don't want to deal with the complexity of manually managing threads, `@Async` with a custom executor is a straightforward solution.

### **5. Exception Handling**:

* **Custom Async Exception Handling**: `@Async` allows you to define custom `AsyncUncaughtExceptionHandler` to handle uncaught exceptions in async methods, making it easier to handle exceptions without disrupting the main application flow.

## **When to Use `CompletableFuture` ?**

### **1. Complex Asynchronous Workflows**:

* **Chaining Asynchronous Tasks**: If your application requires a sequence of asynchronous tasks where each task depends on the result of the previous one, `CompletableFuture` is ideal. It allows you to chain tasks together using methods like `thenApply`, `thenCompose`, and `thenAccept`.
* **Combining Results from Multiple Tasks**: If you need to run multiple asynchronous tasks in parallel and then combine their results, `CompletableFuture` provides methods like `allOf`, `anyOf`, and `join` to handle such scenarios.

### **2. Fine-Grained Control**:

* **Custom Execution Logic**: `CompletableFuture` provides more control over how tasks are executed. You can specify different executors for different tasks, handle exceptions at each step, and control how results are combined.
* **Handling Timeouts and Delays**: With `CompletableFuture`, you can handle timeouts, delays, and retries more flexibly. For instance, you can specify a timeout for a task or retry a task if it fails.

### **3. Non-Blocking Async Calls**:

* **Reactive and Non-Blocking Systems**: In reactive or non-blocking architectures, `CompletableFuture` is often used to handle async calls without blocking the main thread. This is especially useful in highly concurrent systems where blocking threads can lead to performance bottlenecks.

### **4. Combining with Other Java 8+ Features**:

* **Streams and Parallelism**: `CompletableFuture` integrates well with other Java 8+ features like Streams and parallel processing, making it easier to build complex data processing pipelines that operate asynchronously.

### **5. Better Control Over Exceptions**:

* **Exception Handling**: `CompletableFuture` provides mechanisms like `exceptionally`, `handle`, and `whenComplete` to manage exceptions at various stages of the asynchronous workflow, offering more granular control compared to `@Async`.

## **Impact on Thread Context When Main Thread Exits**

* **Thread Context**:
  * The thread context includes things like security context, transaction context, and any thread-local variables.
  * When we return immediately and the main thread handling the HTTP request exits, the thread context associated with that main thread is no longer available.
* **Impact with `@Async`**:
  * Spring will execute the `@Async` method in a different thread. The new thread will not have the same context as the original main thread unless we explicitly propagate the context (e.g., using `DelegatingSecurityContextAsyncTaskExecutor` for security context).
  * If our asynchronous task relies on the main thread's context (e.g., security context or transaction management), we need to ensure that this context is either propagated or re-established in the new thread.
* **Impact with `CompletableFuture`**:
  * Similar to `@Async`, when using `CompletableFuture`, the task is executed in a different thread (unless we explicitly provide an executor with the same context).
  * Any context tied to the original request thread will not be present in the thread executing the `CompletableFuture`. This means if our task relies on the original thread's context, we may need to manually pass the necessary information or use context-aware executors.

## Example - **User Registration and Notification Service**

Imagine we are building a user registration system for an e-commerce platform. When a user registers, the system performs the following actions:

1. **Save the User Details** in the database.
2. **Send a Welcome Email** to the user.
3. **Notify Admins** of the new user registration.
4. **Generate a Welcome Gift Voucher** for the new user.

Some of these tasks, like sending an email or notifying admins, can be done asynchronously to improve the overall performance of the application.

```java
package com.example.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableAsync;

@Configuration
@EnableAsync
public class AsyncConfig {
    // We'll add a custom thread pool later
}
```

```java
package com.example.service;

import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.concurrent.CompletableFuture;

@Service
public class VoucherService {

    @Async
    public CompletableFuture<String> generateVoucher(String username) {
        // Simulate voucher generation
        return CompletableFuture.completedFuture("Voucher1234");
    }

    @Async
    public CompletableFuture<Void> sendVoucher(String username, String voucherCode) {
        // Simulate sending voucher
        System.out.println("Sent voucher " + voucherCode + " to " + username);
        return CompletableFuture.completedFuture(null);
    }

    @Async
    public void processVoucher(String username) {
        generateVoucher(username)
            .thenCompose(voucherCode -> sendVoucher(username, voucherCode))
            .join();  // Wait for the entire process to complete
    }
}
```



