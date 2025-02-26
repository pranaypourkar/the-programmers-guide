# State Diagram

## About

A **State Diagram** represents an object's **lifecycle states** and transitions between them based on **events or conditions**. It helps model **real-world behaviour** of objects.

{% hint style="success" %}
Refer to the official documentation for more details - [https://plantuml.com/state-diagram](https://plantuml.com/state-diagram)
{% endhint %}

### **Key Elements**

1. **States**&#x20;
   * Represented as **rounded rectangles** (e.g., "Idle", "Processing").
2. **Transitions**&#x20;
   * Arrows indicating **state changes due to events**.
3. **Initial & Final States**&#x20;
   * **Black circle (initial state)** marks the starting point.
   * **Encircled black dot (final state)** indicates the end.
4. **Events & Conditions**&#x20;
   * Triggers for transitions (e.g., "User logs in").

## 1. User Authentication Flow

This represents a **User Authentication Flow** in a system.

{% hint style="success" %}
* **Initial State (`[*]`)** and **Transitions (`-->`)**.
* **Different States (`StateName`)**: `LoggedOut`, `LoggingIn`, etc.
* **Looping (`Retry`)**: Allows reattempting login.
{% endhint %}

```plant-uml
@startuml
title User Authentication - State Diagram

[*] --> LoggedOut

LoggedOut --> LoggingIn : User enters credentials
LoggingIn --> LoggedIn : Authentication Success
LoggingIn --> LoginFailed : Authentication Failed

LoginFailed --> LoggedOut : Retry
LoggedIn --> LoggedOut : User Logs Out
LoggedIn --> SessionExpired : Inactivity Timeout

SessionExpired --> LoggedOut

@enduml
```

<figure><img src="../../../../.gitbook/assets/plantuml-state-diagram-1.png" alt="" width="516"><figcaption></figcaption></figure>

