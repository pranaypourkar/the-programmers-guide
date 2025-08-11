# What is an API ?

## About

An **API (Application Programming Interface)** is a **contract or interface** that allows **two software systems to communicate** with each other. It defines a set of **rules and protocols** that one system can use to request data or perform actions in another system.

In simple terms, an API allows a client (like a mobile app or web frontend) to **talk to** a server, service, or another application—**without knowing how it works internally**.

{% hint style="success" %}
* The component that **exposes** the API is called the **provider**.
* The component that **uses** the API is called the **consumer**.
{% endhint %}

## What Makes Up an API?

An API is not just a single endpoint—it’s a complete contract made up of various components that **define communication rules** between systems. Here’s a breakdown of what’s typically included in an API:

#### 1. **Endpoints**

* These are the **URLs** that define access points to resources.
* Example: `/api/users`, `/api/orders/{id}`.
* Each endpoint is associated with a particular action or resource.

#### 2. **HTTP Methods (Verbs)**

* Determine the **action** to perform on a resource:
  * `GET` – Read data
  * `POST` – Create new data
  * `PUT/PATCH` – Update existing data
  * `DELETE` – Remove data

#### 3. **Headers**

* Provide **metadata** for both requests and responses.
* Examples:
  * `Authorization: Bearer <token>` (for security)
  * `Content-Type: application/json`

#### 4. **Request Parameters**

* Can be in the **query string**, **path**, or **body**:
  * **Path Parameter**: `/users/{id}`
  * **Query Parameter**: `/users?role=admin`
  * **Body**: `{ "name": "Alice", "age": 30 }`

#### 5. **Response**

* The data returned from the API.
* Usually in **JSON** format, containing either the requested data or error details.
* Always includes an **HTTP status code** like `200 OK`, `404 Not Found`, or `500 Internal Server Error`.

#### 6. **Authentication Mechanisms**

* APIs often require tokens, API keys, or other credentials to validate the caller.
* These ensure **only authorized clients** can access or modify data.

## Why do we need APIs?

APIs are essential for **building flexible, scalable, and connected software systems**. Here's why they matter:

#### 1. **Separation of Concerns**

* Frontend and backend teams can work independently.
* You don’t need to expose internal logic—just the interface.

#### 2. **Reusability**

* APIs can serve multiple consumers (e.g., mobile app, web frontend, third-party partners) using the same backend logic.

#### 3. **Security**

* APIs act as a controlled access point to your application.
* You expose only what is necessary and keep internal systems hidden.

#### 4. **Integration**

* APIs enable communication with **external services**, like:
  * Google Maps
  * Stripe (for payments)
  * Twilio (for SMS)
  * Social media platforms
* These services expose their APIs so others can build on top of them.

#### 5. **Automation**

* APIs are essential in automation pipelines, integrations, and DevOps.
* You can trigger workflows, deploy code, update systems—all without a UI.

#### 6. **Scalability**

* APIs support **stateless, scalable architecture** (especially REST).
* They enable microservices and distributed systems to interact efficiently.

## How APIs Work ?

Understanding the real working of an API helps understand what happens behind the scenes.

#### Step 1: **The Client Sends a Request**

* A mobile app, browser, or another system sends a request to the API.
* This request includes:
  * **Endpoint URL**
  * **HTTP method**
  * Optional headers, body, and parameters

#### Step 2: **API Gateway or Server Receives the Request**

* The request reaches the backend service or passes through an API Gateway (like AWS API Gateway, Kong, etc.)
* This layer handles:
  * Security (authentication/authorization)
  * Logging and rate limiting
  * Routing to the correct service

#### Step 3: **The Application Logic Executes**

* The backend code (often in Java, Python, Node.js, etc.) processes the request.
* It might:
  * Query a database
  * Perform validations
  * Call another internal service
  * Transform data

#### Step 4: **A Response Is Generated**

* The result is packaged as a response.
* It contains:
  * A **status code** (200, 400, 500, etc.)
  * A response body (usually in JSON)
  * Optional headers

#### Step 5: **Client Receives and Processes the Response**

* The client receives the response.
* It might:
  * Display the data on a screen
  * Store it locally
  * Trigger another request or action
