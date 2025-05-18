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







