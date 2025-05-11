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

