# OpenAPI-Generated Clients

## About

OpenFeign is a declarative HTTP client for Java that allows developers to define service communication interfaces with annotations instead of writing boilerplate HTTP request-handling code.\
When combined with **OpenAPI Generator**, Feign clients can be generated automatically from API specifications, enabling consistent, type-safe service-to-service communication without manually coding HTTP logic.

By using **OpenAPI-generated Feign clients**, we can:

* Ensure that our Feign interface exactly matches the contract in the OpenAPI spec.
* Eliminate the risk of discrepancies between API consumers and providers.
* Automatically get typed request/response classes and proper HTTP method annotations.

## How It Works ? <a href="#how-it-works" id="how-it-works"></a>

* **OpenAPI Specification**
  * We start with a `.yaml` or `.json` OpenAPI definition for the API we want to consume.
  * The spec defines endpoints, HTTP methods, request parameters, request/response schemas, etc.
* **Code Generation**
  * Use the OpenAPI Generator (`openapi-generator-maven-plugin` or Gradle equivalent).
  * Specify `java` as the generator and `feign` (or `spring` with `feign` support) as the library.
  * The generated code includes:
    * **Feign client interfaces** with method annotations for endpoints.
    * **Model classes** for requests and responses.
    * **Configuration classes** for Feign.
* **Feign Client Wiring**
  * We register the generated Feign clients as Spring beans (either manually or via `@EnableFeignClients`).
  * Feign automatically implements the interfaces at runtime using HTTP calls.
* **Usage in our Service**
  * Inject the generated interface and call it like a normal Java method.
  * Feign handles request creation, parameter encoding, serialization/deserialization, and error handling.

## OpenAPI-Generated Clients vs Manual Configuration <a href="#openapi-generated-clients-vs-manual-webclient-configuration" id="openapi-generated-clients-vs-manual-webclient-configuration"></a>

<table data-full-width="true"><thead><tr><th width="187.8046875">Aspect</th><th>OpenAPI-Generated Feign Clients</th><th>Manual Feign Configuration</th></tr></thead><tbody><tr><td><strong>Contract Consistency</strong></td><td>Guaranteed to match the OpenAPI spec exactly.</td><td>Risk of divergence if manual definitions are outdated.</td></tr><tr><td><strong>Development Effort</strong></td><td>No need to manually create request/response DTOs or Feign method signatures.</td><td>Must manually define interface, parameters, and DTOs.</td></tr><tr><td><strong>Maintenance</strong></td><td>Regenerate clients automatically when the spec changes.</td><td>Manual updates needed whenever the API changes.</td></tr><tr><td><strong>Type Safety</strong></td><td>Strong typing for parameters and responses based on the spec.</td><td>Strong typing possible but prone to human error.</td></tr><tr><td><strong>Documentation Sync</strong></td><td>Always in sync with the OpenAPI documentation.</td><td>Can become outdated if not maintained in parallel.</td></tr><tr><td><strong>Customization</strong></td><td>Can be extended or wrapped for custom logic.</td><td>Full control from the start, but more boilerplate.</td></tr></tbody></table>

## Typical Project Usage

In real-world Spring Boot projects, **OpenAPI-generated Feign clients** are used in scenarios such as:

1. **Internal Microservice Communication**
   * Example: `payment-service` calling `account-service` using the `account-api-spec`.
   * Specs are versioned and stored in a central Git repository.
   * Client generation happens in the build process.
2. **Integration with Partner APIs**
   * Example: A banking application consuming a partner’s account API.
   * The partner provides the OpenAPI spec.
   * The Feign client is generated and wired into the service.
3. **Contract-First Development**
   * Teams agree on the OpenAPI spec before implementing services.
   * Both client and server stubs are generated from the same spec, ensuring compatibility.
4. **Versioned Client Libraries**
   * Some teams publish the generated clients as reusable Maven artifacts.
   * Other services simply import the dependency without generating code locally.

## Drawbacks and Considerations

While **OpenAPI-generated Feign clients** bring speed and consistency, they also introduce some challenges:

1. **Code Generation Overhead**
   * Requires additional setup in the build pipeline.
   * Generated code may be verbose.
2. **Customization Limitations**
   * Generated Feign clients follow the OpenAPI spec strictly.
   * Complex authentication, retry logic, or dynamic header injection might require wrapping or extending the generated interface.
3. **Version Synchronization**
   * If the API spec changes but the client is not regenerated, it may cause runtime errors.
4. **Large Specs and Compile Time**
   * Very large OpenAPI definitions can generate hundreds of files, increasing build time.
5. **Dependency on Spec Quality**
   * Poorly defined OpenAPI specs (missing examples, unclear schemas) will lead to poor client usability.
6. **Compatibility with Feign Custom Configurations**
   * Generated clients may require additional tuning (e.g., custom error decoders, logging, or interceptors).
