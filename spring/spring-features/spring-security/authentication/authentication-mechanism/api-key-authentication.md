# API Key Authentication

## About

API Key Authentication is a security mechanism used to authenticate and authorize access to APIs by requiring clients to present a unique key (API Key). The API Key acts as a **secret token** that identifies and authenticates the client making the request.

Unlike OAuth or JWT, API Key authentication is a **simpler authentication method**, primarily used for **machine-to-machine (M2M) communication**.

## **How API Key Authentication Works?**

1. **Client Requests an API Key**
   * The client (user, application, or system) registers with the API provider.
   * The provider generates a **unique API Key** and shares it with the client.
2. **Client Makes a Request with the API Key**
   * The client includes the API Key in the request (either in the headers, query parameters, or body).
   *   Example (Authorization Header):

       ```
       GET /api/data
       Authorization: Api-Key 1234567890abcdef
       ```
3. **Server Validates the API Key**
   * The API server **verifies the API Key** against a database or key store.
   * If valid, the request is **authorized**, and the server responds with data.
   * If invalid, the request is **denied** (HTTP 401 Unauthorized or HTTP 403 Forbidden).

## **Where to Pass the API Key?**

There are three common ways to send API Keys:

### **1. HTTP Headers (Recommended)**

* Most secure method as headers are **not logged in URLs**.
*   Example:

    ```
    Authorization: Api-Key 1234567890abcdef
    ```

### **2. Query Parameters (Less Secure)**

*   API Key is included in the URL:

    ```
    GET /api/data?api_key=1234567890abcdef
    ```
* **Risk**: URLs may be logged, exposing API Keys.

### **3. Request Body (For POST Requests)**

* Secure but **only works for POST, PUT, DELETE** requests.
*   Example JSON Payload:

    ```json
    {
      "api_key": "1234567890abcdef"
    }
    ```

## **Best Practices for API Key Authentication**

### **1. Use API Keys in Headers, Not in URLs**

* Avoid sending API Keys in query parameters (`api_key=xyz`).
* Use **Authorization Headers** instead.

### **2. Implement API Key Scoping & Permissions**

* Limit API Keys to specific actions (read-only, write, admin).
* Assign **roles** to API Keys.

### **3. Rotate API Keys Periodically**

* Provide an API key **expiration policy**.
* Allow users to generate **multiple keys**.

### **4. Implement Rate Limiting & Throttling**

* Prevent abuse by **limiting API calls per key**.
* Example: **1000 requests per hour per API Key**.

### **5. Secure API Key Storage**

* Store API Keys **securely** using a **key vault** or **environment variables**.
* Never hardcode API Keys in code.

### **6. Monitor & Log API Key Usage**

* Log API Key usage to detect **abnormal behavior**.
* Revoke compromised API Keys immediately.

## **Implementing API Key Authentication in Spring Security**

### **Step 1: Create a Filter to Extract API Key**

```java
@Component
public class ApiKeyAuthFilter extends OncePerRequestFilter {

    private static final String API_KEY_HEADER = "Authorization";
    private static final String EXPECTED_API_KEY = "1234567890abcdef"; // Store securely

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, 
                                    FilterChain filterChain) throws ServletException, IOException {
        String apiKey = request.getHeader(API_KEY_HEADER);
        
        if (apiKey == null || !apiKey.equals(EXPECTED_API_KEY)) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Invalid API Key");
            return;
        }

        filterChain.doFilter(request, response);
    }
}
```

### **Step 2: Register the Filter in Security Configuration**

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http, ApiKeyAuthFilter apiKeyAuthFilter) throws Exception {
        http
            .csrf(AbstractHttpConfigurer::disable)
            .addFilterBefore(apiKeyAuthFilter, BasicAuthenticationFilter.class)
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/**").authenticated()
                .anyRequest().permitAll()
            );
        return http.build();
    }
}
```

## **When to Use API Key Authentication?**

<table data-header-hidden data-full-width="true"><thead><tr><th></th><th></th></tr></thead><tbody><tr><td><strong>Scenario</strong></td><td><strong>Why API Key Authentication?</strong></td></tr><tr><td><strong>Third-Party API Access</strong></td><td>Used to authenticate external apps consuming an API.</td></tr><tr><td><strong>Machine-to-Machine (M2M) Communication</strong></td><td>Ideal for microservices, IoT devices, and automated scripts.</td></tr><tr><td><strong>Public APIs with Rate Limits</strong></td><td>Helps monetize APIs by issuing <strong>API Keys per client</strong>.</td></tr><tr><td><strong>Backend Services (Server-Side API Calls)</strong></td><td>Used for secure internal API communication.</td></tr></tbody></table>

