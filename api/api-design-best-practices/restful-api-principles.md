# RESTful API Principles

## About

REST (Representational State Transfer) is an architectural style used for designing networked applications. RESTful APIs follow a set of well-defined principles to ensure scalability, maintainability, and interoperability. Following are the key principles which a RESTful API follows -

* Client-Server Architecture
* Statelessness
* Cacheability
* Uniform Interface
* Layered System
* Code on Demand (Optional Principle)

## **Why These Principles Matter ?**

* **Scalability** – Stateless architecture and caching allow APIs to handle high loads.
* **Performance** – Layered architecture and caching improve speed.
* **Flexibility** – RESTful APIs work with different clients (web, mobile, IoT).
* **Security** – Statelessness and authentication mechanisms enhance security.

## **1. Client-Server Architecture**

REST follows a **client-server model**, where the **client** (frontend, mobile app, or another service) and the **server**(backend) are separate entities that communicate via HTTP.

### **Importance**

* **Separation of concerns** – UI (client) and data storage (server) operate independently.
* The **client** does not need to know the internal workings of the **server** and vice versa.
* This allows different clients (web, mobile, IoT) to interact with the same API.

### **Example**

A **mobile app (client)** requests a user profile from the **server**, and the server responds with JSON data.

```
GET /users/123  
Host: api.example.com  
Authorization: Bearer <token>
```

## **2. Statelessness**

RESTful APIs must be **stateless**, meaning each request from a client to the server **must contain all the information needed** to understand and process the request. The server **does not store session state** between requests.

### **Importance**

* Makes APIs **scalable** – any server instance can handle any request.
* Reduces **memory usage** on the server since no client session is stored.
* Improves **reliability** – no session persistence means fewer failures due to state issues.

### **Example**

**Bad Approach: Storing state on the server**

* A login request is made, and the server stores the user session.
* The client sends requests without authentication because the server maintains the session.

**Good Approach: Stateless authentication**

* Every request contains authentication credentials (e.g., JWT token).
* The server processes each request independently.

```
GET /orders/123  
Authorization: Bearer <JWT-TOKEN>
```

## **3. Cacheability**

RESTful APIs **should allow caching** to improve performance and reduce unnecessary load on the server. Responses must include cache control mechanisms.

### **Importance**

* **Reduces latency** – clients can store and reuse responses instead of making redundant requests.
* **Optimizes server performance** – decreases load on backend servers.
* **Enhances scalability** – fewer API calls mean a more efficient system.

### **Example**

**Using Cache-Control Headers:**

```
GET /products  
Cache-Control: max-age=3600, public  
```

* `max-age=3600`: The response is valid for **one hour**.
* `public`: Can be cached by proxies and browsers.

**E-Tag for Conditional Requests:**

```
GET /products  
ETag: "123abc"
```

* On the next request, the client sends `If-None-Match: "123abc"` to check if data changed.
* The server responds with **304 Not Modified** if the data is unchanged, saving bandwidth.

### **4. Uniform Interface**

A REST API should have a **consistent and uniform** way of interacting with resources, following common HTTP conventions.

### **Importance**

1. **Resource-Based URLs** – APIs should expose data as **resources** using meaningful URLs.
2. **Standard HTTP Methods** – CRUD operations should follow HTTP standards.
3. **Self-Descriptive Messages** – Responses must be easy to understand.
4. **HATEOAS (Hypermedia as the Engine of Application State)** – APIs should provide links to related resources.

### **Example**

**Good API Design (Meaningful & Consistent URLs)**

```
GET /users/123       # Get user details  
POST /users          # Create a new user  
PUT /users/123       # Update user details  
DELETE /users/123    # Delete user  
```

**Bad API Design (Non-Standard & Unclear)**

```
GET /getUser?id=123  
POST /createUser  
PUT /modifyUser?id=123  
DELETE /removeUser/123  
```

## **5. Layered System**

A RESTful API should be designed in **layers**, where each layer provides specific functionality **without the client needing to know its internal structure**.

### **Importance**

* **Enhances scalability** – APIs can be distributed across multiple layers.
* **Improves security** – Certain layers can enforce authentication and logging.
* **Supports load balancing** – Different layers can handle different tasks (e.g., caching, business logic, authentication).

### **Example**

<table data-header-hidden><thead><tr><th width="249"></th><th></th></tr></thead><tbody><tr><td><strong>Layer</strong></td><td><strong>Function</strong></td></tr><tr><td><strong>Client</strong></td><td>Mobile app, web app, or third-party service</td></tr><tr><td><strong>API Gateway</strong></td><td>Handles authentication, rate limiting, and routing</td></tr><tr><td><strong>Business Logic Layer</strong></td><td>Processes API requests and interacts with the database</td></tr><tr><td><strong>Database Layer</strong></td><td>Stores and retrieves data</td></tr></tbody></table>

A client calling `/users/123` does not need to know whether the request is handled by a **single server, a microservice, or a distributed system**.

## **6. Code on Demand (Optional Principle)**

A REST API **can return executable code** to the client **on demand**, such as JavaScript or mobile scripts.

### **Importance**

* Enables **dynamic client behavior** (e.g., returning UI components in APIs).
* Reduces the need for frequent API requests.

### **Example**

A REST API can return JavaScript code that **renders dynamic UI components** in a web app.

However, **most RESTful APIs do not implement this principle**, as it introduces security risks.

## Comparison

<table data-header-hidden data-full-width="true"><thead><tr><th></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Principle</strong></td><td><strong>Purpose</strong></td><td><strong>Key Benefit</strong></td></tr><tr><td><strong>Client-Server</strong></td><td>Separates UI and business logic</td><td>Scalable and modular design</td></tr><tr><td><strong>Statelessness</strong></td><td>No session state on the server</td><td>More scalable and reliable</td></tr><tr><td><strong>Cacheability</strong></td><td>Responses can be cached</td><td>Improves performance</td></tr><tr><td><strong>Uniform Interface</strong></td><td>Consistent API interactions</td><td>Predictable and easy to use</td></tr><tr><td><strong>Layered System</strong></td><td>Separation of concerns</td><td>Supports scalability and security</td></tr><tr><td><strong>Code on Demand (Optional)</strong></td><td>Sends executable code to the client</td><td>Enhances flexibility (rarely used)</td></tr></tbody></table>

