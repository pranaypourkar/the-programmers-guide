# Workflows

## Scenario 1

### To create a new GitLab repository with all the files, commits, branches, and other history from an existing repository

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
