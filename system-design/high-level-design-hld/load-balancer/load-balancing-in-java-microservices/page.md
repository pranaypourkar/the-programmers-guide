# Server-Side Load Balancing Example

## About

In **server-side load balancing**, a central load balancer distributes incoming traffic across multiple backend servers to ensure that no single server is overwhelmed with requests.

## **NGINX**

One of the most widely used tools for server-side load balancing is **NGINX**. Unlike client-side load balancing (where the client makes decisions about which server to use), server-side load balancing occurs on a dedicated machine that sits between the client and the backend services.

### **What is NGINX?**

NGINX is a powerful open-source web server that also functions as a **reverse proxy**, **load balancer**, and **HTTP cache**. It is commonly used to manage incoming HTTP, TCP, and UDP traffic and distribute it efficiently across multiple backend servers.

### How Server-Side Load Balancing Works with NGINX?

When a client sends a request to a system using server-side load balancing, the request is first received by the load balancer (NGINX in this case). NGINX then selects a backend server (from a pool of servers) based on a predefined **load-balancing algorithm** and forwards the request to that server. Once the backend server processes the request, it sends the response back to NGINX, which in turn forwards it to the client.

### NGINX Load Balancing Architecture

* **Client**: Sends requests to the load balancer (NGINX).
* **NGINX (Load Balancer)**: Distributes incoming requests to one of the backend servers based on a load-balancing algorithm.
* **Backend Servers**: A pool of servers (e.g., API servers, web servers) that handle the actual processing of requests.

### Example

Let's create a sample service <mark style="background-color:purple;">maven project</mark> say `sample-project` with an client API endpoint.

Add the following dependencies in pom.xml file

```xml
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <version>1.18.30</version>
            <scope>provided</scope>
        </dependency>
```

{% hint style="info" %}
We may need to add spring-boot-maven-plugin to be able to generate jar file.

```xml
<plugin>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-maven-plugin</artifactId>
    <configuration>
        <mainClass>org.example.Application</mainClass>
        <layout>JAR</layout>
    </configuration>
</plugin>
```
{% endhint %}

Create a sample controller class with 1 endpoint

```java
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
class SampleController {
    @GetMapping("/api/hello-world")
    public String sayHelloWorld() {
        return "Hello world from " + System.getenv("SERVER_INSTANCE");
    }
}
```

{% hint style="info" %}
We may notice the use of SERVER\_INSTANCE variable. We will be setting it the docker compose file as a environment variable since we will need to create multiple instance (more than 1) of this service to test the load balancing feature.
{% endhint %}

Create a main application file

```java
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
```

application.yaml file

```yaml
server:
  port: 8080
```

Build the project to generate jar file (to be used later in docker compose file)

<figure><img src="../../../../.gitbook/assets/image (6).png" alt=""><figcaption></figcaption></figure>

{% hint style="info" %}
We will use the generated jar file directly in docker-compose instead of creating docker image for above service
{% endhint %}



Now, we need to setup NGINX.

Create a `nginx.conf` config file

```nginx
# Define a load-balancing group named 'backend'
upstream backend {
    # Backend server 1, running a Spring Boot app instance on port 8080
    server backend1:8080;
    # Backend server 2, running another Spring Boot app instance on port 8080
    server backend2:8080;
}

server {
    # Listen for incoming HTTP requests on port 90
    listen 90;

    # Define the default location block for handling requests specifically for /api path
    location /api/ {
        # Proxy pass - forwards the client requests to the 'backend' upstream group
        proxy_pass http://backend;

        # Preserve the original Host header from the client request
        proxy_set_header Host $host;

        # Pass the real IP address of the client to the backend server
        proxy_set_header X-Real-IP $remote_addr;

        # Include any prior X-Forwarded-For headers and append the client's IP address
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

        # Specify the protocol (HTTP or HTTPS) used by the client
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Create a docker file for nginx with above config file to create a nginx image

`Dockerfile`

```docker
# Use the official NGINX base image
FROM nginx:latest

# Remove the default configuration
RUN rm /etc/nginx/conf.d/default.conf

# Copy the custom NGINX configuration file
COPY nginx.conf /etc/nginx/conf.d/

# Expose the port that NGINX will run on
EXPOSE 90
```

{% hint style="info" %}
Note that config file is kept at the same place as Dockerfile and relative path is being used
{% endhint %}

Now, let us create docker image using above docker file

```
docker build -t nginx-load-balancer .
```



Now, we have the services ready. Let's create `docker-compose.yml` file

{% hint style="info" %}
We can keep this docker-compose file in root of sample-project since we need to provide relative path of jar file
{% endhint %}

```yaml
version: '3'

services:
  nginx:
    image: nginx-load-balancer
    ports:
      - "90:90"
    depends_on:
      - backend1
      - backend2

  backend1:
    image: openjdk:17-jdk-slim
    environment:
      - SERVER_INSTANCE=Backend1
    volumes:
      - ./target/sample-project-1.0-SNAPSHOT.jar:/app/sample-project-1.0-SNAPSHOT.jar  # Attach the pre-built JAR file
    working_dir: /app
    command: ["java", "-jar", "sample-project-1.0-SNAPSHOT.jar"]  # Run the JAR file directly
    ports:
      - "8081:8080"

  backend2:
    image: openjdk:17-jdk-slim
    environment:
      - SERVER_INSTANCE=Backend2
    volumes:
      - ./target/sample-project-1.0-SNAPSHOT.jar:/app/sample-project-1.0-SNAPSHOT.jar  # Attach the pre-built JAR file
    working_dir: /app
    command: ["java", "-jar", "sample-project-1.0-SNAPSHOT.jar"]  # Run the JAR file directly
    ports:
      - "8082:8080"

networks:
  shared-network:
    driver: bridge
```



Run the docker-compose file

<figure><img src="../../../../.gitbook/assets/image (3).png" alt="" width="371"><figcaption></figcaption></figure>

Call the API [http://localhost:90/api/hello-world](http://localhost:90/api/hello-world) multiple time to see load balancing effect

<figure><img src="../../../../.gitbook/assets/image (4).png" alt="" width="553"><figcaption></figcaption></figure>

<figure><img src="../../../../.gitbook/assets/image (5).png" alt="" width="455"><figcaption></figcaption></figure>

