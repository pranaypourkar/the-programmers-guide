# CSRF

## About

Cross-Site Request Forgery (CSRF) is a web security vulnerability that tricks an authenticated user into performing unintended actions on a web application without their consent. It exploits the trust a web application has in the user’s browser session.

{% hint style="info" %}
If a user is logged into a website, their browser automatically includes authentication tokens (cookies, session IDs, etc.) in requests made to that site. CSRF attacks leverage this by tricking users into making unintended requests, such as changing passwords, transferring money, or modifying settings.
{% endhint %}

{% hint style="success" %}
CSRF and XSRF refer to the same security attack.

* **CSRF (Cross-Site Request Forgery)** → Commonly used term.
* **XSRF (Cross-Site Request Forgery)** → Some security experts and frameworks use this alternative name.

Why Two Names?

* **"Cross-Site" → "X-Site"** abbreviation resulted in **XSRF**.
* Some web frameworks, such as **Angular**, use **XSRF-TOKEN** as a CSRF protection mechanism.
{% endhint %}

## How CSRF Works? (Attack Flow)

A typical CSRF attack follows these steps:

1. **User Authentication**
   * A user logs into a web application (e.g., banking website).
   * The application issues an authentication session (usually via cookies). The browser stores authentication details (like session cookies, JWT, or OAuth tokens)
2. **User Visits a Malicious Site**
   * The user unknowingly visits an attacker-controlled site or clicks a malicious link.
   * The attacker’s site contains an HTML form or script that sends a request to the victim's application using the authenticated session.
3. **Execution of Unauthorized Action**
   * The victim's browser automatically includes authentication session in the request.
   * The web application processes the request, assuming it was made by the legitimate user.

Example of a malicious form triggering a CSRF attack:

```html
<form action="https://bank.com/transfer" method="POST">
    <input type="hidden" name="account" value="attacker_account">
    <input type="hidden" name="amount" value="5000">
    <input type="submit">
</form>
```

If the victim is logged in, this request could transfer money without their knowledge.

### **CSRF vs XSS (Cross-Site Scripting)**

<table data-full-width="true"><thead><tr><th width="269">Feature</th><th width="293">CSRF</th><th>XSS</th></tr></thead><tbody><tr><td><strong>Target</strong></td><td>Exploits authenticated users</td><td>Exploits the application itself</td></tr><tr><td><strong>Attack Method</strong></td><td>Forces user actions without consent</td><td>Injects malicious scripts into web pages</td></tr><tr><td><strong>Requires User Authentication?</strong></td><td>Yes</td><td>No</td></tr><tr><td><strong>Mitigation</strong></td><td>CSRF tokens, SameSite cookies</td><td>Input validation, Content Security Policy (CSP)</td></tr></tbody></table>

## Do Browsers Automatically Cascade Session-Related Data?

Yes, browsers automatically include certain session-related data with requests based on security policies and authentication mechanisms. However, not all session-related data is automatically cascaded.

### **What Session-Related Data Does the Browser Automatically Include?**

<table data-header-hidden data-full-width="true"><thead><tr><th></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Type of Authentication</strong></td><td><strong>Automatically Sent by Browser?</strong></td><td><strong>Reason</strong></td></tr><tr><td><strong>Session Cookies</strong></td><td>Yes</td><td>Cookies are automatically attached to requests based on domain and path rules.</td></tr><tr><td><strong>Basic Authentication (Authorization Header: <code>Basic username:password</code>)</strong></td><td>Yes (if cached)</td><td>Some browsers remember credentials and resend them.</td></tr><tr><td><strong>Bearer Tokens (JWT in Authorization Header)</strong></td><td>No</td><td>Browsers do NOT automatically attach JWT tokens.</td></tr><tr><td><strong>API Keys in Headers</strong></td><td>No</td><td>API Keys must be explicitly added by the client.</td></tr></tbody></table>

### **When Does a Browser Automatically Include Session Data?**

1.  **Cookies (Session-Based Authentication)**

    * Browsers automatically send cookies with every request to the same domain and matching path.
    * Example: If a user logs into `example.com`, the session cookie is **automatically sent** with every subsequent request to `example.com/api/*`.

    **Example: Cookie Auto-Sent by Browser**

    ```http
    GET /dashboard
    Host: example.com
    Cookie: JSESSIONID=abc123xyz
    ```

    * The browser **automatically includes `JSESSIONID`**, making it vulnerable to CSRF if not protected.
2. **Basic Authentication (If Cached by the Browser)**
   * If a site uses **Basic Authentication**, some browsers cache the credentials and **resend them** automatically.
   *   Example:

       ```http
       Authorization: Basic dXNlcjpwYXNzd29yZA==
       ```
   * However, this behavior depends on browser settings and may not always happen.

### **Does the Browser Automatically Include JWT Tokens?**

No, browsers do NOT automatically attach JWT tokens to requests.

1. JWTs are stored manually (in `localStorage`, `sessionStorage`, or cookies).
2. Unlike cookies, JWTs are not automatically sent unless explicitly added to the `Authorization` header.
3. JWT-based authentication requires the client (JavaScript) to attach the token manually in API requests.

**Example: Client Manually Sends JWT in Headers**

```javascript
fetch('https://api.example.com/protected', {
    method: 'GET',
    headers: {
        'Authorization': 'Bearer YOUR_JWT_TOKEN'
    }
});
```

{% hint style="success" %}
Since JWTs are explicitly added, CSRF protection is NOT required.
{% endhint %}

### **What If a JWT Is Stored in Cookies?**

If we store the JWT in a cookie with the `HttpOnly` and `Secure` flags, the browser will send it automatically like a session cookie.

**Example: Storing JWT in a Cookie**

```http
Set-Cookie: access_token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...; HttpOnly; Secure; SameSite=Strict
```

{% hint style="success" %}
If the JWT is stored in a cookie, CSRF protection is needed because the browser will automatically send it with requests/
{% endhint %}

## **CSRF Attack Scenarios**

### 1. GET Request-Based CSRF

Many older web applications performed sensitive operations (like fund transfers, account modifications, etc.) using **GET requests** instead of `POST`, `PUT`, or `DELETE`. Since GET requests are automatically executed by browsers when an image, iframe, or script is loaded, attackers can craft a **malicious URL** that triggers an action when the victim visits a compromised page.

#### **Example Scenario: Online Banking Fund Transfer**

Let’s say an online banking system has an endpoint that allows users to transfer money using a simple GET request:

```
https://bank.com/transfer?to=attacker&amount=5000
```

If a user is **logged into their banking account**, this request **automatically transfers** $5000 to the attacker's account when executed.

#### **Attack Execution**

1.  **Attacker Crafts a Malicious URL**

    ```html
    <img src="https://bank.com/transfer?to=attacker&amount=5000">
    ```
2. **User Visits a Malicious Website**
   * The page automatically loads the `<img>` tag, sending a request to the bank.
   * The request includes the user’s authentication cookies (because it’s an image request to a trusted domain).
3. **Bank Processes the Request**
   * Since the bank’s server sees a legitimate GET request from an authenticated user, it **executes the fund transfer**.

#### **Mitigation Strategies**

* **Use POST requests** for any sensitive actions. GET requests should only retrieve data, never modify it.
* **Implement CSRF tokens**, ensuring that every action requires a unique, server-generated token.
* **SameSite Cookie Policy**, which prevents cookies from being sent with cross-site requests.

### 2. POST Request-Based CSRF (Form Submission)

* Many web applications process sensitive operations using **POST requests**, but they **do not validate the source** of these requests.
* Attackers can **embed hidden forms** on malicious sites that auto-submit upon page load, tricking users into performing unintended actions.

#### **Example Scenario: Changing Email Address**

Assume a website allows users to change their email address via the following form:

```html
htmlCopyEdit<form action="https://example.com/change-email" method="POST">
    <input type="hidden" name="email" value="attacker@example.com">
    <input type="submit" value="Change Email">
</form>
```

An attacker can create a similar form on their malicious site and auto-submit it when the victim visits.

#### **Attack Execution**

1.  **Attacker Embeds a Hidden Form on a Malicious Website**

    ```html
    <form action="https://example.com/change-email" method="POST">
        <input type="hidden" name="email" value="attacker@example.com">
        <script>document.forms[0].submit();</script>
    </form>
    ```
2. **User Visits the Malicious Page**
   * The script executes immediately, submitting the form **without user interaction**.
3. **Server Accepts the Request**
   * Since the user is authenticated, their cookies are automatically sent with the request.
   * The email gets changed without their knowledge.

#### **Mitigation Strategies**

* **CSRF Tokens**: Every form submission must include a unique, server-generated token.
* **SameSite Cookies**: Prevent browsers from sending cookies in cross-site requests.
* **Referrer Header Validation**: Check that the request originated from the same domain.

### 3. CSRF via AJAX Requests

Modern applications often use **AJAX requests** to communicate with the server dynamically. If CORS (Cross-Origin Resource Sharing) is **misconfigured**, an attacker can craft a **malicious JavaScript script**that triggers API requests from an external site using the victim’s session.

#### **Example Scenario: Unauthorized Money Transfer via Fetch API**

A bank provides an API for transferring funds via AJAX:

```javascript
fetch("https://bank.com/transfer", {
    method: "POST",
    credentials: "include",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ to: "attacker", amount: 5000 })
});
```

If the user is authenticated, the browser **automatically includes session cookies** in the request, making it valid.

#### **Attack Execution**

1.  **Attacker Hosts Malicious JavaScript**

    ```javascript
    fetch("https://bank.com/transfer", {
        method: "POST",
        credentials: "include",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ to: "attacker", amount: 5000 })
    });
    ```
2. **User Visits a Malicious Page**
   * The script executes automatically in the background.
   * The browser sends a request to `bank.com` with the user’s cookies.
3. **The Bank’s Server Processes the Request**
   * Since the request looks legitimate, the transaction is completed.

#### **Mitigation Strategies**

* **CSRF Tokens**: Require a unique token for all AJAX requests.
* **CORS Configuration**: Restrict APIs to trusted domains.
* **SameSite Cookies**: Prevent cookies from being sent with cross-origin requests.
* **Origin Header Validation**: Ensure that requests originate from the same domain.

## Mitigation Techniques in Spring Security

Cross-Site Request Forgery (CSRF) is a critical web security vulnerability that allows attackers to trick users into performing unintended actions on authenticated websites. To mitigate CSRF attacks effectively, web applications should implement a combination of the following security measures.

### **1. CSRF Tokens (Synchronizer Token Pattern)**

A **CSRF token** is a randomly generated unique token that the server generates and associates with a user session. Every sensitive request (e.g., form submission, API call) must include this token. The server validates the token before processing the request.

#### **How CSRF Tokens Work?**

1. **Server generates a CSRF token** for each user session.
2. The token is **embedded in all forms and AJAX requests**.
3. On submission, the **server validates the CSRF token** before processing the request.
4. If the token is **missing or invalid**, the request is rejected.

#### **Implementation Steps**

1.  Default CSRF Configuration (No Need to Manually Enable)

    Spring Security enables CSRF protection by default. Any state-changing HTTP requests (POST, PUT, DELETE) require a valid CSRF token.



    ```java
    @Configuration
    @EnableWebSecurity
    public class SecurityConfig {

        @Bean
        public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
            http
                .authorizeHttpRequests(auth -> auth
                    .requestMatchers("/public/**").permitAll()
                    .anyRequest().authenticated()
                )
                .csrf(Customizer.withDefaults()) // CSRF protection enabled (default)
                .formLogin(Customizer.withDefaults()) // Enables login
                .logout(Customizer.withDefaults()); // Enables logout

            return http.build();
        }
    }
    ```
2. **Generate a CSRF Token**
   * When a user logs in or starts a session, the server generates a unique CSRF token and stores it in the session.
   *   Example in Java (Spring Security):

       ```java
       @GetMapping("/form")
       public String getForm(Model model, HttpSession session) {
           String csrfToken = UUID.randomUUID().toString();
           session.setAttribute("csrfToken", csrfToken);
           model.addAttribute("csrfToken", csrfToken);
           return "form";
       }
       ```
3. **Embed the CSRF Token in Requests**
   *   In HTML forms:

       ```html
       <form action="/transfer" method="POST">
           <input type="hidden" name="csrfToken" value="${csrfToken}">
           <button type="submit">Transfer</button>
       </form>
       ```
   *   In AJAX requests:

       ```javascript
       fetch('/transfer', {
           method: 'POST',
           headers: { 'Content-Type': 'application/json', 'X-CSRF-TOKEN': csrfToken },
           body: JSON.stringify({ to: 'attacker', amount: 5000 })
       });
       ```
4. **Verify CSRF Token on the Server**
   * When a request is received, the server checks whether the provided token matches the token stored in the session.
   *   Example in Java (Spring Security):

       ```java
       @PostMapping("/transfer")
       public ResponseEntity<String> transfer(@RequestParam String csrfToken, HttpSession session) {
           String sessionToken = (String) session.getAttribute("csrfToken");
           if (sessionToken == null || !sessionToken.equals(csrfToken)) {
               return ResponseEntity.status(HttpStatus.FORBIDDEN).body("CSRF Token Mismatch");
           }
           // Process transaction
           return ResponseEntity.ok("Transfer successful");
       }
       ```

### **2. SameSite Cookie Attribute**

The **SameSite** attribute in HTTP cookies prevents cookies from being sent with cross-site requests, blocking unauthorized CSRF attempts.

#### **Implementation**

When setting cookies, configure the **SameSite** attribute as `Strict` or `Lax`:

```http
Set-Cookie: sessionId=abc123; HttpOnly; Secure; SameSite=Strict
```

<table data-header-hidden data-full-width="true"><thead><tr><th width="147"></th><th width="228"></th><th></th></tr></thead><tbody><tr><td><strong>SameSite Value</strong></td><td><strong>Behavior</strong></td><td><strong>Example Scenario</strong></td></tr><tr><td><code>Strict</code></td><td>Cookies are sent only for requests from the same site.Cross-site requests won't send cookies.</td><td>You are logged into <code>bank.com</code>. If an attacker tricks you into clicking a malicious link from <code>hacker.com</code>, your session cookie won't be sent to <code>bank.com</code>, preventing CSRF.</td></tr><tr><td><code>Lax</code></td><td>Cookies are sent for same-site and top-level GET requests.</td><td>You click a link to <code>bank.com</code> from <code>news.com</code>. Since it's a top-levelnavigation, cookies are sent. However, cookies are not sent for embedded resources (like images, scripts, or AJAX requests) from other sites.</td></tr><tr><td><code>None</code></td><td>Cookies are sent with all requests, even from different websites, but must be marked as Secure.</td><td>If a web app needs cross-site requests (e.g., APIs used by multiple domains), it must use <code>None</code> and Secure to prevent security risks.</td></tr></tbody></table>

#### **Example in Spring Boot**

```java
@Bean
public CookieSerializer cookieSerializer() {
    DefaultCookieSerializer serializer = new DefaultCookieSerializer();
    serializer.setSameSite("Strict");
    return serializer;
}
```

{% hint style="info" %}
* Simple to implement with no extra tokens.
* Works well with browsers supporting the SameSite attribute.
* May break legitimate third-party integrations.
* Not supported by all legacy browsers.
{% endhint %}

### **3. CORS (Cross-Origin Resource Sharing) Restriction**

CORS defines which domains are allowed to make requests to a web server. Properly configuring CORS prevents CSRF attacks via AJAX requests.

#### **Implementation**

1.  **Restrict Allowed Origins**

    * Only allow requests from trusted origins.

    ```java
    @Configuration
    public class CorsConfig {
        @Bean
        public WebMvcConfigurer corsConfigurer() {
            return new WebMvcConfigurer() {
                @Override
                public void addCorsMappings(CorsRegistry registry) {
                    registry.addMapping("/api/**")
                        .allowedOrigins("https://trustedsite.com")
                        .allowedMethods("GET", "POST");
                }
            };
        }
    }
    ```
2.  **Validate Origin and Referer Headers**

    * Ensure that requests originate from an authorized domain.

    ```java
    @PostMapping("/transfer")
    public ResponseEntity<String> secureTransfer(@RequestHeader("Origin") String origin) {
        if (!origin.equals("https://trustedsite.com")) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Invalid Origin");
        }
        return ResponseEntity.ok("Transfer Successful");
    }
    ```

{% hint style="info" %}
* Effective against unauthorized AJAX-based CSRF attacks.
* Works well for API-based applications.
* Not effective for traditional form-based CSRF attacks.
* Requires proper configuration to avoid breaking legitimate requests.
{% endhint %}

### **4. Double Submit Cookie Pattern**

* The server sets a **CSRF token as a cookie**.
* The frontend **reads this cookie** and includes it in every request as a header.
* The server validates that both values match.

#### **Implementation**

1.  **Set CSRF Token as a Cookie**

    ```java
    @GetMapping("/csrf-token")
    public ResponseEntity<Void> setCsrfToken(HttpServletResponse response) {
        String csrfToken = UUID.randomUUID().toString();
        Cookie csrfCookie = new Cookie("XSRF-TOKEN", csrfToken);
        csrfCookie.setHttpOnly(false);
        csrfCookie.setPath("/");
        response.addCookie(csrfCookie);
        return ResponseEntity.ok().build();
    }
    ```
2.  **Frontend Reads and Includes CSRF Token in Requests**

    ```javascript
    const csrfToken = document.cookie.split('; ')
        .find(row => row.startsWith('XSRF-TOKEN='))
        ?.split('=')[1];

    fetch('/transfer', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', 'X-CSRF-TOKEN': csrfToken },
        body: JSON.stringify({ to: 'attacker', amount: 5000 })
    });
    ```
3.  **Verify Token on the Server**

    ```java
    @PostMapping("/transfer")
    public ResponseEntity<String> validateCsrf(@RequestHeader("X-CSRF-TOKEN") String csrfToken, @CookieValue("XSRF-TOKEN") String csrfCookie) {
        if (!csrfToken.equals(csrfCookie)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("CSRF Token Mismatch");
        }
        return ResponseEntity.ok("Transfer Successful");
    }
    ```

{% hint style="info" %}
* Works well for single-page applications (SPAs).
* Does not require session storage.
* Less secure than synchronizer tokens (an attacker can read cookies in some cases).
{% endhint %}

### **5. User Authentication-Based Mitigation**

* Require **multi-factor authentication (MFA)** for sensitive actions.
* Force **re-authentication** before critical actions like fund transfers.

#### **Example: MFA Prompt**

```java
@PostMapping("/transfer")
public ResponseEntity<String> secureTransfer(@RequestHeader("Authorization") String token) {
    if (!mfaService.isVerified(token)) {
        return ResponseEntity.status(HttpStatus.FORBIDDEN).body("MFA Required");
    }
    return ResponseEntity.ok("Transfer Successful");
}
```

{% hint style="info" %}
* Highly secure for sensitive operations.
* Provides an extra layer beyond CSRF protection.
* Requires user interaction, which can reduce usability.
{% endhint %}





