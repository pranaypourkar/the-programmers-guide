# Application Server

## About

An application server is a Java Virtual Machine (JVM) that runs user application. The application server collaborates with the web server to return a dynamic, customized response to a client request. The client request can consist of servlets, JavaServer Pages (JSP) files, and enterprise beans, and their supporting classes.&#x20;

{% hint style="info" %}
**About History**

* **Early days**: Initially, web servers handled both static and dynamic content. Common Gateway Interface (CGI) scripts were used for dynamic content.
* **Emergence of Application Servers**: As web applications grew more complex, dedicated application servers emerged in the late 1990s to handle dynamic content and business logic separately from web servers.
* **Modern Era**: Today, application servers support a wide range of technologies, including microservices and cloud-native applications.
{% endhint %}

{% hint style="info" %}
An application server or container is a component based product that resides in the middle-tier of a server centric architecture. It provides middleware services for security and state maintenance, along with data access and persistence. It acts as a middle layer between database servers and client machines, handling application logic, connectivity, and resource management.
{% endhint %}

For example, a user at a web browser visits a company website:

1. The user requests access to products data.
2. The user request flows to the web server.
3. The web server determines that the request involves an application containing resources not handled directly by the web server (such as servlets). It forwards the request to one of its application servers on which the application is running.
4. The invoked application then processes the user request. For example:
   * An application servlet prepares the user request for processing by an enterprise bean that performs the database access.
   * The application produces a dynamic web page containing the results of the user query.
5. The application server collaborates with the web server to return the results to the user at the web browser.
