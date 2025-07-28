# Use Case

## 1. Service-1 calling Service-2 GET API

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

<figure><img src="../../../../../.gitbook/assets/image (177).png" alt="" width="313"><figcaption></figcaption></figure>

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

<figure><img src="../../../../../.gitbook/assets/image (178).png" alt="" width="313"><figcaption></figcaption></figure>

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

<figure><img src="../../../../../.gitbook/assets/image (179).png" alt=""><figcaption></figcaption></figure>

### Log Request & Response using Default httpclient

We can enable basic information logging like request, headers, response code etc by setting logging level below

`logging.level.org.springframework.web.client.RestTemplate=DEBUG`

<figure><img src="../../../../../.gitbook/assets/image (180).png" alt=""><figcaption></figcaption></figure>

* We can enable full logging including request, response body, etc using Apache HttpClient

### Log Request & Response using Apache httpclient

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

<figure><img src="../../../../../.gitbook/assets/image (182).png" alt=""><figcaption></figcaption></figure>

<details>

<summary>Logs</summary>

```
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

</details>

