---
description: Minimal, intent-first Claude Code command to update your branch with a linear history. Lets the LLM decide exact Git commands; avoids brittle inline Bash snippets and environment leakage. Auto when possible; asks only if the upstream cannot be inferred. Works best when you pass an explicit upstream ref (e.g. `/merge origin/main`).
argument-hint: "[optional upstream ref, e.g. origin/main | origin/master | upstream/main]"
allowed-tools: >
  Bash(git *),
  Bash(npm *),
  Bash(pnpm *),
  Bash(yarn *),
  Bash(node *)
---

# /merge

## Mission
Bring the current branch up to date from a single upstream ref **without creating merge commits**, preferring **fast-forward** and otherwise performing a **rebase**. If conflicts arise, resolve them **intent‑first** using inbound diffs and keep changes minimal.

## Operating principles for the assistant
- Prefer **rebase** over merge; keep history linear.
- Do **not** rely on previously defined shell variables or state persisting between tool calls. Every `Bash(...)` command you run must be **self‑contained** with explicit values.
- If upstream is ambiguous and cannot be inferred safely, ask the user exactly once: “Which upstream? (e.g. origin/main)”. Otherwise proceed automatically.
- Never use interactive TUIs (no `-i`). Never run `git pull` (construct explicit `fetch`, `merge --ff-only`, or `rebase` commands instead).
- If the working tree has unrelated local changes, auto‑stash before rebase and pop afterward.
- Use `merge.conflictStyle=diff3` and enable `rerere` to speed repeat resolutions.

## Plan (what to do)
1) **Detect upstream** (call it `UP`):
   - If the user provided an argument, use it verbatim (e.g., `origin/main`).
   - Else try, in order:
     a) `git rev-parse --abbrev-ref --symbolic-full-name @{u}` (tracking branch)  
     b) default branch from `git remote show origin` (HEAD branch), with `origin/<HEAD>`  
     c) fallbacks: try `origin/main`, then `origin/master` if they exist
   - If none resolves, ask the user for the ref.

2) **Preflight**
   - Ensure not in detached HEAD.
   - If repository is shallow, unshallow (`git fetch --unshallow`).
   - Enable: `git config rerere.enabled true` and `git config merge.conflictStyle diff3`.
   - `git fetch --prune <remote-for-UP>`.

3) **Update**
   - If `git merge-base --is-ancestor HEAD <UP>` is true → run `git merge --ff-only <UP>` (fast‑forward).
   - Else → run `git rebase --autostash <UP>`.

4) **On conflicts (intent‑aware)**
   - List conflicts: `git diff --name-only --diff-filter=U`.
   - For each conflicted file, inspect base/ours/theirs (`git show :1:FILE`, `:2:FILE`, `:3:FILE`), plus inbound diffs for the file from `<UP>`.
   - Infer the **intent** of inbound changes (bugfix, refactor, API change, feature, tests, config) from the actual diff.
   - Apply minimal edits to preserve behavior while adopting upstream contracts (APIs/types/renames). Avoid formatting churn.
   - Stage fixes (`git add FILE`) and continue (`git rebase --continue`). Repeat until clean.

5) **Post‑checks**
   - If dependency or lockfiles changed, run a quick install (`pnpm install --ignore-scripts` | `npm ci` | `yarn install`).
   - If `tsconfig.json` exists, run `npx tsc --noEmit` and surface any actionable errors.
   - If we auto‑stashed, `git stash pop` and resolve trivial aftershocks similarly.
   - Suggest `git push --force-with-lease` if branch was previously pushed.

## Examples (assistant may adapt as needed)
- Detect tracking branch: `git rev-parse --abbrev-ref --symbolic-full-name @{u}`
- Default remote head: `git remote show origin | sed -n 's/.*HEAD branch: //p'`
- Check fast‑forward: `git merge-base --is-ancestor HEAD origin/main && git merge --ff-only origin/main`
- Rebase explicitly: `git rebase --autostash origin/main`
- List conflicts: `git diff --name-only --diff-filter=U`

## Output
- Short report: strategy (FF/rebase), number of inbound commits, conflicted files (if any), and a one‑line description of inbound intent.
