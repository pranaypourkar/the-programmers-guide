# UserDetails

## About

In Spring Security, `UserDetails` is an interface that represents a **user account** in the system. It contains **user-related data** such as username, password, roles, and account status (enabled, locked, etc.).

Spring Security uses `UserDetails` to **retrieve user information** and **validate credentials** during authentication. It works together with `UserDetailsService` to load user details from a database, an external system, or even in-memory storage.

## **Responsibilities of UserDetails**

* Stores **user identity information** (username, password, roles, account status).
* Used by `UserDetailsService` to retrieve user details during authentication.
* Passed to `AuthenticationProvider` for credential validation.
* Customizable for additional user attributes (e.g., email, phone, permissions).

## **UserDetails Interface (Spring Security Built-in)**

Spring Security provides the `UserDetails` interface:

```java
public interface UserDetails extends Serializable {
    String getUsername();  
    String getPassword();  
    Collection<? extends GrantedAuthority> getAuthorities();  
    boolean isAccountNonExpired();  
    boolean isAccountNonLocked();  
    boolean isCredentialsNonExpired();  
    boolean isEnabled();  
}
```

| **Method**                  | **Purpose**                               |
| --------------------------- | ----------------------------------------- |
| `getUsername()`             | Returns the username of the user.         |
| `getPassword()`             | Returns the encoded password.             |
| `getAuthorities()`          | Returns a list of user roles/permissions. |
| `isAccountNonExpired()`     | Checks if the account is still valid.     |
| `isAccountNonLocked()`      | Checks if the account is not locked.      |
| `isCredentialsNonExpired()` | Checks if the password is not expired.    |
| `isEnabled()`               | Checks if the account is active.          |

### **Default Implementation: User Class**

Spring Security provides a built-in implementation of `UserDetails` through the `User` class.

```java
import org.springframework.security.core.userdetails.User;

UserDetails user = User.builder()
    .username("admin")
    .password("{noop}password") // No encoding used
    .roles("ADMIN") // Adds ROLE_ADMIN
    .build();
```

* Uses Builder Pattern to create users easily.
* Supports password encoding (e.g., `{bcrypt}hashedPassword`).
* Automatically assigns ROLE\_ prefix to roles.

### **Custom Implementation of UserDetails (For Database Authentication)**

In real-world applications, we often **fetch users from a database**. Instead of using Spring’s default `User`, we create our own `UserDetails` implementation.

```java
@Entity
public class CustomUser implements UserDetails {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String username;
    private String password;
    private boolean enabled;

    @ManyToMany(fetch = FetchType.EAGER)
    private List<Role> roles;

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return roles.stream()
                .map(role -> new SimpleGrantedAuthority(role.getName()))
                .collect(Collectors.toList());
    }

    @Override
    public String getPassword() {
        return password;
    }

    @Override
    public String getUsername() {
        return username;
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
        return enabled;
    }
}
```

* Stores user details in a database (`@Entity`).
* Implements `UserDetails` to be compatible with Spring Security.
* Retrieves roles dynamically and converts them to `GrantedAuthority`.



