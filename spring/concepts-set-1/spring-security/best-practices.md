# Best Practices

## About

Spring Security is a powerful framework for securing Java applications. However, improper configurations can introduce vulnerabilities. This guide covers **best practices** for authentication, authorization, session management, secure coding, and more to ensure a robust security posture.

## **1. Authentication Best Practices**

Authentication verifies user identity. Weak authentication mechanisms expose applications to attacks like **credential stuffing, brute force attacks, and session hijacking**.

### **Use Strong Password Hashing**

* Store passwords securely using **BCrypt**, **Argon2**, or **PBKDF2**.
* Avoid using MD5, SHA-1, or unsalted hashing algorithms.

**Example:** Using `BCryptPasswordEncoder` in Spring Security:

```java
@Bean
public PasswordEncoder passwordEncoder() {
    return new BCryptPasswordEncoder(12); // 12 is the strength factor
}
```

{% hint style="info" %}
Why BCrypt? It includes automatic salting and is resistant to brute force attacks.
{% endhint %}

### **Implement Multi-Factor Authentication (MFA)**

* Require users to verify their identity using TOTP, OTP, or biometric authentication.
* Use Spring Security OAuth2 with MFA providers like Google Authenticator.

### **Use Secure Session Management**

* Regenerate session IDs upon login to prevent session fixation attacks.
* Limit session lifetimes and implement idle timeouts.
* Destroy sessions on logout.

Example:

```java
http.sessionManagement(session -> session
    .sessionFixation().migrateSession()
    .maximumSessions(1)
    .expiredUrl("/session-expired")
);
```

### **Protect Against Brute Force Attacks**

* Implement **account lockout** after multiple failed login attempts.
* Use **rate-limiting** to throttle repeated authentication attempts.
* Deploy **CAPTCHA** for suspicious login attempts.

Example:

```java
@Bean
public AuthenticationEventPublisher authenticationEventPublisher() {
    return new DefaultAuthenticationEventPublisher();
}
```

Spring Security provides **AuthenticationFailureEvent**, which can trigger account lockouts.

## **2. Authorization Best Practices**

Authorization controls **who can access what** in an application.

### **Use Role-Based Access Control (RBAC) and Attribute-Based Access Control (ABAC)**

RBAC uses **roles** to grant permissions.

```java
http.authorizeHttpRequests(auth -> auth
    .requestMatchers("/admin/**").hasRole("ADMIN")
    .requestMatchers("/user/**").hasAnyRole("USER", "ADMIN")
    .anyRequest().authenticated()
);
```

ABAC considers **user attributes, environment conditions, and context** to enforce fine-grained policies.

Example (ABAC using Spring Security SpEL):

```java
@PreAuthorize("hasRole('ADMIN') and #user.id == authentication.principal.id")
public void deleteUser(User user) { ... }
```

### **Enforce Least Privilege**

* Assign users **the minimum permissions necessary** for their tasks.
* **Avoid using wildcard permissions** (e.g., `@RolesAllowed("*")`).
* Regularly audit **roles and permissions**.

### **Secure Method-Level Authorization**

Use annotations like `@PreAuthorize` and `@PostAuthorize` for method-level security.

```java
@PreAuthorize("hasAuthority('DELETE_USER')")
public void deleteUser(Long userId) { ... }
```

## **3. Secure Session Management**

### **Use Secure Cookie Attributes**

Configure session cookies to be **HttpOnly, Secure, and SameSite**.

```properties
propertiesCopyEditserver.servlet.session.cookie.http-only=true
server.servlet.session.cookie.secure=true
server.servlet.session.cookie.same-site=strict
```

**Why?**

* `HttpOnly` prevents **XSS-based session theft**.
* `Secure` ensures cookies are **only transmitted over HTTPS**.
* `SameSite` prevents **CSRF attacks**.

### **Implement Logout Properly**

* Invalidate sessions on logout.
* Delete authentication cookies.

Example:

```java
http.logout(logout -> logout
    .logoutUrl("/logout")
    .invalidateHttpSession(true)
    .deleteCookies("JSESSIONID")
);
```

## **4. Security Headers and Protection Against Attacks**

Security headers protect applications from **common web vulnerabilities**.

### **Enable Security Headers**

Use Spring Security’s built-in support for security headers.

```java
http.headers(headers -> headers
    .contentSecurityPolicy("default-src 'self'")
    .xssProtection(xss -> xss.block(true))
    .frameOptions(HeadersConfigurer.FrameOptionsConfig::deny)
    .httpStrictTransportSecurity(hsts -> hsts.includeSubDomains(true).maxAgeInSeconds(31536000))
);
```

### **Prevent Cross-Site Scripting (XSS)**

* Use **CSP (Content Security Policy)**.
* Escape all user-generated input before rendering.

### **Prevent Cross-Site Request Forgery (CSRF)**

* **Enable CSRF protection** for non-API applications.

```java
http.csrf(csrf -> csrf
    .csrfTokenRepository(CookieCsrfTokenRepository.withHttpOnlyFalse())
);
```

**For REST APIs**, **disable CSRF** (stateless applications).

### **Use HTTPS and Enforce HSTS**

* **Never allow HTTP** connections for authenticated users.
* Use **HTTP Strict Transport Security (HSTS)** to force HTTPS.

```java
http.headers(headers -> headers
    .httpStrictTransportSecurity(hsts -> hsts.includeSubDomains(true).maxAgeInSeconds(31536000))
);
```

## **5. Secure API Development**

### **Use Stateless Authentication for APIs**

* Use **JWT (JSON Web Token)** for authentication instead of sessions.

```java
http.sessionManagement(session -> session
    .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
);
```

### **Validate and Sanitize Input**

* **Reject untrusted user input** to prevent SQL Injection and XSS.
* Use parameterized queries instead of string concatenation:

```java
jdbcTemplate.update("SELECT * FROM users WHERE username = ?", username);
```

### **Restrict CORS Properly**

* **Do not allow `*` in CORS policies**.
* Allow only specific origins:

```java
@Bean
public WebMvcConfigurer corsConfigurer() {
    return new WebMvcConfigurer() {
        @Override
        public void addCorsMappings(CorsRegistry registry) {
            registry.addMapping("/api/**")
                .allowedOrigins("https://trusted-site.com")
                .allowedMethods("GET", "POST");
        }
    };
}
```

## **6. Secure Development and Deployment**

### **Enable Logging and Monitoring**

* Monitor **failed authentication attempts** and **suspicious access patterns**.
* Use **Spring Boot Actuator** for security audits.

Example: Enabling security events logging:

```properties
logging.level.org.springframework.security=DEBUG
```

### **Keep Dependencies Updated**

* Use **dependency management tools** (Maven or Gradle) to avoid outdated libraries.

```xml
<dependency>
    <groupId>org.springframework.security</groupId>
    <artifactId>spring-security-core</artifactId>
    <version>latest</version>
</dependency>
```

### **Use Secrets Management for Credentials**

* Do not hardcode secrets in application properties.
* Use environment variables or secrets management tools (Vault, AWS Secrets Manager, Azure Key Vault).



