# SecurityContextHolder

## About

`SecurityContextHolder` is a utility class in **Spring Security** that provides access to the `SecurityContext`. It is responsible for **storing and retrieving authentication details** of the currently authenticated user. It plays a important role in **Spring Security’s authentication and authorization process** by maintaining security information throughout the lifecycle of a request.

## **Why is SecurityContextHolder Important?**

* **Centralized access to security details** – Provides access to the currently authenticated user from anywhere in the application.
* **Manages security context per thread** – Ensures thread-local storage of authentication details.
* **Facilitates method-level security** – Used to enforce role-based access.
* **Allows customization of storage strategies** – Supports different ways to store security context data.

## **SecurityContextHolder Class Overview**

The `SecurityContextHolder` class is a **final** class that provides static methods for managing the security context.

```java
public final class SecurityContextHolder {
    public static SecurityContext getContext();
    public static void setContext(SecurityContext context);
    public static void clearContext();
    public static void setStrategyName(String strategyName);
}
```

<table data-header-hidden data-full-width="true"><thead><tr><th width="371"></th><th></th></tr></thead><tbody><tr><td><strong>Method</strong></td><td><strong>Purpose</strong></td></tr><tr><td><code>getContext()</code></td><td>Retrieves the current <code>SecurityContext</code>.</td></tr><tr><td><code>setContext(SecurityContext context)</code></td><td>Manually sets the security context.</td></tr><tr><td><code>clearContext()</code></td><td>Clears authentication details (used on logout).</td></tr><tr><td><code>setStrategyName(String strategyName)</code></td><td>Changes the storage strategy (default is ThreadLocal)</td></tr></tbody></table>

## **SecurityContext Storage Strategies**

Spring Security provides three different strategies for storing `SecurityContext`:

<table data-header-hidden data-full-width="true"><thead><tr><th width="226"></th><th width="391"></th><th></th></tr></thead><tbody><tr><td><strong>Strategy</strong></td><td><strong>Description</strong></td><td><strong>Usage</strong></td></tr><tr><td><strong>ThreadLocal (Default)</strong></td><td>Stores <code>SecurityContext</code> in the current thread.</td><td>Default strategy, used in web apps.</td></tr><tr><td><strong>InheritableThreadLocal</strong></td><td>Allows child threads to inherit <code>SecurityContext</code>.</td><td>Useful for async processing.</td></tr><tr><td><strong>Global (Shared Context)</strong></td><td>A single <code>SecurityContext</code> shared across all threads.</td><td>Not recommended due to security risks.</td></tr></tbody></table>

### **Changing SecurityContext Strategy**

We can change the default `ThreadLocal` storage to `MODE_INHERITABLETHREADLOCAL`:

```java
SecurityContextHolder.setStrategyName(SecurityContextHolder.MODE_INHERITABLETHREADLOCAL);
```

### Clearing SecurityContext on Logout

To clear the security context on logout, we can use:

```java
SecurityContextHolder.clearContext();
```

* Prevents unauthorized access after logout

## **How to Use SecurityContextHolder**

### **1. Accessing SecurityContext in Controllers**

Spring Security provides `SecurityContextHolder` to retrieve authentication details.

```java
@GetMapping("/user-info")
public ResponseEntity<String> getUserInfo() {
    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    String username = authentication.getName();
    return ResponseEntity.ok("Authenticated User: " + username);
}
```

* Retrieves the **currently logged-in user's username**.
* &#x20;`authentication.getAuthorities()` can be used to fetch **roles/permissions**.

### **2. Accessing SecurityContext in Services**

If we need user details inside a service layer:

```java
@Service
public class UserService {
    public String getCurrentUsername() {
        return SecurityContextHolder.getContext().getAuthentication().getName();
    }
}
```

* **Ensures authentication details are available throughout the request lifecycle**.

### **3. Setting SecurityContext Manually**

If we need to **set authentication manually** (e.g., for programmatic login):

```java
UsernamePasswordAuthenticationToken auth =
    new UsernamePasswordAuthenticationToken("user", null, List.of(new SimpleGrantedAuthority("ROLE_USER")));

SecurityContextHolder.getContext().setAuthentication(auth);
```

* This is useful for **custom authentication mechanisms**.

## SecurityContextHolder Configuration **in Spring Boot**

### **Spring Boot 2 – SecurityContext Configuration**

Before Spring Security 5.7+, configurations were done via `WebSecurityConfigurerAdapter`:

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.authorizeRequests()
            .anyRequest().authenticated()
            .and()
            .formLogin()
            .and()
            .logout().logoutSuccessHandler((req, res, auth) -> SecurityContextHolder.clearContext());
    }
}
```

* Uses `SecurityContextHolder.clearContext()` on logout.

### **Spring Boot 3 – SecurityContext Configuration**

Spring Boot 3 removes `WebSecurityConfigurerAdapter` and uses bean-based configuration:

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http.authorizeHttpRequests(auth -> auth.anyRequest().authenticated())
            .formLogin(Customizer.withDefaults())
            .logout(logout -> logout.logoutSuccessHandler((req, res, auth) -> SecurityContextHolder.clearContext()));
        return http.build();
    }
}
```

* Uses lambda-based DSL for cleaner security configuration.





