# Payment Validation

## Problem Statement

We are building a payment processing module. The system supports multiple payment types:

* CREDIT\_CARD
* UPI
* WALLET
* NET\_BANKING

Each payment type requires **a different set of validations**, and each validation must be executed in a **specific order**. For example:

**CREDIT\_CARD**:

* Step 1: Balance Check
* Step 2: Card Expiry Validation
* Step 3: Authorize Payment

**WALLET**:

* Step 1: Balance Check
* Step 2: Wallet Active Check
* Step 3: Fraud Detection

Instead of writing switch-cases or hardcoded flows, we want to define reusable **validation steps (handlers)** and let Spring dynamically execute them **in order** per payment type.

## Design Goals

* Maintainable, testable, and extensible structure
* Decouple payment type from validation logic
* Dynamically register validation logic using Spring
* Apply validation steps in the correct order
* Support different validation chains per payment type

## Patterns Involved

* **Strategy Pattern**: Different strategy for each payment type.
* **Chain of Responsibility Pattern**: Validation handlers processed in order.
* **Template Method Pattern (Optional)**: For executing steps in a defined sequence.

## Solution

#### `PaymentType.java`

```java
public enum PaymentType {
    CREDIT_CARD,
    WALLET,
    UPI
}
```

#### `PaymentRequest.java`

```java
public class PaymentRequest {
    private PaymentType paymentType;
    private String accountId;
    private double amount;
    private String cardNumber;
    private String walletId;

    // Getters and setters
    // Constructors (or use Lombok if preferred)
}
```

#### `PaymentValidationStep.java`

```java
public interface PaymentValidationStep {
    void validate(PaymentRequest request);

    List<PaymentType> getSupportedPaymentTypes();

    int getOrder(PaymentType type);
}
```

#### Validators (`validators/`)

#### A. `BalanceCheckValidator.java`

```java
@Component
public class BalanceCheckValidator implements PaymentValidationStep {

    @Override
    public void validate(PaymentRequest request) {
        System.out.println("Balance check for " + request.getAccountId());
        // simulate check
    }

    @Override
    public List<PaymentType> getSupportedPaymentTypes() {
        return List.of(PaymentType.CREDIT_CARD, PaymentType.WALLET, PaymentType.UPI);
    }

    @Override
    public int getOrder(PaymentType type) {
        return 1;
    }
}
```

#### B. `CardExpiryValidator.java`

```java
@Component
public class CardExpiryValidator implements PaymentValidationStep {

    @Override
    public void validate(PaymentRequest request) {
        System.out.println("Card expiry check for card: " + request.getCardNumber());
        // simulate check
    }

    @Override
    public List<PaymentType> getSupportedPaymentTypes() {
        return List.of(PaymentType.CREDIT_CARD);
    }

    @Override
    public int getOrder(PaymentType type) {
        return 2;
    }
}
```

#### C. `WalletActiveValidator.java`

```java
@Component
public class WalletActiveValidator implements PaymentValidationStep {

    @Override
    public void validate(PaymentRequest request) {
        System.out.println("Wallet active check for wallet: " + request.getWalletId());
        // simulate check
    }

    @Override
    public List<PaymentType> getSupportedPaymentTypes() {
        return List.of(PaymentType.WALLET);
    }

    @Override
    public int getOrder(PaymentType type) {
        return 2;
    }
}
```

#### `PaymentValidatorService.java`

```java
@Service
public class PaymentValidatorService {

    private final Map<PaymentType, List<PaymentValidationStep>> validatorsMap = new HashMap<>();

    @Autowired
    public PaymentValidatorService(List<PaymentValidationStep> allSteps) {
        for (PaymentType type : PaymentType.values()) {
            List<PaymentValidationStep> steps = allSteps.stream()
                .filter(step -> step.getSupportedPaymentTypes().contains(type))
                .sorted(Comparator.comparingInt(step -> step.getOrder(type)))
                .toList();

            validatorsMap.put(type, steps);
        }
    }

    public void validate(PaymentRequest request) {
        List<PaymentValidationStep> steps = validatorsMap.get(request.getPaymentType());
        if (steps == null || steps.isEmpty()) {
            throw new IllegalArgumentException("No validators found for " + request.getPaymentType());
        }

        for (PaymentValidationStep step : steps) {
            step.validate(request);
        }
    }
}
```

#### `PaymentController.java`

```java
@RestController
@RequestMapping("/api/payments")
public class PaymentController {

    private final PaymentValidatorService validatorService;

    public PaymentController(PaymentValidatorService validatorService) {
        this.validatorService = validatorService;
    }

    @PostMapping("/validate")
    public ResponseEntity<String> validate(@RequestBody PaymentRequest request) {
        validatorService.validate(request);
        return ResponseEntity.ok("Validation completed for " + request.getPaymentType());
    }
}
```

#### `PaymentValidationApplication.java`

```java
@SpringBootApplication
public class PaymentValidationApplication {
    public static void main(String[] args) {
        SpringApplication.run(PaymentValidationApplication.class, args);
    }
}
```

#### Example Request (POST)

**POST** `/api/payments/validate`

```json
{
  "paymentType": "CREDIT_CARD",
  "accountId": "12345",
  "amount": 250.0,
  "cardNumber": "4111111111111111"
}
```

**Console Output**

```
Balance check for 12345
Card expiry check for card: 4111111111111111
```
