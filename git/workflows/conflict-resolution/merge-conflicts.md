# Merge Conflicts

## About

In Git, a **merge** is the process of integrating changes from one branch into another. It typically happens when:

* We have been working on a feature branch, and now we want to bring our changes into `main` (or any other base branch).
* Multiple team members have worked on different branches, and those branches are now being combined.

A merge can be done with:

```bash
git merge <branch>
```

Git tries to automatically reconcile differences, but if changes affect the same lines or structure in both branches, **merge conflicts** arise.

## What Is a Merge Conflict?

A **merge conflict** occurs when Git cannot automatically determine which changes to keep and which to discard. This happens when both branches modify the same part of a file differently, or if there's a structural conflict (e.g., file moved or deleted in one branch and modified in another).

Git then **stops the merge** and asks us to manually resolve the conflicts.

## Common Causes of Merge Conflicts

1. **Same Line Edited Differently**\
   Both branches made changes to the same line(s) in the same file.
2. **One Deleted, One Modified**\
   One branch deleted a file while the other modified it.
3. **File Renamed or Moved Differently**\
   File paths diverge between branches, confusing Git on how to reconcile.
4. **Complex Structural Changes**\
   If both branches restructure large chunks of the same file or class.

## What Happens Internally ?

When we run:

```bash
git merge feature-branch
```

Git:

1. Locates the **common ancestor** of the current and target branches.
2. Calculates changes from the ancestor to each branch.
3. Tries to apply both sets of changes together.
4. If overlapping changes are detected, Git **cannot auto-resolve** and marks the affected files as conflicted.

## How Git Shows Merge Conflicts ?

Git inserts conflict markers in the conflicted files like this:

```
<<<<<<< HEAD
Our branch’s changes
=======
Incoming branch’s changes
>>>>>>> feature-branch
```

We must edit the file manually to choose or combine changes, then remove the markers.

## How to Resolve a Merge Conflict ?

1.  **Run the merge**:

    ```bash
    git merge feature-branch
    ```
2. **Git pauses on conflict**, and marks conflicting files.
3. **Open the conflicted files**, and manually:
   * Review both versions
   * Keep the correct lines from each version
   * Delete the conflict markers
4.  **Stage the resolved files**:

    ```bash
    git add <file>
    ```
5.  **Complete the merge**:

    ```bash
    git commit
    ```

> Git does not auto-create a commit if a conflict occurred. We must commit after resolving.

## Optional Commands

*   Abort the merge and return to the previous state:

    ```bash
    git merge --abort
    ```
*   View conflicts:

    ```bash
    git status
    ```
* Use visual tools:
  * IDEs (IntelliJ, VSCode, Eclipse) often provide a merge conflict editor.
  * CLI tools like `git mergetool` can be configured.
