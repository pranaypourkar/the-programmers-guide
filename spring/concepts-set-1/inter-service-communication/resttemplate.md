# RestTemplate

`RestTemplate` is a synchronous client included in the Spring Framework that allows to interact with RESTful web services. It provides a simplified way to send HTTP requests and receive responses. It also supports authentication, making it versatile for various API interactions.



### **Key points about RestTemplate**

* **Synchronous communication:** RestTemplate makes synchronous HTTP requests, meaning program waits (blocking) for the response before continuing execution. It can have performance impact in high-concurrency applications.
* **Template methods:** It offers template methods for common HTTP methods like GET, POST, PUT, and DELETE. These methods handle the underlying details of sending requests and receiving responses.
* **Flexibility:** While there are convenient methods for common scenarios, RestTemplate also provides more generic `exchange()` and `execute()` methods for less frequent cases.
* **Configuration:** RestTemplate can be customized by providing a custom `ClientHttpRequestFactory` or a list of `HttpMessageConverter` instances. We must define @Bean of RestTemplate in Spring Boot Configuration.
* **Non-Reactive:** Not suited for reactive programming or handling large data streams efficiently. Consider WebClient for these scenarios.
* **Deprecation:** RestTemplate is marked for deprecation in future Spring versions. Consider WebClient for new development as it offers both synchronous and asynchronous capabilities with a reactive programming model.
* RestTemplate doesn't use Apache classes be default. By default the RestTemplate relies on `SimpleClientHttpRequestFactory` which is a standard Java `HttpURLConnection` class for making HTTP requests. It doesn't offer features like connection pooling or advanced configuration options. We can switch to use a different HTTP library such as Apache HttpComponents and then we can enable complete request response logging via `logging.level.org.apache.http.wire=DEBUG`

{% hint style="info" %}
To use Apache HttpComponents, add below dependency and configure RestTemplate with -

<pre class="language-java"><code class="lang-java"><strong>RestTemplate restTemplate = new RestTemplate();
</strong>restTemplate.setRequestFactory(new HttpComponentsAsyncClientHttpRequestFactory());
</code></pre>

```markup
<dependency>
    <groupId>org.apache.httpcomponents</groupId>
    <artifactId>httpasyncclient</artifactId>
</dependency>
```
{% endhint %}

{% hint style="info" %}
To achieve asynchronous behavior when using RestTemplate, we can use it with `CompletableFuture`.

For example -&#x20;

```java
// URL for the REST API endpoint
String url = "http://example.com/api/resource";

// Making an asynchronous GET request using CompletableFuture
CompletableFuture<String> future = CompletableFuture.supplyAsync(() -> {
    // Perform the HTTP request
    String response = restTemplate.getForObject(url, String.class);
    return response;
});

// Other tasks can continue while the request is being made asynchronously

// Wait for the asynchronous operation to complete
future.join();
```
{% endhint %}



### Commonly used RestTemplate configuration

1. **Setting Timeout**: We can configure connection and read timeouts to prevent application from hanging indefinitely if a remote server is slow to respond.

```java
RestTemplate restTemplate = new RestTemplateBuilder()
    .setConnectTimeout(Duration.ofSeconds(10))
    .setReadTimeout(Duration.ofSeconds(10))
    .build();
```

2. **Customizing Message Converters**: We might need to customize the message converters used by `RestTemplate` to handle specific data formats or serialization/deserialization requirements.

```java
RestTemplate restTemplate = new RestTemplate();
restTemplate.setMessageConverters(Arrays.asList(new MappingJackson2HttpMessageConverter()));
```

3. **Error Handling**: We can configure error handling to handle different types of errors gracefully, such as by defining custom error handlers.

```java
RestTemplate restTemplate = new RestTemplate();
restTemplate.setErrorHandler(new MyResponseErrorHandler());
```

4. **Interceptors**: Interceptors allows to intercept and modify outgoing requests or incoming responses. They can be used for logging, adding headers, or other pre/post-processing tasks.

```java
RestTemplate restTemplate = new RestTemplate();
restTemplate.setInterceptors(Collections.singletonList(new MyClientHttpRequestInterceptor()));
```

5. **HTTP Basic Authentication**: If we need to authenticate with a server using HTTP Basic authentication, we can configure it with `RestTemplate`.

```java
RestTemplate restTemplate = new RestTemplate();
restTemplate.getInterceptors().add(new BasicAuthenticationInterceptor("username", "password"));
```

6. **Connection Pooling**: To improve performance and efficiency, we can configure connection pooling.

```java
RestTemplate restTemplate = new RestTemplate();
HttpComponentsClientHttpRequestFactory requestFactory = new HttpComponentsClientHttpRequestFactory();
requestFactory.setHttpClient(HttpClients.createDefault());
restTemplate.setRequestFactory(requestFactory);
```



### **RestTemplate methods**

Some of the RestTemplate methods are given below. For more details visit [https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/client/RestTemplate.html](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/client/RestTemplate.html)

* `restTemplate.getForEntity(...)`:

Sends an HTTP GET request to the specified URL. Retrieves the entire HTTP response, including headers and body, and returns it encapsulated in a `ResponseEntity` object. It allows to access response headers, status code, and body separately.

* `restTemplate.exchange(...)`:

Provides more flexibility than `getForEntity()` by allowing to specify the HTTP method (GET, POST, PUT, DELETE, etc.), headers, request entity, and response type. Returns a `ResponseEntity` like `getForEntity()`, but with the ability to specify additional request parameters.

* `restTemplate.delete(...)`:

Sends an HTTP DELETE request to the specified URL. It's a convenience method specifically for DELETE requests, equivalent to `exchange(url, HttpMethod.DELETE, ...)`. Does not expect a response body.

* `restTemplate.execute(...)`:

This method provides the lowest-level access to HTTP requests.  It takes an instance of `RequestCallback` and `ResponseExtractor` as parameters . This allows for full control over the request and response handling.

* `restTemplate.getForObject(...)`:

Similar to `getForEntity()`, but it directly returns the response body instead of encapsulating the entire response in a `ResponseEntity` object.  Useful when you're only interested in the response body and don't need access to headers or status code separately.

* `postForObject(...)`:

Sends an HTTP POST request to the specified URL. Accepts a URL, request entity (typically an object representing the request body), and a response type. Returns the response body as an object of the specified type. Convenient when you expect a response body and want it directly mapped to a Java object.

* `postForEntity(...)`:

Similar to `postForObject()` but returns the entire HTTP response encapsulated in a `ResponseEntity` object. This allows you to access the response headers, status code, and body separately.

* `postForLocation(...)`:

Used when we expect the server to respond with a '201 Created' status and a 'Location' header indicating the URL of the newly created resource. Sends an HTTP POST request and returns the URL of the newly created resource.

* `patchForObject(...)`:

Sends an HTTP PATCH request to the specified URL. Similar to `postForObject()` but specifically designed for HTTP PATCH requests. Accepts a URL, request entity (typically an object representing the request body), and a response type.

* `put(...)`:

Sends an HTTP PUT request to the specified URL. Typically used to update an existing resource with the provided request entity. Unlike `postForObject()` and `postForEntity()`, there isn't a `putForObject()` or `putForEntity()` method because `RestTemplate`'s `exchange()` method can be used for PUT requests, providing more flexibility.



### **Example:**&#x20;

#### Service 1 calling GET API of Service 2 using RestTemplate

Dependencies

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

Sample Service 2

<figure><img src="../../../.gitbook/assets/image (3) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt="" width="313"><figcaption></figcaption></figure>

_<mark style="background-color:yellow;">**SampleController.java**</mark>_

```java
package org.example.api;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RequiredArgsConstructor
@RestController
public class SampleController {

    @GetMapping("/api/service-2/details")
    public ResponseEntity<String> getInterServiceDetails() {
        return ResponseEntity.ok("Service 2 processed successfully");
    }
}
```

_<mark style="background-color:yellow;">**application.yaml**</mark>_

```
server:
  port: 8082
```

Build and run the service 2 application.

Sample Service 1

<figure><img src="../../../.gitbook/assets/image (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt="" width="313"><figcaption></figcaption></figure>

_<mark style="background-color:yellow;">**ResttemplateConfig.java**</mark>_

```java
package org.example.config;

import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

import java.time.Duration;

@Configuration
public class ResttemplateConfig {
    @Bean
    public RestTemplate restTemplate(RestTemplateBuilder restTemplateBuilder) {
        return restTemplateBuilder
                .setConnectTimeout(Duration.ofMillis(8000))
                .setReadTimeout(Duration.ofMillis(8000))
                .build();
    }
}
```

_<mark style="background-color:yellow;">**SampleController.java**</mark>_

```java
package org.example.api;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@Slf4j
@RequiredArgsConstructor
@RestController
public class SampleController {

    private final RestTemplate restTemplate;
    private static final String SERVICE_2_ENDPOINT = "http://localhost:8082/api/service-2/details";

    @GetMapping("/api/service-1/details")
    public ResponseEntity<String> getInterServiceDetails() {
        log.info("Calling service 2 API");
        return restTemplate.getForEntity(SERVICE_2_ENDPOINT, String.class);
    }
}
```

_<mark style="background-color:yellow;">**application.yaml**</mark>_

```
server:
  port: 8081
```

Build and execute the application

* Call the Service 1 API using Postman

<figure><img src="../../../.gitbook/assets/image (2) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

* We can enable basic information logging like request, headers, response code etc by setting logging level below

`logging.level.org.springframework.web.client.RestTemplate=DEBUG`

<figure><img src="../../../.gitbook/assets/image (3) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

* We can enable full logging including request, response body, etc Apache HttpClient

#### Log Request & Response using Apache httpclient in RestTemplate

Add below dependency

```xml
<dependency>
    <groupId>org.apache.httpcomponents</groupId>
    <artifactId>httpclient</artifactId>
    <version>4.5.13</version>
</dependency>
```

Update RestTemplate config to use HttpComponentsClientHttpRequestFactory() request factory of Apache HTTPClient

```java
package org.example.config;

import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.web.client.RestTemplate;

@Configuration
public class ResttemplateConfig {
    @Bean
    public RestTemplate restTemplate(RestTemplateBuilder restTemplateBuilder) {
        RestTemplate restTemplate = new RestTemplate();
        restTemplate.setRequestFactory(new HttpComponentsClientHttpRequestFactory());
        return restTemplate;
    }
}
```

Add below logging property in application.yaml

```yaml
logging.level.org.apache.http: DEBUG
```

Run both the service 1 and service 2 application from above example



Run the service 1 API from Postman and monitor the logs

<figure><img src="../../../.gitbook/assets/image (5) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

```atom
2024-04-19 15:55:22.074  INFO 21200 --- [nio-8081-exec-5] org.example.api.SampleController         : Calling service 2 API
2024-04-19 15:55:22.076 DEBUG 21200 --- [nio-8081-exec-5] o.a.h.client.protocol.RequestAddCookies  : CookieSpec selected: default
2024-04-19 15:55:22.076 DEBUG 21200 --- [nio-8081-exec-5] o.a.h.client.protocol.RequestAuthCache   : Auth cache not set in the context
2024-04-19 15:55:22.076 DEBUG 21200 --- [nio-8081-exec-5] h.i.c.PoolingHttpClientConnectionManager : Connection request: [route: {}->http://localhost:8082][total available: 1; route allocated: 1 of 5; total allocated: 1 of 10]
2024-04-19 15:55:22.076 DEBUG 21200 --- [nio-8081-exec-5] org.apache.http.impl.conn.CPool          : Connection [id:0][route:{}->http://localhost:8082][state:null] expired @ Fri Apr 19 15:20:45 IST 2024
2024-04-19 15:55:22.076 DEBUG 21200 --- [nio-8081-exec-5] h.i.c.DefaultManagedHttpClientConnection : http-outgoing-0: Close connection
2024-04-19 15:55:22.077 DEBUG 21200 --- [nio-8081-exec-5] h.i.c.PoolingHttpClientConnectionManager : Connection leased: [id: 1][route: {}->http://localhost:8082][total available: 0; route allocated: 1 of 5; total allocated: 1 of 10]
2024-04-19 15:55:22.077 DEBUG 21200 --- [nio-8081-exec-5] o.a.http.impl.execchain.MainClientExec   : Opening connection {}->http://localhost:8082
2024-04-19 15:55:22.079 DEBUG 21200 --- [nio-8081-exec-5] .i.c.DefaultHttpClientConnectionOperator : Connecting to localhost/127.0.0.1:8082
2024-04-19 15:55:22.079 DEBUG 21200 --- [nio-8081-exec-5] .i.c.DefaultHttpClientConnectionOperator : Connection established 127.0.0.1:62992<->127.0.0.1:8082
2024-04-19 15:55:22.080 DEBUG 21200 --- [nio-8081-exec-5] o.a.http.impl.execchain.MainClientExec   : Executing request GET /api/service-2/details HTTP/1.1
2024-04-19 15:55:22.080 DEBUG 21200 --- [nio-8081-exec-5] o.a.http.impl.execchain.MainClientExec   : Target auth state: UNCHALLENGED
2024-04-19 15:55:22.080 DEBUG 21200 --- [nio-8081-exec-5] o.a.http.impl.execchain.MainClientExec   : Proxy auth state: UNCHALLENGED
2024-04-19 15:55:22.080 DEBUG 21200 --- [nio-8081-exec-5] org.apache.http.headers                  : http-outgoing-1 >> GET /api/service-2/details HTTP/1.1
2024-04-19 15:55:22.080 DEBUG 21200 --- [nio-8081-exec-5] org.apache.http.headers                  : http-outgoing-1 >> Accept: text/plain, application/json, application/*+json, */*
2024-04-19 15:55:22.080 DEBUG 21200 --- [nio-8081-exec-5] org.apache.http.headers                  : http-outgoing-1 >> Host: localhost:8082
2024-04-19 15:55:22.080 DEBUG 21200 --- [nio-8081-exec-5] org.apache.http.headers                  : http-outgoing-1 >> Connection: Keep-Alive
2024-04-19 15:55:22.080 DEBUG 21200 --- [nio-8081-exec-5] org.apache.http.headers                  : http-outgoing-1 >> User-Agent: Apache-HttpClient/4.5.13 (Java/17.0.7)
2024-04-19 15:55:22.080 DEBUG 21200 --- [nio-8081-exec-5] org.apache.http.headers                  : http-outgoing-1 >> Accept-Encoding: gzip,deflate
2024-04-19 15:55:22.080 DEBUG 21200 --- [nio-8081-exec-5] org.apache.http.wire                     : http-outgoing-1 >> "GET /api/service-2/details HTTP/1.1[\r][\n]"
2024-04-19 15:55:22.080 DEBUG 21200 --- [nio-8081-exec-5] org.apache.http.wire                     : http-outgoing-1 >> "Accept: text/plain, application/json, application/*+json, */*[\r][\n]"
2024-04-19 15:55:22.080 DEBUG 21200 --- [nio-8081-exec-5] org.apache.http.wire                     : http-outgoing-1 >> "Host: localhost:8082[\r][\n]"
2024-04-19 15:55:22.080 DEBUG 21200 --- [nio-8081-exec-5] org.apache.http.wire                     : http-outgoing-1 >> "Connection: Keep-Alive[\r][\n]"
2024-04-19 15:55:22.080 DEBUG 21200 --- [nio-8081-exec-5] org.apache.http.wire                     : http-outgoing-1 >> "User-Agent: Apache-HttpClient/4.5.13 (Java/17.0.7)[\r][\n]"
2024-04-19 15:55:22.080 DEBUG 21200 --- [nio-8081-exec-5] org.apache.http.wire                     : http-outgoing-1 >> "Accept-Encoding: gzip,deflate[\r][\n]"
2024-04-19 15:55:22.080 DEBUG 21200 --- [nio-8081-exec-5] org.apache.http.wire                     : http-outgoing-1 >> "[\r][\n]"
2024-04-19 15:55:22.084 DEBUG 21200 --- [nio-8081-exec-5] org.apache.http.wire                     : http-outgoing-1 << "HTTP/1.1 200 [\r][\n]"
2024-04-19 15:55:22.084 DEBUG 21200 --- [nio-8081-exec-5] org.apache.http.wire                     : http-outgoing-1 << "Content-Type: text/plain;charset=UTF-8[\r][\n]"
2024-04-19 15:55:22.084 DEBUG 21200 --- [nio-8081-exec-5] org.apache.http.wire                     : http-outgoing-1 << "Content-Length: 32[\r][\n]"
2024-04-19 15:55:22.084 DEBUG 21200 --- [nio-8081-exec-5] org.apache.http.wire                     : http-outgoing-1 << "Date: Fri, 19 Apr 2024 10:25:22 GMT[\r][\n]"
2024-04-19 15:55:22.084 DEBUG 21200 --- [nio-8081-exec-5] org.apache.http.wire                     : http-outgoing-1 << "Keep-Alive: timeout=60[\r][\n]"
2024-04-19 15:55:22.085 DEBUG 21200 --- [nio-8081-exec-5] org.apache.http.wire                     : http-outgoing-1 << "Connection: keep-alive[\r][\n]"
2024-04-19 15:55:22.085 DEBUG 21200 --- [nio-8081-exec-5] org.apache.http.wire                     : http-outgoing-1 << "[\r][\n]"
2024-04-19 15:55:22.085 DEBUG 21200 --- [nio-8081-exec-5] org.apache.http.wire                     : http-outgoing-1 << "Service 2 processed successfully"
2024-04-19 15:55:22.085 DEBUG 21200 --- [nio-8081-exec-5] org.apache.http.headers                  : http-outgoing-1 << HTTP/1.1 200 
2024-04-19 15:55:22.085 DEBUG 21200 --- [nio-8081-exec-5] org.apache.http.headers                  : http-outgoing-1 << Content-Type: text/plain;charset=UTF-8
2024-04-19 15:55:22.085 DEBUG 21200 --- [nio-8081-exec-5] org.apache.http.headers                  : http-outgoing-1 << Content-Length: 32
2024-04-19 15:55:22.085 DEBUG 21200 --- [nio-8081-exec-5] org.apache.http.headers                  : http-outgoing-1 << Date: Fri, 19 Apr 2024 10:25:22 GMT
2024-04-19 15:55:22.085 DEBUG 21200 --- [nio-8081-exec-5] org.apache.http.headers                  : http-outgoing-1 << Keep-Alive: timeout=60
2024-04-19 15:55:22.085 DEBUG 21200 --- [nio-8081-exec-5] org.apache.http.headers                  : http-outgoing-1 << Connection: keep-alive
2024-04-19 15:55:22.085 DEBUG 21200 --- [nio-8081-exec-5] o.a.http.impl.execchain.MainClientExec   : Connection can be kept alive for 60000 MILLISECONDS
2024-04-19 15:55:22.086 DEBUG 21200 --- [nio-8081-exec-5] h.i.c.PoolingHttpClientConnectionManager : Connection [id: 1][route: {}->http://localhost:8082] can be kept alive for 60.0 seconds
2024-04-19 15:55:22.086 DEBUG 21200 --- [nio-8081-exec-5] h.i.c.DefaultManagedHttpClientConnection : http-outgoing-1: set socket timeout to 0
2024-04-19 15:55:22.086 DEBUG 21200 --- [nio-8081-exec-5] h.i.c.PoolingHttpClientConnectionManager : Connection released: [id: 1][route: {}->http://localhost:8082][total available: 1; route allocated: 1 of 5; total allocated: 1 of 10]
```

