# PasswordEncoder

## About

`PasswordEncoder` is a core interface in Spring Security that **handles password hashing and verification** to enhance security. It ensures that passwords are never stored as plaintext and helps **validate credentials securely** by comparing hashed passwords.

Spring Security provides multiple implementations of `PasswordEncoder`, with **BCrypt** being the most commonly used due to its strong hashing algorithm and built-in salting mechanism.

## **Why is Password Encoding Important?**

* **Prevents storing plaintext passwords** in databases.
* **Enhances security** by hashing passwords before storing them.
* **Uses one-way encryption**, making it difficult to reverse-engineer passwords.
* **Protects against brute-force attacks** with slow hashing mechanisms.
* **Ensures forward compatibility** by allowing seamless upgrades to stronger hashing algorithms.

## **PasswordEncoder Interface**

Spring Security provides the following interface for password encoding:

```java
public interface PasswordEncoder {
    String encode(CharSequence rawPassword);
    boolean matches(CharSequence rawPassword, String encodedPassword);
}
```

<table data-header-hidden data-full-width="true"><thead><tr><th></th><th></th></tr></thead><tbody><tr><td><strong>Method</strong></td><td><strong>Purpose</strong></td></tr><tr><td><code>encode(CharSequence rawPassword)</code></td><td>Hashes the raw password.</td></tr><tr><td><code>matches(CharSequence rawPassword, String encodedPassword)</code></td><td>Verifies the password against a stored hash.</td></tr></tbody></table>

## **Available Implementations of PasswordEncoder**

Spring Security provides several implementations of `PasswordEncoder`, each designed for different security needs.

<table data-header-hidden data-full-width="true"><thead><tr><th width="268"></th><th width="205"></th><th></th></tr></thead><tbody><tr><td><strong>Encoder</strong></td><td><strong>Strength</strong></td><td><strong>Usage</strong></td></tr><tr><td><code>NoOpPasswordEncoder</code></td><td>Not Secure</td><td>Stores plaintext passwords (Deprecated).</td></tr><tr><td><code>BCryptPasswordEncoder</code></td><td>Recommended</td><td>Uses <strong>bcrypt</strong> hashing with salting.</td></tr><tr><td><code>PBKDF2PasswordEncoder</code></td><td>High</td><td>Uses PBKDF2 key derivation function.</td></tr><tr><td><code>SCryptPasswordEncoder</code></td><td>High</td><td>Uses SCrypt hashing, suitable for memory-hard operations.</td></tr><tr><td><code>Argon2PasswordEncoder</code></td><td>High</td><td>Uses Argon2 hashing, winner of the Password Hashing Competition.</td></tr><tr><td><code>DelegatingPasswordEncoder</code></td><td>🔄 Flexible</td><td>Supports multiple encoding types for seamless migration.</td></tr></tbody></table>

### **1. BCryptPasswordEncoder (Most Commonly Used)**

`BCryptPasswordEncoder` is the most widely used password encoder because it automatically generates a **random salt**, making it resistant to **rainbow table attacks**.

```java
@Bean
public PasswordEncoder passwordEncoder() {
    return new BCryptPasswordEncoder();
}
```

* Uses **bcrypt hashing** algorithm.
* Generates **a different hash even for the same password**.
* Suitable for **high-security applications**.

#### **Example Usage**

```java
PasswordEncoder encoder = new BCryptPasswordEncoder();
String rawPassword = "securePassword";
String hashedPassword = encoder.encode(rawPassword);

System.out.println("Encoded password: " + hashedPassword);

boolean matches = encoder.matches("securePassword", hashedPassword);
System.out.println("Password Match: " + matches);
```

* **Hashes the password before storing**.
* **Compares hashed values** to verify authentication.

### **2. PBKDF2PasswordEncoder**

PBKDF2 (Password-Based Key Derivation Function 2) is a **key-stretching algorithm** that uses multiple iterations to slow down brute-force attacks.

```java
@Bean
public PasswordEncoder passwordEncoder() {
    return new Pbkdf2PasswordEncoder();
}
```

* **Provides strong hashing** with configurable iteration count.
* More resistant to **GPU-based brute-force attacks** than bcrypt.

### **3. SCryptPasswordEncoder**

SCrypt is a **memory-hard** password hashing algorithm, making it highly secure.

```java
@Bean
public PasswordEncoder passwordEncoder() {
    return new SCryptPasswordEncoder();
}
```

* Uses **high memory usage** to slow down attackers.
* Ideal for **modern authentication systems**.

### **4. Argon2PasswordEncoder** (Most Secure)

Argon2 is the **winner of the Password Hashing Competition (PHC)** and is considered one of the best hashing algorithms.

```java
@Bean
public PasswordEncoder passwordEncoder() {
    return new Argon2PasswordEncoder();
}
```

* **Highly secure** and resistant to brute-force attacks.
* **Memory-intensive**, making it difficult to attack using GPUs.

### **5. NoOpPasswordEncoder (Deprecated & Insecure)**

`NoOpPasswordEncoder` **does not hash passwords** and stores them in plaintext. **Never use it in production!**

```java
@Bean
public PasswordEncoder passwordEncoder() {
    return NoOpPasswordEncoder.getInstance();
}
```

* Only useful for testing purposes.
* Insecure – passwords remain in plaintext.

### **6. DelegatingPasswordEncoder (Handles Migrations)**

When migrating from **one hashing algorithm to another**, `DelegatingPasswordEncoder` allows backward compatibility.

```java
@Bean
public PasswordEncoder passwordEncoder() {
    return PasswordEncoderFactories.createDelegatingPasswordEncoder();
}
```

* **Supports multiple encoding mechanisms**.
* Automatically **migrates passwords** from old hashing formats.

#### **Example Hash Storage Format**

Passwords encoded with `DelegatingPasswordEncoder` are stored like this:

```
{bcrypt}$2a$10$hG1KbAp82KgVsNfM/Wpm6ePEpLv.Kz/PZEV6QuUz6rUVIuT4OAiWi
```

* &#x20;`{bcrypt}` specifies which algorithm was used.
* This helps with **seamless migration** to new hashing algorithms.

## **Password Encoding Configuration**

### **Spring Boot 2 (`WebSecurityConfigurerAdapter`)**

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Autowired
    private UserDetailsService userDetailsService;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(userDetailsService).passwordEncoder(passwordEncoder());
    }
}
```

* Uses `WebSecurityConfigurerAdapter` (Deprecated in Spring Security 5.7+).
* Defines `PasswordEncoder` as a bean.

### **Spring Boot 3 (Bean-based Security Configuration)**

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

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
}
```

* Uses explicit bean-based security configuration.
* Defines `PasswordEncoder` as a Spring Bean.







