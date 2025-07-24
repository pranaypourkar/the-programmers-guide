# API Testing

## About

APIs (Application Programming Interfaces) are at the heart of modern software systems. Whether it’s a frontend talking to a backend, two services in a microservices architecture, or external applications integrating with our platform, APIs need to be **correct**, **reliable**, and **secure**. To ensure this, **API testing** is critical.

API testing is a type of software testing that focuses on verifying that APIs function correctly, return expected results, handle errors gracefully, and perform under load or edge cases.

Unlike UI testing, which tests user interfaces, API testing works at the **message level** - sending HTTP requests directly to the API and checking the responses.

## Importance of API Testing

In modern software systems, APIs serve as the **backbone** of communication between services, platforms, and users. Whether it's a mobile app fetching data from a backend, or multiple services talking to each other in a microservices setup, APIs are the bridge that keeps everything connected and functioning smoothly.

If these APIs fail, the entire application or user experience can break down - even if the UI looks perfect.

#### 1. **APIs are Used by Multiple Clients**

APIs are often consumed by:

* Web frontends
* Mobile apps
* Third-party developers
* Internal services in microservices architecture

A single broken API can cause widespread failures across different parts of a system. That’s why it's important to test APIs thoroughly — they’re not isolated.

#### 2. **Helps Catch Issues Before They Reach the UI**

Unlike UI testing, API testing validates the behavior of a system **early in the development lifecycle**. It allows developers to:

* Test logic before UI is even built
* Get faster feedback on issues
* Debug directly at the communication layer

Catching bugs earlier saves time and reduces cost.

#### 3. **Validates Core Business Logic and Data Exchange**

Many APIs carry **critical business logic**, such as:

* Processing payments
* Creating user accounts
* Handling authentication

Testing ensures that:

* APIs return the correct data
* Data flows between services as expected
* Side effects (like database changes) occur correctly

#### 4. **Ensures Contract and Format Consistency**

APIs often have a defined contract (via OpenAPI or Swagger) specifying:

* Request structure
* Required fields
* Data types
* Expected response format

API testing verifies that implementations **adhere to this contract**. This helps prevent mismatches that could crash consumers or integrations.

#### 5. **Improves Confidence During Refactoring or Deployment**

When backend teams refactor code, change data models, or migrate services, untested APIs can silently break. API tests act like a **safety net** that ensures the changes:

* Don’t introduce regressions
* Still meet the original behavior and expectations

#### 6. **Supports CI/CD and Automation**

API testing is easy to **automate** and can be integrated into CI/CD pipelines. This makes it practical to:

* Run tests on every code push
* Validate environments during deployment
* Catch errors early without manual effort

#### 7. **Helps with Security and Input Validation**

Security issues often arise from poorly tested APIs. API testing can help ensure:

* Proper authentication and authorization checks
* Sensitive endpoints are protected
* Input validation prevents injections or malformed payloads

#### 8. **Reduces Production Failures and Downtime**

Since many systems rely on APIs to function, untested APIs can lead to:

* Broken features
* Data corruption
* Application crashes
* System-wide outages

Proper API testing minimizes these risks and leads to more **stable, maintainable software**.

## What do we Test in API ?

When testing an API, the goal is to verify **functionality, reliability, security, and performance** of the system at the interface level. It ensures that the API behaves as expected under different conditions — both normal and edge cases.

Below are the key aspects typically tested in an API -

#### 1. **Functionality Testing**

This verifies that the API endpoints do what they are supposed to do. It includes:

* Correct request methods (GET, POST, PUT, DELETE, etc.)
* Proper handling of input parameters and payloads
* Accurate and expected responses
* Matching status codes (e.g., 200 OK, 404 Not Found)
* Business logic validation (e.g., “create user” actually creates a user)

**Example**: If an API is supposed to return a list of users, it should not return an empty list unless no users exist.

#### 2. **Input Validation**

Test how the API handles:

* Missing or null parameters
* Invalid data types (sending string instead of number)
* Malformed JSON or XML bodies
* Extra unexpected fields

This ensures the API doesn't break or misbehave when given bad input and that it returns useful error messages.

#### 3. **Response Validation**

This includes checking:

* Structure and format of response (e.g., JSON schema)
* Correct data types and values
* Field names, nesting, and data consistency
* Headers (e.g., Content-Type)

Also, verify that the API doesn't expose sensitive data unintentionally.

#### 4. **Status Code Verification**

The API must return correct and meaningful HTTP status codes:

* 200 OK for success
* 400 Bad Request for input errors
* 401 Unauthorized for authentication failures
* 404 Not Found for missing resources
* 500 Internal Server Error when something goes wrong server-side

Improper status codes lead to confusion for API consumers and make debugging harder.

#### 5. **Authentication & Authorization**

Test that:

* Protected endpoints require authentication
* Only valid credentials allow access
* Roles and permissions are enforced (e.g., admin vs regular user)
* Tokens (JWT, API Keys) are handled properly

This ensures that only authorized users can access or modify sensitive data.

#### 6. **Error Handling**

Verify how the API responds to:

* Invalid input
* Missing fields
* Internal failures (e.g., database not reachable)
* Unsupported operations

Good APIs provide clear, consistent, and informative error messages and codes to help consumers fix issues quickly.

#### 7. **Performance Testing**

Measure how the API performs under:

* Normal load (expected traffic)
* High load (multiple requests per second)
* Stress conditions (sudden traffic spikes)

Track response times, throughput, latency, and server behavior under pressure. Identify bottlenecks and opportunities for optimization.

#### 8. **Security Testing**

Verify:

* APIs are not vulnerable to attacks (e.g., SQL injection, XSS)
* Sensitive data (passwords, tokens) is encrypted
* Rate limiting and throttling are in place to prevent abuse
* No unintended data exposure or insecure endpoints

Security is critical, especially for public or external-facing APIs.

#### 9. **Rate Limiting and Throttling**

Check if:

* API limits are enforced properly
* Repeated or abusive requests are blocked
* Proper messages are returned when rate limits are exceeded

This prevents misuse and helps protect backend resources.

#### 10. **Data Integrity and Consistency**

Test that:

* Data created or updated through APIs is stored correctly
* There are no unexpected side effects or data loss
* Duplicate entries or conflicting operations are handled gracefully

Especially important in systems that update state or interact with databases.

## Types of API Testing

API testing involves validating the behavior, performance, security, and reliability of an API. Depending on what aspect of the API we are targeting, testing can be categorized into several types. Each type serves a different purpose and helps ensure the API meets functional and non-functional requirements.

### 1. **Functional Testing**

**Purpose**: To verify that the API behaves according to business requirements and returns correct data.

**Focus**:

* Does the API return expected outputs for valid inputs?
* Does it support the expected HTTP methods (GET, POST, PUT, DELETE)?
* Are responses accurate and complete?

**Example**: Testing if `GET /users/1` returns user data for ID 1.

### 2. **Validation Testing**

**Purpose**: To verify the correctness of API responses, response structure, status codes, and headers.

**Focus**:

* Is the data type and format correct?
* Are required fields present?
* Is the status code appropriate (200, 400, 500)?
* Are headers like Content-Type correctly set?

**Example**: Ensuring a `POST /login` returns `Content-Type: application/json`.

### 3. **Load Testing**

**Purpose**: To test how the API performs under expected user loads.

**Focus**:

* How does the system behave when receiving many requests per second?
* Can it serve multiple users simultaneously without delay?

**Example**: Sending 1000 simultaneous requests to an endpoint and measuring the average response time.

### 4. **Stress Testing**

**Purpose**: To test the limits of the API and observe how it behaves under extreme load or resource shortage.

**Focus**:

* How does the API respond when overloaded?
* Does it fail gracefully or crash?

**Example**: Gradually increasing request volume until the server becomes unresponsive.

### 5. **Security Testing**

**Purpose**: To ensure the API is protected against threats and vulnerabilities.

**Focus**:

* Can unauthorized users access protected resources?
* Are inputs sanitized to prevent injection attacks?
* Are tokens and credentials securely handled?

**Example**: Testing if a user can access admin APIs without proper authentication.

### 6. **Reliability Testing**

**Purpose**: To confirm the API functions correctly over time and across repeated tests.

**Focus**:

* Can the API consistently deliver correct results during repeated or long-running tests?

**Example**: Running the same API call hourly for a day and checking for failures.

### 7. **Latency and Performance Testing**

**Purpose**: To measure response times and throughput.

**Focus**:

* How fast does the API respond?
* What is the average and worst-case response time?

**Example**: Testing an API that should respond in under 100ms.

### 8. **Integration Testing**

**Purpose**: To ensure the API works well with other components, services, or third-party APIs.

**Focus**:

* Does the API correctly call or receive responses from databases, other APIs, or services?

**Example**: Verifying that an order API integrates correctly with a payment gateway.

### 9. **Error Handling Testing**

**Purpose**: To check how the API handles invalid or unexpected input and failures.

**Focus**:

* Are proper error codes and messages returned?
* Is the system protected from crashes?

**Example**: Sending invalid JSON to an endpoint and verifying that a 400 Bad Request is returned with a helpful message.

### 10. **Regression Testing**

**Purpose**: To verify that recent code changes haven't broken existing functionality.

**Focus**:

* Does everything still work after updates or bug fixes?

**Example**: Re-running functional test cases after a new feature is added.

### 11. **Documentation Testing**

**Purpose**: To ensure API documentation (e.g., Swagger/OpenAPI) is accurate and matches actual behavior.

**Focus**:

* Do endpoints, input parameters, and responses match what is documented?

**Example**: Testing if a field marked as "required" in docs is truly required.

### 12. **Usability Testing (for APIs)**

**Purpose**: To evaluate the developer experience (DX) of using the API.

**Focus**:

* Is the API intuitive and easy to use?
* Are error messages clear?
* Is onboarding simple?

**Example**: Testing how quickly a new developer can integrate and make a working API call.

## Where API Testing Fits in the Development Lifecycle ?

API testing plays a crucial role in modern software development and is integrated throughout the development lifecycle, not just as a final step. With the rise of service-oriented architecture, microservices, and frontend-backend separation, APIs often represent the contract between systems — making their correctness and reliability essential from day one.

### **1. Requirement & Design Phase**

* **Purpose**: Define the expected API behavior, request/response structure, and data contracts before implementation.
* **Activities**:
  * Define API specifications using tools like OpenAPI (Swagger).
  * Design test cases based on API contracts (Contract Testing).
  * Start thinking about edge cases and validations.
* **Why test here**: Prevent misunderstandings and mismatched expectations between backend and frontend teams.

### **2. Development Phase**

* **Purpose**: Validate functionality as endpoints are implemented.
* **Activities**:
  * Write unit tests for individual components or methods.
  * Perform early integration testing using tools like Postman or REST Assured.
  * Use mock servers to test dependent APIs before they're ready.
* **Why test here**: Catch issues early, reduce rework, and verify each part works as it’s built.

### **3. Testing / QA Phase**

* **Purpose**: Thoroughly test the API across various types (functional, security, performance, etc.).
* **Activities**:
  * Execute automated test suites for regression and validation.
  * Perform manual exploratory testing if needed.
  * Run security, load, and reliability tests.
* **Why test here**: Ensure the API is stable, secure, and meets business needs before release.

### **4. Pre-Deployment / Staging Phase**

* **Purpose**: Simulate production-like behavior and identify environment-specific issues.
* **Activities**:
  * Test APIs in staging environments with near-real data.
  * Verify that performance SLAs are met.
  * Confirm that new changes haven’t broken existing functionality.
* **Why test here**: Prevent last-minute surprises in production and ensure the API works in realistic scenarios.

### **5. Deployment & Post-Release**

* **Purpose**: Monitor live APIs and validate runtime behavior.
* **Activities**:
  * Run smoke tests after deployment to verify basic functionality.
  * Monitor logs, errors, and response times.
  * Perform health checks and real-user monitoring (RUM).
* **Why test here**: Ensure uptime, detect issues quickly, and confirm that everything works as expected in production.

### **6. Maintenance & Continuous Delivery**

* **Purpose**: Ensure long-term stability and smooth updates.
* **Activities**:
  * Include API testing in CI/CD pipelines (automated testing on every commit).
  * Maintain and update test suites as the API evolves.
  * Perform regression tests for every new release.
* **Why test here**: Prevent future regressions, ensure confidence in making changes, and support agile development.



