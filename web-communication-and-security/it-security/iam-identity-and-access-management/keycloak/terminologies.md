# Terminologies

## Authentication

Authentication in Keycloak involves verifying the identity of a user. It ensures that users are who they claim to be before granting them access to protected resources. Keycloak supports various authentication mechanisms, including username/password, social login (e.g., Google, Facebook), and multi-factor authentication.

**For Example:** We have a web application protected by Keycloak. When a user tries to access a secured page, the application redirects them to Keycloak for authentication. The user enters their username and password on the Keycloak login page. Keycloak verifies the credentials and, upon successful authentication, issues an access token that represents the user's identity.

## Authorization

Authorization in Keycloak involves determining what resources a user can access and what actions they can perform. It defines the permissions and privileges associated with different roles and assigns those roles to users. Keycloak provides role-based access control (RBAC) to manage authorization.

**For Example:** After a user has been authenticated, Keycloak can enforce authorization rules based on their assigned roles. For instance, let's consider an e-commerce application where users can be assigned roles such as "customer" or "admin". A customer with the "customer" role may have permission to view products, add items to their cart, and place orders. On the other hand, an admin with the "admin" role may have additional privileges to manage products, view customer details, and perform administrative tasks. Keycloak ensures that only users with the appropriate roles can access specific resources or perform specific actions.

## Token-based Authentication

Token-based authentication is a method of authenticating users and granting them access to resources using unique tokens instead of traditional methods like session IDs or cookies. This approach is commonly used in modern web and mobile applications, especially with distributed and stateless architectures.

### **How Token-Based Authentication Works**

In a token-based authentication system, the process generally follows these steps:

* **User Login**: A user logs into an application by providing their credentials (username and password).
* **Token Issuance**: Upon successful authentication, the server generates a unique token, often a JSON Web Token (JWT), that encapsulates the user’s identity and claims (permissions or roles). This token acts as a “key” to access protected resources.
* **Client Stores the Token**: The token is sent back to the client (e.g., a web or mobile application) and stored locally, typically in the client’s memory, local storage, or a secure cookie.
* **Client Requests with Token**: When the client needs access to a protected resource, it includes the token in the request (usually in the HTTP Authorization header as a Bearer token).
* **Server Validates the Token**: The server verifies the token's validity, checking its integrity, expiration, and other claims.
* **Access Granted or Denied**: If the token is valid, the server processes the request and grants access to the resource. If not, the server rejects the request (for example, if the token is expired or tampered with).





