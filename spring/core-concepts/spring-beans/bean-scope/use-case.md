# Use Case

## @RequestScope&#x20;

### 1. Extracting `Accept-Language` Header Once Per Request

In many Spring Boot applications, we often need to extract headers like `Accept-Language` and make them available across various components (e.g., services or repositories). While interceptors can be used for this purpose, there are cleaner alternatives that leverage Spring's bean scopes and lifecycle events.

Below are 3 clean approaches that avoid duplication and keep the code modular and testable.

#### Solution 1: Using a `@RequestScope` Bean with `@ControllerAdvice`

This approach uses a Spring bean that is scoped to a single HTTP request. It holds the `Accept-Language` header, which is populated once per request using `@ControllerAdvice`.

1\. Create a Request-Scoped Bean\
This bean holds the header for the current HTTP request.

```java
import org.springframework.stereotype.Component;
import org.springframework.web.context.annotation.RequestScope;

@RequestScope
@Component
public class RequestContext {
    private String acceptLanguage;

    public String getAcceptLanguage() {
        return acceptLanguage;
    }

    public void setAcceptLanguage(String acceptLanguage) {
        this.acceptLanguage = acceptLanguage;
    }
}
```

2\. Populate the Bean Using `@ControllerAdvice`\
This class runs on every controller request and sets the header value into the `RequestContext`.

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import javax.servlet.http.HttpServletRequest;

@ControllerAdvice
public class AcceptLanguageAdvice {

    @Autowired
    private RequestContext requestContext;

    @ModelAttribute
    public void populateAcceptLanguage(HttpServletRequest request) {
        String acceptLanguage = request.getHeader("Accept-Language");
        requestContext.setAcceptLanguage(acceptLanguage);
    }
}
```

3\. Access the Header in Service Layer\
Inject the request-scoped bean wherever needed.

```java
import org.springframework.stereotype.Service;

@Service
public class MyService {

    private final RequestContext requestContext;

    public MyService(RequestContext requestContext) {
        this.requestContext = requestContext;
    }

    public void process() {
        String language = requestContext.getAcceptLanguage();
        // Use the language value as needed
    }
}
```

**Benefits:**

* Clean separation of concerns.
* Easy to test.
* Automatically available on every HTTP request.
* No need to repeat logic in each controller.

#### Solution 2: Injecting `HttpServletRequest` Directly in the Service

This is a more direct approach, suitable for simpler applications, where the service layer directly accesses the header using the `HttpServletRequest` object.

```java
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;

@Service
public class MyService {

    private final HttpServletRequest request;

    public MyService(HttpServletRequest request) {
        this.request = request;
    }

    public void process() {
        String acceptLanguage = request.getHeader("Accept-Language");
        // Use the header value directly
    }
}
```

#### Solution 3: Using a `@RequestScope` Bean That Injects `HttpServletRequest` Directly

This approach initializes the header value **once per HTTP request**, directly inside the `@RequestScope` bean.

1\. Create a Request-Scoped Bean

```java
import org.springframework.stereotype.Component;
import org.springframework.web.context.annotation.RequestScope;

import javax.servlet.http.HttpServletRequest;

@RequestScope
@Component
public class RequestContext {

    private final String acceptLanguage;

    public RequestContext(HttpServletRequest request) {
        this.acceptLanguage = request.getHeader("Accept-Language");
    }

    public String getAcceptLanguage() {
        return acceptLanguage;
    }
}
```

* Here, the `HttpServletRequest` is injected by Spring.
* The header value is extracted and stored once when the bean is initialized.
* No need for any `@ControllerAdvice` or extra setup.

2\. Use It in Any Service

```java
import org.springframework.stereotype.Service;

@Service
public class MyService {

    private final RequestContext requestContext;

    public MyService(RequestContext requestContext) {
        this.requestContext = requestContext;
    }

    public void process() {
        String lang = requestContext.getAcceptLanguage();
        // Use the language
    }
}
```

