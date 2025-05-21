# Recover from a bad rebase

## About

A **bad rebase** occurs when something goes wrong during the `git rebase` process:

* We dropped or lost commits unintentionally.
* We resolved a conflict incorrectly.
* We rebased the wrong branch.
* We used `--autosquash` or `-i` and made a mistake editing the commit list.
* We force-pushed a broken rebase to a shared remote.

The result is **broken history**, unexpected code changes, or missing work. In a worst-case scenario, collaborators might now be working on inconsistent commit histories.

## Why Does This Happen?

To understand how recovery works, it's important to understand what **rebase** really does.

* `git rebase` **reapplies commits** from our current branch onto a new base.
* It **creates entirely new commits** — even if the file contents are unchanged — because Git treats commits as unique (different timestamps, parent hashes, etc.).
* This means the old commits are **still there in Git**, but no longer referenced by our current branch pointer.

Because rebase creates new commits, **our original commits are orphaned**, but not deleted — unless garbage collection runs.

Git doesn’t immediately delete anything. Commits stay in the repository unless:

* They’re unreachable (not referenced by any branch or tag), and
* Git's garbage collection (`git gc`) runs and removes them.

This makes recovery possible by using tools like:

* `git reflog`
* `git fsck`
* `git log --all`
* `git stash` (if we stashed before rebasing)

## A. Recovering Using `git reflog`

### 1. Understand `git reflog`

`git reflog` records every movement of our HEAD (branch pointer). This includes rebases, merges, resets, pulls, commits, etc.

Even if our rebase deleted or rewrote commits, the reflog keeps track of our **previous HEAD state**, which lets us recover.

### 2. Run the Reflog

```bash
git reflog
```

Example output:

```
df8a5c7 HEAD@{0}: rebase finished: returning to refs/heads/feature/login
89dc123 HEAD@{1}: rebase: pick commit to add login API
293adfa HEAD@{2}: checkout: moving from main to feature/login
a88fbb0 HEAD@{3}: commit: add login error handling
```

Each line shows a previous state of our branch.

* HEAD@{0} is our current state.
* HEAD@{1}, HEAD@{2}... are our older states.
* We can checkout or reset to any of these.

### 3. Recover to a Pre-Rebase State

Find the **last safe commit** before the rebase began (usually just before `rebase:` appears).

Then either:

*   **Checkout that commit**:

    ```bash
    git checkout HEAD@{2}
    ```
*   Or **reset our branch to it**:

    ```bash
    git reset --hard HEAD@{2}
    ```

Use `--hard` with caution. If we have local file changes, use `--soft` or `--mixed` instead.

## B. Recover with `git rebase --abort`

### When to Use ?

We are **in the middle of a rebase**, and something went wrong (e.g., conflicts, wrong commits picked).

### What It Does ?

Aborts the ongoing rebase and resets our branch to the state it was in **before** the rebase started.

### Steps

1. Identify that we are mid-rebase:
   * Git will show messages like `you are currently rebasing`.
2.  Abort the rebase:

    ```bash
    git rebase --abort
    ```
3.  Check the branch state:

    ```bash
    git log --oneline
    ```

Now we are back where we started.

## C. Recover using a Backup Branch (Preventive Strategy)

### When to Use

We made a backup of our branch before rebasing (recommended practice).

### What It Does:

We simply switch back to our backup.

### Steps

1.  Create backup before rebase (done earlier):

    ```bash
    git checkout feature/login
    git branch backup/feature/login
    ```
2.  If our rebase goes bad, reset or switch:

    ```bash
    git checkout feature/login
    git reset --hard backup/feature/login
    ```

Or just:

```bash
git checkout backup/feature/login
```

We now have our pre-rebase branch restored.

## D. Recover with `git stash`

### When to Use ?

We had **uncommitted changes** and stashed them before rebasing.

### What It Does ?

Reapplies our stashed changes onto a safe branch after the rebase failed or was aborted.

### Steps

1.  Stash changes before rebasing:

    ```bash
    git stash push -m "Pre-rebase backup"
    ```
2.  Attempt rebase. If it fails or we abort it:

    ```bash
    git rebase --abort
    ```
3.  Apply stash:

    ```bash
    git stash list
    git stash apply stash@{0}
    ```
4. We can now re-commit or reattempt rebase with our changes intact.

## E. Recover Orphaned Commits via `git fsck`

### When to Use ?

* Rebase rewrote commits and we **can’t find them in any branch**.
* We **didn’t create a backup**, and reflog doesn't help.

### What It Does ?

Finds **dangling commits** that still exist in the repository but are not referenced.

### Steps

1.  Run fsck to find dangling commits:

    ```bash
    git fsck --lost-found
    ```
2.  Output example:

    ```
    dangling commit abc1234
    dangling commit def5678
    ```
3.  Inspect each commit:

    ```bash
    git show abc1234
    ```
4.  Recover it by cherry-picking or creating a new branch:

    ```bash
    git checkout -b recovery-temp abc1234
    ```

We now have a branch with the lost commit(s).

### Recovery using `git log --all` and Cherry-Pick

### When to Use ?

* We know a commit exists but is not on the current branch.
* Useful if `fsck` doesn’t help but we recall the message or part of a hash.

### What It Does ?

Shows **all commits in the repo**, even if they aren’t part of current branch history.

#### Steps:

1.  See all commits:

    ```bash
    git log --all --graph --decorate --oneline
    ```
2. Search for our lost commit visually.
3. Once found:
   *   Cherry-pick it onto our branch:

       ```bash
       git cherry-pick <commit-hash>
       ```

Or create a new branch directly from it:

```bash
git checkout -b recovered-branch <commit-hash>
```

## What If we Already Force-Pushed the Bad Rebase?

If we have **force-pushed** the bad rebase to the shared remote:

* Others may already have pulled the broken history.
*   If we recover our correct commits locally, we will need to **force-push** again:

    ```bash
    git push origin <branch> --force
    ```
* Be sure to **communicate with the team** so they reset or rebase their branches appropriately.

## Best Practices to Prevent Rebase Issues

*   **Backup before rebasing**:

    ```bash
    git branch backup/feature/login
    ```
* Use `rebase --interactive` with caution.
* Never rebase shared branches unless we coordinate with the team.
* Use `git log` and `git diff` to validate before force-pushing.





