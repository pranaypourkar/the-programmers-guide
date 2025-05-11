# Spring Code Design

## 1. Is it good to Inject `@Value` variables in **abstract class ?**

Injecting `@Value` variables in an **abstract class** in Spring Boot is **technically possible and works**, but **it’s generally not recommended as a best practice** in most cases.

### When it works ?

Spring can inject `@Value` fields in abstract classes **as long as the subclass is a Spring-managed bean** (i.e., annotated with `@Component`, `@Service`, etc.). For example:

```java
public abstract class BaseHandler {

    @Value("${app.timeout}")
    protected int timeout;
}
```

```java
@Component
public class MyHandler extends BaseHandler {
    // You can use 'timeout' here
}
```

This will work if `MyHandler` is managed by Spring and the `app.timeout` property exists.

### Why it’s generally discouraged ?

1. **Hidden Dependencies**: Abstract classes are usually used for shared logic, and injecting configuration values directly makes them harder to understand, reuse, or test outside of the Spring context.
2. **Poor Separation of Concerns**: Abstract classes should focus on behavior, not configuration wiring. Mixing the two makes your design less clean.
3. **Testability Issues**: It’s harder to mock or inject test values into abstract classes that rely on Spring’s internal injection mechanism.
4. **Tight Coupling to Spring**: You make the abstract class tightly coupled to the Spring environment, reducing its portability and reuse.

### **Recommended Alternative**

Use constructor injection in the concrete class and pass values to the abstract class:

```java
public abstract class BaseHandler {
    protected final int timeout;

    protected BaseHandler(int timeout) {
        this.timeout = timeout;
    }
}
```

```java
@Component
public class MyHandler extends BaseHandler {

    public MyHandler(@Value("${app.timeout}") int timeout) {
        super(timeout);
    }
}
```

This approach keeps the abstract class free of Spring dependencies and improves clarity and testability.

## 2. Can controller method add/modify/remove validation annotations that are not present in the original interface ?

Jakarta Bean Validation **strictly enforces constraint compatibility** in overridden methods (like `@Override` on interface implementations):

* The implementing method **must not add or change constraints** on parameters that are not present in the interface method.

For example:

* `SegmentIntegrationApi#getSegments(...)` (the generated OpenAPI interface) defines the method **without** `@Size(max = 32)` on `List<String> state`
* But our controller method adds it: `List<@Size(max = 32) String> state`

**That's a conflict** — hence the `ConstraintDeclarationException`  will be thrown at runtime.

{% hint style="info" %}
`ConstraintDeclarationException`  with below message

HV000151: A method overriding another method must not redefine the parameter constraint configuration
{% endhint %}

### Solutions

#### **Option 1: Add the same constraint to the OpenAPI interface**

If we own or can customize the OpenAPI spec:

* Modify the OpenAPI spec (YAML/JSON) to include the `maxLength: 32` constraint for each `state` element.
* Then regenerate the interface, which will include the same constraint in the method signature.

#### **Option 2: Do not add constraints in the implementing method**

If we **cannot** change the OpenAPI interface, then remove `@Size(max = 32)` from the controller method. Instead, validate manually in the method body:
