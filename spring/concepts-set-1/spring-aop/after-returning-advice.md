---
description: Details as well as Examples covering After Returning Advice.
---

# After Returning Advice

After returning advice is executed after the target method successfully returns a result. It allows to perform additional actions based on the returned result. Some of the use cases are described below.

**Logging**: It can be used to log method response. This can be helpful for debugging, auditing, or monitoring purposes.

**Notification**: It it can be used to trigger notification logic such as sending SMS, Email etc. after successful response.



#### Sample Examples

#### <mark style="background-color:blue;">Scenario 1</mark>: Triggering SMS on the successful method invocation

Create custom annotation

_**SmsOnSuccess.java**_

```java
package org.example.sms;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target(ElementType.METHOD)           // Annotation will be applicable on methods only
@Retention(RetentionPolicy.RUNTIME)   // Annotation will be available to the JVM at runtime
public @interface SmsOnSuccess {
}
```

Create Aspect class

_**SmsOnSuccessAspect.class**_

<pre class="language-java"><code class="lang-java">package org.example.sms;

import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;

<strong>@Slf4j
</strong>@Aspect
@Component
public class SmsOnSuccessAspect {

    @AfterReturning("@annotation(SmsOnSuccess)")
    public void sendSmsOnSuccess() {
        log.info("Sending SMS...");
    }
}
</code></pre>

Controller Class

_**PaymentApi.java**_

```java
package org.example.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.Model.Transaction;
import org.example.service.PaymentService;
import org.example.sms.SmsOnSuccess;
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

    @SmsOnSuccess
    @PostMapping("/process")
    public ResponseEntity<Void> processTransaction(@RequestBody Transaction transaction) {

        log.info("Started processing transaction {}", transaction);
        paymentService.processPayment(transaction);

        return ResponseEntity.accepted().build();
    }
}
```

Run the application and trigger the API

<figure><img src="../../../.gitbook/assets/image (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt="" width="563"><figcaption></figcaption></figure>

<figure><img src="../../../.gitbook/assets/image (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt=""><figcaption><p>Output</p></figcaption></figure>

#### <mark style="background-color:blue;">Scenario 2</mark>: Logging method response using pointcut expression

Create Aspect class

_**LoggingAspect.java**_

```java
package org.example.logging;

import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.*;
import org.springframework.stereotype.Component;

@Slf4j
@Aspect
@Component
public class LoggingAspect {

    private static final String AFTER_RETURNING_POINTCUT ="execution(* org.example.controller.*.*(..))";
    
    @AfterReturning(pointcut = AFTER_RETURNING_POINTCUT, returning = "result")
    public void logResponse(JoinPoint joinPoint, Object result) {
        log.info("JoinPoint - {}", joinPoint);
        log.info("Response - {}", result);
    }
}

```

{% hint style="info" %}
Note that pointcut expression matches any class and any method defined under `org.example.controller` package
{% endhint %}

Create controller class

_**DataApi.java**_

```java
package org.example.controller;

import lombok.RequiredArgsConstructor;
import org.example.Model.InputData;
import org.example.Model.OutputData;
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

    @PostMapping("/extract")
    public ResponseEntity<OutputData> getData(@RequestBody InputData inputData) {

        return new ResponseEntity<>(
                dataService.extractData(inputData),
                HttpStatus.OK
        );
    }
}
```



Run the application, trigger the API and verify the logs

<figure><img src="../../../.gitbook/assets/image (2) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt="" width="563"><figcaption></figcaption></figure>

<figure><img src="../../../.gitbook/assets/image (3) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt=""><figcaption><p>Output</p></figcaption></figure>







{% hint style="info" %}
Note: The code snippet given in this page is just for understanding and does not contain complete code. (For e.g. missing service class code snippet)
{% endhint %}
