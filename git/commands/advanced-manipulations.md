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



### Usage





## git cherry-pick

### Description



### Usage
