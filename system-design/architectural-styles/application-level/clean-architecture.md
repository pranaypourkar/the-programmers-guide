# Clean Architecture

## About

Clean Architecture is a software design philosophy introduced by Robert C. Martin (Uncle Bob) that emphasizes **separation of concerns**, **independence**, and **testability** in software systems. It aims to create systems that are easy to maintain, scalable, and adaptable to change by organizing code and components into layers with well-defined responsibilities.

The core idea behind Clean Architecture is to design the system so that the **business logic** and **application rules** are at the center of the architecture and do not depend on external frameworks, databases, or UI concerns. This separation allows the core logic to remain unaffected by changes in technology or infrastructure.

At its heart, Clean Architecture promotes **independence** in the following dimensions:

* Independence from frameworks
* Independence from UI
* Independence from databases and external agencies
* Independence from any external agency

## **Separation of Concerns via Layers**

Clean Architecture organizes software into concentric layers, where each layer has a distinct responsibility and communicates only with the layers immediately inside or outside it. The typical layers are:

### **1. Entities (Core Business Rules)**

* This is the **innermost layer** - the heart of our system.
* It contains **business objects and logic** that are critical to our domain.
* Example: If we are building a banking app, entities might be `Account`, `Transaction`, and the rules around them (like calculating interest or validating transactions).
* **Important:** This layer does NOT depend on anything else no databases, UI, or frameworks.

### **2. Use Cases (Application Business Rules)**

* This layer orchestrates **specific application operations**.
* It uses entities to implement business workflows.
* Example: Use case like `TransferFunds` or `GenerateMonthlyStatement` coordinates entities to accomplish a task.
* It still **does not know anything about UI or database** it focuses on the “what” to do, not “how” or “where.”
* Use cases depend on entities but nothing outside them.

### **3. Interface Adapters**

* This layer acts like a **translator or adapter** between the inner business logic and the outside world.
* It converts data from external formats (e.g., JSON, database records) into the format our use cases and entities expect, and vice versa.
* Includes things like:
  * Controllers (handling HTTP requests)
  * Presenters (formatting data for UI)
  * Gateways or Repositories (abstracting data access)
* Example: If our UI sends user input as JSON, the interface adapter converts it into objects our use cases understand.

### **4. Frameworks & Drivers (Outer Layer)**

* This is the **most external layer**, containing frameworks, databases, web UI, third-party libraries, etc.
* Example: React/Angular front-end, MySQL database, external REST APIs.
* These layers **depend on** the layers inside but **do not influence** inner layers.
* If we want to replace a database or UI framework, we should be able to do so without changing our core business rules.

## Dependency Rule

The **Dependency Rule** is the fundamental guideline that governs the relationships between the layers in Clean Architecture. It states:

> “Source code dependencies can only point inward.”

This means:

* **Inner layers cannot depend on outer layers.**\
  The core business logic (Entities and Use Cases) must not know anything about UI, databases, or frameworks.
* **Outer layers can depend on inner layers.**\
  Frameworks, databases, and user interfaces can depend on the business rules, but the reverse is forbidden.

**Why is this important ?**

* It ensures that **business rules remain pure and unaffected** by external changes.
* We can replace UI technologies, databases, or third-party libraries without changing our core logic.
* Promotes **testability** because we can test inner layers without involving outer layers or infrastructure.

**Visualizing the Dependency Rule**

Imagine these concentric circles (from inner to outer):

```
[Entities] <— core business logic  
    ↑  
[Use Cases] <— application-specific rules  
    ↑  
[Interface Adapters] <— convert data and commands to/from outer layers  
    ↑  
[Frameworks & Drivers] <— UI, databases, frameworks
```

**Dependencies can only point inward** - arrows can go from outer layers to inner layers, but never the other way.

**Example Scenario**

* Our `Account` entity should never import or depend on database-specific code or UI frameworks.
* However, our database access code (repository) can use `Account` to persist or retrieve data.
* If we change our database from MySQL to MongoDB, we only change the outer layer our entities remain untouched.

## Independence from Frameworks

One of the key goals of Clean Architecture is to keep the **core business logic independent from any external frameworks or libraries**. Frameworks provide useful tools and services but can impose their own constraints, dependencies, and complexities.

**What does independence from frameworks mean ?**

* **Our business rules (entities and use cases) should not directly depend on any framework code.**
* Frameworks should be treated as tools used only at the outermost layer of our system.
* This separation ensures that our core logic remains **portable, testable, and free from external constraints**.

**Why is this important ?**

* **Flexibility:** We can switch frameworks, upgrade, or replace them without affecting our core application logic.
* **Testability:** Business logic can be tested without needing the framework environment, enabling fast and reliable unit tests.
* **Maintainability:** Reduces coupling, preventing frameworks from “leaking” their complexity into our core design.

**How is it achieved ?**

* Use **interfaces and abstractions** to define contracts in our inner layers.
* Implement these interfaces in the outer layers where frameworks operate.
* For example, if we use a web framework (like Spring or Django), controllers and routing logic live outside the core layers, adapting web requests to our use cases without the core knowing about the framework.

**Example**

* Our business rules define an interface `UserRepository` for data access.
* The actual implementation using a specific ORM or database driver lives in the outer framework layer.
* If we change the ORM or database, only the outer implementation changes; the business rules stay intact.

## Testability

Testability is a core advantage and design goal of Clean Architecture. By organizing code into independent layers and following strict dependency rules, Clean Architecture makes it much easier to write effective and reliable tests.

**Why Testability Matters ?**

* Ensures that **business logic can be verified independently** of UI, databases, or external systems.
* Enables **fast and isolated unit tests** that run without complex setup or integration dependencies.
* Improves **confidence in code correctness** and reduces bugs during development and maintenance.
* Facilitates **continuous integration and delivery** by making automated testing feasible and efficient.

**How Clean Architecture Supports Testability ?**

* **Separation of Concerns:**\
  Business rules reside in inner layers, isolated from infrastructure and frameworks.
* **Dependency Rule:**\
  Inner layers do not depend on outer layers, so we can test them without starting up databases, web servers, or frameworks.
* **Use of Interfaces/Abstractions:**\
  Outer layers implement interfaces defined in inner layers, which can be easily mocked or stubbed during tests.
* **Small, Focused Components:**\
  Each use case or entity can be tested in isolation, focusing purely on business logic.

**Practical Example**

* To test a `TransferFunds` use case, we only need to provide mock implementations of repository interfaces (e.g., mock account storage).
* No need to run the full database or web server stack.
* This reduces test execution time and complexity.

## UI and Database Agnostic

Clean Architecture promotes the design of systems that are **agnostic to user interfaces (UI) and databases**. This means the core business logic and application rules should **not depend on any specific UI technology or database implementation**.

**What Does UI and Database Agnostic Mean ?**

* The system’s core logic is **independent of how data is presented to users (UI)** or **how data is stored and retrieved (database)**.
* UI layers and database layers are treated as **implementation details** that can be changed without impacting business rules.

**Why is This Important ?**

* **Flexibility to Change UI:**\
  We can replace or update the UI technology (web app, mobile app, command-line interface) without touching core logic.
* **Freedom to Change Database:**\
  We can switch databases (SQL, NoSQL, in-memory) or migrate between technologies without affecting our application’s core.
* **Easier Maintenance and Evolution:**\
  Decoupling UI and database concerns reduces ripple effects from changes in technology stacks.
* **Better Testing:**\
  Since core logic is independent, tests can focus on business rules without involving UI or database layers.

**How Is This Achieved ?**

* Define **interfaces or abstractions** for database access (e.g., repository interfaces) and UI interactions.
* Implement these interfaces in outer layers, which communicate with actual UI frameworks or databases.
* Inner layers only deal with **business objects and logic**, unaware of UI components or data storage details.

**Example**

* The `UserService` core logic defines a method like `GetUserProfile(userId)` and relies on a `UserRepository` interface.
* The `UserRepository` interface is implemented by an outer database-specific class, such as `PostgresUserRepository` or `MongoUserRepository`.
* Similarly, the UI layer could be a React app, a mobile app, or a CLI — all consuming the same core services without the core knowing their specifics.

## Benefits of Clean Architecture

Clean Architecture offers a robust framework for building software systems that stand the test of time by promoting clear separation of concerns and independence from technology choices. The main benefits include:

**1. Maintainability**

* Changes in business rules or features only require modifications to the core layers without impacting UI, databases, or frameworks.
* Codebase stays organized and easier to understand, reducing technical debt over time.

**2. Testability**

* Business logic can be tested independently with unit tests, without relying on external systems like databases or UI frameworks.
* Facilitates fast, reliable, and isolated tests that improve software quality and speed up development.

**3. Flexibility & Adaptability**

* The system is resilient to changes in external technologies.
* We can swap out databases, UI frameworks, or third-party services with minimal changes to the core logic.

**4. Scalability**

* Separation of concerns allows different teams to work independently on UI, business logic, and infrastructure.
* Modular design supports scaling the system both technically and organizationally.

**5. Independent Deployment**

* Changes can be made and deployed to individual layers or components without a full system rewrite.
* Supports incremental upgrades and microservices-style architectures.

**6. Clearer Architecture**

* Provides a well-defined structure that promotes consistency and clarity across projects.
* Easier onboarding for new developers due to predictable organization.

**7. Improved Collaboration**

* Clear boundaries between layers facilitate collaboration between developers, testers, and business analysts.
* Each team can focus on their domain without tight coupling.

**8. Longevity**

* Systems built with Clean Architecture are more resistant to becoming obsolete.
* Business rules remain stable even as technologies evolve.

## Example code snippet to illustrate Clean Architecture

### Bank Account Transfer

1\. Entity Layer - Core Business Logic

```java
// Entity: Account.java
public class Account {
    private String id;
    private double balance;

    public Account(String id, double balance) {
        this.id = id;
        this.balance = balance;
    }

    public void withdraw(double amount) {
        if (balance < amount) {
            throw new IllegalArgumentException("Insufficient funds");
        }
        balance -= amount;
    }

    public void deposit(double amount) {
        balance += amount;
    }

    public double getBalance() {
        return balance;
    }

    public String getId() {
        return id;
    }
}
```

2\. Use Case Layer - Application Business Rules

```java
// Use Case: TransferFunds.java
public class TransferFunds {
    private AccountRepository accountRepository;

    public TransferFunds(AccountRepository accountRepository) {
        this.accountRepository = accountRepository;
    }

    public void execute(String fromAccountId, String toAccountId, double amount) {
        Account from = accountRepository.findById(fromAccountId);
        Account to = accountRepository.findById(toAccountId);

        from.withdraw(amount);
        to.deposit(amount);

        accountRepository.save(from);
        accountRepository.save(to);
    }
}

// Repository Interface defined in use case layer
interface AccountRepository {
    Account findById(String accountId);
    void save(Account account);
}
```

3\. Interface Adapter Layer - Implementation of Repository

```java
// Infrastructure Layer: InMemoryAccountRepository.java
import java.util.HashMap;
import java.util.Map;

public class InMemoryAccountRepository implements AccountRepository {
    private Map<String, Account> accounts = new HashMap<>();

    @Override
    public Account findById(String accountId) {
        return accounts.get(accountId);
    }

    @Override
    public void save(Account account) {
        accounts.put(account.getId(), account);
    }
}
```

4\. Frameworks & Drivers Layer - Example Usage

```java
public class Main {
    public static void main(String[] args) {
        AccountRepository repository = new InMemoryAccountRepository();

        // Setup initial accounts
        repository.save(new Account("A1", 1000));
        repository.save(new Account("A2", 500));

        TransferFunds transferFunds = new TransferFunds(repository);
        transferFunds.execute("A1", "A2", 200);

        System.out.println("A1 balance: " + repository.findById("A1").getBalance()); // 800
        System.out.println("A2 balance: " + repository.findById("A2").getBalance()); // 700
    }
}
```

#### Key Points:

* **Entities** (Account) have no dependencies outside core business rules.
* **Use Cases** (TransferFunds) depend on abstractions (`AccountRepository`), not implementations.
* **Interface Adapters** provide concrete implementations (InMemoryAccountRepository).
* Outer layers depend on inner layers; inner layers have no knowledge of outer layers.
