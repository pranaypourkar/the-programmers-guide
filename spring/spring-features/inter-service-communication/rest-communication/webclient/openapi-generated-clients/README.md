# OpenAPI-Generated Clients

## About

OpenAPI-Generated Clients simplify how services in a distributed system communicate by turning API specifications into usable, type-safe client code. This approach aligns with the contract-first paradigm  the API design comes first, and both producers (servers) and consumers (clients) follow that shared contract.

In Spring-based systems, OpenAPI clients can be generated to internally use **WebClient**, offering non-blocking, reactive HTTP communication. This fits naturally with modern microservice architectures that emphasize scalability, observability, and separation of concerns.

**Why this matters**

* Developers can focus on business logic rather than HTTP mechanics.
* APIs are consistent across services, enabling reuse and reducing duplication.
* Changes in the API spec automatically propagate to clients, keeping systems in sync.

## How It Works ?

OpenAPI Generator transforms an OpenAPI spec file into client libraries, with support for many HTTP libraries and frameworks. Here's the life cycle of the client creation process:

#### 1. **API Spec Definition**

* Written in YAML or JSON.
* Describes endpoints, methods, parameters, headers, request/response schemas, error models, and authentication.
* Example: `account-api.yaml` defining `/accounts/{id}` with a `GET` operation.

#### 2. **Code Generation**

* Run via Maven/Gradle plugin, CLI, or CI tool.
* We specify language (`java`), generator (`spring`, `webclient`, etc.), and output folder.
* Code includes:
  * API interfaces or classes (e.g., `AccountApi`)
  * Model classes (e.g., `Account`, `ErrorResponse`)
  * Supporting configuration classes

#### 3. **Client Integration**

* Generated code is added as a dependency in our consuming service.
* Clients are initialized with proper base URLs and injected WebClient.
* Developers use method calls directly (e.g., `accountApi.getAccountById(id)`), not worrying about constructing URLs or parsing responses.

## OpenAPI-Generated Clients vs Manual **WebClient** Configuration

In modern Spring applications, especially those following microservices principles, communication between services is common. Developers can either manually write WebClient-based HTTP calls or rely on **OpenAPI-generated clients**, which use WebClient under the hood but abstract away manual setup. Both approaches have their place the right choice depends on team structure, API governance, and operational priorities.

<table data-header-hidden data-full-width="true"><thead><tr><th width="167.42706298828125"></th><th width="362.22747802734375"></th><th></th></tr></thead><tbody><tr><td><strong>Aspect</strong></td><td><strong>OpenAPI-Generated Clients</strong></td><td><strong>Manual WebClient Configuration</strong></td></tr><tr><td><strong>Approach</strong></td><td>Spec-first (contract-first)</td><td>Code-first</td></tr><tr><td><strong>Client Creation</strong></td><td>Automatically generated from OpenAPI spec</td><td>Manually create WebClient instances and call chains</td></tr><tr><td><strong>Ease of Use</strong></td><td>Easier once set up — clients expose strongly typed method calls</td><td>Developers must build full request structure manually</td></tr><tr><td><strong>Code Repetition</strong></td><td>Minimal duplication across services</td><td>Often duplicated logic for headers, retries, paths, error handling</td></tr><tr><td><strong>Maintenance</strong></td><td>Changes in spec require regeneration and distribution</td><td>Manual edits needed in each service</td></tr><tr><td><strong>Consistency</strong></td><td>Enforced by the spec — parameter names, models, and paths align perfectly</td><td>May drift across services unless enforced by review or policy</td></tr><tr><td><strong>Type Safety</strong></td><td>Full – response/request models are generated</td><td>Manual – error-prone serialization and deserialization</td></tr><tr><td><strong>Mocking for Testing</strong></td><td>Easier due to generated interfaces and models</td><td>Requires custom mocks or wrapper layers</td></tr><tr><td><strong>Error Handling</strong></td><td>Default strategies, but may need to override</td><td>Fully controlled, custom exception flows</td></tr></tbody></table>

## Typical Project Usage

In a typical enterprise Spring Boot project, OpenAPI-generated clients are used to streamline communication between services by eliminating boilerplate WebClient code. These clients are automatically created based on standardized OpenAPI specifications (YAML or JSON), and provide strongly typed, reusable classes for HTTP communication.

#### **1. Service Communication in Microservice Architectures**

**Use Case**: A `payment-service` calls an `account-service` and a `notification-service` using generated clients.

* Each team owns its OpenAPI spec (e.g., `account-api.yaml`, `notification-api.yaml`).
* Specs are versioned and published to a central repository or Git.
* `payment-service` includes those specs as dependencies via Maven or Gradle.
* The build process uses a plugin (like OpenAPI Generator Maven Plugin) to generate client classes using the `spring-webclient` library.
* Calls become as simple as:

```java
AccountApi accountApi = new AccountApi(webClient);
AccountDetailsResponse response = accountApi.getAccountById("acc123").block();
```

This avoids the need to define base URLs, headers, error decoding, or JSON mapping manually.

#### **2. Shared Contract Repositories**

**Pattern**: A team maintains a central **API Contracts Repository** that includes all internal API specs.

* Other services reference it as a Git submodule or use pre-packaged generated clients (published to a Maven repo).
* This promotes **alignment**, especially when services are being consumed by multiple teams.
* API changes trigger client regeneration and publishing in CI pipelines.

#### **3. Integration with External Partners or Public APIs**

**Example**: Integrating with a payment gateway that provides OpenAPI specs.

* Even third-party APIs (Stripe, Razorpay, etc.) can be consumed by generating WebClient-based clients from their OpenAPI definitions.
* This reduces the learning curve for developers and ensures consistency with external contracts.
* Many teams use code generation with custom templates to enforce logging, retry, or security layers during generation.

#### **4. Combined with Interface-Based Abstractions**

In larger projects, the generated client is wrapped inside a **custom interface layer** to avoid tight coupling with the generated code.

```java
public interface AccountServiceClient {
    AccountDetailsResponse getById(String accountId);
}
```

The implementation simply delegates to the OpenAPI-generated client. This pattern supports easier mocking, testing, and future refactoring.

#### **5. Used in CI/CD to Ensure Spec Compatibility**

* Before a service releases a new version, CI pipelines compare current OpenAPI specs with previous versions to ensure backward compatibility.
* Generated clients are part of these pipelines to validate successful client generation and functionality.
* Integration tests use generated stubs or mocks to simulate service interactions.

#### **6. Developer Onboarding and Consistency**

* New developers joining a project don’t need to know the exact HTTP semantics of every service.
* They rely on generated clients and model classes — similar to consuming a Java SDK.
* This enhances **developer velocity** and **reduces runtime bugs** caused by inconsistent path, param, or body construction.

#### **7. Client Generation in Build Pipelines**

Typical flow in a Gradle or Maven project:

* Include the OpenAPI Generator plugin.
* Reference the spec location (local or remote).
* Define package, library (`spring-webclient`), and output paths.
* Optionally, define custom templates for header injection, base classes, logging, etc.

## Drawbacks and Considerations

<table data-header-hidden data-full-width="true"><thead><tr><th width="223.90533447265625"></th><th></th></tr></thead><tbody><tr><td><strong>Concern</strong></td><td><strong>Details</strong></td></tr><tr><td><strong>Regeneration Workflow</strong></td><td>Any spec change needs regeneration and redeployment of clients. Must be part of CI/CD pipelines.</td></tr><tr><td><strong>Template Rigidness</strong></td><td>Generated code structure is dictated by templates; deep customization requires overriding templates.</td></tr><tr><td><strong>Verbose Output</strong></td><td>The generated codebase can be large and cluttered, making navigation harder.</td></tr><tr><td><strong>Debugging Complexity</strong></td><td>Stack traces go through layers of generated classes, making root cause analysis slower.</td></tr><tr><td><strong>Performance Assumptions</strong></td><td>Generated clients may not apply optimal timeouts, retries, or connection pooling by default.</td></tr><tr><td><strong>Mismatch Risk</strong></td><td>If server-side API changes are not reflected in the spec, it can break clients at runtime.</td></tr><tr><td><strong>Versioning Needs</strong></td><td>Spec versions need to be maintained carefully to avoid breaking consumers.</td></tr><tr><td><strong>Onboarding Overhead</strong></td><td>New team members must learn how to work with OpenAPI tooling and codebase organization.</td></tr></tbody></table>

> A good mitigation strategy is to **automate code generation in our build pipeline**, version clients with semantic versioning, and include API compatibility checks during merges or deployments.
