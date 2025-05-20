# Revert vs Reset

## About

Git is a distributed version control system built to track history **accurately** and **flexibly**. That flexibility is reflected in having **multiple ways to “undo” a change**, depending on our **intent**:

* Do we want to **preserve history** and just "undo" the effect of a commit? → Use `revert`
* Do we want to **go back in time** and pretend a commit never happened? → Use `reset`

The commands differ in **philosophy** as much as behavior:

<table><thead><tr><th width="130.03125">Command</th><th>Philosophical Intent</th></tr></thead><tbody><tr><td>Revert</td><td>History is immutable; mistakes should be recorded and fixed.</td></tr><tr><td>Reset</td><td>History is under your control; change it if necessary.</td></tr></tbody></table>

## How Git Stores Commits ?

To fully grasp `reset` and `revert`, it helps to understand how Git handles commits.

Git’s data model is like a **chain of snapshots**, not a series of changes. Each commit is a **snapshot** of the entire repository, and it points to its parent.

For example:

```
A ← B ← C ← D (HEAD)
```

Each letter is a snapshot (commit), and HEAD points to the current branch tip.

* `git revert C` will create a new commit `E` that undoes changes introduced in `C`, but **D, C, B, and A all remain in the history**.
* `git reset --hard B` moves HEAD and branch pointer back to `B`, **deleting `C` and `D` from the visible history**.

## **What is `git revert` ?**

`git revert` is used to create a **new commit** that **undoes the changes** introduced by a previous commit.

### Characteristics

* Does NOT remove commits from history
* Safe for shared/public branches
* Creates a new commit with the inverse changes of the selected commit
* Maintains project history and collaboration safety

### Example

```bash
git revert <commit-hash>
```

Let’s say commit `abc123` added a line of code. Running `git revert abc123` will create a **new commit** that **removes that line**, but both `abc123` and the new revert commit will exist in the log.

### Common Use Cases

* Undoing a buggy commit in a **shared branch**
* Keeping history **intact and traceable**
* Collaborative workflows where **rewriting history is dangerous**

## **What is `git reset` ?**

`git reset` is used to **move the HEAD (and branch pointer)** to a previous commit. It can also modify our **working directory and staging area** depending on the mode.

### Types of Reset

<table><thead><tr><th width="308.04296875">Command</th><th>What it Does</th></tr></thead><tbody><tr><td><code>git reset --soft</code></td><td>Moves HEAD, <strong>keeps</strong> staging + working dir</td></tr><tr><td><code>git reset --mixed</code></td><td>Moves HEAD, resets staging, keeps working dir</td></tr><tr><td><code>git reset --hard</code></td><td>Moves HEAD, resets staging + working dir</td></tr></tbody></table>

### Example

```bash
git reset --hard <commit-hash>
```

This will reset the branch to the specified commit and **erase** all commits after it in history (if not already pushed).

### Characteristics

* Modifies history
* Dangerous on shared branches (can lose data)
* Used for local clean-up
* Good for rewriting commit history before pushing

### Common Use Cases

* Erasing local experimental commits
* Rewriting recent history before first push
* Clean up mistakes in local branches



