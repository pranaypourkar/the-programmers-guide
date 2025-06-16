# Security Filter Chain

## About

The Security Filter Chain in Spring Security is the backbone of request authentication and authorization. It consists of a sequence of security filters that process incoming requests, ensuring that only authenticated and authorized users can access protected resources.

Spring Security uses Servlet Filters to intercept requests and apply security rules. The filters work in a specific order to handle authentication, authorization, session management, CSRF protection, and more.

## **Components of the Security Filter Chain**

The Security Filter Chain consists of multiple filters, each handling a specific security concern. The key filters are:

<table data-header-hidden data-full-width="true"><thead><tr><th width="354"></th><th></th></tr></thead><tbody><tr><td><strong>Filter</strong></td><td><strong>Responsibility</strong></td></tr><tr><td><code>SecurityContextPersistenceFilter</code></td><td>Restores the <code>SecurityContext</code> across multiple requests.</td></tr><tr><td><code>UsernamePasswordAuthenticationFilter</code></td><td>Handles authentication using username and password.</td></tr><tr><td><code>BasicAuthenticationFilter</code></td><td>Supports HTTP Basic Authentication.</td></tr><tr><td><code>BearerTokenAuthenticationFilter</code></td><td>Extracts JWT tokens from requests.</td></tr><tr><td><code>OAuth2LoginAuthenticationFilter</code></td><td>Handles OAuth2 authentication flows.</td></tr><tr><td><code>SessionManagementFilter</code></td><td>Manages user sessions.</td></tr><tr><td><code>CsrfFilter</code></td><td>Protects against Cross-Site Request Forgery (CSRF) attacks.</td></tr><tr><td><code>LogoutFilter</code></td><td>Handles logout functionality.</td></tr><tr><td><code>ExceptionTranslationFilter</code></td><td>Converts security exceptions into proper HTTP responses.</td></tr><tr><td><code>FilterSecurityInterceptor</code></td><td>Handles authorization by checking user permissions.</td></tr></tbody></table>

## **How the Security Filter Chain Works**

1. An HTTP request is received.
2. Filters in the chain execute in a predefined order.
3. Authentication Filters validate credentials.
4. Authorization Filters determine access permissions.
5. Other filters handle session management, CSRF protection, etc.
6. If authentication and authorization succeed, the request proceeds to the controller.
7. If authentication fails, Spring Security returns an appropriate response (e.g., 401 Unauthorized)

## **Spring Security Filter Chain Execution Flow**

### **1. Security Filter Chain is Registered**

* Defined in `HttpSecurity` configuration.
* Spring Security automatically registers `SecurityFilterChain` filters based on configuration.

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/admin/**").hasRole("ADMIN")
                .anyRequest().authenticated())
            .formLogin()
            .and()
            .logout();
        return http.build();
    }
}
```

### **2. Request Passes Through the Filter Chain**

* Every incoming request passes through multiple security filters.
* Each filter processes the request and decides whether to continue or block it.
* Filters are executed in a specific order.

### **3. Authentication Filters Process the Request**

* The request reaches an authentication filter, such as `UsernamePasswordAuthenticationFilter` or `BearerTokenAuthenticationFilter`.
* These filters extract authentication credentials (username/password, JWT token, etc.).
* The extracted credentials are passed to the `AuthenticationManager`.

```java
Authentication authentication = authenticationManager.authenticate(
    new UsernamePasswordAuthenticationToken(username, password));
```

### **4. AuthenticationManager Delegates to AuthenticationProvider**

* The `AuthenticationManager` delegates the authentication to a registered `AuthenticationProvider`.
* If authentication is successful, an `Authentication` object is created and stored in `SecurityContextHolder`.

```java
SecurityContextHolder.getContext().setAuthentication(authentication);
```

### **5. Authorization Filters Check User Permissions**

* `FilterSecurityInterceptor` checks if the authenticated user has permission to access the requested resource.
* If authorization fails, the request is rejected with a **403 Forbidden** response.

```java
http.authorizeHttpRequests(auth -> auth
    .requestMatchers("/admin/**").hasRole("ADMIN")
    .anyRequest().authenticated());
```

### **6. Additional Security Measures Apply**

* `SessionManagementFilter` handles session-related security.
* `CsrfFilter` ensures protection against CSRF attacks.
* `ExceptionTranslationFilter` catches security exceptions and returns appropriate responses.

### **7. Request is Allowed or Blocked**

* If authentication and authorization pass, the request reaches the controller.
* If authentication fails, an **HTTP 401 Unauthorized** response is returned.
* If authorization fails, an **HTTP 403 Forbidden** response is returned.

## **Customizing the Security Filter Chain**

Spring allows adding or removing filters in the security chain.

### **1. Adding Custom Filters**

We can define a custom security filter and register it in the filter chain.

```java
@Component
public class CustomSecurityFilter extends OncePerRequestFilter {
    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, 
                                    FilterChain filterChain) throws ServletException, IOException {
        // Custom security logic
        filterChain.doFilter(request, response);
    }
}
```

Then register the filter:

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .addFilterBefore(new CustomSecurityFilter(), UsernamePasswordAuthenticationFilter.class)
            .authorizeHttpRequests(auth -> auth.anyRequest().authenticated())
            .formLogin();
        return http.build();
    }
}
```

### **2. Removing Default Filters**

If we want to disable certain security filters, we can do so in the configuration.

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable()) // Disable CSRF filter
            .authorizeHttpRequests(auth -> auth.anyRequest().authenticated())
            .formLogin();
        return http.build();
    }
}
```

