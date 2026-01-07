# Scanning a Spring Boot Project

## About

This section explains **how a Spring Boot project is actually scanned by SonarQube**, what SonarQube expects from the build, and how analysis results flow into the dashboard and Quality Gates.

Before scanning, the following must already be true:

* Spring Boot project builds successfully
* Java version supported by SonarQube
* Tests can run (even if minimal)
* SonarQube server is reachable
* Authentication token is available

SonarQube **assumes a healthy build**.\
If the build is broken, analysis quality is undefined.

### How SonarQube Fits into the Spring Boot Build ?

SonarQube analysis runs **after compilation**, not before.

Typical Spring Boot flow:

```
Source Code
   ↓
mvn compile
   ↓
mvn test (JaCoCo generates coverage)
   ↓
sonar:sonar
   ↓
SonarQube Dashboard + Quality Gate
```

SonarQube does **not**:

* Start Spring context
* Load application properties
* Execute controllers or services

It analyzes **code artifacts**, not runtime behavior.

## Option 1: Local SonarQube Using Docker + Maven Sonar Plugin

_(Most common for learning, PoC, and early team setup)_

This option is ideal when:

* You want a self-contained setup
* You are evaluating SonarQube
* You want to scan locally before CI integration
* You want zero infrastructure dependency

This mirrors production behavior without CI complexity.

{% hint style="warning" %}
* SonarQube runs as a Docker container
* Database runs as a Docker container
* Spring Boot project runs locally
* Maven triggers analysis using the Sonar plugin
{% endhint %}

### Step-wise Process

#### Step 1: Run SonarQube Using Docker

A minimal Docker setup consists of:

* SonarQube server
* PostgreSQL database
* Persistent volumes

Typical responsibilities:

* Docker handles runtime
* SonarQube handles analysis & UI
* PostgreSQL stores history and metrics

This setup is **stateful** and should not be recreated every run.

#### Step 2: Access SonarQube UI

Once started:

* SonarQube UI is available on `http://localhost:9000`
* Default admin credentials are used initially
* A project key and token are generated

At this point, SonarQube is **ready to receive analysis reports**, but nothing has been scanned yet.

#### Step 3: Configure Spring Boot Project for Analysis

The Spring Boot project must:

* Compile successfully
* Produce bytecode
* Produce test and coverage reports

This is **non-negotiable for Java analysis**.

SonarQube does not analyze:

* Uncompiled code effectively
* Runtime behavior
* Spring context wiring

#### Step 4: Use Maven Sonar Plugin to Trigger Scan

The **Maven Sonar plugin** acts as the bridge between:

* Your build
* SonarQube server

Key characteristics:

* Runs after compilation and tests
* Collects source + bytecode + reports
* Uploads analysis results to SonarQube

Typical flow:

```
mvn clean verify
mvn sonar:sonar
```

Or combined:

```
mvn clean verify sonar:sonar
```

This is the **authoritative scan**, identical in behavior to CI scans.

#### Step 5: Authentication and Project Binding

During scan:

* Project key identifies the service
* Token authenticates the scanner
* SonarQube binds results to the project

After completion:

* Issues appear in the UI
* Ratings are calculated
* Quality Gate is evaluated

### Script

{% file src="../../../.gitbook/assets/script-to-run-local-sonar-analysis.sh" %}

### Example

Use the sample java project having required plugins

{% file src="../../../.gitbook/assets/springboot-sonar-demo.zip" %}

Execute the Script using the below command as well provide the path of the springboot project

{% code overflow="wrap" %}
```
./script-to-run-local-sonar-analysis.sh /Users/pranayp/Documents/Project/codebase/sonar/springboot-sonar-demo
```
{% endcode %}

<figure><img src="../../../.gitbook/assets/image.png" alt=""><figcaption></figcaption></figure>



