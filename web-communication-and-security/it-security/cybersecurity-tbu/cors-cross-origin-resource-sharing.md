# CORS (Cross-Origin Resource Sharing)

## Overview

**Cross-Origin Resource Sharing (CORS)** is a security feature implemented by web browsers that restricts web pages from making requests to a different domain than the one that served the web page. This is known as the "Same-Origin Policy" (SOP). CORS allows web servers to specify who can access their resources and how those resources can be accessed, thus enabling controlled sharing of resources between different origins.

## Same-Origin Policy (SOP)

Before diving into CORS, it's essential to understand the Same-Origin Policy.

* **Origin**: In web terms, the origin is defined as a combination of the scheme (protocol), host (domain), and port number. For example:
  * `https://example.com:443` (Origin A)
  * `http://example.com:80` (Origin B)
  * `https://api.example.com:443` (Origin C)
* **Same-Origin Policy (SOP)**: By default, web browsers only allow scripts on a web page to access data from the same origin. This means that a web page loaded from `https://example.com` cannot make requests to `https://api.example.com` unless certain conditions are met, primarily through CORS.

## What is CORS?

CORS is a mechanism that allows restricted resources (like fonts, images, or APIs) on a web page to be requested from another domain outside the domain from which the first resource was served. It works by using HTTP headers to inform the browser that the resource can be shared with other origins.

### Key Components of CORS

1. **Preflight Requests**
   * For certain types of requests, particularly those that might affect user data or involve complex operations (like `PUT`, `DELETE`, or custom headers), the browser sends a preflight request using the `OPTIONS` method to the server. This request checks if the server allows the actual request to proceed.
2. **HTTP Headers**
   * **`Access-Control-Allow-Origin`**: Specifies which origin(s) are permitted to access the resource. This can be a specific origin (`https://example.com`) or a wildcard (`*`) to allow any origin.
   * **`Access-Control-Allow-Methods`**: Lists the HTTP methods (`GET`, `POST`, `PUT`, `DELETE`, etc.) allowed when accessing the resource.
   * **`Access-Control-Allow-Headers`**: Indicates which headers can be used in the actual request.
   * **`Access-Control-Allow-Credentials`**: Specifies whether or not the browser should include any credentials (like cookies or HTTP authentication) with requests to the resource.
   * **`Access-Control-Max-Age`**: Specifies how long the results of a preflight request can be cached by the browser.
3. **Simple vs. Non-Simple Requests**
   * **Simple Requests**: These are requests that meet certain criteria, such as using standard methods like `GET`, `POST`, or `HEAD`, and do not require preflight checks.
   * **Non-Simple Requests**: These requests use methods other than `GET`, `POST`, or `HEAD`, or include custom headers, triggering a preflight request to ensure the server allows the action.

{% hint style="info" %}
**Credentials in CORS**:

By default, CORS requests do not include credentials like cookies or HTTP authentication. However, if the server includes the `Access-Control-Allow-Credentials: true` header and the frontend explicitly allows credentials (`withCredentials: true` in XHR or Fetch), then cookies and credentials are sent with the request.
{% endhint %}

### Example Workflow

1. **Simple Request**
   * A browser makes a `GET` request from `https://example.com` to `https://api.example.com/data`.
   * The server at `https://api.example.com` responds with the data and includes an `Access-Control-Allow-Origin` header with `https://example.com` as the value.
   * The browser allows the page to access the data.
2. **Preflight Request**
   * A browser makes a `PUT` request from `https://example.com` to `https://api.example.com/update`.
   * Before sending the actual request, the browser sends an `OPTIONS` request (preflight) to check if the server allows `PUT` requests from `https://example.com`.
   * The server responds with appropriate CORS headers (`Access-Control-Allow-Methods`, `Access-Control-Allow-Origin`, etc.).
   * If allowed, the browser sends the actual `PUT` request.

## Does it involve both i.e. client side as well as server side?

Yes, CORS (Cross-Origin Resource Sharing) is a mechanism that involves both the **browser** (client side) and the **backend API** (server side). Here’s how it works at both ends.

### 1. **Browser (Client Side)**

The browser enforces CORS by implementing the Same-Origin Policy (SOP). This policy restricts how a web page loaded from one origin can interact with resources from another origin. The browser is responsible for:

* **Initiating CORS Requests**: When a web application running in the browser attempts to make a cross-origin HTTP request (e.g., using `fetch`, `XMLHttpRequest`, or AJAX), the browser automatically includes the `Origin` header in the request to indicate where the request originated from.
* **Handling Preflight Requests**: For certain types of requests (e.g., those using methods other than GET/POST, or with custom headers), the browser sends a preflight `OPTIONS` request to the server to determine whether the cross-origin request is allowed. The browser then processes the server's response to decide whether to proceed with the actual request.
* **Enforcing CORS Policy**: The browser checks the CORS headers in the server's response to determine whether the response should be made accessible to the client-side JavaScript. If the server does not allow the origin or fails to include the appropriate CORS headers, the browser will block the response and prevent the web page from accessing the data.

### 2. **Backend API (Server Side)**

The backend API is responsible for configuring and sending the correct CORS headers in its responses. This configuration tells the browser whether or not to allow the cross-origin request. The server handles CORS by:

* **Allowing Specific Origins**: The server can specify which origins are allowed to access its resources by setting the `Access-Control-Allow-Origin` header. This can be a specific origin (e.g., `https://www.example.com`) or a wildcard (`*`) to allow all origins.
* **Specifying Allowed Methods**: The server can control which HTTP methods (e.g., GET, POST, PUT, DELETE) are allowed in cross-origin requests by setting the `Access-Control-Allow-Methods` header.
* **Controlling Allowed Headers**: The server can specify which headers can be used in the request by setting the `Access-Control-Allow-Headers` header.
* **Handling Preflight Requests**: When the server receives a preflight request (an `OPTIONS` request), it responds with the appropriate CORS headers to indicate whether the actual request should be allowed.
* **Allowing Credentials**: If the server needs to allow credentials (like cookies or HTTP authentication) in cross-origin requests, it sets the `Access-Control-Allow-Credentials` header to `true`.

### CORS in Both Ends

CORS requires coordination between the client (browser) and the server (backend API):

* **The Browser's Role**: Enforces the CORS policy by checking the server's response headers before allowing the web application to access the response data.
* **The Server's Role**: Configures the CORS policy by sending appropriate headers that indicate whether a cross-origin request is allowed.

### **Example Flow**

* A browser sends a cross-origin request to a backend API.
* The backend API checks if the request is allowed (based on its CORS configuration) and responds with the appropriate headers.
* The browser receives the response, checks the CORS headers, and either allows or blocks the request based on the policy.

## How CORS Security Protects the System?

### About

CORS (Cross-Origin Resource Sharing) is a security feature implemented by web browsers to prevent malicious websites from making unauthorized requests to different origins (i.e., domains, protocols, or ports) than the one from which the browser loaded the initial web page. By enforcing the Same-Origin Policy (SOP), browsers restrict how web pages loaded from one origin can interact with resources from another origin. CORS allows servers to explicitly grant permission to certain origins to access their resources, thereby protecting sensitive data and preventing certain types of attacks, such as Cross-Site Request Forgery (CSRF).

### **Scenario:**

Let's break down how CORS works and how it can protect the system using an example.

* **Website A**: A web application hosted at `https://www.website-a.com`.
* **Website B**: Another web application or API hosted at `https://api.website-b.com` (say implemented using a Java backend).

**Objective:**

* Website A wants to make an AJAX call to Website B's API to retrieve some data.

**Steps Involved:**

1. **Browser Sends Preflight Request (for Non-Simple Requests)**:
   * If Website A attempts to send a non-simple HTTP request (e.g., a request with custom headers, methods other than GET or POST, or content types other than `application/x-www-form-urlencoded`, `multipart/form-data`, or `text/plain`), the browser first sends a **preflight request** to Website B.
   * The preflight request is an `OPTIONS` request that asks Website B if it allows cross-origin requests from `https://www.website-a.com`.
   *   Example of a preflight request:

       ```makefile
       OPTIONS /api/resource
       Host: api.website-b.com
       Origin: https://www.website-a.com
       Access-Control-Request-Method: POST
       Access-Control-Request-Headers: X-Custom-Header
       ```
2. **Server Response to Preflight Request**:
   * Website B's server checks its CORS policy to determine whether to allow the request from Website A.
   * If allowed, the server responds with headers indicating that cross-origin requests from `https://www.website-a.com` are permitted.
   *   Example of a response:

       ```mathematica
       HTTP/1.1 200 OK
       Access-Control-Allow-Origin: https://www.website-a.com
       Access-Control-Allow-Methods: GET, POST, OPTIONS
       Access-Control-Allow-Headers: X-Custom-Header
       ```
   * If Website B's server does not allow requests from Website A, it will respond with a 403 Forbidden status or not include the CORS headers, and the browser will block the actual request.
3. **Browser Sends Actual Request (if Preflight is Successful)**:
   * If the preflight request is successful and Website B grants permission, the browser sends the actual HTTP request to Website B's API.
   * The browser includes the `Origin` header in this request to inform the server about the request's origin.
   *   Example of an actual request:

       ```makefile
       POST /api/resource
       Host: api.website-b.com
       Origin: https://www.website-a.com
       Content-Type: application/json
       X-Custom-Header: Value
       ```
4. **Server Response to Actual Request**:
   * Website B's server processes the request and responds with the requested data.
   * The server again includes CORS headers to indicate that the response can be accessed by the origin (`https://www.website-a.com`).
   *   Example of a response:

       ```bash
       HTTP/1.1 200 OK
       Access-Control-Allow-Origin: https://www.website-a.com
       Content-Type: application/json
       {
         "data": "Some data"
       }
       ```
5. **Browser Enforces CORS**:
   * The browser checks the response headers to ensure that the `Access-Control-Allow-Origin` header matches the origin of the requesting site.
   * If the headers are valid, the browser allows the JavaScript on Website A to access the response.
   * If not, the browser blocks the response, and the JavaScript on Website A is unable to access the data.

### Security Implications of CORS

**1. Preventing Unauthorized Access**

CORS ensures that only authorized domains can access resources on Website B. This prevents malicious websites from making unauthorized API calls to Website B and stealing sensitive information.

**2. Mitigating CSRF Attacks**

CSRF attacks occur when a malicious website causes a user's browser to perform unwanted actions on a different site where the user is authenticated. CORS helps prevent such attacks by enforcing the Same-Origin Policy and ensuring that cross-origin requests are only allowed from trusted sources.

**3. Safeguarding Sensitive Data**

Without CORS, a malicious script on an attacker’s website could potentially make requests to the Java backend of Website B and access sensitive data like user information, cookies, or tokens. CORS headers prevent such scenarios by restricting access based on origin.

**4. Allowing Controlled Access**

CORS provides a mechanism to allow controlled access to resources by specifying which origins are allowed, what HTTP methods can be used, and what headers are permissible. This granularity helps protect the system while still enabling legitimate cross-origin requests.

### Potential Risks and Mitigations

While CORS is a powerful tool, incorrect configuration can lead to security vulnerabilities.

* **Allowing All Origins (`Access-Control-Allow-Origin: *`)**: This can expose the API to any origin, potentially leading to abuse. It’s safer to specify only trusted origins.
* **Credentials in Cross-Origin Requests (`Access-Control-Allow-Credentials: true`)**: If CORS allows credentials (cookies, HTTP authentication), ensure that the `Access-Control-Allow-Origin` is not set to `*`. Always specify the trusted origin explicitly to avoid exposure.
* **Preflight Caching**: Preflight requests can be cached by the browser using the `Access-Control-Max-Age` header. Ensure that this value is appropriate for your security needs

