---
description: Details as well as Examples covering Before Advice.
---

# Before Advice

Before Advice is executed before the advised method execution. It allows to execute custom logic or perform certain actions before the target method is invoked. Some of the use cases are described below.

**Logging**: Before Advice can be used to log method invocations, providing information such as the method name and parameters. This can be helpful for debugging, auditing, or monitoring purposes.

**Security Checks**: Before advice can be used to perform security checks before executing sensitive methods. For example, checking if the user has the required permissions or if the request is coming from a trusted source.

**Parameter Validation**: Before advice can validate method parameters before executing the method. This ensures that the method receives valid input and prevents potential errors or security vulnerabilities.

**Caching**: Before advice can check if the requested data is already available in the cache before executing expensive database queries. If the data is found in the cache, the method execution can be skipped, improving performance.

**Transaction Management**: Before advice can be used to start a transaction before executing methods that require database operations.



#### Sample Examples

#### <mark style="background-color:blue;">Scenario 1</mark>: Logging request details using custom annotation&#x20;

Create custom annotation `LogRequest`

_**LogRequest.java**_

```java
package org.example.logging;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target(ElementType.METHOD)           // Annotation will be applicable on methods only
@Retention(RetentionPolicy.RUNTIME)   // Annotation will be available to the JVM at runtime
public @interface LogRequest {
}
```

Create Aspect class

_**LoggingAspect.java**_

```java
package org.example.logging;

import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

@Slf4j
@Aspect
@Component
public class LoggingAspect {

    @Before("@annotation(LogRequest)")
    public void logRequest(JoinPoint joinPoint) {

        log.info("Start: LogRequest");
        log.info("JoinPoint: signature - {}", joinPoint.getSignature());
        log.info("JoinPoint: arguments - {}", joinPoint.getArgs());
        log.info("JoinPoint: kind - {}", joinPoint.getKind());
        log.info("JoinPoint: class - {}", joinPoint.getClass());
        log.info("Finish: LogRequest");
    }
}
```

Add the annotation on the Controller method.

```java
package org.example.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.Model.Transaction;
import org.example.logging.LogRequest;
import org.example.service.PaymentService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/payment")
public class PaymentApi {

    private final PaymentService paymentService;

    @LogRequest
    @PostMapping("/process")
    public ResponseEntity<Void> processTransaction(@RequestBody Transaction transaction) {

        log.info("Started processing transaction {}", transaction);
        paymentService.processPayment(transaction);

        return ResponseEntity.accepted().build();
    }
}
```

Run and execute the API and verify the log response.

<figure><img src="../../../.gitbook/assets/image (2) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt="" width="563"><figcaption><p>Postman</p></figcaption></figure>

<figure><img src="../../../.gitbook/assets/image (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) ( (6).png" alt=""><figcaption><p>Output</p></figcaption></figure>

> Passing argNames in the Before Advice annotation.
>
> ```java
> @Before(value = "@annotation(LogRequest) && args(transaction)", argNames = "transaction")
> public void logRequest(JoinPoint joinPoint, Transaction transaction) {
>
>     log.info("Start: LogRequest");
>     log.info("Transaction: {}", transaction);
>     log.info("JoinPoint: signature - {}", joinPoint.getSignature());
>     log.info("JoinPoint: arguments - {}", joinPoint.getArgs());
>     log.info("JoinPoint: kind - {}", joinPoint.getKind());
>     log.info("JoinPoint: class - {}", joinPoint.getClass());
>     log.info("Finish: LogRequest");
> }
> ```







{% hint style="info" %}
Note: The code snippet given in this page is just for understanding and does not contain complete code. (For e.g. missing service class code snippet)
{% endhint %}
