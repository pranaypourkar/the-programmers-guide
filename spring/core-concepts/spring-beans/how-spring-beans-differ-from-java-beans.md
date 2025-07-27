# How Spring Beans Differ from Java Beans ?

## About

The term **“bean”** has been used in multiple contexts in Java and enterprise development. The most common are:

* **JavaBeans** – Defined by the Java language specification.
* **Enterprise JavaBeans (EJBs)** – From Java EE / Jakarta EE.
* **Spring Beans** – Managed by the Spring Framework.

Although they share the term "bean", their purpose, behavior, and management model are very different. This topic focuses on understanding **Spring Beans** and how they differ from **JavaBeans** and **other bean types**.

{% hint style="success" %}
The term "bean" is generic in Java, often referring to any reusable component. However, **JavaBeans are largely structural**, whereas **Spring Beans are functional and infrastructure-bound**. This distinction is crucial, especially when transitioning from plain Java applications to Spring-based enterprise applications.
{% endhint %}

## JavaBean

A **JavaBean** is a simple Java class that follows a specific set of conventions defined by the JavaBeans specification. These beans are primarily used to encapsulate data and are commonly used in frameworks like JSP, JSF, or when binding data in UI components.

**Key Characteristics**

* Must have a public no-argument constructor
* Properties should be private with public getters and setters
* Must be serializable (optionally, by implementing `Serializable`)
* Primarily used for data transfer or UI-bound components

**Use Case:** Storing and transferring structured data, like a `User`, `Product`, or `Order`.

**Example**

```java
public class Person {
    private String name;
    private int age;

    public Person() {}

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }
}
```

## Spring Bean

A **Spring Bean** is any Java object that is managed by the **Spring IoC (Inversion of Control) container**. These are not just data containers — they are often service-layer or business-layer components that Spring instantiates, configures, wires, and manages through dependency injection.

**Key Characteristics**

* Defined by annotation (`@Component`, `@Service`, `@Repository`, etc.) or XML configuration
* Managed lifecycle (created, injected, destroyed by Spring)
* Can be singleton, prototype, request, or session-scoped
* Can depend on other beans, configured via dependency injection
* Part of application logic, not just data holders

**Use Case:** Service classes, DAOs, configuration classes, and any component involved in business logic or infrastructure management.

**Example**

```java
@Component
public class EmailService {
    public void send(String to, String msg) {
        // logic to send email
    }
}
```

Injected somewhere like:

```java
@Autowired
private EmailService emailService;
```

## JavaBean vs. Spring Bean

<table data-header-hidden data-full-width="true"><thead><tr><th width="150.400146484375"></th><th width="369.3914794921875"></th><th></th></tr></thead><tbody><tr><td><strong>Feature</strong></td><td><strong>JavaBean</strong></td><td><strong>Spring Bean</strong></td></tr><tr><td><strong>Definition</strong></td><td>A reusable class that follows specific conventions (POJO with getters/setters)</td><td>Any object managed and instantiated by the Spring IoC container</td></tr><tr><td><strong>Purpose</strong></td><td>Mainly used for holding data; acts like a DTO or form object</td><td>Serves as an application component: service, repository, controller, etc.</td></tr><tr><td><strong>Creation</strong></td><td>Manually instantiated using <code>new</code> keyword</td><td>Automatically created and wired by the Spring container</td></tr><tr><td><strong>Managed By</strong></td><td>Developer or any non-framework code</td><td>Spring’s IoC (Inversion of Control) container</td></tr><tr><td><strong>Lifecycle Management</strong></td><td>No lifecycle management by default</td><td>Spring handles full lifecycle: init, destroy, proxies, etc.</td></tr><tr><td><strong>Configuration Style</strong></td><td>No configuration required beyond Java class definition</td><td>Configured via <code>@Component</code>, <code>@Service</code>, <code>@Bean</code>, or XML</td></tr><tr><td><strong>Dependency Injection</strong></td><td>Not supported unless manually written</td><td>Fully supports field, constructor, setter injection</td></tr><tr><td><strong>Reusability</strong></td><td>Can be reused as a simple POJO</td><td>Reused across the application via container and injection</td></tr><tr><td><strong>Scope Awareness</strong></td><td>Always per-instance (each <code>new</code> creates a separate object)</td><td>Supports scopes like singleton, prototype, request, session</td></tr><tr><td><strong>Framework Dependency</strong></td><td>Does not depend on any framework</td><td>Tight integration with Spring Framework</td></tr><tr><td><strong>Testability</strong></td><td>Simple to test as a POJO</td><td>Easily testable with mock injection and Spring Test support</td></tr><tr><td><strong>Common Use Cases</strong></td><td>DTOs, form objects, simple utility objects</td><td>Services, DAOs, Controllers, Configurations, Event Publishers</td></tr><tr><td><strong>Bean Naming</strong></td><td>Class name or manual naming</td><td>Automatic or explicit naming via annotations/configuration</td></tr><tr><td><strong>Serialization</strong></td><td>Typically implements <code>Serializable</code></td><td>Not required unless needed; depends on usage</td></tr></tbody></table>

## Spring Bean vs. Enterprise JavaBeans (EJB)

<table data-header-hidden data-full-width="true"><thead><tr><th width="155.0181884765625"></th><th width="366.66058349609375"></th><th></th></tr></thead><tbody><tr><td><strong>Feature / Aspect</strong></td><td><strong>Spring Bean</strong></td><td><strong>Enterprise JavaBean (EJB)</strong></td></tr><tr><td><strong>Definition</strong></td><td>A Java object managed by the Spring IoC container</td><td>A component managed by the EJB container (Java EE standard)</td></tr><tr><td><strong>Framework Dependency</strong></td><td>Requires Spring Framework</td><td>Requires Java EE (Jakarta EE) runtime/container (like JBoss, GlassFish)</td></tr><tr><td><strong>Component Types</strong></td><td>Typically services, DAOs, configuration, etc.</td><td>Stateless, Stateful, Singleton, and Message-Driven Beans</td></tr><tr><td><strong>Container</strong></td><td>Spring IoC container</td><td>EJB container provided by application server</td></tr><tr><td><strong>Lightweight vs Heavyweight</strong></td><td>Lightweight</td><td>Considered heavyweight due to additional infrastructure</td></tr><tr><td><strong>Dependency Injection</strong></td><td>Fully supported with annotations like <code>@Autowired</code>, constructor, setter</td><td>Supported via <code>@EJB</code>, <code>@Resource</code> (less flexible compared to Spring)</td></tr><tr><td><strong>AOP Support</strong></td><td>Built-in AOP using proxies (<code>@Aspect</code>)</td><td>Declarative with limitations; interceptors used for cross-cutting concerns</td></tr><tr><td><strong>Transaction Management</strong></td><td>Declarative (<code>@Transactional</code>) and programmatic</td><td>Declarative (container-managed) and programmatic transactions supported</td></tr><tr><td><strong>Configuration Style</strong></td><td>Java Config, Annotations (<code>@Component</code>, <code>@Service</code>), XML</td><td>Deployment descriptors (XML) and annotations (<code>@Stateless</code>, <code>@EJB</code>)</td></tr><tr><td><strong>Persistence Integration</strong></td><td>Uses Spring Data JPA, Hibernate, or any ORM via abstraction</td><td>Integrates directly with JPA or legacy EJB Entity Beans (in older versions)</td></tr><tr><td><strong>Remote Access</strong></td><td>Optional, requires manual exposure (e.g., REST controllers or RMI setup)</td><td>Built-in remote invocation using RMI/IIOP or Web Services</td></tr><tr><td><strong>Scalability &#x26; Performance</strong></td><td>Scales well in lightweight containers like Tomcat or Jetty</td><td>Designed for large-scale, enterprise-grade distributed systems</td></tr><tr><td><strong>Security</strong></td><td>Spring Security integration with flexible configurations</td><td>Java EE security annotations like <code>@RolesAllowed</code> with container enforcement</td></tr><tr><td><strong>Testing</strong></td><td>Easier to test with mock beans, standalone, or with Spring Test framework</td><td>Requires full container or specialized testing frameworks like Arquillian</td></tr><tr><td><strong>Resource Requirements</strong></td><td>Minimal, runs on any servlet container</td><td>Requires full Java EE container</td></tr><tr><td><strong>Lifecycle Management</strong></td><td>Customizable with lifecycle annotations (<code>@PostConstruct</code>, <code>@PreDestroy</code>)</td><td>Managed by container; supports lifecycle callbacks</td></tr><tr><td><strong>Use Case</strong></td><td>Web apps, microservices, APIs, RESTful services</td><td>Large-scale distributed enterprise systems, legacy enterprise apps</td></tr><tr><td><strong>Popularity / Modern Usage</strong></td><td>Highly popular in modern cloud-native and microservices architectures</td><td>Declining in favor of Spring, Jakarta EE, and lightweight alternatives</td></tr></tbody></table>
