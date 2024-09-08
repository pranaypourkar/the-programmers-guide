# Camel Endpoints

## About

In Apache Camel, endpoints are a critical concept used to define communication points for various systems and applications. They represent either the source or destination of messages within a Camel route, serving as connection points for components, such as files, messaging systems, databases, or web services. Endpoints allow Camel to integrate with external systems and facilitate the movement of data in and out of Camel routes.

## Key Aspects of Camel Endpoints

### **Definition of Endpoints**

* An endpoint defines how and where to interact with an external system. It typically contains a URI that specifies the protocol, location, and any necessary options (e.g., credentials or connection properties) for accessing a particular resource.
* Endpoints can be categorized as either **producers** (sending messages) or **consumers** (receiving messages).

### **Endpoint URI**

* The URI (Uniform Resource Identifier) is used to define an endpoint and describe how Camel should connect to the external resource.
* For example:
  * `file://inputDirectory` for reading files from a directory.
  * `jms:queue:orders` for interacting with a JMS queue named "orders."
  * `http://api.example.com` for making HTTP requests to a RESTful API.

### **Creating Endpoints**

* Endpoints can be defined using Java DSL, XML DSL, or annotations.

**Java DSL** example:

```java
from("file:inputFolder").to("jms:queue:orderQueue");
```

**XML DSL** example:

```xml
<from uri="file:inputFolder"/>
<to uri="jms:queue:orderQueue"/>
```

### **Components**

* Endpoints are provided by **components**, which are the building blocks that connect Camel to the outside world. Components expose various types of endpoints, such as:
  * `File` component to interact with file systems.
  * `JMS` component to communicate with messaging systems like ActiveMQ.
  * `HTTP` component to send or receive HTTP requests.
  * `Kafka` component to connect to Apache Kafka.
* Each component supports one or more endpoints, and every endpoint has its unique URI scheme.

### **Consumer vs. Producer Endpoints**

* **Consumers**: These are endpoints that start a route by consuming messages from a source. For example, a file consumer would listen to a directory and pick up files as messages.
  * `from("file:inputFolder")`: This starts a route by consuming files from a directory.
* **Producers**: These are endpoints that send messages to an external system or service. For example, a JMS producer would send messages to a queue.
  * `to("jms:queue:orderQueue")`: This sends a message to a JMS queue.

### **Types of Endpoints**

* **File Endpoints**: Connect to file systems to read and write files.
  * Example: `from("file:data/input").to("file:data/output");`
* **Messaging Endpoints**: Connect to messaging systems such as JMS, ActiveMQ, RabbitMQ, or Kafka.
  * Example: `from("jms:queue:inputQueue").to("jms:queue:outputQueue");`
* **HTTP/REST Endpoints**: Handle HTTP requests and communicate with REST APIs.
  * Example: `from("jetty:http://localhost:8080/order").to("file:output");`
* **Database Endpoints**: Connect to databases using components like JDBC or JPA.
  * Example: `from("sql:select * from orders where status='NEW'").to("jms:queue:newOrders");`
* **Timer Endpoints**: Generate periodic events based on a schedule.
  * Example: `from("timer://heartbeat?period=5000").to("log:heartbeat");`

### **Endpoint Options**

* Endpoints often support various configuration options that can be passed via the URI. These options allow you to customize the behavior of the endpoint.
*   Example with options:

    ```java
    from("file:data/input?noop=true&delay=5000")
    .to("file:data/output");
    ```

    * `noop=true`: Avoid moving or deleting the original file after processing.
    * `delay=5000`: Poll every 5 seconds.

### **Dynamic Endpoints**

* Camel allows the use of dynamic endpoints, where the URI of the endpoint is computed dynamically at runtime. This provides flexibility when dealing with varying external resources.
*   Example using a **simple** expression:

    ```java
    to("file:outputFolder/${header.orderType}");
    ```

    Here, the file path is constructed based on a message header `orderType`.

### **Polling Endpoints**

* Some endpoints (such as file or database endpoints) work in a polling mode, where Camel regularly checks for new data to process. You can configure polling intervals, delays, or throttling mechanisms on these endpoints.

### **Common Endpoint Patterns**

* **In-Only (One-Way)**: An endpoint that sends a message without expecting a response (e.g., a file write operation).
* **In-Out (Request-Response)**: An endpoint that sends a message and expects a response (e.g., an HTTP request).
