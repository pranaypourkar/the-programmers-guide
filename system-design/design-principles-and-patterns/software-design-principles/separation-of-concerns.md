# Separation of Concerns

## About

**Separation of Concerns (SoC)** is a fundamental software design principle that advocates dividing a system into distinct sections, each responsible for a **specific, well-defined concern**.\
A _concern_ refers to a particular aspect of the system’s functionality, such as data persistence, business logic, user interface, logging, or security.

The main idea is that **each concern should be handled by its own module, component, or layer**, without overlapping responsibilities.\
This makes the system easier to understand, maintain, and extend because changes in one concern are less likely to affect others.

Common examples of SoC in practice include:

* **MVC (Model-View-Controller)** architecture separating data, UI, and control flow.
* **Layered architecture** separating presentation, application, domain, and infrastructure logic.
* **Microservices** separating business capabilities into independent services.

## Why It Matters ?

Applying Separation of Concerns leads to **cleaner, more modular systems** with clear boundaries between different parts of the application.

Key benefits include:

* **Improved Maintainability** – Changes in one concern (e.g., UI redesign) don’t require rewriting unrelated concerns (e.g., database code).
* **Better Testability** – We can test each concern in isolation without worrying about unrelated dependencies.
* **Easier Collaboration** – Teams can work on different concerns in parallel without stepping on each other’s code.
* **Enhanced Reusability** – Well-isolated concerns can be reused in other projects or contexts.
* **Reduced Risk of Bugs** – Limiting the scope of change prevents unintended side effects in unrelated areas.

In short, SoC **reduces complexity** by breaking the system into manageable, focused parts, making it a cornerstone of scalable, maintainable software design.

## Common Violations

* **Mixing Business Logic with Presentation Logic**
  * Example: Writing database queries directly inside UI event handlers.
  * Effect: Any change to UI design risks breaking business logic.
* **Tightly Coupled Modules**
  * Components directly depend on each other’s internal implementation details instead of using clear interfaces.
* **Overloaded Classes or Functions**
  * “God classes” or “utility classes” that handle multiple unrelated responsibilities.
* **Hard‑Coded Dependencies**
  * Embedding service URLs, credentials, or configurations directly into business logic.
* **Poor Layer Boundaries**
  * Application layers that leak responsibilities - e.g., persistence layer performing request validation.
* **Feature Logic Spread Across Multiple Unrelated Places**
  * A single business rule is partially implemented in UI, partially in API, and partially in database triggers, without a central source of truth.

## How to Apply Separation of Concerns ?

#### **1. Identify Distinct Concerns**

* Start by listing major responsibilities in our application—UI, persistence, domain logic, configuration, logging, security, etc.
* Group related functionality together and ensure each group has a **clear, single purpose**.

#### **2. Use Layered Architecture**

* Common pattern:
  * **Presentation Layer** – UI and API endpoints
  * **Business Logic Layer** – Core application rules
  * **Data Access Layer** – Database interaction
  * **Infrastructure Layer** – External services, messaging, caching
* Each layer should depend **only** on the layer below it, not on unrelated concerns.

#### **3. Apply Modularity**

* Split code into modules, packages, or microservices based on responsibility.
* Keep module boundaries clean—avoid “reaching into” another module’s internals.

#### **4. Use Interfaces and Abstractions**

* Define contracts for how different concerns interact.
* Example: Use a `UserRepository` interface instead of embedding SQL in our business logic.

#### **5. Centralize Cross‑Cutting Concerns**

* Logging, authentication, and error handling are common cross‑cutting concerns.
* Implement them using middleware, interceptors, or aspects rather than duplicating them across modules.

#### **6. Apply MVC or MVVM for UI Apps**

* Keep **Model** (data), **View** (UI), and **Controller/ViewModel** (logic) separate.
* Prevent data logic from leaking into the view layer.

#### **7. Enforce Boundaries with Code Reviews**

* During pull requests, check whether a module is doing something outside its responsibility.
* Ask: _“If I change this requirement, should it really require editing this file?”_

## Example

**Violation (Poor Separation of Concerns)**

```java
public class UserController {

    public void createUser(String username, String email) {
        // Validate input
        if (username == null || username.isEmpty()) {
            throw new IllegalArgumentException("Username required");
        }

        // Direct database logic in controller
        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/app", "root", "pass")) {
            PreparedStatement stmt = conn.prepareStatement("INSERT INTO users (username, email) VALUES (?, ?)");
            stmt.setString(1, username);
            stmt.setString(2, email);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Send confirmation email
        EmailService.send(email, "Welcome!", "Thanks for registering.");
    }
}
```

**Issues**

* Controller mixes validation, persistence, and email notification logic.
* Changes in database or email service affect controller code.

**Applied Separation of Concerns**

```java
// Controller
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    public void createUser(String username, String email) {
        userService.registerUser(username, email);
    }
}

// Service
public class UserService {

    private final UserRepository repository;
    private final EmailService emailService;

    public UserService(UserRepository repository, EmailService emailService) {
        this.repository = repository;
        this.emailService = emailService;
    }

    public void registerUser(String username, String email) {
        if (username == null || username.isEmpty()) {
            throw new IllegalArgumentException("Username required");
        }
        repository.save(new User(username, email));
        emailService.send(email, "Welcome!", "Thanks for registering.");
    }
}

// Repository
public interface UserRepository {
    void save(User user);
}
```

**Benefits**

* Each layer focuses on its own concern.
* Changing the database or email provider doesn’t affect the controller.
* Easier to test each component in isolation.

## When Not to Apply Separation of Concerns ?

While SoC is a cornerstone principle, there are scenarios where **strict enforcement** can cause more harm than good.

#### **1. In Very Small or Throwaway Projects**

For a small script or prototype, adding multiple layers may slow us down without adding real value.

#### **2. When Abstraction Becomes Overhead**

Over‑separating can lead to excessive indirection—simple changes might require editing too many files, hurting productivity.

#### **3. When Performance Is Critical**

Sometimes combining layers or concerns in performance‑critical paths can remove method calls or abstraction overhead, improving speed.

#### **4. For Temporary Code**

If a piece of code is expected to be replaced soon (e.g., temporary ETL migration scripts), heavy separation may be wasted effort.

#### **5. When It Obscures the Logic**

Over‑splitting concerns into dozens of small classes or files can make it harder to follow the flow of execution.
