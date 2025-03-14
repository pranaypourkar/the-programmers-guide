# Bean Scope

## About

In Spring, bean scopes define the lifecycle and visibility of beans within the Spring application context. Each scope serves different purposes and is suitable for different scenarios. Choosing the appropriate scope for a bean depends on factors such as concurrency requirements, statefulness, and the intended lifecycle of the bean in the application.

## Different bean scopes in the Spring Framework

### **Singleton Scope**:

* **Default Scope**: If no scope is specified, beans are by default singleton scoped.
* **Definition**: Only one instance of the bean is created per Spring IoC container, and this single instance is shared by all clients requesting the bean.
* **Lifecycle**: The bean instance is created when the container is initialized and remains in memory until the container is destroyed.
* **Usage**: Suitable for stateless beans or beans that can be safely shared across multiple clients without risking concurrency issues.
* **Declaration**: Use the `@Scope("singleton")` annotation or specify the scope attribute as "singleton" in XML configuration.
* **Example**: Database Connection Pool
* **Use Case**: We have a singleton bean representing a database connection pool that needs to be shared across multiple requests. This singleton bean ensures that database connections are efficiently managed and reused by all clients accessing the REST API.

```java
@Component
@Scope("singleton")
public class DatabaseConnectionPool {
    // Singleton bean representing a database connection pool
    // Implementation of database connection pooling logic
}
```

### **Prototype Scope**:

* **Definition**: A new instance of the bean is created every time it is requested from the Spring IoC container.
* **Lifecycle**: Each client requesting the bean receives a new, independent instance.
* **Usage**: Suitable for stateful beans or beans that require a new instance for each client, such as controllers in a web application.
* **Declaration**: Use the `@Scope("prototype")` annotation or specify the scope attribute as "prototype" in XML configuration.
* **Example**: Request-specific Logger
* **Use Case**: We have a prototype-scoped bean representing a logger that logs request-specific information. Each time a new HTTP request is received by the REST API, a new instance of the logger bean is created to log information specific to that request. This ensures that logging is isolated and independent for each request.

```java
@Component
@Scope("prototype")
public class RequestSpecificLogger {
    // Prototype-scoped bean representing a logger for request-specific information
    // Implementation of logging logic
}
```

### **Request Scope**:

* **Definition**: A new instance of the bean is created for each HTTP request in a web application.
* **Lifecycle**: The bean instance is bound to the lifecycle of an HTTP request, and a new instance is created for each request.
* **Usage**: Suitable for beans that need to be scoped to the lifecycle of an HTTP request, such as request-specific controllers or service classes.
* **Declaration**: Use the `@Scope("request")` annotation or specify the scope attribute as "request" in XML configuration.
* **Example**: User Authentication Context
* **Use Case**: We have a request-scoped bean representing the authentication context of a user. Each HTTP request to the REST API requires authentication, and the authentication context bean stores information about the authenticated user, such as their username and roles. This ensures that authentication information is scoped to each individual request and does not interfere with other concurrent requests.

```java
@Component
@Scope("request")
public class UserAuthenticationContext {
    // Request-scoped bean representing user authentication context
    // Stores information about the authenticated user for the current request
}
```

### **Session Scope**:

* **Definition**: A new instance of the bean is created for each HTTP session in a web application.
* **Lifecycle**: The bean instance is bound to the lifecycle of an HTTP session, and a new instance is created for each session.
* **Usage**: Suitable for beans that need to be scoped to the lifecycle of an HTTP session, such as session-specific controllers or service classes.
* **Declaration**: Use the `@Scope("session")` annotation or specify the scope attribute as "session" in XML configuration.
* **Example**: User Session Data
* **Use Case**: We have a session-scoped bean representing user session data, such as shopping cart items in an e-commerce application. Each user session in the web application has its own instance of the session bean, allowing users to maintain separate shopping carts and session-specific data as they interact with the REST API.

```java
@Component
@Scope("session")
public class UserSessionData {
    // Session-scoped bean representing user session data
    // Stores information specific to each user session, such as shopping cart items
}
```

### **Application Scope (Singleton per Servlet Context)**:

* **Definition**: A single instance of the bean is created per servlet context (web application).
* **Lifecycle**: The bean instance is shared across the entire application, regardless of the number of servlets or users.
* **Usage**: Suitable for beans that need to be shared across all components within a web application, such as application-wide configuration settings or cache managers.
* **Declaration**: Use the `@Scope("application")` annotation or specify the scope attribute as "application" in XML configuration.
* **Example**: Configuration Settings
* **Use Case**: We have an application-scoped bean representing application-wide configuration settings, such as database connection properties or system settings. This singleton bean ensures that configuration settings are shared across all components within the web application and remain consistent throughout the application's lifecycle.

```java
@Component
@Scope("application")
public class ApplicationConfigurationSettings {
    // Application-scoped bean representing application-wide configuration settings
    // Stores configuration properties, such as database connection settings
}
```

### **Custom Scopes**:

Spring allows defining custom scopes by implementing the `Scope` interface and registering the scope with the Spring IoC container. This allows for flexibility in defining custom bean lifecycle semantics tailored to specific application requirements.

```java
import org.springframework.beans.factory.ObjectFactory;
import org.springframework.beans.factory.config.Scope;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.HashMap;
import java.util.Map;

@Configuration
public class CustomScopeConfiguration {

    @Bean
    public CustomScope customScope() {
        return new CustomScope();
    }

    public static class CustomScope implements Scope {

        private final Map<String, Object> scopedObjects = new HashMap<>();

        @Override
        public Object get(String name, ObjectFactory<?> objectFactory) {
            return scopedObjects.computeIfAbsent(name, key -> objectFactory.getObject());
        }

        @Override
        public Object remove(String name) {
            return scopedObjects.remove(name);
        }

        @Override
        public void registerDestructionCallback(String name, Runnable callback) {
        }

        @Override
        public Object resolveContextualObject(String key) {
            return null;
        }

        @Override
        public String getConversationId() {
            return null;
        }
    }
}
```
