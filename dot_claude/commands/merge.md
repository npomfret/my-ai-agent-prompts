---
description: Intent-aware inbound merge without merge commits. Fast-forward if clean; otherwise rebase with diff3 conflicts and LLM-guided conflict resolution that preserves intent (not just code).
argument-hint: [optional upstream; defaults to @{u}]
allowed-tools: >
  Bash(git fetch:*),
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
  Bash(git checkout:*),
  Bash(git switch:*),
  Bash(git log:*),
  Bash(cat:*),
  Bash(tee:*),
  Bash(mkdir:*),
  Bash(sed:*),
  Bash(awk:*),
  Bash(tr:*)
---

# /merge

> Use an **LLM-first** flow to analyze inbound changes, infer intent, and perform a linear update: **fast-forward** if possible; otherwise **rebase (no merge commits)**. If conflicts occur, I will synthesize minimal patches that keep behavior consistent with the inferred intent and then continue the rebase.

## Context (generated via Bash and included for reasoning)

- Fetch lightly for speed (does not alter working tree)  
  !`git fetch --prune --quiet --filter=blob:none`

- Divergence counts (AHEAD local / BEHIND upstream)  
  !`git rev-list --left-right --count HEAD...@{u}`

- Current branch & status  
  !`git branch --show-current`  
  !`git status --porcelain -b`

- Inbound file list & summary (rename/copy detection)  
  !`git diff --name-status HEAD..@{u}`  
  !`git diff -M -C --summary HEAD...@{u}`

- Inbound compact patch (first 400 lines, full saved to .git/inbound.patch)  
  !`mkdir -p .git && git diff --unified=0 --no-color HEAD...@{u} | tee .git/inbound.patch | sed -n '1,400p'`

- Files you’ve changed locally and path overlap with inbound  
  !`comm -12 <(git diff --name-only | sort) <(git diff --name-only HEAD..@{u} | sort) | wc -l | tr -d ' '`

- Pre-map conflicted paths (dry-run)  
  !`BASE=$(git merge-base HEAD @{u}); git merge-tree "$BASE" HEAD @{u} | sed -n '1,200p'`

---

## Your task

You are an **agentic merge assistant** operating inside Claude Code. Perform an **intent-aware, linear update** from upstream to the current branch, using the following policy:

### 1) Analyze inbound intent (diffs-only)
- Infer high-level goals per file/group: `bugfix | refactor | feature | tests | deps | config | schema`. **Do not** use commit messages. Use *diff evidence* only.
- Produce a **concise JSON** (print to chat **and** write to `.git/merge-intent.json`) of the form:

```json
{
  "summary": "Natural-language TL;DR of inbound change intent from diffs only",
  "categories": [
    { "type": "refactor", "confidence": 0.86, "rationale": "e.g., massive renames + signature shifts", "files": ["src/..."] }
  ],
  "signals": {
    "renamesDetected": true,
    "testsTouched": false,
    "lockfilesTouched": false,
    "schemaTouched": false
  },
  "recommendedResolutionBias": {
    "default": "theirs|ours|mixed",
    "overrides": [
      { "glob": "tests/**", "prefer": "theirs" },
      { "glob": "*lock*.json", "prefer": "theirs" },
      { "glob": "src/**", "prefer": "theirs-if-bugfix-else-mixed" }
    ]
  }
}
```

- Also emit a **one-line TL;DR** and write it to `.git/merge-intent.txt`.

**Write files:** Use `Bash(tee:*)`, e.g. `printf '%s' '<json>' | tee .git/merge-intent.json >/dev/null`.

### 2) Choose the update strategy (no merge commits)
Follow this decision tree:
- If upstream is **not ahead** → report “Up to date” and exit.
- If upstream is ahead and you have **no local changes/divergence** → run `git pull --ff-only`.
- Otherwise, run a rebase that preserves linear history with readable conflicts:  
  `git -c merge.conflictStyle=diff3 pull --rebase=merges --autostash -X theirs`

### 3) If rebase stops on conflicts → preserve **intent** (not necessarily exact code)
- Enable learned resolutions: `git config rerere.enabled true`.
- For each conflicted file (`git diff --name-only --diff-filter=U`):
  1. Load **stage 2 (ours)** and **stage 3 (theirs)**: `git show :2:<path>`, `git show :3:<path>`.
  2. Using the intent JSON, synthesize a **minimal unified diff patch** against the **current working tree** for `<path>` that preserves runtime behavior and aligns with inbound goals. Examples:
     - **Bugfix/security**: Prefer *theirs*; re-implement fix on top of local scaffolding if needed.
     - **Refactor vs local feature**: Keep local behavior; adopt API/rename semantics from refactor.
     - **Tests/lockfiles/schema/contracts**: Prefer *theirs*; update local code to satisfy the new contract.
  3. Apply with tolerance: `git apply -3 --recount --whitespace=fix` (retry with relaxed hunk fuzz if needed).
  4. `git add <path>`.

- After all files are addressed: `git rebase --continue`. If further conflicts arise, repeat this loop.

### 4) Post-checks
- If lockfiles or deps changed, run the appropriate install step (Node: consider `pnpm install --prefer-offline` or `npm i --no-audit --no-fund`) and re-run `git add` if files updated.
- Print a short **merge report**: fast path taken or number of conflicted files resolved + the `.git/merge-intent.txt` TL;DR (first line).

### Guardrails
- Never create merge commits; prefer `--ff-only` or `--rebase=merges`.
- Keep patches tight—no sweeping style churn.
- If a patch cannot be made safely, comment the rationale and leave the file staged with conflict markers removed, preserving compilation/tests when possible.

---

## Notes
- Use `@{u}` as the default upstream; if the user passes an argument, treat it as the upstream refspec (e.g., `origin/main`).  
- Always prioritize **behavioral intent** over literal code when resolving conflicts.
