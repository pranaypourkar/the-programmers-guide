# Servlets - TBU

## **What is Tomcat?**

Apache Tomcat is an open-source implementation of the Java Servlet, JavaServer Pages (JSP), and WebSocket technologies. It is designed to serve Java web applications, providing a "pure Java" HTTP web server environment for running Java code.

## **Who is Responsible for Tomcat?**

Apache Tomcat is developed and maintained by the Apache Software Foundation, a non-profit organization that supports various open-source projects.

## **Latest Version and Link**

As of July 2024, the latest stable version of Apache Tomcat is **10.1.10**. You can download it from the [official Apache Tomcat website](https://tomcat.apache.org/download-10.cgi).

## **Tomcat Architecture Diagram**

The Tomcat architecture is modular, consisting of several components that handle different aspects of request processing and web application management.

<figure><img src="../../../.gitbook/assets/image (468).png" alt="" width="375"><figcaption></figcaption></figure>

### **Layers in Tomcat Architecture**

1. **Server**
   * **Description**: The top-level component that represents the entire Tomcat instance. It contains all other components.
   * **Role**: Manages the overall Tomcat server lifecycle, including startup and shutdown processes.
2. **Service**
   * **Description**: A collection of connectors and engines. Each service represents a group of request processing elements.
   * **Role**: Defines a logical group of components that work together to handle incoming requests and generate responses.
3. **Engine**
   * **Description**: The core component that processes requests and generates responses. It is associated with a specific service.
   * **Role**: Routes incoming requests to the appropriate host and context for processing.
4. **Host**
   * **Description**: Represents a virtual host, which maps to a specific DNS hostname.
   * **Role**: Allows Tomcat to support multiple domains or applications on a single server instance.
5. **Context**
   * **Description**: Represents a web application, containing resources, servlets, JSP files, and other components.
   * **Role**: Isolates web applications from each other, enabling multiple applications to run simultaneously on the same host.

### **Components in Tomcat Architecture**

1. **Connectors**
   * **Description**: Handle communication between clients and the Tomcat server. They listen for incoming requests on specific ports and protocols.
   * **Types**:
     * **HTTP Connector**: Handles HTTP/1.1 requests.
     * **AJP Connector**: Handles AJP (Apache JServ Protocol) requests, often used for integrating with web servers like Apache HTTP Server.
   * **Role**: Translate incoming network requests into a format that the engine can process.
2. **Resources**
   * **Description**: Static content such as HTML files, images, and other static resources within a web application context.
   * **Role**: Serve static content directly to clients without further processing.
3. **Servlets**
   * **Description**: Java classes that handle dynamic content generation based on client requests.
   * **Role**: Process requests, perform business logic, and generate dynamic responses.
4. **JSP (JavaServer Pages)**
   * **Description**: Dynamic web pages that combine HTML with Java code.
   * **Role**: Simplify the creation of dynamic content by embedding Java code directly within HTML pages.

### Overall Flow

1. **Client Requests**: Clients send HTTP or AJP requests to the Tomcat server.
2. **Connector Handling**: Connectors receive these requests and pass them to the appropriate service.
3. **Engine Processing**: The engine processes the requests and routes them to the appropriate host based on the hostname.
4. **Host Resolution**: The host resolves the request to the correct web application (context) based on the URL.
5. **Context Execution**: Within the context, the request is either served directly (static resources) or processed by servlets and JSPs (dynamic content).
6. **Response Generation**: The processed content is returned through the same path back to the client.

## Additional **Tomcat Components**

### **Catalina**

* **Description**: Catalina is the core component of Tomcat, acting as the servlet container.
* **Role**: Implements the Java Servlet and JavaServer Pages (JSP) specifications. It manages the lifecycle of servlets, handles requests, and generates responses. Essentially, it is the heart of Tomcat that processes servlet and JSP requests.

### **Coyote**

* **Description**: Coyote is the HTTP connector component within Tomcat.
* **Role**: Processes incoming HTTP requests and passes them to the Catalina servlet container. It is responsible for listening on a specified port for HTTP/1.1 or HTTP/2 requests, parsing these requests, and then forwarding them to the appropriate servlet container for processing.

### **Jasper**

* **Description**: Jasper is the JSP engine for Tomcat.
* **Role**: Compiles JSP files into servlets. When a JSP file is requested, Jasper converts the JSP into a Java servlet and then compiles it. The compiled servlet is then handled by Catalina for execution. This enables dynamic content generation through JSP.

### **Cluster**

* **Description**: The cluster component provides support for clustering and load balancing in Tomcat.
* **Role**: Enables Tomcat to distribute requests across multiple server instances, ensuring high availability and scalability. It supports session replication, load balancing, and failover capabilities, which are essential for enterprise-grade applications.

### **Realm**

* **Description**: A Realm in Tomcat is responsible for authentication and authorization.
* **Role**: Defines how users and roles are stored and retrieved, and how authentication is performed. Realms can be integrated with various user databases, such as JDBC databases, JNDI directories, and others, to manage user access and permissions.

### **Valves and Filters**

* **Valves**:
  * **Description**: Valves are request processing components that can be attached to a specific Tomcat pipeline.
  * **Role**: Intercept requests before they reach a servlet, allowing for additional processing such as logging, authentication, or IP filtering.
* **Filters**:
  * **Description**: Filters are components defined in the Java Servlet API that can intercept requests and responses.
  * **Role**: Perform filtering tasks such as modifying request headers, compressing responses, or performing request logging. Filters are configured in the `web.xml` file of a web application.

## **List of Tomcat Features**

* Servlet and JSP support
* WebSocket support
* HTTP/2 support
* Clustering and load balancing
* Security and role-based access control
* Management and monitoring tools
* Extensible and customizable via plugins
* Integration with Apache Portable Runtime (APR) for enhanced performance

## **Installation Information**

* **Standalone Installation**: Download the binary distribution, extract it, and run the startup script (e.g., `startup.sh`or `startup.bat`).
* **Spring Boot-Based Installation**: Include `spring-boot-starter-tomcat` dependency in your `pom.xml` or `build.gradle` file. Spring Boot automatically configures and starts an embedded Tomcat instance.

## **Tomcat Configuration**

* Configuration files are located in the `conf` directory.
* Key configuration files include `server.xml` (main server configuration), `web.xml` (default servlet and JSP settings), and `context.xml` (context-specific settings).
* Configuration can include defining connectors, specifying resource limits, setting up security realms, and enabling clustering.

## **Connectors in Tomcat**

A connector in Tomcat is responsible for handling communications between the client and the server. It listens for incoming requests on a specific port and protocol (e.g., HTTP/1.1, HTTP/2, AJP) and forwards them to the appropriate servlet container components for processing. Connectors can be configured in the `server.xml` file.

## **Deploying WAR and JAR Web Applications in Tomcat**

* **WAR (Web Archive)**: Place the `.war` file in the `webapps` directory. Tomcat will automatically deploy it.
* **JAR (Java Archive)**: While traditionally Tomcat is designed to deploy WAR files, Spring Boot applications packaged as executable JARs can also be run with embedded Tomcat by executing the JAR file (`java -jar yourapp.jar`).

## **Using HTTPS in Tomcat**

* Tomcat supports HTTPS through SSL/TLS configuration.
* Configure HTTPS by adding an SSL connector in the `server.xml` file and specifying the keystore file, password, and protocol.

```xml
<Connector port="8443" protocol="org.apache.coyote.http11.Http11NioProtocol"
           maxThreads="200" SSLEnabled="true">
    <SSLHostConfig>
        <Certificate certificateKeystoreFile="conf/keystore.jks"
                     type="RSA" />
    </SSLHostConfig>
</Connector>
```

* Ensure the keystore file contains the SSL certificate and private key.
