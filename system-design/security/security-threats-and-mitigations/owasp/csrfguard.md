# CSRFGuard

## About

OWASP CSRFGuard is an **open-source security library** designed to protect **Java web applications** against **Cross-Site Request Forgery (CSRF) attacks**. It implements **token-based mitigation strategies** to ensure that **state-changing requests** originate from a **trusted user session** rather than a malicious source.

{% hint style="info" %}
Refer to the Official Documentation: [https://owasp.org/www-project-csrfguard/](https://owasp.org/www-project-csrfguard/)
{% endhint %}

## What is OWASP CSRFGuard?

CSRFGuard is a **Java EE filter-based** library that prevents CSRF attacks by embedding **unique anti-CSRF tokens** into HTTP requests. These tokens validate that a request is **legitimate** and not triggered by an attacker.

### How CSRF Attacks Work?

* A user logs into a **secure website** (e.g., a banking portal).
* The user **remains logged in** (session is active).
* A malicious website tricks the user into making an unintended **state-changing request** (e.g., transferring money).
* The **server processes the unauthorized request** because it assumes the request came from the legitimate user.

{% hint style="info" %}
CSRFGuard prevents this by requiring a valid token for each state-changing request.
{% endhint %}

## Why is CSRFGuard Important?

* **Prevents Unauthorized Actions** – Ensures that only **legitimate user actions** are processed.
* **Works with Java EE Web Applications** – Easily integrates with **Spring Boot, Spring MVC, Struts, JSF, and JSP applications**.
* **Supports AJAX Requests** – Provides **JavaScript integration** to secure **asynchronous requests**.
* **Configurable Token Generation** – Supports **session-based and per-request token strategies**.
* **Mitigates Cross-Site Scripting (XSS)-Induced CSRF Attacks** – Ensures tokens are bound to the user session.

## How OWASP CSRFGuard Works ?

CSRFGuard **injects security tokens** into HTML forms and AJAX requests. These tokens are validated **on the server** before processing state-changing operations.

### CSRFGuard Workflow

1. **User logs into the application** → A **CSRF token** is generated and stored in the session.
2. **User submits a form** → CSRFGuard **inserts the CSRF token** into hidden form fields or request headers.
3. **Server validates the token** → If the token is **valid**, the request is processed.
4. **If the token is missing/invalid** → The request is **rejected**, preventing CSRF attacks.

## How to Integrate OWASP CSRFGuard in a Java Spring Boot Application

### **Step 1: Add CSRFGuard to our Project**

**For Maven Users:**

Add the CSRFGuard dependency in `pom.xml`:

```xml
<dependency>
    <groupId>org.owasp</groupId>
    <artifactId>csrfguard</artifactId>
    <version>4.0.0</version>  <!-- Use the latest version -->
</dependency>
```

**For Gradle Users:**

```gradle
implementation 'org.owasp:csrfguard:4.0.0'
```

### **Step 2: Configure CSRFGuard in `csrfguard.properties`**

Create a configuration file `csrfguard.properties` under `src/main/resources/`:

```properties
org.owasp.csrfguard.Enabled=true
org.owasp.csrfguard.TokenPerPage=false
org.owasp.csrfguard.TokenPerRequest=false
org.owasp.csrfguard.SessionKey=OWASP-CSRF-TOKEN
org.owasp.csrfguard.PRNG=SHA1PRNG
org.owasp.csrfguard.Ajax=true
org.owasp.csrfguard.javascript.inject=true
org.owasp.csrfguard.Action.NoToken=logout
```

* **`TokenPerPage`** – If `true`, generates a new token for each page.
* **`TokenPerRequest`** – If `true`, generates a new token per request.
* **`SessionKey`** – The CSRF token's session key name.
* **`Ajax`** – Enables AJAX protection.
* **`javascript.inject`** – Automatically injects CSRF tokens into forms.
* **`Action.NoToken`** – Specifies an action (e.g., logout) when a token is missing.
