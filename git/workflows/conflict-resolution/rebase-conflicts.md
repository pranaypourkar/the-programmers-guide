# Rebase Conflicts

## About

Rebasing in Git is the act of **moving or transplanting a sequence of commits** from one base to another. It is primarily used to:

* Maintain a **linear commit history**
* Integrate changes from another branch (e.g., `main`) into our feature branch without merge commits
* Make feature branches look like they were created from the most recent version of the base branch

Instead of showing branches diverging and then merging back together, rebasing “replays” our changes on top of another branch, eliminating the need for a merge commit.

## What Is a Rebase Conflict?

A **rebase conflict** occurs when Git cannot automatically apply one of our commits during a rebase operation. This typically happens when:

* Our changes and the new base branch both modify the **same lines** of code differently.
* The file structure or logic has changed so significantly that Git can’t understand how to apply our changes cleanly.

Rebase conflicts are very similar to merge conflicts, but they happen one commit at a time, and we must resolve each before the rebase can proceed.

## What Triggers Rebase Conflicts?

Let’s explore the types of code changes that often result in rebase conflicts:

1. **Conflicting Code Edits**\
   Both branches edited the same function, block, or line in a file.
2. **Deleted or Renamed Files**\
   One branch deletes or renames a file that the other modifies.
3. **Changes to Project Structure**\
   Refactoring or reorganizing files can lead to conflicts when rebased onto.
4. **Non-trivial History**\
   The commit history is large, old, or complex. The older the branch, the more likely it is to face rebase conflicts because the base branch has changed significantly.

## What Happens Behind the Scenes

When we run:

```bash
git rebase main
```

Git performs the following steps internally:

1. Finds the common ancestor of the current branch and `main`.
2. Temporarily saves all our commits after that point (as patches).
3. Resets our branch to the tip of `main`.
4. Tries to apply each of our saved commits, one at a time, on top of `main`.
5. If one commit fails to apply cleanly, it **stops** and reports a conflict.

At this point, Git **pauses** the rebase and waits for us to resolve the conflict manually.

## The Process to Handle Rebase Conflicts

1.  **Start the rebase:**

    ```bash
    git rebase main
    ```
2. **Rebase pauses on a conflicting commit**:\
   Git will tell us which files are in conflict and mark them with conflict markers.
3. **We manually resolve the conflict**:
   * Edit the file(s)
   * Decide what code to keep and clean up the markers
   * Test our changes
4.  **Stage the file(s):**

    ```bash
    git add <filename>
    ```
5.  **Continue the rebase:**

    ```bash
    git rebase --continue
    ```
6. **Repeat steps 3–5** if there are more conflicts in later commits.
7.  **Abort if needed:**

    ```bash
    git rebase --abort
    ```

    This stops the rebase and restores our branch to its original state.
8.  **Skip a commit (rare):**

    ```bash
    git rebase --skip
    ```

    Skips the problematic commit (only use if we are sure it’s safe to ignore that change).

## Rebase Conflicts vs Merge Conflicts

<table data-full-width="true"><thead><tr><th width="160.87890625">Category</th><th>Rebase Conflict</th><th>Merge Conflict</th></tr></thead><tbody><tr><td>When it Happens</td><td>During replaying individual commits</td><td>When merging full branches</td></tr><tr><td>Scope</td><td>One commit at a time</td><td>Entire history from both branches at once</td></tr><tr><td>Resulting History</td><td>Linear (no merge commits)</td><td>May include merge commits</td></tr><tr><td>Continuation Command</td><td><code>git rebase --continue</code></td><td><code>git commit</code> after resolving</td></tr><tr><td>Complexity</td><td>Can feel more complex if many commits</td><td>Easier to resolve at once but messy history</td></tr><tr><td>Suitable For</td><td>Keeping clean history, personal branches</td><td>Collaborative work, public branches</td></tr></tbody></table>

## Important Points

* If we are working on a **team branch** or have already pushed our changes, **prefer merge** unless all collaborators are comfortable with rebasing.
* If we are preparing a **feature branch for a clean merge**, rebasing onto the latest `main` helps reduce review noise.
* Learn how to **confidently handle conflicts**, because whether we rebase or merge, conflict resolution is a critical part of working with Git.
