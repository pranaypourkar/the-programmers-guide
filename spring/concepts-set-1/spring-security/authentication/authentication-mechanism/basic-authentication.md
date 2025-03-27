# Basic Authentication

## About

Basic Authentication is a simple authentication mechanism where the client (browser or API consumer) sends a username and password with each request. It is widely used for securing APIs and web applications but is often combined with HTTPS for security. Spring Security provides built-in support for **Basic Authentication**, making it easy to integrate into applications.

## **How Basic Authentication Works**

1. **Client Requests a Resource**
   * The client attempts to access a secured endpoint.
2. **Server Responds with 401 (Unauthorized)**
   * The server responds with `HTTP 401 Unauthorized` and the `WWW-Authenticate` header requesting credentials.
3. **Client Sends Credentials**
   *   The client resends the request, including the `Authorization` header with credentials encoded in Base64:

       ```http
       Authorization: Basic dXNlcm5hbWU6cGFzc3dvcmQ=
       ```

       * Here, `dXNlcm5hbWU6cGFzc3dvcmQ=` is the Base64-encoded version of `username:password`.
4. **Server Decodes and Verifies Credentials**
   * The server decodes the Base64 string and verifies the username/password.
5. **Access Granted or Denied**
   * If authentication succeeds, the request is processed.
   * If authentication fails, the server responds with `HTTP 401 Unauthorized`.

## **Basic Authentication in Spring Security**

Spring Security makes it easy to enable Basic Authentication using its DSL-based configuration.

### **1. Enabling Basic Authentication in Spring Boot 2**

In **Spring Boot 2**, we can configure Basic Authentication like this:

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
            .httpBasic();  // Enables Basic Authentication
    }
}
```

* This configuration ensures that all incoming requests must be authenticated using Basic Authentication.

### **2. Enabling Basic Authentication in Spring Boot 3**

Spring Boot 3 and Spring Security 6 use the new **Lambda-based Security DSL** instead of `WebSecurityConfigurerAdapter`:

```java
@Configuration
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .anyRequest().authenticated()
            )
            .httpBasic(withDefaults()); // Enables Basic Authentication

        return http.build();
    }
}
```

* **Key Differences**:
  * `WebSecurityConfigurerAdapter` is deprecated.
  * Uses `SecurityFilterChain` and `HttpSecurity` DSL.
  * More modular and flexible approach.

## **Customizing Basic Authentication in Spring Security**

#### **1. Changing the Default Username & Password Storage**

By default, Spring Boot provides an auto-generated password when `UserDetailsService` is not defined. To customize this, define a `UserDetailsService` bean:

{% hint style="success" %}
**Does Spring Boot Add a Default Username and Password If Not Configured?**

Yes, **Spring Boot automatically generates a default username and password** if no user configuration is provided.

* **Default Username**: `user`
*   **Default Password**: A random password, printed in the console at application startup:

    ```
    Using generated security password: 3b3c5a7e-9b1e-4f5a-8f07-dfb9c99f5e0b
    ```
*   This password **changes on every restart** unless explicitly set in `application.properties`:

    ```properties
    spring.security.user.name=admin
    spring.security.user.password=admin123
    ```
* This behavior is provided by `DefaultPasswordEncoderAuthenticationProvider` and is primarily meant for **development/testing purposes**.
{% endhint %}

```java
@Bean
public UserDetailsService userDetailsService() {
    UserDetails user = User.withUsername("admin")
            .password(passwordEncoder().encode("password"))
            .roles("USER")
            .build();

    return new InMemoryUserDetailsManager(user);
}
```

* This stores credentials in-memory.
* Uses **BCrypt** password encoding.

#### **2. Custom Authentication Provider**

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

* This provider directly validates credentials instead of relying on `UserDetailsService`.

## **When to Use Basic Authentication?**

### **Use Cases for Basic Authentication**:

* **Internal APIs**: When APIs are used within a controlled network (e.g., between microservices).
* **Quick Authentication Setup**: When we need a **simple** and **fast authentication** mechanism without setting up OAuth2 or JWT.
* **Testing and Development**: When securing a development environment or prototyping an authentication system.
* **CI/CD Pipelines & Automation**: Many **build tools, API clients, and automation scripts** use Basic Authentication to authenticate with services.

### **When NOT to Use Basic Authentication**:

* **Public-Facing APIs**: Since credentials are sent with every request, it is **insecure for public APIs** unless combined with HTTPS and additional security layers.
* **Scalable Authentication Needs**: If our application needs **session management, OAuth2, or token-based authentication**, Basic Authentication is not ideal.
* **Single Sign-On (SSO) and Federated Authentication**: For enterprise applications requiring SSO, **OAuth2, OpenID Connect, or SAML** are preferred.

