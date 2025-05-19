# Backup and restore a Git repository

## About

Backing up a Git repository means creating a safe copy of the entire repo (including commits, branches, tags, configuration, and history) so it can be restored if the original is lost or corrupted.

Restoring a Git repository means recreating the original repository from the backup so that work can resume with full version control history.

## Why do we need it?

* Protect against accidental deletion or data loss
* Transfer a repo between machines or users
* Create an offline copy
* Archive a project at a stable point

## What Does a Backup Contain?

A full backup includes:

* All commits and branches (history)
* Tags
* Remote settings (optional)
* Git configuration
* Repository data from `.git/` directory

## Backup Methods

### Method 1: Clone as a Bare Repository (Recommended for Backup)

A **bare repository** contains only Git data without working files.

```bash
git clone --bare https://example.com/our-repo.git
```

This creates a folder like:

```
our-repo.git/
```

This directory contains only `.git` data and is ideal for backup purposes.

We can store this on:

* USB drives
* External HDD/SSD
* Network drives
* Cloud storage (e.g., Google Drive, S3)

### Method 2: Zip the Project Folder with `.git`

If we have a local repo (non-bare), and we want to back it up including the working directory:

```bash
cd our-project-folder
zip -r backup.zip .
```

This keeps both the `.git` folder (which holds history) and our working files.

> Important: Make sure the `.git` folder is included. Without it, we lose all Git history.

### Method 3: Mirror Clone

This is an advanced option that includes all refs (branches, tags, remotes):

```bash
git clone --mirror https://example.com/our-repo.git
```

This is similar to a `--bare` clone but includes all refs and remote configuration, making it ideal for syncing or server backups.

## Restore Methods

### 1. Restore from Bare Clone

If we used `--bare` to create a backup:

```bash
git clone our-repo.git
```

This will create a working directory clone from our bare backup.

### 2. Restore from Zip File

If we zipped the working directory, just unzip:

```bash
unzip backup.zip
```

Then navigate into the folder and continue using Git as usual.

### 3. Restore from Mirror Clone

If we used `--mirror`, push it to a new remote:

```bash
cd our-repo.git
git push --mirror https://new-remote-url.com/new-repo.git
```

This restores everything (branches, tags, remote refs) to the new server.
