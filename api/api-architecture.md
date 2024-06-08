# API Architecture

## What is API Architecture?

API architecture refers to the high-level design principles that govern how an API is structured, organized and interacts with other components within a system or between different systems. It defines how data flows within the API system, ensuring functionality, scalability, and maintainability. Choosing the right architecture depends on factors like the API's complexity, scalability needs, and performance requirements.



## Different API Architectures

Below are some common API architectures -&#x20;

### **Monolithic Architecture**

#### **Description**

* In a monolithic architecture, all components of an application are tightly integrated into a single codebase and deployed as a single unit.
* APIs in a monolithic architecture are typically implemented as internal libraries or modules within the application, allowing different parts of the application to communicate directly with each other.
* While monolithic architectures are straightforward to develop and deploy, they can become difficult to maintain and scale as the application grows in size and complexity.

#### Components of Monolithic Architecture <a href="#undefined" id="undefined"></a>

The entire programme is developed as a single unit in a monolithic design, making it very simple to develop and deploy, especially for smaller projects. The following are the main components of a monolithic architecture:

* **Single Codebase:** The entire application is written and maintained as a single codebase in a monolithic architecture. This contains all of the application's modules, functionalities, and features.
* **Presentation Layer:** The user interface (UI) and user interaction are taken care of by this layer. It consists of elements that render HTML, handle user inputs, and present data to users.
* **Business Logic Layer:** The business logic layer comprises the application's basic functionality and rules. It includes the processing, calculations, and operations that define the behaviour of the application.
* **Data Access Layer:** This layer is in charge of communicating with the database or data storage. It has parts that control database connections, run queries, and obtain or update data.
* **Database:** The monolithic architecture typically stores all application data in a single database instance. This core database is accessible by the application's many components to read and write data.
* **Integration Layer:  I**ntegration layer handles the interactions to communicate with external systems or services. This can involve connecting to third-party APIs, services, or other software components.
* **Security and Authentication:** Monolithic architectures use a centralised approach to security and authentication.

<figure><img src="../.gitbook/assets/image (62).png" alt="" width="563"><figcaption></figcaption></figure>



### **Service-Oriented Architecture (SOA)**

#### **Description**

* SOA is an architectural style where an application is composed of loosely coupled and independently deployable services that communicate with each other over a network.
* APIs in an SOA are typically exposed as interfaces to these services, allowing clients to interact with specific functionalities or business logic provided by each service.
* SOA promotes reusability, scalability, and flexibility by breaking down complex applications into smaller, manageable services that can be developed, deployed, and maintained independently.

#### Components of SOA <a href="#undefined" id="undefined"></a>

SOA consists of several essential components that collaborate to establish a flexible and modular software structure. These components enable the creation, deployment, and interaction of services within the SOA framework.

Here are the main components of SOA:

* **Services:** Services serve as the foundational units of SOA, encapsulating distinct functionalities or business logic. Services are designed to be reusable, self-contained, and modular.
* **Service Provider:** The role of the service provider involves crafting, implementing, and hosting services. It exposes the service's functionality through well-defined interfaces.
* **Service Consumer:** The service consumer refers to a client application that solicits and utilizes services. It interacts with services using their published interfaces.
* **Service Registry:** The service registry acts as a repository where descriptions and metadata of services are stored. This allows service consumers to discover available services along with their particulars.
* **Service Contract:** A service contract outlines the agreements, regulations, and specifications adhered to by both the service provider and the consumer. It encompasses information about the service's inputs, outputs, and behaviour.
* **Service Interface:** The service interface delineates the methods, operations, and parameters that clients can employ to interact with the service. It defines how a service can be invoked.
* **Security and Governance:** SOA components often integrate security measures and governance policies to ensure secure and compliant interactions between services.
* **Enterprise Service Bus (ESB):** An ESB is a middleware solution that facilitates communication, mediation, and integration among diverse services.

<figure><img src="../.gitbook/assets/image (65).png" alt="" width="454"><figcaption></figcaption></figure>



### **Microservices Architecture**

#### **Description**

* Microservices architecture is an extension of SOA, where services are further decomposed into smaller, more focused units called microservices.
* Each microservice in a microservices architecture is responsible for a specific business capability and can be developed, deployed, and scaled independently.
* APIs in a microservices architecture are typically exposed as endpoints for each microservice, allowing clients to interact with individual services via HTTP, RPC, or messaging protocols.
* Microservices architecture enables agility, resilience, and scalability by facilitating rapid development, deployment, and evolution of software systems.

#### Components of Microservice Architecture <a href="#undefined" id="undefined"></a>

Microservice architecture comprises several essential components that collaboratively establish a modular and distributed system. These components facilitate the creation, deployment, and operation of individual microservices within the architecture.

Here are the primary components of Microservice architecture:

* **Microservices:** The foundation of the architecture, microservices are distinct building blocks, each encapsulating a specific business capability or function.
* **Service Registry:** Serving as a central directory, the service registry enables microservices to register themselves, simplifying the discovery and interaction with other services.
* **API Gateway:** The API gateway acts as the primary entry point for external clients to access microservices. It offers a unified interface, manages authentication, and enforces security policies.
* **Service Discovery:** Facilitating the location of microservices within the system, service discovery is vital for dynamic environments where services can be added, removed, or relocated.
* **Load Balancing:** Load balancers distribute incoming traffic across multiple instances of a microservice, optimizing resource utilization and responsiveness.
* **Centralized Configuration:** A centralized configuration management system enables microservices to access configuration settings from a single source, enhancing consistency and manageability.
* **Database Per Service:** Each microservice can possess its database, ensuring data isolation and enabling efficient data management.
* **Event Bus / Message Broker:** The event bus or message broker facilitates asynchronous communication between microservices, enabling event-driven architecture and reducing coupling.
* **Caching:** Implementation of caching mechanisms stores frequently accessed data, reducing redundant processing needs.
* **Monitoring and Logging:** Microservices generate logs and metrics for monitoring. Centralized monitoring tools aid in tracking service health and performance.
* **Containerization / Orchestration:** Utilizing container technologies like Docker and orchestration platforms such as Kubernetes offers deployment and scaling capabilities for microservices.
* **Security and Identity Management:** Ensuring security measures like authentication and authorization safeguards microservices and enforces appropriate access controls.
* **Resilience and Circuit Breakers:** Techniques like circuit breakers and fault tolerance mechanisms enhance architecture resilience against failures.
* **Continuous Integration and Deployment (CI/CD):** Automation tools facilitate continuous integration, testing, and deployment, enabling swift microservice updates.
* **Development and Testing Tools:** Tools aiding microservice creation, testing, and debugging are pivotal for efficient development processes.



<figure><img src="../.gitbook/assets/image (63).png" alt="" width="563"><figcaption></figcaption></figure>

#### Microservices Architecture vs Service-Oriented Architecture (SOA)

<table data-full-width="true"><thead><tr><th>Feature</th><th>Service-Oriented Architecture (SOA)</th><th>Microservices Architecture</th></tr></thead><tbody><tr><td><strong>Scope</strong></td><td>Typically larger in scope, aiming for enterprise-wide integration of services</td><td>Typically smaller in scope, focusing on single business capabilities or functions</td></tr><tr><td><strong>Service Size</strong></td><td>Services tend to be larger and more monolithic, encapsulating multiple functionalities</td><td>Services are smaller and more focused, encapsulating single business capabilities</td></tr><tr><td><strong>Communication Protocol</strong></td><td>Often relies on standardized protocols like SOAP, XML-RPC</td><td>Often uses lightweight protocols like HTTP/REST or messaging systems</td></tr><tr><td><strong>Data Management</strong></td><td>Shared data models and centralized data stores may be common</td><td>Each microservice manages its own data, with decentralized data stores</td></tr><tr><td><strong>Deployment</strong></td><td>Services may be deployed independently, but upgrades may require coordination</td><td>Each microservice is deployed independently, enabling faster deployments and updates</td></tr><tr><td><strong>Scaling</strong></td><td>Scaling often involves scaling entire services</td><td>Scaling can be more granular, scaling individual microservices as needed</td></tr><tr><td><strong>Dependencies</strong></td><td>Services may have complex interdependencies, leading to coupling</td><td>Microservices aim for loose coupling, with each service responsible for its own dependencies</td></tr><tr><td><strong>Governance</strong></td><td>Centralized governance and management of services may be required</td><td>Decentralized governance with teams responsible for their own microservices</td></tr><tr><td><strong>Flexibility</strong></td><td>May be less flexible due to tight coupling between services</td><td>Offers greater flexibility due to loose coupling and smaller service size</td></tr><tr><td><strong>Development Teams</strong></td><td>Cross-functional teams may be responsible for developing and maintaining services</td><td>Individual teams are responsible for developing and maintaining microservices</td></tr><tr><td><strong>Tooling</strong></td><td>Often requires specialized middleware and enterprise service buses (ESBs)</td><td>Relies on lightweight tools and frameworks for development, deployment, and monitoring</td></tr></tbody></table>



### **Event Driven Architecture (EDA)**

* EDA is an architectural pattern where components communicate with each other by producing and consuming events asynchronously.
* APIs in an event-driven architecture are designed to facilitate event propagation, handling, and processing across different components or services.
* Event-driven APIs often include event schemas, topics, and subscriptions that govern how events are produced, consumed, and processed by different parts of the system.
* EDA enables loosely coupled, scalable, and responsive systems by allowing components to react to events and trigger actions independently.

#### Components of Event Driven Architecture <a href="#undefined" id="undefined"></a>

* **Event Sources**: Event sources generate events that represent changes in the system's state or triggers for actions. These sources can include user interactions, system events, sensors, external APIs, or other services.
* **Event Bus/Message Broker**: The event bus or message broker serves as a central hub for distributing events to interested consumers. It decouples event producers from event consumers and ensures reliable event delivery through various messaging patterns like publish-subscribe (pub/sub) or message queuing.
* **Event Consumers**: Event consumers subscribe to specific types of events on the event bus and respond accordingly. They can include microservices, functions, or components that react to events by performing actions, updating state, or triggering further events.
* **Event Processors/Handlers**: Event processors or handlers are responsible for processing incoming events, performing business logic, and updating application state as needed. They can be simple functions or services that execute specific tasks in response to events.
* **Event Stores**: Event stores capture and persist event data for auditing, analysis, or replayability. They provide a historical record of all events that have occurred in the system and enable features like event sourcing and event-driven architectures.
* **Event Sinks**: Event sinks are endpoints or destinations where processed events are sent for further processing, storage, or analysis. They can include databases, data warehouses, analytics platforms, or other downstream systems that consume event data.
* **Event-driven Communication**: Event-driven communication enables asynchronous, loosely coupled interactions between system components. It allows components to react to events in real-time, scale independently, and evolve without tight dependencies.

<figure><img src="../.gitbook/assets/image (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>



### **Serverless Architecture**

* Serverless architecture is a cloud computing model where applications are built and deployed as a set of stateless functions (serverless functions) that are executed in response to events or triggers.
* APIs in a serverless architecture are often implemented as serverless functions exposed via API gateways, allowing clients to invoke specific functions over HTTP or other protocols.
* Serverless architecture abstracts away infrastructure management, enabling developers to focus on writing code and building applications without worrying about provisioning, scaling, or managing servers.

#### Components of **Serverless** Architecture <a href="#undefined" id="undefined"></a>

* **Serverless Functions (FaaS)**: Serverless functions, also known as Function as a Service (FaaS), are the core building blocks of a serverless architecture. These are small, stateless, and event-triggered pieces of code that run in response to specific events or requests. Examples of serverless function providers include AWS Lambda, Google Cloud Functions, and Azure Functions.
* **Event Sources**: Event sources trigger the execution of serverless functions. These can include HTTP requests, database changes, file uploads, message queue events, or scheduled events. Event sources generate events that are processed by serverless functions, leading to the execution of business logic or processing tasks.
* **API Gateway**: API Gateways provide a managed HTTP endpoint for triggering serverless functions via HTTP requests. They handle routing, request validation, authentication, and rate limiting. API Gateways enable the exposure of serverless functions as RESTful APIs, enabling integration with web applications, mobile apps, or external services.
* **Storage Services**: Storage services provide scalable and durable storage solutions for serverless applications. These can include object storage (e.g., Amazon S3, Google Cloud Storage), databases (e.g., DynamoDB, Firestore), or file systems (e.g., AWS EFS). Serverless functions often interact with storage services to store and retrieve data, such as user uploads, application state, or configuration settings.
* **Event Streams and Message Brokers**: Event streams and message brokers facilitate asynchronous communication and event-driven architectures in serverless applications. Examples include Amazon SQS, Amazon SNS, Google Cloud Pub/Sub, and Apache Kafka. They allow decoupled communication between components, enabling event-driven workflows, data processing pipelines, and event-driven microservices.
* **Authentication and Authorization Services**: Authentication and authorization services provide identity management and access control for serverless applications. These services authenticate users and control access to resources or APIs. Examples include AWS Cognito, Google Identity Platform, and Auth0, which offer features like user authentication, authorization rules, and federated identity management.
* **Monitoring and Logging Services**: Monitoring and logging services provide visibility into the performance, health, and behavior of serverless applications. They collect, analyze, and display metrics, logs, and traces generated by serverless functions and services. Examples include AWS CloudWatch, Google Cloud Monitoring, and Azure Monitor, which offer features like metrics dashboards, log aggregation, and alerting.
* **Deployment and Orchestration Tools**: Deployment and orchestration tools automate the deployment, scaling, and management of serverless applications. They streamline the development lifecycle by providing tools for packaging, deploying, and monitoring serverless functions. Examples include AWS SAM (Serverless Application Model), Serverless Framework, Terraform, and Kubernetes-based serverless platforms like AWS Fargate and Google Cloud Run.

<figure><img src="../.gitbook/assets/image (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt="" width="541"><figcaption></figcaption></figure>

