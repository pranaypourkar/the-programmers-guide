# Remember-Me Authentication

## About

Remember-Me Authentication is a feature in Spring Security that allows users to stay logged in even after their session expires or they close the browser. When enabled, Spring Security generates a persistent authentication token, which is stored on the client-side (usually as a cookie) and verified on subsequent visits.

It improves **user experience** by avoiding frequent logins while ensuring authentication security.

## **How Does Remember-Me Authentication Work?**

### **Step 1: User Logs In and Opts for Remember-Me**

* The user provides **valid credentials** (username & password).
* If they check the **"Remember Me"** option, a persistent token is generated.

### **Step 2: Server Stores a Persistent Token**

* The server generates and stores an authentication token.
* This token is saved in either:
  * **Cookies (Default Method)** – A token-based cookie is stored on the client’s browser.
  * **Database (Persistent Token Approach)** – A record is stored in the database.

### **Step 3: User Returns and Gets Automatically Logged In**

* When the user revisits the site, the **token is sent back** to the server via the cookie.
* Spring Security verifies the token:
  * **If valid** → User is automatically authenticated.
  * **If invalid or expired** → User is asked to log in again.

## **Types of Remember-Me Authentication in Spring Security**

Spring Security provides **two main approaches** for Remember-Me Authentication:

### **1. Token-Based (Hashing Method) – Default Approach**

* Uses a hash of **username, password, expiration time, and a key**.
* The generated token is stored as a cookie.
* The server does not maintain any database record.
* **Less secure** because token verification relies on a static hash.

### **2. Persistent Token-Based (Database Approach) – Recommended for Security**

* Stores a **randomly generated token** in a database along with the username.
* The server can **revoke or expire tokens manually**.
* **More secure** as tokens can be invalidated.

## **Remember-Me Cookie Structure**

Spring Security stores the Remember-Me token in the client’s browser as a **cookie**. The default format is:

```
remember-me=USERNAME:EXPIRATION_TIME:HASHED_TOKEN
```

Example:

```
remember-me=admin:1699999999:74b87337454200d4d33f80c4663dc5e5
```

Where:

* **admin** → Username
* **1699999999** → Expiration timestamp
* **74b873...** → Hashed token

## **Implementing Remember-Me Authentication in Spring Security**

### **Method 1: Token-Based Remember-Me (Default)**

**Step 1: Enable Remember-Me in Spring Security**

```java
javaCopyEdit@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .anyRequest().authenticated()
            )
            .formLogin(withDefaults())
            .rememberMe(rm -> rm
                .key("my-secret-key")  // Secret key to generate tokens
                .tokenValiditySeconds(604800)  // Token valid for 7 days
            );
        return http.build();
    }
}
```

* `.key("my-secret-key")` → Ensures security by hashing the remember-me token.
* `.tokenValiditySeconds(604800)` → Sets expiration time (7 days).

### **Method 2: Persistent Token-Based Remember-Me (Recommended for Security)**

**Step 1: Create Database Table to Store Tokens**

```sql
sqlCopyEditCREATE TABLE persistent_logins (
    username VARCHAR(64) NOT NULL,
    series VARCHAR(64) PRIMARY KEY,
    token VARCHAR(64) NOT NULL,
    last_used TIMESTAMP NOT NULL
);
```

**Step 2: Configure Persistent Remember-Me in Spring Security**

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Autowired
    private DataSource dataSource;  // Inject database connection

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .anyRequest().authenticated()
            )
            .formLogin(withDefaults())
            .rememberMe(rm -> rm
                .key("my-secure-key")
                .tokenRepository(persistentTokenRepository()) // Use database storage
                .tokenValiditySeconds(1209600) // 14 days
            );
        return http.build();
    }

    @Bean
    public PersistentTokenRepository persistentTokenRepository() {
        JdbcTokenRepositoryImpl repository = new JdbcTokenRepositoryImpl();
        repository.setDataSource(dataSource);
        return repository;
    }
}
```

* Uses a **database-backed** token repository.
* The token is stored in `persistent_logins` table.
* **More secure** as tokens can be revoked manually.

## **Security Risks & How to Mitigate Them**

<table data-header-hidden data-full-width="true"><thead><tr><th width="366"></th><th></th></tr></thead><tbody><tr><td><strong>Security Risk</strong></td><td><strong>Mitigation Strategy</strong></td></tr><tr><td><strong>Token Theft (Man-in-the-Middle Attacks)</strong></td><td>Use <strong>HTTPS</strong> to encrypt token transmission.</td></tr><tr><td><strong>Cookie Theft (Cross-Site Scripting - XSS)</strong></td><td>Set <code>HttpOnly</code> and <code>Secure</code> flags on cookies.</td></tr><tr><td><strong>Token Reuse (Replay Attacks)</strong></td><td>Use database-backed <strong>persistent tokens</strong> instead of static hashes.</td></tr><tr><td><strong>Stolen Device Login</strong></td><td>Provide a way to <strong>revoke active Remember-Me sessions</strong>.</td></tr></tbody></table>

#### **Setting Secure Cookie Attributes**

```java
rememberMe(rm -> rm
    .key("my-secure-key")
    .useSecureCookie(true)  // Ensures cookies are sent over HTTPS
    .rememberMeCookieName("custom-remember-me") // Custom cookie name
);
```

## **When to Use Remember-Me Authentication?**

<table data-header-hidden data-full-width="true"><thead><tr><th width="307"></th><th></th></tr></thead><tbody><tr><td><strong>Scenario</strong></td><td><strong>Why Use Remember-Me?</strong></td></tr><tr><td><strong>Web Applications with Frequent Logins</strong></td><td>Enhances user experience by reducing login prompts.</td></tr><tr><td><strong>Low-Risk Applications</strong></td><td>Suitable for apps where authentication security is less critical.</td></tr><tr><td><strong>Customer-Facing Services</strong></td><td>Keeps users logged in for extended sessions.</td></tr></tbody></table>

## **When NOT to Use Remember-Me Authentication?**

<table data-header-hidden data-full-width="true"><thead><tr><th width="381"></th><th></th></tr></thead><tbody><tr><td><strong>Scenario</strong></td><td><strong>Alternative Approach</strong></td></tr><tr><td><strong>Highly Secure Systems (e.g., Banking, Finance, Healthcare)</strong></td><td>Use Multi-Factor Authentication (MFA) instead.</td></tr><tr><td><strong>Shared Devices or Public Computers</strong></td><td>Disable Remember-Me to prevent unauthorized access.</td></tr><tr><td><strong>REST APIs &#x26; Mobile Applications</strong></td><td>Use JWT or OAuth2 for token-based authentication.</td></tr></tbody></table>

