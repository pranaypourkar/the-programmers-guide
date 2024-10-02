# Client-Side Load Balancing Example

## About

Client-side load balancing is a method where the load-balancing logic is executed on the client rather than a centralized load balancer.

## Netflix Ribbon

**Netflix Ribbon** is one of the popular libraries for implementing client-side load balancing in Java applications, often used in microservice architectures, particularly in conjunction with Spring Cloud.

### **What is Ribbon?**

Ribbon is a **client-side load balancer** that automatically distributes traffic across multiple service instances based on a configurable algorithm. Unlike traditional load balancers (such as HAProxy or NGINX), which reside between clients and servers, Ribbon allows clients to perform load balancing themselves by maintaining a list of server instances.

### How Ribbon Works?

Ribbon works by:

1. **Maintaining a list of available service instances**: Ribbon is responsible for keeping track of all the instances of a service, typically using service discovery mechanisms like **Eureka** or statically configured lists.
2. **Load Balancing Requests**: Each time a client makes a request, Ribbon selects an instance of the service based on a **load-balancing strategy** (e.g., round-robin, random, or weighted).
3. **Routing Requests to Instances**: Once Ribbon has selected a service instance, the client sends the request directly to that instance.

### Key Components of Ribbon

1. **ServerList**: Ribbon uses this to maintain a list of available servers (service instances). This can be dynamically populated using service discovery tools like Eureka, or it can be hardcoded.
2. **ILoadBalancer**: This interface defines the load balancer, which determines how to pick a server from the list of available instances. Ribbon provides default implementations, such as round-robin or random.
3. **Ping**: Ribbon can periodically check if instances are up or down by "pinging" them to ensure the health of the services. This ensures that requests are not sent to unhealthy instances.
4. **ServerListFilter**: This filters the available server list to exclude servers based on certain conditions (e.g., health status, region).
5. **IRule**: This defines the load-balancing strategy (or rule) that Ribbon uses to select a server. Some built-in strategies include:
   * **RoundRobinRule**: Distributes requests evenly across all available instances.
   * **RandomRule**: Chooses a random instance for each request.
   * **WeightedResponseTimeRule**: Chooses instances based on their response time, giving preference to faster instances.

### Example with Static Server List

Create a client service <mark style="background-color:purple;">maven project</mark> say `sample-project-ribbon` .

Add the following dependencies

```xml
    <properties>
        <spring-cloud-dependencies.version>2021.0.3</spring-cloud-dependencies.version>
    </properties>

    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-dependencies</artifactId>
                <version>${spring-cloud-dependencies.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>

    <dependencies>
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
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-ribbon</artifactId>
            <version>2.2.7.RELEASE</version>
        </dependency>
    </dependencies>
```

{% hint style="info" %}
In this example, parent pom version used as **2.7.11**

```xml
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>2.7.11</version>
    <relativePath/>
</parent>
```
{% endhint %}

Create RestTemplateConfig.java configuration class with below content

```java
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.cloud.client.loadbalancer.LoadBalanced;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

@Configuration
public class RestTemplateConfig {
    @Bean
    @LoadBalanced
    public RestTemplate restTemplate(RestTemplateBuilder builder) {
        return builder.build();
    }
}
```

Create RibbonConfig.java configuration class with below content

```java
import com.netflix.client.config.IClientConfig;
import com.netflix.loadbalancer.IPing;
import com.netflix.loadbalancer.IRule;
import com.netflix.loadbalancer.PingUrl;
import com.netflix.loadbalancer.WeightedResponseTimeRule;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;

@RequiredArgsConstructor
public class RibbonConfig {
    private final IClientConfig ribbonClientConfig;

    @Bean
    public IPing ribbonPing(IClientConfig config) {
        return new PingUrl();
    }

    @Bean
    public IRule ribbonRule(IClientConfig config) {
        return new WeightedResponseTimeRule();
    }
}
```

Create ClientController.java controller class having API call with load balanced ribbon host

```java
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@RequiredArgsConstructor
@RestController
public class ClientController {

    private final RestTemplate restTemplate;

    @GetMapping("/call-backend")
    public String callBackend() {
        // Use Ribbon-enabled RestTemplate to make a call to the backend
        // backend-server is configured in application properties
        String response = restTemplate.getForObject("http://backend-server/api/hello-world", String.class);
        return "Response from Backend: " + response;
    }
}
```

Create a main application class

```java
import org.example.config.RibbonConfig;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.ribbon.RibbonClient;

@RibbonClient(name = "backend-server-load-balancing", configuration = RibbonConfig.class)
@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
```

Create application.yaml properties file

```yaml
server:
  port: 8080

# Ribbon Configuration
backend-server:
  ribbon:
    eureka:
      enabled: false  #disable eureka registry as static list is being used
    listOfServers: backend1:8080,backend2:8080
```

Sample `Dockerfile` to create image for the above service

```docker
# Dockerfile
FROM openjdk:17-jdk-slim
COPY target/sample-project-ribbon-1.0-SNAPSHOT.jar /sample-project-ribbon-1.0-SNAPSHOT.jar
ENTRYPOINT ["java", "-jar", "/sample-project-ribbon-1.0-SNAPSHOT.jar"]
```

Now, build the service and create docker image

```
mvn clean install
docker build -t ribbon-backend-service .
```

Verify the generated docker image

<figure><img src="../../../../.gitbook/assets/image.png" alt="" width="563"><figcaption></figcaption></figure>

&#x20;

