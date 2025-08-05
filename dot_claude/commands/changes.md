---
description: Show uncommitted changes in the current project
allowed-tools: Bash(git status:*), Bash(git diff:*)
---

# Changes

Analyze the current change set from a fresh perspective, and critique it. 

Zoom out and look at the surrounding, upstream and downstream code to appreciate the context.

Reject the change set if:

 * there are ANY superfluous or extraneous
   * code
   * changes 
   * features
 * the resulting code is unnecessarily complex
 * existing style or patterns have been ignored in favor of new ones 
 * or if there are any 
   * obvious bugs
   * security blunders
   * performance or scalability bottlenecks
   * dirty hacks (especially those done in the name of "simplicity")

Don't be overly pedantic; if it's mostly ok, just say so.

Run any relevant builds and tests and report all errors after they have finished.

Check for untracked new files:
- Delete them if they are not needed
- Add them to git if they are needed
- Or, in exceptionally rare circumstance, add to `.gitignore`

If it's ok to commit, **produce a nice commit message** and stop.

DO NOT: git **COMMIT**, git **PUSH** or create a PR
