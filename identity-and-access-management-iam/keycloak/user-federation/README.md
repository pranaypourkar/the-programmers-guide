# User Federation

## About

User Federation in Keycloak allows Keycloak to **connect and authenticate users stored in external identity sources** such as **LDAP** or **Active Directory** without requiring the users to be recreated or managed separately inside Keycloak.

Instead of storing user credentials and metadata internally, Keycloak federates authentication to trusted external systems. This enables centralized identity management across your organization while using Keycloak as a unified authentication and authorization platform.

## Why Use User Federation

User Federation is critical when an organization wants to **integrate existing user directories** (such as LDAP or Active Directory) into a modern identity and access management system like Keycloak **without duplicating or re-creating user accounts**. Below are the key reasons to use it:

#### 1. Reuse Existing Identity Stores

Organizations often maintain large user bases in directories like **OpenLDAP, Microsoft Active Directory, or Novell eDirectory**. User Federation allows Keycloak to **connect directly to these sources**, eliminating the need to migrate users or store duplicate credentials. This:

* Preserves existing identity records and structure
* Avoids re-onboarding users or losing password history
* Reduces risk of data inconsistency between systems

#### 2. Enable Centralized Authentication

By federating users from existing directories, Keycloak becomes a **central login point** for all applications — regardless of where the user is stored.

This simplifies authentication across:

* Internal applications
* Partner portals
* DevOps tools (Jenkins, GitLab, etc.)
* Linux servers (via PAM/SSSD + Keycloak)

Keycloak can enforce **modern protocols** (OIDC, SAML) even when identity is sourced from **legacy LDAP**.

#### 3. Reduce Administrative Overhead

Without federation, administrators would need to manually:

* Create and manage user accounts in Keycloak
* Sync changes (names, emails, roles) from HR or IT systems
* Maintain password policies in multiple places

User Federation automates this by **syncing users and their attributes**, or by reading them directly during login. This cuts down human error, duplication, and access delays.

#### 4. Align with Existing Access Controls

LDAP and Active Directory often define:

* Group memberships
* Department-based structures
* Organizational roles
* Access policies

Federation lets Keycloak **map these structures to its own group/role model**, reusing access logic instead of rebuilding it. This ensures:

* Access consistency across platforms
* Policy reuse and reduced maintenance
* Easier compliance with audit and regulatory standards

#### 5. Support Hybrid and Legacy Systems

Enterprises often run in **hybrid environments** — combining modern cloud-native apps with legacy on-prem systems. User Federation bridges these gaps by:

* Allowing SSO to modern apps using legacy identity sources
* Enabling gradual migration away from old systems
* Supporting both LDAP and external IdPs in one realm

This avoids disruptive changes to existing workflows while modernizing infrastructure.

#### 6. Just-In-Time (JIT) User Provisioning

In import mode, Keycloak can automatically create a user record the **moment they log in** for the first time. This is ideal for:

* Reducing cold-start problems
* Supporting large user bases without bulk syncs
* Provisioning users only when needed (e.g., in B2B apps)

This reduces storage bloat and sync overhead, especially when only a fraction of LDAP users actually need access to federated apps.

#### 7. Enhanced Security with Unified Access

User Federation helps improve **security posture** by:

* Centralizing login audits in Keycloak
* Enforcing strong password policies via LDAP/AD
* Applying multi-factor authentication (MFA) on top of federated users
* Enabling SSO across platforms, reducing credential sprawl

You can combine **existing directory security** with **modern Keycloak features** like risk-based access, conditional flows, and token fine-tuning.

#### 8. Simplifies Compliance and Auditing

By federating users from one or more directories:

* All user activity is tracked centrally in Keycloak logs
* Access decisions can be audited from a single system
* Compliance with standards (ISO 27001, SOC2, GDPR) becomes easier

If a user is disabled in LDAP/AD, access to federated apps is immediately revoked without extra configuration.

#### 9. Multi-Directory Support in a Single Realm

Keycloak allows configuring **multiple user federation providers** in one realm. This is useful when:

* Merging multiple business units
* Supporting multiple customer organizations (multi-tenancy)
* Handling users across regions (e.g., local AD in each country)

Keycloak can query each source sequentially or based on username patterns, enabling flexible and scalable identity federation.

#### 10. Cost-Effective Identity Management

User Federation avoids the need for:

* Costly directory migrations
* Expensive Identity-as-a-Service (IDaaS) for internal apps
* Custom identity solutions

It allows organizations to **leverage their existing investments** in LDAP/AD infrastructure while gaining modern IAM capabilities from Keycloak.

## Concepts

### Federation Providers

A **Federation Provider** is an external identity source that Keycloak uses to fetch user details and authenticate users. These providers are plugged into Keycloak to act as **data sources** for identities instead of Keycloak's built-in user store.

#### Types of Federation Providers:

* **LDAP**: Generic LDAP v3-compatible directories (OpenLDAP, 389 Directory Server, etc.)
* **Active Directory**: Microsoft's directory service; works with domain-joined infrastructure
* **Custom SPI Implementations**: Java classes implementing Keycloak's User Storage SPI to integrate with custom identity systems or databases

#### Key Points:

* We can add **multiple providers** per realm.
* Providers are **ordered** — Keycloak searches them sequentially when resolving a user.
* Each provider maintains its **own config**, sync strategy, and mappers.

### Federation Modes

Federation mode determines how Keycloak interacts with the external user directory - whether it just reads from it or also writes to it.

#### 1. **READ\_ONLY**

* Users are retrieved from the external provider but **cannot be modified** from Keycloak.
* Useful when LDAP is a sensitive source of truth (e.g., corporate HR system).
* Common in production setups for safety.

#### 2. **WRITABLE**

* Keycloak can modify users in the external provider (e.g., change passwords or attributes).
* Requires correct ACLs or admin privileges in the LDAP/AD server.
* Useful in smaller environments where Keycloak is allowed to manage the directory.

#### 3. **UNSYNCED**

* User data is loaded into Keycloak on login or import, but **no further updates or syncs** happen.
* External identity store acts as an initial bootstrap.
* Best for **one-time migrations** or detached identities.

### Sync Options

Keycloak supports **user synchronization** between external directories and its internal database. Sync is important if you want to pre-populate users and allow querying/filtering inside Keycloak even before login.

#### Sync Triggers

<table><thead><tr><th width="164.6727294921875">Type</th><th>Description</th></tr></thead><tbody><tr><td><strong>Manual Sync</strong></td><td>Admin can trigger sync on demand via the Keycloak Admin Console</td></tr><tr><td><strong>Periodic Sync</strong></td><td>Keycloak runs background sync jobs at defined intervals</td></tr><tr><td><strong>Login-Time Sync</strong></td><td>User is created/updated in Keycloak at the time of login (if import mode is enabled)</td></tr></tbody></table>

#### Sync Behaviors

* Imports user attributes and group mappings
* May create or update existing users based on configuration
* Deletes are not handled automatically — removed LDAP users stay in Keycloak unless manually purged

#### Use Case Tips

* Use **Periodic Sync** if LDAP changes frequently and you need Keycloak to reflect those changes in advance.
* Use **Manual Sync** for control during staged deployments or testing.
* Use **Login-Time Sync** to avoid importing unused users.

### User Attribute Mapping

User attribute mapping defines how **LDAP or AD attributes are translated into Keycloak user fields**.

#### How It Works

* Mappers connect specific LDAP attributes to Keycloak fields.
* For example:
  * `uid` → `username`
  * `mail` → `email`
  * `sn` → `lastName`
  * `cn` → `firstName`

#### Attribute Mapper Types

* **User Attribute Mapper**: Maps a single LDAP attribute to a Keycloak user attribute.
* **Hardcoded Attribute Mapper**: Sets a fixed value for a Keycloak attribute.
* **Username Template Mapper**: Builds usernames using LDAP values and templates.

#### Advanced Usage

* We can **create multiple mappers** to pull extra data like `employeeNumber`, `phone`, or `title`.
* These attributes can be made available in **tokens**, used in **policies**, or **displayed in admin UI**.

#### Best Practice

* Match only the **needed attributes** to avoid over-fetching data.
* Keep mappers **consistent across realms** if users are federated in multiple places.

### Group and Role Mapping

Keycloak allows LDAP/AD groups to be **mapped as Keycloak groups or roles**, enabling centralized RBAC (Role-Based Access Control) based on directory group memberships.

#### 1. **Group Mapping**

Sync LDAP groups like `cn=devs,ou=Groups,dc=corp,dc=com` into Keycloak and maintain membership information.

**How**

* Use **Group LDAP Mapper**
* Specify:
  * `Groups DN`: Base DN to search for groups
  * `Group Name LDAP Attribute`: Usually `cn`
  * `Membership Attribute`: Usually `member` or `uniqueMember`
  * `Membership Type`: Usually `DN`

**Result**

* Keycloak creates a group like `/devs`
* User `uid=john.doe` in the `member` list is automatically mapped to that group in Keycloak

#### 2. **Role Mapping**

Assign Keycloak **realm or client roles** based on LDAP user attributes or group membership.

**Methods**

* Use **Role LDAP Mapper**
* Define static or dynamic assignment based on:
  * LDAP filters
  * Hardcoded roles
  * Group membership rules

**Result**

* LDAP-defined access structures drive application-level permissions in Keycloak
* Helps implement **role-based authorization** using existing directory groups

## How It Works

When a user logs in:

1. Keycloak checks its **internal user store**.
2. If the user is not found, it queries the **User Federation provider** (like LDAP or Active Directory).
3. If the user is found in the external directory and credentials match, authentication succeeds.
4. Based on configuration, Keycloak:
   * Either imports user into its internal store (import mode), or
   * Keeps referencing LDAP on every login (read-only mode)

User attributes, group membership, and credentials are mapped using **mappers**.

## How Keycloak Communicates with LDAP or AD

Keycloak does not replicate the full LDAP tree but uses:

* **Base DN** (like `ou=People,dc=corp,dc=acme,dc=com`) to **search users**
* A **Bind DN** account to **authenticate and read data**
* A **search filter** like `(uid={0})` to match username inputs to LDAP entries
* **Mappers** to transform LDAP attributes to Keycloak attributes (e.g., `mail` → `email`, `cn` → `first name`)

Keycloak uses LDAP queries for:

* Login matching
* Credential validation (bind)
* User listing and sync
* Group membership lookup (via `memberOf`, `member`, etc.)

