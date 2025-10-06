---
description: git commit message generation that captures the intent of the commit as well as the important changes contained within
---

# /comment

> Generate a commit message for the current changeset and commit ALL changes (staged + unstaged).
> The message should be accurate but brief, focusing on the important changes and crucially the _intent_ of the changes.

- [ ] use the git cli to view and analyze ALL changes - both staged and unstaged. Every single changed file. No exceptions.
- [ ] if there are untracked files shown in the "Untracked files:" section of git status, STOP and alert the user. 
- [ ] Files shown under "Changes to be committed:" with "new file:" are already staged and should NOT trigger this check.
- [ ] stage ALL modified and new files with `git add`
- [ ] compose a detailed commit message

Do not commit! Report your commit message only.