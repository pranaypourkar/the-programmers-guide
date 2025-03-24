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

### **Stateless Session (For REST APIs)**

### Preventing Session Fixation Attacks



## **CSRF Protection**

### **Disabling CSRF for APIs**

### Enabling CSRF for Web Applications



## **CORS Configuration**

### **Global CORS Policy**

### Security Headers



## **Custom Security Filters**

### **Adding a Custom Filter**





