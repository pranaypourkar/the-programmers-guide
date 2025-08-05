# Functional Testing

## About

Functional testing involves testing the application against the business requirements. It focuses on verifying that the software functions as intended according to the requirements. This type of testing checks the actions and operations of the software to ensure that each feature works correctly.

## Types of Functional Testing

### **1. Unit Testing**

Tests individual components or pieces of code (usually functions or methods) in isolation. Developers in a test-driven environment will typically write and run the tests prior to the software or feature being passed over to the test team. Unit testing can be conducted manually, but automating the process will speed up delivery cycles and expand test coverage.

For example, there is a simple calculator application. The developer can write the unit test to check if the user can enter two numbers and get the correct sum for addition functionality.

### **2. Integration Testing**

It tests the interaction between integrated units/modules to ensure they work together as expected. After each unit is thoroughly tested, it is integrated with other units to create modules or components that are designed to perform specific tasks or activities. These are then tested as group through integration testing to ensure whole segments of an application behave as expected (i.e, the interactions between units are seamless). These tests are often framed by user scenarios, such as logging into an application or opening files.

For example, a user is buying a flight ticket from any airline website. Users can see flight details and payment information while buying a ticket, but flight details and payment processing are two different systems. Integration testing should be done while integrating of airline website and payment processing system.

**Tools**: JUnit, NUnit, TestNG, Selenium, TestContainers

### **3. System Testing**

Tests the complete and fully integrated software product to evaluate the system's compliance with its requirements. The functionality of the software is tested from end-to-end and is typically conducted by a separate testing team than the development team before the product is pushed into production.

For example, a tester is testing a health insurance website. End to End testing involves testing of buying an insurance policy, adding another beneficiary, updating credit card information on users’ accounts, updating user address information, receiving order confirmation emails and policy documents.

**Tools**: Selenium, LoadRunner, Manual Testing.

### **4. Acceptance Testing**

Acceptance testing is the last phase of functional testing and is used to assess whether or not the final piece of software is ready for delivery. It involves ensuring that the product is in compliance with all of the original business criteria and that it meets the end user’s needs. This requires the product be tested both internally and externally, meaning we’ll need to get it into the hands of the end users for beta testing along with those of the QA team. Beta testing is key to getting real feedback from potential customers and can address any final usability concerns.

The client accepts the software only when all the features and functionalities work as expected. This is the last phase of testing, after which the software goes into production.

**Types**:

* **User Acceptance Testing (UAT)**: Conducted by end-users to ensure the software meets their needs.
* **Operational Acceptance Testing (OAT)**: Ensures system's operational readiness (such as maintenance, backup, and disaster recovery).

**Tools**: Cucumber, Manual Testing
