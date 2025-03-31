# Session Management and Security

## About

Session management is a fundamental aspect of web security that enables applications to track user interactions **across multiple requests**. It ensures that authenticated users can maintain a **persistent session** while protecting against attacks like **session hijacking**, **session fixation**, and **cross-site request forgery (CSRF)**.

## **Why is Session Management Important?**

Without proper session management, attackers can:

* Hijack sessions (steal cookies and gain unauthorized access)
* Fixate sessions (force users to authenticate with a pre-defined session)
* Exploit CSRF vulnerabilities (perform unauthorized actions on behalf of users)

Proper session management ensures:

* User authentication continuity across multiple requests
* Session expiration and timeout mechanisms for security
* Protection against session hijacking and fixation

## **How Sessions Work?**

A session starts when a user **authenticates** and is assigned a **session ID (SID)**. The session ID is stored on the client (via cookies, URL parameters, or local storage) and mapped to **server-side session data**.

### **Session Lifecycle**

1. **User logs in** → Server creates a session and assigns a **Session ID (SID)**.
2. **Session ID is sent to the client** (usually in a secure HTTP-only cookie).
3. **Client includes SID in requests** to maintain authentication.
4. **Server validates SID** and retrieves session data.
5. **Session expires or is destroyed on logout/inactivity.**

## **Session Management in Spring Security**

Spring Security provides **built-in session management** to handle authentication, session fixation protection, and concurrent session control.

### **1. Configuring Session Management in Spring Boot**

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .sessionManagement(session -> session
                .sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED) // Controls when sessions are created
                .maximumSessions(1) // Limits concurrent sessions per user
                .expiredUrl("/session-expired") // Redirects if session expires
            )
            .authorizeHttpRequests(auth -> auth
                .anyRequest().authenticated()
            )
            .formLogin();

        return http.build();
    }
}
```

* `sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED)`: Creates a session **only when needed**.
* `maximumSessions(1)`: Allows **only one active session per user** (prevents multiple logins).
* `expiredUrl("/session-expired")`: Redirects users when their session expires.

### **2. Session Creation Policies in Spring Security**

<table data-header-hidden><thead><tr><th width="163"></th><th></th></tr></thead><tbody><tr><td><strong>Policy</strong></td><td><strong>Description</strong></td></tr><tr><td><code>ALWAYS</code></td><td>A session is always created, even if not needed.</td></tr><tr><td><code>IF_REQUIRED</code></td><td>A session is created <strong>only if necessary</strong> (default).</td></tr><tr><td><code>NEVER</code></td><td>Spring Security does not create a session, but will use an existing one.</td></tr><tr><td><code>STATELESS</code></td><td>No session is created; authentication must be handled per request (useful for APIs).</td></tr></tbody></table>

**For stateless authentication (e.g., JWT, OAuth2), use `STATELESS`** to avoid storing sessions on the server.

## **Session Fixation Protection**

Session Fixation is an attack where an attacker forces a user to authenticate with a **predefined session ID**, allowing the attacker to hijack the session later.

#### **Preventing Session Fixation in Spring Security**

Spring Security **automatically changes the session ID** upon authentication to prevent fixation attacks. We can explicitly configure it as:

```java
http
    .sessionManagement(session -> session
        .sessionFixation().migrateSession() // Generates a new session ID after login
    );
```

**Other options:**

<table data-header-hidden><thead><tr><th width="211"></th><th></th></tr></thead><tbody><tr><td><strong>Option</strong></td><td><strong>Description</strong></td></tr><tr><td><code>migrateSession()</code></td><td>Creates a new session and copies old session attributes (default).</td></tr><tr><td><code>newSession()</code></td><td>Creates a completely new session without copying attributes.</td></tr><tr><td><code>none()</code></td><td>Keeps the same session (not recommended).</td></tr></tbody></table>

## **Handling Session Expiration and Timeout**

**Configuring session timeout in `application.properties`:**

```properties
server.servlet.session.timeout=15m
```

This means the session **expires after 15 minutes of inactivity**.

{% hint style="info" %}
**Session Timeout Behavior in Spring Boot**

* When a session **times out**, users are redirected to a **login page**.
* We can **listen for session destruction events** using `HttpSessionListener`.
{% endhint %}

Example:

```java
@Component
public class SessionListener implements HttpSessionListener {
    @Override
    public void sessionDestroyed(HttpSessionEvent event) {
        System.out.println("Session expired: " + event.getSession().getId());
    }
}
```

## **Protecting Against Session Hijacking**

Session hijacking occurs when an attacker **steals a session ID** (via XSS, Man-in-the-Middle attacks, or insecure cookies) and impersonates the user.

### **Best Practices to Prevent Session Hijacking**

#### **1. Use Secure and HttpOnly Cookies**

```properties
server.servlet.session.cookie.http-only=true
server.servlet.session.cookie.secure=true
```

* **`HttpOnly`** → Prevents JavaScript from accessing cookies (mitigates XSS attacks).
* **`Secure`** → Ensures cookies are only sent over HTTPS.

#### **2. Regenerate Session ID After Login**

Spring Security does this automatically using `sessionFixation().migrateSession()`.

#### **3. Restrict Session Access by IP Address**

```java
String sessionIp = session.getAttribute("USER_IP").toString();
if (!request.getRemoteAddr().equals(sessionIp)) {
    session.invalidate(); // Terminate session if IP mismatch
}
```

#### **4. Use Content Security Policy (CSP) to Prevent XSS**

```http
Content-Security-Policy: default-src 'self'
```

CSP prevents **JavaScript injection** that could steal session cookies.

## **Preventing CSRF (Cross-Site Request Forgery)**

CSRF attacks trick **authenticated users** into making **unintended requests** to a website.

By default, Spring Security **enables CSRF protection** for **stateful applications**.

```java
http
    .csrf(csrf -> csrf.disable()); // Only disable CSRF for stateless APIs
```

For CSRF protection in **form-based authentication**, Spring generates a **CSRF token** that must be included in POST requests.

Example:

```html
<form action="/update-profile" method="POST">
    <input type="hidden" name="_csrf" value="CSRF_TOKEN">
    <button type="submit">Update Profile</button>
</form>
```

## **Concurrent Session Control**

Preventing Multiple Logins from the Same User

```java
http
    .sessionManagement(session -> session
        .maximumSessions(1) // Only 1 session per user
        .maxSessionsPreventsLogin(true) // Prevent new logins when session limit is reached
    );
```

If `maxSessionsPreventsLogin(true)`, new logins will be rejected if the user is already logged in.

## **Stateless Authentication (For REST APIs)**

For REST APIs, **sessions are not recommended**. Instead, use **JWT or OAuth2**.

```java
http
    .sessionManagement(session -> session
        .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
    );
```

`STATELESS` ensures the server **does not store sessions**, making it ideal for APIs.

## **Logging Out and Invalidating Sessions**

### **1. Logout Configuration in Spring Security**

```java
http
    .logout(logout -> logout
        .logoutUrl("/logout")
        .logoutSuccessUrl("/login?logout")
        .invalidateHttpSession(true) // Destroy session
        .deleteCookies("JSESSIONID") // Remove session cookie
    );
```

### **2. Manually Destroying Sessions**

```java
@RequestMapping("/logout")
public String logout(HttpServletRequest request) {
    HttpSession session = request.getSession(false);
    if (session != null) {
        session.invalidate(); // Destroy session
    }
    return "redirect:/login";
}
```

Ensure `invalidateHttpSession(true)` is set to completely clear user sessions upon logout.
