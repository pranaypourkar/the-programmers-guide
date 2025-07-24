# JSR 303, 349, 380 (Bean Validation)

## About

**Bean Validation** is a Java specification that defines a **standard way to declare and validate constraints** on object fields, method parameters, and return values using annotations. It plays a key role in **Java SE and EE** applications by helping enforce data integrity and input validation in a declarative and reusable way.

Bean Validation is defined through a series of JSRs:

* **JSR 303 – Bean Validation 1.0**
* **JSR 349 – Bean Validation 1.1**
* **JSR 380 – Bean Validation 2.0**

## **Why Use Bean Validation?**

* **Declarative Constraints**: Use annotations like `@NotNull`, `@Size`, `@Email` to enforce validation rules.
* **Reusability**: Write constraint logic once and apply it consistently across layers.
* **Integration**: Automatically integrated with Java frameworks like:
  * **Spring Boot**
  * **Jakarta EE (formerly Java EE)** (e.g., JAX-RS, JPA, CDI)
  * **Hibernate (via Hibernate Validator)**
* **Interoperability**: Works uniformly across tools and platforms due to standardization.

## **JSR Evolution Timeline**

### **JSR 303: Bean Validation 1.0**

* **Released**: 2009
* **Purpose**: Introduced the foundational API for validation using annotations.
* **Main Features**:
  * Field-level constraint annotations
  * Custom constraint support
  * Integration with JPA and POJOs
*   **Examples**:

    ```java
    public class User {
        @NotNull
        @Size(min = 5, max = 15)
        private String username;
    }
    ```

### **JSR 349: Bean Validation 1.1**

* **Released**: 2013
* **Enhancements**:
  * **Method and constructor validation**
  * **Cross-parameter constraint validation**
  * Support for dependency injection containers (CDI, Spring)
*   **Example**:

    ```java
    public class UserService {
        public void registerUser(@NotNull User user) {
            // Automatically validated
        }
    }
    ```

### **JSR 380: Bean Validation 2.0**

* **Released**: 2017
* **Target Platform**: Java SE 8+
* **Major Improvements**:
  * Support for Java 8 features:
    * `Optional`, `java.time` types
    * **Repeatable annotations**
    * **Type use annotations** (container element validation)
  * New built-in constraints:
    * `@NotEmpty`, `@NotBlank`, `@Positive`, `@Negative`, etc.
*   **Example (with container validation)**:

    ```java
    public class ShoppingCart {
        @NotEmpty
        private List<@NotNull @Size(min = 2) String> items;
    }
    ```

## **Summary Table of Bean Validation JSRs**

<table><thead><tr><th width="79.453125">JSR</th><th width="95.875">Version</th><th width="105.07421875">Released</th><th>Key Enhancements</th></tr></thead><tbody><tr><td>303</td><td>1.0</td><td>2009</td><td>Basic annotation validation on fields</td></tr><tr><td>349</td><td>1.1</td><td>2013</td><td>Method/constructor validation, CDI</td></tr><tr><td>380</td><td>2.0</td><td>2017</td><td>Java 8 support, container validation, more annotations</td></tr></tbody></table>
