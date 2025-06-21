# Mocking @Value

## About

In Spring Boot applications, `@Value("${...}")` is commonly used to inject values from configuration properties. While this is convenient during runtime, testing code that depends on `@Value` fields requires special handling — especially when we want to **mock or override** these values during unit or integration tests.

## What is `@Value`?

In Spring Boot, the `@Value` annotation is used to inject values from `application.properties`, environment variables, or system properties.

```java
@Value("${scope.stepup.otp}")
private String stepUpOtpScope;
```

## **Unit Testing (No Spring Context)**

In unit tests, we don't start the Spring container, so dependency injection via `@Value` won't happen automatically. We have two options:

### **1. Set the Field via Reflection (Private Fields)**

If the field is `private`, use Java reflection:

```java
public class MyService {
    @Value("${scope.stepup.otp}")
    private String stepUpOtpScope;

    public String getScope() {
        return stepUpOtpScope;
    }
}
```

```java
@Test
void testStepUpOtpScopeUsingReflection() throws Exception {
    MyService service = new MyService();

    Field field = MyService.class.getDeclaredField("stepUpOtpScope");
    field.setAccessible(true);
    field.set(service, "mock-scope");

    assertEquals("mock-scope", service.getScope());
}
```

### **2. Use a Constructor or Setter (Public Fields or Refactored Code)**

A better design is to inject properties via constructor or setter, which makes mocking easier:

```java
public class MyService {
    private final String stepUpOtpScope;

    public MyService(String stepUpOtpScope) {
        this.stepUpOtpScope = stepUpOtpScope;
    }

    public String getScope() {
        return stepUpOtpScope;
    }
}
```

#### **Option 1: Use `@Component` + `@Value` on Constructor Parameter**

```java
@Component
public class MyService {
    private final String stepUpOtpScope;

    public MyService(@Value("${scope.stepup.otp}") String stepUpOtpScope) {
        this.stepUpOtpScope = stepUpOtpScope;
    }

    public String getScope() {
        return stepUpOtpScope;
    }
}
```

#### **Option 2: Use `@Bean` Method in Configuration Class**

If `MyService` is not annotated with `@Component`, we can define a `@Bean` ourself:

```java
@Configuration
public class MyServiceConfig {

    @Value("${scope.stepup.otp}")
    private String stepUpOtpScope;

    @Bean
    public MyService myService() {
        return new MyService(stepUpOtpScope);
    }
}
```

```java
@Test
void testUsingConstructorInjection() {
    MyService service = new MyService("mock-scope");
    assertEquals("mock-scope", service.getScope());
}
```

## **Integration Testing (Using Spring Context)**

When writing Spring Boot integration tests using `@SpringBootTest`, Spring will inject `@Value` properties. To override them:

### **1. Use `@TestPropertySource` or Spring Profiles**

```java
@SpringBootTest
@TestPropertySource(properties = {
    "scope.stepup.otp=mock-scope"
})
class MyServiceIntegrationTest {

    @Autowired
    private MyService myService;

    @Test
    void testInjectedValue() {
        assertEquals("mock-scope", myService.getScope());
    }
}
```

### **2. Use `@DynamicPropertySource` (for dynamic values or Testcontainers)**

Use this when we need to set properties programmatically at runtime (common in integration tests with Testcontainers):

```java
@SpringBootTest
@Testcontainers
class MyServiceIntegrationTest {

    @Container
    static GenericContainer<?> container = new GenericContainer<>("some-image").withExposedPorts(1234);

    @DynamicPropertySource
    static void overrideProperties(DynamicPropertyRegistry registry) {
        registry.add("scope.stepup.otp", () -> "mock-dynamic-scope");
    }

    @Autowired
    private MyService myService;

    @Test
    void testDynamicValue() {
        assertEquals("mock-dynamic-scope", myService.getScope());
    }
}
```

