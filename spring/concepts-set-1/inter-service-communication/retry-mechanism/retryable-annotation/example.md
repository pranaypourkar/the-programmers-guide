# Example

## 1. Handling Payment Processing Failures

In a microservices architecture, let’s assume we have an e-commerce platform with a Payment Service responsible for processing payments by communicating with a third-party payment gateway (e.g., Stripe, PayPal). Due to various reasons (e.g., network instability, gateway downtime, rate-limiting), payment processing may occasionally fail, but these failures are often transient.

The goal is to implement a retry mechanism with different retry policies, backoff strategies, and recovery handling, ensuring payment operations are retried when appropriate but without overloading the payment gateway.

* **Service**: PaymentService calls a third-party payment API to process payments.
* **Retry Logic**:
  * Retry on specific transient failures like `TimeoutException` and `PaymentGatewayUnavailableException`.
  * Use an exponential backoff strategy to avoid overloading the payment gateway.
  * Limit the number of retry attempts to prevent excessive retries.
* **Fallback Recovery**: After exhausting retries, the transaction is marked as pending, and the user is notified to try again later.

PaymentService.java class

```java
package org.example.service;

import org.example.client.PaymentGatewayClient;
import org.example.exception.PaymentException;
import org.example.exception.PaymentGatewayUnavailableException;
import org.example.model.PaymentRequest;
import org.example.model.PaymentResponse;
import org.springframework.retry.annotation.Backoff;
import org.springframework.retry.annotation.Recover;
import org.springframework.retry.annotation.Retryable;
import org.springframework.stereotype.Service;

import java.util.concurrent.TimeoutException;

@Service
public class PaymentService {

    private final PaymentGatewayClient paymentGatewayClient;

    public PaymentService(PaymentGatewayClient paymentGatewayClient) {
        this.paymentGatewayClient = paymentGatewayClient;
    }

    // Retryable method for processing payment
    @Retryable(
            retryFor = { TimeoutException.class, PaymentGatewayUnavailableException.class },
            maxAttempts = 5,
            backoff = @Backoff(delay = 2000, multiplier = 2.0)
    )
    public PaymentResponse processPayment(PaymentRequest request) throws PaymentException {
        // Call the third-party payment gateway
        return paymentGatewayClient.processPayment(request);
    }

    // Recovery method if retries fail
    @Recover
    public PaymentResponse recover(PaymentGatewayUnavailableException e, PaymentRequest request) {
        System.out.println("Recovering after retries failed for request: " + request.getTransactionId());
        // Mark transaction as pending and notify user to retry
        return markTransactionAsPending(request);
    }

    private PaymentResponse markTransactionAsPending(PaymentRequest request) {
        // Logic to mark the transaction as pending due to payment failures
        return new PaymentResponse("PENDING", "Your payment is pending. Please try again later.");
    }
}
```

_PaymentGatewayClient.java class_

```java
package org.example.client;

import org.example.exception.PaymentException;
import org.example.exception.PaymentGatewayUnavailableException;
import org.example.model.PaymentRequest;
import org.example.model.PaymentResponse;
import org.springframework.stereotype.Component;

@Component
public class PaymentGatewayClient {

    public PaymentResponse processPayment(PaymentRequest request) throws PaymentException {
        // Simulate communication with payment gateway
        if (Math.random() > 0.7) {
            return new PaymentResponse("SUCCESS", "Payment processed successfully.");
        } else {
            throw new PaymentGatewayUnavailableException("Payment gateway is temporarily unavailable.");
        }
    }
}
```

_PaymentException and PaymentGatewayUnavailableException java class_

```java
package org.example.exception;

public abstract class PaymentException extends Exception {
    protected PaymentException(String message) {
        super(message);
    }
}
```

```java
package org.example.exception;

public class PaymentGatewayUnavailableException extends PaymentException {
    public PaymentGatewayUnavailableException(String message) {
        super(message);
    }
}
```

_PaymentRequest and PaymentResponse java Class_

```java
package org.example.model;

public class PaymentRequest {
    private String transactionId;
    private double amount;

    // Getters and Setters

    public PaymentRequest(String transactionId, double amount) {
        this.transactionId = transactionId;
        this.amount = amount;
    }

    public String getTransactionId() {
        return transactionId;
    }

    public double getAmount() {
        return amount;
    }
}
```

```java
package org.example.model;

public class PaymentResponse {
    private String status;
    private String message;

    // Getters and Setters

    public PaymentResponse(String status, String message) {
        this.status = status;
        this.message = message;
    }

    public String getStatus() {
        return status;
    }

    public String getMessage() {
        return message;
    }
}
```



