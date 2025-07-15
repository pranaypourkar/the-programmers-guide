# Integrating OpenLDAP

## Objective

Connect a local OpenLDAP server (running via Docker) to Keycloak, so that users and groups can be read, synced, and authenticated via Keycloak.

## Prerequisites

Make sure the following services are running:

| Service          | Tool                    | Example URL              |
| ---------------- | ----------------------- | ------------------------ |
| **LDAP Server**  | `osixia/openldap` image | `ldap://localhost:389`   |
| **phpLDAPadmin** | Admin GUI               | `https://localhost:6443` |
| **Keycloak**     | Identity provider       | `http://localhost:8180`  |

We should already have:

* A working `docker-compose.yml`
* Seeded users and groups via `seed-data.ldif`
* Admin DN and password (e.g., `cn=admin,dc=corp,dc=acme,dc=com`)

Refer to the following pages for more details on the setup

{% content-ref url="../../ldap/local-openldap-setup.md" %}
[local-openldap-setup.md](../../ldap/local-openldap-setup.md)
{% endcontent-ref %}

## Apply LDAP Config

### Log into Keycloak Admin Console

1. Open `http://localhost:8180`
2. Log in as the Keycloak admin user (e.g., `admin / admin`)
3. Select the target **Realm** (e.g., `master`, or create a new one say `employee`)

### Add LDAP User Federation Provider

1. Go to **User Federation** (left-hand menu)
2. Click **Add provider → ldap**

### Set Configurations

<figure><img src="../../../.gitbook/assets/keycloak-ldap-provider-config-1.png" alt=""><figcaption></figcaption></figure>

<figure><img src="../../../.gitbook/assets/keycloak-ldap-provider-config-2.png" alt=""><figcaption></figcaption></figure>

<figure><img src="../../../.gitbook/assets/keycloak-ldap-provider-config-3.png" alt=""><figcaption></figcaption></figure>

<figure><img src="../../../.gitbook/assets/keycloak-ldap-provider-config-4.png" alt=""><figcaption></figcaption></figure>

<figure><img src="../../../.gitbook/assets/keycloak-ldap-provider-config-5.png" alt=""><figcaption></figcaption></figure>

### Test the Connection

Use the **"Test connection"** and **"Test authentication"** buttons at the bottom of the provider form:

* **Test connection**: Validates LDAP connectivity
* **Test authentication**: Confirms bind credentials work

If any test fails, double-check:

* LDAP port (`389` open?)
* Bind DN/password
* Network access between Keycloak container and LDAP container

## Sync and Verify Users

Click **"Synchronize all users"** from the LDAP provider settings. This will import all matching users under `Users DN` into Keycloak.

<figure><img src="../../../.gitbook/assets/keycloak-ldap-provider-user-sync-1.png" alt=""><figcaption></figcaption></figure>

Sample users available in LDAP (Seeds file)

<figure><img src="../../../.gitbook/assets/keycloak-ldap-provider-user-sync-2.png" alt="" width="375"><figcaption></figcaption></figure>

<figure><img src="../../../.gitbook/assets/keycloak-ldap-provider-user-sync-3.png" alt=""><figcaption></figcaption></figure>

<figure><img src="../../../.gitbook/assets/keycloak-ldap-provider-user-sync-4.png" alt=""><figcaption></figcaption></figure>

<figure><img src="../../../.gitbook/assets/keycloak-ldap-provider-user-sync-5.png" alt=""><figcaption></figcaption></figure>

<figure><img src="../../../.gitbook/assets/keycloak-ldap-provider-user-sync-6.png" alt=""><figcaption></figcaption></figure>

<figure><img src="../../../.gitbook/assets/keycloak-ldap-provider-user-sync-7.png" alt=""><figcaption></figcaption></figure>

<figure><img src="../../../.gitbook/assets/keycloak-ldap-provider-user-sync-8.png" alt=""><figcaption></figcaption></figure>

<figure><img src="../../../.gitbook/assets/keycloak-ldap-provider-user-sync-9.png" alt=""><figcaption></figcaption></figure>

## Configure LDAP Mappers

By default, Keycloak adds a few LDAP mappers. We can verify and adjust them

| **Mapper Type** | Example Mapping |
| --------------- | --------------- |
| Username        | `uid`           |
| Email           | `mail`          |
| First Name      | `givenName`     |
| Last Name       | `sn`            |
| Full Name       | `cn`            |

> We can also add custom mappers for attributes like `employeeNumber`, `title`, `mobile`.

<figure><img src="../../../.gitbook/assets/keycloak-ldap-provider-mapper-1.png" alt=""><figcaption></figcaption></figure>

<figure><img src="../../../.gitbook/assets/keycloak-ldap-provider-mapper-2.png" alt=""><figcaption></figcaption></figure>

## Group Mapping

To map LDAP groups:

1. Click **"Add mapper"** on the LDAP provider
2. Choose **"group-ldap-mapper"** as type

### Add configurations

<figure><img src="../../../.gitbook/assets/keycloak-ldap-provider-sync-groups-1.png" alt=""><figcaption></figcaption></figure>

<figure><img src="../../../.gitbook/assets/keycloak-ldap-provider-sync-groups-2.png" alt=""><figcaption></figcaption></figure>

### Sync Groups

Click on "Sync LDAP Groups with Keycloak" button to sync

<figure><img src="../../../.gitbook/assets/keycloak-ldap-provider-sync-groups.png" alt=""><figcaption></figcaption></figure>

### Verify Sync Groups in keycloak

<figure><img src="../../../.gitbook/assets/keycloak-ldap-provider-sync-groups-3.png" alt=""><figcaption></figcaption></figure>

LDAP Seed File group declaration

<figure><img src="../../../.gitbook/assets/keycloak-ldap-provider-sync-groups-4.png" alt="" width="563"><figcaption></figcaption></figure>

<figure><img src="../../../.gitbook/assets/keycloak-ldap-provider-sync-groups-5.png" alt=""><figcaption></figcaption></figure>

<figure><img src="../../../.gitbook/assets/keycloak-ldap-provider-sync-groups-6.png" alt=""><figcaption></figcaption></figure>

