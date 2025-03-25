# SecurityContext

## About

`SecurityContext` is a **core component** in Spring Security responsible for **storing authentication details** of the currently authenticated user. It holds the `Authentication` object, which contains user credentials, authorities (roles), and additional security-related information.

In a typical Spring Security flow, `SecurityContext` is populated once a user is authenticated and remains accessible throughout the request lifecycle.

## Why is SecurityContext Important?

* **Stores user authentication details** securely.
* **Provides access to authenticated user information** in any part of the application.
* **Ensures thread-local storage**, allowing seamless access to authentication data within the same thread.
* **Plays a key role in method-level security**, allowing role-based authorization.

## **SecurityContext Interface**

The `SecurityContext` interface is defined as follows:

```java
public interface SecurityContext extends Serializable {
    Authentication getAuthentication();
    void setAuthentication(Authentication authentication);
}
```

<table data-header-hidden data-full-width="true"><thead><tr><th></th><th></th></tr></thead><tbody><tr><td><strong>Method</strong></td><td><strong>Purpose</strong></td></tr><tr><td><code>getAuthentication()</code></td><td>Retrieves the current <code>Authentication</code> object.</td></tr><tr><td><code>setAuthentication(Authentication authentication)</code></td><td>Updates the authentication details in the context.</td></tr></tbody></table>

## **SecurityContextHolder – Managing SecurityContext**

Spring Security provides `SecurityContextHolder`, a utility class for accessing the current `SecurityContext`.

```java
public class SecurityContextHolder {
    public static SecurityContext getContext();
    public static void setContext(SecurityContext context);
    public static void clearContext();
}
```

| **Method**                            | **Purpose**                                      |
| ------------------------------------- | ------------------------------------------------ |
| `getContext()`                        | Retrieves the current `SecurityContext`.         |
| `setContext(SecurityContext context)` | Manually sets a new `SecurityContext`.           |
| `clearContext()`                      | Clears authentication details (e.g., on logout). |

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

## **How to Access SecurityContext in Spring Applications**

### **1. Accessing SecurityContext in Controllers**

Spring provides `SecurityContextHolder` to retrieve authentication details.

```java
@GetMapping("/user-info")
public ResponseEntity<String> getUserInfo() {
    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    String username = authentication.getName();
    return ResponseEntity.ok("Authenticated User: " + username);
}
```

* Retrieves the **currently logged-in user's username**.
* `authentication.getAuthorities()` can be used to fetch **roles/permissions**.

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

* Ensures authentication details are available throughout the request lifecycle.

### **3. Setting SecurityContext Manually**

If we need to **set authentication manually** (e.g., for programmatic login):

```java
UsernamePasswordAuthenticationToken auth =
    new UsernamePasswordAuthenticationToken("user", null, List.of(new SimpleGrantedAuthority("ROLE_USER")));

SecurityContextHolder.getContext().setAuthentication(auth);
```

* This is useful for **custom authentication mechanisms**.

## **SecurityContext in Spring Boot**

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
