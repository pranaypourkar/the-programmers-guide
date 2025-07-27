# Transaction Dispute

## Context

In many enterprise applications, such as payment platforms or banking systems, a **transaction dispute** can occur due to different reasons:

* Unauthorized access
* Duplicate transaction
* Product not received
* Service-related issues

Each type of dispute requires **distinct validation and handling logic**.

## Problem Statement

We receive a **dispute type** as an `enum` from a request parameter in a REST controller. We want to:

* Route this enum to the correct validation strategy (bean)
* Call its `validateDispute()` method
* Avoid large if-else or switch-case blocks

## Design Solution

This fits the **Strategy Pattern**, where:

* The `enum` acts as a **strategy key**
* Each `DisputeHandler` is a **strategy implementation**
* Spring injects the correct bean based on the enum at runtime

## Structure

#### A. Dispute Type Enum

```java
public enum DisputeType {
    UNAUTHORIZED,
    DUPLICATE,
    PRODUCT_NOT_RECEIVED,
    SERVICE_ISSUE
}
```

#### B. Strategy Interface

```java
public interface DisputeHandler {
    void validateDispute(Transaction transaction);
    DisputeType getSupportedType();
}
```

#### C. Implementations

```java
@Component
public class UnauthorizedDisputeHandler implements DisputeHandler {

    @Override
    public void validateDispute(Transaction transaction) {
        // Logic for unauthorized dispute
    }

    @Override
    public DisputeType getSupportedType() {
        return DisputeType.UNAUTHORIZED;
    }
}
```

Repeat similar beans for other dispute types.

#### D. Strategy Resolver Using Enum Map

```java
@Service
public class DisputeValidationService {

    private final Map<DisputeType, DisputeHandler> handlerMap;

    @Autowired
    public DisputeValidationService(List<DisputeHandler> handlers) {
        this.handlerMap = handlers.stream()
            .collect(Collectors.toMap(DisputeHandler::getSupportedType, Function.identity()));
    }

    public void validateDispute(DisputeType type, Transaction txn) {
        DisputeHandler handler = handlerMap.get(type);
        if (handler == null) {
            throw new IllegalArgumentException("Unsupported dispute type: " + type);
        }
        handler.validateDispute(txn);
    }
}
```

#### E. Controller Layer

```java
@RestController
@RequestMapping("/api/disputes")
public class DisputeController {

    private final DisputeValidationService disputeService;

    public DisputeController(DisputeValidationService disputeService) {
        this.disputeService = disputeService;
    }

    @PostMapping("/validate")
    public ResponseEntity<Void> validate(
        @RequestParam DisputeType type,
        @RequestBody Transaction transaction
    ) {
        disputeService.validateDispute(type, transaction);
        return ResponseEntity.ok().build();
    }
}
```
