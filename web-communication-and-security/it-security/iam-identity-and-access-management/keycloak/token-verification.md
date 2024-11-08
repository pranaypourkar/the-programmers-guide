# Token Verification

Let's understand how we can verify whether a token (say ID Token) is valid and not tampered.

## Different ways to parse and validate JWT Tokens

### 1. Manual Parsing and Validation

In this approach, we have to manually parse the JWT token by splitting it into its three components (header, payload, and signature) using a base64 decoding mechanism. Once split, we have to inspect the token's claims and validate the signature using the token's signing algorithm and the corresponding key. We have to write the logic by ourselves with the help of [RFC 7519: JSON Web Token (JWT)](https://datatracker.ietf.org/doc/html/rfc7519#section-7.2)

### 2. JWT Libraries

Utilize JWT libraries available in your programming language or framework. These libraries provide built-in methods to parse and validate JWT tokens, making the process easier and more robust. Libraries for different framework/language is available at [JWT.IO - JSON Web Tokens Libraries](https://jwt.io/libraries)

### 3. Identity Provider SDKs

Many identity providers offer SDKs that handle JWT parsing and validation as part of their authentication libraries. For example, libraries like Auth0 SDKs, Okta SDKs, or Azure AD libraries often include methods to validate JWT tokens issued by their respective identity providers.

### 4. Framework Integration

Some web frameworks have built-in support for JWT token handling and validation. These frameworks provide middleware or modules that handle the parsing, validation, and authentication of JWT tokens automatically.&#x20;

### 5. Online Validation Tools

Use online JWT validation tools or libraries to perform validation checks without writing code. For example using this site - [JWT.IO](https://jwt.io/)

## Example using Java JWT Library: Nimbus-JOSE-JWT

We will be using Java JWT Library - Nimbus-JOSE-JWT [Bitbucket](https://bitbucket.org/connect2id/nimbus-jose-jwt/src/master/) and a

sample Spring Boot project to verify ID Token Signature of a Valid and Forged Token.&#x20;

> Fetch the certificate details using Certs endpoint ([/realms/employee/protocol/openid-connect/certs](http://localhost:1010/realms/employee/protocol/openid-connect/certs)) and use it to verify the signature of the JWT Tokens\
>

Let's start the keycloak and mysql service using docker-compose.

```yaml
version: "3.9"
# https://docs.docker.com/compose/compose-file/

services:

  # If mysql volume is already created and need to change the initial setup, 
  # remove the volume and restart the container to reflect
  # docker-compose down -v
  mysql:
    container_name: mysql
    image: mysql:8.0.29
    ports:
      - "3306:3306"
    environment:
      MYSQL_DATABASE: identity
      MYSQL_USER: keycloak
      MYSQL_PASSWORD: keycloak
      MYSQL_ROOT_PASSWORD: root
    volumes:
      - mysql-data:/var/lib/mysql

  # access url - http://localhost:1010/
  keycloak:
    image: quay.io/keycloak/keycloak:21.0
    : jboss/keycloak  (Does not support ARM 64 image)
    command: ["start-dev"]
    ports:
      - 1010:8080
      - 1011:8443
    environment:
      KC_HEALTH_ENABLED: true
      KC_METRICS_ENABLED: true
      KC_DB: mysql
      KC_DB_URL: jdbc:mysql://mysql:3306/identity?useSSL=false&allowPublicKeyRetrieval=true&cacheServerConfiguration=true&createDatabaseIfNotExist=true
      KC_DB_USERNAME: root
      KC_DB_PASSWORD: root
      KEYCLOAK_ADMIN: admin
      KEYCLOAK_ADMIN_PASSWORD: admin
      KEYCLOAK_FRONTEND_URL: http://localhost:1010/auth
    volumes:
      #- ./data:/opt/jboss/keycloak/standalone/data
      #- ./themes:/opt/jboss/keycloak/standalone/themes
      #- ./config:/opt/jboss/keycloak/standalone/configuration
      - ./log:/opt/jboss/keycloak/standalone/log
    depends_on:
        - mysql

volumes:
  mysql-data:
    driver: local

networks:
  default:
    name: company_default
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_02ee7889de134812b6ba3e696470811e~mv2.png/v1/fill/w_1480,h_542,al_c,q_90,usm_0.66_1.00_0.01,enc_auto/5fb94b_02ee7889de134812b6ba3e696470811e~mv2.png" alt=""><figcaption></figcaption></figure>

Realm settings attached below for the reference.

{% file src="../../../../.gitbook/assets/realm-export.json" %}

pom.xml (nimbus-jose-jwt dependency)

```xml
<!-- nimbus-jose-jwt -->
<dependency>
  <groupId>com.nimbusds</groupId>
  <artifactId>nimbus-jose-jwt</artifactId>
  <version>9.30.1</version>
</dependency>
```

Application.java

```java
package com.company.project;

import com.nimbusds.jose.JOSEException;
import com.nimbusds.jose.JWSVerifier;
import com.nimbusds.jose.crypto.RSASSAVerifier;
import com.nimbusds.jose.jwk.JWKSet;
import com.nimbusds.jose.jwk.RSAKey;
import com.nimbusds.jose.util.X509CertUtils;
import com.nimbusds.jwt.JWTClaimsSet;
import com.nimbusds.jwt.SignedJWT;
import java.security.cert.X509Certificate;
import java.security.interfaces.RSAPublicKey;
import java.text.ParseException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestTemplate;

@Slf4j
@SpringBootApplication
public class Application {
    public static final String CERTS_ENDPOINT = "http://localhost:1010/realms/employee/protocol/openid-connect/certs";
    public static final String VALID_ID_TOKEN = "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJqaEtlM0RGc2ZzOWJMbjl3NVYzQUc0Sm5UMDJYMW0zaEpMbWY3dmR3SDhJIn0.eyJleHAiOjE2ODc3ODIxMDEsImlhdCI6MTY4Nzc4MTgwMSwiYXV0aF90aW1lIjowLCJqdGkiOiI0OWE0YzIwNC03NDA2LTQ2YTQtYjIwZi0xYmNlZjg0MTg5YjYiLCJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjEwMTAvcmVhbG1zL2VtcGxveWVlIiwiYXVkIjoiZW1wbG95ZWUtc2VydmljZS1jbGllbnQiLCJzdWIiOiJmMzMxNGVhNy00NDE4LTRiZjctOWZhNy1jYzVkZWZkZTA5MWIiLCJ0eXAiOiJJRCIsImF6cCI6ImVtcGxveWVlLXNlcnZpY2UtY2xpZW50Iiwic2Vzc2lvbl9zdGF0ZSI6Ijg4ZDVmNTQ5LTc5YjUtNDlkOC1iYTY5LTliNDMyNzIxNDk3ZCIsImF0X2hhc2giOiJTRVZtX2Q4Nk5oR2Y4TmVvSWxWUWdRIiwiYWNyIjoiMSIsInNpZCI6Ijg4ZDVmNTQ5LTc5YjUtNDlkOC1iYTY5LTliNDMyNzIxNDk3ZCIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJ1c2VyMSIsImdpdmVuX25hbWUiOiIiLCJmYW1pbHlfbmFtZSI6IiIsImVtYWlsIjoidXNlcjFAdGVzdC5jb20ifQ.HHdm6clyKB6Lh_iUxKyL6A2zqo3WNOOLBhjKWAeR5OvABK8zjAfAESt-wjV99Br3V5eOiGa2MB1PbMOIKwHW05-ZIDBQ_8SY8WWorIEOGS3BdZCjh-_SsXurQkZtHrKpR8268b6nRBkVT83KX_qd8BIJAA_6vgqwdb6z5Pnt9QzZAuDeDQLia1Ba0kdIua0OU1XoDVpAlxNdeSyHcjbRlbFxHx7nZQKmu3LFsAji8j-ypsp1ts06Jn9LDMhp30tgVKUH1MzpwOvIpD2jlpo6MMgAUmjV6Vy6xJBg46F8LItxXkIyvtRzkJiT4bm2Jubvlr5F2X0t6THY_T6ZopTTlQ";
    public static final String FORGED_ID_TOKEN = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6ImpoS2UzREZzZnM5YkxuOXc1VjNBRzRKblQwMlgxbTNoSkxtZjd2ZHdIOEkifQ.eyJleHAiOjE2ODc3ODIxMDEsImlhdCI6MTY4Nzc4MTgwMSwiYXV0aF90aW1lIjowLCJqdGkiOiI0OWE0YzIwNC03NDA2LTQ2YTQtYjIwZi0xYmNlZjg0MTg5YjYiLCJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjEwMTAvcmVhbG1zL2VtcGxveWVlIiwiYXVkIjoiZW1wbG95ZWUtc2VydmljZS1jbGllbnQiLCJzdWIiOiJmMzMxNGVhNy00NDE4LTRiZjctOWZhNy1jYzVkZWZkZTA5MWIiLCJ0eXAiOiJJRCIsImF6cCI6ImVtcGxveWVlLXNlcnZpY2UtY2xpZW50Iiwic2Vzc2lvbl9zdGF0ZSI6Ijg4ZDVmNTQ5LTc5YjUtNDlkOC1iYTY5LTliNDMyNzIxNDk3ZCIsImF0X2hhc2giOiJTRVZtX2Q4Nk5oR2Y4TmVvSWxWUWdRIiwiYWNyIjoiMSIsInNpZCI6Ijg4ZDVmNTQ5LTc5YjUtNDlkOC1iYTY5LTliNDMyNzIxNDk3ZCIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJ1c2VyMiIsImdpdmVuX25hbWUiOiIiLCJmYW1pbHlfbmFtZSI6IiIsImVtYWlsIjoidXNlcjJAdGVzdC5jb20ifQ.KzV8RT8iumpFnPzt6J1HbQw5E-i4ldEzatHETf3bWyOs3GK_TIfMINnMY6Py5TkFnEwRRwLsDlWA2Vhyu70GbMusIZlY3YbmuioqLZ4R7QwE4wrcWjs-NgBAnEaTd-6T-hL3TKvjU9Yyn4WcsXcszgq8QzE9Udh1umDt57wQgWBGPuc8knf_1lh6bqnUmmH7gaEt8Yvw_yZrXxqBmxOiCBwMb4VxeLnvxFvZxYvXQzXPybd1Q25NT0D2loYx4P_1y2mCJSet2qhek0gfeaeJ7BUY66R6gd5fjAj1d7PkmI7YbJYlsLsrCZKZNg76MVf14f0Ck_Ts9Skd6DkW4l1XTA";
    public static final String SIGNATURE_VERIFIED = "Signature verified";
    public static final String SIGNATURE_INVALID = "Invalid signature";
    public static final String PARSE_EXCEPTION = "Invalid Token";
    public static final String EMAIL_CLAIM = "email";

    public static void main(String[] args) throws ParseException, JOSEException {
        SpringApplication.run(Application.class, args);

        // Get the Certificate API Response
        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<String> certsResponse = restTemplate.getForEntity(CERTS_ENDPOINT, String.class);

        // Parse the String JSON response to extract the first key object
        JWKSet jwkSet = JWKSet.parse(certsResponse.getBody());
        RSAKey rsaKey = (RSAKey) jwkSet.getKeys().get(1);

        log.info("Extracted Public Key/Certificate Details");
        log.info("Key: {}", rsaKey);

        // Extract the public key from the RSAKey
        X509Certificate certificate = X509CertUtils.parse(rsaKey.getX509CertChain().get(0).decode());
        RSAPublicKey publicKey = (RSAPublicKey) certificate.getPublicKey();

        //Validate Valid ID Token
        verifySignature(publicKey, VALID_ID_TOKEN);

        //Validate Forged ID Token
        verifySignature(publicKey, FORGED_ID_TOKEN);
    }

    public static void verifySignature(RSAPublicKey publicKey, String token) throws ParseException, JOSEException {

        log.info("Validating Token: {}", token);

        // Get the JWSVerifier with given public key
        JWSVerifier verifier = new RSASSAVerifier(publicKey);

        // Parse the JWT token string
        SignedJWT signedJWT;
        signedJWT = SignedJWT.parse(token);

        // Verify the signature
        if (signedJWT.verify(verifier)) {
            log.info(SIGNATURE_VERIFIED);
            JWTClaimsSet claims = signedJWT.getJWTClaimsSet();

            // Extract Claims
            log.info("Email: {}", claims.getClaim(EMAIL_CLAIM));
        } else {
            log.info(SIGNATURE_INVALID);
        }
    }
}
```

Output

<figure><img src="https://static.wixstatic.com/media/5fb94b_7fc33487165f44e1b79fd26defcf2e50~mv2.png/v1/fill/w_1480,h_594,al_c,q_90,usm_0.66_1.00_0.01,enc_auto/5fb94b_7fc33487165f44e1b79fd26defcf2e50~mv2.png" alt=""><figcaption></figcaption></figure>

Postman Response of [http://localhost:1010/realms/employee/protocol/openid-connect/certs](http://localhost:1010/realms/employee/protocol/openid-connect/certs)

<figure><img src="https://static.wixstatic.com/media/5fb94b_e78314d492c14f6cb068af614fcdfcf5~mv2.png/v1/fill/w_1480,h_1038,al_c,q_90,usm_0.66_1.00_0.01,enc_auto/5fb94b_e78314d492c14f6cb068af614fcdfcf5~mv2.png" alt=""><figcaption></figcaption></figure>

<figure><img src="https://static.wixstatic.com/media/5fb94b_338ca7174e1f4f66988a8ac8dd339054~mv2.png/v1/fill/w_1480,h_514,al_c,q_90,usm_0.66_1.00_0.01,enc_auto/5fb94b_338ca7174e1f4f66988a8ac8dd339054~mv2.png" alt=""><figcaption></figcaption></figure>

\
\
\
