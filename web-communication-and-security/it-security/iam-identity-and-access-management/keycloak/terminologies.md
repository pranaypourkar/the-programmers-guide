# Terminologies

## Authentication

Authentication in Keycloak involves verifying the identity of a user. It ensures that users are who they claim to be before granting them access to protected resources. Keycloak supports various authentication mechanisms, including username/password, social login (e.g., Google, Facebook), and multi-factor authentication.

**For Example:** We have a web application protected by Keycloak. When a user tries to access a secured page, the application redirects them to Keycloak for authentication. The user enters their username and password on the Keycloak login page. Keycloak verifies the credentials and, upon successful authentication, issues an access token that represents the user's identity.

## Authorization

Authorization in Keycloak involves determining what resources a user can access and what actions they can perform. It defines the permissions and privileges associated with different roles and assigns those roles to users. Keycloak provides role-based access control (RBAC) to manage authorization.

**For Example:** After a user has been authenticated, Keycloak can enforce authorization rules based on their assigned roles. For instance, let's consider an e-commerce application where users can be assigned roles such as "customer" or "admin". A customer with the "customer" role may have permission to view products, add items to their cart, and place orders. On the other hand, an admin with the "admin" role may have additional privileges to manage products, view customer details, and perform administrative tasks. Keycloak ensures that only users with the appropriate roles can access specific resources or perform specific actions.

## Access Token vs Refresh Token vs ID Token

Keycloak uses token-based authentication, where tokens (such as Access Token, Refresh Token, and ID Token) are used to verify the identity of the client and the user. Access Token, Refresh Token, and ID Token are all used in the context of authentication and authorization, particularly in the OAuth 2.0 and OpenID Connect protocols in Keycloak.

### Access Token

An access token is a credential that is issued by an authentication server such as Keycloak to a client application after successful authentication. It represents the identity of the authenticated user and contains information about the user and their granted permissions and scope. The access token is typically short-lived and has an expiration time. It is used by the client to access protected resources or make API requests on behalf of the user.

### Refresh Token

A refresh token is a long-lived credential that is also issued by the authentication server during the authentication process. It is used to obtain a new access token after the current access token expires. When the access token expires, the client application can use the refresh token to request a new access token without requiring the user to re-authenticate. Refresh tokens are typically longer-lived than access tokens and are securely stored on the client side. They should be kept confidential and transmitted securely.

### ID Token

An ID token is specific to the OpenID Connect protocol, an authentication layer built on top of OAuth 2.0. It is a JSON Web Token (JWT) that contains identity information about the authenticated user, such as their name, email address, and other profile information. The ID token is issued by the identity provider such as Keycloak during the authentication process and is consumed by the client application. It provides information about the authenticated user and can be used for authentication and user information verification. If we set the "openid" scope when requesting an access token from the Keycloak authorization server, we will receive an ID token along with the access token.

If we need to map different attributes, such as an account ID, between two different applications for single sign-on (SSO) purposes, we can utilize the ID token in Keycloak. We can configure attribute mappings to include additional attributes in the ID token

## Token Encoding

All the above tokens (i.e. access, refresh and id token) are typically encoded using a specific algorithm to ensure their integrity and security during transmission and storage. In the context of Keycloak, the tokens are encoded as JSON Web Tokens (JWTs).

Keycloak supports various algorithms for token encoding and signing, including:

* **Symmetric Algorithms**: Keycloak supports symmetric algorithms like HMAC-SHA256 and HMAC-SHA512 for signing the tokens. Symmetric algorithms use a single shared secret key to both encrypt and decrypt data.
* **Asymmetric Algorithms**: Keycloak also supports asymmetric algorithms like RSA and ECDSA for signing the tokens. These algorithms use a public-private key pair, where the Keycloak server holds the private key and the client application holds the public key. The public key is used for encryption, while the private key is used for decryption.

Some of the Symmetric and Asymmetric Algorithms are listed below. These algorithms represent a mix of symmetric (HMAC) and asymmetric (RSA, ECDSA) cryptographic operations. The choice of algorithm depends on factors such as security requirements, key management, and the capabilities of the client applications or systems that will validate the tokens.

**Symmetric Algorithms:**

1. HS256: HMAC-SHA256 symmetric signing algorithm
2. HS384: HMAC-SHA384 symmetric signing algorithm
3. HS512: HMAC-SHA512 symmetric signing algorithm

**Asymmetric Algorithms:**

1. RS256: RSA-SHA256 asymmetric signing algorithm
2. RS384: RSA-SHA384 asymmetric signing algorithm
3. RS512: RSA-SHA512 asymmetric signing algorithm
4. ES256: ECDSA-SHA256 asymmetric signing algorithm
5. ES384: ECDSA-SHA384 asymmetric signing algorithm
6. ES512: ECDSA-SHA512 asymmetric signing algorithm

The specific algorithm used for encoding and signing the tokens depends on the configuration of the Keycloak server and the chosen realm settings. We can configure the algorithm preferences in the Keycloak admin console under the realm settings and token settings.

<figure><img src="https://static.wixstatic.com/media/5fb94b_e3235696a78d471680d625b0b9ceee7e~mv2.png/v1/fill/w_1480,h_694,al_c,q_90,usm_0.66_1.00_0.01,enc_auto/5fb94b_e3235696a78d471680d625b0b9ceee7e~mv2.png" alt=""><figcaption></figcaption></figure>

**Default Signature Algorithm** parameter means default algorithm used to sign tokens for the realm. For example RS256 is selected in below screenshot.&#x20;

RS256 is a widely used algorithm for signing JSON Web Tokens (JWTs) in the context of the JSON Web Signature (JWS) specification. It is part of the RSA family of algorithms, where the number "256" represents the size of the RSA key used, which is 256 bits.

In the JWT context, RS256 is responsible for signing the token, which ensures its integrity and authenticity. The process involves encoding the token's header and payload sections into a compact string format called the "Signing Input," and then applying an RSA digital signature using the private key corresponding to the RSA public key associated with the token issuer. This signature is appended to the token, forming the JWS. On the receiving side, the JWT can be validated by using the corresponding RSA public key to verify the signature. This ensures that the token has not been tampered with and originates from a trusted source

**Encoding of the token's content itself is not specific to the RS256 algorithm**. Encoding is performed to ensure that the token can be safely transmitted across different systems or mediums, but it is not directly related to the signing process performed by RS256. **By default, Keycloak encodes the JWTs using Base64 encoding for the token's header and payload sections.**

<figure><img src="https://static.wixstatic.com/media/5fb94b_8cb7adaa717449d1bdd0b11865c79e61~mv2.png/v1/fill/w_1480,h_640,al_c,q_90,usm_0.66_1.00_0.01,enc_auto/5fb94b_8cb7adaa717449d1bdd0b11865c79e61~mv2.png" alt=""><figcaption></figcaption></figure>

Public Key or Certificate is available in "**Keys**" Section.

1. **Public Key**: The public key is made available for download so that it can be used by client applications or other services to verify the authenticity and integrity of JWTs issued by Keycloak. When a JWT is signed using a private key, the corresponding public key is required to validate the signature. By providing the public key, Keycloak enables clients to verify the JWT signatures independently.
2. **Certificate**: In some scenarios, it may be more convenient or necessary to use a certificate instead of directly using the public key. The certificate includes the public key and additional information, such as the issuer, validity period, and certificate authority (CA) that issued the certificate. Providing the certificate allows clients to easily retrieve the public key and other relevant information in a standardized format.

<figure><img src="https://static.wixstatic.com/media/5fb94b_8f51a0c728b3491eaa18a31243b96890~mv2.png/v1/fill/w_1480,h_686,al_c,q_90,usm_0.66_1.00_0.01,enc_auto/5fb94b_8f51a0c728b3491eaa18a31243b96890~mv2.png" alt=""><figcaption></figcaption></figure>

JWT Tokens can be decoded easily on this page - [https://jwt.io/](https://jwt.io/)

JWTs consist of three parts:

* Header
* Payload
* Signature

The header specifies the algorithm used to sign the token, while the payload contains the token claims, such as the user's identity and granted permissions. The signature is used to verify the integrity of the token.

A decoded Access Token looks like below.

<table data-header-hidden data-full-width="true"><thead><tr><th></th><th></th><th></th></tr></thead><tbody><tr><td>​Header</td><td>Payload</td><td>Signature</td></tr><tr><td><p><br></p><p><img src="https://static.wixstatic.com/media/5fb94b_659d11b34f1e4e7b8458aea808dd0481~mv2.png/v1/fill/w_450,h_144,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/5fb94b_659d11b34f1e4e7b8458aea808dd0481~mv2.png" alt="" data-size="original"></p><p><br></p></td><td><p><br></p><p><img src="https://static.wixstatic.com/media/5fb94b_912a2d652a354948862f67808d2044b6~mv2.png/v1/fill/w_450,h_592,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/5fb94b_912a2d652a354948862f67808d2044b6~mv2.png" alt="" data-size="original"></p><p>​</p></td><td><p><br></p><p><img src="https://static.wixstatic.com/media/5fb94b_3eefff17f45e40709484a45314e75699~mv2.png/v1/fill/w_450,h_330,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/5fb94b_3eefff17f45e40709484a45314e75699~mv2.png" alt="" data-size="original"></p><p><br></p></td></tr></tbody></table>

A decoded Refresh Token looks like below.

<table data-header-hidden data-full-width="true"><thead><tr><th></th><th></th><th></th></tr></thead><tbody><tr><td>Header</td><td>Payload</td><td>Signature</td></tr><tr><td><p><br></p><p><img src="https://static.wixstatic.com/media/5fb94b_388f13aa8f2943ee910a584cc7288604~mv2.png/v1/fill/w_450,h_146,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/5fb94b_388f13aa8f2943ee910a584cc7288604~mv2.png" alt="" data-size="original"></p><p><br></p></td><td><p><br></p><p><img src="https://static.wixstatic.com/media/5fb94b_f60057ac7992491fa28c03416b86bb64~mv2.png/v1/fill/w_450,h_274,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/5fb94b_f60057ac7992491fa28c03416b86bb64~mv2.png" alt="" data-size="original"></p><p><br></p></td><td><p><br></p><p><img src="https://static.wixstatic.com/media/5fb94b_151fc04462ea43abb9952c48aa39d950~mv2.png/v1/fill/w_450,h_156,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/5fb94b_151fc04462ea43abb9952c48aa39d950~mv2.png" alt="" data-size="original"></p><p><br></p></td></tr></tbody></table>

A decoded ID Token looks like below.

<table data-header-hidden data-full-width="true"><thead><tr><th></th><th></th><th></th></tr></thead><tbody><tr><td>Header</td><td>Payload</td><td>Signature</td></tr><tr><td><p><br></p><p><img src="https://static.wixstatic.com/media/5fb94b_b2295de43e064d9ea09ddc937fd2fdb7~mv2.png/v1/fill/w_450,h_146,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/5fb94b_b2295de43e064d9ea09ddc937fd2fdb7~mv2.png" alt="" data-size="original"></p><p><br></p></td><td><p><br></p><p><img src="https://static.wixstatic.com/media/5fb94b_b3c06774611944fba7cd0ce5008febbd~mv2.png/v1/fill/w_450,h_480,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/5fb94b_b3c06774611944fba7cd0ce5008febbd~mv2.png" alt="" data-size="original"></p><p><br></p></td><td><p><br></p><p><img src="https://static.wixstatic.com/media/5fb94b_422c11534eee4063a5dfaa2ea61e45af~mv2.png/v1/fill/w_450,h_322,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/5fb94b_422c11534eee4063a5dfaa2ea61e45af~mv2.png" alt="" data-size="original"></p><p><br></p></td></tr></tbody></table>

Let's understand some of the fields included in the token

​​**Header Section:**

<table data-header-hidden data-full-width="true"><thead><tr><th width="121"></th><th></th></tr></thead><tbody><tr><td>Fields</td><td>Description</td></tr><tr><td>alg</td><td>The "alg" (algorithm) field specifies the cryptographic algorithm used to sign the JWT. In this case, "RS256" indicates that the token is signed using the RSA algorithm with SHA-256 hashing.</td></tr><tr><td>typ</td><td>​The "typ" (type) field indicates the type of token, which is "JWT" in our case.</td></tr><tr><td>kid</td><td>The "kid" (key ID) field represents the identifier of the key used to sign the JWT. This can be used to identify the key used for verification on the receiving end.</td></tr></tbody></table>

**Payload Section:**

<table data-header-hidden data-full-width="true"><thead><tr><th width="170"></th><th></th></tr></thead><tbody><tr><td>Fields</td><td>Description</td></tr><tr><td>exp</td><td>The "typ" (type) field indicates the type of token, in this case, it's a "Bearer" token.</td></tr><tr><td>iat</td><td>The "iat" (issued at) field represents the timestamp (in seconds) when the token was issued.</td></tr><tr><td>auth_time</td><td>Represents the time when the user was authenticated by the identity provider. It indicates the timestamp at which the authentication event occurred.</td></tr><tr><td>jti</td><td>The "jti" (JWT ID) field is a unique identifier for the token</td></tr><tr><td>iss</td><td>The "iss" (issuer) field specifies the issuer URL or endpoint that issued the token.</td></tr><tr><td>aud</td><td>Represents the audience for which the token is intended. It specifies the intended recipient or recipients of the JWT.</td></tr><tr><td>sub</td><td>The "sub" (subject) field contains the identifier of the subject (user) for whom the token was issued.</td></tr><tr><td>typ</td><td>The "typ" (type) field indicates the type of token, in this case, it's a "Bearer" token.</td></tr><tr><td>azp</td><td>The "azp" (authorized party) field specifies the client or application that is authorized to use the token.</td></tr><tr><td>session_state</td><td>The "session_state" field represents the unique identifier for the user's session.</td></tr><tr><td>at_hash</td><td>This claim can be present in ID Token and is used to verify the integrity of an access token when it is used in certain contexts, such as OpenID Connect (OIDC) authentication flows.</td></tr><tr><td>acr</td><td>The "acr" (authentication context class reference) field indicates the level of authentication used during token issuance.</td></tr><tr><td>sid</td><td>The "sid" (session ID) field is the session identifier associated with the token.</td></tr><tr><td>email_verified</td><td>The "email_verified" field indicates whether the user's email has been verified (true or false).</td></tr><tr><td>name</td><td>The "name" field contains the user's full name.</td></tr><tr><td>preferred_username</td><td>The "preferred_username" field specifies the user's preferred username.</td></tr><tr><td>given_name</td><td>The "given_name" field contains the user's given name or first name.</td></tr><tr><td>family_name</td><td>The "family_name" field represents the user's family name or last name.</td></tr><tr><td>authorities</td><td>The "authorities" field lists the roles or authorities assigned to the user.</td></tr><tr><td>email</td><td>The "internal_scope" field contains internal scopes or permissions associated with the user.</td></tr></tbody></table>





