# Configuration

## About

In a Spring Boot application, OpenFeign clients are **auto-configured** by default when using the `spring-cloud-starter-openfeign` dependency. However, enterprise-grade applications often need **fine-grained control** over aspects like:

* Connection timeouts
* Logging level
* Interceptors (headers, authentication)
* Retry mechanisms
* Custom encoders/decoders

To enable such control, Spring allows **custom configuration classes**, either globally or per client.

## **Types of Configuration**

<table><thead><tr><th width="291.87109375">Configuration Scope</th><th>Description</th></tr></thead><tbody><tr><td><strong>Global Configuration</strong></td><td>Applies to all Feign clients in the application</td></tr><tr><td><strong>Per-Client Configuration</strong></td><td>Applies only to a specific Feign client using <code>@FeignClient(configuration = ...)</code></td></tr></tbody></table>

## Global Configuration

**Global configuration** in OpenFeign refers to settings that apply **across all Feign clients** in your Spring Boot application. This is especially useful when:

* You want a **standard behavior** across microservices.
* You don't want to repeat configurations for each Feign client.
* You’re handling common concerns like timeouts, retries, logging, etc.

Instead of configuring each client separately, you define a **default configuration block** in `application.yml` or `application.properties`.

Spring Cloud OpenFeign reads the global configuration from the `feign.client.config.default` section. It uses this block to **initialize every client**, unless a specific override is defined for that client.

**Example: application.yml**

```yaml
feign:
  client:
    config:
      default:
        connect-timeout: 5000         # in milliseconds
        read-timeout: 10000
        loggerLevel: full             # NONE, BASIC, HEADERS, FULL
        retryer:
          period: 100                 # initial retry interval
          maxPeriod: 1000             # max retry interval
          maxAttempts: 3              # max retry attempts
```

If we name a client (like `account-service`), that block overrides the default:

```yaml
yamlCopyEditfeign:
  client:
    config:
      default:
        connect-timeout: 3000
        read-timeout: 7000
        loggerLevel: basic
      account-service:
        read-timeout: 15000
```

### **Available Global Settings**

<table><thead><tr><th width="225.66796875">Property</th><th>Description</th></tr></thead><tbody><tr><td><code>connect-timeout</code></td><td>Timeout for establishing connection (ms)</td></tr><tr><td><code>read-timeout</code></td><td>Timeout for waiting for response (ms)</td></tr><tr><td><code>loggerLevel</code></td><td>Log verbosity: <code>NONE</code>, <code>BASIC</code>, <code>HEADERS</code>, or <code>FULL</code></td></tr><tr><td><code>retryer.period</code></td><td>Base interval between retries</td></tr><tr><td><code>retryer.maxPeriod</code></td><td>Maximum wait time between retries</td></tr><tr><td><code>retryer.maxAttempts</code></td><td>Max number of retry attempts</td></tr><tr><td><code>errorDecoder</code></td><td>Fully qualified class name of custom error decoder</td></tr><tr><td><code>requestInterceptors</code></td><td>List of fully qualified interceptor class names</td></tr><tr><td><code>decoder</code> / <code>encoder</code></td><td>Custom decoder or encoder bean class names (if overriding globally)</td></tr></tbody></table>

## Per-Client Configuration

**Per-client configuration** in OpenFeign allows you to define custom settings for **individual Feign clients**, giving you **fine-grained control** over how each client behaves.

This is useful when certain services:

* Have **different timeout requirements**
* Need **specific headers or interceptors**
* Require **unique retry policies**
* Should use a different **encoder, decoder, or error handler**

Rather than applying a one-size-fits-all setup (like in global config), you tailor each client based on its **communication pattern, SLAs, or external API behavior**.

### **How It Works ?**

OpenFeign allows us to configure each client separately in our `application.yml` or `application.properties`, using the name of the client defined in `@FeignClient(name = "...")`.

We can also attach a **Java config class** using the `configuration` attribute of `@FeignClient`.

### **Configuration in application.yml**

```yaml
feign:
  client:
    config:
      account-service:
        connect-timeout: 2000
        read-timeout: 6000
        loggerLevel: full
        retryer:
          maxAttempts: 3
          period: 100
          maxPeriod: 500
      payment-service:
        connect-timeout: 4000
        read-timeout: 10000
        loggerLevel: basic
```

This ensures:

* `account-service` is faster and retries quickly.
* `payment-service` allows for longer response times and lower log verbosity.

### **Using Java Configuration Class**

We can create a dedicated configuration class:

```java
@Configuration
public class AccountClientConfig {

    @Bean
    public Logger.Level feignLoggerLevel() {
        return Logger.Level.FULL;
    }

    @Bean
    public Retryer customRetryer() {
        return new Retryer.Default(100, 1000, 3);
    }

    @Bean
    public RequestInterceptor customHeaderInterceptor() {
        return requestTemplate -> requestTemplate.header("X-Custom-Header", "AccountClient");
    }
}
```

And link it like this:

```java
@FeignClient(
  name = "account-service",
  url = "http://localhost:8081",
  configuration = AccountClientConfig.class
)
public interface AccountClient {
    @GetMapping("/accounts/{id}")
    Account getAccount(@PathVariable String id);
}
```

### **Available Settings**

<table><thead><tr><th width="236.41796875">Setting</th><th>Where to Use</th></tr></thead><tbody><tr><td><code>connect-timeout</code></td><td><code>application.yml/properties</code></td></tr><tr><td><code>read-timeout</code></td><td>Same as above</td></tr><tr><td><code>loggerLevel</code></td><td><code>application.yml</code> or Java config class</td></tr><tr><td><code>retryer</code></td><td>Java config class or YAML block</td></tr><tr><td><code>errorDecoder</code></td><td>Java class implementing <code>ErrorDecoder</code></td></tr><tr><td><code>requestInterceptors</code></td><td>One or more <code>RequestInterceptor</code> beans</td></tr><tr><td><code>encoder</code> / <code>decoder</code></td><td>Custom classes to override default behavior</td></tr></tbody></table>

