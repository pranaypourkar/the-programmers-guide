# Use Case of Lazy Initialization

## **Loading Optional Features in a Web Application**

### **Scenario**

In a **Spring Boot e-commerce application**, there is an **email notification service** that sends order confirmation emails. However, this service is **optional**—it should only be initialized when email notifications are enabled.

### **Problem without Lazy Initialization**

If the email notification service is **eagerly initialized**, it loads on **every application startup**, even when the feature is disabled. This increases startup time and unnecessarily loads dependencies like SMTP configurations.

### **Solution with Lazy Initialization**

Mark the email service as **lazy**, ensuring it is only loaded **when actually needed** (i.e., when an order is placed and email notifications are enabled).

**Implementation**

```java
@Component
@Lazy
public class EmailNotificationService {
    
    public EmailNotificationService() {
        System.out.println("EmailNotificationService Initialized");
    }

    public void sendOrderConfirmation(String email, String orderId) {
        System.out.println("Sending order confirmation to: " + email);
    }
}
```

**Usage in Order Processing**

```java
@Service
public class OrderService {
    
    private final EmailNotificationService emailService;

    public OrderService(EmailNotificationService emailService) {
        this.emailService = emailService;
    }

    public void processOrder(String email, String orderId, boolean emailEnabled) {
        System.out.println("Processing Order: " + orderId);
        if (emailEnabled) {
            emailService.sendOrderConfirmation(email, orderId);
        }
    }
}
```

**Behavior**

* If `emailEnabled = false`, the `EmailNotificationService` **never initializes**, saving memory and startup time.
* If `emailEnabled = true`, the service **initializes on demand** and sends the email.

### **Benefits of Lazy Initialization in this Case**

* **Faster Application Startup** – The email service isn’t loaded unless required.
* **Efficient Resource Utilization** – Avoids loading email configurations & SMTP dependencies when not needed.
* **Better Scalability** – Reduces overhead in applications where certain features are optional.
