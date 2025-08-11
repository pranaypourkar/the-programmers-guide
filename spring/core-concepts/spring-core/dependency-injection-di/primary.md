# @Primary

## About

The `@Primary` annotation in Spring Framework is used to **resolve ambiguity** when multiple beans of the same type are available in the Spring ApplicationContext and no explicit qualifier is provided during injection.\
It tells Spring, _“If multiple matching candidates exist, prefer this one by default unless another is explicitly specified with `@Qualifier`.”_

In dependency injection, Spring matches a required bean type to the available beans in the container.\
When multiple beans of the same type exist, Spring must decide which one to inject.\
Without further guidance, this situation triggers a `NoUniqueBeanDefinitionException`.

`@Primary` is one way to guide Spring’s choice:

* It **marks one bean as the “default” choice** among beans of the same type.
* When injecting without qualifiers, the `@Primary` bean is injected.
* It does **not** prevent other beans from being injected explicitly if a `@Qualifier` is used.

## Attributes

The `@Primary` annotation itself does **not** define any attributes or parameters.\
Its behavior is entirely **declarative** - simply placing it on a bean definition marks that bean as the preferred candidate when multiple beans of the same type are eligible for injection.

### **Syntax**

```java
@Target({ElementType.TYPE, ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface Primary {
}
```

* **`ElementType.TYPE`** - can be placed at the class level (on `@Component`, `@Service`, etc.).
* **`ElementType.METHOD`** - can be placed on `@Bean` methods inside configuration classes.

### **Usage Locations**

1.  **Class Level** (with stereotype annotations)

    ```java
    @Component
    @Primary
    public class FastPaymentService implements PaymentService { }
    ```
2.  **Bean Method Level** (in `@Configuration` class)

    ```java
    @Configuration
    public class AppConfig {
        
        @Bean
        @Primary
        public PaymentService fastPaymentService() {
            return new FastPaymentService();
        }
    }
    ```

### **Notes**

* **One Primary per Injection Type**
  * We can mark multiple beans as `@Primary` if they are of _different_ types.
  * If two beans of the _same type_ are marked `@Primary`, Spring cannot choose and will throw an exception.
* **Interaction with `@Qualifier`**
  * If a `@Qualifier` is used at the injection site, `@Primary` is ignored entirely for that injection.
  * `@Primary` is only a _default_ qualifiers always override it.
* **With `@Profile`**
  * We can have different beans marked `@Primary` in different profiles to change the default at runtime.
* **Meta-Annotations**
  *   We can create a custom annotation that includes `@Primary` to apply it implicitly:

      ```java
      @Primary
      @Service
      public @interface DefaultService { }
      ```

## How It Works ?

When Spring performs dependency injection, it follows a **multi-step candidate resolution process** to determine which bean should be injected.\
`@Primary` participates in this process as a **tie-breaker** when multiple beans of the same type are found and **no explicit `@Qualifier`** is provided.

#### **1. Bean Discovery and Type Matching**

When a dependency is requested (e.g., `@Autowired PaymentService paymentService;`), Spring:

1. Scans the ApplicationContext for all beans assignable to the requested type (`PaymentService` in this example).
2. Creates a list of all matching candidates.

#### **2. Candidate Filtering**

Before `@Primary` comes into play, Spring filters candidates based on:

* Bean definition scope (`singleton`, `prototype`, etc.)
* Bean lifecycle state (e.g., fully initialized, not destroyed)
* Any applied conditions (`@Conditional`, `@Profile`, etc.)

#### **3. Resolving Ambiguity Without Qualifiers**

If multiple candidates remain after filtering:

* **Step 1**: Check if one candidate is marked `@Primary`.
  * If **exactly one** is found, Spring injects that bean.
  * If **more than one** is marked `@Primary` for the same type, Spring throws a `NoUniqueBeanDefinitionException`.
* **Step 2**: If no `@Primary` is found, Spring throws `NoUniqueBeanDefinitionException` unless the developer uses a `@Qualifier` or bean name injection.

#### **4. Interaction with `@Qualifier`**

* If a `@Qualifier` is provided, it **overrides** any `@Primary` designation.
* `@Primary` is **only considered** when injection is based solely on type.

```java
@Autowired
private PaymentService paymentService;  // @Primary considered here

@Autowired
@Qualifier("slowPaymentService")
private PaymentService paymentService;  // @Primary ignored
```

#### **5. Resolution Inside Spring Internals**

Internally, the decision-making occurs in:

* **`DefaultListableBeanFactory`** - the core bean factory used by most Spring applications.
* Specifically, the method `determinePrimaryCandidate()` examines all matching beans and:
  1. Iterates over candidates.
  2. Checks for `isPrimary()` in each `BeanDefinition`.
  3. Returns the single primary bean if found.
  4. Throws an exception if more than one primary exists for the same type.

#### **6. Special Considerations**

* **Collections and Maps**:\
  When injecting a collection (`List<PaymentService>`), `@Primary` does **not** affect which beans are included - all beans of that type are injected.
* **Factory Beans**:\
  If the bean is a `FactoryBean`, `@Primary` applies to the product bean type, not the `FactoryBean` itself.
* **Profiles and Conditions**:\
  `@Primary` beans can be active only in certain profiles, allowing different defaults in dev, test, and prod environments.

## Best Practice

Using `@Primary` effectively ensures clarity in bean resolution, avoids runtime errors, and keeps our dependency injection predictable. However, because it sets a **global default** for a type, it must be used carefully to avoid unintended injections.

#### **1. Use `@Primary` for the True Default Only**

* Apply `@Primary` **only to the bean that should be the default choice** for most injection points.
* If different modules have different "defaults," prefer `@Qualifier` to avoid confusion.

```java
@Component
@Primary
public class FastPaymentService implements PaymentService { }
```

#### **2. Avoid Multiple Primaries for the Same Type**

* Multiple `@Primary` beans for the same type cause ambiguity and result in `NoUniqueBeanDefinitionException`.
* If we must have environment-specific primaries, combine `@Primary` with `@Profile`.

```java
@Profile("prod")
@Primary
@Bean
public PaymentService fastPaymentService() { ... }

@Profile("test")
@Primary
@Bean
public PaymentService mockPaymentService() { ... }
```

#### **3. Prefer `@Qualifier` for Specific Cases**

* Use `@Primary` for the majority default case.
* Use `@Qualifier` for exceptions or special cases.

```java
@Autowired
@Qualifier("slowPaymentService")
private PaymentService backupService;
```

#### **4. Keep `@Primary` Visible and Obvious**

* If possible, place `@Primary` on the class itself (for stereotype beans) rather than the bean definition method, so it’s easier to spot during code reviews.
* If we put it in `@Bean` methods, group related configurations together.

#### **5. Avoid `@Primary` in Shared Libraries**

* Don’t mark beans in reusable libraries as `@Primary` unless absolutely necessary it can unexpectedly override application-level defaults.

#### **6. Combine with Conditional Beans for Flexibility**

* Use `@Conditional` or `@Profile` to make `@Primary` bean selection environment-aware.

#### **7. Document Why a Bean is Primary**

* Always document why a particular bean is marked as `@Primary` so future maintainers understand its global effect.
* In large projects, add Javadoc or comments explaining its role.

#### **8. Testing with `@Primary`**

* In test contexts, mark mocks or stubs as `@Primary` to automatically replace the production default without touching injection code.

```java
@TestConfiguration
public class TestConfig {
    @Bean
    @Primary
    public PaymentService testPaymentService() {
        return new MockPaymentService();
    }
}
```

#### **9. Avoid Overuse**

* Too many `@Primary` beans across modules lead to hidden resolution rules that are hard to track.
* If we find ourself using `@Primary` in multiple places for the same type, reconsider the design and possibly rely more on explicit qualifiers.

## Example

`@Primary` can be applied in different ways depending on whether we define beans via annotations, Java configuration, XML, or even in testing.\
Below are **all key usage patterns** with explanations.

#### **1. Class-Level `@Primary` with Component Scanning**

When using Spring’s stereotype annotations (`@Component`, `@Service`, `@Repository`), we can mark a class as the default bean for its type.

```java
public interface PaymentService {
    void pay(double amount);
}

@Component
@Primary
public class FastPaymentService implements PaymentService {
    @Override
    public void pay(double amount) {
        System.out.println("Processing payment instantly: " + amount);
    }
}

@Component
public class SlowPaymentService implements PaymentService {
    @Override
    public void pay(double amount) {
        System.out.println("Processing payment slowly: " + amount);
    }
}

@Service
public class CheckoutService {
    @Autowired
    private PaymentService paymentService; // Injects FastPaymentService
}
```

**Explanation**

* Two beans (`FastPaymentService`, `SlowPaymentService`) implement `PaymentService`.
* `@Primary` tells Spring to inject `FastPaymentService` unless explicitly overridden with a `@Qualifier`.

#### **2. Bean-Method-Level `@Primary` in Java Configuration**

When using `@Configuration` with `@Bean` methods, `@Primary` can be applied at the method level.

```java
@Configuration
public class PaymentConfig {

    @Bean
    @Primary
    public PaymentService fastPaymentService() {
        return new FastPaymentService();
    }

    @Bean
    public PaymentService slowPaymentService() {
        return new SlowPaymentService();
    }
}

@Service
public class CheckoutService {
    @Autowired
    private PaymentService paymentService; // Injects fastPaymentService
}
```

**Explanation**

* Even without stereotype annotations, `@Primary` works at bean definition level.
* The default bean (`fastPaymentService`) is used when no `@Qualifier` is given.

#### **3. `@Primary` with `@Qualifier` Override**

`@Qualifier` takes precedence over `@Primary`.

```java
@Service
public class CheckoutService {

    @Autowired
    private PaymentService paymentService; // Injects primary bean

    @Autowired
    @Qualifier("slowPaymentService")
    private PaymentService backupService;  // Explicitly injects slowPaymentService
}
```

**Explanation**

* `paymentService` → injected from the primary bean.
* `backupService` → injected from the explicitly named bean, ignoring `@Primary`.

#### **4. Environment-Specific Primary Bean with `@Profile`**

Mark different beans as primary for different environments.

```java
@Configuration
public class PaymentProfileConfig {

    @Bean
    @Primary
    @Profile("prod")
    public PaymentService fastPaymentService() {
        return new FastPaymentService();
    }

    @Bean
    @Primary
    @Profile("test")
    public PaymentService mockPaymentService() {
        return new MockPaymentService();
    }
}
```

**Explanation**

* In the `prod` profile, the production service is primary.
* In the `test` profile, a mock service becomes the primary bean for testing purposes.

#### **5. Testing Context Override with `@Primary`**

In tests, we can override the primary bean with a mock.

```java
@TestConfiguration
public class TestPaymentConfig {

    @Bean
    @Primary
    public PaymentService mockPaymentService() {
        return new MockPaymentService();
    }
}

@SpringBootTest
@Import(TestPaymentConfig.class)
public class CheckoutServiceTest {

    @Autowired
    private CheckoutService checkoutService;

    @Test
    void testPayment() {
        checkoutService.processPayment(100);
        // Uses MockPaymentService instead of FastPaymentService
    }
}
```

**Explanation**

* By marking the mock as `@Primary` in test config, it automatically replaces the production default for the entire test.

#### **6. `@Primary` in Combination with Factory Beans**

When using `FactoryBean`, `@Primary` applies to the product type, not the factory itself.

```java
@Component
@Primary
public class PrimaryConnectionFactoryBean implements FactoryBean<Connection> {
    @Override
    public Connection getObject() {
        return new Connection("Primary DB");
    }
    @Override
    public Class<?> getObjectType() {
        return Connection.class;
    }
}

@Component
public class SecondaryConnectionFactoryBean implements FactoryBean<Connection> {
    @Override
    public Connection getObject() {
        return new Connection("Secondary DB");
    }
    @Override
    public Class<?> getObjectType() {
        return Connection.class;
    }
}
```

**Explanation**

* Even though two factory beans exist, Spring sees them as providers of `Connection`.
* The `PrimaryConnectionFactoryBean` is chosen when injecting a `Connection`.
