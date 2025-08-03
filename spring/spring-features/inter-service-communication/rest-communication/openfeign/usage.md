# Usage

## About

Feign is a declarative HTTP client that allows developers to write clean, type-safe interfaces to call remote HTTP services in a Spring-based application. Rather than writing boilerplate code for HTTP requests, Feign enables us to define Java interfaces annotated with Spring MVC annotations (`@GetMapping`, `@PostMapping`, etc.), and it takes care of the rest.

This is especially useful in microservices where services frequently communicate over REST. It promotes better abstraction, reusability, and readability.

## Dependency

To use Feign in a Spring Boot application, add the following dependency:

If we’re using Spring Cloud OpenFeign:

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-openfeign</artifactId>
</dependency>
```

Also, make sure to include the appropriate Spring Cloud BOM in our `dependencyManagement`:

```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-dependencies</artifactId>
            <version>2023.0.1</version> <!-- Replace the version -->
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```

### **Compatibility**

<table><thead><tr><th width="172.4765625">Feature</th><th>Compatibility</th></tr></thead><tbody><tr><td>Spring Boot</td><td>Fully compatible with Spring Boot 2.x and 3.x</td></tr><tr><td>Spring Cloud</td><td>Required. Feign is integrated via Spring Cloud OpenFeign</td></tr><tr><td>Spring WebMVC</td><td>Native support using Spring MVC-style annotations</td></tr><tr><td>WebFlux</td><td>Not recommended. Feign is blocking and not reactive</td></tr><tr><td>OpenAPI</td><td>Not directly integrated. OpenAPI-generated clients are better suited for spec-first development</td></tr></tbody></table>

## Declarative API <a href="#declarative-and-fluent-api" id="declarative-and-fluent-api"></a>

OpenFeign follows a **declarative programming model** we define what the client interface should look like, and the library generates the HTTP call logic at runtime. Unlike RestTemplate or WebClient, we don't explicitly construct HTTP requests in a fluent chain. Instead, we declare how to reach a service using Java interfaces and annotations.

This approach leads to cleaner, more concise, and maintainable code — especially in large enterprise applications where service-to-service communication is frequent.

### **Declarative API Style**

Declarative means we describe the desired behavior (the _what_), not the process (the _how_). With Feign, the focus is on **interface-first programming**.

```java
@FeignClient(name = "user-service", url = "http://localhost:8081")
public interface UserClient {

    @GetMapping("/api/users/{id}")
    UserDto getUser(@PathVariable("id") Long id);

    @PostMapping("/api/users")
    UserDto createUser(@RequestBody UserDto user);
}
```

We are not writing the logic to build the request, set headers, parse the response, or handle connection issues Feign generates that code based on annotations.

### **How It Differs from Fluent API (e.g., WebClient)**

<table data-full-width="true"><thead><tr><th width="184.22265625">Aspect</th><th>Declarative (Feign)</th><th>Fluent (WebClient)</th></tr></thead><tbody><tr><td>Programming Style</td><td>Interface-based with annotations</td><td>Code-based chain of method calls</td></tr><tr><td>HTTP Verb Configuration</td><td>Annotated on method (<code>@GetMapping</code>, <code>@PostMapping</code>, etc.)</td><td>Explicitly called (<code>.get()</code>, <code>.post()</code> etc.)</td></tr><tr><td>URL &#x26; Path</td><td>Declared in interface and method-level mapping</td><td>Built using <code>.uri(...)</code> and path/query params</td></tr><tr><td>Headers, Cookies</td><td>Declared via annotations or interceptors</td><td>Set dynamically in the fluent chain</td></tr><tr><td>Control Flow</td><td>Abstracted away</td><td>Developer fully controls request/response logic</td></tr><tr><td>Type Safety</td><td>Strong — compile-time checks via interface</td><td>Moderate — dynamic object mapping via lambdas</td></tr><tr><td>Common Use</td><td>Simpler synchronous REST clients</td><td>Advanced or reactive usage (streaming, backpressure, etc.)</td></tr></tbody></table>

## Creating a OpenFeign Instance <a href="#creating-a-webclient-instance" id="creating-a-webclient-instance"></a>

In OpenFeign, we don’t create an instance manually like we would with WebClient or RestTemplate. Instead, we **define an interface**, annotate it with `@FeignClient`, and Spring Boot (via Spring Cloud OpenFeign) **automatically generates the implementation at runtime** and registers it as a Spring bean.

This promotes clean separation of concerns and allows us to inject the client wherever needed just like any other Spring-managed dependency.

**How It Works ?**

To create and use a Feign client:

1. Define an interface
2. Annotate with `@FeignClient`
3. Use Spring’s dependency injection to autowire the client

#### **Example**

**Step 1: Enable Feign Support**

```java
@SpringBootApplication
@EnableFeignClients
public class PaymentServiceApplication {
    public static void main(String[] args) {
        SpringApplication.run(PaymentServiceApplication.class, args);
    }
}
```

**Step 2: Define the Feign Client Interface**

```java
@FeignClient(name = "account-service", url = "http://localhost:8081")
public interface AccountClient {

    @GetMapping("/api/accounts/{id}")
    AccountDto getAccountById(@PathVariable("id") Long id);
}
```

**Step 3: Use the Client in a Service**

```java
@Service
public class PaymentService {

    private final AccountClient accountClient;

    public PaymentService(AccountClient accountClient) {
        this.accountClient = accountClient;
    }

    public void processPayment(Long accountId) {
        AccountDto account = accountClient.getAccountById(accountId);
        // use account info...
    }
}
```
