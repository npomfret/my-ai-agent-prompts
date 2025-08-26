---
description: Intent-aware inbound update with a fast path (FF/rebase clean) and an LLM-guided conflict path that preserves behavior/intent. Linear history only (no merge commits).
argument-hint: "[optional upstream ref, e.g. origin/main | defaults to @{u} or origin/<HEAD>]"
allowed-tools: >
  Bash(git fetch:*),
  Bash(git remote:*),
  Bash(git rev-parse:*),
  Bash(git rev-list:*),
  Bash(git diff:*),
  Bash(git pull:*),
  Bash(git config:*),
  Bash(git merge-base:*),
  Bash(git merge-tree:*),
  Bash(git rebase:*),
  Bash(git add:*),
  Bash(git status:*),
  Bash(git stash:*),
  Bash(git apply:*),
  Bash(git switch:*),
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

> Perform an **LLM-first**, **linear** update from upstream onto the current branch.  
> Fast path: **fast-forward** or **clean rebase**.  
> Conflict path: analyze **diff-only intent**, synthesize **minimal patches** that preserve behavior, then continue the rebase.

---

## 0) Preflight & Upstream Resolution (safe by default)

- Refuse if in a detached HEAD:
  !`if [ "$(git rev-parse --abbrev-ref HEAD)" = "HEAD" ]; then echo "Detached HEAD — switch to a branch first."; exit 1; fi`

- Ensure repo is not shallow (otherwise fetch base history):
  !`if git rev-parse --is-shallow-repository | grep -q true; then git fetch --unshallow --quiet; fi`

- Determine upstream target `$UP`:
  1) If `$ARGUMENTS` provided, use that.  
  2) Else if HEAD has upstream, use `@{u}`.  
  3) Else detect default remote branch: `git remote show origin | sed -n 's/.*HEAD branch: //p'` → `origin/<HEAD>`
  !`UP="$ARGUMENTS"; if [ -z "$UP" ]; then UP="@{u}"; fi; if ! git rev-parse --verify --quiet "$UP" >/dev/null; then HEADBR=$(git remote show origin | sed -n 's/.*HEAD branch: //p'); UP="origin/${HEADBR:-main}"; fi; echo "Upstream: $UP"`

- Light fetch (no working tree changes, blob-less for speed):
  !`git fetch --prune --quiet --filter=blob:none --recurse-submodules=no`

- Quick hygiene:
  !`git config rerere.enabled true`
  !`git config merge.conflictStyle diff3`

- Working tree status / advice on stashing unrelated edits:
  !`git status --porcelain -b`
  > If unrelated local edits exist, I may offer to stash (`git stash -u -k`) and auto-pop later.

---

## 1) Inbound Intent Analysis (diffs-only; no commit messages)

- Compute divergence (LOCAL_AHEAD, LOCAL_BEHIND):
  !`git rev-list --left-right --count HEAD..."$UP"`

- Snapshot core signals:
  - Changed files & summary (rename/copy detection)
    !`git diff --name-status HEAD.."$UP"`
    !`git diff -M -C --summary HEAD..."$UP"`

  - Compact unified patch (save full to `.git/inbound.patch`, print first 400 lines):
    !`mkdir -p .git && git diff --no-color --unified=0 HEAD..."$UP" | tee .git/inbound.patch | sed -n '1,400p'`

- Produce **intent JSON** (print & write `.git/merge-intent.json`) and a **one-line TL;DR** (`.git/merge-intent.txt`). Infer categories per file from **diff evidence** only:
  ```json
  {
    "summary": "TL;DR of inbound change intent (from diffs only).",
    "categories": [
      { "type": "refactor|bugfix|feature|tests|deps|config|schema", "confidence": 0.00, "rationale": "why", "files": ["..."] }
    ],
    "signals": {
      "renamesDetected": false,
      "testsTouched": false,
      "lockfilesTouched": false,
      "schemaTouched": false
    },
    "recommendedResolutionBias": {
      "default": "mixed",
      "overrides": [
        { "glob": "tests/**", "prefer": "theirs" },
        { "glob": "*lock*.json", "prefer": "theirs" },
        { "glob": "package.json", "prefer": "theirs" },
        { "glob": "src/**", "prefer": "theirs-if-bugfix-else-mixed" }
      ]
    }
  }
  ```
  > Use `Bash(tee:*)` to write these files.

---

## 2) Strategy Selection — **no merge commits**

Decision tree (linear history only):

- If upstream **not ahead** → print “Up to date” and exit.
- If upstream ahead and **no local divergence** → `git pull --ff-only` from `$UP`.
- Otherwise → **rebase cleanly** with auto-stash and diff3 markers:
  !`git -c merge.conflictStyle=diff3 pull --rebase --autostash --no-stat`
  > If `git pull --rebase` is insufficient (e.g., multiple remote parents), fallback to:
  !`git fetch --quiet && git rebase --rebase-merges=interactive --autostash "$UP" || true`
  (Will still avoid creating merge commits on update; rebase-merges only used to replay local merge structure if it exists.)

---

## 3) Conflict Loop — preserve **intent** over literal code

When rebase stops, list conflicted files:
!`git diff --name-only --diff-filter=U`

For each conflicted file, Claude will:
1) Show base/ours/theirs fragments for context (first 60 lines each):
   !`for f in $(git diff --name-only --diff-filter=U); do echo "---- $f (BASE) ----"; git show ":1:$f" | sed -n '1,60p'; echo "---- $f (OURS) ----"; git show ":2:$f" | sed -n '1,60p'; echo "---- $f (THEIRS) ----"; git show ":3:$f" | sed -n '1,60p'; done`

2) Apply the intent bias from the JSON to craft minimal patches, then apply them:
   !`git apply -3 --recount --whitespace=fix || git apply --reject --whitespace=fix`

3) Stage resolved files safely (no angle-bracket placeholders):
   !`for f in $(git diff --name-only --diff-filter=U); do git add "$f" || true; done`
   > If a file is fully resolved it will drop out of the U-list; in that case a final safety net:
   !`git add -A`

4) Continue the rebase and loop until done:
   !`git rebase --continue || true`

- If a file cannot be safely auto-reconciled:  
  - Remove obvious markers; leave targeted `FIXME(merge)` notes.  
  - Print a short rationale and suggested follow-ups.

---

## 4) Post-checks (TypeScript-aware)

- If deps/lockfiles changed, run a light install:
  !`if [ -f pnpm-lock.yaml ]; then pnpm install --prefer-offline --ignore-scripts || true; elif [ -f package-lock.json ]; then npm ci --no-audit --no-fund || npm i --no-audit --no-fund; elif [ -f yarn.lock ]; then yarn install --ignore-scripts || true; fi`

- Quick TS/build check if present (non-fatal):
  !`if [ -f tsconfig.json ]; then npx tsc -p . --noEmit || true; fi`

- If we stashed, pop & re-stage any auto-fixes:
  !`git stash list | grep -q 'WIP on' && git stash pop || true`

- Print **merge report**:
  - Strategy taken (FF / rebase clean / rebase with conflicts)
  - Count of inbound commits and files touched
  - Any non-trivial merges and how intent was handled
  - TL;DR (`.git/merge-intent.txt` first line)
  - Next step if branch was previously pushed:
    > Consider `git push --force-with-lease`.

---

## Guardrails

- **Never** create merge commits as part of the update.
- Avoid interactive flags (no TUIs).
- Keep patches **minimal**; no mass formatting churn.
- Respect `rerere` for learned resolutions across runs.
- If `$UP` resolves to the current branch (misconfig), abort with guidance.

---

## Notes & Tips

- You can pass an explicit upstream (e.g., `/merge origin/release/2025.08`).  
- Default upstream priority: `$ARGUMENTS` → `@{u}` → `origin/<HEAD>`.  
- Submodules are not updated by default; add explicit steps if needed.
