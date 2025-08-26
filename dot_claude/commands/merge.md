---
description: Intent-aware inbound update with a fast path (FF-only) or explicit rebase onto a single upstream. This version **persists upstream info to files** so each Bash snippet has access (Claude commands don’t share shell state).
argument-hint: "[optional upstream ref, e.g. origin/main | defaults to @{u} or origin/<HEAD>]"
allowed-tools: >
  Bash(git fetch:*),
  Bash(git remote:*),
  Bash(git rev-parse:*),
  Bash(git rev-list:*),
  Bash(git diff:*),
  Bash(git merge:*),
  Bash(git config:*),
  Bash(git rebase:*),
  Bash(git add:*),
  Bash(git status:*),
  Bash(git stash:*),
  Bash(git apply:*),
  Bash(git log:*),
  Bash(cat:*),
  Bash(tee:*),
  Bash(mkdir:*),
  Bash(sed:*),
  Bash(awk:*),
  Bash(tr:*),
  Bash(node:*),
  Bash(pnpm:*),
  Bash(npm:*),
  Bash(yarn:*)
---

# /merge

> **Linear history only** (no merge commits).  
> Fast path: **fast‑forward** if current `HEAD` is an ancestor of upstream.  
> Else: **explicit rebase** onto a **single resolved upstream commit**.  
> Conflicts: resolve with intent inferred from diffs.

---

## 0) Preflight & Upstream Resolution (persist to files)

- Refuse if in a detached HEAD:
  !`if [ "$(git rev-parse --abbrev-ref HEAD)" = "HEAD" ]; then echo "Detached HEAD — switch to a branch first."; exit 1; fi`

- Ensure repo isn’t shallow (rebase needs history):
  !`if git rev-parse --is-shallow-repository | grep -q true; then git fetch --unshallow --quiet; fi`

- Resolve a **single** upstream ref and its **commit SHA**, then persist:
  !`mkdir -p .git && : > .git/merge_up_ref && : > .git/merge_up_sha`
  !`cand="$ARGUMENTS";`
  !`if [ -z "$cand" ]; then cand=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null || true); fi`
  !`if [ -z "$cand" ]; then headbr=$(git remote show origin 2>/dev/null | sed -n 's/.*HEAD branch: //p'); cand="origin/${headbr:-main}"; fi`
  !`sha=$(git rev-parse --verify -q "${cand}^{commit}") || { echo "Cannot resolve upstream: $cand"; exit 1; }`
  !`printf "%s" "$cand" > .git/merge_up_ref && printf "%s" "$sha" > .git/merge_up_sha && echo "Upstream: $cand @ $sha"`

- Fetch (blobless for speed):
  !`git fetch --prune --quiet --filter=blob:none --recurse-submodules=no`

- Enable rerere & diff3 markers:
  !`git config rerere.enabled true`
  !`git config merge.conflictStyle diff3`

---

## 1) Inbound Intent (diff-only)

- Divergence numbers & store for later:
  !`LA=$(git rev-list --left-right --count HEAD...$(cat .git/merge_up_sha) | awk '{print $1}'); UB=$(git rev-list --left-right --count HEAD...$(cat .git/merge_up_sha) | awk '{print $2}'); echo "Local ahead=$LA, Upstream ahead=$UB" | tee .git/merge_divergence.txt`

- Changed files & summary (with rename/copy detect):
  !`git diff --name-status HEAD...$(cat .git/merge_up_sha)`
  !`git diff -M -C --summary HEAD...$(cat .git/merge_up_sha)`

- Compact patch (save full, print head):
  !`git diff --no-color --unified=0 HEAD...$(cat .git/merge_up_sha) | tee .git/inbound.patch | sed -n '1,400p'`

- Emit minimal **intent** artifact (you can flesh this out as needed):
  !`printf "%s\n" "Upstream intent (from diffs only) -> see .git/inbound.patch" | tee .git/merge-intent.txt`

---

## 2) Strategy — FF or explicit rebase (no git pull)

- If **fast-forward** is possible (HEAD is ancestor of upstream), do it:
  !`if git merge-base --is-ancestor HEAD "$(cat .git/merge_up_sha)"; then git merge --ff-only "$(cat .git/merge_up_sha)"; echo "Fast-forwarded to $(cat .git/merge_up_ref)"; exit 0; fi`

- Otherwise **explicit rebase** onto the single upstream commit:
  !`git rebase --autostash "$(cat .git/merge_up_sha)" || true`

---

## 3) Conflict Loop — intent‑aware

- List conflicted files (if any):
  !`git diff --name-only --diff-filter=U`

- For each conflicted file, show base/ours/theirs context and attempt minimal patching guided by intent:
  !`for f in $(git diff --name-only --diff-filter=U); do echo "---- $f (BASE) ----"; git show ":1:$f" | sed -n '1,80p'; echo "---- $f (OURS) ----"; git show ":2:$f" | sed -n '1,80p'; echo "---- $f (THEIRS) ----"; git show ":3:$f" | sed -n '1,80p'; done`
  !`git apply -3 --recount --whitespace=fix || git apply --reject --whitespace=fix`
  !`for f in $(git diff --name-only --diff-filter=U); do git add "$f" || true; done`
  !`git add -A`
  !`git rebase --continue || true`

- If a file can’t be safely auto‑reconciled, leave precise `FIXME(merge)` notes and a short rationale.

---

## 4) Post‑checks (TypeScript‑aware)

- If deps/lockfiles changed, install lightly:
  !`if [ -f pnpm-lock.yaml ]; then pnpm install --prefer-offline --ignore-scripts || true; elif [ -f package-lock.json ]; then npm ci --no-audit --no-fund || npm i --no-audit --no-fund; elif [ -f yarn.lock ]; then yarn install --ignore-scripts || true; fi`

- TS/build sanity (non‑fatal):
  !`if [ -f tsconfig.json ]; then npx tsc -p . --noEmit || true; fi`

- If we stashed, pop:
  !`git stash list | grep -q 'WIP on' && git stash pop || true`

- Report:
  - Strategy (FF / rebase clean / rebase w/ conflicts)
  - Count of inbound commits / files changed
  - TL;DR from `.git/merge-intent.txt`
  - Next step if previously pushed: consider `git push --force-with-lease`

---

## Guardrails

- Linear history; no merge commits created.
- No interactive flags.
- Minimal diffs; avoid formatting churn.
- Uses persisted files so later snippets can read upstream info reliably.
