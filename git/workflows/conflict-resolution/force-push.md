# Force Push

## About

A **force push** in Git (`git push --force`) is a command used to **push our local branch to the remote repository** while **overwriting the remote branch history**. It **disregards the normal safety checks** that prevent rewriting commits that exist on the remote.

Normally, Git protects shared history. If our local branch has diverged from the remote (i.e., the histories are different), a regular push will be rejected. Force push bypasses that rejection.

## Why Force Push Exists

Git allows rewriting history locally using commands like:

* `git rebase`
* `git commit --amend`
* `git reset`

After such operations, our branch’s history no longer matches the remote. If we try to push, Git will refuse to do so unless we use force. This is where **force push** comes in — it lets us tell Git, “I know what I’m doing, replace the remote history with mine.”

## How It Works

When we run:

```bash
git push --force
```

Git does **not care** whether the remote branch has new commits. It simply updates the remote branch to point to our current local state. If the remote had commits not present locally, they are **lost**.

Git compares commit references (pointers) and updates them directly.

## When to Use Force Push ?

### **a) After Rewriting History**

**Scenario:** We have rewritten commit history using `git rebase` or `git commit --amend`.

**Why:** These operations **change commit hashes**, making your local branch history different from the remote. A normal `git push` will be rejected.

**Example 1 – Rebase:**

```bash
# Interactive rebase to edit/squash commits
git rebase -i HEAD~3
# Edit or squash commits, then save and exit the editor

# Remote will reject a normal push due to changed history
git push --force
```

**Example 2 – Amending a commit:**

```bash
# Fix last commit message or add forgotten changes
git commit --amend -m "Corrected commit message"

# Force push to update remote branch
git push --force
```

{% hint style="success" %}
**Note:** Always ensure no one else is working on the same branch before you force push.
{% endhint %}

### **b) Cleanup Before Merge Request**

**Scenario:** We want to clean up messy commits before raising a Merge Request or Pull Request.

**Why:** To present a **clear and linear commit history**, we may squash multiple WIP (work in progress) commits into one or reorder them.

**Example – Squashing commits:**

```bash
# Suppose we made 4 messy commits on our feature branch
git rebase -i HEAD~4
# Choose 'squash' or 'fixup' in the interactive editor

# Push with force to update cleaned-up history
git push --force
```

{% hint style="success" %}
This is commonly done just **before opening** a PR/MR, or **after feedback**, so the reviewer sees a clean diff.
{% endhint %}

### **c) Removing Mistaken Commits**

**Scenario:** We accidentally pushed something sensitive (e.g., secrets, large files, wrong code).

**Why:** We want to **remove** the commit(s) from remote history so it’s no longer publicly visible or downloadable.

**Example – Using `git reset`:**

```bash
# Go back to a safe commit before the mistake
git reset --hard <last-good-commit-hash>

# Overwrite remote branch with cleaned history
git push --force
```

We can find `<last-good-commit-hash>` using:

```bash
git log
```

OR if unsure:

```bash
git reflog  # shows a list of recent HEAD states
```

{% hint style="warning" %}
Use this carefully. If others pulled the bad commit, removing it locally won't remove it from their machines.
{% endhint %}

## Risks and Why Force Push is Dangerous

**a) Data Loss**

Force push **removes remote commits** that are not in our local history. If someone else pushed to the same branch before our force push, their work is **lost**.

**b) Team Disruption**

If teammates have pulled the old version and we force push a new history:

* They get errors when pulling.
* They must fix their local branches manually using rebase or reset.

**c) Broken CI/CD Pipelines**

Force pushing can break automated pipelines that rely on commit history, hashes, or tags.

## When to Use and When NOT to Use Force Push

<table data-header-hidden data-full-width="true"><thead><tr><th width="235.34375"></th><th width="141.25"></th><th></th></tr></thead><tbody><tr><td>Situation / Scenario</td><td>Use <code>--force</code>?</td><td>Explanation</td></tr><tr><td>After <strong>interactive rebase</strong> (<code>git rebase -i</code>)</td><td>Yes</td><td>Rebase rewrites history; force push is required to update the remote.</td></tr><tr><td>After <strong>amending</strong> the latest commit (<code>--amend</code>)</td><td>Yes</td><td>Changes the commit hash; remote needs a force push to accept the new history.</td></tr><tr><td>After <strong>squashing</strong> commits for clean history</td><td>Yes</td><td>Squash modifies commit history; you must force push to update the branch on the remote.</td></tr><tr><td>After <strong>resetting</strong> to remove sensitive/mistaken data</td><td>Yes</td><td>You are rewriting history to remove bad commits; force push is required.</td></tr><tr><td><strong>Working on your own feature branch alone</strong></td><td>Yes</td><td>Safe to force push if no one else depends on the branch.</td></tr><tr><td>Collaborating on a <strong>shared branch with others</strong></td><td>No</td><td>Force push can overwrite others’ work; use with extreme caution or avoid it.</td></tr><tr><td>Trying to sync local with updated remote</td><td>No</td><td>Use <code>git pull</code>, <code>git fetch</code>, or merge instead; force push can erase incoming updates.</td></tr><tr><td>Undoing a mistake without rewriting history</td><td>No</td><td>Use <code>git revert</code> to add a new commit that undoes the changes.</td></tr><tr><td>On <strong>protected branches</strong> (e.g., <code>main</code>, <code>release</code>)</td><td>No</td><td>Force push is typically disabled or discouraged to avoid accidental overwrites.</td></tr><tr><td>As a shortcut to fix conflicts</td><td>No</td><td>Don't use force push to avoid resolving conflicts. Always handle them properly.</td></tr><tr><td>Accidentally diverged due to <code>git pull</code> conflicts</td><td>Maybe</td><td>Understand what caused divergence. Use <code>--force-with-lease</code> if safe, but only if you're sure.</td></tr></tbody></table>

