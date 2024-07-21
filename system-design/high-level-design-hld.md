# High-Level Design (HLD)

## About

High-Level Design, often referred to as macro-level design, provides an overview of the system architecture and design. It focuses on the big picture and outlines the overall structure and organization of the system.

{% hint style="info" %}
HLD is like the blueprint of a building. It provides an overall picture of what the system will look like and how it will function without going into the finer details.
{% endhint %}

## **Key Aspects**

1. **System Architecture:** Defines the overall architecture of the system, including its main components, their interactions, and how they fit together.
2. **Modules and Components:** Identifies the major modules and components within the system and their relationships.
3. **Data Flow:** Describes the flow of data between different parts of the system.
4. **Technology Stack:** Specifies the technologies, frameworks, and platforms to be used.
5. **Interfaces:** Defines the external interfaces, including APIs, user interfaces, and communication protocols.
6. **Non-Functional Requirements:** Addresses performance, scalability, security, and other non-functional aspects.

## **Purpose**

* Provides a blueprint for the system architecture.
* Facilitates communication among stakeholders by providing a high-level view.
* Serves as a foundation for detailed design and implementation.

## Example of a web-based e-commerce application

* **System Architecture:** Three-tier architecture with presentation, business logic, and data layers.
* **Modules:** User management, product catalog, shopping cart, order processing, payment gateway.
* **Data Flow:** User data flows from the presentation layer to the business logic layer and then to the data layer.
* **Technology Stack:** Frontend (React.js), Backend (Spring Boot), Database (MySQL), Hosting (AWS).
* **Interfaces:** RESTful APIs for communication between frontend and backend, payment gateway API.
* **Non-Functional Requirements:** High availability, scalability, security (SSL/TLS), performance (low latency).

