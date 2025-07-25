# Cyber Attacks

## About

Cyber attacks are malicious attempts by individuals or groups to compromise, damage, or gain unauthorized access to computer systems, networks, or devices. These attacks can target a wide range of entities, including individuals, businesses, governments, and critical infrastructure, and can result in data breaches, financial loss, and disruption of services.

## Types of Cyber Attacks

### 1. Phishing

#### **What it is:**&#x20;

Phishing is a type of cyber attack where attackers send fraudulent messages, often emails, that appear to come from a legitimate source. The goal is to trick recipients into revealing sensitive information such as passwords, credit card numbers, or personal details.

#### **Types of Phishing:**

**1. Email Phishing:** Attackers send fraudulent emails that appear to come from reputable sources, tricking recipients into revealing sensitive information.

**2. Spear Phishing:** A targeted form of phishing where attackers tailor their messages to a specific individual or organization.

**3. Whaling:** A type of spear phishing that targets high-profile individuals like executives or important decision-makers.

**4. Vishing:** Phishing conducted via phone calls, where attackers impersonate legitimate entities to extract sensitive information.

**5. Smishing:** Phishing attacks delivered through SMS messages.

**6. Clone Phishing:** Attackers create a nearly identical copy of a legitimate email, replacing links or attachments with malicious ones.

**7. Pharming:** Redirecting users from legitimate websites to fraudulent ones without their knowledge, usually by altering DNS settings.

**8. Evil Twin:** Attackers create a fake Wi-Fi network that appears legitimate, tricking users into connecting and capturing their data.

#### **Impact:**&#x20;

Theft of sensitive information, Financial loss, Compromise of user accounts, Spread of malware

#### **Mitigation:**

* Use email filtering to detect and block phishing attempts
* Educate users about identifying phishing emails (e.g., checking email addresses, looking for suspicious links)
* Implement multi-factor authentication (MFA)
* Regularly update and patch systems

### 2. Man-in-the-Middle (MitM) Attack

#### **What it is:**&#x20;

A Man-in-the-Middle attack occurs when an attacker intercepts and potentially alters the communication between two parties without their knowledge.

#### **Types of** MitM Attack**:**

**1. HTTPS Spoofing:** Attackers create fake HTTPS websites to intercept secure communications.

**2. Wi-Fi Eavesdropping:** Attackers intercept data transmitted over unsecured Wi-Fi networks.

**3. Session Hijacking:** Attackers take over a user’s session by stealing session cookies.

**4. SSL Stripping:** Attackers downgrade a secure HTTPS connection to an unencrypted HTTP connection to intercept data.

#### **Impact:**&#x20;

Eavesdropping on private communications, Data theft, Manipulation of transmitted data, Impersonation of legitimate parties

#### **Mitigation:**

* Use strong encryption protocols (e.g., TLS/SSL) for communications
* Avoid using public Wi-Fi for sensitive transactions
* Implement secure VPNs for remote access
* Educate users on the risks of Man-in-the-Middle attacks

### 3. SQL Injection

#### **What it is:** &#x20;

SQL injection is an attack that involves inserting malicious SQL queries into input fields of a web application. This can manipulate the database, leading to unauthorized data access or modification.

#### Types of SQL Injection Attacks

**1. Error-Based SQL Injection:** Attackers exploit error messages to gain information about the database.

**2. Union-Based SQL Injection:** Attackers use the UNION SQL operator to combine results from multiple SELECT statements, extracting data from the database.

**3. Blind SQL Injection:** Attackers do not receive direct feedback from the database but infer information based on the application's behavior.

**4. Time-Based Blind SQL Injection:** Attackers determine information from the database based on time delays in the responses.

#### **Impact:**&#x20;

Data breaches, Unauthorized access to sensitive information, Data manipulation or deletion, Compromise of entire databases

#### **Mitigation:**

* Use parameterized queries and prepared statements
* Validate and sanitize user inputs
* Implement web application firewalls (WAFs)
* Regularly update and patch database systems

### 4. Distributed Denial of Service (DDoS)

#### What it is:&#x20;

A DDoS attack aims to overwhelm a target server, service, or network with a flood of internet traffic, causing it to become unavailable to users.

#### Types of DDoS Attacks:

**1. Volume-Based Attacks:** Overwhelm the target with massive amounts of traffic (e.g., UDP floods, ICMP floods).

**2. Protocol Attacks:** Exploit weaknesses in the target’s network protocols (e.g., SYN floods, ping of death).

**3. Application Layer Attacks:** Target the application layer of the OSI model, often involving fewer requests to disrupt services (e.g., HTTP floods).

#### **Impact:**&#x20;

Service outages, Revenue loss due to downtime, Degradation of performance, Increased operational costs

#### **Mitigation:**

* Use DDoS protection services and solutions
* Implement rate limiting and traffic filtering
* Maintain a scalable infrastructure
* Develop and test an incident response plan

### 5. Cross-Site Scripting (XSS)

#### What it is:&#x20;

XSS attacks involve injecting malicious scripts into web pages viewed by other users. These scripts can execute in the user's browser, potentially stealing information or performing actions on their behalf.

#### Types of Cross-Site Scripting (XSS) Attacks:

**1. Stored XSS:** Malicious scripts are permanently stored on a target server and executed when users access the server.

**2. Reflected XSS:** Malicious scripts are reflected off a web application onto the user’s browser.

**3. DOM-Based XSS:** Malicious scripts manipulate the Document Object Model (DOM) in the user’s browser.

#### Impact:&#x20;

Theft of cookies and session tokens, Unauthorized actions on behalf of the user, Defacement of websites, Spread of malware

#### Mitigation:

* Sanitize and validate user inputs
* Use content security policies (CSP)
* Encode output data
* Regularly scan and test web applications for vulnerabilities

### 6. Password Attacks

#### **What it is:**&#x20;

Password attacks involve attempting to gain access to a system by cracking or guessing passwords. Common methods include brute force attacks, dictionary attacks, and credential stuffing.

#### Types of Password Attacks

**1. Brute Force Attack:** Attackers try all possible password combinations until they find the correct one.

**2. Dictionary Attack:** Attackers use a precompiled list of common passwords to gain access.

**3. Credential Stuffing:** Attackers use stolen credentials from one breach to attempt logins on other services.

**4. Keylogger Attack:** Malicious software records keystrokes to capture passwords.

#### **Impact:**&#x20;

Unauthorized access to accounts, Data breaches, Identity theft, Compromise of multiple systems if passwords are reused

#### **Mitigation:**

* Implement strong password policies
* Use multi-factor authentication (MFA)
* Detect and respond to unusual login attempts
* Encourage the use of password managers

### 7. AI-Powered Attacks

#### **What it is:**&#x20;

AI-powered attacks leverage artificial intelligence to enhance traditional attack methods. Examples include sophisticated phishing campaigns, automated vulnerability discovery, and AI-driven malware.

#### Types of AI-Powered Attacks:

**1. Automated Phishing:** AI generates and sends personalized phishing emails at scale.

**2. Malware Evasion:** AI enables malware to adapt and evade detection by security software.

**3. Deepfake Attacks:** AI generates realistic fake audio or video to impersonate individuals.

#### **Impact:**&#x20;

Increased effectiveness and scale of attacks, Harder to detect and defend against, Accelerated pace of attacks, Advanced persistent threats

#### **Mitigation:**

* Use AI and machine learning for defense (e.g., anomaly detection)
* Regularly update threat intelligence
* Educate and train security personnel on emerging AI threats
* Invest in advanced cybersecurity tools

### 8. Drive-By Attack

#### **What it is:**&#x20;

A drive-by attack occurs when a user visits a compromised website that automatically and silently downloads malware onto their device.

#### Types of Drive-By Attack:

**1. Exploit Kits:** Pre-packaged tools that exploit vulnerabilities in software to deliver malware.

**2. Malvertising:** Malicious advertisements that deliver malware when clicked.

#### **Impact:**&#x20;

Malware infection, Data theft, System compromise, Spread of further attacks

#### **Mitigation:**

* Keep web browsers and plugins up to date
* Use reputable antivirus and antimalware solutions
* Implement web filtering solutions
* Educate users about the risks of visiting unknown or suspicious websites

### 9. Ransomware Attack

#### **What it is:**&#x20;

Ransomware is a type of malware that encrypts a victim's data and demands payment (usually in cryptocurrency) to restore access to the data.

#### Types of Ransomware Attack:

**1. Crypto Ransomware:** Encrypts the victim's files and demands ransom for the decryption key.

**2. Locker Ransomware:** Locks the victim out of their device or system and demands ransom to unlock it.

**3. Scareware:** Tricks victims into paying ransom by displaying fake threats and warnings.

#### **Impact:**&#x20;

Data loss, Financial loss from ransom payments, Operational disruptions, Potential legal and reputational damage

#### **Mitigation:**

* Regularly back up data and verify restore processes
* Keep systems and software updated
* Use robust endpoint protection solutions
* Educate users on recognizing phishing attempts and malicious links

### 10. Eavesdropping Attack

#### **What it is:**&#x20;

Eavesdropping attacks involve intercepting and listening to private communications, typically over networks. This can include sniffing unencrypted traffic or exploiting weak encryption.

#### Types of Eavesdropping Attack:

**1. Passive Eavesdropping:** Attackers listen to network communications without altering them.

**2. Active Eavesdropping:** Attackers intercept and alter communications, sometimes impersonating one of the communicating parties

#### **Impact:**&#x20;

Exposure of sensitive information, Breach of privacy, Compromise of credentials and accounts, Unauthorized access to confidential data

#### **Mitigation:**

* Use strong encryption for communications (e.g., TLS/SSL, VPNs)
* Avoid using unsecured networks for sensitive communications
* Implement network segmentation and access controls
* Monitor network traffic for unusual activity







