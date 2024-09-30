# Dynamic Property Registration

Spring Boot provides ways to register properties dynamically within the application context. This helps to:

* **Enhance Integration Testing:** Particularly useful for integration tests utilizing Testcontainers, we can set properties based on container details dynamically.
* **Flexibility:** Retrieve property values from external resources like databases or environment variables during runtime.
* **Implement Custom Logic:** Design custom logic for determining property values, enabling complex test configurations or dynamic behavior adjustments.

Two key annotations for dynamic property registration are:

1. `@DynamicPropertySource` : Used to register properties dynamically within the test class, particularly useful for integration tests. It is a **method-level** annotation.

**Example:**

Create Integration test file _**SampleIT.java**_

```java
package org.example;

import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;

import java.util.function.Supplier;

@Slf4j
@SpringBootTest(classes = Application.class)
class SampleIT {

    @Value("${service.client.url}")
    private String testServiceUrlProperty;

    @DynamicPropertySource
    static void properties(DynamicPropertyRegistry registry) {
        // Retrieve the property value dynamically (e.g., from a database or testcontainer)
        String serverHost = "testcontainerHost";
        int serverPort = 1080;
        String path = "auth";

        Supplier<Object> serviceUrl = () -> String.format("http://%s:%d/%s", serverHost, serverPort, path);

        registry.add("service.client.url", serviceUrl);
    }

    @Test
    void testDynamicProperties() {
        log.info("testServiceUrlProperty: {}", testServiceUrlProperty);
        Assertions.assertEquals("http://testcontainerHost:1080/auth", testServiceUrlProperty);
    }
}
```

<figure><img src="../../.gitbook/assets/image (248).png" alt=""><figcaption></figcaption></figure>

{% hint style="info" %}
Make sure to include below dependencies and failsafe plugin

{% code title="pom.xml" %}
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-test</artifactId>
    <scope>test</scope>
</dependency>

<dependency>
    <groupId>org.junit.jupiter</groupId>
    <artifactId>junit-jupiter-engine</artifactId>
    <scope>test</scope>
</dependency>

<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-failsafe-plugin</artifactId>
        <version>2.22.2</version>
        <executions>
            <execution>
                <goals>
                    <goal>integration-test</goal>
                    <goal>verify</goal>
                </goals>
            </execution>
        </executions>
</plugin>
```
{% endcode %}
{% endhint %}

2. `@TestPropertySource` : Not strictly for dynamic properties, but rather for overriding application properties specifically within the integration tests or for creating new static properties. It is a **class-level** annotation.

```java
package org.example;

import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestPropertySource;

@Slf4j
@SpringBootTest(classes = Application.class)
@TestPropertySource(properties = {
        "spring.datasource.url=jdbc:h2:mem:testdb",
        "spring.jpa.hibernate.ddl-auto=create-drop"
})
class SampleIT {

    @Value("${spring.datasource.url}")
    private String springDatasourceUrl;
    @Value("${spring.jpa.hibernate.ddl-auto}")
    private String springJpaProperty;

    @Test
    void testPropertySource() {
        log.info("springDatasourceUrl: {}", springDatasourceUrl);
        log.info("springJpaProperty: {}", springJpaProperty);
        Assertions.assertEquals("jdbc:h2:mem:testdb", springDatasourceUrl);
        Assertions.assertEquals("create-drop", springJpaProperty);
    }
}
```

<figure><img src="../../.gitbook/assets/image (249).png" alt=""><figcaption></figcaption></figure>

{% hint style="info" %}
Both `@TestPropertySource` and `@DynamicPropertySource` are processed **before** the Spring application context is loaded for the integration test. This ensures that the properties defined in these annotations are available for use by the test beans and components.
{% endhint %}
