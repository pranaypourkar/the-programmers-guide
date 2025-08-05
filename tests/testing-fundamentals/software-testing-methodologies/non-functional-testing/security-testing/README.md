# Security Testing

## About

**Security Testing** is a type of software testing that evaluates an application, system, or network for **vulnerabilities, risks, and weaknesses** that could be exploited by malicious actors.\
Its primary objective is to ensure that data, resources, and services are protected against unauthorized access, misuse, modification, or destruction.

Unlike functional testing, which verifies that features work as intended, security testing focuses on **proactively identifying and mitigating threats** before they are exploited in production.\
It covers areas such as authentication, authorization, encryption, input validation, session management, and secure configuration.

Security testing can be **manual** (ethical hacking, code review) or **automated** (vulnerability scanning, static/dynamic analysis) and often follows industry security standards such as OWASP, NIST, or ISO 27001.

## Purpose of Security Testing

* **Identify Vulnerabilities Before Attackers Do**\
  Detect flaws in the application, infrastructure, or configurations that could lead to data breaches or system compromise.
* **Ensure Data Protection**\
  Verify that sensitive information—such as passwords, financial records, and personal data—is encrypted, stored, and transmitted securely.
* **Validate Authentication and Authorization Controls**\
  Ensure that only authorized users can access specific data and functionalities.
* **Prevent Injection and Exploitation Attacks**\
  Detect and address common vulnerabilities like SQL injection, XSS, CSRF, and insecure API endpoints.
* **Assess Compliance with Security Standards**\
  Confirm adherence to security regulations and frameworks such as PCI DSS, GDPR, HIPAA, and SOC 2.
* **Strengthen Incident Response Preparedness**\
  Test how well the system detects, logs, and responds to potential attacks.
* **Build User Trust**\
  Demonstrate a commitment to protecting customer data and maintaining service integrity.

## Aspects of Security Testing

Security testing covers multiple layers of the application and infrastructure to ensure protection against internal and external threats.\
Key aspects include:

#### 1. **Authentication Testing**

Verifies that the system correctly identifies and validates users before granting access.

* Includes testing of password policies, MFA, biometric authentication, and OAuth/OpenID integrations.

#### 2. **Authorization Testing**

Checks that users can only access resources and actions they are permitted to.

* Covers role-based access control (RBAC), attribute-based access control (ABAC), and privilege escalation prevention.

#### 3. **Data Protection and Encryption**

Ensures sensitive data is encrypted at rest and in transit using secure algorithms and protocols.

* Validates SSL/TLS configurations, key management, and secure storage mechanisms.

#### 4. **Input Validation and Sanitization**

Tests for vulnerabilities caused by improper handling of user input.

* Includes SQL injection, cross-site scripting (XSS), command injection, and template injection.

#### 5. **Session Management**

Evaluates session timeout policies, cookie security flags, token handling, and prevention of session hijacking.

#### 6. **Error and Logging Management**

Checks that error messages do not leak sensitive details and that logging is secure, tamper-proof, and privacy-compliant.

#### 7. **API and Service Security**

Validates API authentication, authorization, rate limiting, and resistance to common API attacks.

#### 8. **Infrastructure and Configuration Security**

Tests server hardening, firewall rules, network segmentation, and secure configuration of dependencies and services.

## When to Perform Security Testing ?

Security testing should not be an afterthought, it needs to be integrated throughout the development and deployment lifecycle.

* **During Development (Shift-Left Security)**\
  Apply static code analysis, dependency scanning, and secure coding practices early in the SDLC.
* **Before Major Releases**\
  Conduct penetration testing, vulnerability scanning, and security audits before pushing to production.
* **After Significant Code or Architecture Changes**\
  Reassess security when introducing new features, APIs, or infrastructure changes.
* **Before Integrating with Third-Party Services**\
  Validate that external services do not introduce security risks.
* **As Part of Continuous Monitoring**\
  Automate vulnerability scanning and configuration checks as part of CI/CD pipelines.
* **After a Security Incident**\
  Perform targeted security testing to ensure vulnerabilities have been fixed and no new ones were introduced.

## Security Testing Tools and Frameworks

Security testing uses a combination of **manual techniques**, **automated scanners**, and **framework-based methodologies** to detect and mitigate vulnerabilities.\
Tools vary depending on whether the testing focuses on **applications**, **APIs**, **networks**, or **infrastructure**.

#### **Application Security Testing**

* **OWASP ZAP (Zed Attack Proxy)** – Open-source penetration testing tool for finding common vulnerabilities like XSS, SQL injection, and insecure cookies.
* **Burp Suite** – Widely used for web application security testing, with tools for intercepting, modifying, and replaying requests.
* **Acunetix** – Automated web vulnerability scanner that integrates with CI/CD pipelines.

#### **Static Application Security Testing (SAST)**

* **SonarQube** – Detects insecure coding patterns in source code.
* **Checkmarx** – Enterprise-grade SAST solution for secure code analysis.
* **Fortify Static Code Analyzer** – Comprehensive code security scanning tool.

#### **Dynamic Application Security Testing (DAST)**

* **OWASP ZAP** – Also supports dynamic scanning of live applications.
* **Netsparker** – Automated DAST tool for detecting exploitable vulnerabilities in running apps.

#### **API Security Testing**

* **Postman + Security Scripts** – For testing API authentication, authorization, and input validation.
* **Insomnia** – API client that can be extended with security test scripts.
* **42Crunch** – API-specific security testing platform with OpenAPI integration.

#### **Network and Infrastructure Security**

* **Nmap** – Network mapping and vulnerability scanning tool.
* **Nessus** – Comprehensive network vulnerability assessment solution.
* **OpenVAS** – Open-source vulnerability scanner for network services.

#### **Security Testing Frameworks and Standards**

* **OWASP Top 10** – Industry standard list of the most critical security risks for web applications.
* **NIST Cybersecurity Framework** – Risk management and security best practices.
* **MITRE ATT\&CK** – Knowledge base of adversary tactics and techniques.

## Best Practices

#### 1. **Integrate Security Early (Shift-Left Approach)**

Incorporate security testing into the earliest stages of development to detect and fix vulnerabilities before release.

#### 2. **Use a Layered Security Approach**

Test application, network, and infrastructure layers to ensure multiple levels of defense.

#### 3. **Combine Manual and Automated Testing**

Automated tools are efficient for coverage, but manual penetration testing finds logic flaws and complex attack paths.

#### 4. **Test Both Internal and External Threat Models**

Simulate attacks from both authenticated and unauthenticated perspectives.

#### 5. **Validate Third-Party Components**

Scan libraries, dependencies, and APIs for vulnerabilities using tools like OWASP Dependency-Check or Snyk.

#### 6. **Keep Tools and Rules Updated**

Ensure vulnerability databases and testing tools are updated to detect the latest threats.

#### 7. **Secure Test Data and Environment**

Avoid using live customer data; use masked or synthetic data for security tests.

#### 8. **Document and Prioritize Findings**

Classify vulnerabilities by severity (e.g., critical, high, medium, low) and prioritize remediation based on business risk.

#### 9. **Re-Test After Fixes**

Verify that applied patches or changes effectively resolve vulnerabilities without introducing new ones.
