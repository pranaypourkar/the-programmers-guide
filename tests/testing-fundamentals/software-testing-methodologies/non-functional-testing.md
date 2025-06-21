# Non Functional Testing

## Description

Non-Functional Testing focuses on the operational aspects of a software application, such as performance, usability, reliability, etc. This type of testing ensures that the software meets certain criteria that aren't related to specific behaviors or functions.

## Types of Non-Functional Testing:

### **Performance Testing**:

**Description**: It is a technique used to determine how an application will behave under various conditions. The goal is to test its responsiveness and stability in real user situations. It evaluates the speed, responsiveness, and stability of the software under various conditions.

**Sub-types**:

* **Load Testing**: Tests the software’s performance under expected load. It is the process of putting increasing amounts of simulated demand on the software, application, or website to verify whether or not it can handle what it’s designed to handle.\
  For example, an application handles 100 users at a time with a response time of 3 seconds, then load testing can be done by applying a load of the maximum of 100 or less than 100 users. The goal is to verify that the application is responding within 3 seconds for all the users
*   **Stress Testing**: Tests the software under extreme conditions. It is used to gauge how the software will respond at or beyond its peak load. The goal of stress testing is to overload the application on purpose until it breaks by applying both realistic and unrealistic load scenarios. With stress testing, we’ll be able to find the failure point of our piece of software.

    For example, an application handles 1000 users at a time with a response time of 4 seconds, then stress testing can be done by applying a load of more than 1000 users. Test the application with 1100, 1200, 1300 users and notice the response time. The goal is to verify the stability of an application under stress.
* **Spike Testing**: Tests the software’s performance with sudden increases in load. It is a type of load test used to determine how the software will respond to substantially larger bursts of concurrent user or system activity over varying amounts of time. Ideally, this will help understand what will happen when the load is suddenly and drastically increased.
*   **Endurance Testing (or Soak testing**): Tests the software under sustained load over a long period. It is used to analyze the behavior of an application under a specific amount of simulated load over longer amounts of time. The goal is to understand how the system will behave under sustained use, making it a longer process than load or stress testing (which are designed to end after a few hours). A critical piece of endurance testing is that it helps uncover memory leaks.

    For example, car companies perform soak testing to verify that users can drive cars continuously for hours without any problem.

**Tools**: JMeter, LoadRunner.

### **Scalability Testing**

**Description:** Scalability testing is testing an application’s stability and response time by applying load, which is more than the designed number of users for an application.

For example, an application handles 1000 users at a time with a response time of 2 seconds, then scalability testing can be done by applying a load of more than 1000 users and gradually increasing the number of users to find out where exactly application is crashing.

Let’s say an application is giving response time as follows:

1000 users -2 sec\
1400 users -2 sec\
4000 users -3 sec\
5000 users -45 sec\
5150 users- crash – This is the point that needs to identify in scalability testing

**Tools**: JMeter, LoadRunner.

### **Usability Testing**:

**Description**: Assesses how easy and user-friendly the software is. Usability testing is a testing method that measures an application’s ease-of-use from the end-user perspective and is often performed during the system or acceptance testing stages. The goal is to determine whether or not the visible design and aesthetics of an application meet the intended workflow for various processes, such as logging into an application. Usability testing is a great way for teams to review separate functions, or the system as a whole, is intuitive to use.

For example, there is a mobile app for stock trading, and a tester is performing usability testing. Testers can check the scenario like if the mobile app is easy to operate with one hand or not, scroll bar should be vertical, background color of the app should be black and price of and stock is displayed in red or green color.

**Tools**: Crazy Egg, Optimizely.

{% hint style="info" %}
**Exploratory testing**

Exploratory Testing is informal testing performed by the testing team. The objective of this testing is to explore the application and look for defects that exist in the application. Testers use the knowledge of the business domain to test the application. Test charters are used to guide the exploratory testing.

**Cross browser testing**

Cross browser testing is testing an application on different browsers, operating systems, mobile devices to see look and feel and performance. Different users use different operating systems, different browsers, and different mobile devices. The goal of the company is to get a good user experience regardless of those devices.

**Accessibility Testing**

The aim of Accessibility Testing is to determine whether the software or application is accessible for disabled people or not. Here, disability means deafness, color blindness, mentally disabled, blind, old age, and other disabled groups. Various checks are performed, such as font size for visually disabled, color and contrast for color blindness, etc.
{% endhint %}

### **Security Testing**:

**Description**: Identifies vulnerabilities and ensures that the software protects data and maintains functionality as intended. The goal is to purposefully find loopholes and security risks in the system that could result in unauthorized access to or the loss of information by probing the application for weaknesses. There are multiple types of this testing method, each of which aimed at verifying six basic principles of security.

1. Integrity
2. Confidentiality
3. Authentication
4. Authorization
5. Availability
6. Non-repudiation

**Tools**: OWASP ZAP, Burp Suite.

{% hint style="info" %}
**Penetration Testing**

Penetration Testing or Pen testing is the type of security testing performed as an authorized cyberattack on the system to find out the weak points of the system in terms of security.

Pen testing is performed by outside contractors, generally known as ethical hackers. That is why it is also known as ethical hacking. Contractors perform different operations like SQL injection, URL manipulation, Privilege Elevation, session expiry, and provide reports to the organization.
{% endhint %}

### **Compatibility Testing**:

**Description**: Ensures the software works across different devices, operating systems, browsers, and networks. It is used to gauge how an application or piece of software will work in different environments. It is used to check that the product is compatible with multiple operating systems, platforms, browsers, or resolution configurations. The goal is to ensure that software’s functionality is consistently supported across any environment we expect our end users to be using.

**Tools**: BrowserStack, Sauce Labs.

### **Reliability Testing**:

**Description**: Ensures the software performs consistently under specific conditions for a specified period.

**Tools**: LoadRunner, JMeter.

### **Recovery Testing**:

**Description**: Checks the software's ability to recover from crashes, failures, or other unexpected conditions.

**Tools**: Not specific, often involves manual tests.

### **Compliance Testing**:

**Description**: Ensures the software adheres to regulations, standards, and guidelines.

**Tools**: Often manual, sometimes automated tools depending on the standard.

### **Localization Testing**:

**Description**: Checks the software’s ability to be used in a particular locale, considering language, cultural, and regional differences.

**Tools**: LinguaTools, Localazy.

### **Maintainability Testing**:

**Description**: Assesses how easy it is to maintain the software, including modifications, upgrades, and fixes.

**Tools**: SonarQube, CAST.
