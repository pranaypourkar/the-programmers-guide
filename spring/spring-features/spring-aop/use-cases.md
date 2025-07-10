# Use Cases

## 1. Perform Authorization Check with the help of HTTP Request Headers

We want to **perform an authorization check** without touching the controller logic.

#### Context

In a typical Spring Boot application, authorization logic is often placed in the **controller** or **service** methods. However, this tightly couples business logic with security concerns and **violates separation of concerns**.

We want to perform **authorization checks** (e.g., checking if the user has permission to access a resource) **without modifying the controller or service layer logic**.

#### Solution

We will:

1. Define a custom annotation
2. Apply it to the method we want to protect
3. Create an Aspect that intercepts the method and performs authorization
4. Keep the business logic clean and focused

#### Create the Custom Annotation

```java
@Target({ElementType.METHOD, ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
public @interface RequireAuthorization {
    String role() default "ADMIN";
}
```

This annotation will mark methods that require a role-based check.\
The default required role is `"ADMIN"` but it's customizable.

#### Create the Aspect

```java
@Aspect
@Component
public class AuthorizationAspect {

    private final HttpServletRequest request;

    public AuthorizationAspect(HttpServletRequest request) {
        this.request = request;
    }

    @Before("@annotation(requireAuthorization)")
    public void checkAuthorization(RequireAuthorization requireAuthorization) {
        // Extract the expected role from annotation
        String requiredRole = requireAuthorization.role();

        // Extract actual role from HTTP header
        String userRole = request.getHeader("X-USER-ROLE");

        // Null or missing role
        if (userRole == null) {
            throw new UnauthorizedException("Missing role in request header");
        }

        // Role mismatch
        if (!userRole.equalsIgnoreCase(requiredRole)) {
            throw new UnauthorizedException("Access denied. Required role: " + requiredRole);
        }

        // Authorized – proceed
    }
}
```

**Notes:**

* The aspect uses `@Before` to intercept method execution.
* `HttpServletRequest` is injected and used to read headers or parameters.
* We can extend this to check cookies, JWT claims, or session attributes.

#### Define Custom Exception

```java
@ResponseStatus(HttpStatus.FORBIDDEN)
public class UnauthorizedException extends RuntimeException {
    public UnauthorizedException(String message) {
        super(message);
    }
}
```

#### Apply the Annotation on a Controller or Service Method

```java
@RestController
@RequestMapping("/api/admin")
public class AdminController {

    @RequireAuthorization(role = "ADMIN")
    @DeleteMapping("/delete/{id}")
    public ResponseEntity<Void> deleteResource(@PathVariable String id) {
        // Controller logic untouched
        return ResponseEntity.ok().build();
    }
}
```

## 2. Trigger an Notification Event on Successful Payment Response

We want to **trigger an event** (e.g., sending a notification) **only after a controller method returns successfully**, without cluttering the controller logic. Request and Response object should be available while triggering that event to capture some of the details from it.

#### Approach

1. Use a **custom annotation** to mark methods where events should be triggered.
2. Write an **aspect** using `@AfterReturning` to intercept only successful executions.
3. Inject the `HttpServletRequest` and access the returned object (response).
4. Capture necessary data and publish a custom Spring event.

#### Solution

#### Custom Annotation

```java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface TriggerNotificationOnSuccess {
    String eventType() default "PAYMENT_SUCCESS";
}
```

#### Event Class

```java
public class PaymentSuccessEvent extends ApplicationEvent {
    private final HttpServletRequest request;
    private final Object response;
    private final String eventType;

    public PaymentSuccessEvent(Object source, HttpServletRequest request, Object response, String eventType) {
        super(source);
        this.request = request;
        this.response = response;
        this.eventType = eventType;
    }

    public HttpServletRequest getRequest() {
        return request;
    }

    public Object getResponse() {
        return response;
    }

    public String getEventType() {
        return eventType;
    }
}
```

#### Aspect to Intercept and Publish Event

```java
@Aspect
@Component
public class NotificationTriggerAspect {

    private final ApplicationEventPublisher eventPublisher;
    private final HttpServletRequest request;

    public NotificationTriggerAspect(ApplicationEventPublisher eventPublisher, HttpServletRequest request) {
        this.eventPublisher = eventPublisher;
        this.request = request;
    }

    @AfterReturning(pointcut = "@annotation(annotation)", returning = "result")
    public void afterSuccessfulResponse(TriggerNotificationOnSuccess annotation, Object result) {
        String eventType = annotation.eventType();

        PaymentSuccessEvent event = new PaymentSuccessEvent(
            this,
            request,
            result,
            eventType
        );

        eventPublisher.publishEvent(event);
    }
}
```

#### Sample Controller

```java
@RestController
@RequestMapping("/api/payments")
public class PaymentController {

    @PostMapping("/pay")
    @TriggerNotificationOnSuccess(eventType = "PAYMENT_SUCCESS")
    public PaymentResponse pay(@RequestBody PaymentRequest request) {
        // Payment processing logic
        return new PaymentResponse("TXN123456", "SUCCESS");
    }
}
```

#### Event Listener

```java
@Component
public class PaymentSuccessEventListener {

    @EventListener
    public void onPaymentSuccess(PaymentSuccessEvent event) {
        HttpServletRequest request = event.getRequest();
        Object response = event.getResponse();

        // Extract relevant info from request and response
        String userAgent = request.getHeader("User-Agent");
        String transactionId = ((PaymentResponse) response).getTransactionId();

        // Trigger notification logic
        System.out.println("Sending notification for transaction: " + transactionId + " from " + userAgent);
    }
}
```

