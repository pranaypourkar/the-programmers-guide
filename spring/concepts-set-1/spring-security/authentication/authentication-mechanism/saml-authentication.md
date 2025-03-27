# SAML Authentication

## About

Security Assertion Markup Language (**SAML**) is an **XML-based** open standard for **single sign-on (SSO)** authentication. It enables secure authentication across multiple applications without requiring users to enter credentials multiple times.

SAML is widely used in **enterprise environments** for federated identity management and works with **Identity Providers (IdP)** and **Service Providers (SP)** to facilitate authentication.

## **How SAML Authentication Works**

1. **User Requests Access**
   * The user attempts to access a **Service Provider (SP)** (e.g., a SaaS application like Salesforce).
2. **SP Redirects to IdP**
   * The SP **redirects the user** to the **Identity Provider (IdP)** for authentication.
3. **User Authenticates with IdP**
   * The user logs in to the **IdP** (e.g., Active Directory, Okta, Azure AD).
4. **IdP Generates SAML Assertion**
   * The IdP verifies credentials and creates a **SAML assertion** (a signed XML document).
5. **IdP Sends SAML Assertion to SP**
   * The IdP **redirects the user back to the SP**, passing the **SAML assertion**.
6. **SP Validates SAML Assertion**
   * The SP verifies the signature and **grants access** to the user.

**Result:** The user is authenticated without needing to re-enter credentials.

## **Components of SAML**

<table data-header-hidden data-full-width="true"><thead><tr><th width="195"></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Component</strong></td><td><strong>Description</strong></td><td><strong>Examples</strong></td></tr><tr><td><strong>Identity Provider (IdP)</strong></td><td>Authenticates the user and issues <strong>SAML Assertions</strong>.</td><td>Okta, Azure AD, Google Workspace, ADFS</td></tr><tr><td><strong>Service Provider (SP)</strong></td><td>The application that requests authentication from IdP.</td><td>Salesforce, AWS, Office 365</td></tr><tr><td><strong>SAML Assertion</strong></td><td>The XML-based authentication response sent from IdP to SP.</td><td>Contains user details &#x26; authentication status.</td></tr><tr><td><strong>SAML Request</strong></td><td>The authentication request from SP to IdP.</td><td>Initiates SSO authentication.</td></tr><tr><td><strong>SAML Response</strong></td><td>The authentication response from IdP to SP.</td><td>Contains the SAML assertion.</td></tr></tbody></table>

## **Types of SAML SSO Flows**

<table data-header-hidden><thead><tr><th width="163"></th><th></th></tr></thead><tbody><tr><td><strong>Type</strong></td><td><strong>Description</strong></td></tr><tr><td><strong>IdP-Initiated SSO</strong></td><td>The user logs in at the IdP (e.g., Okta) and is <strong>redirected to SP</strong> after authentication.</td></tr><tr><td><strong>SP-Initiated SSO</strong></td><td>The user tries to access an SP (e.g., Salesforce), which then <strong>redirects to the IdP</strong> for authentication.</td></tr></tbody></table>

## **SAML Assertion Structure**

A **SAML Assertion** is an **XML document** that contains user authentication details.

```xml
<saml:Assertion xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion">
    <saml:Issuer>https://idp.example.com</saml:Issuer>
    <saml:Subject>
        <saml:NameID Format="urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress">user@example.com</saml:NameID>
    </saml:Subject>
    <saml:Conditions NotBefore="2025-03-13T00:00:00Z" NotOnOrAfter="2025-03-13T01:00:00Z"/>
    <saml:AuthnStatement AuthnInstant="2025-03-13T00:10:00Z">
        <saml:AuthnContext>
            <saml:AuthnContextClassRef>urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport</saml:AuthnContextClassRef>
        </saml:AuthnContext>
    </saml:AuthnStatement>
</saml:Assertion>
```

* **Issuer:** Identifies the IdP.
* **Subject:** Contains user identity (email, username, etc.).
* **AuthnStatement:** Indicates authentication time and method.
* **Conditions:** Defines validity period.

## **SAML Integration with Spring Security**

### **Spring Boot 2 vs Spring Boot 3 – SAML Authentication**

<table data-header-hidden data-full-width="true"><thead><tr><th width="218"></th><th width="315"></th><th></th></tr></thead><tbody><tr><td><strong>Feature</strong></td><td><strong>Spring Boot 2</strong></td><td><strong>Spring Boot 3</strong></td></tr><tr><td><strong>SAML Support</strong></td><td>Requires Spring Security Extensions</td><td>Native SAML2 support in <code>spring-boot-starter-security</code></td></tr><tr><td><strong>Security Configuration</strong></td><td>Uses <code>WebSecurityConfigurerAdapter</code></td><td>Uses <code>SecurityFilterChain</code> (Lambda DSL)</td></tr><tr><td><strong>Metadata Management</strong></td><td>More manual setup</td><td>Easier configuration via <code>application.yml</code></td></tr></tbody></table>

### **1. Add Dependencies**

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>

<dependency>
    <groupId>org.springframework.security</groupId>
    <artifactId>spring-security-saml2-service-provider</artifactId>
</dependency>
```

### **2. Configure SAML Authentication in Spring Boot**

**Define Security Configuration**

```java
@Configuration
public class SecurityConfig {
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .anyRequest().authenticated()
            )
            .saml2Login(withDefaults()); // Enable SAML authentication

        return http.build();
    }
}
```

### **3. Configure SAML Identity Provider (IdP) Settings**

```yaml
spring:
  security:
    saml2:
      relyingparty:
        registration:
          my-app:
            identityprovider:
              entity-id: "https://idp.example.com"
              verification.credentials:
                - certificate-location: "classpath:idp-certificate.crt"
              single-sign-on-service-location: "https://idp.example.com/sso"
```

### **4. Handle SAML Authentication Response**

```java
@RestController
@RequestMapping("/auth")
public class SAMLController {

    @GetMapping("/user")
    public Authentication getUser(Authentication authentication) {
        return authentication;
    }
}
```

## **When to Use SAML?**

SAML (Security Assertion Markup Language) is best suited for scenarios where **Single Sign-On (SSO)** is required across multiple web applications, especially in **enterprise environments**.

### **Use SAML When -**

1. **Enterprise SSO for Web Applications**
   * If we need a **central authentication system** where users log in once and access multiple web-based applications without logging in again.
   * Example: Logging into **Salesforce, Workday, or Google Workspace** using your organization's credentials.
2. **B2B & Corporate Authentication**
   * If our business requires **federated authentication** between different organizations (e.g., partners, suppliers).
   * Example: A company allowing its employees to access a supplier’s portal using **corporate credentials**.
3. **When Using Legacy Systems**
   * If our organization has older enterprise applications that already **support SAML**, it's easier to continue using it instead of migrating to a newer authentication standard.
4. **Strict Security & Compliance Requirements**
   * SAML is widely used in industries with strict **compliance regulations** like finance, healthcare, and government.
   * Example: **HIPAA-compliant** authentication for a healthcare system.
5. **When we Need a Strong Identity Provider (IdP)**
   * If our organization has an **Identity Provider (IdP)** like **Okta, Microsoft ADFS, or Azure AD**, which manages authentication and **issues SAML assertions** to web applications.

### **Avoid SAML When -**

* **For API Authentication:** SAML is designed for web-based SSO, not securing APIs. Instead, use **OAuth2** for API access.
* **For Mobile & Modern Apps:** SAML uses **XML-based messages**, which are **heavy and complex** for mobile apps. Instead, use **OpenID Connect (OIDC)** for modern authentication.

## **SAML vs OAuth2 vs OpenID Connect**

<table data-header-hidden data-full-width="true"><thead><tr><th width="166"></th><th></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Feature</strong></td><td><strong>SAML (Security Assertion Markup Language)</strong></td><td><strong>OAuth2 (Open Authorization)</strong></td><td><strong>OpenID Connect (OIDC)</strong></td></tr><tr><td><strong>Purpose</strong></td><td>Secure <strong>Single Sign-On (SSO)</strong> for web apps.</td><td>Secure <strong>API access</strong> (authorization).</td><td>Secure <strong>user authentication</strong> for web &#x26; mobile.</td></tr><tr><td><strong>Best Used For</strong></td><td>Enterprise SSO (e.g., logging into Salesforce, Google Workspace).</td><td>Granting third-party apps access to <strong>APIs</strong> (e.g., logging into Spotify with Google).</td><td>Modern authentication for web &#x26; mobile apps (e.g., "Sign in with Google").</td></tr><tr><td><strong>Token Format</strong></td><td>XML-based <strong>SAML Assertion</strong>.</td><td>JSON-based <strong>Access Token</strong>.</td><td>JSON-based <strong>ID Token</strong> (built on OAuth2).</td></tr><tr><td><strong>Authentication?</strong></td><td>Yes – Verifies user identity.</td><td>No – Only grants access to APIs.</td><td>Yes – Verifies user identity &#x26; provides profile info.</td></tr><tr><td><strong>Authorization?</strong></td><td>Yes – Grants access to web apps</td><td>Yes – Grants access to APIs.</td><td>Yes – Grants access to user profile &#x26; APIs.</td></tr><tr><td><strong>Common Providers</strong></td><td>Okta, ADFS, Azure AD, Google Workspace.</td><td>Google, Facebook, GitHub, Microsoft, Twitter.</td><td>Google, Microsoft, Facebook (OIDC built on OAuth2).</td></tr><tr><td><strong>Ideal For</strong></td><td>Large organizations &#x26; corporate SSO.</td><td>APIs, third-party integrations.</td><td>Modern web &#x26; mobile login (replaces SAML for new apps).</td></tr><tr><td><strong>Complexity</strong></td><td>Complex (XML-based, needs IdP &#x26; SP setup).</td><td>Simple for API access, but lacks authentication.</td><td>Simple (JSON-based, supports authentication).</td></tr></tbody></table>
