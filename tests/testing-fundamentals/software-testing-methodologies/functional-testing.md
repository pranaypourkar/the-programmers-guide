# Functional Testing

## Description

Functional testing involves testing the application against the business requirements. It focuses on verifying that the software functions as intended according to the requirements. This type of testing checks the actions and operations of the software to ensure that each feature works correctly.&#x20;

## Types of Functional Testing:

### **1. Unit Testing**:

**Description**: Tests individual components or pieces of code (usually functions or methods) in isolation. Developers in a test-driven environment will typically write and run the tests prior to the software or feature being passed over to the test team. Unit testing can be conducted manually, but automating the process will speed up delivery cycles and expand test coverage.

For example, there is a simple calculator application. The developer can write the unit test to check if the user can enter two numbers and get the correct sum for addition functionality.

**Tools**: JUnit, NUnit, TestNG.

{% hint style="info" %}
**White Box Testing**

White Box Testing, also known as Clear Box or Glass Box Testing, is a method where the tester has complete knowledge of the internal structure, code, and implementation of the software. The focus is on testing internal operations such as code paths, branches, loops, and statements.
{% endhint %}

### **2. Integration Testing**:

**Description**: It tests the interaction between integrated units/modules to ensure they work together as expected. After each unit is thoroughly tested, it is integrated with other units to create modules or components that are designed to perform specific tasks or activities. These are then tested as group through integration testing to ensure whole segments of an application behave as expected (i.e, the interactions between units are seamless). These tests are often framed by user scenarios, such as logging into an application or opening files.

For example, a user is buying a flight ticket from any airline website. Users can see flight details and payment information while buying a ticket, but flight details and payment processing are two different systems. Integration testing should be done while integrating of airline website and payment processing system.

**Tools**: JUnit, NUnit, TestNG, Selenium, TestContainers

{% hint style="info" %}
**Gray Box Testing**

Gray Box Testing is a method where the tester has partial knowledge of the internal workings of the software. This approach combines elements of both Black Box and White Box testing. The tester might have access to some architectural documents, database diagrams, or code.
{% endhint %}

### **3. System Testing**:

**Description**: Tests the complete and fully integrated software product to evaluate the system's compliance with its requirements. The functionality of the software is tested from end-to-end and is typically conducted by a separate testing team than the development team before the product is pushed into production.

For example, a tester is testing a health insurance website. End to End testing involves testing of buying an insurance policy, adding another beneficiary, updating credit card information on users’ accounts, updating user address information, receiving order confirmation emails and policy documents.

**Tools**: Selenium, LoadRunner, Manual Testing.

{% hint style="info" %}
**End to End Testing**

It involves testing a complete application environment in a situation that mimics real-world use, such as interacting with a database, using network communications, or interacting with other hardware, applications, or systems if appropriate.

**Black Box Testing**

Blackbox testing is a software testing technique in which testing is performed without knowing the internal structure, design, or code of a system under test. Testers should focus only on the input and output of test objects.

**Smoke Testing**

Smoke testing is performed to verify that basic and critical functionality of the system under test is working fine at a very high level. Whenever a new build is provided by the development team, then the Software Testing team validates the build and ensures that no major issue exists. The testing team will ensure that the build is stable, and a detailed level of testing will be carried out further.

**Sanity Testing**

Sanity testing is performed on a system to verify that newly added functionality or bug fixes are working fine. Sanity testing is done on stable build. It is a subset of the regression test.

For example, a tester is testing a health insurance website. There is a change in the discount for buying a policy for second member. Then sanity testing is only performed on buying insurance policy module.

**Regression Testing**:

It is performed to verify that new code changes do not adversely affect the existing functionality of the software.

**Happy path Testing**

The objective of Happy Path Testing is to test an application successfully on a positive flow. It does not look for negative or error conditions. The focus is only on valid and positive inputs through which the application generates the expected output.

**Monkey Testing**

Monkey Testing is carried out by a tester, assuming that if the monkey uses the application, then how random input and values will be entered by the Monkey without any knowledge or understanding of the application.

The objective of Monkey Testing is to check if an application or system gets crashed by providing random input values/data. Monkey Testing is performed randomly, no test cases are scripted, and it is not necessary to be aware of the full functionality of the system.
{% endhint %}

### **4. Acceptance Testing**:

**Description**: Acceptance testing is the last phase of functional testing and is used to assess whether or not the final piece of software is ready for delivery. It involves ensuring that the product is in compliance with all of the original business criteria and that it meets the end user’s needs. This requires the product be tested both internally and externally, meaning we’ll need to get it into the hands of the end users for beta testing along with those of the QA team. Beta testing is key to getting real feedback from potential customers and can address any final usability concerns.

The client accepts the software only when all the features and functionalities work as expected. This is the last phase of testing, after which the software goes into production.

**Types**:

* **User Acceptance Testing (UAT)**: Conducted by end-users to ensure the software meets their needs.
* **Operational Acceptance Testing (OAT)**: Ensures system's operational readiness (such as maintenance, backup, and disaster recovery).

**Tools**: Cucumber, Manual Testing

{% hint style="info" %}
**Alpha Testing**

Alpha testing is a type of acceptance testing performed by the team in an organization to find as many defects as possible before releasing software to customers.

For example, the health insurance website is under UAT. UAT team will run real-time scenarios like buying an insurance policy, buying annual membership, changing the address, ownership transfer of the user in a same way the user uses the real website. The team can use test credit card information to process payment-related scenarios.

**Beta Testing**

Beta Testing is a type of software testing which is carried out by the clients/customers. It is performed in the Real Environment before releasing the product to the market for the actual end-users.

Beta Testing is carried out to ensure that there are no major failures in the software or product, and it satisfies the business requirements from an end-user perspective. Beta Testing is successful when the customer accepts the software.

Usually, this testing is typically done by the end-users. This is the final testing done before releasing the application for commercial purposes. Usually, the Beta version of the software or product released is limited to a certain number of users in a specific area.
{% endhint %}

