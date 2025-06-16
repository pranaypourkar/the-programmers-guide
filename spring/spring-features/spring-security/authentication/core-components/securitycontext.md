# SecurityContext

## About

`SecurityContext` is a **core component** in Spring Security responsible for **storing authentication details** of the currently authenticated user. It holds the `Authentication` object, which contains user credentials, authorities (roles), and additional security-related information.

In a typical Spring Security flow, `SecurityContext` is populated once a user is authenticated and remains accessible throughout the request lifecycle.

## Why is SecurityContext Important?

* **Stores user authentication details** securely.
* **Provides access to authenticated user information** in any part of the application.
* **Ensures thread-local storage**, allowing seamless access to authentication data within the same thread.
* **Plays a key role in method-level security**, allowing role-based authorization.

## **SecurityContext Interface**

The `SecurityContext` interface is defined as follows:

```java
public interface SecurityContext extends Serializable {
    Authentication getAuthentication();
    void setAuthentication(Authentication authentication);
}
```

<table data-header-hidden data-full-width="true"><thead><tr><th></th><th></th></tr></thead><tbody><tr><td><strong>Method</strong></td><td><strong>Purpose</strong></td></tr><tr><td><code>getAuthentication()</code></td><td>Retrieves the current <code>Authentication</code> object.</td></tr><tr><td><code>setAuthentication(Authentication authentication)</code></td><td>Updates the authentication details in the context.</td></tr></tbody></table>

## **Default Implementation**

Spring Security provides the `SecurityContextImpl` class as the default implementation of `SecurityContext`.

```java
public class SecurityContextImpl implements SecurityContext {
    private Authentication authentication;

    public SecurityContextImpl() {}

    public SecurityContextImpl(Authentication authentication) {
        this.authentication = authentication;
    }

    @Override
    public Authentication getAuthentication() {
        return authentication;
    }

    @Override
    public void setAuthentication(Authentication authentication) {
        this.authentication = authentication;
    }

    @Override
    public String toString() {
        return this.authentication == null ? "Empty SecurityContext" : "Authentication=" + this.authentication;
    }
}
```

## **How to Access SecurityContext in Spring Applications**

Spring provides `SecurityContextHolder` to retrieve authentication details.

```java
@GetMapping("/user-info")
public ResponseEntity<String> getUserInfo() {
    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    String username = authentication.getName();
    return ResponseEntity.ok("Authenticated User: " + username);
}
```

* Retrieves the **currently logged-in user's username**.
* `authentication.getAuthorities()` can be used to fetch **roles/permissions**.
