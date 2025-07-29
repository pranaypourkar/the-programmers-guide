# Asynchronous Execution

## About

While `RestTemplate` itself is **synchronous by design**, it can be **used asynchronously** by **wrapping it with concurrency mechanisms** such as `CompletableFuture`, `ExecutorService`, or integrating with Spring’s `@Async` support.

This allows a system to make **non-blocking parallel HTTP calls**—improving **throughput**, **latency**, and **resource utilization**, especially in IO-bound service-to-service communication.

In modern microservices and cloud-native systems:

* Services often call **multiple downstream APIs**.
* Waiting sequentially for all responses can become a **performance bottleneck**.
* Asynchronous execution allows **concurrent invocations**, reducing **overall response time**.
* It enables use cases like **parallel data fetching**, **timeout-based fallbacks**, and **circuit breaker integration**.

## **1. Using CompletableFuture with Custom Executor**

This is the most popular pattern in enterprise applications for parallel execution.

```java
@Async("customExecutor")
public CompletableFuture<UserResponse> getUserAsync(String userId) {
    String url = "http://userservice/api/users/" + userId;
    UserResponse response = restTemplate.getForObject(url, UserResponse.class);
    return CompletableFuture.completedFuture(response);
}
```

We must annotate our class with `@EnableAsync` and define an executor:

```java
@Configuration
@EnableAsync
public class AsyncConfig {

    @Bean(name = "customExecutor")
    public Executor taskExecutor() {
        return new ThreadPoolTaskExecutorBuilder()
            .corePoolSize(10)
            .maxPoolSize(50)
            .queueCapacity(100)
            .threadNamePrefix("async-rest-")
            .build();
    }
}
```

Then use it:

```java
CompletableFuture<UserResponse> user1 = service.getUserAsync("123");
CompletableFuture<UserResponse> user2 = service.getUserAsync("456");

CompletableFuture.allOf(user1, user2).join();

UserResponse result1 = user1.get();
UserResponse result2 = user2.get();
```

## **2. Manual ExecutorService Wrapping**

For fine-grained control (without `@Async`), wrap the calls manually:

```java
ExecutorService executor = Executors.newFixedThreadPool(10);

Callable<UserResponse> task = () -> restTemplate.getForObject(url, UserResponse.class);
Future<UserResponse> future = executor.submit(task);
```

Use `invokeAll` to parallelize multiple calls.

## **3. Combining with Retry or Timeout Logic**

To prevent indefinite blocking:

```java
CompletableFuture<UserResponse> future = CompletableFuture
    .supplyAsync(() -> restTemplate.getForObject(url, UserResponse.class), executor)
    .orTimeout(3, TimeUnit.SECONDS)
    .exceptionally(ex -> {
        log.warn("Timeout or failure for user call", ex);
        return fallbackResponse();
    });
```
