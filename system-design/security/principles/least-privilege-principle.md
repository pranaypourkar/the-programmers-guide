# Least Privilege Principle

## About

The **Principle of Least Privilege (PoLP)** is a fundamental security concept that dictates that users, applications, and systems should be granted the **minimum level of access or permissions necessary** to perform their tasks—no more, no less. This principle reduces the risk of unauthorized access, data breaches, and insider threats.

## **Why Least Privilege Is Important ?**

1. **Reduces Attack Surface** – Limits the number of users and systems with high-level access, making attacks harder to execute.
2. **Prevents Accidental Data Corruption** – Users with limited access cannot mistakenly modify critical files or configurations.
3. **Mitigates Insider Threats** – Employees or compromised accounts cannot access or misuse sensitive data if they don’t have unnecessary privileges.
4. **Limits Malware Spread** – If an account with limited permissions is compromised, the attack remains restricted rather than spreading system-wide.
5. **Enhances Compliance** – Many regulations (e.g., GDPR, HIPAA, PCI-DSS) require strict access controls based on least privilege.

## **How Least Privilege Works ?**

### **1. User Access Control**

* Users should only have access to the files, systems, or applications necessary for their role.
* Example: A **marketing team member** should not have database administrator privileges.

### **2. System & Application Access**

* Applications should be granted only the permissions they require.
* Example: A **web server** should not have access to **financial records** unless explicitly needed.

### **3. Network Access Restrictions**

* Networks should be segmented, and systems should not have unrestricted access.
* Example: A **developer’s machine** should not have direct access to the **production environment**.

### **4. Just-in-Time (JIT) Privileges**

* Temporary elevation of privileges when needed, rather than permanent high-level access.
* Example: **Developers** needing **admin rights** to deploy code can request access that expires after a short period.

### **5. Role-Based Access Control (RBAC)**

* Permissions are assigned based on roles rather than individuals.
* Example: A **customer support agent** gets "view-only" access to customer accounts but cannot modify data.

### **6. Principle of Separation of Duties (SoD)**

* Dividing critical tasks among multiple users to prevent fraud and errors.
* Example: One person **initiates** a financial transaction, and another person **approves** it.

## **Threats Prevented by Least Privilege**

<table data-header-hidden data-full-width="true"><thead><tr><th width="207"></th><th></th></tr></thead><tbody><tr><td><strong>Threat</strong></td><td><strong>How PoLP Helps</strong></td></tr><tr><td><strong>Privilege Escalation</strong></td><td>Attackers cannot escalate privileges if users already have minimal access.</td></tr><tr><td><strong>Insider Threats</strong></td><td>Employees with limited access cannot steal or leak sensitive data.</td></tr><tr><td><strong>Malware Attacks</strong></td><td>Malware running under restricted privileges cannot make system-wide changes.</td></tr><tr><td><strong>Data Breaches</strong></td><td>Unauthorized users cannot access sensitive data if they lack permissions.</td></tr></tbody></table>

## **Implementing Least Privilege in an Organization**

* **Conduct Access Reviews:** Regularly audit user accounts and remove unnecessary permissions.
* **Enforce Role-Based Access Control (RBAC):** Define roles with specific permissions instead of assigning broad access.
* **Implement Multi-Factor Authentication (MFA):** Ensures that even if a low-privilege account is compromised, an attacker cannot easily gain access.
* **Use Just-in-Time (JIT) Privileges:** Provide temporary access for critical tasks instead of permanent admin rights.
* **Enforce Network Segmentation:** Restrict access between internal systems based on necessity.
* **Monitor & Log Access:** Track user activities to detect any privilege misuse.

## **Examples of Least Privilege Principle**

<table data-header-hidden data-full-width="true"><thead><tr><th width="226"></th><th></th></tr></thead><tbody><tr><td><strong>Scenario</strong></td><td><strong>Least Privilege Application</strong></td></tr><tr><td><strong>Windows User Accounts</strong></td><td>Standard users should not have administrator privileges by default.</td></tr><tr><td><strong>Cloud Access</strong></td><td>AWS IAM roles grant <strong>specific permissions</strong> rather than full admin access.</td></tr><tr><td><strong>Database Access</strong></td><td>Employees can <strong>query</strong> customer data but cannot modify or delete records.</td></tr><tr><td><strong>Software Installation</strong></td><td>Employees cannot install unauthorized applications to prevent malware infections.</td></tr></tbody></table>

