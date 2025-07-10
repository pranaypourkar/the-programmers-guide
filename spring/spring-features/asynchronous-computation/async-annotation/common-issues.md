# Common Issues

## 1. **java.lang.IllegalStateException - No thread-bound request found**

### **Case 1**

We have an HTTP endpoint that processes a payment and then asynchronously sends an SMS using a method annotated with `@Async`. Inside the async method, some values are accessed from the `HttpServletRequest` or request-scoped beans.

**Error Message:**

```
java.lang.IllegalStateException: No thread-bound request found: 
Are you referring to request attributes outside of an actual web request, 
or processing a request outside of the originally receiving thread? 
If you are actually operating within a web request and still receive this message, 
your code is probably running outside of DispatcherServlet: 
In this case, use RequestContextListener or RequestContextFilter to expose the current request.
```

#### **Root Cause:**

Spring manages the HTTP request lifecycle using thread-bound context. That means request-related objects (like `HttpServletRequest`, `RequestAttributes`, or beans scoped as `request`) are available only within the thread that handled the request.

When we use `@Async`, the annotated method executes in a **separate thread**, which does **not have access to the original thread’s request context**. So any attempt to read request attributes (like headers, parameters, or session data) from the async method will result in this exception.

#### **Solution:**

**Option 1: Pass Required Data Explicitly**

The recommended and safest approach is to extract any necessary values from the request **before** calling the async method, and pass them as method arguments.

```java
@PostMapping("/pay")
public ResponseEntity<Void> processPayment(HttpServletRequest request) {
    String userId = request.getHeader("X-USER-ID");
    paymentService.process(); // sync logic
    notificationService.sendSmsAsync(userId); // pass needed data explicitly
    return ResponseEntity.ok().build();
}

@Async
public void sendSmsAsync(String userId) {
    // use userId directly, no need for request context
}
```

**Option 2: Register a `RequestContextListener`**

If we absolutely need access to the request context in the async thread, register a `RequestContextListener` in our configuration:

```java
@Bean
public RequestContextListener requestContextListener() {
    return new RequestContextListener();
}
```

> Note: Even with this, it's **not always reliable** to depend on request context in async threads, especially under heavy load or across thread pools.

**Option 3: Use a `RequestContextFilter` (Alternative to Listener)**

If our application uses filters and we want to ensure consistent behavior across threads, we can use `RequestContextFilter`:

```java
@Bean
public FilterRegistrationBean<RequestContextFilter> requestContextFilter() {
    FilterRegistrationBean<RequestContextFilter> registration = new FilterRegistrationBean<>();
    registration.setFilter(new RequestContextFilter());
    return registration;
}
```

### Case 2

We are using @Asyn method which runs after main thread is over. This method calls another api and uses `private final HttpServletRequest request` but request is no more available as main thread is exited.

The issue arises because `HttpServletRequest` is inherently tied to the main thread's lifecycle in Java web applications. Once the main thread exits, the `HttpServletRequest` object is no longer valid or accessible.

When using `@Async` methods in Spring Boot, the code runs in a different thread than the one handling the HTTP request. To solve this issue, you need to extract the necessary information from `HttpServletRequest` before the main thread exits and pass it explicitly to the `@Async` method.

#### **1. Clone the Request Data**

Manually copy the relevant information from the `HttpServletRequest` before invoking the `@Async` method. We can store the information in a `Map` or a custom object.

Example:

**Main Thread**

```java
@PostMapping("/process")
public ResponseEntity<String> processRequest(HttpServletRequest request) {
    // Clone the request's data into a Map
    Map<String, String> requestData = new HashMap<>();
    Enumeration<String> headerNames = request.getHeaderNames();
    while (headerNames.hasMoreElements()) {
        String headerName = headerNames.nextElement();
        requestData.put(headerName, request.getHeader(headerName));
    }

    // Pass the cloned data to the async service
    asyncService.asyncMethod(requestData);

    return ResponseEntity.ok("Request processing started!");
}
```

**Async Service**

```java
@Service
public class AsyncService {

    @Async
    public void asyncMethod(Map<String, String> requestData) {
        // Use the cloned request data
        String headerValue = requestData.get("X-Custom-Header");
        System.out.println("Async thread processing with header: " + headerValue);

        // Call another API, using the cloned data
    }
}
```

#### **2. Use a ThreadLocal for Propagation**

Use a `ThreadLocal` to propagate the `HttpServletRequest` to the async thread. We can copy the data into a `ThreadLocal` before invoking the `@Async` method.

**Utility Class**

```java
public class RequestContext {
    private static final ThreadLocal<HttpServletRequest> requestHolder = new ThreadLocal<>();

    public static void setRequest(HttpServletRequest request) {
        requestHolder.set(request);
    }

    public static HttpServletRequest getRequest() {
        return requestHolder.get();
    }

    public static void clear() {
        requestHolder.remove();
    }
}
```

**Main Thread**

```java
@PostMapping("/process")
public ResponseEntity<String> processRequest(HttpServletRequest request) {
    // Set the request in ThreadLocal
    RequestContext.setRequest(request);

    asyncService.asyncMethod();

    return ResponseEntity.ok("Request processing started!");
}
```

**Async Service**

```java
@Service
public class AsyncService {

    @Async
    public void asyncMethod() {
        try {
            // Retrieve the request from ThreadLocal
            HttpServletRequest request = RequestContext.getRequest();
            if (request != null) {
                String headerValue = request.getHeader("X-Custom-Header");
                System.out.println("Async thread processing with header: " + headerValue);
            }
        } finally {
            // Clean up the ThreadLocal to prevent memory leaks
            RequestContext.clear();
        }
    }
}
```

**Caution**: Using `ThreadLocal` with `@Async` should be done carefully, as Spring may use thread pooling for async tasks. Always clear the `ThreadLocal` to avoid memory leaks or incorrect data propagation.

#### **3. Use RequestContextHolder**

Spring provides `RequestContextHolder` for accessing the current `HttpServletRequest`. However, we must configure Spring to allow request context propagation to async threads.

**Configuration**

Enable request context propagation in Spring Boot by setting the following property in `application.properties`:

```properties
spring.web.async.request-timeout=30000
```

**Access Request in Async Method**

```java
@Service
public class AsyncService {

    @Async
    public void asyncMethod() {
        HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
        String headerValue = request.getHeader("X-Custom-Header");
        System.out.println("Async thread processing with header: " + headerValue);

        // Call another API using the request data
    }
}
```

## 2. ScopeNotActiveException in Async/Executor Threads

The error we're encountering arises because the `@RequestScope` beans in Spring are tied to the HTTP request lifecycle. When using `ExecutorService` to execute tasks asynchronously, the task runs in a different thread from the original HTTP request thread, and the `RequestScope` is not active in the new thread.

#### **Why This Happens**

1. **Request Scope Lifecycle**:
   * Beans annotated with `@RequestScope` are bound to the lifecycle of the HTTP request.
   * When the original HTTP thread finishes processing the request, the request scope is destroyed.
2. **Asynchronous Threads**:
   * When we submit tasks to `ExecutorService`, these tasks are executed in separate threads. These threads are independent of the HTTP request and do not have access to the `RequestScope`.

#### **Solutions**

**1. Use Scoped Proxies**

Spring allows us to use a scoped proxy for `@RequestScope` beans. This creates a proxy object that resolves the actual bean at runtime, ensuring the correct `RequestScope` context is used.

Example:

```java
@Bean
@Scope(value = WebApplicationContext.SCOPE_REQUEST, proxyMode = ScopedProxyMode.TARGET_CLASS)
public MyRequestScopedBean requestScopedBean() {
    return new MyRequestScopedBean();
}
```

If our bean is already annotated with `@RequestScope`:

```java
@RequestScope
@Scope(proxyMode = ScopedProxyMode.TARGET_CLASS)
public class MyRequestScopedBean {
    // Implementation
}
```

**2. Pass Contextual Information**

Instead of relying on `@RequestScope` beans in an asynchronous task, pass the required request-scoped data as method parameters. Extract necessary data in the controller layer and pass it to the service or task.

Example:

```java
public void asyncTask(String requestScopedData) {
    executorService.submit(() -> {
        // Use the passed data
        System.out.println(requestScopedData);
    });
}
```

**3. Use `@Async` with Context Propagation**

The `@Async` annotation in Spring can manage scoped beans if properly configured with context propagation. We can use libraries like **Spring Cloud Sleuth** or **TaskDecorator** to propagate the request context.

*   **Example with `TaskDecorator`**:

    ```java
    @Bean
    public TaskDecorator taskDecorator() {
        return runnable -> {
            RequestAttributes context = RequestContextHolder.currentRequestAttributes();
            return () -> {
                try {
                    RequestContextHolder.setRequestAttributes(context);
                    runnable.run();
                } finally {
                    RequestContextHolder.resetRequestAttributes();
                }
            };
        };
    }

    @Bean
    public Executor taskExecutor(TaskDecorator taskDecorator) {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(10);
        executor.setMaxPoolSize(20);
        executor.setQueueCapacity(50);
        executor.setTaskDecorator(taskDecorator);
        executor.initialize();
        return executor;
    }
    ```

    This setup propagates the request context into asynchronous threads.

**4. Avoid Using `@RequestScope` for Long-Lived Tasks**

If our task requires data for processing that might outlive the request, consider fetching or caching the required data before starting the asynchronous task.
