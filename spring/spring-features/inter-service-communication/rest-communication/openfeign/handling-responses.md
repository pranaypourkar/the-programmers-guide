# Handling Responses

## About

OpenFeign abstracts HTTP client code by converting remote service APIs into Java interfaces. While it simplifies calling remote services, **how we handle responses both success and error is critical for building resilient applications**.

OpenFeign simplifies the handling of successful HTTP responses by automatically decoding them into Java objects. Depending on the method return type, OpenFeign delegates response parsing to the appropriate decoder, typically Jackson in Spring Cloud OpenFeign.

## **Supported Return Types**

<table><thead><tr><th width="271.7890625">Return Type</th><th>Use Case / When to Use</th></tr></thead><tbody><tr><td><code>Pojo</code> (Java DTO)</td><td>Standard REST responses (JSON → Java object)</td></tr><tr><td><code>String</code></td><td>When we want the raw response body as a JSON/text string</td></tr><tr><td><code>byte[]</code></td><td>For binary responses like PDFs, images, etc.</td></tr><tr><td><code>feign.Response</code></td><td>For complete access to raw body, headers, status</td></tr><tr><td><code>List&#x3C;Pojo></code></td><td>For APIs returning an array or collection</td></tr><tr><td><code>Optional&#x3C;Pojo></code></td><td>For nullable responses (customized via fallback or decoder)</td></tr><tr><td><code>Map&#x3C;String, Object></code></td><td>For dynamic structures when DTO is not defined</td></tr></tbody></table>

### **1. Mapping JSON Response to a POJO**

In Feign, mapping a JSON response to a POJO (Plain Old Java Object) is a common use case for handling successful HTTP responses. When Feign receives the HTTP response body (usually in JSON), it delegates the conversion of the response into a Java object to a message converter (typically Jackson).

Feign automatically deserializes the JSON response into the return type specified in the interface method this allows us to treat remote calls like local method invocations.

For this to work, ensure:

* We have Jackson on the classpath (`spring-boot-starter-web` or `spring-boot-starter-json`)
* The POJO has proper getters/setters and no-args constructor
* The return type of our Feign method matches the expected structure of the JSON

Suppose the remote API returns the following JSON when querying a user:

```json
{
  "id": 42,
  "name": "Alice",
  "email": "alice@example.com"
}
```

We want to map this to a `UserResponse` Java object.

Step 1: Create the POJO

```java
package com.example.client.model;

public class UserResponse {
    private Long id;
    private String name;
    private String email;

    // Constructors
    public UserResponse() {}

    // Getters and setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}
```

Step 2: Create the Feign Client Interface

```java
package com.example.client;

import com.example.client.model.UserResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(name = "user-service", url = "http://localhost:8081")
public interface UserClient {

    @GetMapping("/api/users/{id}")
    UserResponse getUserById(@PathVariable("id") Long id);
}
```

Step 3: Use the Client in our Service

```java
package com.example.service;

import com.example.client.UserClient;
import com.example.client.model.UserResponse;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    private final UserClient userClient;

    public UserService(UserClient userClient) {
        this.userClient = userClient;
    }

    public void fetchUser() {
        UserResponse user = userClient.getUserById(42L);
        System.out.println("Fetched User: " + user.getName());
    }
}
```

### **2. Getting Raw JSON as a String**

Sometimes, we may not want to map the response body to a Java POJO — for example, when:

* The structure of the JSON is dynamic or unknown
* We want to log or cache the response as-is
* We want to delay parsing or forward it to another service

Feign allows returning the raw JSON response as a `String`. When the return type is `String`, Feign does **not attempt** to deserialize the body; it just returns it as-is.

This approach is useful for:

* Prototyping or debugging API responses
* Custom parsing using a JSON library (e.g., Jackson, Gson)
* Interacting with loosely defined APIs

Suppose the endpoint returns:

```json
{
  "status": "success",
  "timestamp": "2025-07-29T12:00:00Z",
  "data": { "id": 1, "name": "Demo" }
}
```

And we want to capture the **entire JSON as a raw string**.

Step 1: Define Feign Client Method

```java
package com.example.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(name = "raw-json-service", url = "http://localhost:8082")
public interface RawJsonClient {

    @GetMapping("/api/raw/{id}")
    String getRawJson(@PathVariable("id") Long id);
}
```

Step 2: Use in our Service

```java
package com.example.service;

import com.example.client.RawJsonClient;
import org.springframework.stereotype.Service;

@Service
public class JsonLoggingService {

    private final RawJsonClient rawJsonClient;

    public JsonLoggingService(RawJsonClient rawJsonClient) {
        this.rawJsonClient = rawJsonClient;
    }

    public void logRawJson() {
        String rawResponse = rawJsonClient.getRawJson(1L);
        System.out.println("Raw JSON Response:\n" + rawResponse);
    }
}
```

### **3. Accessing Full HTTP Response with feign.Response**

By default, OpenFeign maps the HTTP response body to a method's return type (like `String`, custom POJO, etc.). However, sometimes we need to access the **entire HTTP response**, including:

* Status code
* Headers
* Response body as bytes or string
* Reason phrase

This is useful when:

* We want to inspect or log headers or status codes
* We are working with non-200 status responses (e.g., 204 No Content, 202 Accepted)
* We need to read and parse raw response manually
* We want to wrap the raw response for downstream processing

To achieve this, declare our method to return `feign.Response`, which is the low-level response representation provided by Feign.

**Suppose the remote endpoint returns:**

```http
HTTP/1.1 200 OK  
Content-Type: application/json  
X-Correlation-Id: abc-123  
Body: {"message": "Data retrieved"}
```

We can access all of it.

Step 1: Define Feign Client

```java
package com.example.client;

import feign.Response;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;

@FeignClient(name = "full-response-client", url = "http://localhost:8083")
public interface FullResponseClient {

    @GetMapping("/api/data")
    Response getFullResponse();
}
```

Step 2: Use the Response

```java
package com.example.service;

import com.example.client.FullResponseClient;
import feign.Response;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

@Service
public class ResponseInspectorService {

    private final FullResponseClient fullResponseClient;

    public ResponseInspectorService(FullResponseClient fullResponseClient) {
        this.fullResponseClient = fullResponseClient;
    }

    public void inspectResponse() throws IOException {
        Response response = fullResponseClient.getFullResponse();

        int status = response.status();
        String contentType = response.headers().getOrDefault("Content-Type", null).toString();
        String correlationId = response.headers().getOrDefault("X-Correlation-Id", null).toString();

        String body = response.body() != null
                ? new String(response.body().asInputStream().readAllBytes(), StandardCharsets.UTF_8)
                : "No Body";

        System.out.println("Status Code: " + status);
        System.out.println("Content-Type: " + contentType);
        System.out.println("X-Correlation-Id: " + correlationId);
        System.out.println("Response Body:\n" + body);
    }
}
```

### **4. Receiving Binary Data (e.g., Images or PDFs)**

When calling APIs that return **binary content** (like images, PDFs, or any file download), OpenFeign can return the **raw response body as a byte stream**, so we can write it to disk, pass it to another service, or convert it to a specific format (e.g., `BufferedImage`, `File`, etc.).

To support this:

* Use `feign.Response` to get full control of the stream.
* Use `Response.body().asInputStream()` to read the binary data.
* Avoid mapping directly to `String` or POJO, since binary content may not be encoded as text or JSON.

#### **Example: Downloading a PDF File**

Step 1: Define Feign Client

```java
package com.example.client;

import feign.Response;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;

@FeignClient(name = "pdf-client", url = "http://localhost:8082")
public interface PdfClient {

    @GetMapping(value = "/api/files/sample", produces = "application/pdf")
    Response downloadPdf();
}
```

Step 2: Download and Save the File

```java
package com.example.service;

import com.example.client.PdfClient;
import feign.Response;
import org.springframework.stereotype.Service;

import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.IOException;

@Service
public class PdfDownloadService {

    private final PdfClient pdfClient;

    public PdfDownloadService(PdfClient pdfClient) {
        this.pdfClient = pdfClient;
    }

    public void downloadAndSavePdf() throws IOException {
        Response response = pdfClient.downloadPdf();

        if (response.status() == 200 && response.body() != null) {
            try (InputStream input = response.body().asInputStream();
                 FileOutputStream output = new FileOutputStream("sample.pdf")) {

                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = input.read(buffer)) != -1) {
                    output.write(buffer, bytesRead, 0, bytesRead);
                }

                System.out.println("PDF downloaded and saved as 'sample.pdf'");
            }
        } else {
            System.out.println("Failed to download PDF. Status: " + response.status());
        }
    }
}
```

### **5. Handling List of Objects**

Many REST APIs return a **list of items** instead of a single object — for example, a list of users, orders, or transactions. OpenFeign supports this out of the box as long as the response structure and return type in the interface match.

This is especially useful for:

* Fetching all users/products/orders
* Batch querying resources
* Simple array-style responses from REST endpoints

#### **Sample JSON Response**

```json
[
  {
    "id": 1,
    "name": "Alice"
  },
  {
    "id": 2,
    "name": "Bob"
  }
]
```

Model Class

```java
package com.example.model;

public class User {
    private Long id;
    private String name;

    // Getters and setters
}
```

Feign Client Interface

```java
package com.example.client;

import com.example.model.User;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@FeignClient(name = "user-client", url = "http://localhost:8082")
public interface UserClient {

    @GetMapping("/api/users")
    List<User> getAllUsers();
}
```

Service Usage

```java
package com.example.service;

import com.example.client.UserClient;
import com.example.model.User;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserService {

    private final UserClient userClient;

    public UserService(UserClient userClient) {
        this.userClient = userClient;
    }

    public void printAllUsers() {
        List<User> users = userClient.getAllUsers();
        for (User user : users) {
            System.out.println("User ID: " + user.getId() + ", Name: " + user.getName());
        }
    }
}
```

### **6. Returning Map or Generic Structures**

When the JSON response structure is **dynamic** or **unknown at compile time**, we may prefer to deserialize the response into a generic structure like:

* `Map<String, Object>` – for loosely structured key-value pairs
* `List<Map<String, Object>>` – for lists of untyped records
* Custom `Map<String, T>` – when values follow a known structure

Feign integrates well with Jackson, so it can automatically deserialize JSON into maps or collections using standard type inference.

This is especially useful when:

* The API returns **different keys per request** (e.g., analytics, filters)
* We need to **pass through** raw data to another system
* We are writing a **generic client or adapter** for multiple services

#### **Example: Returning a Map from JSON**

Sample JSON Response

```json
{
  "id": 101,
  "name": "John Doe",
  "active": true,
  "roles": ["admin", "editor"]
}
```

Step 1: Define Feign Client

```java
package com.example.client;

import java.util.Map;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;

@FeignClient(name = "user-client", url = "http://localhost:8082")
public interface UserClient {

    @GetMapping("/api/users/101")
    Map<String, Object> getUserAsMap();
}
```

#### **Example: Returning a List of Maps**

```java
@FeignClient(name = "user-client", url = "http://localhost:8082")
public interface UserClient {

    @GetMapping("/api/users")
    List<Map<String, Object>> getAllUsersAsMap();
}
```

#### **Example: Using in a Service Layer**

```java
package com.example.service;

import com.example.client.UserClient;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
public class UserService {

    private final UserClient userClient;

    public UserService(UserClient userClient) {
        this.userClient = userClient;
    }

    public void printUserDetails() {
        Map<String, Object> user = userClient.getUserAsMap();
        System.out.println("User Name: " + user.get("name"));
        System.out.println("Roles: " + user.get("roles"));
    }
}
```

### **7. Optional Return Types**

Spring Cloud OpenFeign supports returning `Optional<T>` from client methods. This is useful when:

* The remote service **might return 404 or empty**, and we don’t want to throw exceptions for that
* We want to **explicitly express absence of data** rather than returning `null`
* It encourages **null-safe** handling at the consumer side

This pattern is especially valuable when integrating with **internal services**, where a missing record is not necessarily an error.

However, `Optional<T>` only works reliably when:

* We are using **Spring Cloud >= 2020.x** or newer
* The response body is actually **empty or null** for 404 (i.e., not a structured error response)

#### **Example 1: Return Optional from GET Request**

Feign Client Interface

```java
package com.example.client;

import java.util.Optional;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(name = "user-client", url = "http://localhost:8082")
public interface UserClient {

    @GetMapping("/api/users/{id}")
    Optional<User> getUserById(@PathVariable("id") Long id);
}
```

#### **Example 2: Consuming the Optional in Service**

```java
package com.example.service;

import com.example.client.UserClient;
import com.example.model.User;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    private final UserClient userClient;

    public UserService(UserClient userClient) {
        this.userClient = userClient;
    }

    public void fetchUser(long id) {
        userClient.getUserById(id).ifPresentOrElse(
            user -> System.out.println("User found: " + user.getName()),
            () -> System.out.println("User not found")
        );
    }
}
```

#### **Model Example**

```java
package com.example.model;

public class User {
    private Long id;
    private String name;

    // Getters and setters
}
```

## **Custom Wrapper Example**

In many real-world APIs, especially internal microservices, responses are **wrapped** inside a common envelope or container for consistency. These wrappers typically contain:

* The actual payload
* Metadata like status, message, timestamps, etc.

This pattern simplifies error handling, logging, and standardizes API contracts.

#### **Example Custom Wrapper**

A typical wrapper class might look like:

```json
{
  "status": "SUCCESS",
  "message": "User fetched successfully",
  "data": {
    "id": 1,
    "name": "Alice"
  }
}
```

To handle such structures with OpenFeign, our client must define the return type using a **POJO that reflects this wrapper**.

#### **Wrapper Class Example**

```java
package com.example.wrapper;

public class ApiResponse<T> {
    private String status;
    private String message;
    private T data;

    // Getters and setters
}
```

Model Class

```java
package com.example.model;

public class User {
    private Long id;
    private String name;

    // Getters and setters
}
```

Feign Client Interface

```java
package com.example.client;

import com.example.model.User;
import com.example.wrapper.ApiResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(name = "user-client", url = "http://localhost:8082")
public interface UserClient {

    @GetMapping("/api/users/{id}")
    ApiResponse<User> getUserById(@PathVariable("id") Long id);
}
```

Service Usage

```java
package com.example.service;

import com.example.client.UserClient;
import com.example.wrapper.ApiResponse;
import com.example.model.User;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    private final UserClient userClient;

    public UserService(UserClient userClient) {
        this.userClient = userClient;
    }

    public void fetchUser(long id) {
        ApiResponse<User> response = userClient.getUserById(id);
        if ("SUCCESS".equalsIgnoreCase(response.getStatus())) {
            User user = response.getData();
            System.out.println("User: " + user.getName());
        } else {
            System.out.println("Failed to fetch user: " + response.getMessage());
        }
    }
}
```



