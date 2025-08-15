# Secure Coding Practices

## About

Secure Coding Practices are **a set of guidelines, patterns, and guardrails** that developers follow to write code that is **resilient to vulnerabilities** and **maintains security** even when under attack. They sit at the **implementation phase** of SSDLC but influence both **design decisions** and **code review criteria**.

The ultimate aim is to ensure that code **meets functional needs without creating exploitable weaknesses**.

## **Foundational Principles of Secure Coding**

<table data-full-width="true"><thead><tr><th width="155.77734375">Principle</th><th>Description</th><th>Example in Practice</th></tr></thead><tbody><tr><td><strong>Principle of Least Privilege</strong></td><td>Code should only have the minimum access rights it needs.</td><td>API key with read-only access to a reporting DB, not full CRUD.</td></tr><tr><td><strong>Defense in Depth</strong></td><td>Implement multiple layers of security so that a failure in one doesn’t cause a total breach.</td><td>Combining input validation, authentication, rate limiting, and logging.</td></tr><tr><td><strong>Fail-Safe Defaults</strong></td><td>Deny by default; explicitly allow only what is necessary.</td><td>Default firewall rules block all ports except explicitly opened ones.</td></tr><tr><td><strong>Secure by Design</strong></td><td>Anticipate misuse cases and build preventive mechanisms before coding.</td><td>Implementing account lockouts for repeated failed logins.</td></tr><tr><td><strong>Keep It Simple</strong></td><td>Avoid unnecessary complexity that increases attack surface.</td><td>Using well-known libraries for encryption instead of custom crypto.</td></tr></tbody></table>
