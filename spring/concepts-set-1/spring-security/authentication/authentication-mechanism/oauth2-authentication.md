# OAuth2 Authentication

## About

OAuth2 (Open Authorization 2.0) is an **industry-standard authorization protocol** that allows **secure access to resources without sharing credentials**. It is widely used in modern applications for **third-party authentication and authorization**, such as Google, Facebook, and GitHub login.

OAuth2 is primarily an **authorization framework**, but it can be extended to handle authentication using **OpenID Connect (OIDC)**.

## **How OAuth2 Authentication Works (Simplified Flow)**

1. **User Requests Access**
   * The user attempts to log in to an application using OAuth2 (e.g., "Login with Google").
2. **Redirect to Authorization Server**
   * The application redirects the user to the **OAuth2 provider (Authorization Server)** (e.g., Google, Facebook).
3. **User Grants Permission**
   * The user logs in and grants permission for the application to access their data (e.g., email, profile).
4. **Authorization Server Issues Code**
   * If permission is granted, the OAuth2 provider **returns an authorization code** to the application.
5. **Application Requests Access Token**
   * The application exchanges the authorization code for an **access token** from the OAuth2 provider.
6. **Application Uses Token**
   * The application includes the **access token** in API requests to access user data.

## **OAuth2 Roles**

OAuth2 defines four key roles:

<table data-header-hidden><thead><tr><th width="188"></th><th></th></tr></thead><tbody><tr><td><strong>Role</strong></td><td><strong>Description</strong></td></tr><tr><td><strong>Resource Owner</strong></td><td>The user who grants access to their data.</td></tr><tr><td><strong>Client</strong></td><td>The application requesting access on behalf of the user.</td></tr><tr><td><strong>Authorization Server</strong></td><td>Issues access tokens after user consent.</td></tr><tr><td><strong>Resource Server</strong></td><td>The API that holds the user’s protected resources.</td></tr></tbody></table>

### OAuth2 Client & OAuth2 Resource Owner

#### **1. OAuth2 Client**

* **Acts as the application that requires authentication and authorization from an OAuth2 provider.**
* The client **does not store or validate tokens**, but instead relies on an **OAuth2 Authorization Server** (like Keycloak, Google, or GitHub) to handle authentication.
* The user logs in through the **OAuth2 provider**, and the client application **obtains an access token** to act on behalf of the user.
* Commonly used for **SSO (Single Sign-On)** or integrating with external authentication providers.

**Example Use Case**:

* A web application that allows users to log in with **Google OAuth** (instead of its own authentication system).
* When a user clicks "Login with Google," the OAuth2 Client redirects the user to Google's authentication page.
* Once authenticated, Google redirects back with an **authorization code**, which the client exchanges for an **access token**.
* The web app then uses this token to access user data from Google's API.

#### **2. OAuth2 Resource Server**

* **Acts as the backend API that protects its resources and validates incoming access tokens.**
* It does **not authenticate users directly**, but instead **verifies the access token** issued by an OAuth2 Authorization Server.
* Used when a client application (frontend, mobile, or another service) sends a request with an OAuth2 **access token**to access a protected API.

**Example Use Case**:

* We have a REST API that only allows authenticated users to fetch data.
* A frontend (React/Angular) calls the API and sends an **OAuth2 access token**.
* The **resource server (API)** validates the token and processes the request if valid.

## **OAuth2 Grant Types (Authorization Flows)**

OAuth2 provides different grant types (authorization flows) to handle different use cases. These grant types define how a client application can obtain an **access token** to access a protected resource (e.g., an API).

### **1. Authorization Code Flow** (Recommended for Web Apps & SPAs)

**Best for:** Web applications (backend and frontend) & Single Page Applications (SPAs).

#### **How it Works:**

1. The user tries to log in through a third-party provider (e.g., Keycloak, Google, GitHub, or other identity providers).
2. The provider **redirects** the user to a login page.
3. After successful login, the provider sends back an **authorization code** to the application.
4. The application exchanges the **authorization code** for an **access token** (by making a server-to-server request).
5. The application can now use the **access token** to access the user’s data.

#### **Why Use This?**

* **More secure** since the token is not exposed to the frontend.
* Uses **server-to-server communication**, reducing the risk of token theft.

### **2. Client Credentials Flow** (Used for Machine-to-Machine Authentication)

**Best for:** Services or APIs communicating without user involvement.

#### **How it Works:**

1. The client application (e.g., a backend service) directly sends a request to the **authorization server** with its **client ID and client secret**.
2. The authorization server verifies the credentials and returns an **access token**.
3. The client uses the **access token** to access the protected resource (e.g., an API).

#### **Why Use This?**

* No user is involved; only **trusted backend services** use this flow.
* Used for **microservices** or **backend-to-backend** communication.

### **3. Implicit Flow** (Deprecated, Previously Used for SPAs)

**Best for:** Older SPAs (NOT recommended due to security risks).

#### **How it Works:**

1. The user logs in through a third-party provider.
2. The provider **directly returns an access token** to the frontend application (without an authorization code).
3. The frontend application uses this token to access resources.

#### **Why It’s Deprecated?**

* **Tokens are exposed in the browser URL**, making them vulnerable to attacks.
* Authorization Code Flow with **PKCE** is now recommended instead.

### **4. Password Grant Flow** (Deprecated, Previously Used for Direct Login)

**Best for:** Legacy applications (NOT recommended).

#### **How it Works:**

1. The user enters their **username and password** directly into the client application.
2. The client application sends these credentials to the **authorization server**.
3. The authorization server verifies them and returns an **access token**.

#### **Why It’s Deprecated?**

* Requires users to **trust third-party applications** with their credentials.
* **Security risk** if credentials are stored or exposed.

### **5. Device Authorization Flow** (Used for Devices Without Keyboards)

**Best for:** Smart TVs, gaming consoles, IoT devices.

#### **How it Works:**

1. The device displays a **code** and asks the user to visit a URL on another device (e.g., a smartphone).
2. The user logs in on their smartphone and **approves access**.
3. The device then receives an **access token** and can authenticate.

#### **Why Use This?**

* Allows login on **devices with no keyboard or browser**.
* Secure since login happens on a **trusted device**.



## **OAuth2 Tokens**

### **Access Token**

* A short-lived token used to access resources (e.g., APIs).
*   Included in the `Authorization` header:

    ```
    Authorization: Bearer <access_token>
    ```
* Typically **expires in minutes or hours**.

### **Refresh Token**

* A long-lived token that allows obtaining a **new access token** without user interaction.
* Used when an **access token expires**.

## **OAuth2 with Spring Security**

### **1. Dependencies**

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-oauth2-client</artifactId>
</dependency>
```

### **2. Configure OAuth2 Login (Google as Provider)**

**application.yml:**

```yaml
spring:
  security:
    oauth2:
      client:
        registration:
          google:
            client-id: your-client-id
            client-secret: your-client-secret
            scope: profile, email
```

### **3. Enable OAuth2 Login in Security Configuration**

**Spring Boot 2 (Spring Security 5)**

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .csrf().disable()
            .authorizeRequests()
                .antMatchers("/").permitAll()
                .anyRequest().authenticated()
            .and()
            .oauth2Login();  // Enable OAuth2 Login
    }
}
```

**Spring Boot 3 (Spring Security 6)**

```java
@Configuration
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/").permitAll()
                .anyRequest().authenticated()
            )
            .oauth2Login(Customizer.withDefaults());  // Enable OAuth2 Login

        return http.build();
    }
}
```

## **OAuth2 with Resource Server (Protecting APIs)**

#### **1. Dependencies**

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-oauth2-resource-server</artifactId>
</dependency>
```

#### **2. Configure Resource Server**

```yaml
spring:
  security:
    oauth2:
      resourceserver:
        jwt:
          issuer-uri: https://accounts.google.com
```

#### **3. Secure API Endpoints with OAuth2 Token**

```java
@Configuration
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/public").permitAll()
                .requestMatchers("/api/**").authenticated()
            )
            .oauth2ResourceServer(oauth2 -> oauth2.jwt());

        return http.build();
    }
}
```





