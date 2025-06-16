# AuthenticationManager

## About

In Spring Security, the _AuthenticationManager_ is the **core component responsible for processing authentication requests**. It acts as a **central hub** that delegates authentication to one or more `AuthenticationProvider` instances.

Whenever a user attempts to log in (via username/password, JWT, OAuth2, etc.), the `AuthenticationManager` verifies the credentials and returns an `Authentication` object if authentication is successful.

## **Responsibilities of AuthenticationManager**

1. **Processes authentication requests** by delegating to `AuthenticationProvider`.
2. **Returns a valid `Authentication` object** upon success or throws an exception on failure.
3. **Supports multiple authentication mechanisms** like form login, basic authentication, JWT, OAuth2, etc.
4. **Integrates with SecurityContextHolder** to store the authenticated user details.
5. **Allows custom authentication providers** for non-standard authentication methods.

## **Authentication Flow in Spring Security**

### **1. User submits credentials**

A user tries to log in by submitting a request with their credentials.

* Example: A form login request (`POST /login`) with username and password.

### **2. AuthenticationManager is called**

Spring Security passes the credentials to `AuthenticationManager`.

```java
Authentication authentication = authenticationManager.authenticate(
    new UsernamePasswordAuthenticationToken(username, password)
);
```

### **3. Delegates to AuthenticationProvider**

* The `AuthenticationManager` doesn't authenticate directly.
* It delegates the request to one or more `AuthenticationProvider` implementations.

### **4. AuthenticationProvider validates credentials**

* Checks the username and password against the database.
* If valid, it returns an authenticated `Authentication` object.
* If invalid, it throws an `AuthenticationException`.

### **5. Stores Authentication in SecurityContext**

If authentication is successful, the result is stored in the `SecurityContextHolder`:

```java
SecurityContextHolder.getContext().setAuthentication(authentication);
```

### **6. Request is authorized or rejected**

* If authentication is successful, the request proceeds to the controller.
* If authentication fails, Spring Security returns **401 Unauthorized**.

## **Components Related to AuthenticationManager**

#### **1. AuthenticationManager**

* Interface responsible for processing authentication requests.
* Common implementation: `ProviderManager`.

#### **2. AuthenticationProvider**

* Handles specific authentication mechanisms (e.g., username/password, JWT).
* Custom implementations can be created.

#### **3. Authentication Object**

* Holds authentication details (e.g., principal, credentials, authorities).
* Example: `UsernamePasswordAuthenticationToken`.

#### **4. SecurityContextHolder**

* Stores the authentication information for the current request.

#### **5. UserDetailsService**

* Loads user details from the database.
* Default implementation: `InMemoryUserDetailsManager`, `JdbcUserDetailsManager`.

## **AuthenticationManager Implemention**

### **1. Default AuthenticationManager (Spring Boot 3)**

Spring Boot automatically configures an `AuthenticationManager` when using `HttpSecurity`.

{% hint style="danger" %}
In Spring Boot 3, `WebSecurityConfigurerAdapter` is removed. Use `SecurityFilterChain` instead.
{% endhint %}

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth.anyRequest().authenticated())
            .formLogin();
        return http.build();
    }
}
```

{% hint style="info" %}
No need to manually configure AuthenticationManager as Spring Boot does it for us.
{% endhint %}

### **2. Manually Defining AuthenticationManager**

If we need custom authentication logic, define `AuthenticationManager` explicitly.

```java
@Configuration
public class SecurityConfig {
    @Bean
    public AuthenticationManager authenticationManager(UserDetailsService userDetailsService, PasswordEncoder passwordEncoder) {
        DaoAuthenticationProvider provider = new DaoAuthenticationProvider();
        provider.setUserDetailsService(userDetailsService);
        provider.setPasswordEncoder(passwordEncoder);
        return new ProviderManager(List.of(provider));
    }
}
```

* Here, `ProviderManager` delegates authentication to `DaoAuthenticationProvider`.
* Uses `UserDetailsService` to fetch user details.
* Uses `PasswordEncoder` for secure password storage.

### **3. Custom Authentication Provider**

For non-standard authentication (e.g., API keys, LDAP, JWT), create a custom `AuthenticationProvider`.

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

* This provider authenticates only if username is "admin" and password is "password".
* If credentials are incorrect, it throws `BadCredentialsException`.

## **AuthenticationManager in JWT Authentication**

Spring Security's `AuthenticationManager` is crucial in JWT authentication flows.

### **1. JWT Authentication Flow**

* The user logs in and sends username/password.
* The credentials are validated using `AuthenticationManager`.
* If successful, a JWT token is generated and returned.
* On future requests, the token is validated instead of username/password.

### **2. JWT AuthenticationManager Implementation**

```java
@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {
    @Autowired
    private JwtUtil jwtUtil;
    
    @Autowired
    private AuthenticationManager authenticationManager;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, 
                                    FilterChain filterChain) throws ServletException, IOException {
        String token = jwtUtil.extractToken(request);
        if (token != null && jwtUtil.validateToken(token)) {
            Authentication authentication = authenticationManager.authenticate(new JwtAuthenticationToken(token));
            SecurityContextHolder.getContext().setAuthentication(authentication);
        }
        filterChain.doFilter(request, response);
    }
}
```

* Extracts JWT token from the request.
* Uses `AuthenticationManager` to authenticate based on the token.
* Stores authentication in `SecurityContextHolder`.
