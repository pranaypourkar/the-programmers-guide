# Top 10 Security Threats

## About

Security flaws in applications are weaknesses or vulnerabilities that attackers can exploit to gain unauthorized access, manipulate data, or disrupt services. The **Open Web Application Security Project (OWASP)** is dedicated to identifying and mitigating these security flaws by providing guidelines, tools, and best practices for secure software development.

The **OWASP Top 10** is a globally recognized list of the most critical security risks in web applications. It is updated periodically to reflect emerging threats and changing attack patterns.

## Why Understanding Security Flaws is Important ?

* Security flaws **increase the risk** of data breaches, financial loss, and reputational damage.
* Exploitable vulnerabilities can lead to **account takeovers, unauthorized transactions, or full system compromise**.
* Many security flaws arise due to **poor coding practices, misconfigurations, or lack of security awareness**.
* Understanding these flaws helps developers **build secure applications** from the ground up.

## A01:2021 – Broken Access Control

**Description**

* Occurs when an application **fails to enforce restrictions** on what authenticated users can do.
* Attackers can **bypass authorization mechanisms** to access or modify resources beyond their intended permissions.

**Examples of Exploitation:**

* Modifying **URL parameters** to access other users' data (`/api/user/123` → `/api/user/124`).
* **Privilege escalation** via insecure access controls.
* Disabling security features by modifying requests.

**Solution:**

* Implement **Role-Based Access Control (RBAC)** with least privilege principles.
* Use **server-side enforcement** for access controls (do not rely on client-side checks).
* Enforce **proper authentication & session management**.
* Perform **security testing** to identify misconfigurations.

## A02:2021 – Cryptographic Failures (Sensitive Data Exposure)

**Description:**

* Insufficient **encryption or improper handling of sensitive data** like passwords, credit card details, or personal data.
* Attackers can **intercept unencrypted data**, brute-force weak encryption, or exploit misconfigured cryptographic implementations.

**Examples of Exploitation:**

* Storing passwords in **plain text** instead of hashing them.
* **Weak encryption** (e.g., MD5, SHA-1) making data vulnerable to brute force attacks.
* Not enforcing **TLS encryption** for data in transit.

**Solution:**

* Use **strong encryption algorithms** (AES-256, bcrypt, Argon2 for password hashing).
* **Never store plaintext passwords**—always hash them with salt.
* Enforce **TLS (HTTPS) for all communication**.
* Use **HSTS (HTTP Strict Transport Security)** to prevent SSL stripping attacks.

## A03:2021 – Injection (SQL, NoSQL, Command, etc.)

**Description:**

* Occurs when untrusted data is **sent to an interpreter** (SQL, NoSQL, LDAP, OS commands) as part of a query or command.
* Attackers can **manipulate queries** to extract or modify data, execute arbitrary code, or escalate privileges.

**Examples of Exploitation:**

* SQL Injection (`SELECT * FROM users WHERE username = 'admin' -- ' AND password = 'password'`)
* Command Injection (`; rm -rf /`)
* NoSQL Injection (`{ "$where": "this.password == 'password'" }`)

**Solution:**

* Use **parameterized queries** (Prepared Statements) or ORM frameworks.
* **Sanitize and validate user inputs** before processing.
* Implement **Web Application Firewalls (WAFs)** for additional protection.
* Use **least privilege** for database accounts to limit impact.

## A04:2021 – Insecure Design

**Description:**

* Flaws in **architecture and design** that expose security risks.
* Unlike misconfigurations or bugs, these issues arise from **fundamental design weaknesses**.

**Examples of Exploitation:**

* API endpoints that **lack rate limiting**, allowing brute-force attacks.
* Application **lacking multi-factor authentication (MFA)**, making account takeovers easier.

**Solution:**

* Perform **Threat Modeling** early in the design phase.
* Follow **Secure by Design** principles (least privilege, fail-safe defaults).
* Conduct **regular security reviews and architectural risk assessments**.

## A05:2021 – Security Misconfiguration

**Description:**

* Occurs when an application, database, or server is **improperly configured**, leading to vulnerabilities.
* Attackers can **exploit default credentials, unpatched software, and excessive permissions**.

**Examples of Exploitation:**

* Leaving **default admin credentials** unchanged (`admin/admin`).
* Exposing **debug error messages** that reveal sensitive details.

**Solution:**

* **Harden configurations** by disabling unnecessary services and features.
* Remove **default accounts** and enforce **strong authentication mechanisms**.
* Automate security configuration checks using **CIS Benchmarks**.

## A06:2021 – Vulnerable and Outdated Components

**Description:**

* Using outdated third-party **libraries, plugins, or dependencies** with known vulnerabilities.
* Attackers can **exploit old vulnerabilities** to gain control of applications.

**Examples of Exploitation:**

* Running an outdated **Log4j version vulnerable to RCE attacks**.
* Using **deprecated cryptographic algorithms** in outdated libraries.

**Solution:**

* Regularly **update software dependencies** and apply patches.
* Use **OWASP Dependency-Check** to identify outdated components.
* Follow **Software Composition Analysis (SCA)** best practices.

## A07:2021 – Identification and Authentication Failures

**Description:**

* Weak authentication mechanisms **allow attackers to bypass login protections**.
* Users can be impersonated, leading to data breaches and account takeovers.

**Examples of Exploitation:**

* Allowing **weak passwords** like "password123".
* Not enforcing **account lockout** after failed login attempts.
* Using **JWT tokens without expiration**.

**Solution:**

* Enforce **strong password policies** and implement MFA.
* Implement **secure session management** (short-lived tokens, session timeout).
* Use **OAuth 2.0, OpenID Connect, or SAML for authentication**.

## A08:2021 – Software and Data Integrity Failures

**Description:**

* Attackers modify software, configuration files, or transmitted data to introduce malicious behavior.
* Lack of **code signing, CI/CD security controls, or integrity verification** leads to risk.

**Examples of Exploitation:**

* Malicious code injection in **third-party scripts** (e.g., Magecart attack).
* **Supply chain attacks** where compromised libraries introduce backdoors.

**Solution:**

* Use **digital signatures** and **checksum validation**.
* Implement **secure CI/CD pipelines** with signed artifacts.
* Validate **third-party dependencies** before use.

## A09:2021 – Security Logging and Monitoring Failures

**Description:**

* Without proper logging, **attacks go undetected**, making it harder to respond.
* Lack of monitoring enables **stealthy persistence of attackers** in systems.

**Examples of Exploitation:**

* No logs for **failed login attempts**, allowing brute-force attacks.
* Not detecting **suspicious API calls or privilege escalation attempts**.

**Solution:**

* Enable **centralized security logging** (SIEM solutions).
* Implement **real-time monitoring and alerts** for suspicious activity.
* Perform **regular security audits** and log analysis.

## A10:2021 – Server-Side Request Forgery (SSRF)

**Description:**

* Attackers **manipulate server requests** to access internal resources or sensitive data.
* Often exploited in **cloud environments** where internal APIs are exposed.

**Examples of Exploitation:**

* Sending a crafted request to access **metadata services (e.g., AWS, Azure)**.
* Exploiting vulnerable **file upload** functionality to retrieve local files.

**Solution:**

* Restrict **external URL fetching** with allowlists.
* Validate and sanitize user input before processing URLs.
* Use **network segmentation** to prevent unauthorized internal access.





