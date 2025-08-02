# Use Case: Internal API Calls with Manual Clients

## About

This use case demonstrates how **one Spring Boot service (Service 1)** can invoke a **GET API exposed by another internal service (Service 2)** using **`WebClient`**, a modern, non-blocking HTTP client introduced in Spring 5.

## **Service 2**

Dependency

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

_<mark style="background-color:yellow;">**SampleController.java**</mark>_

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

_<mark style="background-color:yellow;">**application.yaml**</mark>_

```yaml
server:
  port: 8082
```

Build and run the application

## **Service 1**

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
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-webflux</artifactId>
</dependency>
```

_<mark style="background-color:yellow;">**SampleController.java**</mark>_

```java
package org.example.api;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.service.SampleService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

@Slf4j
@RequiredArgsConstructor
@RestController
public class SampleController {

    private final SampleService sampleService;

    @GetMapping("/api/service-1/details")
    public Mono<String> getInterServiceDetails() {
        return sampleService.fetchService2Details();
    }
}
```

_<mark style="background-color:yellow;">**WebClientConfig.java**</mark>_

```java
package org.example.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.web.reactive.function.client.WebClient;

@Configuration
public class WebClientConfig {
    @Bean
    public WebClient webClient() {
        return WebClient.builder()
                .baseUrl("http://localhost:8082") // Set the base URL for the requests
                .defaultCookie("cookie-name", "cookie-value") // Set a default cookie for the requests
                .defaultHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE) // Set a default header for the requests
                .build();
    }
}
```

_<mark style="background-color:yellow;">**SampleService.java**</mark>_

```java
package org.example.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

@Slf4j
@RequiredArgsConstructor
@Service
public class SampleService {

    private static final String SERVICE_2_ENDPOINT_PATH = "/api/service-2/details";

    private final WebClient webClient;

    // Method to retrieve service 2 details using a GET request
    public Mono<String> fetchService2Details() {
        log.info("Calling service 2 API via WebClient");

        return webClient.get()
                .uri(SERVICE_2_ENDPOINT_PATH)
                .retrieve()
                .bodyToMono(String.class)
                .doOnNext(data -> log.info("Received data from Service-2: {}", data)) // Do logging after receiving response
                .onErrorReturn("Failed to retrieve data from Service-2"); // Default error message
    }
}
```

_<mark style="background-color:yellow;">**application.yaml**</mark>_

```yaml
server:
  port: 8081

logging:
  level:
    org.springframework.web.reactive.function.client: DEBUG
    reactor.netty.http.client: DEBUG
```

Build and run the application

## **Verification**

**Execute the service 1 API via Postman**

<figure><img src="../../../../../../.gitbook/assets/image (174).png" alt=""><figcaption></figcaption></figure>

Monitor the logs (have a look at the threads executing the code)

<figure><img src="../../../../../../.gitbook/assets/image (176).png" alt=""><figcaption></figcaption></figure>

## Handling error based on Http status

#### Sample Code to Create an employee, Fetch all employees and handling error based on Http status

```java
package org.example.service;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClientResponseException;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@RequiredArgsConstructor
@Service
public class EmployeeService {

    private final WebClient webClient;

    public Flux<Employee> getAllEmployees() {

        return webClient.get()
                .uri("/employees")
                .retrieve()
                .onStatus(httpStatus -> !httpStatus.is2xxSuccessful(),
                        clientResponse -> handleErrorResponse(clientResponse.statusCode()))
                .bodyToFlux(Employee.class)
                .onErrorResume(Exception.class, e -> Flux.empty()); // Return an empty collection on error
    }

    public Mono<ResponseEntity<Employee>> createEmployee(Employee newEmployee) {

        return webClient.post()
                .uri("/employees")
                .body(Mono.just(newEmployee), Employee.class)
                .retrieve()
                .onStatus(HttpStatus::is4xxClientError, response -> {
                    //logError("Client error occurred");
                    return Mono.error(new WebClientResponseException
                            (response.statusCode().value(), "Bad Request", null, null, null));
                })
                .onStatus(HttpStatus::is5xxServerError, response -> {
                    //logError("Server error occurred");
                    return Mono.error(new WebClientResponseException
                            (response.statusCode().value(), "Server Error", null, null, null));
                })
                .toEntity(Employee.class);
    }

    private Mono<? extends Throwable> handleErrorResponse(HttpStatus statusCode) {
        // Handle non-success status codes
        return Mono.error(new EmployeeServiceException("Failed to fetch employee. Status code: " + statusCode));
    }
}
```
