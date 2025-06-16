# Authentication Models

## About

Authentication models define how entities verify each other's identities in a system. These models determine whether authentication is **one-way** (only the client verifies the server) or **mutual** (both parties authenticate each other). The choice of an authentication model depends on security requirements, trust levels, and the nature of communication between clients and servers.

## **Types of Authentication Models**

Authentication models are broadly classified into two main categories:

### **1. One-Way Authentication**

* In this model, only **one party (usually the client)** verifies the identity of the other party (server).
* The server presents **credentials**, such as a password, certificate, or token, to prove its authenticity.
* The client does not need to authenticate itself.
* This is commonly used in **web applications**, where clients verify the legitimacy of a server using SSL/TLS certificates (HTTPS).

**Example Use Cases:**

* Accessing websites over HTTPS (SSL/TLS)
* API calls where only the client verifies the API server

### **2. Mutual Authentication**

* In **mutual authentication**, both the **client and the server authenticate each other** before communication is established.
* This ensures that neither party is communicating with an **untrusted** or **malicious** entity.
* It typically involves **client-side certificates, cryptographic keys, or challenge-response mechanisms**.

**Example Use Cases:**

* Banking transactions where both the user and the bank verify identities
* Secure API communication between two services
* VPN authentication, where both the client and the server validate each other's credentials

## **How to Choose the Right Authentication Model?**

* If only the server's authenticity needs to be verified → Use One-Way Authentication
* If both parties must verify each other for security reasons → Use Mutual Authentication
* For highly sensitive operations (e.g., financial transactions) → Prefer Mutual Authentication with strong cryptographic methods
