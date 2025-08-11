# Spring Profiles

## About

**Spring Profiles** provide a mechanism to separate **environment-specific** bean definitions and configuration logic, so our application can adapt automatically to different runtime contexts (e.g., development, testing, staging, production).

Instead of manually commenting/uncommenting configuration code for each environment, we can annotate beans or configuration classes with `@Profile` so they are only **loaded** if the matching profile is **active**.

## Purpose

Spring Profiles exist to **isolate and control bean registration based on runtime context**, enabling one application codebase to serve multiple operational needs without invasive code changes.

In modern applications, environments differ in **infrastructure, performance requirements, security policies, and integration endpoints**. If we tried to support all environments with a single unfiltered configuration, we would face:

* **Complex conditional logic** scattered across the codebase
* **High risk of misconfiguration**, especially when moving from lower to higher environments
* **Hard-to-reproduce bugs** caused by unintended bean inclusion

Spring Profiles solve this by giving the container **selective visibility** into which beans should be considered at startup. The decision is made **before bean instantiation**, so irrelevant beans are never even created.

**Key reasons profiles exist:**

1. **Environment Specialization**
   * Dev might use an in-memory H2 database; prod might use a cloud-hosted Postgres.
   * Allows infrastructure changes without touching core logic.
2. **Behavior Swapping**
   * Swap a real payment gateway with a mock gateway in tests.
   * Replace complex external integrations with local stubs for faster local development.
3. **Deployment Flexibility**
   * The same artifact (JAR/WAR) can be deployed to multiple environments by simply changing an activation flag - no rebuild required.
4. **Risk Reduction**
   * Prevents accidental use of production-only beans in development/testing contexts.
   * Eliminates “wrong environment” incidents by physically excluding beans.
5. **Clean Separation of Concerns**
   * Configuration is moved **out of business logic** into declarative annotations or config files.
   * Developers no longer need to read conditional code to understand environment rules.
6. **Scalability in Large Teams**
   * Teams working on different modules can define profile-specific beans without interfering with each other’s configurations.
   * Encourages modularity in infrastructure definitions.
7. **Runtime Adaptability**
   * Supports complex setups like _multi-cloud deployments_, _hybrid on-prem/cloud_, or _feature-flag-driven releases_, where bean composition changes based on active profile combinations.

In short, the purpose of Spring Profiles is **not just “different config for different environments”**, but to **build flexible, safe, and maintainable application configurations** that scale across multiple deployment contexts - all while keeping the main codebase clean and environment-agnostic.

## How It Works ?

Spring Profiles operate at the **bean definition registration stage** - _before_ any beans are instantiated, but _after_ all configuration sources have been loaded into the `Environment`.

Here’s the step-by-step breakdown:

### **1. Profile Resolution Phase**

When the Spring application starts, the container determines which profiles are **active** and which are **default**:

1. **Sources for profile activation** (checked in priority order):
   * Command-line arguments (`--spring.profiles.active=...`)
   * JVM system properties (`-Dspring.profiles.active=...`)
   * Environment variables (`SPRING_PROFILES_ACTIVE`)
   * Application properties/YAML files
   * Programmatic calls (`ConfigurableEnvironment#setActiveProfiles`)
2. If **no active profiles** are explicitly set, the container:
   * Falls back to `spring.profiles.default`
   * If `spring.profiles.default` is also not set, uses `"default"` as the implicit profile.

### **2. Bean Definition Phase**

Before bean instantiation:

* Spring **parses** all `@Configuration` classes, `@Component` classes, and imported configurations.
* Each bean definition is checked for **profile metadata**:
  * Beans with **no `@Profile`** → eligible for all profiles.
  * Beans with `@Profile` → only eligible if **at least one** profile matches the currently active set.

{% hint style="success" %}
Profile checks happen **before** any dependency resolution or `@Autowired` injection.
{% endhint %}

### **3. Matching Logic**

Spring uses **set intersection logic**:

* Let **A** = Set of active profiles (from `Environment`)
* Let **B** = Set of profiles declared on the bean via `@Profile`
* If **A ∩ B** is **non-empty** → Bean is registered.
* If empty → Bean definition is discarded.

### **4. Profile Expressions**

Spring 4+ allows logical operators in `@Profile`:

* `@Profile({"dev", "test"})` → OR condition
* `@Profile("dev & mysql")` → AND condition
* `@Profile("!prod")` → NOT condition

Expression parsing is handled by `ProfilesParser`, which creates a **predicate** evaluated against the active profile set.

### **5. Bean Registration Outcome**

After profile filtering:

* Only **matching beans** remain in the `BeanDefinitionRegistry`.
* Dependency injection operates **only** on the filtered set.
* Beans excluded due to profile mismatch:
  * Are never instantiated
  * Do not participate in dependency resolution
  * Do not trigger `@PostConstruct` or `InitializingBean` hooks

### **6. Special Cases**

* **Overlapping profiles**: Multiple beans for the same type may be active if profiles overlap. Use `@Primary` or `@Qualifier` to resolve ambiguity.
* **Profile-specific configuration classes**: If a `@Configuration` class is annotated with `@Profile`, **all beans inside** are subject to the same profile restriction.
* **Default profile override**: If `spring.profiles.active` is set, the default profile is ignored.

## **Naming Convention**

The file naming must follow:

```
application-<profile>.yaml
application-<profile>.properties
```

Where `<profile>` exactly matches the profile name declared in:

* `spring.profiles.active`
* `SPRING_PROFILES_ACTIVE` environment variable
* CLI argument (`--spring.profiles.active=...`)
* Programmatic activation.

## Declaring Profiles

In Spring, **declaring a profile** means associating a bean definition (or configuration class) with one or more **environment identifiers** so that the bean is **only loaded** when those profiles are **active**.\
This declaration is a **filtering mechanism** during the _bean registration phase_, not during bean execution.

When the container is starting up, it evaluates all bean definitions against the **currently active profile set** before even instantiating them. If the bean’s `@Profile` condition is **not satisfied**, the bean is **never registered** in the `ApplicationContext`. This is important because:

* The bean's lifecycle methods (`@PostConstruct`, `@PreDestroy`) are never called.
* Other beans cannot inject it because it doesn’t exist in the context.
* This is more efficient than loading all beans and disabling them at runtime.

#### **1. Applying `@Profile` on Bean Classes**

When placed on a class that is a **Spring bean** (`@Component`, `@Service`, `@Repository`, `@Controller`), `@Profile` tells Spring to register that bean only when the matching profile is active.

```java
@Service
@Profile("dev")
public class DevPaymentService implements PaymentService {
    public void pay() { System.out.println("Processing payment in DEV mode"); }
}
```

* **Effect**: Only available when `spring.profiles.active=dev` (or when `dev` is part of a multi-profile setup).
* If `dev` is not active, the container will **not even know** this bean exists.

#### **2. Applying `@Profile` on `@Bean` Methods**

Profiles can also be declared **at the method level** inside a `@Configuration` class.\
This allows us to **conditionally define beans** without splitting the configuration into multiple classes.

```java
@Configuration
public class DataSourceConfig {

    @Bean
    @Profile("prod")
    public DataSource prodDataSource() {
        return new HikariDataSource(); // connects to production DB
    }

    @Bean
    @Profile("test")
    public DataSource testDataSource() {
        return new EmbeddedDatabaseBuilder().setType(H2).build(); // in-memory DB
    }
}
```

* Here, only **one** `DataSource` bean is created depending on the active profile.
* This prevents duplicate beans and ambiguity errors.

#### **3. Applying `@Profile` on Configuration Classes**

When applied at the **class level** to a `@Configuration` class, **all bean methods inside** inherit that profile condition.

```java
@Configuration
@Profile("staging")
public class StagingConfiguration {

    @Bean
    public EmailService stagingEmailService() {
        return new SmtpEmailService("staging-mail.company.com");
    }

    @Bean
    public PaymentService stagingPaymentService() {
        return new PaymentGateway("https://staging-payments.company.com");
    }
}
```

* This approach keeps environment-specific configurations **grouped together**.
* Useful when multiple beans change together between environments.

#### **4. Multi-Profile Declarations**

We can assign **multiple profiles** to the same bean or configuration class:

```java
@Component
@Profile({"qa", "staging"})
public class QAAndStagingLogger implements Logger { ... }
```

* The bean will be active if **any** listed profile matches.
* This is an **OR** condition by default.

#### **5. Profile Expressions for Complex Conditions**

Spring 4+ supports **logical profile expressions**:

* **AND**: `"dev & mysql"` → both must be active.
* **OR**: `"dev | qa"` → either one is active.
* **NOT**: `"!prod"` → active in all profiles except prod.

Example:

```java
@Component
@Profile("dev & !cloud")
public class LocalDevFileStorage implements FileStorage { ... }
```

* Bean loads only in **local dev environments**, not in cloud deployments.

#### **6. Default Profile Binding**

If we don’t explicitly set a profile, beans without a `@Profile` annotation are considered **profile-neutral** - they load in **all environments**.\
But we can **explicitly** bind beans to the `default` profile:

```java
@Component
@Profile("default")
public class DefaultMetricsService implements MetricsService { ... }
```

* This is useful for having a **fallback configuration** when no profiles are active.

## Default Profile

In Spring, the **default profile** is a **fallback** profile that is applied **when no explicit profile is active**.

* It is internally represented as `"default"`.
* Beans annotated with `@Profile("default")` are **only** loaded if:
  * No profile is set via `spring.profiles.active` (properties, YAML, env vars, CLI, etc.).
  * No profile is activated programmatically.
* Beans **without any `@Profile` annotation** are _not tied_ to any profile and are always loaded regardless of active profile(s).

{% hint style="info" %}
**No `@Profile`** → bean is _always included_.

`@Profile("default")` → bean is included _only if nothing else is active_.
{% endhint %}

#### **Why Have a Default Profile ?**

* **Local development fallback**: When running the app without specifying a profile, it still starts with sensible defaults.
* **Baseline configuration**: Shared settings that don’t belong to any specific environment but are needed for the app to run.
* **Avoid startup failures**: Ensures the application has at least one set of beans to load.

#### **How It Works Internally ?**

* At startup, Spring checks for active profiles:
  * If **none** are set → `"default"` profile is automatically active.
  * If **one or more** profiles are active → `"default"` profile is **not** added unless explicitly included in `spring.profiles.active`.
* The `"default"` profile is just a **label** like any other; it’s not special beyond the auto-activation rule.

#### **application.yaml vs application-\<profile>.yaml**

Spring Boot automatically loads configuration files based on active profiles:

Loading Order:

1. `application.yaml` (or `.properties`) → Always loaded first.
2. `application-<profile>.yaml` → Loaded only if `<profile>` is active.
3. Profile-specific files override values from the base file.

#### **A. Example – No Active Profile**

**Files:**

```yaml
# application.yaml
spring:
  datasource:
    url: jdbc:h2:mem:default
```

```yaml
# application-dev.yaml
spring:
  datasource:
    url: jdbc:mysql://localhost/devdb
```

**Run without `spring.profiles.active`**:

* Active profile → `"default"`
* Loaded configs:
  * application.yaml (H2 in-memory DB)
  * application-dev.yaml is **ignored**.

#### **B. Example – Active Profile is dev**

**Run with**:

```bash
java -jar app.jar --spring.profiles.active=dev
```

* Active profile → `"dev"`
* Loaded configs:
  * application.yaml (base config)
  * application-dev.yaml (overrides datasource URL to MySQL)
* `"default"` profile beans are **ignored**.

#### **C. Example – Multiple Profiles**

```bash
java -jar app.jar --spring.profiles.active=dev,aws
```

* application.yaml (base config)
* application-dev.yaml (dev-specific overrides)
* application-aws.yaml (AWS-specific overrides)
* All beans with `@Profile("dev")` or `@Profile("aws")` are eligible.

## Activating Profiles

#### **A. Properties/YAML**

```properties
spring.profiles.active=dev
spring.profiles.default=default
```

```yaml
spring:
  profiles:
    active: dev
    default: default
```

#### **B. Command-Line**

```bash
java -jar app.jar --spring.profiles.active=prod
```

#### **C. JVM System Property**

```bash
java -Dspring.profiles.active=staging -jar app.jar
```

#### **D. Environment Variable**

```bash
export SPRING_PROFILES_ACTIVE=test
```

#### **E. Programmatically**

```java
SpringApplication app = new SpringApplication(MyApp.class);
app.setAdditionalProfiles("dev");
app.run(args);
```

#### **F. Multi-Profile Beans**

A single bean can match **multiple profiles**:

```java
@Profile({"qa", "staging"})
@Component
public class StagingPaymentService implements PaymentService { ... }
```

If **either** profile is active, the bean will be loaded.

#### **G. Testing with Profiles**

In tests, we can activate profiles with:

```java
@SpringBootTest
@ActiveProfiles("test")
public class PaymentServiceTest { ... }
```

This ensures test beans replace production beans automatically.

#### **H. Combining Profiles with Conditional Beans**

`@Profile` can be combined with:

* `@ConditionalOnProperty`
* `@ConditionalOnClass`
* `@ConditionalOnMissingBean`\
  …for even more precise bean activation control.

Example:

```java
@Bean
@Profile("cloud")
@ConditionalOnProperty(name = "storage.type", havingValue = "s3")
public FileStorage s3FileStorage() { ... }
```
