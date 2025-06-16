# Form-Based Authentication

## About

Form-Based Authentication is a common authentication method in web applications where users log in using a custom login form (username and password). Unlike Basic Authentication, which uses HTTP headers, Form-Based Authentication handles authentication at the application level, allowing better customization and integration with user sessions.

Spring Security provides **built-in support for Form-Based Authentication**, making it easy to secure web applications with login forms.

## **How Form-Based Authentication Works**

1. **User Requests a Secured Resource**
   * The user tries to access a protected page without being authenticated.
2. **Redirect to Login Page**
   * Spring Security intercepts the request and redirects the user to the login page.
3. **User Submits Credentials**
   * The user enters their username and password into the login form and submits it.
4. **Server Processes Authentication**
   * Spring Security captures the login request and processes authentication using `AuthenticationManager` and `AuthenticationProvider`.
5. **Authentication Success or Failure**
   * If credentials are valid: The user is authenticated and redirected to the requested page.
   * If authentication fails: The login page is shown again with an error message.

## **Form-Based Authentication in Spring Security**

### **1. Enabling Authentication in Spring Boot 2 (Spring Security 5)**

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .authorizeRequests()
                .anyRequest().authenticated()  // All requests require authentication
                .and()
            .formLogin()  // Enables Form-Based Authentication
                .loginPage("/login")  // Custom login page URL
                .permitAll();
    }
}
```

* This configuration ensures:
  * All requests require authentication.
  * Users are redirected to `/login` if not authenticated.
  * The login page is accessible to all users.

### **2. Enabling Authentication in Spring Boot 3 (Spring Security 6) – New Security DSL**

Spring Boot 3 and Spring Security 6 use a **Lambda-based Security DSL** instead of `WebSecurityConfigurerAdapter`:

```java
@Configuration
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .anyRequest().authenticated()
            )
            .formLogin(form -> form
                .loginPage("/login")  // Custom login page
                .permitAll()
            );

        return http.build();
    }
}
```

## **How Spring Security Handles Form-Based Authentication**

Spring Security uses several key components for handling authentication via a login form:

<table data-header-hidden data-full-width="true"><thead><tr><th width="345"></th><th></th></tr></thead><tbody><tr><td><strong>Component</strong></td><td><strong>Role</strong></td></tr><tr><td><strong>Security Filter Chain</strong></td><td>Intercepts HTTP requests and applies security rules.</td></tr><tr><td><strong>UsernamePasswordAuthenticationFilter</strong></td><td>Captures login requests and extracts credentials.</td></tr><tr><td><strong>AuthenticationManager</strong></td><td>Delegates authentication to an <code>AuthenticationProvider</code>.</td></tr><tr><td><strong>DaoAuthenticationProvider</strong></td><td>Verifies credentials using <code>UserDetailsService</code>.</td></tr><tr><td><strong>UserDetailsService</strong></td><td>Loads user details from a database or in-memory storage.</td></tr><tr><td><strong>PasswordEncoder</strong></td><td>Encrypts and verifies passwords.</td></tr><tr><td><strong>SecurityContext</strong></td><td>Stores authenticated user details.</td></tr><tr><td><strong>SecurityContextHolder</strong></td><td>Provides access to the <code>SecurityContext</code></td></tr></tbody></table>

## **Customizing Form-Based Authentication in Spring Security**

### **1. Custom Login Page**

By default, Spring Security provides a login page. To use a custom login page, define a controller and an HTML template:

```java
@Controller
public class LoginController {

    @GetMapping("/login")
    public String loginPage() {
        return "login";  // Returns login.html
    }
}
```

**Custom Login Page (`src/main/resources/templates/login.html`)**

```html
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
</head>
<body>
    <h2>Login</h2>
    <form method="post" action="/login">
        <label>Username: <input type="text" name="username"></label><br>
        <label>Password: <input type="password" name="password"></label><br>
        <button type="submit">Login</button>
    </form>
</body>
</html>
```

* This replaces Spring Security’s default login form.

### **2. Custom Success and Failure URLs**

To redirect users after login success or failure:

```java
@Bean
public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    http
        .authorizeHttpRequests(auth -> auth
            .anyRequest().authenticated()
        )
        .formLogin(form -> form
            .loginPage("/login")
            .defaultSuccessUrl("/home", true)  // Redirect after successful login
            .failureUrl("/login?error=true")  // Redirect after failed login
            .permitAll()
        );

    return http.build();
}
```

* **`defaultSuccessUrl("/home", true)`** → Redirects to `/home` after login.
* **`failureUrl("/login?error=true")`** → Redirects back to `/login` on failure.

### **3. Custom Authentication Provider**

Instead of `UserDetailsService`, we can define a custom authentication provider:

```java
@Component
public class CustomAuthenticationProvider implements AuthenticationProvider {

    @Override
    public Authentication authenticate(Authentication authentication) throws AuthenticationException {
        String username = authentication.getName();
        String password = authentication.getCredentials().toString();

        if ("admin".equals(username) && "password".equals(password)) {
            return new UsernamePasswordAuthenticationToken(username, password, List.of(new SimpleGrantedAuthority("ROLE_USER")));
        } else {
            throw new BadCredentialsException("Invalid Credentials");
        }
    }

    @Override
    public boolean supports(Class<?> authentication) {
        return authentication.equals(UsernamePasswordAuthenticationToken.class);
    }
}
```

* This provider directly validates credentials instead of using `UserDetailsService`.

## **When to Use Form-Based Authentication?**

Form-Based Authentication is **suitable for web applications** that require user authentication via a login form. Below are the key scenarios where it is the **right choice** and situations where it may **not be ideal**.

### **When to Use Form-Based Authentication**

1. **Traditional Web Applications**
   * Suitable for applications with **server-side rendering** (JSP, Thymeleaf, Freemarker, etc.).
   * Example: Banking portals, HR systems, admin dashboards.
2. **Session-Based Authentication**
   * Works well when users have persistent **sessions** (cookies, session storage).
   * Example: Employee portals, university login systems.
3. **Need for a Custom Login Page**
   * Allows **UI customization** instead of using browser popups (like Basic Authentication).
   * Example: E-commerce platforms, customer dashboards.
4. **Multi-Page Applications (MPAs)**
   * Suitable for **multi-page applications** (MPAs) where users navigate between pages.
   * Example: ERP systems, customer service portals.
5. **When Security Enhancements are Needed**
   * Allows **password policies**, **account lockout**, and **captcha integration**.
   * Example: Enterprise applications with strict security requirements.
6. **When Using Stateful Authentication**
   * Works well in **monolithic applications** where the backend handles user sessions.
   * Example: Internal business applications.

### **When NOT to Use Form-Based Authentication**

1. **For REST APIs and Microservices**
   * APIs require **stateless authentication** (JWT, OAuth2).
   * Alternative: **Use JWT Authentication** instead of sessions.
2. **For Single-Page Applications (SPAs)**
   * SPAs (React, Angular, Vue) rely on **token-based authentication** (JWT, OAuth2).
   * Alternative: **Use OAuth2 with access tokens**.
3. **For Mobile Applications**
   * Mobile apps do not maintain web-based **sessions**.
   * Alternative: **Use OAuth2 or API Key Authentication**.
4. **When You Need Scalability**
   * Sessions require **server-side state**, making horizontal scaling difficult.
   * Alternative: **Use JWT (stateless authentication)** for better scaling.
