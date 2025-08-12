# Unit Testing

## About

**Unit Testing** is the process of verifying the smallest testable components of software—known as “units”—in isolation from the rest of the system.\
A unit can be a single function, method, class, or a small module, depending on the programming language and architecture.

The primary goal is to confirm that each unit behaves exactly as intended under a variety of conditions, including normal inputs, boundary cases, and invalid data.

Unit tests are typically **automated** and run frequently throughout the development cycle, often as part of Continuous Integration (CI). They are generally written and maintained by developers, sometimes in collaboration with testers in a Test-Driven Development (TDD) or Behavior-Driven Development (BDD) environment.

{% hint style="success" %}
**White Box Testing**

White Box Testing, also known as Clear Box or Glass Box Testing, is a method where the tester has complete knowledge of the internal structure, code, and implementation of the software. The focus is on testing internal operations such as code paths, branches, loops, and statements.
{% endhint %}

## Purpose of Unit Testing

* Validate that individual code units work correctly in isolation.
* Detect defects early, before integration with other components.
* Reduce debugging complexity by narrowing failures to specific code blocks.
* Provide fast feedback to developers during active coding.
* Act as living documentation for code behavior and expected inputs/output

## Characteristics of Good Unit Tests

* **Isolated**: No external dependencies such as databases, network calls, or file systems unless explicitly mocked or stubbed.
* **Deterministic**: Produces the same result for the same inputs every time.
* **Fast**: Executes in milliseconds to allow frequent execution.
* **Small in Scope**: Tests only one logical unit at a time.
* **Readable and Maintainable**: Clear purpose and minimal complexity, making it easy to update as the code evolves.

## When to Perform Unit Testing ?

Unit testing is typically performed

* Immediately after writing or modifying a function, method, or class.
* Before code is integrated into the shared codebase (shift-left testing).
* Automatically in CI pipelines, triggered by commits or pull requests.

## Best Practices

* Keep tests independent from each other.
* Use mocks, stubs, or fakes for dependencies.
* Name tests descriptively to reflect the scenario and expected outcome.
* Avoid testing multiple functionalities in a single test case.
* Run unit tests frequently—ideally on every code change.
* Include negative and boundary test cases, not just the happy path.

## Unit Testing Tools and Frameworks

Popular frameworks vary by language:

* **Java**: JUnit, TestNG, Mockito (for mocking)
* **JavaScript/TypeScript**: Jest, Mocha, Jasmine
* **Python**: unittest, pytest
* **C#/.NET**: MSTest, NUnit, xUnit
