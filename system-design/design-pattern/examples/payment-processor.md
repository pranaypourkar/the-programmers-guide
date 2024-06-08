---
description: Payment Processor example using Strategy Pattern
---

# Payment Processor

Flexibility and extensibility are often key objectives when designing systems that handle varied business requirements. Payment processing system often requires the ability to support multiple payment types while accommodating future additions or modifications with ease.

{% hint style="info" %}
**Strategy pattern:** Encapsulate various payment processing algorithms (such as Cash processing, Local Transfer processing, etc.) into separate classes (strategies) that implement a common interface (`PaymentProcessor`). This allows the system to dynamically select and execute the appropriate algorithm based on the transaction type, promoting flexibility and maintainability in the payment processing logic.
{% endhint %}



Let's start by creating an enum with supported payment types.

_**PaymentType.java**_

```java
@Getter
public enum PaymentType {
    ACCOUNT_TO_ACCOUNT(Constant.ACCOUNT_TO_ACCOUNT),
    ACCOUNT_TO_WALLET(Constant.ACCOUNT_TO_WALLET),
    WALLET_TO_WALLET(Constant.WALLET_TO_WALLET),
    LOCAL_TRANSFER(Constant.LOCAL_TRANSFER),
    INTERNATIONAL_TRANSFER(Constant.INTERNATIONAL_TRANSFER),
    CASH(Constant.CASH),
    INTERNAL_TRANSFER(Constant.INTERNAL_TRANSFER);

    private final String value;
    
    private PaymentType(String type) {
        this.value = type;
    }
    
    public class Constant {
        public static final String ACCOUNT_TO_ACCOUNT = "ACCOUNT_TO_ACCOUNT";
        public static final String ACCOUNT_TO_WALLET = "ACCOUNT_TO_WALLET";
        public static final String WALLET_TO_WALLET = "WALLET_TO_WALLET";
        public static final String LOCAL_TRANSFER = "LOCAL_TRANSFER";
        public static final String INTERNATIONAL_TRANSFER = "INTERNATIONAL_TRANSFER";
        public static final String CASH = "CASH";
        public static final String INTERNAL_TRANSFER = "INTERNAL_TRANSFER";
    }
}
```



Now, create an interface.

_**PaymentProcessor.java**_

```java
public interface PaymentProcessor {
    void processor(Transaction transaction);
}
```



Create different payment processors.

* For e.g. Cash payment processor

_**CashProcessor.java**_

```java
@Slf4j
@Component(value = PaymentType.Constant.CASH)
public class CashProcessor implements PaymentProcessor{
    @Override
    public void processor(Transaction transaction) {
        log.info("Processing {} Payment", transaction.getType());
    }
}
```

* For e.g. Internal payment processor

_**InternalTransferProcessor.java**_

```java
@Slf4j
@Component(value = PaymentType.Constant.INTERNAL_TRANSFER)
public class InternalTransferProcessor implements PaymentProcessor{
    @Override
    public void processor(Transaction transaction) {
        log.info("Processing {} Payment", transaction.getType());
    }
}
```

* And others

<figure><img src="../../../.gitbook/assets/image (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt="" width="255"><figcaption></figcaption></figure>



Now, in the service class, inject all the processor implementation and fetch and trigger appropriate processor logic based on Transaction/Payment Type.

```java
@RequiredArgsConstructor
@Service
public class PaymentService {

    private final Map<String, PaymentProcessor> paymentProcessorMap;

    public void processPayment(Transaction transaction) {
        // Get the payment processor based on Payment Type
        PaymentProcessor processor = paymentProcessorMap.get(transaction.getType().getValue());
        // Process the payment
        processor.processor(transaction);
    }
}
```



We can create Controller class and define the sample endpoint.

_**PaymentApi.java**_

```java
@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/payment")
public class PaymentApi {

    private final PaymentService paymentService;

    @PostMapping("/process")
    public ResponseEntity<Void> processTransaction(@RequestBody Transaction transaction) {

        log.info("Started processing transaction {}", transaction);
        paymentService.processPayment(transaction);

        return ResponseEntity.accepted().build();
    }
}
```



Run the application and call the endpoint.

<figure><img src="../../../.gitbook/assets/image (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt="" width="563"><figcaption></figcaption></figure>

<figure><img src="../../../.gitbook/assets/image (2) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt=""><figcaption><p>Log Output</p></figcaption></figure>

