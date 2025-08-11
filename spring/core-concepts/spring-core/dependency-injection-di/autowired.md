# @Autowired

## About

In the Spring Framework, `@Autowired` is an annotation used for **automatic dependency injection**. It tells Spring to **resolve and inject a bean** into the marked field, constructor, or method based on the bean’s type, without requiring explicit configuration in XML or Java configuration classes.

Spring performs this injection at runtime by scanning the application context for a matching bean. If exactly one bean of the required type exists, it is injected automatically. If more than one candidate exists, Spring requires additional disambiguation - typically via `@Primary`, `@Qualifier`, or by matching bean names.

`@Autowired` is used whenever a class depends on another Spring-managed bean, and we want Spring to handle the wiring without manual instantiation. It promotes loose coupling and easier testing by allowing bean dependencies to be defined declaratively rather than imperatively in code.

## Attributes

The `@Autowired` annotation has **one primary attribute** and one **meta-behavior** that affects how it interacts with the injection process.

<table><thead><tr><th width="103.890625">Attribute</th><th width="86.55078125">Type</th><th width="82.90234375">Default</th><th>Description</th></tr></thead><tbody><tr><td><code>required</code></td><td>boolean</td><td><code>true</code></td><td>Indicates whether the dependency is mandatory. If <code>true</code> and no suitable bean is found, Spring throws an exception. If <code>false</code>, Spring will inject <code>null</code> (for objects) or the default value (for primitives/wrappers).</td></tr></tbody></table>

### Attribute Details

**`required`**

* **Default behavior (`true`)**:
  * If no bean of the required type (or matching qualifiers) exists in the application context, Spring throws a `NoSuchBeanDefinitionException` during context initialization.
  * Ensures the application fails fast when a critical dependency is missing.
* **Optional injection (`false`)**:
  * The annotated field, parameter, or method argument can remain unset if no candidate is found.
  * Commonly used when injecting optional collaborators or when certain beans are only conditionally loaded.
  * Useful for plugin-based or feature-flag-driven systems.
* **Caution**: Optional injection may lead to `NullPointerException` if we forget to check for `null` before using the dependency.

### Meta-Behavior

**`@Autowired` as a meta-annotation**

While `@Autowired` itself has only `required` as a configurable attribute, its behavior is influenced by other annotations when combined:

* With `@Qualifier`: Narrows bean selection when multiple candidates exist.
* With `@Lazy`: Delays bean instantiation until the dependency is first accessed.
* With `@Primary`: Selects a default candidate when multiple matches exist.

## How It Works ?

The `@Autowired` annotation triggers Spring’s **dependency resolution and injection process** during the bean creation phase of the application context lifecycle.

At a high level, Spring’s `AutowiredAnnotationBeanPostProcessor` detects `@Autowired` annotations on bean fields, constructors, and methods, and then attempts to **resolve and inject a suitable bean** from the application context.

#### **Step-by-Step Internal Process**

**1. Bean Scanning and Detection**

* When Spring starts, it scans our classes for annotations like `@Component`, `@Service`, `@Controller`, and `@Configuration` (or beans defined via XML/Java config).
* It also registers **BeanPostProcessors**, including `AutowiredAnnotationBeanPostProcessor`, which specifically looks for `@Autowired` (and similar annotations like `@Inject`).

**2. Identifying Injection Points**

For each bean being created, the post-processor:

* Inspects all **fields**, **constructors**, and **methods**.
* Marks those annotated with `@Autowired` as **injection points**.
* Tracks metadata so the injection can be performed after the bean is instantiated but before it’s used.

**3. Injection Type Resolution**

Spring matches dependencies **by type** first:

1. **Single Match** → Inject directly.
2. **Multiple Matches** → Apply narrowing rules in order:
   * `@Qualifier` match (if present at injection point).
   * Bean name match (field name or parameter name matches a bean id).
   * `@Primary` preference (if exactly one primary exists).
3. **No Match** →
   * If `required=true`, throw `NoSuchBeanDefinitionException`.
   * If `required=false`, inject `null` (or default primitive value).

**4. Constructor Injection Priority**

* If a bean has a **single constructor**, Spring will use it for injection automatically (even without `@Autowired`).
* If multiple constructors exist, we must annotate exactly one with `@Autowired` so Spring knows which one to use.
* Constructor injection ensures all required dependencies are available at instantiation time, making the bean immutable after creation.

**5. Field Injection Mechanics**

* Spring uses reflection to set private/protected/public fields.
* Field injection happens after the bean is constructed but before any `@PostConstruct` methods run.
* This approach is convenient but makes dependencies less explicit — constructor injection is often preferred in complex systems.

**6. Method (Setter) Injection Mechanics**

* Spring identifies setter methods (or arbitrary methods) annotated with `@Autowired`.
* Parameters are resolved like constructor parameters — by type first, then by qualifier/name.
* Useful for optional dependencies that may change or for legacy beans needing backward-compatible wiring.

**7. Handling Optional Dependencies**

* If a dependency is optional, we can:
  * Set `@Autowired(required=false)`

**8. Circular Dependency Handling**

* For singleton beans, Spring can resolve **circular dependencies** between fields and setters via early references from the singleton cache.
* However, **constructor-based circular dependencies** are not resolvable and will cause a `BeanCurrentlyInCreationException`.
* Avoiding circular dependencies is generally recommended - it indicates tight coupling between components.

**9. Lazy Injection**

* If combined with `@Lazy`, the dependency is injected as a proxy, and the target bean is created only when first used.
* This can break dependency cycles or reduce startup time for expensive beans.

## Best Practice

Correct usage of `@Autowired` can greatly improve code clarity and maintainability, while poor usage can lead to brittle, tightly coupled systems. The following guidelines help ensure `@Autowired` is used effectively in production applications.

#### **1. Prefer Constructor Injection Over Field Injection**

* **Why**: Constructor injection makes dependencies explicit, supports immutability, and allows for easier unit testing without reflection.
* Spring automatically injects a single constructor without needing `@Autowired`, but adding it explicitly improves readability.
* Example:

```java
@Component
class OrderService {
    private final PaymentService paymentService;

    @Autowired
    public OrderService(PaymentService paymentService) {
        this.paymentService = paymentService;
    }
}
```

#### **2. Avoid Field Injection in Complex Systems**

* Field injection is convenient for quick prototypes but hides dependencies, making code harder to test and refactor.
* If we must use field injection (e.g., in legacy beans or configuration classes), keep it to simple, non-critical dependencies.

#### **3. Keep Dependencies Minimal**

* If a bean requires many `@Autowired` dependencies, it may be violating the **Single Responsibility Principle**.
* Consider splitting the bean into smaller components with clearer purposes.

#### **4. Use `@Qualifier` When Multiple Beans Exist**

* When multiple beans of the same type exist, always disambiguate with `@Qualifier` or `@Primary`.
* This avoids accidental bean resolution changes if another bean of the same type is introduced later.

#### **5. Avoid Circular Dependencies**

* Circular dependencies indicate strong coupling and make code harder to maintain.
* If unavoidable, use setter injection or `@Lazy` injection to break the cycle but redesign is usually the better fix.

#### **6. Use `@Lazy` for Expensive Beans**

* If a dependency is costly to initialize or rarely used, annotate it with `@Lazy` to defer creation until needed.
* This can speed up application startup and reduce memory footprint.

**7. Limit `@Autowired` Usage in Configuration Classes**

* In `@Configuration` classes, prefer constructor injection for dependencies rather than field injection.
* This ensures all dependencies are ready before bean creation and avoids subtle lifecycle issues.

#### **8. Do Not Overuse `@Autowired`**

* Use it for **true dependencies**, not just for convenience to access a bean.
* If a dependency can be passed as a method argument or handled locally, avoid injecting it.

#### **9. Test Dependency Wiring Explicitly**

* For integration tests, ensure the Spring context loads with the intended dependencies wired in.
* Use `@MockBean` or `@TestConfiguration` to override dependencies in test scenarios without affecting production beans.

#### **10. Handle Optional Dependencies Safely**

* Instead of `@Autowired(required=false)`, prefer:
  * `Optional<T>` injection (since Spring 4.3)
  * `@Nullable` injection (since Spring 5.0)
* These approaches make optionality explicit and reduce null-handling errors.

## Example

#### **1. Field Injection (Basic Usage)**

```java
@Component
class OrderService {

    @Autowired
    private PaymentService paymentService;

    public void processOrder() {
        paymentService.pay();
    }
}
```

**Explanation**

* Spring finds a bean of type `PaymentService` and injects it into the private field, even without a setter or constructor.
* Convenient for small projects, but hides dependencies (less test-friendly).

#### **2. Constructor Injection (Preferred)**

```java
@Component
class OrderService {

    private final PaymentService paymentService;

    @Autowired
    public OrderService(PaymentService paymentService) {
        this.paymentService = paymentService;
    }
}
```

**Explanation**

* Dependencies are made explicit and required at bean creation time.
* If there’s only **one constructor**, Spring can inject it without the `@Autowired` annotation, but adding it makes intent clear.

#### **3. Multiple Constructor Scenario**

```java
@Component
class OrderService {

    private final PaymentService paymentService;

    @Autowired
    public OrderService(PaymentService paymentService) {
        this.paymentService = paymentService;
    }

    public OrderService() {
        this.paymentService = null;
    }
}
```

**Explanation**

* If multiple constructors exist, we must annotate the one we want Spring to use.
* Without `@Autowired`, Spring cannot decide which constructor to use.

#### **4. Setter Injection**

```java
@Component
class OrderService {

    private PaymentService paymentService;

    @Autowired
    public void setPaymentService(PaymentService paymentService) {
        this.paymentService = paymentService;
    }
}
```

**Explanation**

* Useful when we want to inject dependencies after object creation, or when they are optional.
* More flexible, but less strict than constructor injection.

#### **5. With `@Qualifier` to Resolve Ambiguity**

```java
@Component
class OrderService {

    @Autowired
    @Qualifier("fastPaymentService")
    private PaymentService paymentService;
}
```

**Explanation**

* When multiple beans implement `PaymentService`, `@Qualifier` ensures the correct one is injected.
* Without this, Spring throws `NoUniqueBeanDefinitionException`.

#### **6. Optional Dependency with `required=false`**

```java
@Component
class OrderService {

    @Autowired(required = false)
    private DiscountService discountService;
}
```

**Explanation**

* If `DiscountService` bean doesn’t exist, no error is thrown; `discountService` will be `null`.
* Risk: Must check for null before use.

#### **7. Optional Dependency with `Optional<T>`**

```java
@Component
class OrderService {

    @Autowired
    private Optional<DiscountService> discountService;
}
```

**Explanation**

* Since Spring 4.3, `Optional` injection avoids null checks.
* Use `discountService.ifPresent(...)` to safely run code when the bean exists.

#### **8. Optional Dependency with `@Nullable`**

```java
@Component
class OrderService {

    @Autowired
    public void setDiscountService(@Nullable DiscountService discountService) {
        // discountService may be null
    }
}
```

**Explanation**

* Since Spring 5.0, `@Nullable` can be applied to parameters to indicate the bean is optional.

#### **9. Lazy Injection**

```java
@Component
class OrderService {

    @Autowired
    @Lazy
    private PaymentService paymentService;
}
```

**Explanation**

* Bean creation is deferred until `paymentService` is first accessed.
* Useful for breaking circular dependencies or speeding up startup.

#### **10. Collection Injection**

```java
@Component
class OrderService {

    @Autowired
    private List<PaymentService> paymentServices;

    @Autowired
    private Map<String, PaymentService> paymentServiceMap;
}
```

**Explanation**

* Injects **all beans** of a given type into a `List` or `Map`.
* `List` is ordered by `@Order` or bean definition order.
* `Map` keys are bean names.

#### **11. Self-Defined Bean Selection with Collection Filtering**

```java
@Component
class FastPaymentService implements PaymentService { }

@Component
class SlowPaymentService implements PaymentService { }

@Component
class OrderService {

    @Autowired
    @Qualifier("fastPaymentService")
    private PaymentService paymentService;

    @Autowired
    private List<PaymentService> allPaymentServices;
}
```

**Explanation**

* Injects one specific bean via qualifier, but also injects **all available beans** into a collection.

#### **12. Injection in `@Configuration` Class**

```java
@Configuration
class AppConfig {

    private final PaymentService paymentService;

    @Autowired
    public AppConfig(PaymentService paymentService) {
        this.paymentService = paymentService;
    }

    @Bean
    public OrderService orderService() {
        return new OrderService(paymentService);
    }
}
```

**Explanation**

* Constructor injection in configuration classes ensures dependencies are ready when defining beans.

#### **13. Circular Dependency Example (Setter-Based Fix)**

```java
@Component
class ServiceA {

    private ServiceB serviceB;

    @Autowired
    public void setServiceB(ServiceB serviceB) {
        this.serviceB = serviceB;
    }
}

@Component
class ServiceB {

    private final ServiceA serviceA;

    @Autowired
    public ServiceB(ServiceA serviceA) {
        this.serviceA = serviceA;
    }
}
```

**Explanation**

* Field or setter injection can resolve circular dependencies between beans of singleton scope.
* Constructor-based circular dependencies cause errors.
