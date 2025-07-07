# Verifying retries with @Retryable

## About

In Spring Boot applications, the `@Retryable` annotation (from **Spring Retry**) allows methods to be retried automatically upon specified exceptions. This is especially useful for transient failures such as network issues, service timeouts, or temporary unavailability of external systems.

During integration testing, it’s often necessary to verify that the retry mechanism works as expected—specifically, that the method is invoked the correct number of times before ultimately failing or succeeding.

## Example

### Actual Source Code

Enable Spring Retry in our main class or any configuration class.

```java
@SpringBootApplication
@EnableRetry
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
```

Create a Service with `@Retryable`

```java
@Service
public class PaymentService {

    @Retryable(value = SomeRetryableException.class, maxAttempts = 3)
    public void abc() {
        throw new SomeRetryableException("Simulated failure");
    }
}
```

Use the Service in a Controller

```java
@RestController
@RequestMapping("/api/v1/payment")
public class PaymentController {

    @Autowired
    private PaymentService paymentService;

    @PostMapping("/notification")
    public ResponseEntity<Void> notifyPayment() {
        paymentService.abc();
        return ResponseEntity.ok().build();
    }
}
```

### Test Class

Write Integration Test to Verify Retries

```java
@SpringBootTest
@AutoConfigureMockMvc
public class PaymentNotificationIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @SpyBean
    private PaymentService paymentService;

    @Test
    void testPaymentNotification_failure() throws Exception {
        mockMvc.perform(MockMvcRequestBuilders.post("/api/v1/payment/notification")
                .contentType(MediaType.APPLICATION_JSON)
                .content(new ObjectMapper().writeValueAsString(getPaymentNotificationRequest()))
                .header(HttpHeaders.AUTHORIZATION, "Bearer test-token"))
            .andExpect(status().is5xxServerError());

        // Assert that the retryable method was called 3 times
        Mockito.verify(paymentService, Mockito.times(3)).abc();
    }

    private PaymentNotificationRequest getPaymentNotificationRequest() {
        // build and return request
    }
}
```

> `@SpyBean` creates a proxy of the real Spring bean and allows us to verify method invocations.

* When the controller is triggered, `paymentService.abc()` is called.
* The method always throws `SomeRetryableException`, which triggers the retry logic.
* Spring Retry attempts the method 3 times (`maxAttempts = 3`).
* `@SpyBean` is used to spy on the real `PaymentService` bean.
* `Mockito.verify(..., times(3))` asserts that the method was retried exactly 3 times.

