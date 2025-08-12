---
hidden: true
---

# Liquibase

## About

Liquibase is an open-source database change management tool designed to track, version, and automate database schema changes across different environments. It allows developers to define database changes in a **declarative format** such as YAML, XML, JSON, or SQL making them easy to version-control alongside application code.

When integrated into development and deployment workflows, Liquibase ensures that database updates are **consistent**, **repeatable**, and **reversible**, reducing the risk of human error. It works with a wide range of relational databases including MySQL, PostgreSQL, Oracle, Microsoft SQL Server, and many others.

Liquibase is particularly valuable in modern DevOps and CI/CD pipelines, where frequent and automated deployments demand reliable database migrations.

With Liquibase, we define changes in _changelogs_ using XML, YAML, JSON, or SQL, and Liquibase applies them consistently across environments from development to production. It also provides rollback capabilities, allowing safe and reversible deployments.

## Why Use Liquibase ?

In modern application development, database changes are as frequent and critical as application code changes. Without a structured approach, managing schema updates can lead to:

* **Inconsistent Environments** – Development, staging, and production databases falling out of sync.
* **Deployment Failures** – Manual scripts failing or being applied in the wrong order.
* **Lack of Rollback Options** – Difficulty in reversing changes when issues arise.
* **Poor Traceability** – Unclear history of who made what change and when.

Liquibase addresses these issues by:

* **Version-controlling database changes**, just like source code.
* **Automating deployments** to eliminate manual steps.
* **Providing rollback capabilities** to quickly recover from problematic releases.
* **Integrating seamlessly with CI/CD pipelines** to ensure consistent schema updates across all environments.

By using Liquibase, teams can improve collaboration, reduce deployment risks, and maintain a clear, auditable record of database changes.

## Feature of Liquibase

Liquibase offers a rich set of capabilities that simplify and standardize database change management:

* **Change Logs** – Centralized files (YAML, XML, JSON, or SQL) defining schema and data changes in a structured, version-controlled way.
* **Change Sets** – Individual units of change with unique identifiers, ensuring each change is executed only once per environment.
* **Rollback Support** – Ability to define and execute reverse changes for quick recovery from failures.
* **Multiple Format Support** – Flexibility to write changes in YAML, XML, JSON, or SQL.
* **Database Independence** – Works with multiple RDBMS vendors without rewriting scripts.
* **Execution History Tracking** – Uses internal tables (`DATABASECHANGELOG`, `DATABASECHANGELOGLOCK`) to record applied changes and manage concurrency.
* **Command-Line Interface (CLI)** – Direct execution and management of changes without needing a build tool.
* **Integration with Build & CI/CD Tools** – Compatible with Maven, Gradle, Jenkins, GitHub Actions, and other automation platforms.
* **Preconditions** – Conditional logic to control when a change set should run, based on database state.
* **Data Loading** – Support for inserting seed or reference data alongside schema updates.

## Benefits

Liquibase provides value far beyond simply applying SQL scripts. It solves real problems that arise in collaborative software development, especially when managing database schema changes across multiple environments.

**1. Version Control for Databases**

* **Why it matters:** Application code is stored in Git or another VCS, but database changes often get applied manually or stored in ad-hoc SQL files. This creates drift between environments.
* **How Liquibase helps:** Changelogs act as a version history for our database. Each changeset is a permanent, timestamped, author-tagged record of _what_ changed and _why_.
* **Impact:** Anyone can recreate the database schema at any point in time crucial for debugging, audits, and disaster recovery.

**2. Consistency Across Environments**

* **Why it matters:** In traditional workflows, developers, testers, and production DBs can easily become out of sync, leading to “works on my machine” problems.
* **How Liquibase helps:** Every environment runs from the **same changelog**, ensuring that the same schema changes are applied in the same order.
* **Impact:** Eliminates schema drift and environment-specific bugs.

**3. Automation and CI/CD Integration**

* **Why it matters:** Manual database deployments are slow, error-prone, and risky.
* **How Liquibase helps:** The CLI, Maven/Gradle plugins, and APIs integrate directly into Jenkins, GitLab CI, GitHub Actions, Azure Pipelines, and more.
* **Impact:** Database migrations happen automatically as part of build/deploy pipelines, reducing human error and accelerating releases.

**4. Rollback Capability**

* **Why it matters:** Production deployments can fail or introduce data issues without rollback, our only option is manual repair.
* **How Liquibase helps:** Supports both automated (`liquibase rollback`) and custom rollback scripts in each changeset.
* **Impact:** Increases confidence in deployments and reduces downtime during incidents.

**5. Multi-Database Support**

* **Why it matters:** Many organizations run multiple RDBMS types (e.g., MySQL for one service, PostgreSQL for another).
* **How Liquibase helps:** Works with a wide variety of relational databases using the same changelog format.
* **Impact:** Simplifies database tooling and training for teams working across different systems.

**6. Multiple Changelog Formats**

* **Why it matters:** Different teams have different skill sets some prefer visual XML/YAML, others prefer pure SQL.
* **How Liquibase helps:** Supports XML, YAML, JSON, and SQL for defining changes.
* **Impact:** Teams can choose the format that best fits their workflow without losing Liquibase’s features.

**7. Safety via Preconditions**

* **Why it matters:** A migration might fail if the database isn’t in the expected state (e.g., table already exists).
* **How Liquibase helps:** Preconditions can check DB state before applying changes, preventing runtime errors.
* **Impact:** Reduces risk of failed deployments or corrupted schema changes.

**8. Audit Trail for Compliance**

* **Why it matters:** Many industries require proof of when and by whom schema changes were made (e.g., finance, healthcare).
* **How Liquibase helps:** The `DATABASECHANGELOG` table records every executed changeset, including ID, author, execution date, and checksum.
* **Impact:** Simplifies audit preparation and regulatory compliance.

**9. Faster Onboarding of New Developers**

* **Why it matters:** New team members often need to manually sync their local DB to match production.
* **How Liquibase helps:** A single command (`liquibase update`) brings a local database up to the latest schema.
* **Impact:** Reduces setup time from hours to minutes.

**10. Predictable, Repeatable Migrations**

* **Why it matters:** Manually running SQL scripts can lead to differences in execution order or accidental duplication.
* **How Liquibase helps:** Tracks executed changes and only runs new ones, in the correct order.
* **Impact:** Guarantees that deployments are deterministic and reproducible.
