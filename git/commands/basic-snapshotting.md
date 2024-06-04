# Tracking Changes

## git status

### Description

It is used to display the state of the working directory and the staging area. It shows which changes have been staged, which haven't, and which files aren't being tracked by Git. This command is very useful for getting a quick overview of the current status of the repository.

### Usage

```sh
git status [<options>]
```

#### What It Shows

* **Untracked Files**: Files in your working directory that aren't tracked by Git.
* **Tracked Files**: Files that are tracked by Git and have changes that haven't been staged yet.
* **Staged Changes**: Files that have changes staged for the next commit.
* **Branch Information**: The current branch you are on and whether your local branch is ahead, behind, or has diverged from the remote branch.

### Example Output

Here’s an example of what `git status` might display

<figure><img src="../../.gitbook/assets/image.png" alt=""><figcaption></figcaption></figure>

Or

```git
On branch main
Your branch is up to date with 'origin/main'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        modified:   file1.txt
        new file:   file2.txt

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   file3.txt

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        file4.txt
```

#### Breakdown of Example Output

* **Branch Information**:
  * `On branch main`: Indicates the current branch.
  * `Your branch is up to date with 'origin/main'.`: Shows synchronization status with the remote branch.
* **Staged Changes (Changes to be committed)**:
  * `modified: file1.txt`: `file1.txt` has been modified and staged.
  * `new file: file2.txt`: `file2.txt` is a new file that has been staged.
* **Changes Not Staged for Commit**:
  * `modified: file3.txt`: `file3.txt` has been modified but not staged.
* **Untracked Files**:
  * `file4.txt`: `file4.txt` is a new file that isn't being tracked by Git.

### Common Options

* `-s` or `--short` : It gives the output in a more concise, short format.

Example short format output:

```ruby
M file3.txt
?? file4.txt
```

{% hint style="info" %}
`M` indicates a modified file.\
`??` indicates an untracked file.
{% endhint %}

* `-b` or `--branch:` Shows the branch and tracking information in a short format.

```sh
git status -s
git status -b
```

{% hint style="info" %}
* **Status Indication**: `git status` provides hints on what to do next, such as commands to stage files, unstage files, or discard changes.
* **Performance**: `git status` can be slow in large repositories because it checks the entire working directory. In such cases, using `git status -uno` (show untracked files only) might improve performance.
{% endhint %}

### Common Workflow

```git
-- Check Status
git status

-- Stage Changes
git add file3.txt

-- Check Status Again
git status

-- Commit Staged Changes
git commit -m "Modify file3.txt"

-- Check Status After Commit
git status
```



## git diff

### Description

The `git diff` command is used to show changes between commits, commit and working tree, etc. It is a powerful tool for inspecting the differences between various states of a repository.

{% hint style="info" %}
By default, git diff shows the differences in the command-line interface. However, it is also possible to use tools like graphical diff viewers to make it easier to review changes. For example, git difftool can be used to open a graphical diff viewer, such as Beyond Compare or KDiff3 or meld etc.
{% endhint %}

### Usage

```sh
git diff [<options>] [<commit>] [--] [<path>...]
```

#### Basic Use Cases

```git
-- Compare Working Directory to Staging Area
-- Shows changes between the working directory and the staging area.
git diff

-- Compare Staging Area to Last Commit
-- Shows changes between the staging area and the last commit
git diff --staged

-- Compare Working Directory to Last Commit
-- Shows changes between the working directory and the last commit
git diff HEAD

-- Compare Two Commits
-- Shows changes between two specific commits
git diff <commit1> <commit2>

-- Compare a Specific File
-- Shows changes in a specific file between the working directory and a commit, or between two commits.
git diff <commit> -- <file>

-- Compare Branches
-- Shows changes between two branches
git diff <branch1> <branch2>
```

### Common Options

* `--staged` or `--cached`: Compare the staged changes with the last commit.
* `--name-only`: Show only the names of changed files.
* `--name-status`: Show the names and status of changed files.
* `-p` or `--patch`: Generate patch (standard output format).
* `--stat`: Show a summary of changes
* `-U<n>` or `--unified=<n>`: Generate diffs with \<n> lines of context.
* `--color`: Colorize the diff output.

```git
git diff --staged
git diff --name-only
git diff --name-status
git diff -p
git diff --stat
git diff -U3
git diff --color
```

### Example Outputs

```
git diff
```

<figure><img src="../../.gitbook/assets/image (1).png" alt="" width="539"><figcaption></figcaption></figure>

```
git diff <filename>
```

<figure><img src="../../.gitbook/assets/image (2).png" alt="" width="539"><figcaption></figcaption></figure>

```
git diff --stat
```

<figure><img src="../../.gitbook/assets/image (3).png" alt="" width="467"><figcaption></figcaption></figure>



## git add

### Description

It is used to add changes in the working directory to the staging area. This command prepares the changes to be included in the next commit.

### Usage

```sh
git add [<options>] [--] <pathspec>...
```

* `<pathspec>`: Specifies the files or directories to be added. This can be a specific file, a directory, or a pattern.
* `[--]`: Used to separate paths from options, useful if the paths might be mistaken for options.

### What It Does

1. **Stages Changes**: Adds changes in specified files or directories to the staging area.
2. **New and Modified Files**: Tracks new files and stages changes in modified files.
3. **Does Not Affect Unchanged Files**: Does not change the state of files that haven't been modified.

{% hint style="info" %}
* **Staging Area**: The staging area (also called the index) is an intermediate area where changes are listed to be included in the next commit. This allows to build up a commit incrementally, adding and reviewing changes before committing them.
* **Removing Files**: To remove a file from the staging area, use:

git restore --staged filename.txt

* **Interactive Mode**: Using `git add -p` is especially useful for selectively staging parts of files.
{% endhint %}

### Common Use Cases

```git
-- Add a Specific File
-- Stages changes in filename.txt for the next commit
git add filename.txt

-- Add All Changes
-- Stages all changes in the current directory and subdirectories
git add .


-- Add All Changes (Except Untracked Files)
-- Stages modifications and deletions, but not new untracked files
git add -u

-- Add All Changes in a Specific Directory
-- Stages all changes in the specified directory
git add path/to/directory

-- Add Changes Matching a Pattern
-- Stages changes in all .txt files
git add '*.txt'

-- Removing Files
-- To remove a file from the staging area
git restore --staged filename.txt
```

### Options

`-A` or `--all`: Stages all changes (modifications, deletions, and untracked files).

`-p` or `--patch`: Interactively stage changes, allowing you to review each hunk before staging

`-u` or `--update`: Stages modifications and deletions, but not new untracked files.

`-n` or `--dry-run`: Shows what would be staged without actually staging the changes.

`-v` or `--verbose`: Shows the files as they are being added.

```
git add -A
git add -p
git add -u
git add -n
git add -v
```

### Example Output

When running `git status` after staging changes with `git add`

<figure><img src="../../.gitbook/assets/image (4).png" alt="" width="538"><figcaption></figcaption></figure>



## git rm

### Description







## git commit

### Description







