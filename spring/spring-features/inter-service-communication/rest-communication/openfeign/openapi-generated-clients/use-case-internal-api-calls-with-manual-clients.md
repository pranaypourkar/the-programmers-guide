# Use Case: Internal API Calls with Manual Clients

## About

This use case demonstrates how **one Spring Boot service (Service 1)** can invoke a **GET API exposed by another internal service (Service 2)** using OpenFeign, a modern HTTP client introduced in Spring 5.



## Service 2

Dependency

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

SampleController.java

```java
package org.example.api;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class SampleController {

    @GetMapping("/api/service-2/details")
    public ResponseEntity<String> getInterServiceDetails() {
        return ResponseEntity.ok("Service 2 processed successfully");
    }
}
```

Application.java

```java
package org.example;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class Application {
    public static void main(String[] args) {
       SpringApplication.run(Application.class);
    }
}
```

application.yaml

```yaml
server:
  port: 8082
```

Build and run the application

## Service 1

Dependency

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

<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-openfeign</artifactId>
</dependency>
```

```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-dependencies</artifactId>
            <version>2021.0.5</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```

{% hint style="info" %}
Spring parent version used is given below

```xml
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>2.7.4</version>
    <relativePath/> <!-- lookup parent from repository -->
</parent>
```
{% endhint %}

_<mark style="background-color:yellow;">**SampleController.java**</mark>_

```java
package org.example.api;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.service.SampleService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RequiredArgsConstructor
@RestController
public class SampleController {

    private final SampleService sampleService;

    @GetMapping("/api/service-1/details")
    public String getInterServiceDetails() {
        return sampleService.processService2Details();
    }
}
```

_<mark style="background-color:yellow;">**Service2Client.java**</mark>_

```java
package org.example.config;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;

@FeignClient(name = "service2Client", url = "http://localhost:8082")
public interface Service2Client {

    @GetMapping("/api/service-2/details")
    String fetchService2Details();
}
```

_<mark style="background-color:yellow;">**SampleService.java**</mark>_

```java
package org.example.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.config.Service2Client;
import org.springframework.stereotype.Service;

@Slf4j
@RequiredArgsConstructor
@Service
public class SampleService {

    private final Service2Client service2Client;

    // Method to retrieve service 2 details using a GET request
    public String processService2Details() {
        log.info("Calling service 2 API via OpenFeign");
        return service2Client.fetchService2Details();
    }
}
```

Main _<mark style="background-color:yellow;">**Application.java**</mark>_

```java
package org.example;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;

@EnableFeignClients
@SpringBootApplication
public class Application {
    public static void main(String[] args) {
       SpringApplication.run(Application.class);
    }
}
```

_<mark style="background-color:yellow;">**application.yaml**</mark>_

```yaml
server:
  port: 8081
```

## Verification

Build and run the application

Run the service 1 API from Postman

<figure><img src="../../../../../../.gitbook/assets/image (266).png" alt=""><figcaption></figcaption></figure>

<figure><img src="../../../../../../.gitbook/assets/image (267).png" alt=""><figcaption><p>Service 1 logs</p></figcaption></figure>

## Enable Feign logs

To Enable Feign logging, add the below bean and update application.yaml property file.

_<mark style="background-color:yellow;">**FeignClientConfiguration.java**</mark>_

```java
package org.example.config;

import feign.Logger;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class FeignClientConfiguration {

    @Bean
    Logger.Level feignLoggerLevel() {
        return Logger.Level.FULL;
    }
}
```

_<mark style="background-color:yellow;">**application.yaml**</mark>_

```yaml
logging:
  level:
    org:
      example:
        config:
          Service2Client: DEBUG
```

Hit the API again via Postman and monitor the logs.

<figure><img src="../../../../../../.gitbook/assets/image (173).png" alt=""><figcaption></figcaption></figure>
