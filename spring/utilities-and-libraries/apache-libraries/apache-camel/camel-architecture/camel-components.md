# Camel Components

## About

In Apache Camel, components are essential building blocks that facilitate communication with various technologies, protocols, APIs, and services. Each component represents a technology-specific connector that allows Camel routes to interact with external systems. Components abstract the underlying complexity of a technology or protocol, making it easier for developers to use them in Camel routes.

## Key Aspects of Camel Components

### **Definition**

* A component in Apache Camel is a factory that creates and configures endpoints. Each component supports one or more endpoint types, depending on the nature of the technology or protocol it represents.
* For example:
  * The **File** component provides endpoints to interact with file systems.
  * The **JMS** component provides endpoints to work with messaging systems like ActiveMQ or RabbitMQ.
  * The **HTTP** component provides endpoints for making HTTP requests.

### **Component Structure**

* A component is identified by its URI scheme, which precedes the colon (e.g., `file:` or `jms:`). Camel identifies the right component by parsing the URI scheme.
* After the scheme, the URI may contain information such as file paths, server addresses, queue names, and additional options.

Example:

```java
from("file:inputDirectory?noop=true").to("jms:queue:orderQueue");
```

### **Types of Components**

Components can be broadly categorized based on their functionality or the type of technology they integrate with:

* **File-based Components**: Used for working with file systems and file transfers.
  * `file`, `ftp`, `sftp`
* **Messaging Components**: Used to interact with messaging systems, such as message brokers or event buses.
  * `jms`, `kafka`, `rabbitmq`
* **HTTP and Web Components**: Used to interact with web services, APIs, or to serve web content.
  * `http`, `jetty`, `servlet`, `rest`
* **Database Components**: Used to interact with databases and perform SQL operations.
  * `jdbc`, `jpa`, `sql`
* **Cloud Components**: Used for cloud-native integration, working with cloud services like AWS, Google Cloud, or Azure.
  * `aws-s3`, `google-pubsub`, `azure-storage-blob`
* **Timer and Scheduling Components**: Used for scheduling events or generating periodic messages.
  * `timer`, `quartz`, `cron`
* **Integration Patterns Components**: Components that support various integration patterns such as content-based routing, filtering, and more.
  * `direct`, `seda`, `vm`

### **Component Options**

* Each component typically has a set of configurable options that can be set in the URI. These options may include things like polling intervals, buffer sizes, security credentials, timeouts, etc.
*   Example with options:

    ```java
    from("ftp://server/folder?username=user&password=secret&binary=true&delay=5000")
    .to("file:outputFolder");
    ```

    * `username=user`: Specifies the FTP username.
    * `binary=true`: Configures the transfer mode to binary.
    * `delay=5000`: Specifies a 5-second polling interval.

### **Component Lifecycle**

* Components are instantiated when the **CamelContext** is started. They can be reused across multiple routes, and Camel manages their lifecycle, ensuring they are properly started and stopped with the CamelContext.

### **Built-in and Custom Components**

* Camel comes with a vast array of **built-in components** that support a wide variety of protocols, APIs, and technologies (e.g., JMS, FTP, Kafka, HTTP, SQL).
* In addition to built-in components, developers can create **custom components** if they need to integrate Camel with proprietary or uncommon systems.

Example of using a built-in component:

```java
from("jms:queue:inputQueue").to("file:outputFolder");
```

Custom components typically extend `org.apache.camel.Component` and can be registered with CamelContext.

### **Commonly Used Camel Components**

*   **File Component**: Handles reading from and writing to files and directories.

    ```java
    from("file:input").to("file:output");
    ```
*   **JMS Component**: Integrates with message brokers such as ActiveMQ or RabbitMQ for asynchronous messaging.

    ```java
    from("jms:queue:inputQueue").to("file:output");
    ```
*   **HTTP Component**: Used to send HTTP requests and consume HTTP services.

    ```java
    from("http://api.example.com/orders").to("log:response");
    ```
*   **Kafka Component**: Enables interaction with Apache Kafka for streaming and messaging.

    ```java
    from("kafka:my-topic").to("log:received");
    ```
*   **SQL Component**: Allows SQL queries to be executed against a relational database.

    ```java
    from("sql:select * from orders where status='NEW'").to("jms:queue:newOrders");
    ```
*   **Timer Component**: Triggers a route at regular intervals.

    ```java
    from("timer://heartbeat?period=10000").to("log:heartbeat");
    ```

### **Component Configuration**

* Components can be configured globally in the `CamelContext` or within specific routes.

**Global configuration** example in Spring XML:

```xml
<bean id="jms" class="org.apache.camel.component.jms.JmsComponent">
    <property name="connectionFactory" ref="myConnectionFactory"/>
</bean>
```

**In-route configuration** example:

```java
from("file:input?delete=true").to("file:output?fileExist=Append");
```

* This example shows file endpoint-specific options, where `delete=true` deletes the file after processing, and `fileExist=Append` appends to the existing file if it exists.

### **Creating Custom Components**

* While Camel provides a vast library of built-in components, it also offers a flexible framework for creating **custom components** for specific use cases.
* A custom component typically extends `org.apache.camel.Component` and defines how endpoints are created and how they interact with external systems.
* Custom components can be registered programmatically in CamelContext or as Spring beans.

### **Component Reuse and Flexibility**

* One of Camel’s strengths is the ability to reuse components across multiple routes or within different parts of an application. This makes Camel flexible and easy to extend when integrating various systems.
* For example, the **File Component** can be reused in multiple routes to handle file input/output in different directories or with different options.

### **Component Auto-discovery**

* Camel provides **auto-discovery** for components using its ServiceLoader. Components can be automatically loaded and registered by placing them in the correct directory (e.g., `META-INF/services/org/apache/camel/component`).
