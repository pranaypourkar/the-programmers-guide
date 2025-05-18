# Mirror a repository

## About

Mirroring a repository means creating an **exact clone** of a Git repository, including **all branches**, **tags**, and **refs** (such as remotes, notes, etc.). Unlike a regular clone, mirroring includes all Git references and is typically used for:

* **Backup** purposes
* **Migrating** a repository from one hosting service (e.g., GitHub, GitLab, Bitbucket) to another
* **Maintaining a read-only replica**
* **Syncing forks** with upstream

## Difference Between `clone`, `clone --bare`, and `clone --mirror`

<table data-header-hidden data-full-width="true"><thead><tr><th></th><th></th><th></th><th></th></tr></thead><tbody><tr><td>Feature / Behavior</td><td><code>git clone</code></td><td><code>git clone --bare</code></td><td><code>git clone --mirror</code></td></tr><tr><td><strong>Working directory present</strong></td><td>Yes</td><td>No</td><td>No</td></tr><tr><td><strong><code>.git</code> directory</strong></td><td>Inside working directory (<code>repo/.git</code>)</td><td>Cloned directly as the repository (<code>repo.git/</code>)</td><td>Same as <code>--bare</code>, stored as <code>repo.git/</code></td></tr><tr><td><strong>Default checked-out branch</strong></td><td>Yes, typically <code>main</code> or <code>master</code></td><td>No branch checked out</td><td>No branch checked out</td></tr><tr><td><strong>Remote-tracking branches (<code>origin/*</code>)</strong></td><td>Only the default branch (<code>origin/main</code>)</td><td>All branches present but no remote-tracking setup</td><td>All remote-tracking branches and refs copied as-is</td></tr><tr><td><strong>Tags</strong></td><td>Yes</td><td>Yes</td><td>Yes</td></tr><tr><td><strong>All branches</strong></td><td>Only <code>HEAD</code> and selected branches</td><td>Yes (available but not tracked remotely)</td><td>Yes (tracked remotely as in origin)</td></tr><tr><td><strong>All refs (<code>refs/*</code>)</strong></td><td>No</td><td>Only basic refs</td><td>Yes – includes all refs like <code>refs/pull</code>, <code>refs/notes</code>, <code>refs/remotes</code></td></tr><tr><td><strong>Refspec behavior</strong></td><td>Uses <code>+refs/heads/*:refs/remotes/origin/*</code></td><td>Limited</td><td>Uses <code>+refs/*:refs/*</code> (a complete ref sync)</td></tr><tr><td><strong>Remote configuration (origin)</strong></td><td>Configured to <code>origin</code> with fetch/push URLs</td><td>Configured, but only fetch by default</td><td>Configured for push and fetch, used for mirroring</td></tr><tr><td><strong>Use case</strong></td><td>Active development and contribution</td><td>Hosting a repo on a server or sharing</td><td>Full backup or migration (one-time or continuous sync)</td></tr><tr><td><strong>Push behavior</strong></td><td>Pushes selected branches/tags manually</td><td>Pushes must be explicitly defined</td><td>Pushes all branches/tags/refs exactly as local repo</td></tr><tr><td><strong>Removes deleted refs on push</strong></td><td>No</td><td>No</td><td>Yes – deleted refs in local will also be deleted remotely</td></tr><tr><td><strong>Default for developers</strong></td><td>Yes</td><td>No</td><td>No</td></tr><tr><td><strong>Default for Git server/admins</strong></td><td>No</td><td>Yes</td><td>Yes (if syncing or migrating repos)</td></tr></tbody></table>



## When to Use `--mirror`

Use `git clone --mirror` when:

* You want to migrate everything from one remote to another (full history, branches, tags).
* You want to keep a **mirror in sync** with the upstream repository, including **removal of deleted branches**.
* You are building a **read-only backup** system.

### Use Case

To create a new GitLab repository with all the files, commits, branches, and other history from an existing repository

<pre class="language-git"><code class="lang-git">-- Step 1: Mirror the Existing Repository
-- Create a bare clone of the existing repository. This ensures that all branches, tags, and refs are copied.
git clone --mirror https://gitlab.com/your-username/existing-repo.git
cd existing-repo.git

-- Step 2: Create a New Repository on GitLab
-- Go to GitLab and create a new repository. Note the URL of the new repository, which will look something like https://gitlab.com/your-username/new-repo.git

-- Step 3: Push the Mirror to the New Repository
-- Push the mirrored repository to the new GitLab repository.
git remote set-url origin https://gitlab.com/your-username/new-repo.git
git push --mirror

-- Step 4: Verify the New Repository
<strong>-- Clone the new repository to verify that all branches, commits, and tags have been copied correctly.
</strong>cd ..
git clone https://gitlab.com/your-username/new-repo.git
cd new-repo
git branch -a  # List all branches
git log        # Check commit history
git tag        # Check tags
</code></pre>

## How to Mirror a Repository – Step by Step

### **1. Clone the Source Repository with `--mirror`**

```bash
git clone --mirror https://source-url.com/your-repo.git
```

This creates a `.git` folder with **all references**, but no working tree. You’ll get:

* All branches (not just the default)
* All remote-tracking branches
* All tags
* All refs (like notes, stash, etc.)

This is different from `git clone`, which only checks out the default branch and HEAD.

### **2. Push the Mirror to a New Remote**

```bash
cd your-repo.git
git push --mirror https://destination-url.com/your-repo.git
```

This pushes:

* All branches
* All tags
* All refs

## Important Notes

* A mirror repository is **not for development** – it has no working directory.
* Use it for **backups**, **replication**, or **migration**.
* Mirroring overwrites all remote refs – **careful with `--mirror` push** on shared remotes.
* A `--mirror` push will **delete remote branches** that no longer exist locally.

