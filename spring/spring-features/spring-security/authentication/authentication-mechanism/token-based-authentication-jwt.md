# Token-Based Authentication (JWT)

About

Token-Based Authentication is a **stateless authentication mechanism** where a user is authenticated once and receives a token (typically JWT – JSON Web Token). This token is then sent in subsequent requests, eliminating the need for sessions.

JWT authentication is widely used in **REST APIs, microservices, and Single Page Applications (SPAs)** due to its scalability and security benefits.

## **How Token-Based Authentication Works (JWT Authentication Flow)**

1. **User Logs In**
   * The user provides credentials (username/password) via a login API.
2. **Server Validates Credentials**
   * If credentials are valid, the server generates a JWT token and returns it.
3. **Client Stores Token**
   * The client (browser or mobile app) stores the token (e.g., LocalStorage, SessionStorage, HTTP cookies).
4. **Client Sends Token in Requests**
   * For every subsequent API request, the token is sent in the `Authorization` header.
5. **Server Validates Token**
   * The server verifies the token using a secret key or public-private key pair.
6. **Access Granted or Denied**
   * If the token is valid, the request is processed. Otherwise, an authentication error is returned.

## **JWT Structure**

A JWT token consists of three parts:

```
header.payload.signature
```

Example:

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ1c2VyMSIsImV4cCI6MTcwMDAwMDAwMH0.XYZ123abcDEF
```

### **1. Header**

Contains metadata about the token, including the algorithm used for signing:

```json
{
  "alg": "HS256",
  "typ": "JWT"
}
```

### **2. Payload (Claims)**

Contains user information (claims):

```json
{
  "sub": "user1",
  "exp": 1700000000, 
  "roles": ["USER"]
}
```

* `sub` → Subject (username)
* `exp` → Expiration time
* `roles` → User roles

### **3. Signature**

Used to verify token integrity:

```
HMACSHA256( base64UrlEncode(header) + "." + base64UrlEncode(payload), secret)
```

## **JWT Authentication in Spring Boot**

### **1. Dependencies**

Add the following dependencies in `pom.xml`:

```xml
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt</artifactId>
    <version>0.11.5</version>
</dependency>
```

### **2. Generate JWT Token**

A service to generate JWT tokens:

```java
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import java.util.Date;
import javax.crypto.SecretKey;

public class JwtUtil {

    private static final SecretKey SECRET_KEY = Keys.secretKeyFor(SignatureAlgorithm.HS256);
    private static final long EXPIRATION_TIME = 86400000; // 1 day

    public static String generateToken(String username) {
        return Jwts.builder()
                .setSubject(username)
                .setExpiration(new Date(System.currentTimeMillis() + EXPIRATION_TIME))
                .signWith(SECRET_KEY)
                .compact();
    }

    public static String getUsernameFromToken(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(SECRET_KEY)
                .build()
                .parseClaimsJws(token)
                .getBody()
                .getSubject();
    }
}
```

### **3. Custom JWT Authentication Filter**

Intercepts requests, extracts the token, and sets authentication context:

```java
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;

public class JwtAuthenticationFilter extends UsernamePasswordAuthenticationFilter {

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws ServletException, IOException {

        String token = request.getHeader("Authorization");

        if (token != null && token.startsWith("Bearer ")) {
            token = token.substring(7);

            try {
                Claims claims = Jwts.parserBuilder()
                        .setSigningKey(JwtUtil.SECRET_KEY)
                        .build()
                        .parseClaimsJws(token)
                        .getBody();

                String username = claims.getSubject();
                SecurityContextHolder.getContext().setAuthentication(
                        new UsernamePasswordAuthenticationToken(username, null, List.of())
                );
            } catch (Exception e) {
                SecurityContextHolder.clearContext();
            }
        }

        chain.doFilter(request, response);
    }
}
```

### **4. Configure Spring Security**

**Spring Boot 2 (Spring Security 5)**

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .csrf().disable()
            .authorizeRequests()
                .antMatchers("/api/auth/login").permitAll()
                .anyRequest().authenticated()
            .and()
            .addFilterBefore(new JwtAuthenticationFilter(), UsernamePasswordAuthenticationFilter.class);
    }
}
```

**Spring Boot 3 (Spring Security 6)**

```java
@Configuration
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/auth/login").permitAll()
                .anyRequest().authenticated()
            )
            .addFilterBefore(new JwtAuthenticationFilter(), UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}
```

## **JWT vs. Session-Based Authentication**

<table data-header-hidden data-full-width="true"><thead><tr><th width="147"></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Feature</strong></td><td><strong>JWT Authentication</strong></td><td><strong>Session-Based Authentication</strong></td></tr><tr><td><strong>State</strong></td><td>Stateless</td><td>Stateful (session storage)</td></tr><tr><td><strong>Scalability</strong></td><td>High (suitable for microservices)</td><td>Low (server maintains session)</td></tr><tr><td><strong>Security</strong></td><td>Requires strong encryption</td><td>Sessions can be hijacked</td></tr><tr><td><strong>Storage</strong></td><td>Stored on the client (LocalStorage, HTTP Cookies)</td><td>Stored on the server</td></tr><tr><td><strong>Revocation</strong></td><td>Hard to revoke</td><td>Easy to revoke by destroying the session</td></tr></tbody></table>

### **Why is JWT Called Stateless?**

JWT (JSON Web Token) is considered **stateless** because the server does **not** store any session-related information after issuing the token. Instead, all necessary authentication details (user identity, expiration time, roles, etc.) are **embedded within the token itself** and sent with each request.

Even though a JWT **remains valid for a certain period** (until expiration), the server does not maintain any record of issued tokens. Instead, **validity is checked dynamically** based on the token’s signature and expiration claim (`exp`).

### **How JWT Differs from Stateful Authentication**

<table data-full-width="true"><thead><tr><th>Feature</th><th>JWT (Stateless)</th><th>Session-Based (Stateful)</th></tr></thead><tbody><tr><td><strong>Where is session data stored?</strong></td><td>Inside the token (client-side)</td><td>On the server (session storage)</td></tr><tr><td><strong>Does the server track sessions?</strong></td><td>No, no need to track user sessions</td><td>Yes, maintains session storage</td></tr><tr><td><strong>Scalability</strong></td><td>High (since no session storage is needed)</td><td>Low (server must store &#x26; sync session data)</td></tr><tr><td><strong>Token Revocation</strong></td><td>Harder (token remains valid until expiration)</td><td>Easy (destroy session on logout)</td></tr></tbody></table>

## **When to Use Token-Based Authentication (JWT)?**

JWT authentication is **not always the best choice**. It works well in certain scenarios but has limitations.

### **Use JWT When -**

#### **1. Building RESTful APIs & Microservices**

* JWT allows authentication to work across multiple independent services **without requiring shared session storage**.
* Example: A microservices-based system where multiple services (e.g., `UserService`, `OrderService`, `PaymentService`) need authentication without a central session store.

#### **2. Stateless, Scalable Applications**

* If your app runs across multiple instances (e.g., Kubernetes, cloud environments), JWT helps avoid **session synchronization issues**.

#### **3. Mobile and Single Page Applications (SPAs)**

* Since mobile apps and SPAs (React, Angular, Vue) cannot store session cookies like browsers, JWT provides an efficient **token-based authentication** mechanism.
* Example: A React frontend communicating with a Spring Boot backend over REST.

#### **4. Third-Party Authentication (OAuth2/OpenID Connect)**

* OAuth2 and OpenID Connect use JWT for issuing access tokens (Google, Facebook, GitHub authentication).
* Example: Logging into a web app using "Sign in with Google".

#### **5. Reduced Load on the Server**

* Since JWT stores authentication details **on the client-side**, the server does not need to **validate session data in a database**, improving performance.

### **Avoid JWT When -**

#### **1. When We Need Easy Token Revocation**

* If a JWT is stolen, the attacker can use it until it expires (unless you implement a blacklist).
* **Alternative:** Use session-based authentication (e.g., Spring Security’s default session management).

#### **2. Short-Lived User Sessions**

* If users log in and out frequently, storing session state might be better than issuing and validating JWTs on every request.

#### **3. Large Payloads / Sensitive Data**

* JWT tokens can get large if they contain too many claims, impacting **network performance**.
* **Solution:** Keep tokens small by storing only **essential** information (e.g., user ID, roles).

#### **4. Browser-Based Authentication with CSRF Protection**

* If we need CSRF protection (like in traditional web apps), **session cookies with SameSite settings are more secure** than JWT stored in local storage.
* **Alternative:** Use **HttpOnly Secure Cookies** instead of JWT for authentication.





