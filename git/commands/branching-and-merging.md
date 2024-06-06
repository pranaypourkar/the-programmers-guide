# Branching and Merging

## git branch

### Description

It is used to manage branches in a Git repository. It allows you to create, list, rename, and delete branches.

### Usage

```sh
git branch [<options>] [<branch-name>] [<start-point>]
```

* `<branch-name>`: The name of the branch to create, rename, delete, or list.
* `<start-point>`: (Optional) A commit, tag, or branch from which the new branch will start. Defaults to the current HEAD if not specified.

#### Options

`-d` or `--delete`: Deletes the specified branch. It must be fully merged in its upstream branch or in HEAD.

`-D`: Forcefully deletes the specified branch, even if it has unmerged changes

`-m` or `--move`: Renames the current branch or a specified branch.

`-r` or `--remotes`: Lists remote-tracking branches.

`-a` or `--all`: Lists both local and remote branches.

`--list`: Allows for pattern matching.

```
git branch -d branch-name
git branch -D branch-name
git branch -m old-name new-name
git branch -r
git branch -a
git branch --list 'feature/*'
```

{% hint style="info" %}
**Branch Naming**: Use descriptive branch names to make it clear what the branch is for (e.g., `feature-login`, `bugfix-issue123`, `release-v1.0`).

**Branch Lifecycle**: Typically, you'll create a branch to work on a new feature or bug fix, merge it back into the main branch when done, and then delete it to keep your branch list clean.

**Remote Branches**: Working with remote branches involves using `git fetch`, `git pull`, and `git push` to synchronize changes between local and remote repositories.
{% endhint %}

### Common Use Cases

```git
-- List All Branches
-- Lists all local branches, highlighting the current branch with an asterisk (*)
git branch

-- Create a New Branch
-- Creates a new branch named new-branch from the current HEAD
git branch new-branch

-- Create a New Branch from a Specific Commit
-- Creates a new branch named new-branch starting from the specified commit SHA
git branch new-branch commit-sha

-- Delete a Branch
-- Deletes the specified branch. If the branch has unmerged changes, use the -D option to force delete.
git branch -d old-branch

-- Rename a Branch
-- Renames a branch from old-name to new-name
git branch -m old-name new-name

-- List All Remote Branches
-- Lists all branches from the remote repository
git branch -r

-- List Both Local and Remote Branches
-- Lists all branches, both local and remote
git branch -a
```

### Example Workflow

```
-- 1. Check Current Branches
git branch

-- 2. Create a New Feature Branch
git branch feature-branch

-- 3. Switch to the New Branch
git checkout feature-branch

-- 4. Work on the Feature Branch and Commit Changes
git add .
git commit -m "Work on feature"

-- 5. Merge the Feature Branch into Main
git checkout main
git merge feature-branch

-- 6. Delete the Feature Branch After Merging
git branch -d feature-branch
```

### Example Output

When running `git branch`

<figure><img src="../../.gitbook/assets/image (164).png" alt="" width="227"><figcaption></figcaption></figure>

## git checkout

### Description

It is used for switching between branches, creating new branches, and checking out specific commits or files from your Git history. Although many of its functions have been replaced or supplemented by `git switch` and `git restore`, `git checkout` is still a fundamental Git command with versatile uses.

### Usage

```sh
git checkout [<options>] <branch>
git checkout [<options>] <commit>
git checkout [<options>] <branch> -- <path>
git checkout [<options>] <commit> -- <path>
```

#### Options

`-b <new-branch>`: Creates a new branch and switches to it.

`-B <new-branch>`: Creates a new branch (or resets an existing branch) to the current commit and switches to it.

`-f` or `--force`: Forces the checkout, discarding local changes.

`--ours` / `--theirs`: During a merge conflict, checks out our/their version of a conflicted file.

```
git checkout -b new-branch
git checkout -B new-branch
git checkout -f branch-name
git checkout --ours path/to/file
git checkout --theirs path/to/file
```

{% hint style="info" %}
If we want to checkout remote branch i.e. create new branch and add remote origin reference to it, then create a new branch in remote (Gitlab etc) via UI and do git pull in local to get reference to remote branch. Then we will be able to run checkout remote branch and git push, pull etc will work.h
{% endhint %}

{% hint style="info" %}
**Using `git switch` and `git restore`**: For switching branches and restoring files, Git introduced `git switch` and `git restore` to make commands more intuitive.

Switch branches: **git switch branch-name**

Create and switch to a new branch: **git switch -c new-branch**

Restore files: **git restore path/to/file**
{% endhint %}

{% hint style="info" %}
**Detached HEAD State**: Checking out a specific commit (not a branch) puts us in a detached HEAD state. Any commits made in this state are not associated with any branch and can be lost if not handled properly. See the detached head workflow below.
{% endhint %}

### Example Workflows

#### Workflow involving creation of new branch

```git
-- Check Current Branch
git branch

-- Create and Switch to a New Feature Branch
git checkout -b new-feature-branch

-- Work on the Feature and Commit Changes
echo "New feature" > feature.txt
git add feature.txt
git commit -m "Add new feature"

-- Switch Back to Main Branch
git checkout main

-- Merge Feature Branch into Main
git merge feature-branch

-- Delete Feature Branch
git branch -d feature-branch
```

#### Workflow involving detached head and how to recover

```git
-- Enter Detached HEAD State
-- Replace commit-sha with the SHA-1 hash of the commit we want to check out. This puts in a detached HEAD state.
git checkout commit-sha

-- Verify Detached HEAD State
-- We will see a message indicating that you are in a detached HEAD state
git status
-- Sample message -> HEAD detached at commit-sha

-- Work in Detached HEAD State
-- Make changes and commit them if needed. Remember, these commits are not on any branch yet.
echo "Changes in detached HEAD state" > file.txt
git add file.txt
git commit -m "Commit in detached HEAD state"

-- Create a New Branch from Detached HEAD State
-- If we want to keep the changes and not lose them, we should create a new branch from the detached HEAD state
-- This command creates a new branch named new-branch starting from the current commit and switches to it.
git checkout -b new-branch

-- Verify New Branch
-- With this we will see that we are now on the new-branch
git branch

-- Switch Back to Main Branch
-- If we decide not to keep the changes made in the detached HEAD state, we can simply switch back to an existing branch (e.g., main):
-- This will leave our detached HEAD state and switch back to the main branch
git checkout main

-- Verify Branch Switch
git status
```

{% hint style="info" %}
**Detached HEAD State**: Be cautious when working in a detached HEAD state. If we make commits and do not create a new branch, these commits can be lost when we switch branches.
{% endhint %}

### Example Output

When running `git checkout branch-name`

<figure><img src="../../.gitbook/assets/image.png" alt="" width="311"><figcaption></figcaption></figure>

When creating and switching to a new branch with `git checkout -b new-branch`

<figure><img src="../../.gitbook/assets/image (1).png" alt="" width="302"><figcaption></figcaption></figure>

## git merge

### Description

It is used to combine changes from different branches into a single branch. This is an essential feature for collaborative workflows, where multiple contributors work on different features or fixes in separate branches and then need to integrate these changes into a main branch.

{% hint style="info" %}
**Fast-forward Merges**: These occur when the current branch has no new commits since the branch being merged was created, making it unnecessary to create a merge commit.

**Three-way Merges**: These occur when both branches have new commits since the last common ancestor, requiring Git to create a merge commit to combine the changes.

**Merge Conflicts**: Conflicts arise when changes in the two branches overlap. Git marks these conflicts in the files, and they must be resolved manually.
{% endhint %}

### Usage

```sh
git merge [<options>] <branch>
```

* `<branch>`: The branch that we want to merge into your current branch.

#### Options

`--no-ff`: Creates a merge commit even if the merge resolves as a fast-forward. This preserves the feature branch's history.

`--ff-only`: Ensures that the merge can only happen if it's a fast-forward merge. If not, the merge is aborted.

`-squash`: Combines all changes from the branch being merged into a single commit on the target branch.

`-m <message>`: Allows you to specify a commit message for the merge commit.

```
git merge --no-ff feature-branch
git merge --ff-only feature-branch
git merge --squash feature-branch
git merge -m "Merge feature-branch into main" feature-branch
```

### What It Does

1. **Fast-forward Merge**: If the current branch has not diverged from the branch being merged, Git simply moves the current branch pointer forward.
2. **Three-way Merge**: If the branches have diverged, Git performs a three-way merge using the common ancestor of the two branches. This can result in merge conflicts that need to be resolved manually.

### Common Use Cases

```git
-- Merge a Feature Branch into Main
-- This merges feature-branch into the main branch
git checkout main
git merge feature-branch

-- Merge and Create a Merge Commit
-- This forces a merge commit, even if a fast-forward merge is possible. This is useful for preserving the history of feature branches.
git merge --no-ff feature-branch

-- Abort a Merge in Progress
-- This aborts the merge process and returns the branch to its pre-merge state.
git merge --abort

```

### Example Workflow

```
-- Create a Feature Branch and Switch to It
git checkout -b feature-branch

-- Make Changes and Commit
echo "New feature" > feature.txt
git add feature.txt
git commit -m "Add new feature"

-- Switch Back to Main Branch
git checkout main

-- Merge the Feature Branch into Main
git merge feature-branch

```

### Example Output

When running `git merge feature-branch`

<figure><img src="../../.gitbook/assets/image (2).png" alt="" width="251"><figcaption></figcaption></figure>

If a merge commit is created (for a three-way merge)

<figure><img src="../../.gitbook/assets/image (4).png" alt="" width="327"><figcaption></figcaption></figure>

### Merge Conflicts

If there are conflicting changes in the branches being merged, Git will highlight these conflicts, and we'll need to resolve them manually. After resolving conflicts, we need to stage the changes and complete the merge with -

```sh
git add .
git commit
```

### Resolve Git Merge Conflicts

Merge conflicts occur when changes from different branches interfere with each other and Git can't automatically combine them. Resolving merge conflicts involves identifying conflicting changes, deciding which changes to keep, and then completing the merge process.

#### Example Workflow to Resolve Merge Conflicts

```git
----------- Prepare our Branches (main and feature)
-- Initialize a new Git repository
git init conflict-demo
cd conflict-demo

-- Create and switch to the main branch
git checkout -b main

-- Create a sample file and commit it
echo "Line 1" > example.txt
git add example.txt
git commit -m "Initial commit on main"

-- Create and switch to the feature branch
git checkout -b feature

-- Make changes to the file in the feature branch
echo "Line 2 from feature" >> example.txt
git add example.txt
git commit -m "Add Line 2 from feature"

-- Switch back to the main branch
git checkout main

-- Make conflicting changes to the file in the main branch
echo "Line 2 from main" >> example.txt
git add example.txt
git commit -m "Add Line 2 from main"
-----------


-- Merge the Feature Branch into Main
-- Attempt to merge the feature branch into the main branch, which will result in a conflict.
git merge feature

-- Git Identifies Conflicts
-- Git will detect conflicts and pause the merge process. We will see output like this
# Auto-merging example.txt
# CONFLICT (content): Merge conflict in example.txt
# Automatic merge failed; fix conflicts and then commit the result.

-- Check the Status
-- Verify the status to see which files are in conflict
git status
#On branch main
#You have unmerged paths.
#  (fix conflicts and run "git commit")
#  (use "git merge --abort" to abort the merge)

# Unmerged paths:
#  (use "git add <file>..." to mark resolution)
#        both modified:   example.txt

-- Open and Resolve Conflicts
-- Open the conflicted file (example.txt) in a text editor. Git will mark the conflicts like this
# Line 1
# <<<<<<< HEAD
# Line 2 from main
# =======
# Line 2 from feature
# >>>>>>> feature

-- Resolve the conflict by deciding which lines to keep, modify, or combine. For example, we  qcould resolve it to:
-- Save the file after resolving the conflict.
# Line 1
# Line 2 from main
# Line 2 from feature

-- Add the Resolved File
-- After resolving conflicts, mark the file as resolved by adding it to the staging area.
git add example.txt

--  Complete the Merge
-- Commit the resolved changes to complete the merge
git commit -m "Resolve merge conflict between main and feature"

-- Verify the Merge
-- Check the status and log to ensure the merge is completed successfully.
git status
git log --oneline --graph

```

{% hint style="info" %}
#### Tips for Resolving Conflicts

* **Use a Merge Tool**: Tools like `kdiff3`, `meld`, or IDE-integrated tools can help visualize and resolve conflicts.
* **Commit Often**: Smaller, frequent commits make it easier to resolve conflicts.
* **Communicate**: Coordinate with your team to avoid overlapping changes.
* **Test Thoroughly**: After resolving conflicts, ensure that the project works as expected.
{% endhint %}



## **git switch**&#x20;

### Description





## **git restore**

### Description





## git rebase

### Description

