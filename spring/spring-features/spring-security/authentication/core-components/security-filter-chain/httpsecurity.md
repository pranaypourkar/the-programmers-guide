# HttpSecurity

## About

`HttpSecurity` is a Spring Security class that allows developers to configure security policies for their applications. It provides a **fluent API** to define security rules, including authentication, authorization, session management, CSRF protection, CORS, and custom security filters.

It is highly customizable and is used inside the `SecurityFilterChain` bean.

## **Responsibilities of HttpSecurity**

<table data-header-hidden data-full-width="true"><thead><tr><th width="321"></th><th></th></tr></thead><tbody><tr><td><strong>Responsibility</strong></td><td><strong>Description</strong></td></tr><tr><td><strong>Authentication Configuration</strong></td><td>Specifies login mechanisms (e.g., form-based login, HTTP Basic, OAuth2, JWT, etc.).<br>Defines custom authentication filters.</td></tr><tr><td><strong>Authorization Rules</strong></td><td>Controls access to different resources based on user roles and permissions.<br>Supports method-level security.</td></tr><tr><td><strong>Session Management</strong></td><td>Configures session policies (e.g., stateless sessions for REST APIs).<br>Prevents session fixation attacks.</td></tr><tr><td><strong>Cross-Site Request Forgery (CSRF) Protection</strong></td><td>Enables or disables CSRF protection.<br>Allows fine-grained control over CSRF behavior.</td></tr><tr><td><strong>Cross-Origin Resource Sharing (CORS) Policies</strong></td><td>Configures CORS rules for handling requests from different origins.</td></tr><tr><td><strong>Security Headers Management</strong></td><td>Sets HTTP security headers such as <code>Strict-Transport-Security</code>, <code>X-Frame-Options</code>, etc.</td></tr><tr><td><strong>Adding Custom Security Filters</strong></td><td>Allows adding custom authentication and authorization filters at specific positions in the filter chain.</td></tr></tbody></table>

### **Sample Usage**

A standard Spring Security configuration using `HttpSecurity` looks like this -&#x20;

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable()) // Disable CSRF for APIs
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/public/**").permitAll() // Allow public access
                .requestMatchers("/admin/**").hasRole("ADMIN") // Only ADMIN can access
                .anyRequest().authenticated() // All other requests need authentication
            )
            .formLogin(Customizer.withDefaults()) // Enable default form-based login
            .logout(logout -> logout.logoutUrl("/logout").permitAll()); // Custom logout settings
        
        return http.build();
    }
}
```

## Authentication Configuration

Spring Security allows authentication configuration through `HttpSecurity`. The authentication mechanism determines how users provide credentials and how the system validates them.

### **Syntax for Authentication Configuration**

Authentication is configured inside a `SecurityFilterChain` bean:

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/public/**").permitAll() // Public endpoints accessible to all
                .requestMatchers("/admin/**").hasRole("ADMIN") // Only admin can access
                .anyRequest().authenticated() // Other requests require authentication
            )
            .httpBasic(Customizer.withDefaults()) // Enable HTTP Basic authentication
            .formLogin(Customizer.withDefaults()); // Enable form-based login

        return http.build();
    }
}
```

* **`authorizeHttpRequests(auth -> auth...)`** → Defines access rules for different endpoints.
* **`requestMatchers("/public/**").permitAll()`** → Allows access without authentication.
* **`requestMatchers("/admin/**").hasRole("ADMIN")`** → Restricts access to users with the `ADMIN` role.
* **`anyRequest().authenticated()`** → Requires authentication for all other endpoints.
* **`httpBasic(Customizer.withDefaults())`** → Enables Basic Authentication.
* **`formLogin(Customizer.withDefaults())`** → Enables Form-Based Authentication.

### **1. Basic Authentication**

HTTP Basic Authentication is a simple authentication scheme where the client sends a username and password in the `Authorization` header of each request. The credentials are Base64-encoded but not encrypted, making it insecure over HTTP (use HTTPS only). Suitable for APIs or internal applications where user sessions are not needed.

#### **Configuring Basic Authentication**

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .anyRequest().authenticated() // All endpoints require authentication
            )
            .httpBasic(Customizer.withDefaults()); // Enable Basic Authentication

        return http.build();
    }
}
```

#### **How Basic Authentication Works**

1.  The client sends a request with an `Authorization` header:

    ```
    Authorization: Basic dXNlcjpwYXNzd29yZA==
    ```

    (Where `dXNlcjpwYXNzd29yZA==` is `user:password` encoded in Base64)
2. Spring Security decodes the credentials and checks them against the user database.
3. If valid, access is granted; otherwise, a `401 Unauthorized` response is returned.

{% hint style="success" %}
#### **When to Use Basic Authentication**

* When working with REST APIs that don't require session management.
* When using stateless authentication (e.g., microservices).
{% endhint %}

### 2. Form-Based Authentication

Form-Based Authentication uses an HTML login page where users enter their credentials. The credentials are submitted to a login endpoint, verified by Spring Security, and a session is created.

#### **Configuring Form-Based Authentication**

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .anyRequest().authenticated()
            )
            .formLogin(form -> form
                .loginPage("/login") // Custom login page
                .defaultSuccessUrl("/home", true) // Redirect after successful login
                .failureUrl("/login?error=true") // Redirect after failed login
                .permitAll() // Allow everyone to access login page
            );

        return http.build();
    }
}
```

#### **How Form-Based Authentication Works**

1. The user navigates to `/login` and enters their credentials.
2. The credentials are sent via `POST` to `/login` (default endpoint).
3. Spring Security authenticates the user and **creates a session.**
4. If successful, the user is redirected to `/home`.
5. If failed, they are redirected to `/login?error=true`.

{% hint style="success" %}
**When to Use Form-Based Authentication**

* When building **web applications** that require **session-based authentication**.
{% endhint %}

#### **Customizing Login & Logout**

```java
.formLogin(form -> form
    .loginPage("/custom-login") // Custom login page
    .loginProcessingUrl("/process-login") // Custom endpoint for processing login
    .usernameParameter("user_name") // Custom username field
    .passwordParameter("pwd") // Custom password field
    .successHandler(new CustomSuccessHandler()) // Custom logic after success
    .failureHandler(new CustomFailureHandler()) // Custom logic after failure
)
.logout(logout -> logout
    .logoutUrl("/perform_logout") // Custom logout URL
    .logoutSuccessUrl("/login?logout") // Redirect after logout
    .deleteCookies("JSESSIONID") // Clear session cookies
);
```

### 3. JWT Authentication (Using Custom Filter)

JWT (JSON Web Token) Authentication is a stateless authentication mechanism. A token is generated after login and sent with each request instead of using sessions.

#### **Configuring JWT Authentication**

Create a Custom JWT Filter

```java
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {
        String token = request.getHeader("Authorization");

        if (token != null && token.startsWith("Bearer ")) {
            String jwt = token.substring(7); // Extract JWT token
            // Validate token and set authentication context (skipping actual validation logic)
        }

        filterChain.doFilter(request, response);
    }
}
```

Register JWT Filter in Security Configuration

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable()) // Disable CSRF for APIs
            .authorizeHttpRequests(auth -> auth
                .anyRequest().authenticated()
            )
            .addFilterBefore(new JwtAuthenticationFilter(), UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}
```

#### **How JWT Authentication Works**

1. User logs in and receives a **JWT token**.
2. The token is included in the **Authorization header** (`Bearer <token>`) for every request.
3. The **JWT filter** extracts and validates the token.
4. If valid, authentication is set in the **SecurityContext**.

{% hint style="success" %}
#### **When to Use JWT Authentication**

* For **REST APIs** that require **stateless authentication**.
{% endhint %}

### 4. OAuth2 Login (Social Logins)

Allows authentication using **external providers** like Google, Facebook, GitHub, etc. Users **don't need to enter credentials** in the application; they authenticate via the provider.

#### **Configuring OAuth2 Login**

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .anyRequest().authenticated()
            )
            .oauth2Login(oauth2 -> oauth2
                .loginPage("/oauth2/authorization/google") // Redirect to Google for login
                .defaultSuccessUrl("/home") // Redirect after success
            );

        return http.build();
    }
}
```

#### **How OAuth2 Authentication Works**

1. The user is redirected to **Google/GitHub/etc.** for login.
2. After authentication, the provider sends an **authorization code**.
3. Spring Security exchanges this code for an **access token**.
4. The application **retrieves user details** and grants access.

{% hint style="success" %}
#### **When to Use OAuth2 Authentication**

* When users prefer **single sign-on (SSO)** with third-party accounts.
{% endhint %}

## Authorization Rules

Authorization determines what actions an **authenticated** user can perform. Spring Security provides several ways to define access control, including:

1. Role-Based Access Control (RBAC)
2. Method-Level Security

### **Configuring Authorization Rules in Spring Security**

Spring Security defines authorization rules inside the `SecurityFilterChain` using `authorizeHttpRequests()`.

#### **Basic Authorization Configuration**

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/public/**").permitAll() // Allow everyone
                .requestMatchers("/user/**").hasRole("USER") // Only users with ROLE_USER
                .requestMatchers("/admin/**").hasRole("ADMIN") // Only users with ROLE_ADMIN
                .anyRequest().authenticated() // Other requests require authentication
            )
            .httpBasic(Customizer.withDefaults()); // Enable Basic Authentication

        return http.build();
    }
}
```

* **`permitAll()`** → Allows access to everyone (unauthenticated users).
* **`hasRole("USER")`** → Allows only users with the **USER** role.
* **`hasRole("ADMIN")`** → Restricts access to users with the **ADMIN** role.
* **`anyRequest().authenticated()`** → Requires authentication for all other endpoints.

### 1. Role-Based Access Control

RBAC is a security model where access is granted **based on user roles**.

#### **Defining User Roles**

In Spring Security, user roles are typically stored in a **UserDetailsService**.

**Example: Creating a User with Roles**

```java
@Bean
public UserDetailsService userDetailsService() {
    UserDetails user = User.withDefaultPasswordEncoder()
        .username("john")
        .password("password")
        .roles("USER") // Assigning USER role
        .build();

    UserDetails admin = User.withDefaultPasswordEncoder()
        .username("admin")
        .password("admin123")
        .roles("ADMIN") // Assigning ADMIN role
        .build();

    return new InMemoryUserDetailsManager(user, admin);
}
```

* The `roles()` method automatically **prefixes "ROLE\_"** to the given role names.
* `roles("USER")` becomes `ROLE_USER` in the system.

#### **Role-Based Authorization in Security Configuration**

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/admin/**").hasRole("ADMIN") // Only ADMIN users
                .requestMatchers("/user/**").hasAnyRole("USER", "ADMIN") // USER or ADMIN
                .requestMatchers("/reports/**").hasAuthority("REPORT_VIEW") // Fine-grained authority
                .anyRequest().authenticated()
            )
            .httpBasic(Customizer.withDefaults());

        return http.build();
    }
}
```

{% hint style="info" %}
* **First, Spring Security checks if the request matches `/admin/**`**
  * If **YES**, it checks if the user has `ROLE_ADMIN`.
  * If **NO**, it moves to the next rule.
* **Then, it checks if the request matches `/user/**`**
  * If **YES**, it checks if the user has `ROLE_USER` or `ROLE_ADMIN`.
  * If **NO**, it moves to the next rule.
* **Then, it checks if the request matches `/reports/**`**
  * If **YES**, it checks if the user has the `REPORT_VIEW` permission.
  * If **NO**, it moves to the next rule.
* **For all other requests (`anyRequest()`)**
  *   If a request does NOT match any of the above paths (`/admin/**`, `/user/**`, `/reports/**`), this rule applies:

      ```java
      .anyRequest().authenticated()
      ```
  * This means **all other endpoints require authentication** (but no specific role/authority is needed).
  * The user just needs to **log in** to access these routes.

\


If we changed it to

```java
.anyRequest().permitAll()
```

* Then **any request** that doesn't match `/admin/**`, `/user/**`, or `/reports/**` would be **publicly accessible** (no authentication required).
{% endhint %}

#### **`hasAuthority()` vs. `hasRole()`**

<table data-header-hidden data-full-width="true"><thead><tr><th width="329"></th><th></th></tr></thead><tbody><tr><td><strong>Method</strong></td><td><strong>Description</strong></td></tr><tr><td><code>hasRole("ADMIN")</code></td><td>Checks if user has <strong>ROLE_ADMIN</strong> (Spring Security adds the <code>ROLE_</code> prefix).</td></tr><tr><td><code>hasAuthority("REPORT_VIEW")</code></td><td>Checks if user has the specific <strong>authority/permission</strong> (without <code>ROLE_</code> prefix).</td></tr><tr><td><code>hasAnyRole("USER", "ADMIN")</code></td><td>Allows users with <strong>either</strong> <code>ROLE_USER</code> or <code>ROLE_ADMIN</code>.</td></tr><tr><td><code>hasAnyAuthority("READ_PRIVILEGES", "WRITE_PRIVILEGES")</code></td><td>Allows users with <strong>at least one</strong> of the specified permissions.</td></tr></tbody></table>

#### **Storing Permissions Instead of Roles**

If we need **fine-grained** permissions (e.g., `READ_PRIVILEGES`, `EDIT_POST`), use **Authorities** instead of roles.

```java
.authorizeHttpRequests(auth -> auth
    .requestMatchers("/reports/**").hasAuthority("REPORT_VIEW")
    .requestMatchers("/admin/**").hasAuthority("ADMIN_PRIVILEGE")
)
```

* **Roles** → Used for **broad access control** (e.g., `ROLE_ADMIN`, `ROLE_USER`).
* **Authorities** → Used for **fine-grained permissions** (e.g., `EDIT_POST`, `DELETE_USER`).

### 2. Method-Level Security

Spring Security allows restricting access at the **method level** using annotations.

#### **Enabling Method Security**

Add `@EnableMethodSecurity` in the configuration class:

```java
@Configuration
@EnableWebSecurity
@EnableMethodSecurity // Enables @PreAuthorize, @PostAuthorize, etc.
public class SecurityConfig {}
```

#### **`@PreAuthorize` - Check Before Method Execution**

**Example: Restricting API Calls**

```java
@RestController
@RequestMapping("/api")
public class UserController {

    @PreAuthorize("hasRole('ADMIN')") // Only ADMIN can access
    @GetMapping("/admin")
    public String adminEndpoint() {
        return "Admin Access Granted!";
    }

    @PreAuthorize("hasRole('USER') or hasRole('ADMIN')") // USER or ADMIN can access
    @GetMapping("/user")
    public String userEndpoint() {
        return "User Access Granted!";
    }
}
```

`@PreAuthorize("hasRole('ADMIN')")` → Only allows users with `ROLE_ADMIN` to execute the method.

#### **`@PostAuthorize` - Check After Method Execution**

Used when authorization depends on the **returned object**.

```java
@PostAuthorize("returnObject.username == authentication.name") // Only return the object if it's the logged-in user
public User getUserDetails(String username) {
    return userRepository.findByUsername(username);
}
```

The method runs first, and then Spring Security checks if the **returned object's username** matches the **logged-in user**.

#### &#x20;**`@Secured` - Alternative to `@PreAuthorize`**

```java
@Secured("ROLE_ADMIN") // Only ADMIN can access
public void performAdminTask() {
    System.out.println("Admin Task Executed!");
}
```

Unlike `@PreAuthorize`, `@Secured` **does not support SpEL expressions**.

#### &#x20;**`@RolesAllowed` - JSR-250 Alternative**

```java
@RolesAllowed({"ROLE_ADMIN", "ROLE_USER"}) // Supports multiple roles
public void processTask() {
    System.out.println("Task Processed!");
}
```

Works like `@Secured`, but allows specifying multiple roles.

### **Combining Role-Based & Method-Level Security**

Combining **URL-Based Security** (`authorizeHttpRequests()`) and **Method-Level Security** (`@PreAuthorize`, `@PostAuthorize`) provides multiple layers of security, ensuring that:

1. **Unauthorized requests are blocked as early as possible** (at the filter level).
2. **Granular, context-aware security rules** can be enforced at the service level.

{% hint style="info" %}
**Problems with Using Only URL-Based Security**

If we rely **only** on `authorizeHttpRequests()`, we may face security loopholes:\
**Pros:**

* Easy to configure in `HttpSecurity`.
* Centralized security rules for REST APIs.
* Protects against direct access via URLs.

**Cons:**

* Only protects **controller endpoints** (not service methods).
* Does **not** protect internal method calls.
* If a new API method is introduced and not explicitly secured, it might be **accidentally left open**.



**Problems with Using Only Method-Level Security**

If we rely **only** on `@PreAuthorize`, `@PostAuthorize`, or `@Secured`:\
**Pros:**

* Fine-grained security **at method level**.
* Can apply **dynamic authorization logic** (e.g., checking if the user owns a resource).
* Works well for **non-REST applications** (like **microservices** or **service-layer security**).

**Cons:**

* Methods are still **exposed via HTTP endpoints** unless restricted by `HttpSecurity`.
* **No centralized visibility**—developers must check each method for security annotations.
* Does **not block unauthorized requests early** (the request still reaches the service layer).
{% endhint %}

#### **Example: Combining Both Approaches**

```java
@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/admin/**").hasRole("ADMIN")
                .requestMatchers("/user/**").hasRole("USER")
                .anyRequest().authenticated()
            )
            .formLogin(Customizer.withDefaults());

        return http.build();
    }
}
```

**Controller with Method-Level Security**

```java
javaCopyEdit@RestController
@RequestMapping("/api")
public class UserController {

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/admin")
    public String admin() {
        return "Admin access granted!";
    }

    @PreAuthorize("hasRole('USER')")
    @GetMapping("/user")
    public String user() {
        return "User access granted!";
    }

    @PostAuthorize("returnObject.username == authentication.name") 
    @GetMapping("/profile")
    public User getProfile() {
        return userService.getCurrentUser();
    }
}
```

## **Session Management**

Session management controls how user sessions are created, maintained, and invalidated in a Spring Security-based application. It is crucial for:

* Security (Preventing session hijacking, session fixation)
* Performance (Reducing server memory usage)
* Scalability (Especially for REST APIs where stateless authentication is preferred)

### **Configuring Session Management in Spring Security**

Spring Security allows configuring session management using `sessionManagement()` in the `HttpSecurity` configuration.

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .sessionManagement(session -> session
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS) // Session strategy
                .maximumSessions(1) // Restrict to 1 active session per user
                .maxSessionsPreventsLogin(true) // Prevent new login if session exists
            )
            .formLogin(Customizer.withDefaults()) // Enable login
            .logout(Customizer.withDefaults()); // Enable logout

        return http.build();
    }
}
```

### Stateless Session (For REST APIs)

REST APIs should be **stateless** to ensure scalability and avoid session-based authentication overhead.

#### **Why Stateless Sessions for REST APIs?**

* **Improves scalability** (No need to store session data in memory)
* **Better performance** (Avoids extra lookups for session validation)
* **Ideal for microservices** (No need for session replication across nodes)

#### **How to Implement Stateless Sessions in Spring Security?**

Use `SessionCreationPolicy.STATELESS` to disable session management.

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .sessionManagement(session -> session
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS) // Disable sessions
            )
            .csrf(csrf -> csrf.disable()) // Disable CSRF for REST APIs
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/public/**").permitAll() // Public APIs
                .anyRequest().authenticated()
            )
            .addFilterBefore(new JwtAuthenticationFilter(), UsernamePasswordAuthenticationFilter.class); // Add JWT filter

        return http.build();
    }
}
```

* **`sessionCreationPolicy(SessionCreationPolicy.STATELESS)`** → Prevents the creation of a session.
* **No `HttpSession` is stored or used** → Every request must include authentication (e.g., JWT token).
* **Disables CSRF (`csrf.disable()`)** → CSRF protection is not needed in stateless APIs.
* **Custom JWT Filter** (`JwtAuthenticationFilter`) → Extracts user authentication from JWT in each request.

#### **Example: Custom JWT Authentication Filter**

```java
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        String token = request.getHeader("Authorization");

        if (token != null && token.startsWith("Bearer ")) {
            token = token.substring(7); // Extract token after "Bearer "

            // Validate token and get user details
            Authentication auth = TokenProvider.getAuthentication(token);
            SecurityContextHolder.getContext().setAuthentication(auth);
        }

        filterChain.doFilter(request, response); // Continue filter chain
    }
}
```

* Extracts the **JWT token** from the request header.
* Validates the token and retrieves user details.
* Sets the user authentication in `SecurityContextHolder`.

### Preventing Session Fixation Attacks

A **session fixation attack** occurs when an attacker tricks a user into using a known **session ID**, allowing them to hijack the session after login.

#### **How to Prevent Session Fixation?**

Spring Security provides built-in protection using `sessionFixation()`.

```java
@Bean
public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    http
        .sessionManagement(session -> session
            .sessionFixation().newSession() // Prevents session fixation
        )
        .formLogin(Customizer.withDefaults());

    return http.build();
}
```

#### **Session Fixation Strategies in Spring Security**

<table data-header-hidden><thead><tr><th width="265"></th><th></th></tr></thead><tbody><tr><td><strong>Strategy</strong></td><td><strong>Description</strong></td></tr><tr><td><code>migrateSession()</code> (Default)</td><td>Creates a new session ID but retains session attributes.</td></tr><tr><td><code>newSession()</code></td><td>Creates a completely new session, discarding previous session attributes.</td></tr><tr><td><code>none()</code></td><td>No protection against session fixation (not recommended).</td></tr></tbody></table>

#### **Example: Custom Login Handler to Invalidate Old Sessions**

```java
@Component
public class CustomAuthenticationSuccessHandler implements AuthenticationSuccessHandler {
    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) throws IOException, ServletException {
        HttpSession session = request.getSession(false); // Get existing session
        if (session != null) {
            session.invalidate(); // Invalidate old session
        }
        request.getSession(true); // Create new session
        response.sendRedirect("/home");
    }
}
```

* **Invalidates old sessions** after successful login.
* **Prevents session fixation attacks** by creating a new session.

## **Managing Concurrent Sessions**

Spring Security allows limiting the number of concurrent sessions per user.

```java
@Bean
public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    http
        .sessionManagement(session -> session
            .maximumSessions(1) // Only one active session per user
            .maxSessionsPreventsLogin(true) // Prevents new login if a session already exists
        )
        .formLogin(Customizer.withDefaults());

    return http.build();
}
```

#### **Explanation**

* **`maximumSessions(1)`** → Restricts users to a single active session.
* **`maxSessionsPreventsLogin(true)`** → Prevents a new login if the user is already logged in elsewhere.

## **CSRF Protection**

Cross-Site Request Forgery (CSRF) is a web security vulnerability that allows an attacker to execute unauthorized actions on behalf of an authenticated user. Spring Security provides **built-in CSRF protection**, which is enabled by default for web applications. However, for stateless APIs, it is typically disabled.

{% hint style="success" %}
CSRF attacks occur when:

* A user is **authenticated** in a web application.
* The user visits a **malicious site** that sends a request to the application.
* The request **executes an action** on behalf of the authenticated user **without their knowledge**.
{% endhint %}



### **Disabling CSRF for APIs**

Since REST APIs are typically stateless, CSRF protection is not needed. API clients (e.g., mobile apps, Postman) do not rely on browser cookies, which makes CSRF attacks irrelevant.

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable()) // Disable CSRF for APIs
            .sessionManagement(session -> session
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            )
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/public/**").permitAll()
                .anyRequest().authenticated()
            )
            .addFilterBefore(new JwtAuthenticationFilter(), UsernamePasswordAuthenticationFilter.class); // Add JWT filter

        return http.build();
    }
}
```

{% hint style="success" %}
**Why Disable CSRF for APIs?**

* REST APIs **do not use cookies** for authentication.
* **Tokens (JWT, OAuth2)** are used instead of session-based authentication.
* **CSRF attacks require authentication via cookies**, which is not applicable for APIs.
{% endhint %}

### Enabling CSRF for Web Applications

For web applications using session-based authentication (cookies), CSRF protection should remain enabled.

```java
@Bean
public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    http
        .csrf(csrf -> csrf
            .csrfTokenRepository(CookieCsrfTokenRepository.withHttpOnlyFalse()) // Store CSRF token in a cookie
        )
        .authorizeHttpRequests(auth -> auth
            .requestMatchers("/public/**").permitAll()
            .anyRequest().authenticated()
        )
        .formLogin(Customizer.withDefaults());

    return http.build();
}
```

* **`csrfTokenRepository(CookieCsrfTokenRepository.withHttpOnlyFalse())`** → Stores the CSRF token in a cookie, making it accessible to JavaScript for AJAX requests.
* **`withHttpOnlyFalse()`** → Allows JavaScript to read the token for AJAX calls.

#### **How the CSRF Token Works Here?**

* Spring Security sends a **CSRF token in a cookie (`XSRF-TOKEN`)**.
* The frontend **must send the token in the `X-CSRF-TOKEN` header** in AJAX requests.

#### **Example: Fetching the CSRF Token in JavaScript**

```javascript
fetch('/transfer', {
    method: 'POST',
    headers: {
        'X-CSRF-TOKEN': getCookie('XSRF-TOKEN') // Retrieve CSRF token from cookie
    },
    body: JSON.stringify({ amount: 1000 })
});
```

## **CORS**

CORS is a **security mechanism** implemented by browsers to **restrict cross-origin HTTP requests**. It prevents unauthorized websites from making requests to your backend services.

**Same-Origin Policy (SOP)**: By default, **browsers block requests** if the origin (protocol, domain, and port) is different from the requested resource.

**CORS Policy**: CORS allows web applications to **bypass SOP** and make cross-origin requests by defining allowed origins, methods, headers, etc.

Spring provides multiple ways to configure CORS:

* Using `WebMvcConfigurer` (Global CORS Policy)
* Using `HttpSecurity` (Security-Specific CORS Configuration)
* Configuring it for specific controllers

### CORS Configuration

Spring Security adds an additional layer of security that might override global CORS settings. We need to explicitly enable it in `HttpSecurity`.

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .cors(cors -> cors.configurationSource(corsConfigurationSource())) // Enable CORS
            .csrf(csrf -> csrf.disable())  // Disable CSRF for APIs
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/public/**").permitAll()
                .anyRequest().authenticated()
            );

        return http.build();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration config = new CorsConfiguration();
        config.setAllowedOrigins(List.of("http://frontend.com"));  // Define allowed origins
        config.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE"));  // Allowed methods
        config.setAllowedHeaders(List.of("*"));  // Allow all headers
        config.setAllowCredentials(true);  // Allow credentials

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", config);
        return source;
    }
}
```

* This configures CORS inside Spring Security, ensuring security rules don’t block valid requests.
* Uses **`CorsConfigurationSource`** to define allowed origins, methods, and headers.

### Security Headers

Apart from CORS, Spring Security also enforces security headers to protect against various web vulnerabilities.

#### **Default Security Headers Added by Spring Security**

Spring Security adds the following headers automatically:

| **Header**                        | **Purpose**                           |
| --------------------------------- | ------------------------------------- |
| `X-Frame-Options: DENY`           | Prevents Clickjacking attacks.        |
| `X-Content-Type-Options: nosniff` | Prevents MIME type sniffing.          |
| `Strict-Transport-Security`       | Forces HTTPS connections.             |
| `X-XSS-Protection: 1; mode=block` | Protects against XSS attacks.         |
| `Content-Security-Policy`         | Prevents inline JavaScript execution. |

#### **Customizing Security Headers**

If we need **custom headers**, we can configure them using `HttpSecurity.headers()`.

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .headers(headers -> headers
                .contentSecurityPolicy("default-src 'self'")  // Prevents loading scripts from other domains
                .frameOptions(frame -> frame.sameOrigin())  // Allows iframes only from the same origin
                .xssProtection(xss -> xss.block(true))  // Enables XSS protection
            )
            .authorizeHttpRequests(auth -> auth
                .anyRequest().authenticated()
            );

        return http.build();
    }
}
```

* `contentSecurityPolicy("default-src 'self'")` → Restricts resources to the same domain.
* `frameOptions(frame -> frame.sameOrigin())` → Allows embedding only from the same domain.
* `xssProtection(xss -> xss.block(true))` → Enables XSS blocking.

#### **Disabling Security Headers (Not Recommended)**

We might need to disable certain headers in some cases, e.g., when using custom security mechanisms.

```java
@Bean
public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    http
        .headers(headers -> headers
            .frameOptions(HeadersConfigurer.FrameOptionsConfig::disable)  // Disable Clickjacking protection
            .xssProtection(XssProtectionConfig::disable)  // Disable XSS protection (Not recommended)
        );

    return http.build();
}
```

## **Custom Security Filters**

A **security filter** in Spring Security is a component that **intercepts HTTP requests and applies security logic** before passing them to the application.

* Spring Security uses a **filter chain** to process authentication, authorization, and other security concerns.
* Filters allow us to **modify request/response handling** at different stages.

Custom filters are needed when:

* Adding custom authentication mechanisms (e.g., API key authentication).
* Logging request details for security auditing.
* Implementing rate limiting for APIs.
* Validating JWT tokens in a custom way.
* Modifying headers before passing requests to controllers.

### **Adding a Custom Filter**

#### **Example: Logging All Incoming Requests**

Let’s create a filter that **logs request details** before passing them to controllers.

```java
@Component
public class RequestLoggingFilter extends OncePerRequestFilter {

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {
        String requestUrl = request.getRequestURI();
        String method = request.getMethod();

        System.out.println("Incoming Request: " + method + " " + requestUrl);

        // Continue the filter chain
        filterChain.doFilter(request, response);
    }
}
```

* **`OncePerRequestFilter`** ensures the filter runs **once per request**.
* **Logs request details** (`method` and `URI`).
* **Passes control** to the next filter (`filterChain.doFilter(...)`).

#### **Registering the Filter in Spring Security**

We need to **add the filter** to the Spring Security filter chain.

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http, RequestLoggingFilter requestLoggingFilter) throws Exception {
        http
            .addFilterBefore(requestLoggingFilter, UsernamePasswordAuthenticationFilter.class) // Add filter before authentication
            .authorizeHttpRequests(auth -> auth
                .anyRequest().authenticated()
            );

        return http.build();
    }
}
```

* `addFilterBefore(requestLoggingFilter, UsernamePasswordAuthenticationFilter.class)` → **Runs the custom filter before authentication**.
