# Camel Context

## **About**

Camel Context is the heart of Apache Camel. It acts as the runtime environment where routes are defined and executed, managing the entire lifecycle of the integration processes. Essentially, CamelContext is the container for all the key componets such as routes, components, endpoints, and processors.

<figure><img src="../../../../../.gitbook/assets/image (285).png" alt="" width="375"><figcaption></figcaption></figure>

## Key Responsibilities of CamelContext

### **Lifecycle Management**

* CamelContext manages the lifecycle of all the routes, components, endpoints, and other resources within an Apache Camel application.
* It can be started, stopped, suspended, and resumed, controlling the entire process flow in a Camel application.

### **Configuration**

* We can configure different aspects of Camel behavior via the CamelContext, including thread pools, error handlers, routes, endpoints, and more.
* CamelContext holds configurations related to the exchange pattern (InOnly, InOut), data formats, bean injection, and more.

### **Hosting Routes**

* All routes are defined and registered within the CamelContext. A route typically describes how a message moves from a source (producer) to a destination (consumer) and how it is transformed in between.
*   Example:

    ```java
    CamelContext context = new DefaultCamelContext();
    context.addRoutes(new RouteBuilder() {
        public void configure() {
            from("file:input")
            .to("file:output");
        }
    });
    ```

### **Component Registration**

* Components (e.g., File, JMS, HTTP, FTP) must be registered with the CamelContext, allowing it to understand different communication protocols.
* Components provide the foundation for building integration solutions by abstracting various protocols.

### **Route Management and Supervision**

* CamelContext monitors all the routes, starting and stopping them as necessary. It also handles route reinitialization or redeployment.
* Through CamelContext, we can programmatically or dynamically manage your routes (e.g., adding, removing, or updating them).

### **Event Management**

* CamelContext supports event-driven architectures and provides access to internal events (such as route lifecycle changes, exchanges starting and completing).
* We can listen to these events using `EventNotifier` to log, audit, or trigger other actions.

### **Error Handling**

* Error handling is managed at the CamelContext level. We can define global error handlers that apply across routes, or specific error handling mechanisms within individual routes.
* This is useful for handling exceptions, retries, dead-letter queues, and more.

### **Type Conversion**

* CamelContext contains the type converter registry, which enables automatic conversion of data from one type to another.
* This feature makes it easier to handle various data formats seamlessly in the routes.

### **Registry Integration**

* CamelContext integrates with dependency injection frameworks like Spring, CDI (Contexts and Dependency Injection), or Camel’s built-in Simple Registry to manage the components and services.
* We can inject beans and other resources directly into routes for better modularity and maintainability.

### **Data Format and Transformation**

* CamelContext holds configurations for data formats (such as XML, JSON, CSV) and allows routing data between different formats.
* We can define transformations and apply them at the route level using CamelContext's facilities.

### Language Choice

We can create routes in different languages. Here are a few examples of how the same route is defined in three different languages.

#### Java DSL

```
from("file:/order").to("jms:orderQueue");
```

#### Spring DSL

```
<route>
   <from uri = "file:/order"/>
   <to uri = "jms:orderQueue"/>
</route>
```

#### Scala DSL

```
from "file:/order" -> "jms:orderQueue"
```

## CamelContext Lifecycle

### **Starting the Context**

When you start CamelContext, it initializes all the components, routes, and resources, allowing the system to begin processing messages.

```java
CamelContext context = new DefaultCamelContext();
context.start();
```

### **Stopping the Context**&#x20;

Stopping the CamelContext gracefully shuts down all the routes and resources. It ensures that in-progress exchanges are completed.

```java
context.stop();
```

### **Suspending/Resuming**

We can temporarily suspend or resume CamelContext. Suspending the context pauses the routes, whereas resuming will restart the routes from where they were paused.

```java
context.suspend();
context.resume();
```

## Example of CamelContext

Sample example demonstrating how CamelContext hosts a route and interacts with a File component:

```java
CamelContext context = new DefaultCamelContext();
context.addRoutes(new RouteBuilder() {
    public void configure() {
        from("file:src/data?noop=true")
        .log("Received file: ${header.CamelFileName}")
        .to("file:target/messages");
    }
});
context.start();

// Stop Camel context gracefully after a few minutes
Thread.sleep(5 * 60 * 1000);
context.stop();
```

