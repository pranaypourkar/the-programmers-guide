# AuthenticationProvider

## About

The `AuthenticationProvider` is a core component in Spring Security that **performs actual authentication** logic. It is responsible for validating user credentials and returning an `Authentication` object if authentication is successful.

Unlike `AuthenticationManager`, which acts as a **delegator**, the `AuthenticationProvider` actually **implements** authentication logic. Multiple `AuthenticationProvider` instances can be registered to support different authentication mechanisms (e.g., **username/password, JWT, OAuth2, LDAP, etc.**).

## **Responsibilities of AuthenticationProvider**

1. **Processes authentication requests** received from `AuthenticationManager`.
2. **Verifies credentials** using `UserDetailsService`, an external system, or a database.
3. **Returns a valid Authentication object** on success or throws an exception on failure.
4. **Supports multiple authentication mechanisms** via different implementations.
5. **Customizable** to support custom authentication logic.

## **Authentication Flow in Spring Security**

### **1. User submits credentials**

A user submits a login request with username and password.

### **2. AuthenticationManager delegates to AuthenticationProvider**

Spring Security's `AuthenticationManager` calls one of its registered `AuthenticationProvider` instances.

```java
Authentication authentication = authenticationManager.authenticate(
    new UsernamePasswordAuthenticationToken(username, password)
);
```

### **3. AuthenticationProvider verifies credentials**

* Extracts credentials from `Authentication` object.
* Checks username against the database.
* Verifies the password using `PasswordEncoder`.

### **4. AuthenticationProvider returns Authentication object**

If the credentials are valid, it returns an `Authentication` object that contains the authenticated user's details.

### **5. SecurityContext stores Authentication object**

If authentication is successful, the result is stored in `SecurityContextHolder`:

```java
SecurityContextHolder.getContext().setAuthentication(authentication);
```

## **Built-in AuthenticationProvider Implementations**

Spring Security provides multiple built-in `AuthenticationProvider` implementations:

<table data-header-hidden data-full-width="true"><thead><tr><th width="388"></th><th></th></tr></thead><tbody><tr><td><strong>AuthenticationProvider</strong></td><td><strong>Description</strong></td></tr><tr><td><code>DaoAuthenticationProvider</code></td><td>Standard provider for username/password authentication using <code>UserDetailsService</code>.</td></tr><tr><td><code>LdapAuthenticationProvider</code></td><td>Authentication against an LDAP directory.</td></tr><tr><td><code>JwtAuthenticationProvider</code></td><td>Custom provider for JWT-based authentication.</td></tr><tr><td><code>OAuth2AuthenticationProvider</code></td><td>Handles OAuth2 authentication.</td></tr><tr><td><code>CasAuthenticationProvider</code></td><td>Authentication via Central Authentication Service (CAS).</td></tr><tr><td><code>SamlAuthenticationProvider</code></td><td>Authentication via SAML 2.0.</td></tr><tr><td><code>ActiveDirectoryLdapAuthenticationProvider</code></td><td>Microsoft Active Directory authentication.</td></tr></tbody></table>

### **1. DaoAuthenticationProvider (Username/Password Authentication)**

The most commonly used authentication provider in Spring Security. It retrieves user details from `UserDetailsService`and verifies the password using `PasswordEncoder`.

#### **Default DaoAuthenticationProvider Implementation**

Spring Boot automatically configures a `DaoAuthenticationProvider` when `UserDetailsService` and `PasswordEncoder`are available.

```java
@Bean
public AuthenticationManager authenticationManager(UserDetailsService userDetailsService, PasswordEncoder passwordEncoder) {
    DaoAuthenticationProvider provider = new DaoAuthenticationProvider();
    provider.setUserDetailsService(userDetailsService);
    provider.setPasswordEncoder(passwordEncoder);
    return new ProviderManager(List.of(provider));
}
```

### **2. Custom Authentication Provider (Example: Hardcoded Credentials)**

If we need a **custom authentication logic**, implement `AuthenticationProvider` manually.

```java
@Component
public class CustomAuthenticationProvider implements AuthenticationProvider {

    @Override
    public Authentication authenticate(Authentication authentication) throws AuthenticationException {
        String username = authentication.getName();
        String password = authentication.getCredentials().toString();

        if ("admin".equals(username) && "password".equals(password)) {
            return new UsernamePasswordAuthenticationToken(username, password, List.of(new SimpleGrantedAuthority("ROLE_ADMIN")));
        } else {
            throw new BadCredentialsException("Invalid credentials");
        }
    }

    @Override
    public boolean supports(Class<?> authentication) {
        return UsernamePasswordAuthenticationToken.class.isAssignableFrom(authentication);
    }
}
```

* This provider authenticates **only if the username is "admin" and password is "password"**.
* If credentials are incorrect, it throws `BadCredentialsException`.
* It registers itself as an `AuthenticationProvider` by being annotated with `@Component`.

### **3. Custom Authentication Provider for JWT Authentication**

If using JWT authentication, a custom `AuthenticationProvider` can validate JWT tokens instead of username/password.

```java
@Component
public class JwtAuthenticationProvider implements AuthenticationProvider {

    @Autowired
    private JwtUtil jwtUtil;

    @Override
    public Authentication authenticate(Authentication authentication) throws AuthenticationException {
        String token = (String) authentication.getCredentials();
        String username = jwtUtil.extractUsername(token);

        if (username != null && jwtUtil.validateToken(token)) {
            return new UsernamePasswordAuthenticationToken(username, token, List.of(new SimpleGrantedAuthority("ROLE_USER")));
        } else {
            throw new BadCredentialsException("Invalid JWT token");
        }
    }

    @Override
    public boolean supports(Class<?> authentication) {
        return JwtAuthenticationToken.class.isAssignableFrom(authentication);
    }
}
```

* Extracts the username from the JWT token.
* Validates the token using `JwtUtil`.
* Returns an authenticated `Authentication` object if the token is valid.

## **Spring Boot 2 vs Spring Boot 3 AuthenticationProvider Configuration**

### **Spring Boot 2 Configuration (Extends WebSecurityConfigurerAdapter)**

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {
    
    @Autowired
    private CustomAuthenticationProvider customAuthenticationProvider;
    
    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.authenticationProvider(customAuthenticationProvider);
    }
}
```

* Uses `WebSecurityConfigurerAdapter` (Deprecated in Spring Security 5.7+).
* Configures `AuthenticationProvider` inside `configure()` method.

### **Spring Boot 3 Configuration (Uses Lambda DSL & Beans)**

{% hint style="success" %}
In **Spring Security**, the **DSL (Domain-Specific Language)** is the **fluent API style configuration** used to define security rules in a more readable and declarative way.
{% endhint %}

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    
    @Bean
    public AuthenticationManager authenticationManager(CustomAuthenticationProvider customAuthenticationProvider) {
        return new ProviderManager(List.of(customAuthenticationProvider));
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth.anyRequest().authenticated())
            .formLogin(Customizer.withDefaults());
        return http.build();
    }
}
```

* `WebSecurityConfigurerAdapter` is removed.
* `AuthenticationManager` is explicitly defined using `@Bean`.
* Uses `SecurityFilterChain` for security configurations.

