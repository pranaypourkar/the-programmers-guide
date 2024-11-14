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
