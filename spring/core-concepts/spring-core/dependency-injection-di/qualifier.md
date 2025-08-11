# @Qualifier

## About

In Spring Framework, `@Qualifier` is used to resolve **ambiguity** when multiple beans of the same type exist in the application context.

By default, Spring performs **type-based dependency injection -** if more than one bean matches the required type, Spring cannot decide which one to inject and will throw a `NoUniqueBeanDefinitionException`.

The `@Qualifier` annotation helps by **explicitly specifying which bean** should be injected, either by using the bean name or a custom qualifier value.

It is commonly used in combination with `@Autowired` (or `@Inject`) to refine the injection target.

## Attributes

`@Qualifier` has a **single attribute**:

<table data-full-width="true"><thead><tr><th width="99.6796875">Attribute</th><th width="90.76953125">Type</th><th width="117.9296875">Required</th><th>Description</th></tr></thead><tbody><tr><td><code>value</code></td><td>String</td><td>Yes</td><td>Specifies the name (or qualifier) of the bean to inject. This must match the bean's name or the value provided in its own <code>@Qualifier</code> or <code>@Component</code>/<code>@Bean</code> annotation.</td></tr></tbody></table>

* **Mandatory**: The `value` attribute is always required; without it, `@Qualifier` serves no purpose.
* **Bean Matching**:
  * If the bean is defined with `@Component("customName")` or `@Bean(name="customName")`, the `value` in `@Qualifier` should match `"customName"`.
  * If the bean is defined with another `@Qualifier("name")`, the `value` should match `"name"`.
* **No Default Value**: There’s no default - we must explicitly provide the bean name.

## How It Works ?

`@Qualifier` **narrows the set of type-matching candidate beans** so Spring can pick the right one when more than one bean implements the requested type. It is applied _after_ Spring selects candidates by type and _before_ falling back to defaults like `@Primary` or name-based matching.

### Resolution flow

This is what Spring does step by step:

1. **Type-based candidate selection**\
   When an injection point is processed (field, constructor parameter, method parameter), Spring first finds _all beans whose type matches_ the required type. This is the base set of candidates.
2. **Apply qualifier filtering (if present at the injection point)**\
   If the injection point has a `@Qualifier("q")` (or a custom qualifier), Spring **filters the type-matching candidates** to those that have a matching qualifier value (or matching qualifier annotation metadata). Qualifier matching is _performed within the already type-selected candidates_, it isn’t a global name lookup. That’s why `@Qualifier` is a narrowing/filtering mechanism rather than a direct “inject-by-id” command.
3. **Bean-name fallback and injection-point name matching**\
   If no explicit qualifier is present, Spring may consider the _bean name_ (or the injection-point parameter/field name) as a fallback qualifier i.e., the field/parameter name can match a bean id/alias and resolve the ambiguity.
4. **`@Primary` as a fallback preference**\
   If qualifiers (and name matching) don’t resolve the ambiguity but exactly one candidate is annotated `@Primary`, that primary bean will be selected. `@Primary` provides a default when we don’t want to annotate every injection point.
5. **If the candidate set still contains multiple beans → failure**\
   If Spring still sees multiple equally-matching candidates after the above steps, it throws a `NoUniqueBeanDefinitionException` (we must disambiguate with `@Qualifier`, `@Primary`, changing the injection type to a collection, etc.).

### Notes

* **Qualifiers narrow&#x20;**_**within**_**&#x20;type matches** - `@Qualifier` doesn’t change the type-based search; it filters the beans that already match the required type. This is why giving semantic qualifier names (e.g. `"fast"`, `"persistent"`) is recommended over relying on generated bean ids.
* **Qualifier vs bean-name vs `@Primary` precedence**
  * `@Qualifier` is the _explicit_ narrowing mechanism and typically wins over defaults. If we put `@Qualifier` at the injection point, Spring uses that filter first. If no qualifier is present, `@Primary` can act as a tie-breaker. (In short: qualifier narrows first → primary is used if no qualifier and exactly one primary exists → then name matching can apply as a fallback.)
* **Qualifier values are not required to be unique**\
  A qualifier can be used as a **filter** for collections: if we inject `Set<MyType>` and annotate the injection with `@Qualifier("k")`, _all_ beans of `MyType` that carry qualifier `"k"` will be injected into the collection. So qualifiers can select multiple beans, not just a single one.
* **Where we can put qualifiers**\
  `@Qualifier` may be applied to fields, method/constructor parameters, and setter methods - use it wherever we narrow injection. For constructor/multi-arg methods, prefer qualifiers on the parameter level.

## Best Practice

Using `@Qualifier` correctly ensures that Spring injects the intended bean in a clean, maintainable way. Since qualifiers are often introduced when an application grows in complexity, their use should be **strategic**, not haphazard.

#### 1. Use `@Qualifier` for Explicit Disambiguation

Only use `@Qualifier` when we genuinely have multiple beans of the same type. Overuse can make the code verbose and harder to refactor. If there’s only one bean for a type, Spring can inject it automatically without qualifiers.

#### 2. Match Qualifier Value to Bean Definition Intentionally

When using `@Qualifier("beanName")`, ensure that `beanName` matches **how the bean is registered**:

* With `@Component("beanName")`
* With `@Bean(name="beanName")`
* With another `@Qualifier("beanName")` on the bean definition

Avoid relying on Spring’s **default bean naming** (which is typically the class name with a lowercase first letter) in production code - explicit naming is more robust against refactoring.

#### 3. Prefer Semantic Qualifier Names Over Implementation Names

Instead of naming qualifiers after specific implementation classes (e.g., `"fastPaymentService"`), prefer **semantic names** that describe the behavior or purpose, such as `"fast"`, `"reliable"`, or `"cached"`. This decouples our injection logic from specific class names and supports easier refactoring.

#### 4. Combine with `@Primary` for Defaults

When one bean should be the **default** and others are used only in special cases, annotate the default with `@Primary` and apply `@Qualifier` only at injection points that need the alternative. This avoids unnecessary qualifiers on most injection points.

#### 5. Use Custom Qualifier Annotations for Clarity

For complex systems with multiple dimensions of selection, create **custom qualifier annotations** meta-annotated with `@Qualifier`.\
Example:

```java
@Target({ElementType.FIELD, ElementType.PARAMETER, ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
@Qualifier
public @interface PaymentType {
    String value();
}
```

This avoids magic strings and improves readability:

```java
@Autowired
@PaymentType("fast")
private PaymentService service;
```

#### 6. Consider Qualifier Use in Collections and Maps

When injecting `List<T>` or `Map<String, T>`, qualifiers can be used to filter which beans appear in the collection. This is more scalable than injecting single beans repeatedly.

#### 7. Avoid Hidden Conflicts in Large Teams

In large projects with multiple developers, establish **team-wide naming conventions** for qualifiers. Without naming rules, duplicate or conflicting qualifier names can cause subtle injection errors that are hard to trace.

#### 8. Test Bean Resolution Explicitly

When writing integration tests, include tests that verify Spring’s ability to resolve the intended bean with the given qualifiers. This guards against accidental renaming or qualifier removal.

#### 9. Avoid Overlapping Qualifiers

If a bean is annotated with multiple qualifiers and another bean shares one of them, we can unintentionally make the resolution ambiguous again. Keep qualifiers **orthogonal -** one qualifier should clearly distinguish a bean without overlap unless intentionally grouping.

## Example

#### **1. Basic Disambiguation with Multiple Beans**

When multiple beans of the same type exist, `@Qualifier` specifies which one to inject.

```java
@Component("fastPaymentService")
class FastPaymentService implements PaymentService { }

@Component("slowPaymentService")
class SlowPaymentService implements PaymentService { }

@Component
class PaymentController {
    @Autowired
    @Qualifier("fastPaymentService")
    private PaymentService paymentService;
}
```

Here, `fastPaymentService` is injected because the qualifier matches the bean name.

#### **2. Using `@Qualifier` with Constructor Injection**

```java
@Component
class PaymentController {

    private final PaymentService paymentService;

    @Autowired
    public PaymentController(@Qualifier("slowPaymentService") PaymentService paymentService) {
        this.paymentService = paymentService;
    }
}
```

`@Qualifier` can be applied directly to constructor parameters to select a specific bean.

#### **3. Applying `@Qualifier` on Setter Injection**

```java
@Component
class PaymentController {

    private PaymentService paymentService;

    @Autowired
    public void setPaymentService(@Qualifier("fastPaymentService") PaymentService paymentService) {
        this.paymentService = paymentService;
    }
}
```

Setter-based injection works the same way as field and constructor injection.

#### **4. Defining Qualifier at Bean Creation with `@Bean`**

```java
@Configuration
class AppConfig {
    @Bean
    @Qualifier("fast")
    public PaymentService fastPaymentService() {
        return new FastPaymentService();
    }

    @Bean
    @Qualifier("slow")
    public PaymentService slowPaymentService() {
        return new SlowPaymentService();
    }
}
```

The `@Qualifier` values here are used when injecting beans later.

#### **5. Matching Bean Name Without Explicit Qualifier**

If a bean is named with `@Component("fast")`, we can match it with `@Qualifier("fast")` without adding a qualifier annotation at the bean definition level.

```java
@Component("fast")
class FastPaymentService implements PaymentService { }

@Component
class PaymentController {
    @Autowired
    @Qualifier("fast")
    private PaymentService paymentService;
}
```

#### **6. Combining `@Primary` and `@Qualifier`**

```java
@Component
@Primary
class DefaultPaymentService implements PaymentService { }

@Component
class SpecialPaymentService implements PaymentService { }

@Component
class PaymentController {

    @Autowired
    private PaymentService defaultService; // Injects DefaultPaymentService

    @Autowired
    @Qualifier("specialPaymentService")
    private PaymentService specialService; // Explicitly selects the special one
}
```

`@Primary` defines the default, while `@Qualifier` picks a non-default option.

#### **7. Custom Qualifier Annotation**

```java
@Target({ElementType.FIELD, ElementType.PARAMETER, ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
@Qualifier
public @interface PaymentType {
    String value();
}

@Component
@PaymentType("fast")
class FastPaymentService implements PaymentService { }

@Component
@PaymentType("slow")
class SlowPaymentService implements PaymentService { }

@Component
class PaymentController {
    @Autowired
    @PaymentType("fast")
    private PaymentService paymentService;
}
```

This avoids magic strings and makes code self-documenting.

#### **8. Filtering Beans in Collections**

```java
@Component
@Qualifier("fast")
class FastPaymentService implements PaymentService { }

@Component
@Qualifier("slow")
class SlowPaymentService implements PaymentService { }

@Component
class PaymentProcessor {

    @Autowired
    @Qualifier("fast")
    private List<PaymentService> fastServices; // All beans with qualifier "fast"
}
```

`@Qualifier` can select **multiple beans** into a collection.

#### **9. Using `@Qualifier` with `@Bean(name=...)`**

```java
@Configuration
class PaymentConfig {

    @Bean(name = "fastService")
    public PaymentService fastPaymentService() {
        return new FastPaymentService();
    }

    @Bean(name = "slowService")
    public PaymentService slowPaymentService() {
        return new SlowPaymentService();
    }
}

@Component
class PaymentController {
    @Autowired
    @Qualifier("fastService")
    private PaymentService paymentService;
}
```

#### **10. Multiple Attributes in Custom Qualifiers**

```java
@Target({ElementType.FIELD, ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
@Qualifier
public @interface PaymentQualifier {
    String speed();
    String region();
}

@Component
@PaymentQualifier(speed = "fast", region = "US")
class FastUSPaymentService implements PaymentService { }

@Component
class PaymentController {
    @Autowired
    @PaymentQualifier(speed = "fast", region = "US")
    private PaymentService paymentService;
}
```

Spring will match all specified attributes exactly.
