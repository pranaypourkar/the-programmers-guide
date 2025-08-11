# Types of API

## About

APIs come in various types based on **who can access them**, **how they are used**, and **what protocols or architecture they follow**. Understanding these categories helps in selecting the right kind of API for our system architecture or integration needs.

We can organize API types into three broad categories

## 1. Based on **Access Scope**

This classification focuses on **who can access the API** and how openly it's shared. It’s important because access control defines security, business reach, and integration possibilities.

### a. **Open APIs (Public APIs)**

Open APIs are **available to any external developer or user**. They are published publicly and are designed to be used beyond the internal organization—either freely or with some access control like API keys or rate limits.

**Use Cases**

* Letting developers integrate our product into theirs (e.g., embedding Google Maps).
* Building a developer ecosystem around our product.
* Enabling integrations across platforms.

**Examples**

* Google Maps API
* Twitter API
* OpenWeather API

**Key Points**

* Often have **developer portals**, SDKs, and documentation.
* May require an API key or OAuth for rate-limited usage.
* Typically monitored and versioned carefully to support external dependencies.

**Benefits**

* Encourages adoption of your platform.
* Supports third-party innovation.
* Drives business growth through exposure.

### b. **Internal APIs (Private APIs)**

Internal APIs are **restricted to developers within the organization**. They’re used for communication between internal systems—like between microservices or between front-end and back-end.

**Use Cases**

* Connecting internal services in a microservices architecture.
* Enabling a company’s mobile app to talk to its backend.
* Sharing data between internal business units.

**Examples**

* An HR system internally calling a payroll service.
* A dashboard accessing internal analytics APIs.

**Key Points**

* **Not exposed on the public internet**.
* Security and performance are tightly controlled.
* Can evolve faster as they don’t depend on external users.

**Benefits**

* Greater control over functionality and access.
* No public exposure, reducing attack surface.
* Promotes internal modularity and reuse.

### c. **Partner APIs**

Partner APIs are **exposed only to selected business partners or clients**. They’re not public, but they’re not limited to internal use either. Access is granted through contracts or formal agreements.

**Use Cases**

* Integrating with third-party logistics, payment processors, or data providers.
* Allowing vendors or partners to place orders or access analytics.
* Collaborative B2B integrations.

**Examples**

* A travel booking site integrating with airline APIs.
* Payment APIs shared between banks and third-party wallets.

**Key Points**

* Usually authenticated and authorized with stronger controls.
* Often tied to **SLAs (Service Level Agreements)** and access policies.
* Documentation is usually shared only with approved partners.

**Benefits**

* Enables secure external collaboration.
* Allows monetization or controlled use of services.
* Helps expand services while preserving governance.

### d. **Composite APIs**

Composite APIs **combine multiple API calls into a single request**, simplifying client-side development and improving performance. They are typically internal or partner-level APIs.

**Use Cases**

* Returning multiple pieces of related data in one API call.
* Reducing the number of network requests in mobile or low-bandwidth environments.

**Examples**

* A dashboard loading user info, recent orders, and preferences in one call.
* A mobile app requesting user profile and notifications together.

**Key Points**

* Often used in **microservices** to abstract service orchestration.
* Reduces latency and simplifies client logic.
* Can call multiple underlying services and aggregate the result.

**Benefits**

* Reduces round-trips between client and server.
* Improves performance, especially for mobile apps.
* Encapsulates complexity of multiple services.

## 2. Based on **Communication Style or Architecture**

This classification focuses on **how data is exchanged** between client and server, what protocol or design pattern the API follows, and how tightly it's coupled to the system’s architecture. This affects how flexible, scalable, and efficient your APIs are.

### a. **REST (Representational State Transfer)**

REST is an architectural style that uses standard **HTTP methods** and treats everything as a **resource**, identified by URLs. It is **stateless**, meaning each request from client to server must contain all the information the server needs.

**Key Features**

* Uses HTTP methods: `GET`, `POST`, `PUT`, `DELETE`
* Data formats: Usually JSON, sometimes XML
* Each resource has a unique URL
* Stateless: Server doesn’t store session information

**Example**

```
GET /users/123
```

Returns user details with ID 123.

**Use**

* Widely used in web services
* Used in mobile apps, SPAs (Single Page Applications)

**Benefits**

* Simple and readable
* Well-suited for web environments
* Easy to cache and scale

### b. **SOAP (Simple Object Access Protocol)**

SOAP is a **protocol**, not just a style. It uses **XML** for request and response format and follows strict standards. SOAP can run over multiple protocols like HTTP, SMTP, and more.

**Key Features**

* Uses **XML** exclusively
* Relies on WSDL (Web Services Description Language) for contracts
* Built-in support for **security**, **transaction**, and **error handling**
* Can be used over protocols beyond HTTP

**Example SOAP Request (simplified)**

```xml
<soap:Envelope>
  <soap:Body>
    <getUserDetails>
      <userId>123</userId>
    </getUserDetails>
  </soap:Body>
</soap:Envelope>
```

**Use**

* Financial, healthcare, and enterprise systems
* When contracts and reliability are essential

**Benefits**

* Standardized and robust
* Strong support for security (WS-Security)
* Good for enterprise integrations

### c. **GraphQL**

GraphQL is a **query language** and runtime developed by Facebook. It allows clients to request **exactly the data they need**, reducing over-fetching and under-fetching common in REST.

**Key Features**

* Single endpoint (unlike REST's multiple endpoints)
* Allows clients to shape the response
* Strongly typed schema
* Supports nested queries

**Example Query**

```graphql
{
  user(id: "123") {
    name
    email
    posts {
      title
    }
  }
}
```

**Use**

* Frontend-heavy applications (e.g., React apps)
* APIs used by multiple types of clients (web, mobile, smart devices)

**Benefits**

* Reduces payload size
* Flexible and efficient for front-end teams
* Better tooling (auto-complete, validation)

### d. **gRPC (Google Remote Procedure Call)**

gRPC is a **high-performance RPC (Remote Procedure Call)** framework by Google. It uses **Protocol Buffers** (a compact binary format) instead of JSON or XML for data exchange.

**Key Features**

* Contract-first: Uses `.proto` files
* Bi-directional streaming
* HTTP/2 based – supports multiplexing and compression
* Strongly typed and compiled into client/server code

**Example**\
Instead of calling `GET /user/123`, gRPC might call a method like:

```protobuf
rpc GetUser(UserRequest) returns (UserResponse);
```

**Real-World Use**

* Internal microservices communication
* Systems where performance and low-latency matter

**Benefits**

* Very fast and efficient (uses binary)
* Strong type safety and code generation
* Ideal for service-to-service communication

### e. **WebSockets**

WebSockets provide **full-duplex communication** channels over a single TCP connection, allowing **real-time, two-way** interaction between the client and server.

**Key Features**

* Maintains persistent connection
* Bi-directional and real-time
* Not stateless (unlike REST)

**Example**

* Used in chat apps, stock tickers, live dashboards

**Real-World Use**

* Live updates in UI (chat, gaming, notifications)

**Benefits**

* Real-time communication
* Reduces overhead of repeated requests

### **Quick Comparison**

<table data-full-width="true"><thead><tr><th>Feature</th><th>REST</th><th>SOAP</th><th>GraphQL</th><th>gRPC</th></tr></thead><tbody><tr><td>Protocol</td><td>HTTP</td><td>Protocol (XML over HTTP/SOAP)</td><td>HTTP</td><td>HTTP/2</td></tr><tr><td>Format</td><td>JSON (mostly)</td><td>XML</td><td>JSON</td><td>Binary (Protobuf)</td></tr><tr><td>Endpoint Style</td><td>Multiple endpoints</td><td>Single endpoint (but method-based)</td><td>Single endpoint</td><td>Single endpoint</td></tr><tr><td>Client Control</td><td>Low</td><td>Low</td><td>High</td><td>Medium</td></tr><tr><td>Performance</td><td>Medium</td><td>Low</td><td>High</td><td>Very High</td></tr><tr><td>Use Case</td><td>Web/mobile APIs</td><td>Enterprise systems</td><td>Frontend, modern apps</td><td>Microservices</td></tr></tbody></table>



## 3. Based on **Usage Environment**

This classification focuses on **where and how** the API is used. APIs are not limited to web services—they exist across operating systems, libraries, hardware, and even embedded systems. Understanding usage environments helps recognize the different roles APIs play beyond just REST or HTTP.

### a. **Web APIs**

Web APIs are APIs exposed over the **internet or intranet**, typically via **HTTP or HTTPS**. These are the most common APIs developers use for interacting with web servers, cloud services, and third-party platforms.

**Examples**

* Twitter API (for posting tweets)
* Google Maps API (for embedding maps)
* Payment gateways like Stripe or Razorpay

**Common Forms**

* RESTful APIs
* GraphQL APIs
* SOAP-based Web Services

**Use Cases**

* Mobile or web app backend integration
* Fetching data from a server
* User authentication (e.g., via OAuth)

### b. **Operating System (OS) APIs**

OS APIs allow applications to interact with **operating system services** such as file systems, memory, process management, network, and device drivers.

**Examples**

* Windows API (Win32): to manage windows, files, registry
* POSIX API: for Unix/Linux system calls
* Android SDK APIs: for accessing OS-level features in Android apps

**Use Cases**

* Creating or reading files
* Starting new processes or threads
* Accessing OS-level UI controls or notifications

### c. **Library or Framework APIs**

These are APIs provided by **programming libraries** or **frameworks** that developers use within their applications.

**Examples**

* Java Collections API (like `List`, `Map`, `Set`)
* NumPy API in Python for scientific computing
* Spring Framework APIs in Java for building web apps

**Use Cases**

* Reusing tested components
* Accelerating development with abstraction
* Adding advanced capabilities (e.g., database interaction, security)

### d. **Hardware APIs**

Hardware APIs allow software to communicate with or control **physical hardware components** like printers, sensors, cameras, GPUs, or IoT devices.

**Examples**

* GPU APIs (like CUDA, OpenCL)
* Camera API on smartphones
* USB API for external devices

**Use Cases**

* Real-time image processing using GPU
* Reading sensor data from IoT devices
* Controlling peripherals (printers, scanners, etc.)

### e. **Database APIs**

Database APIs provide methods to connect to, query, and manipulate data in databases. These abstract low-level database drivers and offer consistent APIs to developers.

**Examples**:

* JDBC (Java Database Connectivity)
* ODBC (Open Database Connectivity)
* MongoDB or Redis client APIs

**Use Cases**:

* Performing CRUD operations
* Connecting applications to relational or NoSQL databases

### f. **Embedded System APIs**

APIs in embedded systems are designed for **low-level hardware-software interaction**, often in constrained environments (limited memory, processing power).

**Examples**

* Arduino or Raspberry Pi libraries
* Real-time operating system (RTOS) APIs

**Use Cases**

* Controlling motors, sensors, LEDs
* Interfacing with custom hardware components

### g. **Remote APIs**

These are APIs that allow communication between two **separate systems or environments**, usually over a network.

**Examples**

* Remote Procedure Call (RPC) APIs
* gRPC for microservices
* SOAP-based enterprise integrations

**Use Cases**

* Communicating between distributed systems
* Cloud-to-cloud or cloud-to-client data transfer
