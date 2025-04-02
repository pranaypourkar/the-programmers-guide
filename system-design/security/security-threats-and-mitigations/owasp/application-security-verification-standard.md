# Application Security Verification Standard

## About

The **OWASP Application Security Verification Standard (ASVS)** is a framework designed to help organizations develop **secure web applications** by providing a **structured set of security requirements**. It serves as a **guideline for developers, architects, testers, and security professionals** to ensure security best practices are implemented during development.

## What is OWASP ASVS?

OWASP ASVS is a **set of security standards** that provides a **detailed framework** for verifying the security of web applications. It defines **three levels of security verification**, making it **useful for different types of applications** based on risk and complexity.

* It acts as a **benchmark for security testing**.
* Helps organizations **define and implement security controls**.
* Reduces security risks by **providing structured security requirements**.

{% hint style="success" %}
#### Official OWASP ASVS Documentation: [https://owasp.org/www-project-application-security-verification-standard/](https://owasp.org/www-project-application-security-verification-standard/)&#x20;
{% endhint %}

## **Why is OWASP ASVS Important ?**

* **Standardized Security Approach** – Provides a **common security framework** to evaluate and improve security controls.
* **Improves Security Posture** – Helps organizations **proactively integrate security** at different application layers.
* **Reduces Development Costs** – By **identifying vulnerabilities early**, ASVS helps **reduce security-related fixes** in later stages.
* **Ensures Compliance** – Aligns with **regulatory requirements** such as GDPR, PCI-DSS, and ISO 27001.

## ASVS Security Verification Levels

OWASP ASVS defines three levels of security verification, depending on the application’s risk profile and security requirements.

<table data-header-hidden data-full-width="true"><thead><tr><th width="242.75"></th><th></th><th></th></tr></thead><tbody><tr><td><strong>ASVS Level</strong></td><td><strong>Description</strong></td><td><strong>Use Case</strong></td></tr><tr><td><strong>Level 1 (Basic Security)</strong></td><td>Ensures <strong>basic security controls</strong> are in place. Covers low-risk applications and general security hygiene.</td><td><strong>Public-facing applications</strong> with minimal security risks (e.g., blogs, marketing sites).</td></tr><tr><td><strong>Level 2 (Standard Security)</strong></td><td>Provides <strong>stronger security requirements</strong> for applications handling <strong>sensitive data</strong>.</td><td>Applications handling <strong>personal, financial, or confidential information</strong> (e.g., banking, healthcare).</td></tr><tr><td><strong>Level 3 (Advanced Security)</strong></td><td>Requires <strong>strict security measures</strong> for highly sensitive applications. Focuses on <strong>defense-in-depth</strong> security.</td><td><strong>Critical applications</strong> such as government systems, financial platforms, and military software.</td></tr></tbody></table>

## ASVS Categories and Controls

OWASP ASVS consists of **14 categories** that cover different security aspects. Each category contains **detailed security controls** for verifying application security.

### **V1: Architecture, Design, and Threat Modeling**

* Ensures applications follow **secure design principles**.
* Includes **threat modeling, secure architecture**, and **risk assessment**.
* Helps identify **attack vectors and potential vulnerabilities** before implementation.

### **V2: Authentication and Session Management**

* Covers **secure user authentication** (password policies, multi-factor authentication).
* Ensures **secure session handling** (session timeouts, token expiration, and re-authentication).

### **V3: Access Control**

* Implements **Role-Based Access Control (RBAC)** and **Least Privilege** principles.
* Prevents **unauthorized access, privilege escalation**, and **broken access control** attacks.

### **V4: Input Validation and Sanitization**

* Prevents **injection attacks (SQL Injection, XSS, NoSQL Injection)**.
* Enforces strict **input validation, encoding, and sanitization**.

### **V5: Cryptography**

* Ensures the use of **strong encryption algorithms** for **data protection**.
* Covers **secure key management, hashing, and cryptographic storage**.

### **V6: Stored and Transmitted Data Protection**

* Encrypts **data at rest** and **data in transit** using TLS, HTTPS, and strong cryptographic algorithms.
* Protects sensitive data from exposure and unauthorized access.

### **V7: Error Handling and Logging**

* Ensures **detailed logging for security events** (authentication failures, unauthorized access attempts).
* Prevents **leakage of sensitive information** in error messages and logs.

### **V8: Data Integrity Protection**

* Ensures **data integrity** through **checksum validation, digital signatures**, and **tamper detection**.
* Protects **software updates, API communications, and session tokens** from manipulation.

### **V9: Communication Security**

* Enforces **secure communication channels** using **TLS (HTTPS), HSTS, and certificate pinning**.
* Protects against **Man-in-the-Middle (MITM) attacks**.

### **V10: Malicious Code and Security Hardening**

* Protects against **supply chain attacks, malware, and untrusted third-party dependencies**.
* Enforces **secure coding guidelines** and **static analysis testing**.

### **V11: Business Logic Security**

* Prevents **abuse of business logic flaws** (e.g., bypassing payment, unauthorized transactions).
* Ensures proper **rate-limiting and anti-automation measures**.

### **V12: API and Web Service Security**

* Enforces **secure API authentication (OAuth2, JWT, API Keys)**.
* Protects against **API abuse, rate-limiting bypass, and unauthorized access**.

### **V13: Configuration and Deployment Security**

* Ensures **secure deployment practices** (CI/CD security, hardening configurations).
* Protects against **misconfigurations, default credentials, and insecure components**.

### **V14: Mobile Security (Optional)**

* Covers **mobile-specific security controls** such as **secure storage, encrypted communication, and biometric authentication**.
* Helps secure **mobile applications from data leakage and unauthorized access**.

## How to Implement ASVS in Development Lifecycle ?

To successfully adopt **ASVS**, organizations should integrate it into the **Software Development Lifecycle (SDLC)**:

### **Requirements Phase**

* Define security requirements based on **ASVS levels**.
* Conduct **threat modeling** to identify application risks.

### **Development Phase**

* Implement **secure coding practices** following ASVS guidelines.
* Use **secure authentication, access control, and encryption** mechanisms.

### **Testing Phase**

* Perform **security testing (static analysis, dynamic testing, penetration testing)**.
* Validate against **ASVS checklist** to ensure compliance.

### **Deployment and Maintenance**

* Apply **secure configurations** for web servers, databases, and cloud infrastructure.
* Continuously **monitor application security** and apply **regular patches**.

## OWASP ASVS vs. OWASP Top 10

<table data-full-width="true"><thead><tr><th width="129.00390625">Feature</th><th>OWASP ASVS</th><th>OWASP Top 10</th></tr></thead><tbody><tr><td><strong>Scope</strong></td><td>Detailed security framework for web applications</td><td>List of most critical security risks</td></tr><tr><td><strong>Focus</strong></td><td>Security verification &#x26; best practices</td><td>Common vulnerabilities &#x26; attack prevention</td></tr><tr><td><strong>Use Case</strong></td><td>Secure software development &#x26; compliance</td><td>Awareness &#x26; risk prioritization</td></tr><tr><td><strong>Granularity</strong></td><td>Structured security controls for different risk levels</td><td>High-level risk categories</td></tr></tbody></table>

{% hint style="info" %}
OWASP ASVS is a structured security standard, while OWASP Top 10 is a vulnerability awareness guide.
{% endhint %}
