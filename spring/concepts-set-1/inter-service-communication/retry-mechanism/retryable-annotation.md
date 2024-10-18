# @Retryable annotation

**1. What is Spring Retry?**

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



**2. What is @Retryable?**

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

**Basic Usage of `@Retryable`**

```java
@Service
public class ExternalService {

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

{% hint style="success" %}
**Backoff Strategies :**

* **Fixed backoff**: A constant delay between retries.

`@Retryable(maxAttempts = 3, backoff = @Backoff(delay = 2000))`

* **Exponential backoff**: The delay increases exponentially after each failure.

`@Retryable(maxAttempts = 5, backoff = @Backoff(delay = 1000, multiplier = 2))`

\


**Stateful vs Stateless Retry:**

* **Stateless retry**: Each method invocation is considered independent. If a method succeeds after retries, future invocations will still start from scratch.
* **Stateful retry**: Keeps track of the state between method invocations. If the method already succeeded for a particular input, it won’t retry again for the same input. To use stateful retry, we need to set the `stateful` attribute to true.
{% endhint %}



**Recovery Method (`@Recover`)**

If all retry attempts fail, Spring allows us to define a recovery method using the `@Recover` annotation. This method is invoked after all retries are exhausted, acting as a fallback mechanism.

```java
@Service
public class ExternalService {

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



