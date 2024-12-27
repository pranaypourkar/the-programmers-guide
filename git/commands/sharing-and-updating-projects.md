# Sharing and Updating Projects

## git fetch

### Description

It is used to download commits, files, and references from a remote repository into our local repository. It updates our local copy of the remote branch but does not merge the changes into working branch. This allows to see what others have been working on without affecting your current work.

### Usage

```sh
git fetch [<options>] [<repository>] [<refspec>...]
```

#### Options

`--all`: Fetches updates from all remotes.

`--prune`: Removes remote-tracking branches that no longer exist on the remote.

`--dry-run`: Shows what would be fetched without actually fetching.

`-v` or `--verbose`: Provides more detailed output.

`--depth=<depth>`: Limits the fetching to a specified number of commits.

```
git fetch --all
git fetch --prune
git fetch --dry-run
git fetch --verbose
git fetch --depth=1
```

### What It Does

1. **Updates Remote Tracking Branches**: Fetches updates from a remote repository and updates the remote-tracking branches in our local repository.
2. **Does Not Merge**: It does not change our working directory or current branch. We need to manually merge or rebase the changes if you want to integrate them.

{% hint style="info" %}
**Remote-Tracking Branches**: These are branches in your local repository that track the state of branches in the remote repository. For example, `origin/main` tracks the `main` branch in the `origin` remote.

**Safe Operation**: `git fetch` is safe to run at any time as it does not modify your working directory or current branch. It simply updates your remote-tracking branches with any changes from the remote repository.

**Comparing Branches**: After fetching, you can use `git diff` or `git log` to see what changes have been made on the remote branches before deciding to merge or rebase.
{% endhint %}

### Common Use Cases

```
-- Fetch Updates from All Remote Repositories
-- Fetches updates from all remote repositories configured in our local repository.
git fetch

-- Fetch Updates from a Specific Remote Repository, in this case, origin
git fetch origin

-- Fetch Specific Branches
-- Fetches updates for the specified branch from the remote repository
git fetch origin branch-name
```

### Example Workflow

```
-- Check the Current Branch and Status
git status

-- Fetch Updates from the Remote Repository
git fetch origin

-- View the Differences
-- This shows the commits in the origin/main branch
git log origin/main --oneline

-- Merge or Rebase the Changes
-- If we want to incorporate the fetched changes into our local branch, we can merge or rebase them
git merge origin/main
git rebase origin/main
```

### Example Output

When running `git fetch`

<figure><img src="../../.gitbook/assets/image (399).png" alt="" width="429"><figcaption></figcaption></figure>

### Fetch vs. Pull

* **Fetch**: Downloads changes from the remote repository and updates remote-tracking branches. Does not change our working directory or current branch.

`git fetch`

* **Pull**: Combines `git fetch` and `git merge` (or `git rebase`). Downloads changes and immediately merges or rebases them into our current branch.

`git pull`

<figure><img src="../../.gitbook/assets/image (400).png" alt="" width="458"><figcaption></figcaption></figure>

## git pull

### Description

It is used to fetch changes from a remote repository and immediately integrate them into your current branch. This command is a combination of `git fetch` (which downloads the changes) and `git merge` (which integrates the changes). By default, `git pull` performs a merge, but it can also be configured to rebase.

### Usage

```sh
git pull [<options>] [<repository> [<refspec>...]]
```

### What It Does

1. **Fetches Changes**: Downloads commits, files, and references from a remote repository.
2. **Integrates Changes**: Merges or rebases the fetched changes into the current branch.

{% hint style="info" %}
**Fast-forward vs. Merge Commit**: If your branch has not diverged from the remote branch, `git pull` performs a fast-forward merge. If there are divergent commits, it creates a merge commit.

**Conflicts**: If there are conflicts during the merge or rebase, Git will stop and prompt you to resolve them manually.

**Rebase Option**: Using `git pull --rebase` helps to maintain a cleaner, linear history by applying your changes on top of the fetched commits.

**Customizing Default Behavior**: You can set your default `pull` behavior to rebase by configuring Git:

```sh
git config --global pull.rebase true
```
{% endhint %}

### Common Use Cases

```
-- Pull Changes from the Default Remote Repository (origin)
-- This fetches and merges changes from the default remote repository and branch, typically origin/main
git pull

-- Fetches and merges changes from the specified remote repository origin
git pull origin

-- Pull Changes and Rebase
-- Fetches changes and then rebases our local commits on top of the fetched commits instead of merging them
git pull --rebase
```

### Example Workflow

```
-- Check the Current Branch and Status
git status

-- Pull Changes from the Remote Repository
-- This fetches and merges changes from the main branch of the origin remote repository into our current branch
git pull origin main

-- Resolve Any Conflicts:
-- If conflicts arise during the merge, Git will pause and prompt to resolve them manually. After resolving conflicts, we can continue the merge process by committing the changes.

```

### Example Output

When running `git pull`

<figure><img src="../../.gitbook/assets/image (401).png" alt="" width="426"><figcaption></figcaption></figure>

## git push

### Description

It is used to upload local repository content to a remote repository. By executing this command, we can share our local commits, branches, and tags with others. Essentially, `git push` updates the remote repository with our latest work.

### Usage

```sh
git push [<options>] [<repository> [<refspec>...]]
```

#### Options

`-all`: Pushes all branches

`--tags`: Pushes all tags.

`--force` or `-f`: Forces the push even if it results in a non-fast-forward merge, which can overwrite remote changes.

`--set-upstream` or `-u`: Sets the remote branch as the upstream for the current branch, making future pushes easier.

`--delete`: Deletes a branch or tag from the remote repository.

```
git push --all origin
git push origin --tags
git push --force origin branch-name
git push --set-upstream origin branch-name
git push origin --delete branch-name
```

### What It Does

1. **Uploads Local Changes**: Pushes commits from your local branch to a corresponding branch on the remote repository.
2. **Creates or Updates Remote Branches**: If the remote branch doesn't exist, it will be created. If it exists, it will be updated with your local commits.

{% hint style="info" %}
In the context of Git, `origin/main` refers to two things combined:

1. **Remote repository:** The word `origin` is a nickname for the remote repository we cloned our local project from. This could be a service like GitHub, GitLab, or any other Git hosting platform.
2. **Branch on remote repository:** `/main` refers to the `main` branch that exists on that remote repository.

So, `origin/main` essentially points to the `main` branch on the remote repository that your local copy (`main` branch) was originally cloned from. It's a way for our local Git to keep track of its connection to the upstream branch.
{% endhint %}

{% hint style="warning" %}
**Upstream Branch**: Setting an upstream branch allows to use `git push` without specifying the remote and branch names every time. We can set the upstream branch with:

```
git push --set-upstream origin branch-name
```

**Force Push**: Be careful when using `git push --force` as it can overwrite changes on the remote repository, potentially causing data loss for others working on the same repository. Use it only when necessary and ensure you understand the implications.

```
git push --force origin branch-name
```

**Deleting Remote Branches**: To delete a branch from the remote repository, We can use:

```
git push origin --delete branch-name
```
{% endhint %}

### Common Use Cases

```
-- Push Changes to the Default Remote Repository (origin)
-- Pushes the current branch to its upstream branch on the origin remote repository.
git push

-- Push to a Specific Remote Repository
-- Pushes the current branch to the origin remote repository
git push origin

-- Push a Specific Branch
-- Pushes the specified branch to the origin remote repository
git push origin branch-name

-- Pushes all local branches to the remote repository.
git push --all

-- Push Tags
-- Pushes all local tags to the remote repository
git push origin --tags
```

### Example Workflow

```
-- Make Changes and Commit Locally
echo "Some changes" > file.txt
git add file.txt
git commit -m "Add some changes"

-- Push Changes to the Remote Repository
-- This pushes the main branch to the origin remote repository
git push origin main
```

### Example Output

When running `git push`

<figure><img src="../../.gitbook/assets/image (402).png" alt="" width="535"><figcaption></figcaption></figure>
