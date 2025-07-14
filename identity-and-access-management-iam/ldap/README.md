# LDAP

## About

**LDAP** stands for **Lightweight Directory Access Protocol**. It is an open, vendor-neutral, industry-standard application protocol for accessing and maintaining distributed directory information services over an IP network. It was initially developed as a lightweight alternative to DAP (Directory Access Protocol, part of X.500) and has since become the **de facto standard** for centralized authentication and directory services.

A directory in LDAP is a **read-optimized**, hierarchical database used primarily for **lookup operations**, not for transactional data. It plays a critical role in enterprise **identity and access management (IAM)**.

LDAP is widely used for authentication and authorization in enterprise environments, and acts as a central repository for user, group, and organizational data.

## Evolution and Standards

* Originally specified in **RFC 1487**, later formalized in **RFC 4510** and related specifications.
* LDAP is based on the **X.500** standard but uses **TCP/IP** and a simplified data encoding mechanism (**BER – Basic Encoding Rules** over ASN.1).
* The most commonly used version is **LDAPv3**.

## Why Use LDAP

#### Centralized Identity Management

In most organizations, user and access data is scattered across multiple systems (databases, applications, servers). LDAP provides a **central directory** to consolidate this identity data, making it the **single source of truth**.

#### Read-Optimized Hierarchical Data Access

LDAP is optimized for **high-volume, low-latency read operations**, making it ideal for verifying credentials, retrieving user profiles, or resolving group memberships across thousands or millions of users.

#### Platform and Application Agnostic

LDAP is an **open standard** and supported by a wide range of operating systems (Linux, Windows, macOS) and applications (Keycloak, GitLab, Jenkins, etc.), making it a **vendor-neutral solution**.

#### Scalable and Lightweight

Its **hierarchical structure** (DIT – Directory Information Tree) and efficient protocol make LDAP suitable for both small office setups and large enterprise-grade infrastructures. Most deployments use **replication** to support high availability and geographic distribution.

#### Authentication Backbone

LDAP is commonly used as an **authentication backend** for:

* Single Sign-On (SSO) solutions
* VPN gateways
* Web applications
* Operating systems

#### Group-based Authorization

LDAP allows grouping of users for **Role-Based Access Control (RBAC)**. Applications can query LDAP to determine access rights based on group membership (`memberOf`, `groupOfNames`, etc.).

#### Extensibility

We can extend the schema to support custom attributes, such as `employeeID`, `departmentCode`, `managerID`, etc., adapting the directory to business-specific needs.

## LDAP Server (Directory Server)

An LDAP server is a **specialized database engine** built to store and retrieve identity and directory information efficiently. It listens on network ports (typically 389 for LDAP and 636 for LDAPS) and exposes APIs defined by the LDAP protocol (RFC 4511 and related).

#### Core Responsibilities

* **Store directory entries** in a structured (hierarchical) format.
* **Authenticate and authorize** users based on credentials and access rules.
* **Support operations** such as search, add, modify, and delete.
* **Enforce schema** rules for object classes and attributes.
* **Enable replication** between master/slave or multi-master nodes.
* **Expose monitoring** and diagnostic endpoints for performance and status.

#### Common LDAP Servers

* **OpenLDAP**: The most popular open-source LDAP server, used extensively in Unix-based environments.
* **Microsoft Active Directory**: A directory service that implements LDAP + Kerberos + DNS and is tightly integrated with Windows-based domains.
* **Apache Directory Server**: A Java-based extensible LDAP server.
* **389 Directory Server**: A scalable and secure LDAP server developed by Red Hat, suitable for enterprise-level IAM.

#### Data Storage

LDAP servers typically store data in **BDB** (Berkeley DB), **MDB** (Memory-Mapped DB, used in OpenLDAP), or custom flat file structures, optimized for directory reads and fast lookups.

#### Access Controls

Access to directory data is controlled using **Access Control Lists (ACLs)** or **Access Control Instructions (ACIs)**, allowing fine-grained permissions based on DN, operation type, or IP.

## LDAP Clients

LDAP clients are programs or libraries that connect to an LDAP server to perform operations such as authentication, user lookup, group listing, or directory traversal.

#### Types of Clients

**Command-Line Clients**

* `ldapsearch` – Search for entries using filters.
* `ldapadd` – Add entries from LDIF files.
* `ldapmodify` – Modify existing entries.
* `ldapdelete` – Remove entries.

These tools are especially useful for:

* Manual testing
* Automation scripts
* DevOps and system administration

**GUI-Based Clients**

* **phpLDAPadmin** – Web-based UI for browsing and modifying LDAP entries.
* **Apache Directory Studio** – Desktop GUI client for LDAP operations and schema editing.
* **JXplorer** – Cross-platform LDAP browser and editor.

**Application-Level Clients**

Applications that consume LDAP as an identity source:

* Keycloak, Gluu, ForgeRock
* Jenkins, GitLab, Jira
* Email servers (Postfix, Dovecot)
* Linux PAM/SSSD modules
* Web applications using Spring Security or Node.js Passport LDAP plugins

**API Libraries**

LDAP client libraries exist for multiple programming languages:

* Java (JNDI, UnboundID SDK)
* Python (`ldap3`, `python-ldap`)
* Node.js (`ldapjs`)
* Go (`gopkg.in/ldap.v3`)
* C#/.NET (`System.DirectoryServices`)

#### Authentication Models

LDAP clients typically perform:

* **Simple Bind**: DN + password
* **SASL Bind**: Secure mechanism like DIGEST-MD5, GSSAPI
* **Anonymous**: No credentials; usually read-only and limited

#### Use Cases

* Search user information (name, email, title)
* Resolve group membership
* Authenticate login credentials
* Add/modify/remove directory entries
* Pull user metadata into local applications

## LDAP Integration

LDAP is rarely used in isolation. It is typically **integrated into wider IAM and infrastructure ecosystems**, enabling centralized authentication and access control.

#### 1. Keycloak User Federation

* LDAP acts as an external identity provider.
* Keycloak imports users/groups and keeps them in sync.
* LDAP attribute mapping allows seamless identity translation.
* Keycloak handles SSO while LDAP stores credentials and structure.

#### 2. Linux Authentication (PAM/SSSD)

* Linux systems can authenticate against LDAP using PAM (Pluggable Authentication Modules) and SSSD (System Security Services Daemon).
* This allows centralized login management across multiple servers.
* Home directory creation, group assignment, and sudoers integration are also possible.

#### 3. CI/CD Tools

* Jenkins, GitLab, and SonarQube can connect to LDAP for admin logins and access control.
* Group-based permissions can be mapped from LDAP.

#### 4. Email and Messaging Servers

* Postfix + Dovecot can use LDAP to fetch user mailboxes and routing information.
* LDAP-based address books (e.g., for Thunderbird or Outlook).

#### 5. Web Application Authentication

* Applications using Spring Security or Flask can authenticate users via LDAP.
* LDAP acts as a credential provider with group-based authorization policies.

#### 6. Cloud and Hybrid IAM

* LDAP is often used as a **bridge between legacy and modern identity systems**.
* Organizations might synchronize on-prem LDAP with cloud IdPs like Okta, Azure AD, or Google Workspace via connectors.

#### 7. Custom Software

* Internal business applications can query LDAP directly to retrieve user profiles, roles, and group affiliations.
* Some systems implement **just-in-time (JIT)** user provisioning on first LDAP login.
