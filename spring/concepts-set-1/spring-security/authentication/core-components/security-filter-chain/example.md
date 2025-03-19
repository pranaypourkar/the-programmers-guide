# Example

## Adding a Custom Filter for Request Validation

### **Use Case**

* We need to **validate API requests** for a custom security header before authentication.
* If the request is invalid, reject it **before** it reaches the authentication filter.

### **Implementation**

We create a custom filter that checks for a **mandatory security header**.

**Custom Filter**

```java
@Component
public class CustomRequestValidationFilter extends OncePerRequestFilter {
    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, 
                                    FilterChain filterChain) throws ServletException, IOException {
        String securityHeader = request.getHeader("X-SECURITY-HEADER");

        if (securityHeader == null || !securityHeader.equals("EXPECTED_VALUE")) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Missing or invalid security header");
            return;
        }
        
        filterChain.doFilter(request, response);
    }
}
```

**Register the Filter in Security Configuration**

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .addFilterBefore(new CustomRequestValidationFilter(), UsernamePasswordAuthenticationFilter.class)
            .authorizeHttpRequests(auth -> auth.anyRequest().authenticated())
            .formLogin();
        return http.build();
    }
}
```

**Explanation**

* The **CustomRequestValidationFilter** checks if the request contains a security header.
* If the header is missing or invalid, the request is rejected **before authentication**.
* Otherwise, the request proceeds to the **UsernamePasswordAuthenticationFilter**.

## **Implementing JWT Authentication with a Custom Filter**

### **Use Case**

* You need to authenticate users using **JWT tokens** instead of sessions.
* The filter extracts the token, verifies it, and sets the authentication in the **SecurityContext**.

### **Implementation**

**JWT Utility Class**

```java
@Component
public class JwtUtil {
    private final String SECRET_KEY = "mysecret";

    public String extractUsername(String token) {
        return Jwts.parser().setSigningKey(SECRET_KEY).parseClaimsJws(token).getBody().getSubject();
    }

    public boolean validateToken(String token, UserDetails userDetails) {
        String username = extractUsername(token);
        return username.equals(userDetails.getUsername());
    }
}
```

**JWT Authentication Filter**

```java
@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {
    private final UserDetailsService userDetailsService;
    private final JwtUtil jwtUtil;

    public JwtAuthenticationFilter(UserDetailsService userDetailsService, JwtUtil jwtUtil) {
        this.userDetailsService = userDetailsService;
        this.jwtUtil = jwtUtil;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, 
                                    FilterChain filterChain) throws ServletException, IOException {
        String token = request.getHeader("Authorization");

        if (token != null && token.startsWith("Bearer ")) {
            token = token.substring(7);
            String username = jwtUtil.extractUsername(token);
            if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                UserDetails userDetails = userDetailsService.loadUserByUsername(username);
                if (jwtUtil.validateToken(token, userDetails)) {
                    UsernamePasswordAuthenticationToken authentication = 
                        new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
                    SecurityContextHolder.getContext().setAuthentication(authentication);
                }
            }
        }

        filterChain.doFilter(request, response);
    }
}
```

**Register the JWT Filter in Security Configuration**

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http, JwtAuthenticationFilter jwtAuthenticationFilter) throws Exception {
        http
            .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class)
            .authorizeHttpRequests(auth -> auth.anyRequest().authenticated())
            .sessionManagement(sess -> sess.sessionCreationPolicy(SessionCreationPolicy.STATELESS));
        return http.build();
    }
}
```

**Explanation**

* Extracts JWT from the `Authorization` header.
* Validates the token and extracts the username.
* Loads the user details and sets the authentication.
* Replaces default session-based authentication with token-based authentication.

## **Using Multiple Authentication Mechanisms (JWT + Username/Password + API Keys)**

### **Use Case**

* Some endpoints require **JWT-based authentication**.
* Some endpoints allow **Username/Password login**.
* Some internal API calls use **API keys**.

### **Implementation**

**Custom API Key Filter**

```java
@Component
public class ApiKeyAuthenticationFilter extends OncePerRequestFilter {
    private static final String API_KEY_HEADER = "X-API-KEY";
    private static final String VALID_API_KEY = "mysecureapikey";

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, 
                                    FilterChain filterChain) throws ServletException, IOException {
        String apiKey = request.getHeader(API_KEY_HEADER);

        if (apiKey != null && apiKey.equals(VALID_API_KEY)) {
            UsernamePasswordAuthenticationToken authentication = 
                new UsernamePasswordAuthenticationToken("api-user", null, List.of(new SimpleGrantedAuthority("ROLE_API")));
            SecurityContextHolder.getContext().setAuthentication(authentication);
        }

        filterChain.doFilter(request, response);
    }
}
```

**Register Multiple Authentication Mechanisms**

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http, 
                                                   JwtAuthenticationFilter jwtAuthenticationFilter,
                                                   ApiKeyAuthenticationFilter apiKeyAuthenticationFilter) throws Exception {
        http
            .addFilterBefore(apiKeyAuthenticationFilter, BasicAuthenticationFilter.class)
            .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class)
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/**").hasRole("API")
                .requestMatchers("/admin/**").hasRole("ADMIN")
                .anyRequest().authenticated())
            .formLogin()
            .sessionManagement(sess -> sess.sessionCreationPolicy(SessionCreationPolicy.STATELESS));
        return http.build();
    }
}
```

**Explanation**

* The API Key filter runs **before basic authentication** to check if an API key is present.
* If an API key is valid, a user with the **ROLE\_API** is authenticated.
* The JWT authentication filter runs **before username/password authentication** to check for a valid JWT.
* The authentication order is:
  1. API Key Authentication
  2. JWT Authentication
  3. Username/Password Authentication

## **Handling Access Control Based on Request Attributes**

### **Use Case**

* We want to **restrict access** based on a custom request parameter.
* Users can access different resources based on a custom **header value**.

### **Implementation**

**Custom Access Filter**

```java
@Component
public class CustomAccessFilter extends OncePerRequestFilter {
    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, 
                                    FilterChain filterChain) throws ServletException, IOException {
        String clientType = request.getHeader("X-Client-Type");

        if ("INTERNAL".equals(clientType)) {
            UsernamePasswordAuthenticationToken authentication = 
                new UsernamePasswordAuthenticationToken("internal-user", null, List.of(new SimpleGrantedAuthority("ROLE_INTERNAL")));
            SecurityContextHolder.getContext().setAuthentication(authentication);
        } else {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        filterChain.doFilter(request, response);
    }
}
```

**Register in Security Configuration**

```java
http.addFilterBefore(new CustomAccessFilter(), FilterSecurityInterceptor.class);
```

**Explanation**

* This filter ensures that only requests with **"X-Client-Type: INTERNAL"** are processed.
* If the header is missing or incorrect, the request is blocked.

## **Enforcing Custom IP Whitelisting Using a Security Filter**

### Use Case

Only requests from **whitelisted IP addresses** are allowed to access sensitive endpoints like `/admin/**`.

### **Implementation**

```java
@Component
public class IpWhitelistFilter extends OncePerRequestFilter {

    private static final List<String> WHITELISTED_IPS = List.of("192.168.1.100", "10.0.0.5");

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) 
            throws ServletException, IOException {
        String clientIp = request.getRemoteAddr();

        if (request.getRequestURI().startsWith("/admin") && !WHITELISTED_IPS.contains(clientIp)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied from IP: " + clientIp);
            return;
        }

        filterChain.doFilter(request, response);
    }
}
```

**Register Filter Before Authorization**

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .addFilterBefore(new IpWhitelistFilter(), UsernamePasswordAuthenticationFilter.class)
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/admin/**").hasRole("ADMIN")
                .anyRequest().authenticated())
            .formLogin();

        return http.build();
    }
}
```

**Execution Flow**

1. IP Whitelist Filter runs first → If IP is not in the whitelist, request is blocked.
2. If IP is allowed, authentication proceeds.
3. Role-based access control is enforced for admin routes.

## **Implementing CSRF Protection Only for Certain Requests**

### Use Case

The app disables CSRF globally but enables it only for specific endpoints like POST requests to `/secure/**`.

### **Implementation**

**Custom CSRF Filter**

```java
@Component
public class ConditionalCsrfFilter extends OncePerRequestFilter {

    private final CsrfTokenRepository csrfTokenRepository = new HttpSessionCsrfTokenRepository();

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) 
            throws ServletException, IOException {
        if ("POST".equalsIgnoreCase(request.getMethod()) && request.getRequestURI().startsWith("/secure/")) {
            CsrfToken csrfToken = csrfTokenRepository.loadToken(request);

            if (csrfToken == null || !csrfToken.getToken().equals(request.getHeader("X-CSRF-TOKEN"))) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid CSRF Token");
                return;
            }
        }

        filterChain.doFilter(request, response);
    }
}
```

**Register the Filter**

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())  // Disable CSRF globally
            .addFilterAfter(new ConditionalCsrfFilter(), CsrfFilter.class) // Add custom CSRF check
            .authorizeHttpRequests(auth -> auth
                .anyRequest().authenticated())
            .formLogin();

        return http.build();
    }
}
```

**Execution Flow**

1. CSRF is disabled globally but enforced for specific requests (`/secure/**`).
2. If the request is a `POST` to `/secure/**`, the filter checks for a valid CSRF token.
3. If the token is missing or incorrect, the request is blocked (403 Forbidden).

## **Custom Filter for Logging and Rate Limiting**

### Use Case

Create a custom filter that logs requests and implements rate limiting before authentication occurs. Place before `UsernamePasswordAuthenticationFilter`.

### **Implementation**

```java
@Component
public class RequestLoggingAndRateLimitingFilter extends OncePerRequestFilter {

    private final Map<String, Integer> requestCounts = new ConcurrentHashMap<>();
    private static final int MAX_REQUESTS_PER_MINUTE = 5;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, 
                                    FilterChain filterChain) throws ServletException, IOException {
        String clientIp = request.getRemoteAddr();
        
        // Log request details
        System.out.println("Incoming request from IP: " + clientIp + " - Path: " + request.getRequestURI());

        // Rate limiting logic
        requestCounts.put(clientIp, requestCounts.getOrDefault(clientIp, 0) + 1);
        if (requestCounts.get(clientIp) > MAX_REQUESTS_PER_MINUTE) {
            System.out.println("Rate limit exceeded for IP: " + clientIp);
            response.sendError(HttpServletResponse.SC_TOO_MANY_REQUESTS, "Too many requests");
            return;
        }

        // Continue filter chain
        filterChain.doFilter(request, response);
    }
}
```

**Registering the Custom Filter**

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .addFilterBefore(new RequestLoggingAndRateLimitingFilter(), UsernamePasswordAuthenticationFilter.class)
            .authorizeHttpRequests(auth -> auth.anyRequest().authenticated())
            .formLogin()
            .and()
            .logout();
        return http.build();
    }
}
```

**Explanation**

1. Logs every incoming request along with the **client IP** and **requested path**.
2. Implements **rate limiting** to **prevent abuse**.
3. Rejects requests with `429 Too Many Requests` if the IP exceeds the allowed limit.
4. Continues with the filter chain if the request is within the limit.

## **Rate Limiting with Time Based Expiry**

### Use Case

Create a custom filter that implements rate limiting before authentication occurs. Each IP entry automatically expires after 24 hours.

### Solution 1: ConcurrentHashMap with Expiry

```java
@Component
public class RequestLoggingAndRateLimitingFilter extends OncePerRequestFilter {

    private final Map<String, RequestInfo> requestCounts = new ConcurrentHashMap<>();
    private static final int MAX_REQUESTS_PER_DAY = 1000;
    private static final long EXPIRY_TIME_MS = 24 * 60 * 60 * 1000; // 24 hours

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, 
                                    FilterChain filterChain) throws ServletException, IOException {
        String clientIp = request.getRemoteAddr();
        long currentTime = System.currentTimeMillis();

        requestCounts.compute(clientIp, (ip, requestInfo) -> {
            if (requestInfo == null || currentTime - requestInfo.timestamp > EXPIRY_TIME_MS) {
                return new RequestInfo(1, currentTime); // Reset if 24h has passed
            }
            return new RequestInfo(requestInfo.count + 1, requestInfo.timestamp);
        });

        if (requestCounts.get(clientIp).count > MAX_REQUESTS_PER_DAY) {
            response.sendError(HttpServletResponse.SC_TOO_MANY_REQUESTS, "Too many requests in a day");
            return;
        }

        filterChain.doFilter(request, response);
    }

    private static class RequestInfo {
        int count;
        long timestamp;

        public RequestInfo(int count, long timestamp) {
            this.count = count;
            this.timestamp = timestamp;
        }
    }
}
```

**Explanation**

1. Each IP is tracked in a `RequestInfo` object that stores:
   * The **count of requests**.
   * The **timestamp of the first request**.
2. If an IP **exceeds the limit** in 24 hours, it gets blocked.
3. Once **24 hours** pass since the **first request**, the count **automatically resets**.
4. This method ensures that different IPs **reset independently** rather than at a fixed global interval.

### **Solution 2: Using Caffeine Cache (Auto-Expiry)**

Use Caffeine Cache with an automatic expiration policy to reset the count per IP after 24 hours.

**Add Dependency**

```xml
<dependency>
    <groupId>com.github.ben-manes.caffeine</groupId>
    <artifactId>caffeine</artifactId>
    <version>3.1.6</version>
</dependency>
```

```java
@Component
public class RequestLoggingAndRateLimitingFilter extends OncePerRequestFilter {

    private final Cache<String, Integer> requestCounts;

    public RequestLoggingAndRateLimitingFilter() {
        this.requestCounts = Caffeine.newBuilder()
                .expireAfterWrite(24, TimeUnit.HOURS) // Reset per IP after 24 hours
                .build();
    }

    private static final int MAX_REQUESTS_PER_DAY = 1000;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, 
                                    FilterChain filterChain) throws ServletException, IOException {
        String clientIp = request.getRemoteAddr();
        
        int currentCount = requestCounts.get(clientIp, k -> 0);
        requestCounts.put(clientIp, currentCount + 1);

        if (currentCount + 1 > MAX_REQUESTS_PER_DAY) {
            response.sendError(HttpServletResponse.SC_TOO_MANY_REQUESTS, "Too many requests in a day");
            return;
        }

        filterChain.doFilter(request, response);
    }
}
```

**Explanation**

1. Uses Caffeine Cache to store IP request counts.
2. Each IP's request count automatically expires after 24 hours.
3. No need for a scheduled task; expiration is handled internally.
4. More memory-efficient than `ConcurrentHashMap`.
