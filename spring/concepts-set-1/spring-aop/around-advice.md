---
description: Details as well as Examples covering Around Advice.
---

# Around Advice

Around advice wraps around the target method invocation. It allows to control the method invocation, including modifying the method arguments, skipping method execution, or replacing the method result. Some of the use cases are described below.

**Caching**: Helpful in manual cache checking if the requested data is available in the cache before proceeding with the method execution.

**Security Checks**: Useful in performing authentication and authorization checks before allowing access.

**Logging**: Can be used in calculating execution time.

**Sample Example**

<mark style="background-color:blue;">Scenario 1</mark>: Log method execution time using custom annotation.

Create a custom annotation

_**LogExecutionTime.java**_

```java
package org.example.logging;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target(ElementType.METHOD)           // Annotation will be applicable on methods only
@Retention(RetentionPolicy.RUNTIME)   // Annotation will be available to the JVM at runtime
public @interface LogExecutionTime {
}
```

Create Aspect class

_**LoggingAspect.java**_

```java
package org.example.logging;

import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;

import java.time.OffsetDateTime;

@Slf4j
@Aspect
@Component
public class LoggingAspect {

    @SneakyThrows
    @Around("@annotation(LogExecutionTime)")
    public Object logExecutionTime(ProceedingJoinPoint joinPoint) {
        log.info("Started - {}", OffsetDateTime.now());

        // Perform custom logic before method execution

        // Proceed with the method execution
        final Object proceed = joinPoint.proceed();

        // Perform custom logic after method execution
        log.info("Completed - {}", OffsetDateTime.now());

        return proceed;
    }
}
```

Create controller class

_**DataApi.java**_

```java
package org.example.controller;

import lombok.RequiredArgsConstructor;
import org.example.Model.InputData;
import org.example.Model.OutputData;
import org.example.logging.LogExecutionTime;
import org.example.service.DataService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/data")
public class DataApi {

    private final DataService dataService;

    @LogExecutionTime
    @PostMapping("/extract")
    public ResponseEntity<OutputData> getData(@RequestBody InputData inputData) {

        return new ResponseEntity<>(
                dataService.extractData(inputData),
                HttpStatus.OK
        );
    }
}
```

Run the application, execute the API and observe the logs

<figure><img src="../../../.gitbook/assets/image (234).png" alt="" width="563"><figcaption></figcaption></figure>

<figure><img src="../../../.gitbook/assets/image (236).png" alt=""><figcaption><p>Output</p></figcaption></figure>

{% hint style="info" %}
Note: The code snippet given in this page is just for understanding and does not contain complete code. (For e.g. missing service class code snippet)
{% endhint %}
