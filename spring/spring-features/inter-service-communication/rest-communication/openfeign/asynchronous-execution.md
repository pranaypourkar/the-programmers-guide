# Asynchronous Execution

## About

Traditionally, HTTP clients like `RestTemplate` or basic Feign clients operate synchronously meaning the thread that initiates a remote call blocks and waits for the response. In high-traffic applications or APIs with long-running calls, this approach leads to **thread starvation**, reduced throughput, and inefficient resource usage.

OpenFeign addresses this by allowing asynchronous interaction through **`CompletableFuture`**, enabling **non-blocking invocation**. Instead of halting the current thread, our application can continue processing and receive the response once available.

This approach is not "reactive" in the true sense (like `WebClient` with `Reactor`) but **concurrent and future-based**, making it ideal for traditional Spring MVC applications looking to improve concurrency without switching to reactive stacks.

## **How It Works ?**

When we define a method in a Feign interface returning `CompletableFuture<T>`:

1. **Feign does not natively support async calls** (in older versions), so Spring Cloud Feign (or external libraries like `feign-async`) wrap the call in a task.
2. This task is then submitted to an **Executor** (typically Spring’s async executor).
3. The actual HTTP call still uses synchronous IO underneath unless we plug in a truly async HTTP client (like `AsyncHttpClient`).
4. Once the result is available, the future is completed, and downstream consumers can act on it.

## **Threading and Resource Considerations**

* We **must configure a proper executor** using `@EnableAsync` to ensure that threads are efficiently managed.
* Using `Executors.newFixedThreadPool()` or Spring’s `ThreadPoolTaskExecutor` allows better control over max concurrent requests, queue size, etc.
* **Overusing async calls without limits can exhaust thread pools** always monitor and profile thread usage in production.

## **OpenFeign Async vs Other Approaches**

<table data-full-width="true"><thead><tr><th width="165.671875">Feature</th><th>OpenFeign (Async)</th><th>Spring WebClient</th><th>Synchronous Feign</th></tr></thead><tbody><tr><td>Return type</td><td><code>CompletableFuture&#x3C;T></code></td><td><code>Mono&#x3C;T></code> / <code>Flux&#x3C;T></code></td><td><code>T</code></td></tr><tr><td>Blocking behavior</td><td>Non-blocking via thread</td><td>Truly non-blocking/reactive</td><td>Blocking</td></tr><tr><td>Reactive Streams support</td><td>No</td><td>Yes</td><td>No</td></tr><tr><td>Requires special executor</td><td>Yes</td><td>No</td><td>No</td></tr><tr><td>Suitable for MVC apps</td><td>Yes</td><td>Less Ideal (requires bridge)</td><td>Yes</td></tr><tr><td>Suitable for reactive apps</td><td>No</td><td>Yes</td><td>No</td></tr></tbody></table>

## Example

#### **1. Maven Dependency**

Make sure we include Feign and Spring Cloud dependencies in our `pom.xml`:

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-openfeign</artifactId>
</dependency>
```

#### **2. Enable Feign and Async Execution**

```java
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.scheduling.annotation.EnableAsync;

@SpringBootApplication
@EnableFeignClients
@EnableAsync
public class PaymentServiceApplication {
    public static void main(String[] args) {
        SpringApplication.run(PaymentServiceApplication.class, args);
    }
}
```

#### **3. Async Feign Client Interface**

```java
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.concurrent.CompletableFuture;

@FeignClient(name = "user-service", url = "http://localhost:8081")
public interface UserClient {

    @GetMapping("/api/users/{id}")
    CompletableFuture<UserDTO> getUserById(@PathVariable("id") Long id);
}
```

#### **4. DTO Class**

```java
public class UserDTO {
    private Long id;
    private String name;
    private String email;

    // Getters and setters
}
```

#### **5. Controller Layer**

```java
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.util.concurrent.CompletableFuture;

@RestController
public class TestController {

    private final UserClient userClient;

    public TestController(UserClient userClient) {
        this.userClient = userClient;
    }

    @GetMapping("/test/user/{id}")
    public CompletableFuture<String> getUserName(@PathVariable Long id) {
        return userClient.getUserById(id)
                .thenApply(user -> "User name: " + user.getName())
                .exceptionally(ex -> "Error: " + ex.getMessage());
    }
}
```

#### **6. Custom Async Executor (Recommended)**

```java
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.AsyncConfigurer;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

import java.util.concurrent.Executor;

@Configuration
public class AsyncConfig implements AsyncConfigurer {

    @Bean(name = "asyncExecutor")
    public Executor asyncExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(10);
        executor.setMaxPoolSize(50);
        executor.setQueueCapacity(100);
        executor.setThreadNamePrefix("async-feign-");
        executor.initialize();
        return executor;
    }
}
```
