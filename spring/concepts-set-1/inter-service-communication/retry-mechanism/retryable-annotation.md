# @Retryable annotation

## **1. What is Spring Retry?**

Spring Retry is a module that provides declarative retry support in Spring applications. It allows methods to be automatically re-invoked when they throw exceptions. Spring Retry provides a flexible API for retry policies, recovery logic, and handling exceptions.

_Spring Dependency to add_

```xml
 <dependency>
      <groupId>org.springframework.retry</groupId>
      <artifactId>spring-retry</artifactId>
 </dependency>
 <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-aspects</artifactId>
 </dependency>
```

{% hint style="info" %}
We need enable retry feature before we can use @Retryable

```java
// EnableRetry annotaion will enable spring boot retry pattern and then 
// only @Retryable annotation will work
@SpringBootApplication
@EnableRetry
public class MainApplication {
   public static void main(String[] args) {
    SpringApplication.run(RetryApplication.class, args);
   }
}
```
{% endhint %}

## **2. What is @Retryable?**

`@Retryable` is a declarative annotation provided by Spring Retry that can be applied to any method in a Spring-managed bean to automatically retry that method when an exception occurs. The annotation can be customized with several attributes to define the retry behavior, including:

* **backoff:** Defines the backoff policy for retries (delay and multiplier).
* **exceptionExpression:** A SpEL (Spring Expression Language) expression to determine if the retry should occur based on the exception thrown.
* **exclude and include:** Specifies the list of exceptions that will trigger retries. We can also define exceptions that will not trigger retries.
* **interceptor:** Define retry interceptors for custom retry logic. A retry interceptor is used to customize or extend the behavior of the retry process. It intercepts each retry attempt and can add custom logic.
* **label:** Define a label for better tracking.
* **stateful:** If true, retry state is tracked for each invocation. This is useful for stateful retries where we don’t want to retry if the method succeeded once. Stateful retries keep track of the state of the method being retried across multiple attempts, allowing the retry process to resume where it left off.
* **maxAttempts**: Defines how many times the operation should be retried before giving up.
* **maxAttemptsExpression:** A dynamic expression to calculate max attempts.
* **value:** The main exceptions that trigger retry logic.

{% hint style="info" %}
In order to use `@Retryable,`our method needs to called from outside of the class, because under the hood `@Retryable` makes use of spring's AOP which makes use of proxy to call retires on our target method.
{% endhint %}

{% hint style="success" %}
**Retry Policy:**

Retry policies define the logic of when to retry and how. Some common retry policies include:

* **Simple retry policy**: Retries a method a fixed number of times.
* **Exception classifier retry policy**: Retries based on different exceptions. Different retry behaviors can be applied for different exceptions.
* **Timeout retry policy**: Retries the method until a specific timeout period is reached.

By default, Spring Retry uses a simple retry policy with a max attempt of 3, but this can be customized.
{% endhint %}

{% hint style="success" %}
**Stateful vs Stateless Retry:**

* **Stateless retry**: Each method invocation is considered independent. If a method succeeds after retries, future invocations will still start from scratch.
  * Every retry starts fresh.
  * No memory of previous progress.
  * Useful for simple, non-idempotent tasks that need to restart fully on failure.
* **Stateful retry**: Keeps track of the state between method invocations. If the method already succeeded for a particular input, it won’t retry again for the same input. To use stateful retry, we need to set the `stateful` attribute to true.
  * Retries resume from where they left off.
  * Retains state across retry attempts.
  * Best for cases where progress must not be lost (e.g., partial success should not be redone).

The **stateful retry** mechanism in Spring only maintains state within the current application context or runtime session. If the application restarts (in-memory state is lost), the retry state is lost unless we implement a way to persist this state externally.&#x20;

Without persistence, stateful retries will not resume where they left off after a system restart. They will start the retry process from scratch, as if it’s the first attempt. To make stateful retries resilient to restarts, we would need to **persist retry state externally**, in a database or other persistent storage. This allows the application to resume the retry sequence even after a restart.
{% endhint %}

{% hint style="success" %}
**Backoff Strategies :**

* **Fixed backoff**: A constant delay between retries.

`@Retryable(maxAttempts = 3, backoff = @Backoff(delay = 2000))`

* **Exponential backoff**: The delay increases exponentially after each failure.

`@Retryable(maxAttempts = 5, backoff = @Backoff(delay = 1000, multiplier = 2))`
{% endhint %}

## **3. What is @`Recover`?**

If all retry attempts fail, Spring allows us to define a recovery method using the `@Recover` annotation. This method is invoked after all retries are exhausted, acting as a fallback mechanism.

```java
@Service
public class SampleService {

    @Retryable(
        value = { RemoteServiceNotAvailableException.class }, 
        maxAttempts = 3, 
        backoff = @Backoff(delay = 2000)
    )
    public String callExternalService() {
        // Call to external service
        throw new RemoteServiceNotAvailableException("Service unavailable.");
    }

    @Recover
    public String recover(RemoteServiceNotAvailableException e) {
        return "Service is currently unavailable. Please try again later.";
    }
}
```

## **4. What is** `RetryTemplate`?

`RetryTemplate` allows programmatic control over retry logic, making it suitable for complex applications where flexible, fine-grained retry handling is required as compared to the `@Retryable` annotation.

_RetryTemplateExample.java class_

```java
package org.example.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.retry.RetryPolicy;
import org.springframework.retry.backoff.ExponentialBackOffPolicy;
import org.springframework.retry.policy.ExceptionClassifierRetryPolicy;
import org.springframework.retry.policy.NeverRetryPolicy;
import org.springframework.retry.policy.SimpleRetryPolicy;
import org.springframework.retry.support.RetryTemplate;
import org.springframework.web.client.HttpClientErrorException;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@Configuration
public class RetryTemplateExample {

    @Bean
    public RetryTemplate createRetryTemplate() {
        RetryTemplate retryTemplate = new RetryTemplate();

        // Setting up Simple Retry Policy
        // SimpleRetryPolicy retryPolicy = new SimpleRetryPolicy();
        // retryPolicy.setMaxAttempts(3); // Max attempts for retries
        // retryTemplate.setRetryPolicy(retryPolicy);

        // Setting up ExceptionClassifierRetryPolicy Retry Policy
        ExceptionClassifierRetryPolicy policy = new ExceptionClassifierRetryPolicy();
        Map<Class<? extends Throwable>, RetryPolicy> policyMap = new HashMap<>();
        policyMap.put(HttpClientErrorException.class, new SimpleRetryPolicy(3));
        policyMap.put(IOException.class, new NeverRetryPolicy()); // No retry for IOException
        policy.setPolicyMap(policyMap);
        retryTemplate.setRetryPolicy(policy);

        // Setting up Backoff Policy
        ExponentialBackOffPolicy backOffPolicy = new ExponentialBackOffPolicy();
        backOffPolicy.setInitialInterval(500); // Initial wait time (milliseconds)
        backOffPolicy.setMultiplier(2); // Exponential factor
        backOffPolicy.setMaxInterval(5000); // Max wait time between retries
        retryTemplate.setBackOffPolicy(backOffPolicy);

        return retryTemplate;
    }
}
```

Usage of RetryTemplate in service class

```java
package org.example.service;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.retry.support.RetryTemplate;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;

@RequiredArgsConstructor
@Service
public class SampleService {
    private final RetryTemplate retryTemplate;

    public void processOrder(String orderId) {
        retryTemplate.execute(context -> {
            System.out.println("Attempt: " + (context.getRetryCount() + 1));

            // Simulated order processing
            attemptOrderProcessing(orderId);

            System.out.println("Order processed successfully.");
            return null;
        }, context -> {
            // Recovery logic if retries are exhausted
            System.out.println("Failed to process order after retries. Initiating recovery for order: " + orderId);
            return null;
        });
    }

    private void attemptOrderProcessing(String orderId) throws HttpClientErrorException {
        // Simulate failure
        throw new HttpClientErrorException(HttpStatus.SERVICE_UNAVAILABLE, "Temporary failure in processing order");
    }
}
```

Result Output

```
2024-11-05T12:37:33.148+05:30  INFO 8676 --- [nio-8080-exec-1] o.s.web.servlet.DispatcherServlet        : Completed initialization in 1 ms
Attempt: 1
Attempt: 2
Attempt: 3
Failed to process order after retries. Initiating recovery for order: 123456
```

## **5. Example**

### **Basic Usage of `@Retryable`**

```java
@Service
public class SampleService {

    // Retries occur when RemoteServiceNotAvailableException is thrown.
    // Maximum number of retry attempts is 3
    // Delay between retry attempts is 2000ms
    @Retryable(
        value = { RemoteServiceNotAvailableException.class }, 
        maxAttempts = 3, 
        backoff = @Backoff(delay = 2000)
    )
    public String callExternalService() {
        // Simulate call to external service
        if (Math.random() > 0.5) {
            return "Success";
        } else {
            throw new RemoteServiceNotAvailableException("Service unavailable.");
        }
    }
}
```

### **Stateful** vs **Stateless** Retries Example

Below are two examples that demonstrate the difference between **stateful** and **stateless** retries using a scenario where we process orders. The state of the retry in each case determines whether it remembers the current progress or starts fresh on each retry.

#### Stateful Retry

```java
package org.example.service;

import org.springframework.http.HttpStatus;
import org.springframework.retry.annotation.Retryable;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;

@Service
public class SampleService {
    private int attempt = 0;

    // Stateful retry example
    @Retryable(retryFor = { HttpClientErrorException.class }, maxAttempts = 3, stateful = true)
    public void processOrder(String orderId) throws HttpClientErrorException {
        attempt++;
        System.out.println("Stateful attempt " + attempt + " for order: " + orderId);

        // Simulating failure
        if (attempt < 3) {
            // Simulate partial progress and throw exception
            throw new HttpClientErrorException(HttpStatus.SERVICE_UNAVAILABLE, "Failed to process order!");
        }

        // Successful processing (only on the 3rd attempt)
        System.out.println("Order processed successfully on attempt " + attempt);
    }
}

```

Suppose a controller class calls the above service class method then

* Attempt 1 result output for the API call: Failure (but progress remembered)

```
2024-11-05T10:36:29.343+05:30  INFO 13924 --- [nio-8080-exec-1] o.s.web.servlet.DispatcherServlet        : Completed initialization in 0 ms
Stateful attempt 1 for order: 123456
2024-11-05T10:36:30.418+05:30 ERROR 13924 --- [nio-8080-exec-1] o.a.c.c.C.[.[.[/].[dispatcherServlet]    : Servlet.service() for servlet [dispatcherServlet] in context with path [] threw exception [Request processing failed: org.springframework.web.client.HttpClientErrorException: 503 Failed to process order!] with root cause

org.springframework.web.client.HttpClientErrorException: 503 Failed to process order!
	at org.example.service.SampleService.processOrder(SampleService.java:22) ~[classes/:na]
	at java.base/jdk.internal.reflect.DirectMethodHandleAccessor.invoke(DirectMethodHandleAccessor.java:103) ~[na:na]
	at java.base/java.lang.reflect.Method.invoke(Method.java:580) ~[na:na]
	at org.springframework.aop.support.AopUtils.invokeJoinpointUsingReflection(AopUtils.java:343) ~[spring-aop-6.0.18.jar:6.0.18]
	at org.springframework.aop.framework.ReflectiveMethodInvocation.invokeJoinpoint(ReflectiveMethodInvocation.java:196) ~[spring-aop-6.0.18.jar:6.0.18]
```

* Attempt 2 result output for the API call: Failure (progress still remembered)

```
Stateful attempt 2 for order: 123456
2024-11-05T10:37:07.015+05:30 ERROR 13924 --- [nio-8080-exec-5] o.a.c.c.C.[.[.[/].[dispatcherServlet]    : Servlet.service() for servlet [dispatcherServlet] in context with path [] threw exception [Request processing failed: org.springframework.web.client.HttpClientErrorException: 503 Failed to process order!] with root cause

org.springframework.web.client.HttpClientErrorException: 503 Failed to process order!
	at org.example.service.SampleService.processOrder(SampleService.java:22) ~[classes/:na]
	at java.base/jdk.internal.reflect.DirectMethodHandleAccessor.invoke(DirectMethodHandleAccessor.java:103) ~[na:na]
	at java.base/java.lang.reflect.Method.invoke(Method.java:580) ~[na:na]
	at org.springframework.aop.support.AopUtils.invokeJoinpointUsingReflection(AopUtils.java:343) ~[spring-aop-6.0.18.jar:6.0.18]
```

* Attempt 3 result output for the API call: Success (without redoing previous work)

```
Stateful attempt 3 for order: 123456
Order processed successfully on attempt 3
```

{% hint style="info" %}
* The retry state (`orderId`) ensures that the retry behavior applies specifically to the same `orderId`.
* If we were to call `processOrder` with a different `orderId`, it would treat it as a separate retry sequence and start fresh with `attempt` resetting to 1.
* `stateful = true` is effective for cases like this where it’s critical that retries apply uniquely to specific operations, ensuring that if there's partial progress, it remembers and avoids redundant processing.
{% endhint %}

#### Stateful Retry with Persistence (to cover application restart scenario)

```java
package org.example.service;

import org.example.repository.RetryStateRepository;
import org.springframework.http.HttpStatus;
import org.springframework.retry.RetryState;
import org.springframework.retry.annotation.Retryable;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;

@Service
public class SampleService {

    @Autowired
    private RetryStateRepository retryStateRepository; // Custom repository for storing retry states

    @Retryable(
        value = { HttpClientErrorException.class },
        maxAttempts = 3,
        stateful = true
    )
    public void processOrder(String orderId) throws HttpClientErrorException {
        int attempt = loadAttemptFromDB(orderId); // Load the last attempt count from DB
        attempt++;
        System.out.println("Stateful attempt " + attempt + " for order: " + orderId);

        // Simulating failure
        if (attempt < 3) {
            // Save the attempt count to DB before throwing an exception
            saveAttemptToDB(orderId, attempt);
            throw new HttpClientErrorException(HttpStatus.SERVICE_UNAVAILABLE, "Failed to process order!");
        }

        // Successful processing
        System.out.println("Order processed successfully on attempt " + attempt);
        clearRetryState(orderId); // Clear retry state on success
    }

    // Helper methods to interact with persistent storage
    private int loadAttemptFromDB(String orderId) {
        return retryStateRepository.findAttemptsByOrderId(orderId).orElse(0);
    }

    private void saveAttemptToDB(String orderId, int attempt) {
        retryStateRepository.save(new RetryState(orderId, attempt));
    }

    private void clearRetryState(String orderId) {
        retryStateRepository.deleteByOrderId(orderId);
    }
}
```

#### Stateless Retry

```java
package org.example.service;

import org.springframework.http.HttpStatus;
import org.springframework.retry.annotation.Retryable;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;

@Service
public class SampleService {
    private int attempt = 0;

    // Stateful retry example
    @Retryable(retryFor = { HttpClientErrorException.class }, maxAttempts = 3, stateful = false)
    public void processOrder(String orderId) throws HttpClientErrorException {
        attempt++;
        System.out.println("Stateless attempt " + attempt + " for order: " + orderId);

        // Simulating failure
        if (attempt < 3) {
            // Simulate partial progress and throw exception
            throw new HttpClientErrorException(HttpStatus.SERVICE_UNAVAILABLE, "Failed to process order!");
        }

        // Successful processing (only on the 3rd attempt)
        System.out.println("Order processed successfully on attempt " + attempt);
    }
}
```

Result output for the API call

```
2024-11-05T10:44:33.302+05:30  INFO 10048 --- [nio-8080-exec-2] o.a.c.c.C.[Tomcat].[localhost].[/]       : Initializing Spring DispatcherServlet 'dispatcherServlet'
2024-11-05T10:44:33.302+05:30  INFO 10048 --- [nio-8080-exec-2] o.s.web.servlet.DispatcherServlet        : Initializing Servlet 'dispatcherServlet'
2024-11-05T10:44:33.303+05:30  INFO 10048 --- [nio-8080-exec-2] o.s.web.servlet.DispatcherServlet        : Completed initialization in 0 ms
Stateless attempt 1 for order: 123456
Stateless attempt 2 for order: 123456
Stateless attempt 3 for order: 123456
Order processed successfully on attempt 3
```

## 6. Best Practices

1. **Retry Only for Transient Failures**: Ensure that we’re only retrying for transient failures (e.g., network issues, timeouts) and not for permanent errors (e.g., validation errors).
2. **Limit Retry Attempts**: Avoid indefinite retries. Always cap the number of retry attempts or use a timeout to prevent the application from being stuck in a retry loop.
3. **Backoff Strategy**: Use an exponential backoff strategy to reduce load on external services during failures.
4. **Recovery Fallbacks**: Always provide a recovery method for better user experience in case retries are exhausted.

