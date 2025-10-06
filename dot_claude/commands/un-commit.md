---
description: resets all local commits that have not been pushed, bringing the changes back into the working tree
---

# /un-commit

Take all local commits (unpushed changes) and bring them back into the working tree. This will reset the branch to the state of its upstream counterpart, but leave all the changes in the working directory.

- [ ] run `git status` to check for unpushed commits
- [ ] run `git reset @{u}` to reset the local commits. This will take all local commits (unpushed changes) and bring them back into your working tree.
- [ ] run `git status` again to show the result
