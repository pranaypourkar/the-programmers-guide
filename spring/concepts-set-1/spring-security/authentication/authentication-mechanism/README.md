# Authentication Mechanism

## About

Authentication is the process of verifying the identity of a user, system, or application. Spring Security provides multiple authentication mechanisms, allowing developers to integrate various authentication methods based on security requirements.

## **Authentication Flow**

Regardless of the mechanism used, authentication follows a general flow:

1. **User Requests Access**
   * The user or client sends a request to the secured resource (e.g., login form, API request).
2. **Authentication Attempt**
   * Credentials (username/password, token, etc.) are submitted to the authentication mechanism.
3. **Verification Process**
   * The authentication mechanism (e.g., `AuthenticationManager`) verifies credentials using `AuthenticationProvider`.
   * If successful, an `Authentication` object is created.
4. **Security Context Update**
   * The verified authentication details are stored in **SecurityContextHolder** for future requests.
5. **Authorization Check**
   * The application verifies if the authenticated user has sufficient **GrantedAuthority** to access the requested resource.
6. **Access Granted or Denied**
   * If the user has the correct permissions, access is granted. Otherwise, access is denied.

## Types of Authentication Mechanisms

Authentication mechanisms can be categorized into the following types:

<table data-header-hidden data-full-width="true"><thead><tr><th width="324"></th><th></th></tr></thead><tbody><tr><td><strong>Category</strong></td><td><strong>Mechanism</strong></td></tr><tr><td><strong>Basic Authentication</strong></td><td>Username/Password (Form Login, Basic Auth, Digest Auth)</td></tr><tr><td><strong>Token-Based Authentication</strong></td><td>JWT (JSON Web Token), OAuth2, API Keys</td></tr><tr><td><strong>Multi-Factor Authentication (MFA)</strong></td><td>OTP (One-Time Password), Authenticator Apps</td></tr><tr><td><strong>Federated Authentication</strong></td><td>SAML, OpenID Connect (OIDC), Social Logins (Google, Facebook, GitHub)</td></tr><tr><td><strong>Biometric Authentication</strong></td><td>Fingerprint, Face Recognition</td></tr><tr><td><strong>Certificate-Based Authentication</strong></td><td>X.509 Certificates</td></tr><tr><td><strong>Session-Based Authentication</strong></td><td>HTTP Session Cookies, Remember-Me</td></tr></tbody></table>

