---
hidden: true
---

# Patch & Recovery

## **About**

**Patch & Recovery** covers techniques like `git cherry-pick`, `revert`, and `reset` to selectively apply or undo changes in a Git repository. These commands are crucial for maintaining stability when rolling back faulty commits, backporting changes to older releases, or applying fixes across multiple branches.

## **Importance**

Software teams frequently encounter situations requiring surgical precision:

* A critical bug fixed on `main` needs to be applied to a legacy `support/1.x` branch — `cherry-pick` enables that without merging unrelated changes.
* A developer accidentally pushes a bad commit to production — `git revert` safely creates an undo commit without altering history.
* During test cycles, the team may experiment on `develop` and want to reset only their local changes — `reset` or `restore` are vital here.

These practices reduce downtime, limit blast radius from mistakes, and give teams confidence in experimenting or reacting to production issues without compromising history.
