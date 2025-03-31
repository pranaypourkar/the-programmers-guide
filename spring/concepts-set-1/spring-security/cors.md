---
hidden: true
---

# CORS

## About

**Cross-Origin Resource Sharing (CORS)** is a security feature enforced by web browsers to **restrict** how resources on a web page can be requested from a different origin (domain, protocol, or port).

By default, **browsers block cross-origin HTTP requests** made via `fetch`, `XHR (XMLHttpRequest)`, or `AJAX` unless explicitly allowed by the server.

For Example,&#x20;

**Blocked by CORS**\
A website running on `https://example.com` tries to fetch data from `https://api.otherdomain.com`.

**Allowed by CORS (If API Allows)**\
The server at `https://api.otherdomain.com` responds with a special **CORS header** (`Access-Control-Allow-Origin: https://example.com`), telling the browser it’s safe to proceed.

## **Why is CORS Needed?**

Modern web applications often consume APIs hosted on different domains. Without CORS, these requests **would be blocked** by the browser's **Same-Origin Policy (SOP)**.

{% hint style="success" %}
**Same-Origin Policy (SOP)** is a security mechanism that prevents scripts from making requests to a different origin than the one that served the web page.

**Allowed under SOP:**

* `https://example.com/app1` → `https://example.com/api` (Same origin)

**Blocked under SOP (Without CORS):**

* `https://example.com` → `https://api.example.com` (Different subdomain)
* `https://example.com` → `https://another-domain.com` (Different domain)
* `https://example.com:3000` → `https://example.com:8080` (Different port)
{% endhint %}

**CORS bypasses SOP** **securely** by allowing the server to specify which domains can access its resources.

## **How CORS Works?**

Imagine we own a **bank website** (`https://mybank.com`) that needs to fetch account details from an **API server**(`https://api.mybank.com`).

**Problem:** By default, web browsers block requests from one domain (`mybank.com`) to another (`api.mybank.com`) due to Same-Origin Policy (SOP)—a security rule that prevents unauthorized access to user data.

**Solution:** The API server (`https://api.mybank.com`) must explicitly allow requests from `https://mybank.com` using CORS headers in its response.

{% hint style="success" %}
When a browser makes a cross-origin request, it automatically includes CORS headers in the request. The server must respond with appropriate CORS headers for the request to succeed.
{% endhint %}

### **CORS Request Flow**

**1 - The browser sends a request** to `https://api.mybank.com` asking, **“Can I access your data?”**

```http
GET /accounts
Origin: https://mybank.com
```

**2 - The API server responds with CORS headers**, allowing or denying access.

**Allowed Response:**

```http
HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://mybank.com
```

**Blocked Response (No CORS Headers):**

```http
HTTP/1.1 403 Forbidden
```

**3 - If allowed, the browser processes the response** and displays the data. Otherwise, it blocks the request.

{% hint style="info" %}
#### **Preflight Requests (Extra Security Check)**

If the request uses **special HTTP methods** (`POST`, `PUT`, `DELETE`) or **custom headers**, the browser first sends a **preflight request** (`OPTIONS` request) to ask:

**Browser:** _"API, are you okay with me sending a DELETE request?"_

**API Server:** _"Yes! I allow DELETE requests from `https://mybank.com`."_
{% endhint %}

## **Types of CORS Requests**

### **1. Simple Requests**

A request is **Simple** if:

* It uses `GET`, `POST`, or `HEAD`.
* It has only **allowed headers** (e.g., `Content-Type: application/x-www-form-urlencoded`).

**Example (Simple CORS Request)**

```javascript
fetch("https://api.example.com/data", {
    method: "GET",
    headers: {
        "Content-Type": "application/json"
    }
})
.then(response => response.json())
.then(data => console.log(data))
.catch(error => console.error(error));
```

**Server Response Headers (Success)**

```http
HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://example.com
```

### **2. Preflight Requests (For Non-Simple Requests)**

A **Preflight Request** is an **OPTIONS** request sent **before** the actual request to check if the server allows CORS.

* Happens when using methods like `PUT`, `DELETE`, `PATCH`.
* Happens when sending **custom headers**.
* Ensures security before sending sensitive data.

**Example (Preflight Request - Sent by Browser Automatically)**

```http
OPTIONS /data HTTP/1.1
Origin: https://example.com
Access-Control-Request-Method: DELETE
Access-Control-Request-Headers: Authorization
```

**Server Response (Approving CORS Request)**

```http
HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://example.com
Access-Control-Allow-Methods: GET, POST, PUT, DELETE
Access-Control-Allow-Headers: Authorization, Content-Type
Access-Control-Max-Age: 3600
```

{% hint style="info" %}
**Access-Control-Allow-Origin** → Specifies allowed domains.

**Access-Control-Allow-Methods** → Lists allowed HTTP methods.

**Access-Control-Allow-Headers** → Lists allowed request headers.

**Access-Control-Max-Age** → Specifies how long the preflight response is cached.
{% endhint %}

### **3. Credentialed Requests (Cookies, Authorization Headers, etc.)**

If a request includes **credentials** (cookies, authentication headers), the server **must** allow it explicitly.

**Client Request with Credentials**

```javascript
fetch("https://api.example.com/user", {
    credentials: "include", // Includes cookies
    headers: {
        "Authorization": "Bearer xyz-token"
    }
})
```

**Server Response for Credentialed Requests**

```http
Access-Control-Allow-Origin: https://example.com
Access-Control-Allow-Credentials: true
```

* `Access-Control-Allow-Credentials: true` **MUST** be set to allow credentials.
* `Access-Control-Allow-Origin: *` **CANNOT** be used with credentials.

## **How to Enable CORS in Spring Boot**

### **1. Global CORS Configuration (For All Endpoints)**

{% hint style="success" %}
Spring Boot 2 and 3 follows same approach
{% endhint %}

```java
@Configuration
public class CorsConfig {
    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                registry.addMapping("/**") // Apply to all endpoints
                    .allowedOrigins("https://example.com") // Allowed domains
                    .allowedMethods("GET", "POST", "PUT", "DELETE") // Allowed HTTP methods
                    .allowedHeaders("*") // Allow all headers
                    .allowCredentials(true); // Allow credentials (cookies)
            }
        };
    }
}
```

### **2. CORS for a Specific Controller**

```java
@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "https://example.com", allowedHeaders = "*", methods = {RequestMethod.GET, RequestMethod.POST})
public class SampleController {
    
    @GetMapping("/data")
    public ResponseEntity<String> getData() {
        return ResponseEntity.ok("CORS enabled");
    }
}
```

* `@CrossOrigin` enables CORS **only for this controller**.
* The `allowedHeaders` and `methods` define **which requests are allowed**.

### **3. CORS Configuration for Spring Security**

If Spring Security is enabled, we **must configure CORS explicitly** in `SecurityFilterChain`.

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .cors(cors -> cors.configurationSource(corsConfigurationSource()))
            .csrf().disable()
            .authorizeHttpRequests(auth -> auth.anyRequest().authenticated());

        return http.build();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOrigins(List.of("https://example.com"));
        configuration.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE"));
        configuration.setAllowedHeaders(List.of("*"));
        configuration.setAllowCredentials(true);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }
}
```

* **If Spring Security is enabled**, CORS **must be configured inside the security filter chain**.
* `setAllowedOrigins(List.of("https://example.com"))` → Allows requests only from `example.com`.
* `setAllowCredentials(true)` → Allows credentials (cookies, authentication headers).

## **Common CORS Issues and Fixes**

<table data-header-hidden data-full-width="true"><thead><tr><th width="285"></th><th width="277"></th><th></th></tr></thead><tbody><tr><td><strong>Issue</strong></td><td><strong>Cause</strong></td><td><strong>Fix</strong></td></tr><tr><td> <code>CORS policy error: No 'Access-Control-Allow-Origin' header</code></td><td>Server <strong>did not include</strong> the CORS headers</td><td>Ensure server <strong>explicitly allows</strong> the requesting domain</td></tr><tr><td> <code>Preflight request blocked</code></td><td>Server <strong>did not allow the method or headers</strong> in <code>OPTIONS</code>response</td><td>Add <code>Access-Control-Allow-Methods</code> and <code>Access-Control-Allow-Headers</code></td></tr><tr><td> <code>Credentials request blocked</code></td><td><code>Access-Control-Allow-Credentials</code> is missing</td><td>Add <code>Access-Control-Allow-Credentials: true</code> and <strong>avoid <code>*</code> in <code>Access-Control-Allow-Origin</code></strong></td></tr></tbody></table>

