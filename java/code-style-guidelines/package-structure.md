# Package Structure

## About

In Java, **package structure** refers to the organization and hierarchy of packages used to group related classes, interfaces, enums, and sub-packages. A well-designed package structure acts as the backbone of a maintainable, scalable, and understandable codebase.

Packages help manage complexity by modularizing code into logical units. They enable **encapsulation**, **namespace management**, and facilitate **dependency control**. The package hierarchy reflects the architectural design and domain boundaries of the software system.

Organizing code into meaningful packages enhances navigation, discovery, and reuse. It also supports team collaboration by minimizing conflicts and clarifying responsibilities.

## Importance of Package Structure

#### 1. **Improves Code Organization and Modularity**

By grouping related classes and interfaces into packages, developers create modular code units. This makes understanding, maintaining, and testing parts of the system easier, because related functionality is co-located.

#### 2. **Provides Namespace Management**

Java packages prevent naming conflicts by qualifying class names with their package. For example, you can have `com.example.payment.Transaction` and `com.example.order.Transaction` without collision, even though both have a class named `Transaction`.

#### 3. **Supports Encapsulation and Access Control**

Packages control visibility via access modifiers. Classes, methods, and fields with package-private visibility (`default` access) are accessible only within the same package, enforcing encapsulation boundaries.

#### 4. **Facilitates Dependency and Build Management**

Logical package boundaries allow teams to manage dependencies more cleanly and configure build tools more effectively. This is especially critical for large, modular projects or multi-module builds.

#### 5. **Enhances Developer Productivity**

A consistent, intuitive package structure allows developers to find code faster, understand relationships, and avoid confusion. It reduces onboarding time for new team members.

## Principles of Good Package Structure

#### 1. **Reflect the Domain and Business Logic**

Package names and hierarchy should represent real-world domain concepts or business modules, not just technical layers. This domain-driven design approach improves clarity and maintainability.

**Example:**

```
com.companyname.orders
com.companyname.customers
com.companyname.payments
```

#### 2. **Avoid Deeply Nested Packages**

Deep package nesting increases complexity and verbosity. Aim for a balanced depth, typically between 2 to 4 levels, to keep packages meaningful but manageable.

#### 3. **Organize by Feature or Module, Not by Layer Alone**

While layering (controller, service, repository) is important, organizing packages by features or modules often scales better. Each feature package can contain sub-packages for layers if needed.

**Example:**

```
com.companyname.orders.controller
com.companyname.orders.service
com.companyname.orders.repository
```

#### 4. **Use Meaningful, Consistent Names**

Package names should be concise, lowercase, and meaningful, following Java package naming conventions (reverse domain name style). Avoid generic or vague names.

#### 5. **Group Related Classes Together**

Classes that collaborate or share functionality should be placed in the same package to promote cohesion and reduce coupling.

#### 6. **Separate APIs from Implementations**

If your project exposes APIs, consider separating interface packages from their implementations. This allows flexibility and better encapsulation.

**Example:**

```
com.companyname.payment.api
com.companyname.payment.impl
```

#### 7. **Keep Utility and Common Code Separate**

Shared utility classes and helpers should be in dedicated packages like `util` or `common` but avoid overloading them with unrelated code.

## Sample Package Structure

### 1. Modular Monolith with feature-based packaging

```
com.company.projectname
├── ProjectNameApplication.java
│
├── config
│   ├── SecurityConfig.java
│   ├── SwaggerConfig.java
│   └── WebMvcConfig.java
│
├── common
│   ├── exception
│   │   ├── GlobalExceptionHandler.java
│   │   ├── BusinessException.java
│   │   └── ResourceNotFoundException.java
│   ├── util
│   │   ├── DateUtils.java
│   │   ├── JwtUtils.java
│   │   └── FileUtils.java
│   ├── constant
│   │   ├── AppConstants.java
│   │   ├── ErrorCodes.java
│   │   └── RegexPatterns.java
│   ├── enums
│   │   ├── Status.java
│   │   ├── Gender.java
│   │   └── UserRole.java
│   ├── base
│   │   ├── BaseEntity.java
│   │   ├── Identifiable.java
│   │   └── AbstractService.java
│   └── mapper
│       ├── UserMapper.java
│       ├── ProductMapper.java
│       └── OrderMapper.java
│
├── feature
│   ├── user
│   │   ├── controller
│   │   │   └── UserController.java
│   │   ├── service
│   │   │   ├── UserService.java
│   │   │   └── UserServiceImpl.java
│   │   ├── model
│   │   │   ├── User.java
│   │   │   └── Address.java
│   │   ├── repository
│   │   │   └── UserRepository.java
│   │   ├── dto
│   │   │   ├── UserRequest.java
│   │   │   └── UserResponse.java
│   │   └── validation
│   │       ├── EmailValidator.java
│   │       └── UniqueUsernameValidator.java
│
│   ├── product
│   │   ├── controller
│   │   ├── service
│   │   ├── model
│   │   ├── repository
│   │   └── dto
│
│   ├── order
│   │   ├── controller
│   │   ├── service
│   │   ├── model
│   │   ├── repository
│   │   ├── dto
│   │   └── scheduler
│   │       └── OrderCleanupScheduler.java
│
│   ├── payment
│   │   ├── controller
│   │   ├── service
│   │   ├── client
│   │   │   └── ExternalPaymentClient.java
│   │   ├── dto
│   │   │   ├── PaymentRequest.java
│   │   │   └── PaymentResponse.java
│   │   └── event
│   │       ├── PaymentSuccessEvent.java
│   │       └── listener
│   │           └── NotifyUserOnPaymentListener.java
│
│   ├── notification
│   │   ├── service
│   │   └── event
│   │       └── NotificationEventHandler.java
│
│   └── audit
│       ├── model
│       ├── repository
│       └── service
│
└── scheduler
    ├── DailySummaryScheduler.java
    └── OrderRetryScheduler.java
```

### 2. Single Microservice

Assume this microservice handles **"Order Management"**.

```
com.company.ordermanagement
├── OrderManagementApplication.java
│
├── config
│   ├── SwaggerConfig.java
│   ├── SecurityConfig.java
│   ├── WebClientConfig.java
│   └── KafkaConfig.java
│
├── controller
│   ├── OrderController.java
│   └── WebhookController.java
│
├── service
│   ├── OrderService.java
│   ├── OrderServiceImpl.java
│   ├── OrderNotificationService.java
│   └── PaymentSyncService.java
│
├── repository
│   ├── OrderRepository.java
│   └── OrderItemRepository.java
│
├── model
│   ├── entity
│   │   ├── OrderEntity.java
│   │   ├── OrderItemEntity.java
│   │   └── PaymentStatusEntity.java
│   ├── dto
│   │   ├── OrderRequest.java
│   │   ├── OrderResponse.java
│   │   └── PaymentStatusDto.java
│   └── event
│       ├── OrderCreatedEvent.java
│       └── PaymentConfirmedEvent.java
│
├── client
│   ├── PaymentServiceClient.java
│   └── InventoryServiceClient.java
│
├── listener
│   └── KafkaEventListener.java
│
├── util
│   ├── DateUtil.java
│   └── JsonUtil.java
│
├── constant
│   ├── AppConstants.java
│   └── ErrorMessages.java
│
├── enums
│   ├── OrderStatus.java
│   ├── PaymentMode.java
│   └── DeliveryType.java
│
├── exception
│   ├── GlobalExceptionHandler.java
│   ├── OrderNotFoundException.java
│   └── ValidationException.java
│
└── mapper
    ├── OrderMapper.java
    └── PaymentMapper.java
```

**Unit Test Package Structure**

```
src/test/java
└── com.company.ordermanagement
    ├── controller
    │   └── OrderControllerTest.java
    │
    ├── service
    │   ├── OrderServiceTest.java
    │   └── PaymentSyncServiceTest.java
    │
    ├── repository
    │   └── OrderRepositoryTest.java
    │
    ├── client
    │   └── PaymentServiceClientTest.java
    │
    ├── listener
    │   └── KafkaEventListenerTest.java
    │
    ├── mapper
    │   └── OrderMapperTest.java
    │
    ├── util
    │   └── JsonUtilTest.java
    │
    ├── integration
    │   └── OrderPlacementIntegrationTest.java
    │
    └── config
        └── TestContainersConfig.java
```

**Integration Test (IT) Package Structure**

```
src/test/java
└── com.company.ordermanagement
    ├── integration
    │   ├── controller
    │   │   └── OrderControllerIT.java
    │   │
    │   ├── service
    │   │   └── OrderServiceIT.java
    │   │
    │   ├── client
    │   │   └── PaymentServiceClientIT.java
    │   │
    │   ├── repository
    │   │   └── OrderRepositoryIT.java
    │   │
    │   ├── listener
    │   │   └── KafkaListenerIT.java
    │   │
    │   ├── setup
    │   │   ├── TestDataHelper.java
    │   │   └── KafkaTestContainerSetup.java
    │   │
    │   ├── config
    │   │   └── IntegrationTestConfig.java
    │   │
    │   └── EndToEndOrderFlowIT.java
```

