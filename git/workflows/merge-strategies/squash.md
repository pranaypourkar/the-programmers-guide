# Squash

## About

In Git, **squashing** means **combining multiple commits into one single commit**.

It is most commonly used during:

* **Interactive rebase** (`git rebase -i`)
* **Merge with squash** (`git merge --squash`)

Squashing does **not change our code**, it changes our **commit history**.

The primary goal is to **simplify the commit history** by removing unnecessary commit boundaries (e.g., WIP, typo fixes, partial steps) and creating a single cohesive commit that represents a logical unit of work.

## Why Squash Exists ?

In collaborative development, it’s common to work in small, iterative steps:

* We might have 10 small commits that represent fixing typos, renaming variables, adjusting logic, or debugging.

While useful during development, these small commits:

* Pollute history.
* Make reviewing difficult.
* Add noise to blame/log commands.

**Squashing** exists to clean this up. It **rewrites those granular steps as if the work had been done in a single, clean, well-thought-out commit**.

It is especially useful before merging a feature branch into a long-lived branch like `main`.

## How Squashing Works ?

There are two major ways to squash commits:

### 1. Using `git rebase -i`

This allows fine-grained control.

```bash
git rebase -i HEAD~5
```

We will see:

```
pick abc123 Added initial version
pick def456 Renamed a method
pick ghi789 Fixed a bug in logic
```

Change to:

```
pick abc123 Added initial version
squash def456 Renamed a method
squash ghi789 Fixed a bug in logic
```

Git will:

* Replay the first commit as-is.
* Combine the next two into the first.
* Prompt us to write a combined commit message.

#### 2. Using `git merge --squash`

This squashes commits **across branches**, not within a branch.

```bash
git checkout main
git merge --squash feature-branch
git commit
```

What happens:

* Git collects **all changes** introduced by `feature-branch`.
* Prepares them for a single commit.
* We write the commit message manually.
* No merge commit is created, and the history of `feature-branch` is not preserved.

## Example

### Initial Scenario

We are working on a `feature` branch that branched off from `main` at commit `C`.

```
A---B---C           (main)
         \
          D---E---F (feature)
```

* Commits `D`, `E`, and `F` are all part of our in-progress work.
* Let’s say:
  * `D`: Added new service class.
  * `E`: Fixed method name.
  * `F`: Added tests and finalized logic.

These 3 commits are small and related to a single feature.

### Goal: Squash `D`, `E`, `F` into a single commit on `feature`.

We run:

```bash
git checkout feature
git rebase -i C
```

In the editor:

```
pick D Added new service class
pick E Fixed method name
pick F Added tests and finalized logic
```

Change it to:

```
pick D Added new service class
squash E Fixed method name
squash F Added tests and finalized logic
```

Git combines `E` and `F` into `D`. We are prompted to write a new commit message — something like:

> Implement new service with final logic and tests

Now our commit history looks like this:

```
A---B---C           (main)
         \
          G         (feature)
```

Where `G` is the new squashed commit combining `D+E+F`.

### What Actually Happened Internally ?

* Commits `D`, `E`, and `F` were **rewritten** into a **single new commit `G`**.
* `G` has a new commit ID.
* Original commits are no longer in the history of the branch.
* No changes to file content unless conflicts were resolved differently.
* The rebase rewrote history starting from `C`.

## When to Use Squash and When Not ?

<table data-header-hidden data-full-width="true"><thead><tr><th></th><th></th></tr></thead><tbody><tr><td><strong>Use Squash When</strong></td><td><strong>Do Not Use Squash When</strong></td></tr><tr><td>We want to keep commit history clean and minimal</td><td>We need to preserve the full development history for traceability</td></tr><tr><td>We are preparing a feature branch for merging into <code>main</code></td><td>The branch is shared with others — squashing will rewrite shared history</td></tr><tr><td>The intermediate commits are messy (e.g., “fix typo”, “debugging step”, etc.)</td><td>Each commit contains meaningful, standalone changes we may want to track later</td></tr><tr><td>We are submitting a pull/merge request and want one logical commit</td><td>Our team wants to review changes step-by-step as we made them</td></tr><tr><td>We want a single revert point in case the feature needs to be rolled back</td><td>The work is exploratory and we want to preserve all steps for learning/debug</td></tr><tr><td>Our team enforces a one-feature-one-commit policy</td><td>The repository uses a linear, detailed commit history policy</td></tr><tr><td>We are cleaning up WIP commits before pushing</td><td>We already pushed the commits and others are basing work on them</td></tr><tr><td>We want to rebase and integrate changes cleanly without polluting main history</td><td>We need to retain authorship of individual commits (in case of multiple devs)</td></tr></tbody></table>

