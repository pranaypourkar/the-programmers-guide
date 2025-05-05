# Third-party Packages

## About

**Third-party Packages** refer to libraries and frameworks that are **not part of the standard Java distribution** nor part of the Jakarta EE specification. These libraries are provided by **external vendors** or **open-source communities** to extend Java’s functionality or to simplify specific tasks in software development.

* These packages can range from widely-used frameworks like **Hibernate** (for ORM) to utilities for **JSON processing**, **logging**, **message queuing**, and more.
* They are **independently developed** and are typically included in your project as external dependencies.

{% hint style="info" %}
**Key Points:**

* Third-party packages are provided by **external libraries** and are usually included using dependency management tools like **Maven** or **Gradle**.
* These packages offer extended features or simplify common tasks, often providing solutions not available in the core JDK or Jakarta EE.
* They are maintained by various **open-source projects** or **commercial vendors**.
{% endhint %}

## **Examples**

* **`org.hibernate.validator`** – Provides the implementation for **Bean Validation** (`jakarta.validation`), often used with frameworks like Spring.
* **`com.fasterxml.jackson`** – Provides libraries for **JSON processing** (e.g., Jackson for serializing/deserializing Java objects).
* **`org.apache.commons`** – Offers a wide variety of utilities for **file handling**, **collections**, **IO**, **lang**, etc.
* **`org.springframework`** – Provides a comprehensive framework for building enterprise applications, including **dependency injection**, **AOP**, **REST APIs**, etc.

These packages provide features that **extend Java's capabilities** and are typically integrated into applications for specific needs such as web development, data binding, or logging. Most of these are available via **open-source communities**, and you can freely include them in your project as long as you comply with the licensing agreements.
