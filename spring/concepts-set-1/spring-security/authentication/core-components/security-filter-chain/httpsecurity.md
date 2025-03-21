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

### **Basic Authentication**

### Form-Based Authentication

### JWT Authentication (Using Custom Filter)

### OAuth2 Login (Social Logins)



## Authorization Rules

### Role-Based Access Control

### Method-Level Security



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





