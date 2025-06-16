# UserDetailsService

## About

`UserDetailsService` is a core interface in Spring Security responsible for **retrieving user details** during authentication. It loads user-specific data from a **database, in-memory store, or external system** and returns a `UserDetails` object, which Spring Security then uses for authentication and authorization.

Spring Security's authentication system heavily depends on `UserDetailsService` to **verify users** and check **roles, passwords, and account status**.

## Responsibilities of UserDetailsService

* Loads user details (username, password, roles) from a persistent store.
* Used by `AuthenticationManager` to authenticate users.
* Returns a `UserDetails` object if the user exists.
* Throws `UsernameNotFoundException` if the user is not found.
* Can be customized to **fetch additional user attributes**.

## **UserDetailsService Interface**

Spring Security provides a interface:

```java
public interface UserDetailsService {
    UserDetails loadUserByUsername(String username) throws UsernameNotFoundException;
}
```

| **Method**                            | **Purpose**                                  |
| ------------------------------------- | -------------------------------------------- |
| `loadUserByUsername(String username)` | Fetches user details based on username.      |
| Throws `UsernameNotFoundException`    | If no user is found with the given username. |

### **Default Implementation: In-Memory UserDetailsService**

Spring Security provides a default `InMemoryUserDetailsManager` that loads users from memory.

```java
@Bean
public UserDetailsService userDetailsService() {
    UserDetails user = User.builder()
        .username("admin")
        .password(new BCryptPasswordEncoder().encode("password"))
        .roles("ADMIN")
        .build();
    
    return new InMemoryUserDetailsManager(user);
}
```

* Stores users in-memory (not recommended for production).
* Uses BCrypt for password encoding.
* `InMemoryUserDetailsManager` manages users in memory.

### **Custom Implementation: Database-backed UserDetailsService**

For real-world applications, we fetch users from a database using JPA, JDBC, or an external API.

#### **1. Create a User Entity**

```java
@Entity
public class CustomUser {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String username;
    private String password;
    private boolean enabled;

    @ManyToMany(fetch = FetchType.EAGER)
    private List<Role> roles;

    // Getters and setters
}
```

#### **2. Create User Repository**

```java
@Repository
public interface UserRepository extends JpaRepository<CustomUser, Long> {
    Optional<CustomUser> findByUsername(String username);
}
```

Queries the database to find users by username.

#### **3. Implement Custom UserDetailsService**

```java
@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        CustomUser user = userRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found: " + username));
        
        return new org.springframework.security.core.userdetails.User(
                user.getUsername(),
                user.getPassword(),
                user.getAuthorities()
        );
    }
}
```

* Retrieves user details from the **database**.
* Throws `UsernameNotFoundException` if the user does not exist.
* Returns a `UserDetails` object that Spring Security can use.

### **How Spring Security Uses UserDetailsService in AuthenticationManager**

Spring Security’s `AuthenticationManager` uses `UserDetailsService` to load user details.

```java
@Bean
public AuthenticationManager authenticationManager(UserDetailsService userDetailsService, PasswordEncoder passwordEncoder) {
    DaoAuthenticationProvider provider = new DaoAuthenticationProvider();
    provider.setUserDetailsService(userDetailsService);
    provider.setPasswordEncoder(passwordEncoder);
    return new ProviderManager(List.of(provider));
}
```

* &#x20;`UserDetailsService` fetches user information.
* &#x20;`DaoAuthenticationProvider` validates the user credentials.
* &#x20;`PasswordEncoder` compares the stored and provided passwords.

## **Configuration for UserDetailsService**

### **Spring Boot 2 (`WebSecurityConfigurerAdapter`)**

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Autowired
    private CustomUserDetailsService userDetailsService;

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(userDetailsService).passwordEncoder(new BCryptPasswordEncoder());
    }
}
```

* Uses `WebSecurityConfigurerAdapter` (Deprecated in Spring Security 5.7+).
* Uses `AuthenticationManagerBuilder` to register `UserDetailsService`.

### **Spring Boot 3 (Bean-based Security Configuration)**

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public UserDetailsService userDetailsService() {
        return new CustomUserDetailsService();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public AuthenticationManager authenticationManager(UserDetailsService userDetailsService, PasswordEncoder passwordEncoder) {
        DaoAuthenticationProvider provider = new DaoAuthenticationProvider();
        provider.setUserDetailsService(userDetailsService);
        provider.setPasswordEncoder(passwordEncoder);
        return new ProviderManager(List.of(provider));
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

* Uses `@Bean` configuration instead of `WebSecurityConfigurerAdapter`.
* Defines `UserDetailsService` explicitly as a Spring Bean.
* Uses `SecurityFilterChain` for security rules.



