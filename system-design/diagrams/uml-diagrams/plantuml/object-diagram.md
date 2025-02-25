# Object Diagram

## 1. E-commerce system

This represents the **state of objects at runtime** in an e-commerce system.

{% hint style="success" %}
* **Objects (`object ObjectName { }`)**.
* **Relationships (`--`)**: Shows how objects are related at runtime.
{% endhint %}

```plant-uml
@startuml
title E-Commerce Order - Object Diagram

object Customer {
    name = "John Doe"
    email = "john@example.com"
}

object Order {
    orderId = 12345
    totalAmount = 150.00
}

object Product {
    name = "Laptop"
    price = 1500.00
}

Customer -- Order : places
Order -- Product : contains

@enduml
```

<figure><img src="../../../../.gitbook/assets/plantuml-object-diagram-1.png" alt="" width="246"><figcaption></figcaption></figure>









