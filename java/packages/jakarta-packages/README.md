# Jakarta Packages

## About

**Jakarta Packages** refer to **standard APIs** that come from the **Jakarta EE** (formerly Java EE) specification. These are **not part of core Java** but are part of the **official set of enterprise-grade specifications** for building Java-based applications.

* **Jakarta EE** is managed by the **Eclipse Foundation**, and it encompasses a variety of libraries for building **web applications**, **microservices**, **RESTful services**, **messaging**, **data access**, and more.
* These packages include specifications that provide a **consistent, standardized API** for developers across different Jakarta EE-compliant implementations (such as **Payara**, **WildFly**, **GlassFish**, etc.).

{% hint style="info" %}
**Key Points:**

* Jakarta Packages are **not part of the standard JDK** but are widely used in enterprise-level applications.
* Jakarta EE is the **successor** of Java EE, now under the **Eclipse Foundation**.
* These libraries are generally **included with Jakarta EE runtime** or can be added as dependencies in your project.
{% endhint %}

## **Examples**

* **`jakarta.persistence`** – For **Object-Relational Mapping (ORM)** with JPA.
* **`jakarta.servlet`** – For building **web applications** using Servlets.
* **`jakarta.validation`** – For **Bean Validation**, allowing the validation of object fields using annotations like `@NotNull`, `@Size`, etc.
* **`jakarta.ws.rs`** – For building **RESTful web services**.

These packages are designed to ensure **cross-platform compatibility** and **interoperability** across all Jakarta EE compliant environments. If your application is built using Jakarta EE, these APIs are typically used to handle key functionalities like validation, persistence, and web services.
