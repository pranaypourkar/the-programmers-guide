# Examples

## Use Case 1

The WebClientConfig class demonstrates how to configure a WebClient bean in a Spring application. It supports the following features:

* Skipping SSL verification for development or testing purposes.
* Using a custom SSL certificate for secure communication.
* Configuring an HTTP proxy for outgoing requests.
* The custom SSL certificate should be in PEM format (Privacy-Enhanced Mail), which is commonly used for X.509 certificates.

_**pom.xml**_

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.4.4</version>
        <relativePath />
    </parent>

    <groupId>com.company.project</groupId>
    <artifactId>sample-springboot-service</artifactId>
    <version>1.0.0</version>
    <packaging>jar</packaging>

    <properties>
        <java.version>21</java.version>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <!-- Spring WebFlux for WebClient -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-webflux</artifactId>
        </dependency>

        <!-- Reactor Netty for HttpClient, SSL, and proxy support -->
        <dependency>
            <groupId>io.projectreactor.netty</groupId>
            <artifactId>reactor-netty-http</artifactId>
        </dependency>

        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <version>1.18.36</version>
        </dependency>
    </dependencies>
</project>
```

_**WebClientConfig.java**_

```java
package com.company.project.config;

import io.netty.handler.ssl.SslContextBuilder;
import io.netty.handler.ssl.util.InsecureTrustManagerFactory;
import java.io.File;
import javax.net.ssl.SSLException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.client.reactive.ReactorClientHttpConnector;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.netty.http.client.HttpClient;
import reactor.netty.transport.ProxyProvider;

@Slf4j
@Configuration
public class WebClientConfig {

    @Value("${webclient.base-url}")
    private String baseUrl;

    @Value("${webclient.skip-ssl-verification-and-proxy:false}")
    private boolean skipSslVerification;

    @Value("${webclient.proxy-ip:}")
    private String proxyIP;

    @Value("${webclient.proxy-port:0}")
    private int proxyPort;

    @Value("${webclient.ssl-cert-path:}")
    private String sslCertPath;

    /**
     * Configures and provides a WebClient bean with optional SSL verification skipping and proxy support.
     */
    @Bean
    public WebClient webClient(WebClient.Builder webClientBuilder) {
        HttpClient httpClient = HttpClient.create();

        log.info("WebClient configuration: skipSslVerification={}, sslCertPath={}, proxyIP={}, proxyPort={}",
            skipSslVerification, sslCertPath, proxyIP, proxyPort);

        // SSL configuration
        if (skipSslVerification) {
            httpClient = configureSkipSsl(httpClient);
        } else if (sslCertPath != null && !sslCertPath.isEmpty()) {
            httpClient = configureCustomSsl(httpClient, sslCertPath);
        }

        // Proxy configuration
        if (proxyIP != null && !proxyIP.isEmpty() && proxyPort > 0) {
            httpClient = configureProxy(httpClient);
        }

        return webClientBuilder
            .baseUrl(baseUrl)
            .clientConnector(new ReactorClientHttpConnector(httpClient))
            .build();
    }

    private HttpClient configureSkipSsl(HttpClient httpClient) {
        log.debug("Configuring HttpClient to skip SSL verification");
        return httpClient.secure(sslContextSpec -> {
            try {
                sslContextSpec.sslContext(SslContextBuilder
                    .forClient()
                    .trustManager(InsecureTrustManagerFactory.INSTANCE)
                    .build());
            } catch (SSLException e) {
                throw new IllegalStateException("Failed to configure SSL context for skipping verification", e);
            }
        });
    }

    private HttpClient configureCustomSsl(HttpClient httpClient, String certPath) {
        log.info("Configuring HttpClient with custom SSL certificate: {}", certPath);
        return httpClient.secure(sslContextSpec -> {
            try {
                sslContextSpec.sslContext(SslContextBuilder
                    .forClient()
                    .trustManager(new File(certPath))
                    .build());
            } catch (SSLException e) {
                throw new IllegalStateException("Failed to configure SSL context with custom certificate", e);
            }
        });
    }

    private HttpClient configureProxy(HttpClient httpClient) {
        if (proxyIP != null && !proxyIP.isEmpty() && proxyPort > 0) {
            log.info("Configuring HttpClient proxy: {}:{}", proxyIP, proxyPort);
            return httpClient.proxy(proxy -> proxy
                .type(ProxyProvider.Proxy.HTTP)
                .host(proxyIP)
                .port(proxyPort));
        }
        return httpClient;
    }
}
```

_**application.yaml**_

```yaml
webclient:
  base-url=: https://our-api-url
  skip-ssl-verification-and-proxy: false
  proxy-ip:
  proxy-port: 0
  ssl-cert-path: /etc/ssl/certs/my-custom-cert.pem
```

We can call the endpoint like below sample

```java
@RequiredArgsConstructor
@Component
public class SampleClient {

    private final WebClient webClient;

    public ResponseDto callApi(RequestDto payload) {
        return webClient.post()
            .uri("/api/some/endpoint")
            .contentType(MediaType.APPLICATION_JSON)
            .bodyValue(payload)
            .retrieve()
            .bodyToMono(ResponseDto.class)
            .block();
    }
}
```

