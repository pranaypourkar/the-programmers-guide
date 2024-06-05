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





## git merge

### Description





## git rebase

### Description







