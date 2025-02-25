# Deployment Diagram

## 1. Web Application Deployment

This represents a **Web Application Deployment** with multiple nodes (web server, app server, database).

{% hint style="success" %}
* **Nodes (`node "Name" { }`)**: Represents physical/virtual machines.
* **Components (`[Component]`)**: Represents deployed components.
* **Connections (`-->`)**: Shows data flow.
{% endhint %}

```plant-uml
@startuml
title Web Application Deployment

node "User" {
    [Browser]
}

node "Web Server" {
    [Nginx]
}

node "Application Server" {
    [Spring Boot App]
}

node "Database Server" {
    [PostgreSQL]
}

Browser --> Nginx : HTTP Request
Nginx --> "Spring Boot App" : Forward Request
"Spring Boot App" --> PostgreSQL : Query Data
PostgreSQL --> "Spring Boot App" : Return Data
"Spring Boot App" --> Browser : Render Response

@enduml
```

<figure><img src="../../../../.gitbook/assets/plantuml-deployment-diagram-1.png" alt="" width="314"><figcaption></figcaption></figure>









