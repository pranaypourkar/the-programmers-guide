# Application Server

## About

An application server is a Java Virtual Machine (JVM) that runs user application. The application server collaborates with the web server to return a dynamic, customized response to a client request. The client request can consist of servlets, JavaServer Pages (JSP) files, and enterprise beans, and their supporting classes.

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

## Architecture Diagram

Ref: [https://www.service-architecture.com/articles/application-servers/application-server-definition.html#](https://www.service-architecture.com/articles/application-servers/application-server-definition.html)

<figure><img src="../../.gitbook/assets/image (455).png" alt="" width="423"><figcaption></figcaption></figure>

### 1. **Client Tier**

**Description**: The client tier consists of the applications and browsers that interact with the server. This tier is responsible for sending requests to and receiving responses from the middle tier.

**Components**:

* **Applications**: Standalone applications or applets that interact with the J2EE platform through APIs.
* **Browsers**: Web browsers that access web applications hosted on the web server.

### 2. **Middle Tier**

**Description**: The middle tier is the core of the J2EE architecture. It hosts the business logic and manages communication between the client tier and the EIS tier. This tier includes the J2EE platform, which consists of the EJB server and web server.

**Components**:

* **J2EE Platform**: Provides the runtime environment and services for deploying and running enterprise applications.
  * **EJB Server**: Hosts Enterprise JavaBeans (EJBs), which encapsulate the business logic of the application. EJBs can handle transactions, security, and persistence.
  * **Web Server**: Manages web components such as servlets and JSPs, handling HTTP requests and generating dynamic web content.

### 3. **Enterprise Information System (EIS) Tier**

**Description**: The EIS tier includes the existing systems, databases, and applications that the J2EE platform interacts with. This tier handles data storage, retrieval, and integration with legacy systems.

**Components**:

* **Applications**: Legacy applications or other enterprise systems that provide business functionalities.
* **Database Servers**: Hosts databases that store persistent data used by the applications.
  * **Files**: Flat files or other non-database storage formats.
  * **Databases**: Relational or NoSQL databases that store structured data.

### **Connecting Components**

The diagram shows how different tiers are interconnected:

* **Client Tier to Middle Tier**: Applications and browsers communicate with the web server in the middle tier via HTTP/HTTPS or other protocols. Applications may also directly communicate with the EJB server using RMI/IIOP or similar protocols.
* **Middle Tier to EIS Tier**: The EJB server and web server in the middle tier interact with the database servers and applications in the EIS tier to perform business operations and manage data.

### **APIs**

The diagram indicates the presence of APIs at various points:

* **Client APIs**: Used by client applications to interact with the middle tier.
* **Web Server APIs**: Used by the web server to manage web components.
* **EJB Server APIs**: Used by the EJB server to manage enterprise beans and their interactions.

## Types of Java Application Servers

Java application servers provide a runtime environment for Java applications, managing resources, security, and transactions. They fall into several categories based on their features, intended use, and complexity.

{% hint style="info" %}
**Popular Application Servers**

**Apache Tomcat**:

* **Overview**: Open-source Java servlet container developed by the Apache Software Foundation.
* **Key Features**: Lightweight, efficient, robust community support.

**JBoss EAP**:

* **Overview**: Red Hat's enterprise application platform for Java EE applications.
* **Key Features**: Comprehensive enterprise features, clustering, and high availability.

**Oracle WebLogic**:

* **Overview**: Oracle's enterprise application server for developing and deploying Java EE applications.
* **Key Features**: Advanced clustering, high availability, and integration with Oracle products.

**Microsoft IIS**:

* **Overview**: Microsoft's web server that also functions as an application server for .NET applications.
* **Key Features**: Seamless integration with Windows Server, robust security features.
{% endhint %}

### 1. **Web Servers**

These are lightweight servers designed to handle HTTP requests and serve web content. They are ideal for simple web applications and static content but lack advanced enterprise features.

**Examples:**

* **Apache Tomcat**: A popular open-source web server that supports servlets and JavaServer Pages (JSP). It is widely used for lightweight web applications.
* **Jetty**: An open-source project providing a Java HTTP server and servlet container. It is known for being lightweight and embeddable.

### 2. **Servlet Containers**

Servlet containers provide a more advanced runtime environment for web applications, supporting servlets, JSP, and WebSocket technologies.

**Examples:**

* **Apache Tomcat**: Also functions as a servlet container.
* **Jetty**: Also functions as a servlet container.

### 3. **Full Java EE (Jakarta EE) Application Servers**

These servers implement the full Java EE specification, providing a complete set of services for enterprise applications, including EJBs, JPA, JMS, JAX-RS, and more. They are suitable for large-scale, complex applications requiring robust enterprise features.

**Examples:**

* **WildFly (formerly JBoss AS)**: A popular open-source application server that implements the full Java EE specification. It is known for its modular architecture and flexibility.
* **GlassFish**: An open-source application server sponsored by Eclipse Foundation. It serves as the reference implementation for Java EE.
* **IBM WebSphere**: A commercial application server from IBM, offering robust performance, scalability, and integration capabilities.
* **Oracle WebLogic**: A commercial application server from Oracle, known for its high performance, scalability, and support for advanced features like clustering and high availability.

### 4. **Lightweight Frameworks**

These frameworks provide lightweight containers that offer some features of full Java EE servers but are more modular and easier to configure.

**Examples:**

* **Spring Boot**: A framework that simplifies the creation of stand-alone, production-grade Spring-based applications. It includes an embedded server (Tomcat, Jetty, or Undertow) and is known for its ease of use and rapid development capabilities.
* **Dropwizard**: A Java framework for developing RESTful web services. It combines several well-known libraries into a simple, light-weight package, including Jetty for the HTTP server.

## Setting Up a Java Application Server

Setting up a Java application server involves several steps, including downloading and installing the server software, configuring the server, and deploying applications. The following guide outlines the general process, with specific examples for popular Java application servers like Apache Tomcat and WildFly.

### **Prerequisites**

* **Java Development Kit (JDK)**: Ensure you have the appropriate JDK installed on your system. Most application servers require JDK 8 or later.
* **Server Software**: Download the Java application server software (e.g., Apache Tomcat, WildFly).

### **Example: Apache Tomcat**

#### **Step 1: Download and Install Tomcat**

1. **Download Tomcat**: Go to the [Apache Tomcat website](https://tomcat.apache.org/) and download the latest stable release (e.g., Tomcat 9 or 10).
2.  **Extract the Archive**: Extract the downloaded archive to a directory of your choice.

    ```bash
    tar xzf apache-tomcat-9.0.x.tar.gz -C /opt
    ```
3.  **Set Environment Variables**: Set the `CATALINA_HOME` environment variable to point to the Tomcat installation directory.

    ```bash
    export CATALINA_HOME=/opt/apache-tomcat-9.0.x
    ```

#### **Step 2: Configure Tomcat**

1.  **Server Configuration**: Modify the `server.xml` file located in the `conf` directory to configure ports, connectors, and other server settings.

    ```xml
    <Connector port="8080" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443" />
    ```
2. **Web Application Deployment**: Place your WAR files in the `webapps` directory for automatic deployment. Alternatively, you can configure context files in the `conf/Catalina/localhost` directory.
3.  **User Authentication**: Configure user roles and credentials in the `tomcat-users.xml` file for accessing the management console.

    ```xml
    <role rolename="manager-gui"/>
    <user username="admin" password="password" roles="manager-gui"/>
    ```

#### **Step 3: Start Tomcat**

1.  **Start the Server**: Run the startup script to start Tomcat.

    ```bash
    $CATALINA_HOME/bin/startup.sh
    ```
2. **Access the Server**: Open a web browser and navigate to `http://localhost:8080` to verify that Tomcat is running.

#### **Step 4: Deploy Applications**

1. **Manual Deployment**: Copy WAR files to the `webapps` directory.
2. **Management Console**: Use the Tomcat Manager App to deploy, undeploy, and manage applications.

### **Example:** Standalone Spring Boot Application

#### **Step 1: Create a Spring Boot Project**

We can create a Spring Boot project using the Spring Initializr or manually by setting up a Maven/Gradle project.

#### Step 2: Write the main source code logic

Write the main Application.java class logic and other API logic

#### **Step 3: Configure the Application**

Spring Boot uses a `application.properties` or `application.yml` file for configuration.

1.  **Create Configuration File**: Create an `application.properties` or `application.yml` file in the `src/main/resources` directory.

    ```properties
    # src/main/resources/application.properties
    server.port=8080
    spring.datasource.url=jdbc:mysql://localhost:3306/mydb
    spring.datasource.username=root
    spring.datasource.password=secret
    ```

#### **Step 4: Build and Run the Application**

1.  **Build the Project**: Use Maven or Gradle to build the project.

    ```bash
    mvn clean package
    ```
2.  **Run the Application**: Run the application using the embedded server.

    ```bash
    java -jar target/my-spring-boot-app-0.0.1-SNAPSHOT.jar
    ```

**Step 5: Deploy the Application**

Spring Boot applications can be deployed in several ways:

1. **Standalone JAR**: The built JAR file can be run directly using `java -jar`.
2.  **Docker**: Create a Docker image for your application.

    ```dockerfile
    # Dockerfile
    FROM openjdk:11-jre-slim
    COPY target/my-spring-boot-app-0.0.1-SNAPSHOT.jar /app.jar
    ENTRYPOINT ["java", "-jar", "/app.jar"]
    ```

    ```bash
    docker build -t my-spring-boot-app .
    docker run -p 8080:8080 my-spring-boot-app
    ```
3. **Cloud Platforms**: Deploy to cloud platforms like AWS, Azure, or Google Cloud using their respective services.
4. **Traditional Servers**: Deploy as a WAR file to a traditional application server like Tomcat or WildFly.

## Application Server Configuration

Configuration of a Java application server involves setting up various parameters and components to optimize performance, security, and resource management. Here are common configuration tasks and examples:

### **1. Server Settings**

* **Ports**: Configure the HTTP and HTTPS ports in the server configuration files (e.g., `server.xml` for Tomcat, `standalone.xml` for WildFly, `application.properties` for springboot app).

```properties
server.port=8080
server.ssl.enabled=true
server.ssl.key-store=classpath:keystore.p12
server.ssl.key-store-password=changeit
```

*   **Thread Pools**: Adjust the thread pool settings to manage concurrency and optimize resource utilization.

    ```xml
    <Executor name="tomcatThreadPool" namePrefix="catalina-exec-"
              maxThreads="150" minSpareThreads="4"/>
    ```

### **2. Security**

*   **SSL/TLS**: Configure SSL/TLS for secure communication by specifying the keystore and truststore files.

    ```xml
    <Connector port="8443" protocol="org.apache.coyote.http11.Http11NioProtocol"
               maxThreads="150" SSLEnabled="true" scheme="https" secure="true"
               clientAuth="false" sslProtocol="TLS"
               keystoreFile="conf/keystore.jks" keystorePass="changeit"/>
    ```
*   **Authentication and Authorization**: Define security realms, user roles, and access permissions.

    ```xml
    <security-realm name="ApplicationRealm">
        <authentication>
            <local default-user="$local" allowed-users="*"/>
        </authentication>
    </security-realm>
    ```

```properties
spring.security.user.name=admin
spring.security.user.password=secret
```

### **3. Resource Management**

*   **Data Sources**: Configure JDBC data sources for database connectivity.

    ```xml
    <datasource jndi-name="java:/jdbc/MyDS" pool-name="MyDS"
                enabled="true" use-java-context="true" statistics-enabled="true">
        <connection-url>jdbc:mysql://localhost:3306/mydb</connection-url>
        <driver>mysql</driver>
        <security>
            <user-name>dbuser</user-name>
            <password>dbpass</password>
        </security>
    </datasource>
    ```

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/mydb
spring.datasource.username=root
spring.datasource.password=secret
```

*   **JNDI**: Configure JNDI resources for resource lookup and binding.

    ```xml
    xmlCopy code<Environment name="maxExemptions" value="5" type="java.lang.Integer" override="false"/>
    ```

### **4. Logging**

*   **Log Configuration**: Set up logging levels, appenders, and log file rotation.

    ```xml
    <Console name="CONSOLE" target="SYSTEM_OUT">
        <PatternLayout pattern="%d{HH:mm:ss.SSS} [%t] %-5level %logger{36} - %msg%n"/>
    </Console>

    <File name="FILE" fileName="${jboss.server.log.dir}/server.log">
        <PatternLayout>
            <pattern>%d{yyyy-MM-dd HH:mm:ss,SSS} %-5p [%c] (%t) %s%E%n</pattern>
        </PatternLayout>
    </File>
    ```

```properties
logging.level.org.springframework=INFO
logging.level.com.example.myapp=DEBUG
logging.file.name=logs/app.log
```

### **5. Clustering and Load Balancing**

* **Cluster Configuration**: Set up clustering for high availability and load balancing.

### **6. Performance Tuning**

*   **JVM Options**: Configure JVM options for optimal performance, memory management, and garbage collection.

    ```bash
    export JAVA_OPTS="-Xms512m -Xmx2048m -XX:+UseG1GC -XX:MaxGCPauseMillis=200"
    ```
*   **Caching**: Set up caching mechanisms to improve application performance.

    ```xml
    <cache-container name="web" default-cache="default">
        <local-cache name="default"/>
    </cache-container>
    ```

### **7. Monitoring and Management**

*   **JMX**: Enable JMX for monitoring and management of server resources.

    ```xml
    <mbean-server>
        <jmx-domain>jboss.as</jmx-domain>
        <enabled>true</enabled>
    </mbean-server>
    ```
*   **Health Checks**: Configure health checks to monitor the server's health and availability.

    ```xml
    <subsystem xmlns="urn:jboss:domain:health:1.0">
        <health>
            <check name="heap" enabled="true" interval="10" path="/health/heap"/>
        </health>
    </subsystem>
    ```

## Different Ways to deploy java source code in Application server

There are several ways to deploy Java source code in an application server, each suitable for different environments and requirements.

### 1. **Manual Deployment**

**Steps:**

1. **Build the Application**: Use build tools like Maven or Gradle to compile the source code and package it into a deployable artifact (JAR, WAR, or EAR file).
2. **Transfer the Artifact**: Manually copy the deployable artifact to the application server.
3. **Deploy the Artifact**: Use the application server's management console or command-line tools to deploy the artifact.

**Pros:**

* Simple and straightforward.
* No need for complex setup.

**Cons:**

* Error-prone due to manual steps.
* Not scalable for large teams or frequent deployments.

### 2. **Automated Deployment with CI/CD**

**Steps:**

1. **Continuous Integration (CI)**: Set up a CI server (e.g., Jenkins, GitLab CI) to automatically build, test, and package the application whenever changes are pushed to the version control system.
2. **Continuous Deployment (CD)**: Configure the CI server to automatically deploy the packaged artifact to the application server.

**Tools:**

* **Jenkins**: For building and deploying Java applications.
* **GitLab CI**: Integrated CI/CD pipelines.
* **Travis CI**: Continuous integration service for building and testing code.

**Pros:**

* Reduces human error.
* Scalable and efficient for frequent deployments.
* Provides a repeatable and consistent process.

**Cons:**

* Requires initial setup and configuration.
* Might need integration with other tools and services.

### 3. **Deployment Using Docker**

**Steps:**

1. **Dockerize the Application**: Create a Dockerfile that specifies the application's runtime environment and dependencies.
2. **Build Docker Image**: Use Docker to build an image from the Dockerfile.
3. **Push to Registry**: Push the Docker image to a container registry (e.g., Docker Hub, Amazon ECR).
4. **Deploy to Application Server**: Use orchestration tools like Kubernetes or Docker Swarm to deploy the Docker container to the application server.

**Tools:**

* **Docker**: For containerizing the application.
* **Kubernetes**: For orchestrating and managing containerized applications.
* **Docker Swarm**: For simple container orchestration.

**Pros:**

* Ensures consistent runtime environment.
* Simplifies dependency management.
* Facilitates horizontal scaling and orchestration.

**Cons:**

* Requires understanding of containerization.
* Additional overhead of managing containers and orchestration tools.

### 4. **Using Application Server Specific Tools**

**Examples:**

* **Apache Tomcat**: Use the Tomcat Manager App to deploy WAR files.
* **WildFly (formerly JBoss)**: Use the CLI or web management console to deploy applications.
* **WebSphere**: Use the Integrated Solutions Console or wsadmin scripting tool.
* **GlassFish**: Use the admin console or asadmin command-line tool.

**Steps:**

1. **Package the Application**: Use build tools to create the deployable artifact.
2. **Deploy Using Tools**: Use the application server's specific deployment tools to deploy the artifact.

**Pros:**

* Tailored to the specific application server.
* Can leverage server-specific features and optimizations.

**Cons:**

* Learning curve for different tools.
* Not portable across different application servers.

### 5. **Cloud-based Deployment**

**Steps:**

1. **Package the Application**: Use build tools to create the deployable artifact.
2. **Deploy to Cloud**: Use cloud services like AWS Elastic Beanstalk, Google App Engine, or Azure App Services to deploy the application.

**Tools:**

* **AWS Elastic Beanstalk**: Managed service for deploying and scaling web applications.
* **Google App Engine**: Platform-as-a-Service (PaaS) for building scalable applications.
* **Azure App Services**: PaaS for building, deploying, and scaling web apps.

**Pros:**

* Simplifies infrastructure management.
* Scales automatically based on demand.
* Integrated monitoring and logging.

**Cons:**

* Can be more expensive than on-premise solutions.
* Requires knowledge of cloud services and configurations.

## Application Server Management and Monitoring

### **Management Tools**

* **Admin Consoles**: Web-based interfaces for configuration, deployment, and management.
* **CLI Tools**: Command-line interfaces for advanced management and scripting.

### **Monitoring Tools**

* **Built-in Monitoring**: Java Management Extensions (JMX), Windows Performance Monitor.
* **Third-Party Tools**: New Relic, Dynatrace, Prometheus, Grafana.

### **Key Metrics to Monitor**

* **Resource Utilization**: CPU, memory, disk I/O.
* **Application Performance**: Response times, throughput.
* **Error Rates**: Application errors, failed transactions.

## Security in Application Servers

### **Authentication and Authorization**

* Implement role-based access control (RBAC).
* Integrate with LDAP, OAuth2, and other identity providers.

### **Data Protection**

* Use SSL/TLS for data encryption.
* Implement secure cookie handling and data validation.

### **Vulnerability Management**

* Regularly patch and update servers.
* Use security scanning tools (e.g., OWASP ZAP, Nessus).

### **Security Best Practices**

* Principle of least privilege: Grant minimal necessary permissions.
* Regular security audits and penetration testing.

## Performance Optimization

### **JVM Tuning**

* Optimize garbage collection settings.
* Configure heap and non-heap memory settings.

### **Caching**

* Implement in-memory caches (e.g., Ehcache, Redis).
* Use HTTP caching strategies to reduce load.

### **Load Balancing and Clustering**

* Implement horizontal scaling with load balancers (e.g., NGINX, HAProxy).
* Use clustering to ensure high availability and fault tolerance.

### **Performance Testing**

* Use tools like Apache JMeter, Gatling to simulate load and identify bottlenecks.
* Continuously monitor and optimize based on performance data.
