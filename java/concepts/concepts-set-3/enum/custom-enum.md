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

_OrderProcessingSystem.java_

```
```







