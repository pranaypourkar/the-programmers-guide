# OpenAPI-Generated Clients

## About

OpenAPI-generated clients are HTTP clients automatically created from an OpenAPI (Swagger) specification file. Instead of manually configuring and managing REST clients like `RestTemplate`, you generate strongly-typed client classes that map directly to your service contracts defined in the OpenAPI spec.

These clients abstract the complexity of request creation, serialization, deserialization, error handling, and endpoint management. They help reduce boilerplate code and enforce consistency between service and client.

## How It Works ?

1. **Define the API Contract**:\
   An OpenAPI (YAML or JSON) file defines endpoints, parameters, responses, request bodies, and schemas.
2. **Generate Code**:\
   Tools like OpenAPI Generator, Swagger Codegen, or Gradle/Maven plugins generate client-side code in your language of choice.
3. **Use Generated Client**:\
   The generated classes offer type-safe methods for interacting with remote services, eliminating manual endpoint string construction and request mapping.

## OpenAPI-Generated Clients vs Manual RestTemplate Configuration

<table data-full-width="true"><thead><tr><th width="222.3880615234375">Aspect</th><th width="323.677978515625">OpenAPI-Generated Client</th><th>Manual RestTemplate</th></tr></thead><tbody><tr><td>Setup</td><td>Requires OpenAPI file and code generation setup</td><td>Manual setup of <code>RestTemplate</code> bean</td></tr><tr><td>Endpoint Definition</td><td>Auto-generated methods per endpoint</td><td>Manual string-based URL management</td></tr><tr><td>Data Models</td><td>Generated POJOs matching API schemas</td><td>Manually created DTOs</td></tr><tr><td>Serialization / Deserialization</td><td>Handled internally</td><td>Manually configured message converters</td></tr><tr><td>Error Handling</td><td>Can be auto-handled or customized</td><td>Must handle explicitly via <code>ResponseErrorHandler</code></td></tr><tr><td>Maintainability</td><td>Easier to maintain with contract updates</td><td>High effort in updating method signatures and URLs</td></tr><tr><td>Type Safety</td><td>High; compile-time guarantees</td><td>Lower; string-based, requires defensive checks</td></tr><tr><td>Interceptors / Config</td><td>Can be added via HTTP client</td><td>Custom interceptors added to <code>RestTemplate</code></td></tr><tr><td>Testing</td><td>Can mock client interfaces easily</td><td>Needs manual mocking or wrapper layers</td></tr><tr><td>Asynchronous Support</td><td>Supported via HTTP client options</td><td>Manual integration with <code>CompletableFuture</code>, etc.</td></tr></tbody></table>

## Typical Project Usage

Many enterprise projects define OpenAPI specs as the source of truth. CI pipelines automatically generate and integrate the clients into consumer services.

Teams can:

* Version API clients
* Share clients across teams as artifacts
* Generate clients in different languages (Java for backend, Typescript for frontend)

## Example



