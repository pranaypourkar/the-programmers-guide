# Use Case Diagram

## About

A Use Case Diagram represents high-level system functionality and the interactions between actors (users or systems) and use cases (functionalities). It helps in understanding user requirements and system scope.

{% hint style="success" %}
Refer to the official documentation for more details - [https://plantuml.com/use-case-diagram](https://plantuml.com/use-case-diagram)
{% endhint %}

### **Key Elements**

1. **Actors**&#x20;
   * External entities (users, systems) that interact with the system.
   * Represented as stick figures.
2. **Use Cases**&#x20;
   * System functionalities represented as **ovals**.
   * Describes what the system does, **not how**.
3. **Relationships**&#x20;
   * **Association** (solid line) – Connects actors and use cases.
   * **Include** (`<<include>>`) – Reusable functionality between use cases.
   * **Extend** (`<<extend>>`) – Optional or conditional behavior.
4. **System Boundary**&#x20;
   * A rectangle that encloses all use cases within a system.

## 1. Online Shopping System

This diagram represents an **Online Shopping System** with different actors and use cases.

{% hint style="success" %}
* **Actors (`actor`)**: Represent `Customer` and `Admin`.
* **Use Cases (`(UseCase)`)**: Define system functionalities.
* **Relationships:**
  * **Direct association (`-->`)**
  * **Include (`-->`)**: `Place Order` includes `Make Payment`.
  * **Extend (`-->`)**: `Apply Discount` is optional.
{% endhint %}

```plant-uml
@startuml
title Online Shopping System - Use Case Diagram

actor Customer
actor Admin

rectangle "Online Shopping System" {
    Customer --> (Browse Items)
    Customer --> (Add to Cart)
    Customer --> (Place Order)
    (Place Order) --> (Make Payment) : includes
    (Place Order) --> (Apply Discount) : extends
    (Make Payment) --> (Send Payment Confirmation)

    Admin --> (Manage Products)
    Admin --> (View Reports)
}

@enduml
```

<figure><img src="../../../../../.gitbook/assets/plantuml-use-case-diagram-1.png" alt=""><figcaption></figcaption></figure>









