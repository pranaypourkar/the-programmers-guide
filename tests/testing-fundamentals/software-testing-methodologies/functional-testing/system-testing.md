# System Testing

## About

**System Testing** is the process of verifying the behavior of an entire, integrated application in an environment that closely resembles production.\
Unlike unit or integration testing, which focus on parts of the system or their interactions, system testing validates the complete end-to-end functionality, performance, and compliance of the system against defined requirements.

This level of testing treats the software as a **black box** focusing on inputs and outputs rather than internal code structure. It can encompass both functional testing (validating what the system does) and non-functional testing (evaluating how well it performs, such as speed, scalability, and security).

{% hint style="success" %}
**End to End Testing**

It involves testing a complete application environment in a situation that mimics real-world use, such as interacting with a database, using network communications, or interacting with other hardware, applications, or systems if appropriate.

**Black Box Testing**

Blackbox testing is a software testing technique in which testing is performed without knowing the internal structure, design, or code of a system under test. Testers should focus only on the input and output of test objects.

**Smoke Testing**

Smoke testing is performed to verify that basic and critical functionality of the system under test is working fine at a very high level. Whenever a new build is provided by the development team, then the Software Testing team validates the build and ensures that no major issue exists. The testing team will ensure that the build is stable, and a detailed level of testing will be carried out further.

**Sanity Testing**

Sanity testing is performed on a system to verify that newly added functionality or bug fixes are working fine. Sanity testing is done on stable build. It is a subset of the regression test.

For example, a tester is testing a health insurance website. There is a change in the discount for buying a policy for second member. Then sanity testing is only performed on buying insurance policy module.

**Regression Testing**

It is performed to verify that new code changes do not adversely affect the existing functionality of the software.

**Happy path Testing**

The objective of Happy Path Testing is to test an application successfully on a positive flow. It does not look for negative or error conditions. The focus is only on valid and positive inputs through which the application generates the expected output.

**Monkey Testing**

Monkey Testing is carried out by a tester, assuming that if the monkey uses the application, then how random input and values will be entered by the Monkey without any knowledge or understanding of the application.

The objective of Monkey Testing is to check if an application or system gets crashed by providing random input values/data. Monkey Testing is performed randomly, no test cases are scripted, and it is not necessary to be aware of the full functionality of the system.
{% endhint %}

## Purpose of System Testing

* Verify that the complete system meets business and technical requirements.
* Ensure that all integrated components, including third-party services, work together correctly.
* Detect defects that only surface when the entire system is operational.
* Validate readiness for user acceptance testing and production deployment.
* Confirm compliance with regulatory, contractual, or operational constraints.

## Characteristics of Good System Tests

* **End-to-End Coverage**: Exercises full workflows across multiple modules and integrations.
* **Environment Parity**: Runs in a test or staging environment that mirrors production configurations.
* **Realistic Data and Scenarios**: Uses representative datasets and operational scenarios to simulate real-world use.
* **Combination of Functional and Non-Functional Checks**: Includes validations for correctness, performance, usability, and security.
* **Black-Box Approach**: Focuses on what the system should do, not how it’s implemented internally.

## When to Perform System Testing ?

System testing is typically performed:

* After all components have passed integration testing.
* Before user acceptance testing to confirm overall quality.
* Prior to major releases or production deployments.
* After significant architectural changes, system migrations, or large-scale refactors.
* When validating compliance or certification requirements.

## Best Practices

* **Establish Clear Test Objectives**: Align test scenarios with business workflows and quality attributes.
* **Mirror Production Environments**: Use equivalent configurations, network settings, and security controls.
* **Include Both Functional and Non-Functional Tests**: Test not just correctness but also performance, scalability, security, and usability.
* **Automate Where Feasible**: Use automation for repeatable system tests, especially for regression testing.
* **Control Test Data**: Use a well-prepared dataset to avoid false positives/negatives.
* **Monitor System Behavior**: Track logs, metrics, and error rates during test execution for deeper analysis.
* **Coordinate Across Teams**: System testing often involves multiple teams (QA, DevOps, business stakeholders).

## &#x20;System Testing Tools and Frameworks

System testing often combines multiple tool types, depending on what’s being validated:

* **Functional End-to-End Testing**
  * Selenium, Cypress, Playwright for web UI workflows.
  * Appium for mobile app workflows.
* **API and Service Layer Testing**
  * REST Assured, Postman/Newman for RESTful APIs.
  * SoapUI for SOAP services.
* **Performance & Load Testing**
  * JMeter, Gatling, k6 for measuring system performance at scale.
* **Security Testing**
  * OWASP ZAP, Burp Suite for vulnerability scanning.
* **Environment Simulation**
  * Docker Compose or Kubernetes test clusters for staging environments.
  * Testcontainers for dependent service emulation (databases, queues, external APIs).
