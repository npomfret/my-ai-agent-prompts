# COMMAND-FIRST WORKFLOW

## ⚠️ SCOPE DISCIPLINE - CRITICAL

**DO EXACTLY WHAT IS ASKED - NOTHING MORE, NOTHING LESS**

Common violations to AVOID:
- Asked for commit message → Write message ONLY (don't commit)
- Asked to fix bug → Fix bug ONLY (don't refactor unrelated code)  
- Asked to add feature → Add that feature ONLY (don't add bonus features)
- Asked to analyze → Analyze ONLY (don't implement fixes)

The `scope-guardian` agent will automatically check your work for scope violations.

## 🚀 Start EVERY Request with `/p`

The `/p` meta-prompt command automatically selects the best tools for your task:

```
/p analyze performance issues in my React app
/p fix the login bug in issue #123
/p refactor this code for better types
/p add dark mode to settings
```

## Why `/p`?

- **Zero Memory Load**: No need to remember tool names
- **Optimal Workflows**: Always uses the best combination of tools
- **Learning Aid**: Shows you which tools are selected and why
- **Can't Be Ignored**: Explicit command vs passive instructions

## Available Tools

**View all tools:**
- `/mcp-list` - See MCP servers (fast operations)
- `/agent-list` - See subagents (quality enforcement)

**Direct usage (optional):**
- MCP servers: `mcp__servername__method`
- Subagents: "Use the [agent-name] agent"

## The `/p` Advantage

Instead of:
- Remembering dozens of tool names
- Figuring out the right sequence
- Missing optimal approaches
- Risk of scope creep

Just use `/p` and get:
- Intelligent tool selection
- Proper sequencing
- Best practices enforced
- Automatic scope discipline checking

## Examples of `/p` in Action

**Feature Development:**
```
/p add user authentication to the app
→ architect-advisor → MCP tools → quality agents → scope-guardian → test-runner → auditor
```

**Bug Fixing:**
```
/p fix TypeError in user.service.ts line 45
→ architect-advisor → mcp__typescript-mcp__ → fix → scope-guardian → test-runner → auditor
```

**Analysis:**
```
/p analyze bundle size and suggest optimizations
→ mcp__context-provider__ → mcp__typescript-mcp__ → analyst agent
```

**Commit Message (SCOPE EXAMPLE):**
```
/p write a commit message for my changes
→ Reviews changes → Writes message ONLY (does NOT commit)
→ scope-guardian ensures no extra actions taken
```

## Remember

- **ALWAYS** start with `/p` for intelligent assistance
- The first `/p` in a session initializes MCP context
- Each `/p` returns an enhanced prompt with optimal tool usage
- Follow the enhanced prompt for best results

## ENVIRONMENT SETTINGS (Optional)

For extra strict scope enforcement, add to your shell profile:
```bash
export CLAUDE_STRICT_SCOPE=1
```

This makes the `/p` command even more vigilant about scope violations.

## PROJECT-SPECIFIC INSTRUCTIONS
[Add your project-specific requirements here]