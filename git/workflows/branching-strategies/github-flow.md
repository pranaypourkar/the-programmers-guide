# GitHub Flow

## About

**GitHub Flow** is a **lightweight, branch-based workflow** designed for teams practicing **continuous delivery or continuous deployment**. It focuses on:

* Keeping the `main` branch always deployable
* Creating **feature branches** for new work
* Using **pull requests** for code review
* Releasing code to production as soon as it's ready

It is ideal for **cloud-native teams**, **fast-paced product development**, and teams that push code **multiple times per day**.

## **Core Principles**

1. **Main is always deployable**
   * The `main` branch must always be stable and production-ready.
2. **Create branches off main**
   * Every new feature, bugfix, or experiment starts from `main` in a dedicated branch (e.g., `feature/add-login`).
3. **Open a pull request early**
   * Developers open a **pull request (PR)** as soon as they push code to facilitate early discussion and feedback.
4. **Continuous feedback and testing**
   * Automated tests, linters, and CI checks run against the pull request.
   * Team reviews the PR before merging.
5. **Deploy after merge**
   * Once reviewed and approved, the branch is merged into `main`, and the change is deployed.
6. **Quick iterations**
   * Changes are small, atomic, and deployed frequently.

## **Comparison with Other Workflows**

<table data-full-width="true"><thead><tr><th width="168.63671875">Workflow</th><th>Key Branches</th><th>Release Style</th><th>Use Case</th></tr></thead><tbody><tr><td><strong>Git Flow</strong></td><td><code>main</code>, <code>develop</code>, etc.</td><td>Scheduled releases</td><td>Suits large products with infrequent releases</td></tr><tr><td><strong>GitHub Flow</strong></td><td><code>main</code> only (plus short-lived branches)</td><td>Continuous delivery</td><td>Ideal for cloud-based and SaaS products</td></tr><tr><td><strong>Trunk-Based Dev</strong></td><td><code>main</code> with optional short-lived branches</td><td>Continuous delivery</td><td>Large teams, fast delivery, monorepos</td></tr></tbody></table>

GitHub Flow simplifies the branching model for teams that prioritize **speed and simplicity** over complex release management.

## **Workflow Steps**

### Step 1: Create a New Branch

```bash
git checkout -b feature/improve-login main
```

* Branch naming should be descriptive: `feature/...`, `bugfix/...`, `hotfix/...`.

### Step 2: Commit Regularly

```bash
git add .
git commit -m "Improve login UX by adding spinner"
```

* Keep commits atomic, testable, and meaningful.

### Step 3: Push and Open a PR

```bash
git push origin feature/improve-login
```

* Go to GitHub and open a Pull Request (PR).
* Explain **what** the change is and **why** it’s needed.
* Request reviews from team members.

### Step 4: Collaborate and Review

* Discuss changes in the PR.
* Apply suggestions and push additional commits.
* Automated CI runs (tests, static analysis, etc.).

### Step 5: Merge When Ready

* Once approved and passing CI, **merge to main** (usually via "Squash and merge").
* Keep the commit history clean.

### Step 6: Deploy Immediately or via Automation

* Optionally, use GitHub Actions to auto-deploy on merge.
* Monitor the release for issues.

## Best Practices

* **Always branch from `main`** to stay up to date.
* Keep branches **short-lived** — a few hours to 1–2 days.
* Automate **CI checks**: test coverage, formatting, security scans.
* Write **clear PR descriptions** with context and screenshots if needed.
* Enable **branch protection rules** to enforce:
  * PR reviews
  * Passing CI
  * Commit message standards
* **Squash merge** for clean history.

## When to use GitHub Flow and when not to ?

<table data-header-hidden data-full-width="true"><thead><tr><th width="195.37109375"></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Criteria</strong></td><td><strong>When to Use GitHub Flow</strong></td><td><strong>When Not to Use GitHub Flow</strong></td></tr><tr><td><strong>Team Size</strong></td><td>Small to medium-sized teams that can collaborate quickly and review each other's work often.</td><td>Very large teams working on complex or monolithic applications with multiple stakeholders and release cycles.</td></tr><tr><td><strong>Release Frequency</strong></td><td>Teams deploying <strong>daily or multiple times per day</strong>, using Continuous Delivery or Continuous Deployment.</td><td>Teams following a <strong>scheduled release cycle</strong> (e.g., quarterly or monthly releases) or needing long QA/testing phases.</td></tr><tr><td><strong>Codebase Type</strong></td><td>Ideal for <strong>web apps, APIs, and microservices</strong> where fast iteration and rollback is easy.</td><td>Not ideal for <strong>embedded systems, firmware, or critical infrastructure</strong> where changes must be thoroughly tested before integration.</td></tr><tr><td><strong>Branching Complexity</strong></td><td>Prefer <strong>minimal branching</strong> with short-lived feature branches.</td><td>Projects that need <strong>develop, release, hotfix branches</strong> or long-lived feature branches (e.g., Git Flow).</td></tr><tr><td><strong>Testing Maturity</strong></td><td>Teams with <strong>automated testing and CI/CD pipelines</strong> in place.</td><td>Teams relying heavily on <strong>manual testing or post-merge QA</strong>.</td></tr><tr><td><strong>Deployment Infrastructure</strong></td><td>Supports <strong>automated deployment pipelines</strong> (e.g., GitHub Actions, Jenkins, CircleCI) with ability to roll out quickly.</td><td>Manual deployments or environments where deployment is <strong>infrequent, slow, or involves approval gates</strong>.</td></tr><tr><td><strong>Developer Workflow</strong></td><td>Developers can <strong>work independently on features</strong>, push changes frequently, and merge once reviewed.</td><td>Workflows needing <strong>strict change management</strong>, release gates, or signoffs from multiple departments.</td></tr><tr><td><strong>Environment Requirements</strong></td><td>Works well in setups with <strong>fewer environments</strong> (dev → staging → prod), especially when prod can be updated at will.</td><td>Not suitable where <strong>multiple release environments</strong> (QA, UAT, pre-prod) are tightly controlled or if prod updates are delayed.</td></tr><tr><td><strong>Risk Tolerance</strong></td><td>Suitable for <strong>low to moderate risk</strong> applications where issues can be rolled back or hotfixed quickly.</td><td>High-risk domains like <strong>finance, healthcare, aerospace</strong> where code must be stable and auditable before deployment.</td></tr><tr><td><strong>Feature Isolation</strong></td><td>Great when <strong>feature flags</strong> or toggles are used to control what’s visible to users.</td><td>Hard to use if <strong>features cannot be hidden or isolated</strong> after merging to <code>main</code>.</td></tr><tr><td><strong>Tooling Support</strong></td><td>Strong integration with <strong>GitHub</strong>, <strong>GitHub Actions</strong>, and other modern developer tools.</td><td>May require adaptation if you're using <strong>Bitbucket, GitLab, or enterprise tools</strong> with more advanced branching needs.</td></tr><tr><td><strong>Code Review Culture</strong></td><td>Encourages frequent <strong>peer reviews via pull requests</strong>, ideal for collaborative teams.</td><td>Less suitable where reviews are <strong>formal or happen only at certain release milestones</strong>.</td></tr></tbody></table>
