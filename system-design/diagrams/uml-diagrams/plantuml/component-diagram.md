# Component Diagram

## 1. Banking System

This represents a **Microservices Architecture** in a banking system.

```java
@startuml
title Banking Microservices - Component Diagram

package "Banking System" {
    [User Service] --> [Auth Service] : Authenticate User
    [User Service] --> [Account Service] : Retrieve Account Details
    [Account Service] --> [Transaction Service] : Process Transactions
    [Transaction Service] --> [Notification Service] : Send Alerts
    [Transaction Service] --> [Database] : Store Transactions
}

@enduml
```

<figure><img src="../../../../.gitbook/assets/plantuml-component-diagram-1.png" alt="" width="343"><figcaption></figcaption></figure>













