# Web Server

## About

A web server is a software component that delivers static data like images, files, and text in response to client requests. Whereas, an application server adds business logic to compute the web server's response. Web server contains only web or servlet container. It can be used for servlet, jsp, struts, jsf etc. It can't be used for EJB.

&#x20;For example, browser and web server communicate as follows:

1. The browser uses the URL to find the server’s IP address
2. The browser sends an HTTP request for information
3. The web server communicates with a database server to find the relevant data
4. The web server returns static content such as HTML pages, images, videos, or files in an HTTP response to the browser
5. The browser then displays the information

## Can Web Server handle dynamic content?

Modern web servers can handle dynamic content to some extent, but their primary role traditionally revolves around serving static content.

1. **Static vs Dynamic Content**: Web servers like Apache HTTP Server or Nginx are designed to efficiently serve static content such as HTML files, images, CSS, and JavaScript files. This content doesn't change based on user requests and can be served directly from disk.
2. **Dynamic Content Handling**: While web servers themselves focus on static content, they can integrate with application servers or runtime environments (like servlet containers such as Apache Tomcat or application servers like WildFly) to handle dynamic content. These application servers execute server-side programs (e.g., Java servlets, PHP scripts) to generate dynamic responses based on user input, database queries, or other computations.
3. **Reverse Proxy and Load Balancing**: Web servers can also act as reverse proxies or load balancers, forwarding requests to multiple application servers based on various criteria (like load balancing algorithms or URL patterns). This setup allows web servers to distribute dynamic content generation tasks efficiently among multiple backend servers.
4. **Performance Considerations**: While web servers can handle dynamic content through integration with application servers or via reverse proxy setups, the performance and scalability of handling dynamic content may benefit from using specialized application servers designed for such tasks.

## Architecture Diagram

<figure><img src="broken-reference" alt="" width="563"><figcaption></figcaption></figure>

**Components Explained**

1. **Client**: This could be a web browser or any other client application that initiates HTTP requests to the web server.
2. **Web Server**: Handles incoming HTTP requests from clients. It serves static content directly (like HTML pages, images) and may delegate dynamic content requests to the application server.
3. **Application Server**: Executes server-side programs or scripts (such as servlets, JSPs, PHP scripts) to generate dynamic content based on the client's request. It interacts with databases or other backend services to process data and business logic.

**Interaction Flow**

* **Client to Web Server**: The client initiates an HTTP request (e.g., GET /index.html) to the web server.
* **Web Server**: The web server receives the request and checks if the requested resource is static (like HTML, images). If it's static, the web server directly serves it back to the client. If the request requires dynamic content (e.g., data from a database), the web server forwards the request to the application server.
* **Application Server**: Upon receiving a request from the web server, the application server executes server-side programs to generate the dynamic content. This could involve querying databases, performing calculations, or executing business logic.
* **Response to Web Server**: Once the application server has generated the dynamic content, it sends the response back to the web server.
* **Web Server to Client**: Finally, the web server forwards the dynamic content received from the application server as an HTTP response back to the client.



