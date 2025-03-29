# Authorization

## About

Authorization is the process of determining **what actions a user is allowed to perform** after authentication. It controls **access to resources** based on the user's roles, permissions, or attributes.

{% hint style="success" %}
**Who can access what?** – Determines whether a user can perform an action.

**How is access controlled?** – Uses roles, permissions, and policies.

**Where is authorization applied?** – Can be applied at the **method, API, or resource level**.
{% endhint %}

## **Authentication vs Authorization**

<table><thead><tr><th width="167">Aspect</th><th width="252">Authentication</th><th>Authorization</th></tr></thead><tbody><tr><td><strong>Definition</strong></td><td>Verifies <strong>who you are</strong></td><td>Determines <strong>what you can do</strong></td></tr><tr><td><strong>Process</strong></td><td>Username, password, tokens</td><td>Roles, permissions, policies</td></tr><tr><td><strong>Purpose</strong></td><td>Identifies a user</td><td>Enforces access control</td></tr><tr><td><strong>Happens When?</strong></td><td>Before authorization</td><td>After authentication</td></tr><tr><td><strong>Example</strong></td><td>Login with credentials</td><td>Access control (admin vs. user)</td></tr></tbody></table>

## **How Spring Security Handles Authorization ?**

Spring Security provides multiple ways to implement authorization:

* **Role-based access control (RBAC)** – Users are assigned roles, and roles define permissions.
* **Permission-based access control** – Fine-grained access control using explicit permissions.
* **Attribute-based access control (ABAC)** – Uses user attributes, request parameters, and dynamic rules.
* **Access control at different levels**:
  * **Method-level security** (using `@PreAuthorize`, `@Secured`)
  * **URL-level security** (via `HttpSecurity`)
  * **Domain object security** (using ACLs – Access Control Lists)

## **Authorization Workflow**

1. **User is authenticated** (via session, token, or other mechanisms).
2. **Spring Security retrieves the user's roles and permissions** from `UserDetails`.
3. **Access is checked** against security configurations.
4. **Decision is made** – Allow or deny access.

## **Role-Based Authorization (RBAC)**

RBAC is the **most common authorization model**. It assigns **roles** to users, and roles grant access to specific resources.

#### **Example: Configuring Role-Based Authorization**

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/admin/**").hasRole("ADMIN")  // Only ADMIN role can access
                .requestMatchers("/user/**").hasAnyRole("USER", "ADMIN") // USER or ADMIN can access
                .anyRequest().authenticated()
            )
            .formLogin(withDefaults()); 

        return http.build();
    }
}
```

* `/admin/**` is accessible only to users with the **ADMIN** role.
* `/user/**` is accessible to both **USER and ADMIN** roles.

## **Method-Level Authorization**

Spring Security allows **fine-grained authorization** at the **method level** using annotations.

### **Using `@PreAuthorize` and `@PostAuthorize`**

```java
@Service
public class OrderService {

    @PreAuthorize("hasRole('ADMIN')")
    public void createOrder() {
        // Only ADMIN can create orders
    }

    @PostAuthorize("returnObject.owner == authentication.name")
    public Order getOrder(Long id) {
        // Return order only if the current user is the owner
        return orderRepository.findById(id).orElseThrow();
    }
}
```

* `@PreAuthorize("hasRole('ADMIN')")` – Restricts method execution to ADMIN users.
* `@PostAuthorize("returnObject.owner == authentication.name")` – Ensures the returned object **belongs to the authenticated user**.

### **Using `@Secured` (Alternative to `@PreAuthorize`)**

```java
@Secured({"ROLE_ADMIN"})
public void deleteUser(Long userId) {
    // Only ADMIN can delete a user
}
```

* `@Secured({"ROLE_ADMIN"})` is **less flexible** than `@PreAuthorize`.

## **Attribute-Based Access Control (ABAC)**

ABAC is an **advanced authorization model** that evaluates attributes of users, resources, and contexts dynamically.

#### **Example: Restricting Access Based on Custom Conditions**

```java
@PreAuthorize("#order.owner == authentication.name or hasRole('ADMIN')")
public Order getOrder(Long id) {
    // Order can be accessed if the user is the owner or an ADMIN
    return orderRepository.findById(id).orElseThrow();
}
```

* Users can access orders **only if they own them** or have the **ADMIN** role.

## **Permission-Based Authorization**

Instead of assigning broad **roles**, Spring Security allows fine-grained **permissions**.

### **Define Custom Permissions in `GrantedAuthority`**

```java
public class CustomUserDetails implements UserDetails {
    private List<GrantedAuthority> authorities;

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return authorities;
    }
}
```

### **Using Permissions in Authorization**

```java
@PreAuthorize("hasAuthority('ORDER_READ')")
public Order getOrder(Long id) {
    return orderRepository.findById(id).orElseThrow();
}
```

* `hasAuthority('ORDER_READ')` checks for **specific permission**, not just a role.

## **URL-Based Authorization**

Spring Security also provides **request-based authorization** for securing specific URLs.

```java
@Bean
public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    http
        .authorizeHttpRequests(auth -> auth
            .requestMatchers(HttpMethod.GET, "/orders/**").hasAuthority("ORDER_READ")
            .requestMatchers(HttpMethod.POST, "/orders/**").hasAuthority("ORDER_CREATE")
            .requestMatchers("/admin/**").hasRole("ADMIN")
            .anyRequest().authenticated()
        );

    return http.build();
}
```

* Allows \*\*GET requests to `/orders/**` only if the user has `ORDER_READ` permission.
* Restricts \*\*POST requests to `/orders/**` to users with `ORDER_CREATE`.

## **Custom Access Decision Manager**

If the default authorization mechanisms are **not sufficient**, we can implement **custom access control logic**.

```java
@Component
public class CustomAccessDecisionManager implements AccessDecisionManager {

    @Override
    public void decide(Authentication authentication, Object object, Collection<ConfigAttribute> configAttributes)
            throws AccessDeniedException {
        
        for (ConfigAttribute attribute : configAttributes) {
            if (authentication.getAuthorities().stream()
                    .noneMatch(grantedAuthority -> grantedAuthority.getAuthority().equals(attribute.getAttribute()))) {
                throw new AccessDeniedException("Access Denied");
            }
        }
    }
}
```

* Checks whether the user has the required **permissions dynamically**.

Now, integrate the custom `AccessDecisionManager` in **Spring Security's `SecurityFilterChain`**.

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    private final CustomAccessDecisionManager customAccessDecisionManager;

    public SecurityConfig(CustomAccessDecisionManager customAccessDecisionManager) {
        this.customAccessDecisionManager = customAccessDecisionManager;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/admin/**").hasRole("ADMIN")
                .requestMatchers("/user/**").hasAnyRole("USER", "ADMIN")
                .anyRequest().authenticated()
                .accessDecisionManager(customAccessDecisionManager) // Inject custom manager
            )
            .formLogin(Customizer.withDefaults());

        return http.build();
    }
}
```

## **Security Considerations for Authorization**

| **Security Risk**                    | **Mitigation**                                |
| ------------------------------------ | --------------------------------------------- |
| **Over-privileged roles**            | Implement least privilege principle.          |
| **Hardcoded role checks**            | Use permissions (`hasAuthority()`) instead.   |
| **Lack of auditing**                 | Log access control decisions.                 |
| **Insecure URL-based authorization** | Restrict based on HTTP methods.               |
| **Improper method security**         | Enforce `@PreAuthorize` on sensitive methods. |





