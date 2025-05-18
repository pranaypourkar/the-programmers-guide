# Handling Merge Conflicts

## About

A **merge conflict** in Git is a situation where Git is unable to automatically combine changes from two different branches. Git uses a three-way merge algorithm when combining changes. If Git can’t determine which change should take precedence, it stops and reports a conflict. The responsibility then falls to the developer to resolve the conflict manually.

This is Git’s way of saying:

> “Both branches have made incompatible changes to the same area of code, and I don’t know which one to keep. Please help.”

## Why Do Merge Conflicts Occur?

Merge conflicts typically happen when:

1. **Same line changes**: Two branches modify the same line in the same file differently.
2. **Deletion vs modification**: One branch deletes a file or line that the other branch modifies.
3. **File mode or rename conflicts**: One branch renames or changes file permissions, while the other changes content.
4. **Unmerged history**: Merging two branches that have drifted significantly or haven’t been regularly rebased or merged with each other.

## The Lifecycle of a Merge Conflict

1. **Git tries to perform a merge**:
   * It uses the current branch (HEAD), the incoming branch (MERGE\_HEAD), and the common ancestor.
   * It performs an auto-merge where possible.
2. **Conflict detected**:
   * If conflicting changes are found, Git marks the file as conflicted and pauses the operation.
3. **User intervention**:
   * Developer must manually review and decide how to merge the differences.
4. **Conflict resolution and staging**:
   * After editing the file to resolve the issue, the file must be added (`git add`) to indicate resolution.
5. **Commit or continue operation**:
   * Finalize the merge (`git commit`) or continue the rebase (`git rebase --continue`) or merge.

## What Git Does Internally During Conflict ?

When a conflict happens, Git internally keeps three versions of each conflicted file:

* **Base**: The common ancestor version.
* **Ours**: The current branch (your changes).
* **Theirs**: The incoming branch (other changes).

These are temporarily stored in Git’s index/staging area in different slots (stage 1, 2, and 3) and allow for custom conflict resolution tools or `git mergetool` to function.

## Resolving Conflicts

Git inserts **conflict markers** directly into the affected file:

```
<<<<<<< HEAD
Your current changes
=======
Incoming changes from the branch you're merging
>>>>>>> feature-branch
```

Our task is to:

* Read and understand both versions.
* Decide which to keep, or manually merge parts of each.
* Remove conflict markers.
* Save and stage the resolved file (`git add <file>`).

{% hint style="info" %}
#### What Happens If We Ignore a Conflict?

We cannot complete a merge, rebase, or cherry-pick if conflicts remain unresolved. Git will prevent commits until all conflicts are resolved and marked using `git add`.
{% endhint %}

## Types of Merge Conflict Scenarios

1. **Content Conflict**: Most common. Conflicting edits on the same line.
2. **File Delete/Modify Conflict**: One branch deletes a file while another modifies it.
3. **Rename Conflicts**: Same file renamed differently in both branches.
4. **Binary File Conflicts**: Git can't automatically merge binary files like images or compiled objects.

## How to Abort a Conflict Operation

If we are overwhelmed or need to start over:

```bash
git merge --abort         # Cancels a merge and restores pre-merge state
git rebase --abort        # Cancels a rebase and resets to original HEAD
git cherry-pick --abort   # Aborts a cherry-pick sequence
```

## Tools for Easier Conflict Resolution

Although not required, tools can help:

* `git mergetool`: Launches a visual merge tool.
* IDEs (e.g., IntelliJ, VS Code) show side-by-side diffs and offer conflict resolution tools.
* `git diff` helps compare changes before and after resolving.

