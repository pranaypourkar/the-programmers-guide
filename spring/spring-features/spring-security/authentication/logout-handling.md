# Logout Handling

## About

Logout Handling in Spring Security is the **process of terminating an authenticated session**, ensuring the user is properly logged out and any session data is cleared.

### **Why is Logout Handling Important?**

* **Security** – Prevent unauthorized access after a user logs out.
* **Session Cleanup** – Remove authentication details from memory.
* **Token Revocation** – Ensure JWT or API tokens are invalidated.

## **How Logout Works in Spring Security?**

Spring Security provides **built-in logout support** that:

* **Invalidates HTTP session** (if using session-based authentication).
* **Clears SecurityContext** (removes authentication details).
* **Deletes Remember-Me cookies** (if enabled).
* **Redirects users after logout (configurable)**.

## **Default Logout Handling in Spring Security**

By default, Spring Security enables logout via a **GET or POST request to `/logout`**.

* **For session-based authentication**, it **invalidates the session**.
* **For JWT or API tokens**, additional custom logic is needed.

## **Implementing Logout in Spring Security**

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
            .formLogin(withDefaults()) // Enables login
            .logout(logout -> logout // Enables logout
                .logoutUrl("/logout") // Custom logout URL
                .logoutSuccessUrl("/login?logout") // Redirect after logout
                .invalidateHttpSession(true) // Invalidate session
                .deleteCookies("JSESSIONID") // Remove cookies
            );

        return http.build();
    }
}
```

* `logoutUrl("/logout")` → Defines the logout endpoint.
* `logoutSuccessUrl("/login?logout")` → Redirects users after logout.
* `invalidateHttpSession(true)` → Destroys the session.
* `deleteCookies("JSESSIONID")` → Removes session cookies.

## **Custom Logout Handler**

If we need **custom logic** (e.g., logging, token revocation, auditing), implement a **LogoutHandler**.

### **Step 1: Create a Custom Logout Handler**

```java
@Component
public class CustomLogoutHandler implements LogoutHandler {

    @Override
    public void logout(HttpServletRequest request, HttpServletResponse response,
                       Authentication authentication) {
        if (authentication != null) {
            System.out.println("User " + authentication.getName() + " is logging out.");
        }
        request.getSession().invalidate(); // Invalidate session
    }
}
```

* `logout()` method executes custom logic (e.g., logging, API calls).
* Can be used to **log logout events** or **notify external services**.

### **Step 2: Register the Custom Logout Handler**

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Autowired
    private CustomLogoutHandler customLogoutHandler;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .anyRequest().authenticated()
            )
            .logout(logout -> logout
                .addLogoutHandler(customLogoutHandler) // Register custom logout handler
                .logoutSuccessUrl("/login?logout")
            );

        return http.build();
    }
}
```

### **Logout in JWT-Based Authentication**

In **JWT-based authentication**, logout **does not rely on session invalidation**. Instead, we:

* **Blacklist JWTs** (store invalid tokens in a database or cache).
* **Use short-lived tokens** with refresh tokens.
* **Clear tokens from client-side storage** (e.g., local storage or cookies).

#### **Custom JWT Logout Handler**

```java
@Component
public class JwtLogoutHandler implements LogoutHandler {

    @Autowired
    private TokenBlacklistService tokenBlacklistService; // Custom service to blacklist JWT

    @Override
    public void logout(HttpServletRequest request, HttpServletResponse response, Authentication authentication) {
        String token = extractToken(request);
        if (token != null) {
            tokenBlacklistService.blacklistToken(token); // Add token to blacklist
        }
    }

    private String extractToken(HttpServletRequest request) {
        String bearerToken = request.getHeader("Authorization");
        return (bearerToken != null && bearerToken.startsWith("Bearer ")) ?
                bearerToken.substring(7) : null;
    }
}
```

* Extracts JWT token from **Authorization header**.
* Adds token to a **blacklist (Redis, database, etc.)**.

#### **Register JWT Logout Handler**

```java
@Bean
public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    http
        .authorizeHttpRequests(auth -> auth
            .anyRequest().authenticated()
        )
        .logout(logout -> logout
            .addLogoutHandler(new JwtLogoutHandler())
            .logoutSuccessHandler((request, response, authentication) -> {
                response.setStatus(HttpServletResponse.SC_OK);
            })
        );

    return http.build();
}
```

* `logoutSuccessHandler()` sends a `200 OK` response instead of redirecting.

### **Logout in OAuth2 Authentication**

In **OAuth2-based authentication**, logging out means:

* **Clearing the local session**.
* **Revoking the OAuth2 access token** (if supported by provider).



```java
@Component
public class OAuth2LogoutHandler implements LogoutHandler {

    @Autowired
    private OAuth2AuthorizedClientService clientService;

    @Override
    public void logout(HttpServletRequest request, HttpServletResponse response, Authentication authentication) {
        if (authentication instanceof OAuth2AuthenticationToken) {
            OAuth2AuthenticationToken oauthToken = (OAuth2AuthenticationToken) authentication;
            clientService.removeAuthorizedClient(oauthToken.getAuthorizedClientRegistrationId(), oauthToken.getName());
        }
    }
}
```

* **Removes OAuth2 tokens** from the client store.

### **Custom Logout Success Handler**

If we need to perform **custom logic after logout**, implement `LogoutSuccessHandler`.

```java
@Component
public class CustomLogoutSuccessHandler implements LogoutSuccessHandler {
    @Override
    public void onLogoutSuccess(HttpServletRequest request, HttpServletResponse response,
                                Authentication authentication) throws IOException {
        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().write("Logout Successful!");
    }
}
```

* Sends a **custom response** instead of a redirect.

#### **Register Logout Success Handler**

```java
@Bean
public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    http
        .logout(logout -> logout
            .logoutUrl("/logout")
            .logoutSuccessHandler(new CustomLogoutSuccessHandler())
        );

    return http.build();
}
```

## **Security Considerations for Logout Handling**

| **Risk**                   | **Mitigation**                         |
| -------------------------- | -------------------------------------- |
| **Session Hijacking**      | Ensure session invalidation on logout. |
| **Token Replay Attacks**   | Implement JWT blacklisting.            |
| **CSRF Attacks on Logout** | Use POST-only logout requests.         |
