# Cherry-pick strategies

## About

**Cherry-picking** is the process of selecting specific commits from one branch and applying them to another. Unlike merge or rebase, which deal with **ranges of commits**, cherry-pick is about **individual commits** that we want to apply elsewhere.

It’s called “cherry-pick” because we are picking only the changes we want — like picking cherries from a tree.

<figure><img src="../../../.gitbook/assets/Screenshot 2025-06-18 at 1.01.17 PM.png" alt=""><figcaption></figcaption></figure>

## When and Why to Use Cherry-pick ?

Cherry-picking is useful when:

* We want to **backport** a bug fix from the `main` branch to an older support branch (e.g., `support/1.x`)
* A developer committed a change to the wrong branch, and we want to **replicate** it in the correct one
* We want to apply a **hotfix** to production without pulling in unrelated development changes
* We want to move **isolated features or commits** between branches

## The Basic Cherry-pick Command

```bash
git cherry-pick <commit-hash>
```

This applies the changes introduced by the specified commit onto our current branch.

## Cherry-pick Strategies

Depending on our use case, there are various strategies or best practices for cherry-picking:

### 1. **Single Commit Cherry-pick**

The most basic strategy. We know a specific commit hash that we want to apply to our current branch.

```bash
git checkout release/1.0
git cherry-pick 3ac9ff2
```

This is simple and works well when the commit is small and self-contained.

### 2. **Range of Commits**

Sometimes, we want to cherry-pick **multiple sequential commits**.

```bash
git cherry-pick A^..B
```

This picks all commits starting **after** A (A^) and **up to and including** B.

Example:

```bash
git cherry-pick a1b2c3^..d4e5f6
```

This is useful if we had a small feature or fix implemented over a few commits.

### 3. **Interactive Selection Using `git log`**

If we are unsure which commits to pick, review them with:

```bash
git log --oneline
```

Then selectively cherry-pick only the ones that are relevant. This is a **manual, but controlled strategy** often used in urgent situations (hotfixes, patch branches).

### 4. **Backporting Fixes to Maintenance Branches**

In real projects, the main development may happen on `main` or `develop`, but we also maintain older release branches (`support/1.0`, `release/2.1`). We may want to **copy bug fixes** from the active branch to the older one.

Steps:

```bash
git checkout support/1.0
git cherry-pick <commit-hash>
```

After that, test it, and push the change back to the support branch. This helps keep the older version secure and up to date without pulling in unrelated changes.

### 5. **Resolving Conflicts During Cherry-pick**

If the cherry-picked commit touches code that differs in the current branch, we may run into a conflict.

Git will pause and indicate a conflict:

```bash
error: could not apply <commit>
```

To resolve:

* Fix the conflicted files manually
*   Stage the resolved files:

    ```bash
    git add <filename>
    ```
*   Continue:

    ```bash
    git cherry-pick --continue
    ```

Or abort the operation:

```bash
git cherry-pick --abort
```

### 6. **Cherry-pick with Commit Message Editing**

If we want to modify the commit message while cherry-picking:

```bash
git cherry-pick -e <commit>
```

This opens an editor allowing we to edit the commit message before applying.

### 7. **Skip Empty Commits**

Sometimes the changes in the cherry-picked commit are already present. Git may throw a message like:

```bash
The previous cherry-pick is now empty, possibly due to conflict resolution.
```

To automatically skip such commits:

```bash
git cherry-pick --skip
```

Or configure Git to skip them automatically:

```bash
git config --global cherry-pick.empty warn
```

### 8. **Using `-x` for Traceability**

When cherry-picking across branches, it’s often useful to trace the source of the cherry-picked commit.

```bash
git cherry-pick -x <commit>
```

This appends a line to the commit message like:

```
(cherry picked from commit 3ac9ff2)
```

This is particularly important when managing hotfixes and audit trails.

## Best Practices

* Use cherry-pick only when we want to **copy changes**, not combine full histories.
* Prefer cherry-pick for **isolated bug fixes**, not entire features or broad refactors.
* Always test after cherry-picking, especially when applying across branches with different base code.
* Keep in mind: cherry-pick **copies commits**, so they have **different commit hashes** from the original. This matters if we are trying to keep commit histories clean.
* Avoid cherry-picking in a **collaborative flow** unless everyone is aware — it can create duplicate commits and confusion if not handled properly.
