# Web Server

## About

A web server is a software component that delivers static data like images, files, and text in response to client requests. Whereas, an application server adds business logic to compute the web server's response. Web server contains only web or servlet container. It can be used for servlet, jsp, struts, jsf etc. It can't be used for EJB.

For example, browser and web server communicate as follows:

1. The browser uses the URL to find the server’s IP address
2. The browser sends an HTTP request for information
3. The web server communicates with a database server to find the relevant data
4. The web server returns static content such as HTML pages, images, videos, or files in an HTTP response to the browser
5. The browser then displays the information

{% hint style="info" %}
The terms "Web Server" and "Application Server" are often used interchangeably, but they serve distinct purposes.

* **Key Differences**:
  * **Web Server**: Primarily serves HTTP content and is optimized for handling static content. It may support dynamic content through plugins or scripting languages like Perl, PHP, ASP, or JSP.
  * **Application Server**: Includes all features of a Web Server but extends functionality to support additional protocols such as RMI/RPC. It provides comprehensive support for dynamic content generation and includes advanced services like connection pooling, object pooling, transactions, and messaging.
* **Integration and Usage**:
  * Most application servers integrate a web server component, allowing them to handle both static and dynamic content efficiently.
  * In production environments, web servers often act as reverse proxies to application servers. They serve static content directly and transparently forward requests for dynamic content to the application server, leveraging their respective strengths in content handling.
{% endhint %}

## Can Web Server handle dynamic content?

Modern web servers can handle dynamic content to some extent, but their primary role traditionally revolves around serving static content.

1. **Static vs Dynamic Content**: Web servers like Apache HTTP Server or Nginx are designed to efficiently serve static content such as HTML files, images, CSS, and JavaScript files. This content doesn't change based on user requests and can be served directly from disk.
2. **Dynamic Content Handling**: While web servers themselves focus on static content, they can integrate with application servers or runtime environments (like servlet containers such as Apache Tomcat or application servers like WildFly) to handle dynamic content. These application servers execute server-side programs (e.g., Java servlets, PHP scripts) to generate dynamic responses based on user input, database queries, or other computations.
3. **Reverse Proxy and Load Balancing**: Web servers can also act as reverse proxies or load balancers, forwarding requests to multiple application servers based on various criteria (like load balancing algorithms or URL patterns). This setup allows web servers to distribute dynamic content generation tasks efficiently among multiple backend servers.
4. **Performance Considerations**: While web servers can handle dynamic content through integration with application servers or via reverse proxy setups, the performance and scalability of handling dynamic content may benefit from using specialized application servers designed for such tasks.

## Architecture Diagram

<figure><img src="../../.gitbook/assets/image (27).png" alt="" width="563"><figcaption></figcaption></figure>

**Components**

1. **Client**: This could be a web browser or any other client application that initiates HTTP requests to the web server.
2. **Web Server**: Handles incoming HTTP requests from clients. It serves static content directly (like HTML pages, images) and may delegate dynamic content requests to the application server.
3. **Application Server**: Executes server-side programs or scripts (such as servlets, JSPs, PHP scripts) to generate dynamic content based on the client's request. It interacts with databases or other backend services to process data and business logic.

**Interaction Flow**

* **Client to Web Server**: The client initiates an HTTP request (e.g., GET /index.html) to the web server.
* **Web Server**: The web server receives the request and checks if the requested resource is static (like HTML, images). If it's static, the web server directly serves it back to the client. If the request requires dynamic content (e.g., data from a database), the web server forwards the request to the application server.
* **Application Server**: Upon receiving a request from the web server, the application server executes server-side programs to generate the dynamic content. This could involve querying databases, performing calculations, or executing business logic.
* **Response to Web Server**: Once the application server has generated the dynamic content, it sends the response back to the web server.
* **Web Server to Client**: Finally, the web server forwards the dynamic content received from the application server as an HTTP response back to the client.

## Web Server vs. Application Server

<table data-full-width="true"><thead><tr><th width="192">Aspect</th><th width="284">Web Server</th><th>Application Server</th></tr></thead><tbody><tr><td><strong>Servlets</strong></td><td>Handles HTTP requests and generates dynamic content using Java servlets.</td><td>Supports Java servlets for handling HTTP requests and provides an environment for running servlets effectively.</td></tr><tr><td><strong>JSP</strong></td><td>Supports JavaServer Pages (JSP), allowing embedding of Java code in HTML pages for dynamic content generation.</td><td>Allows for the execution of JSP pages, facilitating dynamic content generation by embedding Java code within HTML pages.</td></tr><tr><td><strong>Expression Language (EL)</strong></td><td>Provides a language for embedding expressions into JSP pages, simplifying access to Java components and data.</td><td>Includes EL for JSP pages, enabling easy access to Java components and data within JSP-based web applications.</td></tr><tr><td><strong>WebSocket</strong></td><td>Supports WebSocket protocol for full-duplex communication between client and server over a single TCP connection.</td><td>Provides WebSocket support, enabling real-time, bidirectional communication between client and server applications.</td></tr><tr><td><strong>JTA (Java Transaction API)</strong></td><td>Basic support for transactions, including local transactions within servlets.</td><td>Offers comprehensive JTA support, facilitating distributed transactions across multiple resources within enterprise applications.</td></tr><tr><td><strong>JASPIC (Java Authentication Service Provider Interface for Containers)</strong></td><td>Provides basic authentication mechanisms for web applications.</td><td>Includes JASPIC for advanced authentication mechanisms, allowing integration with various authentication protocols and frameworks.</td></tr><tr><td><strong>Batch</strong></td><td>Not typically supported.</td><td>Provides support for batch processing, allowing execution of batch jobs within the application server environment.</td></tr><tr><td><strong>CDI (Contexts and Dependency Injection)</strong></td><td>Basic support for dependency injection within servlets.</td><td>Offers full CDI support, allowing for loosely coupled and reusable components through dependency injection within enterprise applications.</td></tr><tr><td><strong>Bean Validation</strong></td><td>Basic validation capabilities for data within servlets.</td><td>Offers comprehensive Bean Validation support, facilitating declarative validation of data within enterprise applications.</td></tr><tr><td><strong>EJB (Enterprise JavaBeans)</strong></td><td>Not supported.</td><td>Provides support for EJBs, allowing for scalable, transactional components within enterprise applications.</td></tr><tr><td><strong>JPA (Java Persistence API)</strong></td><td>Basic support for persistence of data within servlets.</td><td>Offers full JPA support, enabling easy management and persistence of data within enterprise applications using relational databases.</td></tr><tr><td><strong>JSON-P (JSON Processing)</strong></td><td>Basic support for processing JSON data within servlets.</td><td>Provides JSON-P support, facilitating the manipulation and transformation of JSON data within enterprise applications.</td></tr><tr><td><strong>JMS (Java Message Service)</strong></td><td>Basic support for messaging within servlets.</td><td>Offers full JMS support, enabling asynchronous communication between distributed components within enterprise applications.</td></tr><tr><td><strong>JavaMail</strong></td><td>Basic support for sending emails within servlets.</td><td>Provides JavaMail support, allowing for the sending and receiving of emails within enterprise applications.</td></tr><tr><td><strong>JAX-RX (Java API for RESTful Web Services)</strong></td><td>Basic support for building and consuming RESTful web services within servlets.</td><td>Provides JAX-RS support, facilitating the development of RESTful web services for seamless integration with enterprise applications.</td></tr><tr><td><strong>JAX-WS (Java API for XML Web Services)</strong></td><td>Basic support for building and consuming XML-based web services within servlets.</td><td>Provides JAX-WS support, enabling the development and integration of XML-based web services within enterprise applications.</td></tr></tbody></table>

## **Types of Java Web Servers**

* **Tomcat:** Open-source, lightweight, and widely used. Ideal for smaller web applications and development environments.
* **Jetty:** Another open-source option, known for its embeddability within other applications. Well-suited for microservices architecture.
* **Undertow:** High-performance web server from Red Hat, offering scalability and efficiency for demanding workloads.
* **Resin:** Commercially supported, offers features like load balancing, clustering, and Java EE compliance.
