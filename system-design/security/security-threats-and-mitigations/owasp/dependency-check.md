# Dependency Check

## About

OWASP Dependency-Check is a **software composition analysis (SCA) tool** that identifies **vulnerable dependencies** in a project by scanning its libraries and frameworks. It helps developers **detect known security vulnerabilities** in third-party dependencies using the **Common Vulnerabilities and Exposures (CVE) database**.

## What is OWASP Dependency-Check?

OWASP Dependency-Check is an **open-source security tool** that analyzes dependencies used in an application and **detects known vulnerabilities** by checking against databases like:

* **National Vulnerability Database (NVD)**
* **GitHub Security Advisories**
* **Sonatype OSS Index**
* **VulnDB (commercial integration)**

{% hint style="info" %}
Refer to the Official Documentation for more detail&#x73;**:** [https://owasp.org/www-project-dependency-check/](https://owasp.org/www-project-dependency-check/)
{% endhint %}

## Why is OWASP Dependency-Check Important?

* **Third-Party Libraries Are Common Attack Vectors** – Many security breaches originate from vulnerable third-party libraries (e.g., Log4Shell vulnerability in Log4j).
* **Automatically Detects Known Vulnerabilities** – Scans project dependencies and matches them against public vulnerability databases.
* **Prevents Supply Chain Attacks** – Ensures that your application does not include compromised or backdoored dependencies.
* **Integrates with Build Pipelines** – Can be used with Maven, Gradle, Jenkins, GitHub Actions, and CI/CD pipelines.
* **Compliance with Security Standards** – Helps organizations comply with ISO 27001, NIST, GDPR, and PCI-DSS security requirements.

## How OWASP Dependency-Check Works ?

1. **Extracts dependency information** – Reads dependencies from Maven (pom.xml), Gradle (build.gradle), or package managers.
2. **Matches against vulnerability databases** – Checks dependencies against NVD, OSS Index, and other sources.
3. **Generates a vulnerability report** – Lists dependencies along with CVE details, CVSS scores, and remediation suggestions.

## How to Use OWASP Dependency-Check in a Java Spring Boot (Maven) Project ?

### **Step 1: Add Dependency-Check Plugin in Maven**

Modify our `pom.xml` to include the OWASP Dependency-Check plugin.

```xml
<plugin>
    <groupId>org.owasp</groupId>
    <artifactId>dependency-check-maven</artifactId>
    <version>8.4.0</version>  <!-- Use the latest version -->
    <executions>
        <execution>
            <goals>
                <goal>check</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```

This configuration allows Dependency-Check to scan dependencies automatically during the Maven build process.

### **Step 2: Run OWASP Dependency-Check in Maven**

Run the following command to execute the scan

```sh
mvn org.owasp:dependency-check-maven:check
```

This will analyze the project’s dependencies and generate a report in `target/dependency-check-report.html`.

### **Step 3: View the Dependency Report**

After running the scan, check the generated **HTML report** at:

```sh
target/dependency-check-report.html
```

This report includes:

* List of vulnerable dependencies
* CVE IDs (e.g., CVE-2023-1234)
* CVSS Scores (severity rating of vulnerabilities)
* Suggested remediation actions

## Understanding Dependency-Check Report

The Dependency-Check report provides the following details:

<table data-header-hidden data-full-width="true"><thead><tr><th width="225.8671875"></th><th></th></tr></thead><tbody><tr><td><strong>Column</strong></td><td><strong>Description</strong></td></tr><tr><td><strong>Dependency Name</strong></td><td>The affected library (e.g., <code>log4j-core-2.14.1.jar</code>).</td></tr><tr><td><strong>CVE ID</strong></td><td>Unique identifier for the vulnerability (e.g., <code>CVE-2021-44228</code>).</td></tr><tr><td><strong>CVSS Score</strong></td><td>Severity rating (1-10, where 10 is critical).</td></tr><tr><td><strong>Vulnerability Details</strong></td><td>Description of the security risk.</td></tr><tr><td><strong>Suggested Fix</strong></td><td>Recommended action (e.g., update to a secure version).</td></tr></tbody></table>

## Automating Dependency-Check in CI/CD Pipelines

To **fail the build** when critical vulnerabilities are found, add this configuration:

```xml
<configuration>
    <failBuildOnCVSS>7.0</failBuildOnCVSS>
</configuration>
```

* If any **vulnerability with a CVSS score ≥ 7.0** is detected, the build will fail.
* This ensures **no high-risk dependency gets deployed**.

{% hint style="info" %}
**Use Exclusions for False Positives** – Some libraries may trigger false alarms. Use -

```xml
<suppress>
    <file>dependency-check-suppress.xml</file>
</suppress>
```
{% endhint %}

## List of alternative tools for dependency security scanning

1. **OWASP Dependency-Check** (Open-source vulnerability scanner)
2. **OWASP Dependency-Track** (SBOM monitoring and vulnerability tracking)
3. **Snyk** (Developer-focused security scanning)
4. **Sonatype Nexus IQ** (Enterprise-grade dependency scanning)
5. **JFrog Xray** (Security and compliance for artifacts)
6. **GitHub Dependabot** (Automated dependency updates)
7. **Mend Renovate** (Automated dependency updates with security insights)
8. **Black Duck** (Comprehensive open-source vulnerability scanning)
9. **FOSSA** (License compliance and security scanning)
