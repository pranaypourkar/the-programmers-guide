# Custom Authentication

## About

Custom Authentication in Spring Security allows developers to define **custom logic** for verifying user credentials instead of using the default authentication mechanisms like **Basic Authentication, Form-Based Authentication, JWT, or OAuth2**.

This is useful when:

* We have a **custom user store** (e.g., database, LDAP, API, or third-party service).
* We need **additional validation** beyond username and password (e.g., checking user status, roles, OTP, or security questions).
* We require a **non-standard authentication flow** (e.g., token-based or biometric authentication).

## **How Does Custom Authentication Work?**

Spring Security authentication follows a **step-by-step process**. When customizing authentication, we typically extend or override one or more of the following components:

#### **Core Components in Custom Authentication**

<table data-header-hidden><thead><tr><th width="227"></th><th></th></tr></thead><tbody><tr><td><strong>Component</strong></td><td><strong>Role in Authentication</strong></td></tr><tr><td><strong>AuthenticationManager</strong></td><td>Main interface that delegates authentication requests.</td></tr><tr><td><strong>AuthenticationProvider</strong></td><td>Custom logic to validate user credentials.</td></tr><tr><td><strong>UserDetailsService</strong></td><td>Loads user-specific data from a database or API.</td></tr><tr><td><strong>UserDetails</strong></td><td>Represents authenticated user details.</td></tr><tr><td><strong>PasswordEncoder</strong></td><td>Hashes passwords for secure authentication.</td></tr><tr><td><strong>SecurityFilterChain</strong></td><td>Configures authentication mechanisms and filters.</td></tr></tbody></table>

### **Implementing Custom Authentication in Spring Security**

To create a **custom authentication mechanism**, we typically:

1. Implement a **Custom AuthenticationProvider**.
2. Implement a **Custom UserDetailsService** (if needed).
3. Configure authentication inside **SecurityFilterChain**.

## **Step-by-Step Implementation of Custom Authentication**

### **Step 1: Implement a Custom Authentication Provider**

A **Custom Authentication Provider** replaces Spring Security’s default authentication logic.

```java
@Component
public class CustomAuthenticationProvider implements AuthenticationProvider {

    @Autowired
    private UserDetailsService userDetailsService; // Loads user from database

    @Autowired
    private PasswordEncoder passwordEncoder; // Hashes password

    @Override
    public Authentication authenticate(Authentication authentication) throws AuthenticationException {
        String username = authentication.getName();
        String password = authentication.getCredentials().toString();

        // Load user details from DB or any external source
        UserDetails userDetails = userDetailsService.loadUserByUsername(username);

        // Validate password
        if (!passwordEncoder.matches(password, userDetails.getPassword())) {
            throw new BadCredentialsException("Invalid username or password");
        }

        // If authentication is successful, return an authenticated token
        return new UsernamePasswordAuthenticationToken(
            userDetails, password, userDetails.getAuthorities()
        );
    }

    @Override
    public boolean supports(Class<?> authentication) {
        return UsernamePasswordAuthenticationToken.class.isAssignableFrom(authentication);
    }
}
```

* Loads user details using `UserDetailsService`.
* Compares passwords using `PasswordEncoder`.
* Returns an **authenticated token** upon success.

### **Step 2: Implement a Custom UserDetailsService (If Needed)**

If user details need to be fetched from a **database, API, or another source**, implement `UserDetailsService`.

```java
@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private UserRepository userRepository; // Custom JPA repository

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));

        return new org.springframework.security.core.userdetails.User(
                user.getUsername(), 
                user.getPassword(), 
                user.getAuthorities()
        );
    }
}
```

* Fetches user details from a **database**.
* Converts `User` entity into `UserDetails`.

### **Step 3: Configure SecurityFilterChain**

Finally, register the **Custom Authentication Provider** inside `SecurityFilterChain`.

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Autowired
    private CustomAuthenticationProvider customAuthenticationProvider;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .anyRequest().authenticated()
            )
            .authenticationProvider(customAuthenticationProvider) // Register custom authentication
            .formLogin(withDefaults());

        return http.build();
    }
}
```

* Registers **CustomAuthenticationProvider** inside Spring Security.
* Uses **Form-Based Login** (can be replaced with another authentication method).

## **Handling Custom Authentication Logic**

We can modify the authentication logic based on:

<table data-header-hidden data-full-width="true"><thead><tr><th></th><th></th></tr></thead><tbody><tr><td><strong>Scenario</strong></td><td><strong>Customization</strong></td></tr><tr><td><strong>Custom User Store (e.g., NoSQL, External API, LDAP, etc.)</strong></td><td>Modify <code>UserDetailsService</code> to load users from a different source.</td></tr><tr><td><strong>Custom Password Hashing</strong></td><td>Replace <code>PasswordEncoder</code> with a custom implementation.</td></tr><tr><td><strong>Multi-Factor Authentication (MFA)</strong></td><td>Extend <code>AuthenticationProvider</code> to verify OTPs or security questions.</td></tr><tr><td><strong>Biometric Authentication</strong></td><td>Integrate with third-party biometric authentication services.</td></tr></tbody></table>

## **When to Use Custom Authentication?**

<table data-header-hidden data-full-width="true"><thead><tr><th width="384"></th><th></th></tr></thead><tbody><tr><td><strong>Scenario</strong></td><td><strong>Why Custom Authentication?</strong></td></tr><tr><td><strong>Using a custom user store (API, NoSQL, etc.)</strong></td><td>Spring’s default authentication only supports JDBC/LDAP.</td></tr><tr><td><strong>Enforcing additional security measures</strong></td><td>Custom validations like OTP, security questions, or biometric login.</td></tr><tr><td><strong>Building a REST API with JWT authentication</strong></td><td>Stateless authentication for APIs.</td></tr><tr><td><strong>Custom login flows (e.g., SSO, social login, third-party auth)</strong></td><td>Default mechanisms may not support complex authentication logic.</td></tr></tbody></table>
