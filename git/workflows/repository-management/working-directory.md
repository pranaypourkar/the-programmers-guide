# Working Directory

## About

In Git, the **working directory** (also called **working tree**) is the part of our local Git repository **where we see and modify actual files**.

**Example:**

When we run:

```bash
git clone https://example.com/your-repo.git
```

Git will:

1. Download the `.git` directory (where all Git history, configuration, and metadata live),
2. And also **extract all files from the latest commit** into our current directory.

That visible folder with code files, docs, configs, etc., is our **working directory** — it's what we edit.

## How Is It Different From a **Bare Repository**?

<table><thead><tr><th width="145.3828125">Type</th><th width="158.7109375">Contains Git History</th><th width="259.203125">Contains Files You Edit (Working Dir)</th><th>Typical Use</th></tr></thead><tbody><tr><td>Regular repo</td><td><code>.git</code> folder</td><td>Working directory (code files)</td><td>Development, coding</td></tr><tr><td>Bare repository</td><td>Git data only</td><td>No working directory</td><td>Backup, remote host</td></tr></tbody></table>

**Bare repo example:**

```bash
git clone --bare https://example.com/repo.git
```

* Creates `repo.git/`
* Inside: only Git history and metadata
* **No** code files — we can't run or edit the project here
