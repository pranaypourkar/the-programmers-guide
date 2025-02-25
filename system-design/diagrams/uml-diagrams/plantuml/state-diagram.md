# State Diagram

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

