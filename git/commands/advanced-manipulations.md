# Advanced Manipulations

## git reset

### Description

It is used to undo changes in our working directory and staging area, and it can also move the current branch to a different commit. This command is very powerful and can be used in a variety of scenarios to reset the state of your repository.

### Usage

```sh
git reset [<mode>] [<commit>]
```

#### Options

`--soft`: Resets the HEAD to the specified commit, but leaves the index and working directory unchanged.

`--mixed`: Resets the HEAD and index to the specified commit, but leaves the working directory unchanged.

`--hard`: Resets the HEAD, index, and working directory to the specified commit.

`--keep`: Resets the HEAD to the specified commit, but keeps the working directory unchanged unless there are uncommitted changes that would be overwritten.

`--merge`: Resets the HEAD to the specified commit and resets the index to match, but keeps the working directory unchanged unless there are uncommitted changes that would be overwritten.

```
git reset --soft HEAD~1
git reset HEAD~1
git reset --hard HEAD~1
git reset --keep HEAD~1
git reset --merge HEAD~1
```

### Modes

There are three primary modes for `git reset`: `--soft`, `--mixed`, and `--hard`. Each mode affects the repository differently.

1. **`--soft`**: Moves the HEAD to the specified commit but does not touch the index (staging area) or the working directory.
2. **`--mixed`** (default): Moves the HEAD to the specified commit and resets the index, but does not touch the working directory.
3. **`--hard`**: Moves the HEAD to the specified commit and resets both the index and working directory to match the specified commit.

### Common Use Cases

```
-- Move HEAD to a Specific Commit (Soft Reset)
-- Moves HEAD to the specified commit without changing the index or working directory. 
-- This is useful for undoing commits while keeping changes staged for the next commit.
git reset --soft <commit>

-- Unstage Changes (Mixed Reset)
-- (Default to --mixed mode) Moves HEAD to the specified commit and resets the index, but leaves the working directory unchanged. 
-- This unstages changes that were previously added with git add
git reset <commit>

-- Discard All Changes (Hard Reset) 
-- Moves HEAD to the specified commit and resets both the index and working directory. 
-- This discards all changes in the working directory and index, reverting to the state of the specified commit.
git reset --hard <commit>

-- Unstage All Changes
-- Unstages all changes, leaving the working directory unchanged. 
-- Equivalent to git reset --mixed HEAD
git reset
```

### Example Workflow

#### When There Are No Changes in the Working Directory

**Scenario:**

We have no changes in the working directory and want to move the current branch to a previous commit.

**Commands:**

```sh
-- Reset HEAD to the previous commit, keeping the working directory clean
git reset --hard HEAD~1
```

**Explanation:**

* This command moves the HEAD to the previous commit and resets both the index and working directory to match this commit.
* Since there are no changes in the working directory, this operation is straightforward and safe.



#### When There Are Changes in the Working Directory

**Scenario:**

We have uncommitted changes in the working directory that want to discard.

**Commands:**

```sh
-- Discard changes in the working directory
git reset --hard HEAD
```

**Explanation:**

* This command resets the working directory and index to match the current commit, effectively discarding all uncommitted changes.
* Use with caution as this will permanently delete your changes.



#### When There Are Changes in the Working Directory and Staged Changes

**Scenario:**

We have both staged and unstaged changes that we want to unstage but keep in the working directory.

**Commands:**

```sh
-- Unstage all changes but keep them in the working directory
git reset
```

**Explanation:**

* This command resets the index to match the current commit but leaves the working directory unchanged.
* All changes that were staged are now unstaged but remain in the working directory.



#### When There Are Changes in the Working Directory, Staged Changes, and Commits

**Scenario:**

We have changes in the working directory, staged changes, and we want to undo the last commit but keep the changes in the working directory and staging area.

**Commands:**

```sh
-- Undo the last commit but keep changes in the working directory and staging area
git reset --soft HEAD~1
```

**Explanation:**

* This command moves the HEAD to the previous commit but keeps all changes in the working directory and index.
* Useful for undoing a commit while keeping your changes for further editing.



#### When There Are Changes in the Working Directory, Staged Changes, Commits, and the Commit Has Been Pushed to Remote

**Scenario:**

You have changes in the working directory, staged changes, commits, and you have pushed the commit to a remote repository. Now you want to revert the push commit.

**Commands:**

```sh
-- Undo the last commit locally, keep the changes in the working directory and staging area
git reset --soft HEAD~1

-- Amend the changes if necessary
-- git add <files> (if you need to stage changes again)
-- git commit -m "New commit message" (if you want to amend the commit)

-- Force push the changes to the remote repository
git push --force
```

**Explanation:**

* `git reset --soft HEAD~1` moves the HEAD to the previous commit but keeps the changes in the working directory and staging area.
* If needed, you can amend the changes and commit again.
* `git push --force` updates the remote repository to match your local repository, effectively undoing the previous commit. Use this command with caution, especially in shared repositories, as it rewrites the commit history.



## git reflog

### Description

It is used to record updates to the tip of branches and other references in the Git repository. It allows to view the history of changes to the HEAD reference, including actions such as commits, resets, and checkouts. This is particularly useful for recovering lost commits or changes that we thought were gone.

### Usage

```sh
git reflog
```

#### What It Does

1. **Records History**: Keeps a log of where our references have been, including branch tips and HEAD.
2. **Recovery Tool**: Helps to recover commits or branches that have been altered or deleted.
3. **View Actions**: Shows actions that have changed the state of our repository.

{% hint style="info" %}
**Cleanup Reflog**:

Over time, the reflog can grow large. To expire old entries:

```sh
git reflog expire --expire=30.days.ago --all
```

And then to prune the reflog:

<pre><code><strong>git gc --prune=now
</strong></code></pre>
{% endhint %}

<figure><img src="../../.gitbook/assets/image (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt="" width="473"><figcaption></figcaption></figure>

### Common Use Cases

```
-- View Reference Logs
-- Displays a list of all changes made to the HEAD, including the commit SHA, the action taken, and a brief description.
git reflog

-- Recover Lost Commits
-- If we've lost a commit, we can find its SHA in the reflog and check it out
git reflog
git checkout <commit-SHA>

-- Undo a Recent Change
-- We an use the reflog to find a previous state of our repository and reset to that state
git reflog
git reset --hard <commit-SHA>
```

### Example Workflow

```
-- View Recent HEAD Changes
git reflog
# Example output:
# 1234567 (HEAD -> main) HEAD@{0}: commit: Added new feature
# 89abcdef HEAD@{1}: reset: moving to HEAD~1
# fedcba98 HEAD@{2}: commit: Fixed a bug
# 7654321 HEAD@{3}: commit: Initial commit

-- Recover a Lost Commit
-- Suppose we accidentally reset our branch and lost a commit. We can find it using the reflog
git reflog
-- Find the SHA of the lost commit from the reflog output. Let's say it's 89abcdef
git checkout 89abcdef
-- If we want to move our branch pointer back to this commit, we can create a new branch or reset our current branch
git checkout -b recover-lost-commit 89abcdef
-- Or Reset
git reset --hard 89abcdef

-- Undo a Hard Reset
-- If we've done a hard reset and want to revert it, find the previous state in the reflog
git reflog
-- Let's say we find the desired commit SHA as fedcba98.
git reset --hard fedcba98
```



## git cherry-pick

### Description

It allows us to apply the changes from one or more existing commits to the current branch. This is useful when we want to copy a commit from another branch without merging the entire branch. Cherry-picking can be helpful for backporting bug fixes or features to another branch.

### Usage

```sh
git cherry-pick <commit>
```

#### Options

`--continue`: Resumes the cherry-pick after resolving conflicts.

`--abort`: Aborts the cherry-pick process and tries to return the branch to its previous state.

`--quit`: Stops the cherry-pick but keeps the changes in the working directory.

`-n` or `--no-commit`: Applies the changes from the specified commits without creating a commit.

`-x`: Appends a line to the commit message indicating which commit this change was cherry-picked from.

```
git cherry-pick --continue
git cherry-pick --abort
git cherry-pick --quit
git cherry-pick -n <commit>
git cherry-pick -x <commit>
```

### What It Does

1. **Applies Commit Changes**: Copies the changes introduced by the specified commit(s) to the current branch.
2. **Commits the Changes**: Automatically creates a new commit with these changes.

### Common Use Cases

<pre><code>-- Single Commit
-- Applies the changes from a single commit to the current branch
git cherry-pick &#x3C;commit>

-- Multiple Commits
-- Applies changes from multiple commits in the specified order.
git cherry-pick &#x3C;commit1> &#x3C;commit2> &#x3C;commit3>

-- Range of Commits
-- Applies changes from a range of commits, not including &#x3C;commit1> but including &#x3C;commit2>.
git cherry-pick &#x3C;commit1>..&#x3C;commit2>

-- Continuing After Conflict Resolution
-- If a conflict occurs during cherry-picking, resolve the conflicts and then continue
git add &#x3C;resolved-files>
git cherry-pick --continue

-- Abort Cherry-Pick:
<strong>-- If you want to abort a cherry-pick in progress
</strong>git cherry-pick --abort
</code></pre>

### Example Workflow

#### Scenario: Hotfix on a Production Branch

Imagine we have a `main` branch where our main development happens and a `production` branch that reflects the code running in production. A critical bug is found in production, and we fix it on a feature branch. We need to apply this fix to both the `production` branch and the `main` branch.

```
-----Branch Setup-----
-- Assume we are currently on the main branch
git checkout main
git pull origin main

-- Create a new branch for the hotfix
git checkout -b hotfix/critical-bug


-----Fix the Bug and Commit------
-- Edit files to fix the bug
vim critical_file.py

-- Stage and commit the fix
git add critical_file.py
git commit -m "Fix critical bug affecting production"


------Merge the Fix to main------
-- Switch back to the main branch
git checkout main

-- Merge the hotfix branch into main
git merge hotfix/critical-bug

-- Push the changes to the remote main branch
git push origin main


-------Apply the Fix to production Using Cherry-Pick----
-- Switch to the production branch
git checkout production
git pull origin production

-- Cherry-pick the hotfix commit from main to production
git cherry-pick <hotfix-commit-sha>

-- Resolve any conflicts if necessary
-- If conflicts occur, resolve them manually, then:
git add <resolved-files>
git cherry-pick --continue

-- Push the changes to the remote production branch
git push origin production
```

Summary

* **Hotfix Branch**: Create a hotfix branch to fix the issue.
* **Commit the Fix**: Make changes and commit them on the hotfix branch.
* **Merge to Main**: Merge the hotfix branch into `main` and push.
* **Cherry-Pick to Production**: Apply the fix to `production` using `git cherry-pick` and handle any conflicts that arise.
* **Push to Production**: Push the changes to the remote `production` branch.



#### Handling Conflicts During Cherry-Picking

If there are conflicts when cherry-picking, we will see something like this

<figure><img src="../../.gitbook/assets/image (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt="" width="375"><figcaption></figcaption></figure>

```
-----Steps to resolve conflicts------
-- Check the files with conflicts
git status

-- Edit the files to resolve conflicts
-- Resolve conflicts manually
vim critical_file.py  

-- Stage the resolved files
git add critical_file.py

-- Continue the cherry-pick process
git cherry-pick --continue

-- Push the resolved changes
git push origin production
```

