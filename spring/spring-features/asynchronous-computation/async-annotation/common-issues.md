# Common Issues

## 1. **java.lang.IllegalStateException - No thread-bound request found**

**Context:**

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



