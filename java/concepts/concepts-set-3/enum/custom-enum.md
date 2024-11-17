# Custom Enum

## About

A **Custom Enum** is an enum that we define yourself in a project to fit our own specific needs. We can add fields, methods, and constructors to an enum to expand its capabilities, making it  powerful and functional beyond just a list of constants.

## Adding Fields and Methods to a Custom Enum

Custom enums can contain instance variables, constructors, and methods, enabling them to store and manipulate additional data.

### Example of a Custom Enum with Fields and Methods

```java
public enum ProductType {
    PREPAID_CARD("prepaid-card", "A prepaid card"),
    CREDIT_CARD("credit-card", "A credit card"),
    DEBIT_CARD("debit-card", "A debit card");

    private String code;
    private String description;

    ProductType(String code, String description) {
        this.code = code;
        this.description = description;
    }

    public String getCode() {
        return code;
    }

    public String getDescription() {
        return description;
    }

    public static ProductType fromCode(String code) {
        for (ProductType type : ProductType.values()) {
            if (type.code.equals(code)) {
                return type;
            }
        }
        throw new IllegalArgumentException("Unknown code: " + code);
    }
}
```

#### Usage of Custom Enum

In this example, `ProductType` stores a `code` and `description` for each constant

```java
ProductType type = ProductType.fromCode("prepaid-card");
System.out.println(type.getDescription()); // Output: A prepaid card
```

## Examples

### Payment Confirmation Status

_PaymentConfirmationStatus.java_

```java
package sample.enums;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

/**
 * The status of the confirmation.
 */
public enum PaymentConfirmationStatus {

    CONFIRMED("CONFIRMED"),

    PENDING("PENDING"),

    USER_DECLINED("USER DECLINED"),

    SYSTEM_DECLINED("SYSTEM DECLINED"),

    ERROR("ERROR");

    private String value;

    PaymentConfirmationStatus(String value) {
        this.value = value;
    }

    @JsonValue
    public String getValue() {
        return value;
    }

    @Override
    public String toString() {
        return String.valueOf(value);
    }

    @JsonCreator
    public static PaymentConfirmationStatus fromValue(String value) {
        for (PaymentConfirmationStatus b : PaymentConfirmationStatus.values()) {
            if (b.value.equals(value)) {
                return b;
            }
        }
        throw new IllegalArgumentException("Unexpected value '" + value + "'");
    }
}
```

{% hint style="success" %}
```
Add below dependency for jackson annotation
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-annotations</artifactId>
    <version>2.16.1</version>
</dependency>
```
{% endhint %}

### Validation Enum

_ValidationResult.java_

```java
package sample.enums;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import sample.model.ValidationResponse;

@Getter
@RequiredArgsConstructor
public enum ValidationResult {


    PASSED(Result.PASSED, "Provided value(s) are unique", "000"),
    REJECTED_NAME(Result.REJECTED, "The name is already used. Please use another", "001"),
    REJECTED_ID(Result.REJECTED, "Enter a valid ID number", "002");

    private final Result result;
    private final String message;
    private final String key;

    public ValidationResponse toHttpResponse() {
        return new ValidationResponse().result(result.name()).message(message).key(key);
    }

    public enum Result {
        PASSED, REJECTED
    }
}
```

### Version Type

_VersionType.java_

```java
package sample.enums;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

public enum VersionType {
  
    _1_0_0("1.0.0"),
    _2_0_0("2.0.0");

    private String value;

    VersionType(String value) {
        this.value = value;
    }

    @JsonValue
    public String getValue() {
        return value;
    }

    @Override
    public String toString() {
        return String.valueOf(value);
    }

    @JsonCreator
    public static VersionType fromValue(String value) {
        for (VersionType b : VersionType.values()) {
            if (b.value.equals(value)) {
                return b;
            }
        }
        throw new IllegalArgumentException("Unexpected value '" + value + "'");
    }
}
```

### Yes or No Flag

_YesNoFlagType.java_

```java
package sample.enums;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

/**
 * Flag indicating if a specific option is enabled or disabled with possible supported values. 
 */
public enum YesNoFlagType {
  
    Y("Y"),
    
    N("N");
  
    private String value;
  
    YesNoFlagType(String value) {
        this.value = value;
    }
  
    @JsonValue
    public String getValue() {
        return value;
    }
  
    @Override
    public String toString() {
        return String.valueOf(value);
    }
  
    @JsonCreator
    public static YesNoFlagType fromValue(String value) {
        for (YesNoFlagType b : YesNoFlagType.values()) {
            if (b.value.equals(value)) {
                return b;
            }
        }
        throw new IllegalArgumentException("Unexpected value '" + value + "'");
    }
}
```

### **Multi-stage order processing system**

**OrderState Enum**: The `OrderState` enum defines multiple states for an order, such as `RECEIVED`, `PROCESSING`, `SHIPPED`, `DELIVERED`, and `COMPLETED`. Each enum constant has a stage number (`int stage`), which allows us to track the order's progress. Every state has a behavior defined in the `handleOrder` method. This method is abstract in the enum and is overridden in each state to handle the order’s transition logic. `OrderState` is a **polymorphic enum**. The method `handleOrder` is defined for each state, allowing us to change the order's state and behavior dynamically. The enum constants (`RECEIVED`, `PROCESSING`, etc.) override the abstract method to define their specific behavior. `validTransitions` is an `EnumMap` used to store valid transitions between states. For instance, an order can only go from `RECEIVED` to `PROCESSING`, from `PROCESSING` to `SHIPPED`, etc. The `isTransitionValid` static method checks if a state transition is allowed based on the current and next states.

_OrderState.java_

```java
package sample;

import java.util.EnumMap;
import java.util.EnumSet;

public enum OrderState {
    RECEIVED(1) {
        @Override
        public void handleOrder(Order order) {
            System.out.println("Order " + order.getId() + " received.");
            order.setState(PROCESSING);
        }
    },
    PROCESSING(2) {
        @Override
        public void handleOrder(Order order) {
            System.out.println("Processing order " + order.getId() + "...");
            // Simulate some process time
            order.setState(SHIPPED);
        }
    },
    SHIPPED(3) {
        @Override
        public void handleOrder(Order order) {
            System.out.println("Order " + order.getId() + " shipped.");
            order.setState(DELIVERED);
        }
    },
    DELIVERED(4) {
        @Override
        public void handleOrder(Order order) {
            System.out.println("Order " + order.getId() + " delivered.");
            order.setState(COMPLETED);
        }
    },
    COMPLETED(5) {
        @Override
        public void handleOrder(Order order) {
            System.out.println("Order " + order.getId() + " completed.");
        }
    };

    private final int stage;

    // Constructor to initialize the enum with an additional field
    OrderState(int stage) {
        this.stage = stage;
    }

    public int getStage() {
        return stage;
    }

    // Abstract method that each state must implement
    public abstract void handleOrder(Order order);

    // Transition map to allow direct state transitions (for advanced use cases)
    private static final EnumMap<OrderState, EnumSet<OrderState>> validTransitions = new EnumMap<>(
        OrderState.class);

    static {
        validTransitions.put(RECEIVED, EnumSet.of(PROCESSING));
        validTransitions.put(PROCESSING, EnumSet.of(SHIPPED));
        validTransitions.put(SHIPPED, EnumSet.of(DELIVERED));
        validTransitions.put(DELIVERED, EnumSet.of(COMPLETED));
        validTransitions.put(COMPLETED, EnumSet.noneOf(OrderState.class));
    }

    public static boolean isTransitionValid(OrderState fromState, OrderState toState) {
        return validTransitions.get(fromState).contains(toState);
    }
}
```

**Order Class**: The `Order` class holds an `OrderState` and provides a method (`setState`) to change the state. The `setState` method ensures that only valid state transitions are allowed using `isTransitionValid`. If a transition is invalid (e.g., trying to go backward in the state machine), it prints a message and does not update the state.

_Order.java_

```java
package sample;

import lombok.Getter;

@Getter
public class Order {
    private final String id;
    private OrderState state;

    public Order(String id) {
        this.id = id;
        this.state = OrderState.RECEIVED; // Initially in 'RECEIVED' state
    }

    public void setState(OrderState state) {
        if (OrderState.isTransitionValid(this.state, state)) {
            this.state = state;
            this.state.handleOrder(this);
        } else {
            System.out.println("Invalid state transition: " + this.state + " -> " + state);
        }
    }
}
```

_OrderProcessingSystem.java_

```java
package sample;

public class OrderProcessingSystem {

    public static void main(String[] args) {
        // Create an order with ID 12345
        Order order = new Order("12345");

        // Print the current state of the order
        System.out.println("Initial Order State: " + order.getState());

        // Simulate state transitions using the handleOrder logic
        order.setState(OrderState.PROCESSING);  // Should transition to PROCESSING
        order.setState(OrderState.SHIPPED);     // Should transition to SHIPPED
        order.setState(OrderState.DELIVERED);   // Should transition to DELIVERED
        order.setState(OrderState.COMPLETED);   // Should transition to COMPLETED

        // Try invalid transition (e.g., from DELIVERED to PROCESSING)
        order.setState(OrderState.PROCESSING);  // Invalid transition from DELIVERED to PROCESSING
    }
}
```

