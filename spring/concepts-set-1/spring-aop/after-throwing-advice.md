---
description: Details as well as Examples covering After Throwing Advice.
---

# After Throwing Advice

After throwing advice is executed after the target method throws an exception. It allows to handle or log exceptions thrown by the method. Some of the use cases are described below.

**Exception Logging**: It can be used to log exceptions and stack traces to diagnose errors and troubleshoot issues.

**Notification on Error**: Sending notifications or alerts to administrators or users about unexpected errors.

**Resource Cleanup**: Releasing resources, such as database connections or file handles, to prevent resource leaks.

**Transaction Rollback**: Can be used to close open transactions or rolling back database changes in response to exceptions.



#### Sample Example

#### <mark style="background-color:blue;">Scenario 1</mark>: Capturing exception details via AOP

Create Aspect class

```java
package org.example.logging;

import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;

@Slf4j
@Aspect
@Component
public class LoggingAspect {

    private static final String AFTER_THROWING_POINTCUT ="execution(* org.example.controller.*.*(..))";

    @AfterThrowing(value = AFTER_THROWING_POINTCUT, throwing = "exception")
    public void logsErrors(JoinPoint joinPoint, Throwable exception){
        // Log the controller name
        log.info("AfterThrowing - {}", joinPoint.getSignature().getName());
        // Log the exception message
        log.info("AfterThrowing - {}", exception.getMessage());
    }
}
```



Create controller class. Assuming. some logic in the method throws exception.

_**DataApi.java**_

```java
package org.example.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.Model.InputData;
import org.example.Model.OutputData;
import org.example.service.DataService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/data")
public class DataApi {

    private final DataService dataService;

    @PostMapping("/extract")
    public ResponseEntity<OutputData> getData(@RequestBody InputData inputData) {

        // Crafting some logic which throws exception
        if (inputData != null) {
            throw new ArithmeticException("Throwing some exception");
        }

        log.info("Extracting Data");
        return new ResponseEntity<>(
                dataService.extractData(inputData),
                HttpStatus.OK
        );
    }
}
```



Run the application, trigger the API and observe the logs

<figure><img src="../../../.gitbook/assets/image (8) (1) (1) (1) (1) (1) (1).png" alt="" width="563"><figcaption></figcaption></figure>

<figure><img src="../../../.gitbook/assets/image (9) (1) (1) (1) (1) (1).png" alt=""><figcaption><p>Output</p></figcaption></figure>





{% hint style="info" %}
Note: The code snippet given in this page is just for understanding and does not contain complete code. (For e.g. missing service class code snippet)
{% endhint %}
