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

<figure><img src="../../.gitbook/assets/image (4) (1) (1).png" alt="" width="311"><figcaption></figcaption></figure>

When creating and switching to a new branch with `git checkout -b new-branch`

<figure><img src="../../.gitbook/assets/image (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt="" width="302"><figcaption></figcaption></figure>

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

<figure><img src="../../.gitbook/assets/image (2) (1) (1) (1) (1) (1) (1) (1) (1).png" alt="" width="251"><figcaption></figcaption></figure>

If a merge commit is created (for a three-way merge)

<figure><img src="../../.gitbook/assets/image (4) (1) (1) (1).png" alt="" width="327"><figcaption></figcaption></figure>

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

It is used to switch branches or restore working tree files. It was introduced to provide a more intuitive and focused way to switch branches compared to `git checkout`, which can be confusing due to its multiple functionalities.

### Usage

```sh
git switch [<options>] <branch>
git switch -c <new-branch>
```

#### Options

`-c <new-branch>` or `--create <new-branch>`: Creates a new branch and switches to it.

`-C <new-branch>` or `--create-force <new-branch>`: Creates a new branch and switches to it, or resets an existing branch to start from the current HEAD.

`--detach`: Switches to the specified commit without creating a new branch, putting you in a detached HEAD state.

`-d` or `--discard-changes`: Discards local changes in the working directory when switching branches.

`--force` or `-f`: Forces the switch, discarding local changes if necessary.

<pre class="language-sh"><code class="lang-sh">git switch -c new-branch
<strong>git switch -C new-branch
</strong>git switch --detach commit-sha
<strong>git switch -d branch-name
</strong>git switch --force branch-name
</code></pre>

### What It Does

1. **Switches to an Existing Branch**: Changes the current working branch to another specified branch.
2. **Creates and Switches to a New Branch**: Creates a new branch and switches to it in one command.

{% hint style="info" %}
**Detached HEAD State**: Using `git switch --detach commit-sha` puts you in a detached HEAD state, meaning you are not on a branch. Any commits made in this state are not associated with any branch and can be lost if not handled properly.
{% endhint %}

{% hint style="info" %}
**Switch vs. Checkout**: While `git switch` focuses on changing branches, `git checkout` can also be used to check out files or commits. Git introduced `git switch` and `git restore` to make these operations more intuitive:

* `git switch` for switching branches.
* `git restore` for restoring files.
{% endhint %}

### Common Use Cases

```git
-- Switch to an Existing Branch
-- This switches the current working branch to branch-name.
-- This attempts to switch to branch-name even if there are uncommitted changes in the current branch. 
-- If the switch cannot be completed due to conflicts, Git will inform and we must resolve these before switching.
git switch branch-name

-- Create and Switch to a New Branch
-- This creates a new branch named new-branch and switches to it.
git switch -c new-branch
```

### Example Workflow

```
-- Check Current Branch
git branch

-- Create and Switch to a New Feature Branch
git switch -c feature-branch

-- Work on the Feature and Commit Changes
echo "New feature" > feature.txt
git add feature.txt
git commit -m "Add new feature"

-- Switch Back to Main Branch
git switch main
```

### Example Output

When running `git switch branch-name`

<figure><img src="../../.gitbook/assets/image (3) (1) (1) (1) (1).png" alt="" width="279"><figcaption></figcaption></figure>

When creating and switching to a new branch with `git switch -c new-branch`

<figure><img src="../../.gitbook/assets/image (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt="" width="281"><figcaption></figcaption></figure>

## **git restore**

### Description

It is used to restore working tree files. It was introduced to provide a more focused way to undo changes and restore files compared to the multi-functional `git checkout` command.

### Usage

```sh
git restore [<options>] [--source=<tree>] [--staged] [--worktree] [--] <pathspec>…
```

#### Options

`--source=<tree>`: Specifies the source from which to restore the file. This can be a commit hash, branch name, tag, etc.

`--staged`: Restores the specified file(s) from the staging area, effectively unstaging them.

`--worktree`: Restores the specified file(s) in the working directory. This is the default behavior.

`--force` or `-f`: Forcefully restores the file, discarding any uncommitted changes.

```
git restore --source=commit-sha <file>
git restore --staged <file>
git restore --worktree <file>
git restore --force <file>
```

### What It Does

1. **Restores Files to Their Last Committed State**: Discards changes in the working directory, reverting files to their state at the last commit.
2. **Unstages Files**: Moves files from the staging area back to the working directory.
3. **Restores Files from a Specific Commit**: Reverts files to their state at a specific commit.

{% hint style="info" %}
**Safety**: `git restore` is a safer way to handle file restoration compared to `git checkout`, as it is more explicit in its intentions and helps avoid unintended switches between branches or commits.
{% endhint %}

### Common Use Cases

```git
-- Discard Local Changes in the Working Directory
-- Reverts the specified file to its state at the last commit.
git restore <file>

-- Unstage Changes
-- Removes the specified file from the staging area, keeping the changes in the working director
git restore --staged <file>

-- Restore a File from a Specific Commit
-- Restores the specified file to its state in the specified commit.
git restore --source=<commit> <file>
```

### Example Workflow

```git
-- Modify a File
echo "Some changes" > file.txt

-- Check the Status
git status
# On branch main
# Changes not staged for commit:
# (use "git add <file>..." to update what will be committed)
# (use "git restore <file>..." to discard changes in working directory)
#   modified:   file.txt

-- Discard Changes in the Working Directory
-- This reverts file.txt to its state at the last commit
git restore file.txt

-- Stage the File and Then Unstage It:
git add file.txt
git restore --staged file.txt

-- Restore a File to a Specific Commit
git restore --source=commit-sha file.txt
```

### Example Output

When running `git restore file.txt`, we might see no output if the command succeeds, and the file will be reverted to its last committed state. If there are errors, such as the file not being in the specified source, Git will inform you of the issue.



## git rebase

### Description

It is used to integrate changes from one branch into another. It is an alternative to merging, but instead of creating a new commit that combines the changes from the branches, rebasing moves or reapplies commits from one branch onto another. This results in a cleaner, linear project history.

### Usage

```sh
git rebase [<options>] [<upstream>] [<branch>]
```

#### Options

`-i` or `--interactive`: Starts an interactive rebase session where you can edit, reorder, squash, or drop commits.

`--continue`: Continues the rebase process after conflicts have been resolved.

`-skip`: Skips the current commit and proceeds with the rebase

`--abort`: Aborts the rebase process and resets the branch to its state before the rebase started.

`--onto <newbase>`: Rebases the commits onto a new base.

```
git rebase -i main
git rebase --continue
git rebase --skip
git rebase --abort
git rebase --onto newbase oldbase feature-branch
```

### What It Does

1. **Moves Commits**: Takes the commits from your current branch and applies them onto another branch.
2. **Reapplies Commits**: The commits are reapplied one by one on top of the new base commit.

{% hint style="info" %}
**Linear History**: Rebasing is often used to maintain a linear project history, making it easier to follow and review.

**Rewriting History**: Rebase changes commit hashes, effectively rewriting history. This can cause issues if you rebase commits that have already been pushed to a shared repository.

**Interactive Rebase**: Interactive rebasing is powerful for cleaning up commits, such as combining multiple commits into a single commit or editing commit messages
{% endhint %}

### Common Use Cases

```git
-- Rebase Current Branch onto Another Branch
-- Moves the commits from feature-branch to the tip of main
git checkout feature-branch
git rebase main

-- Interactive Rebase
-- Allows to edit, squash, reorder, or drop commits during the rebase process
git rebase -i main

-- Continue a Rebase After Resolving Conflicts
-- After resolving conflicts during a rebase, this command continues the rebase process
git rebase --continue

-- Skip a Commit during a Rebase
-- Skips the current patch (commit) and proceeds with the rebase
git rebase --skip

-- Abort a Rebase in Progress
-- Stops the rebase process and resets the branch to its original state before the rebase started.
git rebase --abort
```

### Example Workflow

```
-- Check Current Branch
git branch

-- Rebase Feature Branch onto Main
git checkout feature-branch
git rebase main

-- Resolve Any Conflicts:

-- If conflicts arise, Git will pause the rebase and mark the conflicts in the files. 
-- We need to resolve these conflicts manually.

-- Continue the Rebase
git add .
git rebase --continue

-- If Another Conflict Arises
-- Repeat the conflict resolution steps and continue the rebase until it completes.

```

### Example Output

When running `git rebase main`

<figure><img src="../../.gitbook/assets/image (2) (1) (1) (1) (1) (1) (1) (1).png" alt="" width="494"><figcaption></figcaption></figure>

If a conflict occurs, Git will provide instructions.

<figure><img src="../../.gitbook/assets/image (3) (1) (1) (1) (1) (1).png" alt="" width="534"><figcaption></figcaption></figure>

### Rebase vs Merge

<table data-full-width="true"><thead><tr><th width="210">Feature</th><th>Git Rebase</th><th>Git Merge</th></tr></thead><tbody><tr><td><strong>Purpose</strong></td><td>Reapply commits on top of another base branch</td><td>Combine the histories of two branches</td></tr><tr><td><strong>History</strong></td><td>Creates a linear, cleaner history</td><td>Creates a history with merge commits</td></tr><tr><td><strong>Commit Hashes</strong></td><td>Changes commit hashes (rewrites history)</td><td>Preserves commit hashes</td></tr><tr><td><strong>Usage Scenario</strong></td><td>Clean up feature branch before merging into main</td><td>Regularly integrating changes from one branch to another</td></tr><tr><td><strong>Conflicts</strong></td><td>Must be resolved during the rebase process</td><td>Must be resolved during the merge process</td></tr><tr><td><strong>Branch State After</strong></td><td>Current branch starts from the tip of the target branch</td><td>Current branch includes a merge commit</td></tr><tr><td><strong>Merge Commits</strong></td><td>No merge commits; commits are replayed individually</td><td>Creates a merge commit</td></tr><tr><td><strong>Local/Remote</strong></td><td>Best for local branch integration</td><td>Commonly used for both local and remote integration</td></tr><tr><td><strong>Impact on History</strong></td><td>Rewrites commit history</td><td>Adds to commit history</td></tr><tr><td><strong>Interactive Option</strong></td><td>Supports interactive rebase to edit, squash, reword commits</td><td>Does not support interactive merges</td></tr><tr><td><strong>Conflicts Resolution</strong></td><td>Conflicts need to be resolved as they appear and then continue</td><td>Conflicts resolved once during merge</td></tr><tr><td><strong>Usage Command</strong></td><td><code>git rebase target-branch</code></td><td><code>git merge target-branch</code></td></tr><tr><td><strong>Typical Use Case</strong></td><td>Clean up commit history before merging feature branches</td><td>Regular updates and integration of branches</td></tr><tr><td><strong>Visual History</strong></td><td>Linear and simplified</td><td>Branched with merge commits</td></tr></tbody></table>



## git tag

### Description

It is used to create, list, delete, and verify tags in Git. Tags are used to mark specific points in the repository’s history, typically used for marking release points (e.g., v1.0.0, v2.0.0).

### Usage

```git
---- Creating a Tag
-- Lightweight Tag: A lightweight tag is simply a pointer to a specific commit
git tag <tagname>
-- Annotated Tag: An annotated tag is stored as a full Git object and contains additional metadata such as the tagger name, email, date, and a message.
git tag -a <tagname> -m "Tag message"

---- Listing Tags
git tag

---- Viewing a Tag's Details
git show <tagname>

---- Deleting a Tag
git tag -d <tagname>

---- Pushing Tags to Remote
-- Push a single tag
git push origin <tagname>
-- Push all tags
git push origin --tags

---- Deleting a Remote Tag
-- Delete locally
git tag -d <tagname>
-- Delete from remote
git push origin :refs/tags/<tagname>
```

### Example Workflow

```
---- Tagging a New Release
-- Create an annotated tag for the new release
git tag -a v1.2.0 -m "Release version 1.2.0 with new features"
-- Push the tag to the remote repository
git push origin v1.2.0

---- Listing and Verifying Tags
-- List all tags
git tag
-- View details of a specific tag
git show v1.2.0

---- Deleting a Tag
-- Delete a tag locally
git tag -d v1.1.0
-- Delete the same tag from the remote repository
git push origin :refs/tags/v1.1.0
```

### Example output

Viewing Tag Information with `git show v1.0.0`

<figure><img src="../../.gitbook/assets/image (3) (1) (1).png" alt="" width="505"><figcaption></figcaption></figure>

