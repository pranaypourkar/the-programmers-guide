# Deployment & Packaging

## About

In the Spring ecosystem, Deployment & Packaging refers to the process of preparing our Spring applications for execution in various environments from local development to staging and production systems.

This involves two major concerns

* **Packaging** the application into a distributable unit (like a JAR, WAR, or Docker image)
* **Deploying** it into an environment such as a cloud platform, container orchestration system, or traditional server

Effective packaging and deployment ensures that our Spring applications are portable, environment-agnostic, and production-ready.

## Why It Matters

* **Standardization**: Well-packaged applications behave consistently across environments - local, test, staging, and prod.
* **Portability**: Dockerized apps can run anywhere — bare metal, Kubernetes, or cloud runtimes without rework.
* **Reliability**: Clear deployment boundaries reduce misconfigurations and "it works on my machine" issues.
* **Scalability**: Proper deployment models support auto-scaling, load balancing, and observability.
* **Speed**: Streamlined packaging pipelines (e.g., using Jib or Spring Boot plugins) reduce time-to-deploy.
* **Security**: Deployment images can be hardened and scanned for vulnerabilities before going live.

## Common Packaging Options in Spring

<table data-header-hidden data-full-width="true"><thead><tr><th width="159.8055419921875"></th><th width="310.89324951171875"></th><th></th></tr></thead><tbody><tr><td><strong>Type</strong></td><td><strong>Tooling/Format</strong></td><td><strong>Usage</strong></td></tr><tr><td><strong>Executable JAR</strong></td><td>Spring Boot Maven/Gradle Plugin</td><td>Most common; self-contained, includes embedded server</td></tr><tr><td><strong>WAR</strong></td><td>External Servlet container (Tomcat, WildFly)</td><td>Legacy or when app needs to be deployed in existing infra</td></tr><tr><td><strong>Docker Image</strong></td><td>Dockerfile, Jib, Buildpacks</td><td>For container-based deployments, CI/CD, Kubernetes</td></tr><tr><td><strong>Native Binary</strong></td><td>Spring AOT with GraalVM</td><td>For low-memory, fast-startup scenarios</td></tr></tbody></table>

## Deployment Targets

<table data-header-hidden><thead><tr><th width="320.41497802734375"></th><th></th></tr></thead><tbody><tr><td><strong>Target Environment</strong></td><td><strong>Notes</strong></td></tr><tr><td><strong>Local (dev)</strong></td><td>Run via <code>java -jar</code>, IDE, or Spring Boot Devtools</td></tr><tr><td><strong>Traditional server (Tomcat, Jetty)</strong></td><td>Use WAR packaging</td></tr><tr><td><strong>Cloud (e.g., AWS, GCP, Azure)</strong></td><td>Use Docker images, deploy with Terraform, CD tools</td></tr><tr><td><strong>Kubernetes</strong></td><td>Docker + Helm + K8s manifests or Spring Cloud Kubernetes</td></tr><tr><td><strong>Cloud Foundry / Heroku</strong></td><td>Deploy JAR or image with <code>cf push</code> or Git-based flows</td></tr></tbody></table>
