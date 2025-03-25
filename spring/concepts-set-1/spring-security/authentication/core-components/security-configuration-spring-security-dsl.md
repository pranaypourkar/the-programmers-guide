# Security Configuration (Spring Security DSL)

## About

Spring Security **DSL (Domain-Specific Language)** is the modern way to configure security in Spring Boot **without extending `WebSecurityConfigurerAdapter`**. It was introduced in **Spring Security 5** and became the **default approach in Spring Boot 3**.

This approach uses **lambda-based security configuration** to define authentication, authorization, and other security settings more concisely.

{% hint style="info" %}
Spring Security DSL -&#x20;

* Eliminates `WebSecurityConfigurerAdapter` – No need to override `configure()`.
* More readable and flexible – Uses fluent, declarative API.
* Better compatibility with functional and reactive programming.
* Aligns with Spring Boot's convention-over-configuration philosophy.
{% endhint %}

## **Components of Spring Security Configuration**

Spring Security DSL is built on several core components:

| **Component**              | **Description**                   |
| -------------------------- | --------------------------------- |
| **SecurityFilterChain**    | Defines HTTP security rules.      |
| **HttpSecurity**           | Configures security settings.     |
| **AuthenticationManager**  | Handles authentication logic.     |
| **UserDetailsService**     | Loads user details from DB.       |
| **PasswordEncoder**        | Encrypts and verifies passwords.  |
| **AuthenticationProvider** | Custom authentication logic.      |
| **SecurityContext**        | Holds authenticated user details. |

## **Security Configuration**

### **Before (Spring Boot 2 - Extending `WebSecurityConfigurerAdapter`)**

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {
    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .authorizeRequests()
            .antMatchers("/admin").hasRole("ADMIN")
            .antMatchers("/user").hasRole("USER")
            .anyRequest().authenticated()
            .and()
            .formLogin();
    }
}
```

* Uses the **old `WebSecurityConfigurerAdapter`** class (deprecated in Spring Boot 3).

### **After (Spring Boot 3 - Using Security DSL)**

```java
@Configuration
public class SecurityConfig {
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/admin").hasAuthority("ROLE_ADMIN")
                .requestMatchers("/user").hasAuthority("ROLE_USER")
                .anyRequest().authenticated()
            )
            .formLogin(withDefaults());
        return http.build();
    }
}
```

* Uses **`SecurityFilterChain` with HttpSecurity DSL** instead of extending `WebSecurityConfigurerAdapter`.
* &#x20;`requestMatchers()` replaces `antMatchers()`.

## Examples

### **1. Configuring Authentication (In-Memory Users)**

```java
@Bean
public UserDetailsService userDetailsService() {
    UserDetails admin = User.withUsername("admin")
        .password(passwordEncoder().encode("admin123"))
        .roles("ADMIN") // Automatically adds "ROLE_ADMIN"
        .build();

    UserDetails user = User.withUsername("user")
        .password(passwordEncoder().encode("user123"))
        .roles("USER")
        .build();

    return new InMemoryUserDetailsManager(admin, user);
}

@Bean
public PasswordEncoder passwordEncoder() {
    return new BCryptPasswordEncoder();
}
```

* Defines users **in-memory** (for testing).
* Uses **BCryptPasswordEncoder** for secure password hashing.

### **2. Configuring Authentication (Database UserDetailsService)**

```java
@Service
public class CustomUserDetailsService implements UserDetailsService {
    @Autowired
    private UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));

        List<GrantedAuthority> authorities = user.getRoles().stream()
                .map(role -> new SimpleGrantedAuthority(role.getName()))
                .collect(Collectors.toList());

        return new org.springframework.security.core.userdetails.User(
                user.getUsername(), user.getPassword(), authorities);
    }
}
```

* Retrieves users and roles from **database dynamically**.

### **3. Defining Custom AuthenticationManager**

```java
@Bean
public AuthenticationManager authenticationManager(UserDetailsService userDetailsService, 
                                                   PasswordEncoder passwordEncoder) throws Exception {
    return new ProviderManager(List.of(new DaoAuthenticationProvider() {{
        setUserDetailsService(userDetailsService);
        setPasswordEncoder(passwordEncoder);
    }}));
}
```

* **Custom AuthenticationManager** with `UserDetailsService` and `PasswordEncoder`.

### **4. Role-Based Authorization**

```java
@Bean
public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    http
        .authorizeHttpRequests(auth -> auth
            .requestMatchers("/admin").hasRole("ADMIN")
            .requestMatchers("/user").hasRole("USER")
            .anyRequest().authenticated()
        )
        .formLogin(Customizer.withDefaults());
    return http.build();
}
```

* Restricts **/admin** to `ROLE_ADMIN` and **/user** to `ROLE_USER`.

### **5. Permission-Based Authorization**

```java
@Bean
public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    http
        .authorizeHttpRequests(auth -> auth
            .requestMatchers("/edit").hasAuthority("EDIT_PRIVILEGE")
            .requestMatchers("/delete").hasAuthority("DELETE_PRIVILEGE")
            .anyRequest().authenticated()
        )
        .formLogin(Customizer.withDefaults());
    return http.build();
}
```

* Uses **fine-grained permission-based access control**.

### **6. Enabling JWT-Based Authentication**

```java
@Bean
public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    http
        .csrf(csrf -> csrf.disable()) // Disable CSRF for JWT
        .authorizeHttpRequests(auth -> auth
            .requestMatchers("/admin").hasRole("ADMIN")
            .anyRequest().authenticated()
        )
        .addFilterBefore(jwtFilter(), UsernamePasswordAuthenticationFilter.class);
    return http.build();
}
```

* **Integrates JWT authentication** into Spring Security filter chain.

