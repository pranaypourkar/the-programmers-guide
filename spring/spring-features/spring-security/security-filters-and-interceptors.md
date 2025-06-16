# Security Filters and Interceptors

## About

Security **Filters** and **Interceptors** are two core components in Spring Security that handle authentication, authorization, and request processing at different stages.

<table data-header-hidden data-full-width="true"><thead><tr><th width="192"></th><th width="405"></th><th></th></tr></thead><tbody><tr><td><strong>Component</strong></td><td><strong>Purpose</strong></td><td><strong>Executes Before/After</strong></td></tr><tr><td><strong>Security Filters</strong></td><td>Process incoming requests for authentication, authorization, CSRF protection, CORS, etc.</td><td>Before the request reaches the controller</td></tr><tr><td><strong>Security Interceptors</strong></td><td>Perform security-related checks at the method and API level.</td><td>Before/After method execution</td></tr></tbody></table>

## **Security Filters in Spring Security**

### **How Filters Work in Spring Security**

Spring Security uses the **Servlet Filter chain** to intercept requests before they reach the application.

### **Security Filter Chain Overview**

1. The **Http request** enters the application.
2. Spring Security **filters the request** based on authentication and authorization rules.
3. If the request is **valid**, it is passed to the next filter.
4. If authentication/authorization **fails**, the request is rejected.
5. Once **all filters are executed**, the request is handed to the application.

### **Core Security Filters in Spring Security**

Spring Security applies **multiple filters in a specific order**:

<table data-header-hidden data-full-width="true"><thead><tr><th width="376"></th><th></th></tr></thead><tbody><tr><td><strong>Filter Name</strong></td><td><strong>Purpose</strong></td></tr><tr><td><code>ChannelProcessingFilter</code></td><td>Enforces HTTPS and security constraints.</td></tr><tr><td><code>WebAsyncManagerIntegrationFilter</code></td><td>Integrates Spring Security with asynchronous requests.</td></tr><tr><td><code>SecurityContextPersistenceFilter</code></td><td>Restores <code>SecurityContext</code> between requests (session-based security).</td></tr><tr><td><code>HeaderWriterFilter</code></td><td>Adds security headers (e.g., X-Frame-Options, Content-Security-Policy).</td></tr><tr><td><code>CorsFilter</code></td><td>Handles CORS policies.</td></tr><tr><td><code>CsrfFilter</code></td><td>Prevents Cross-Site Request Forgery (CSRF) attacks.</td></tr><tr><td><code>LogoutFilter</code></td><td>Manages user logout functionality.</td></tr><tr><td><code>UsernamePasswordAuthenticationFilter</code></td><td>Handles <strong>form-based authentication</strong> (processes username/password login).</td></tr><tr><td><code>DefaultLoginPageGeneratingFilter</code></td><td>Generates a default login page if none is provided.</td></tr><tr><td><code>BasicAuthenticationFilter</code></td><td>Handles <strong>HTTP Basic Authentication</strong>.</td></tr><tr><td><code>BearerTokenAuthenticationFilter</code></td><td>Processes <strong>JWT and OAuth2 token-based authentication</strong>.</td></tr><tr><td><code>RequestCacheAwareFilter</code></td><td>Saves unauthorized requests and redirects after authentication.</td></tr><tr><td><code>SecurityContextHolderAwareRequestFilter</code></td><td>Wraps requests to provide Spring Security capabilities.</td></tr><tr><td><code>AnonymousAuthenticationFilter</code></td><td>Assigns an anonymous authentication token to unauthenticated users.</td></tr><tr><td><code>SessionManagementFilter</code></td><td>Controls session security policies (concurrent session control, timeout).</td></tr><tr><td><code>ExceptionTranslationFilter</code></td><td>Converts security exceptions into HTTP responses.</td></tr><tr><td><code>FilterSecurityInterceptor</code></td><td>Final authorization filter that enforces security rules.</td></tr></tbody></table>

### **How Spring Security Applies Filters**

Spring Security **automatically registers filters** based on the configuration.

**Example: Manually Registering a Custom Security Filter**

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .addFilterBefore(new CustomFilter(), UsernamePasswordAuthenticationFilter.class)
            .authorizeHttpRequests(auth -> auth.anyRequest().authenticated());

        return http.build();
    }
}
```

* `addFilterBefore()` inserts a **custom filter** before `UsernamePasswordAuthenticationFilter`.
* **Custom filters** can be used for logging, request validation, or additional security checks.

### **Custom Security Filter Implementation**

A **custom security filter** can inspect or modify requests **before authentication**.

**Example: Custom Security Filter**

```java
public class CustomFilter extends OncePerRequestFilter {

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        
        // Custom logic before processing authentication
        System.out.println("Custom Filter Executed: " + request.getRequestURI());

        filterChain.doFilter(request, response); // Continue the filter chain
    }
}
```

* `OncePerRequestFilter` ensures the filter runs **once per request**.
* The filter **logs requests** before processing.

## **Security Interceptors in Spring Security**

Security **Interceptors** enforce **method-level security** in Spring Security. They work **inside the application**, rather than at the filter level.

### **Types of Security Interceptors**

<table data-header-hidden data-full-width="true"><thead><tr><th width="317"></th><th></th></tr></thead><tbody><tr><td><strong>Interceptor</strong></td><td><strong>Purpose</strong></td></tr><tr><td><code>FilterSecurityInterceptor</code></td><td>Ensures authorization at the <strong>filter level</strong>.</td></tr><tr><td><code>MethodSecurityInterceptor</code></td><td>Enforces security on <strong>methods using annotations</strong>.</td></tr><tr><td><code>AspectJMethodSecurityInterceptor</code></td><td>Enables <strong>AspectJ-based security</strong> for non-Spring-managed beans.</td></tr></tbody></table>

### **Method Security with Security Interceptors**

**Using `@PreAuthorize` for Authorization**

```java
@PreAuthorize("hasRole('ADMIN')")
public void deleteUser(Long userId) {
    // Only ADMIN can delete a user
}
```

* `@PreAuthorize` is **evaluated by `MethodSecurityInterceptor`** before executing the method.

**Using `@PostAuthorize` for Authorization**

```java
@PostAuthorize("returnObject.owner == authentication.name")
public Order getOrder(Long id) {
    return orderRepository.findById(id).orElseThrow();
}
```

* The method **executes first**, and then **authorization is checked** after the result is returned.

#### **How Spring Security Configures Interceptors**

Spring Security **automatically registers interceptors** when method-level security is enabled.

<pre class="language-java"><code class="lang-java"><strong>@Configuration
</strong>@EnableMethodSecurity
public class SecurityConfig {
}
</code></pre>

* `@EnableMethodSecurity` enables `MethodSecurityInterceptor` for method-level security.
