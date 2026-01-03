---
hidden: true
---

# SonarQube

## About

**SonarQube** is a **developer-facing static code analysis platform** used to continuously inspect code quality, security, and maintainability during development and CI/CD.

From a tooling perspective, SonarQube is:

* A server-based analysis engine
* A rule execution and aggregation platform
* A quality gate decision service
* A reporting and governance dashboard

It is designed to be **part of the development workflow**, not an after-the-fact audit tool.

## Where SonarQube Fits in Java Development ?

In a typical Java/Spring Boot setup, SonarQube sits:

* After compilation
* Before or during CI
* Before merge or release

It analyzes:

* Source code (Java, tests, config files)
* Bytecode-derived metadata
* Test coverage reports
* Duplication and complexity

SonarQube does **not** execute your application.\
It inspects **code and artifacts** produced during the build.

## SonarQube Editions (Pricing & Capabilities)

SonarQube is available in **four editions**, with **licensing based on Lines of Code (LOC)**.

<table data-full-width="true"><thead><tr><th width="274.08203125">Community Edition (Free)</th><th valign="top">Developer Edition (Paid)</th><th valign="top">Enterprise Edition (Paid)</th><th valign="top">Data Center Edition (Paid, Enterprise-scale)</th></tr></thead><tbody><tr><td><p>Best suited for:</p><ul><li>Individual developers</li><li>Small teams</li><li>Learning and experimentation</li></ul><p>Capabilities:</p><ul><li>Core code quality analysis</li><li>Bugs and code smells</li><li>Basic security rules</li><li>Java, Spring Boot, and many other languages</li><li>Single branch analysis</li></ul><p>Limitations:</p><ul><li>No branch analysis</li><li>No pull request decoration</li><li>Limited security rules</li><li>No governance features</li></ul><p>Use this if:</p><ul><li>You want local analysis</li><li>You are setting up SonarQube for learning</li><li>You don’t need PR-level feedback</li></ul></td><td valign="top"><p>Best suited for:</p><ul><li>Active development teams</li><li>CI/CD-driven workflows</li></ul><p>Additional capabilities:</p><ul><li>Branch analysis</li><li>Pull request decoration</li><li>Enhanced security rules</li><li>Better issue tracking on new code</li></ul><p>This is the <strong>minimum practical edition</strong> for modern Git-based workflows.</p></td><td valign="top"><p>Best suited for:</p><ul><li>Large teams</li><li>Multiple projects and services</li><li>Regulated environments</li></ul><p>Additional capabilities:</p><ul><li>Portfolio management</li><li>Advanced governance</li><li>Multiple quality gates</li><li>Compliance reporting</li><li>Permission and delegation controls</li></ul></td><td valign="top"><p>Best suited for:</p><ul><li>Very large organizations</li><li>High availability requirements</li></ul><p>Additional capabilities:</p><ul><li>Horizontal scaling</li><li>High availability</li><li>Advanced performance tuning</li></ul></td></tr></tbody></table>

## Licensing Model (Important Practical Detail)

SonarQube pricing is based on:

* **Total analyzed Lines of Code**
* Across all projects
* Across all branches

Key implications:

* Test code may or may not count (configurable)
* Generated code should usually be excluded
* Unused projects still consume license

This makes **scope control** a real operational concern

## SonarQube Deployment Model



## How SonarQube Analyzes Java Projects ?



## SonarQube vs IDE Plugins



## When SonarQube Is a Good Fit ?

