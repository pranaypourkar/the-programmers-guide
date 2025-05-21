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

{% hint style="success" %}
**Working directory**: The actual files we see and edit.

**Staging area (index)**: A snapshot of changes we plan to commit.

**HEAD**: The latest commit on our current branch (i.e., what Git considers the last "saved" state).
{% endhint %}

## **What is `git revert` ?**

`git revert` is used to create a **new commit** that **undoes the changes** introduced by a previous commit.

### Characteristics

* Does NOT remove commits from history
* Safe for shared/public branches
* Creates a new commit with the inverse changes of the selected commit
* Maintains project history and collaboration safety

### Example

**Initial State**

* We are on commit `A`.
* We create `file1.java` and commit it → `commit B`.
* We realize `commit B` introduced a bug or unwanted change.

**Step-by-step**

```bash
# We are on main branch
git log --oneline
# Output:
# B123456 (HEAD -> main) Add file1.java
# A789abc Initial commit

# We want to undo commit B (but preserve history)
git revert B123456
```

**What happens now?**

* Git will create a new commit, say `C`, that **reverses the changes** introduced by `B`.
* Our history now looks like:

```
C654321 Revert "Add file1.java"
B123456 Add file1.java
A789abc Initial commit
```

* `file1.java` is either deleted or modified to its earlier state — **whatever the inverse of `B` was**.
* Our working directory and staging area reflect the effect of the new **revert commit**.

### Common Use Cases

* Undoing a buggy commit in a **shared branch**
* Keeping history **intact and traceable**
* Collaborative workflows where **rewriting history is dangerous**

## **What is `git reset` ?**

`git reset` is used to **move the HEAD (and branch pointer)** to a previous commit. It can also modify our **working directory and staging area** depending on the mode.

### Types of Reset

<table><thead><tr><th width="308.04296875">Command</th><th>What it Does</th></tr></thead><tbody><tr><td><code>git reset --soft</code></td><td>Moves HEAD, <strong>keeps</strong> staging + working dir</td></tr><tr><td><code>git reset --mixed</code></td><td>Moves HEAD, resets staging, keeps working dir</td></tr><tr><td><code>git reset --hard</code></td><td>Moves HEAD, resets staging + working dir</td></tr></tbody></table>

### Example

#### `git reset --soft HEAD~1`

We have a file `file1.java` at commit `A`.\
We modify `file1.java`.\
We run `git add file1.java` → the change is now in the **staging area**.\
We run:

```bash
git reset --soft HEAD~1
```

At this point:

* `file1.java` is still **modified compared to the last commit**.
* The change is still **in the staging area**.
* The **working directory remains unchanged** — we see the file exactly as before the reset.
* Git simply moved `HEAD` to the previous commit. No file content was changed or lost.

#### `git reset --mixed HEAD~1` (default)

We have a file `file1.java` at commit `A`.\
We modify `file1.java`.\
We run `git add file1.java` → the change is now in the **staging area**.\
We run:

```bash
git reset --mixed HEAD~1
```

At this point:

* `file1.java` is still **modified compared to the last commit**.
* The change is now **removed from the staging area** (unstaged).
* The **working directory remains unchanged** — our actual file content is still modified.
* Git moved `HEAD` back and cleared the staging area, but our edits are still present in the file.

#### `git reset --hard HEAD~1`

We have a file `file1.java` at commit `A`.\
We modify `file1.java`.\
We run `git add file1.java` → the change is now in the **staging area**.\
We run:

```bash
git reset --hard HEAD~1
```

At this point:

* `file1.java` is **restored exactly as it was in the previous commit** (`HEAD~1`).
* The change is removed from both the **staging area** and the **working directory**.
* Our modifications are **completely lost** — Git discards any local file changes.
* The working directory is reset to match the commit Git moved to.

### Characteristics

* Modifies history
* Dangerous on shared branches (can lose data)
* Used for local clean-up
* Good for rewriting commit history before pushing

### Common Use Cases

* Erasing local experimental commits
* Rewriting recent history before first push
* Clean up mistakes in local branches



