# GrantedAuthority

## About

In **Spring Security**, a `GrantedAuthority` represents a **permission or role** granted to an authenticated user. It is used in **authorization** to determine if a user has access to a specific resource or action.

Spring Security does not differentiate between **roles and permissions**—they are both represented as `GrantedAuthority`. However, by convention, **roles** are prefixed with `"ROLE_"` (e.g., `"ROLE_ADMIN"`).

## **Why is GrantedAuthority Important?**

* **Defines user access levels** – Controls what actions a user can perform.
* **Supports fine-grained permissions** – Not limited to roles; can be specific permissions.
* **Works with Authentication objects** – Used in `UserDetails` and `Authentication`.
* **Facilitates role-based access control (RBAC)** – Commonly used for securing resources

## **GrantedAuthority Interface**

Spring Security provides the `GrantedAuthority` interface:

```java
public interface GrantedAuthority {
    String getAuthority();
}
```

### **Implementation Example**

Spring Security provides a built-in implementation:

```java
public class SimpleGrantedAuthority implements GrantedAuthority {
    private final String role;

    public SimpleGrantedAuthority(String role) {
        this.role = role;
    }

    @Override
    public String getAuthority() {
        return role;
    }
}
```

## **Where is GrantedAuthority Used?**

### **1. In UserDetails Implementation**

A `UserDetails` object contains a collection of `GrantedAuthority` representing the user's roles or permissions.

```java
public class CustomUserDetails implements UserDetails {
    private String username;
    private String password;
    private List<GrantedAuthority> authorities;

    public CustomUserDetails(String username, String password, List<GrantedAuthority> authorities) {
        this.username = username;
        this.password = password;
        this.authorities = authorities;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return authorities;
    }

    @Override
    public String getUsername() {
        return username;
    }

    @Override
    public String getPassword() {
        return password;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }
}
```

* The `getAuthorities()` method returns **roles or permissions** for the user.

### **2. In Authentication Object**

After authentication, Spring Security assigns `GrantedAuthority` to the `Authentication` object.

```java
Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();

for (GrantedAuthority authority : authorities) {
    System.out.println("User has authority: " + authority.getAuthority());
}
```

* Retrieves the **current user's roles or permissions**.

### **3. In Security Expressions (`@PreAuthorize`)**

Spring Security uses `GrantedAuthority` to control access at the method level.

```java
@PreAuthorize("hasAuthority('ROLE_ADMIN')")
public void adminOnlyMethod() {
    System.out.println("Only ADMIN can access this.");
}
```

* Ensures only users with `"ROLE_ADMIN"` can invoke this method.

## **Role-Based vs Permission-Based Security**

<table data-header-hidden data-full-width="true"><thead><tr><th width="251"></th><th width="296"></th><th></th></tr></thead><tbody><tr><td><strong>Approach</strong></td><td><strong>Example</strong></td><td><strong>Use Case</strong></td></tr><tr><td><strong>Role-Based Security</strong></td><td><code>hasRole('ADMIN')</code></td><td>Grants access based on <strong>user roles</strong>.</td></tr><tr><td><strong>Permission-Based Security</strong></td><td><code>hasAuthority('READ_PRIVILEGE')</code></td><td>Grants access based on <strong>fine-grained permissions</strong>.</td></tr></tbody></table>

#### **Using hasRole vs hasAuthority**

* `hasRole('ADMIN')` → Automatically adds `"ROLE_"` prefix (expects `"ROLE_ADMIN"`).
* `hasAuthority('ROLE_ADMIN')` → Requires exact match, including `"ROLE_"`.

## **Using GrantedAuthority in Security Configuration**

### **1. Hardcoded Roles in Memory (InMemoryUserDetailsManager)**

```java
@Bean
public UserDetailsService userDetailsService() {
    UserDetails admin = User.withUsername("admin")
        .password("{noop}password")
        .roles("ADMIN") // Automatically adds "ROLE_ADMIN"
        .build();

    UserDetails user = User.withUsername("user")
        .password("{noop}password")
        .roles("USER") // Automatically adds "ROLE_USER"
        .build();

    return new InMemoryUserDetailsManager(admin, user);
}
```

* Spring **automatically converts** `"ADMIN"` to `"ROLE_ADMIN"`.

### **2. Fetching Roles from a Database**

When using a database, roles are fetched dynamically.

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

* Converts **database roles into GrantedAuthority** dynamically.

## **Changes in GrantedAuthority Handling wrt Spring Boot version**

<table data-header-hidden data-full-width="true"><thead><tr><th width="207"></th><th width="356"></th><th></th></tr></thead><tbody><tr><td><strong>Feature</strong></td><td><strong>Spring Boot 2</strong></td><td><strong>Spring Boot 3</strong></td></tr><tr><td>Security Config</td><td>Uses <code>WebSecurityConfigurerAdapter</code></td><td>Uses <strong>Lambda-based</strong> SecurityFilterChain</td></tr><tr><td>Role Prefix Handling</td><td><code>roles("ADMIN")</code> adds <code>"ROLE_"</code> automatically</td><td>No change</td></tr><tr><td>Method-Level Security</td><td><code>@PreAuthorize("hasRole('ADMIN')")</code></td><td><code>@PreAuthorize("hasAuthority('ROLE_ADMIN')")</code></td></tr><tr><td>AuthenticationManager</td><td><code>configure(AuthenticationManagerBuilder auth)</code></td><td><code>@Bean AuthenticationManager</code></td></tr></tbody></table>

### **Spring Boot 2 Security Configuration Example**

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.authorizeRequests()
            .antMatchers("/admin").hasAuthority("ROLE_ADMIN")
            .antMatchers("/user").hasAuthority("ROLE_USER")
            .anyRequest().authenticated()
            .and()
            .formLogin()
            .and()
            .logout();
    }

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.inMemoryAuthentication()
            .withUser("admin").password("{noop}admin123").authorities("ROLE_ADMIN")
            .and()
            .withUser("user").password("{noop}user123").authorities("ROLE_USER");
    }

    @Bean
    @Override
    public AuthenticationManager authenticationManagerBean() throws Exception {
        return super.authenticationManagerBean();
    }
}
```

### **Spring Boot 3 Security Configuration Example**

```java
@Bean
public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    http.authorizeHttpRequests(auth -> auth
            .requestMatchers("/admin").hasAuthority("ROLE_ADMIN")
            .requestMatchers("/user").hasAuthority("ROLE_USER")
            .anyRequest().authenticated())
        .formLogin(Customizer.withDefaults());
    return http.build();
}
```

* Uses lambda-based security configuration instead of `WebSecurityConfigurerAdapter`.
