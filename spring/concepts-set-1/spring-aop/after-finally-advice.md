---
description: Details as well as Examples covering After Advice.
---

# After (finally) Advice

After (finally) advice is executed regardless of whether the target method completes successfully or throws an exception. It allows to perform cleanup or resource release actions. Some of the use cases are described below.

**Transaction Management**: It can be used for committing or rolling back database transactions after method execution, ensuring data consistency. Helpful to add logic for releasing locks or other resources acquired during transactional operations.

**Logging**: Useful in logging method completion messages or status updates for tracking and debugging purposes. Cleaning up temporary files or resources used during method execution.



**Sample Example**

<mark style="background-color:blue;">Scenario 1:</mark> Logging the method arguments.

Create Aspect class

_**LoggingAspect.java**_

```java
package org.example.logging;

import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;

@Slf4j
@Aspect
@Component
public class LoggingAspect {

    private static final String AFTER_POINTCUT ="execution(* org.example.controller.*.*(..))";

    @After(value = AFTER_POINTCUT)
    public void logsErrors(JoinPoint joinPoint){
        // Log the controller name
        log.info("After - {}", joinPoint.getSignature().getName());
        // Log the exception message
        log.info("After - {}", joinPoint.getArgs());
    }
}
```

Create controller class

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

        // Crafting some logic which can throw exception
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

{% hint style="info" %}
Note that logic is set to throw exception
{% endhint %}



Run the application, execute the API and observe the logs

<figure><img src="../../../.gitbook/assets/image (10) (1) (1).png" alt="" width="563"><figcaption></figcaption></figure>

<figure><img src="../../../.gitbook/assets/image (11) (1).png" alt=""><figcaption><p>Output</p></figcaption></figure>









{% hint style="info" %}
Note: The code snippet given in this page is just for understanding and does not contain complete code. (For e.g. missing service class code snippet)
{% endhint %}
