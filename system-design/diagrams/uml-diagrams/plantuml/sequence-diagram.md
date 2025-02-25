# Sequence Diagram

## 1. Fund Transfer

This sequence diagram represents a **user performing a fund transfer** in a banking system.

{% hint style="success" %}
* **Actors (`participant`)**: Represent different entities in the system.
* **Messages (`->`)**: Show interactions between entities.
* **Alternative (`alt ... else`)**: Conditional logic for valid/invalid accounts.
* **Self-calls (`->`)**: Represents internal method calls within the same participant.
{% endhint %}

```plant-uml
@startuml
title Fund Transfer Process

participant User
participant "Bank API" as BankAPI
participant "Account Service" as AccountService
participant "Transaction Service" as TransactionService
participant "Notification Service" as NotificationService

User -> BankAPI: initiateTransfer(sender, receiver, amount)
BankAPI -> AccountService: validateAccounts(sender, receiver)
AccountService -> BankAPI: return validation result

alt if accounts are valid
    BankAPI -> TransactionService: processTransaction(sender, receiver, amount)
    TransactionService -> AccountService: debit(sender, amount)
    TransactionService -> AccountService: credit(receiver, amount)
    TransactionService -> BankAPI: transaction success

    BankAPI -> NotificationService: sendTransferNotification(sender, receiver)
    NotificationService -> User: notify transaction success
else if accounts are invalid
    BankAPI -> User: notify validation failure
end

@enduml
```

<figure><img src="../../../../.gitbook/assets/plantuml-sequence-diagram-1.png" alt=""><figcaption></figcaption></figure>



