# Activity Diagram

## 1. User Registration Process

This represents the **User Registration Process** in a web application.

{% hint style="success" %}
* **Start (`start`)** and **End (`stop`)** nodes.
* **Decision (`if ... then ... else`)**: Validates user input.
* **Actions (`: ActionName;`)**: Represents different activities.
{% endhint %}

```plant-uml
@startuml
title User Registration Process - Activity Diagram

start
:User Enters Details;
if (Are details valid?) then (Yes)
    :Save to Database;
    :Send Verification Email;
    if (Email Verified?) then (Yes)
        :Activate Account;
    else (No)
        :Show Error;
    endif
else (No)
    :Show Validation Errors;
endif
stop

@enduml
```

<figure><img src="../../../../.gitbook/assets/plantuml-activity-diagram-1.png" alt=""><figcaption></figcaption></figure>









