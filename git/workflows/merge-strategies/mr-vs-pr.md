# MR vs PR

## About

**MR (Merge Request)** and **PR (Pull Request)** are essentially **the same concept** with **different names** depending on the Git hosting service:

| Term               | Used By           |
| ------------------ | ----------------- |
| Pull Request (PR)  | GitHub, Bitbucket |
| Merge Request (MR) | GitLab            |

Despite the different names, both mean:

> A developer requests that their code (on a branch) be reviewed and merged into a mainline branch (like `main`, `develop`, etc).

They provide a **collaboration and review workflow** for merging code — with diffs, comments, approvals, and automated checks.

## Why the Naming Difference?

* **GitHub** coined the term **Pull Request**:
  * You're requesting maintainers to "pull" your changes into their branch.
* **GitLab** preferred **Merge Request**:
  * You're asking for your branch to be "merged" into another branch.

Both are semantically correct depending on perspective:

* **Pull Request**: emphasizes the **action from the maintainer’s side**.
* **Merge Request**: emphasizes the **end result**.

{% hint style="info" %}
### Do They Work Differently **Technically?**

&#x20;**No.**

Both rely on the same underlying Git concepts:

* Comparing two branches.
* Showing diffs between them.
* Option to merge (with or without rebase, squash, etc).

They just **wrap this in a web interface and workflow management**.
{% endhint %}

## Purpose and Workflow

#### General Workflow

1. **Create a Branch** – Work on your feature/fix in isolation.
2. **Push to Remote** – Push your branch to the server (GitHub/GitLab).
3. **Open a PR/MR** – Create a pull/merge request.
4. **Review Process**:
   * Reviewers read the code.
   * Leave comments.
   * Request changes or approve.
   * CI/CD tests run automatically.
5. **Merge the Code** – Once approved, code is merged into the target branch.

This process supports:

* **Code quality enforcement**
* **Peer reviews**
* **Automated testing**
* **Audit trails**

## Comparison

<table><thead><tr><th width="189.15625">Feature</th><th width="300.48046875">Pull Request (PR)</th><th>Merge Request (MR)</th></tr></thead><tbody><tr><td>Used In</td><td>GitHub, Bitbucket</td><td>GitLab</td></tr><tr><td>Terminology Origin</td><td>From "git pull"</td><td>From "git merge"</td></tr><tr><td>Primary Focus</td><td>Request to pull code</td><td>Request to merge code</td></tr><tr><td>Supported Workflows</td><td>Forking and branching</td><td>Primarily branching</td></tr><tr><td>Web UI Behavior</td><td>Similar: diff, approve, comment</td><td></td></tr><tr><td>CI/CD Integration</td><td>Strong support in both</td><td></td></tr><tr><td>Code Review</td><td>Supported in both</td><td></td></tr></tbody></table>



