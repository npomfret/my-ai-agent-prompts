---
description: Intelligent prompt enhancer that automatically selects and executes optimal MCP servers and subagents
---

# Prompt Enhancer

This command analyzes your request and automatically executes it with the optimal MCP servers and subagents.

**User Request**: $ARGUMENTS

## Execution Plan

I'll analyze your request and execute it using the best tools:

### 1. Session Initialization (if first use)
- Use `mcp__context-provider__get_code_context` to understand the project
- Note available MCP servers from `.mcp.json` and `.claude/mcp-inventory.json`
- Load agent capabilities from `.claude/agent-inventory.json`
- Check if `CLAUDE_STRICT_SCOPE=1` environment variable is set for extra scope vigilance

### 2. Request Analysis & Tool Selection

**Analysis Keywords in your request**:
- Code search/understanding: → `mcp__context7__`
- TypeScript/JavaScript analysis: → `mcp__typescript-mcp__`
- Code refactoring: → `mcp__ts-morph__`
- Enhanced context: → `mcp__context-provider__`
- Browser/E2E testing: → `mcp__playwright__`
- IDE diagnostics/errors: → `mcp__ide__`

**Task Type Detection**:
- New features → `architect-advisor` first, then quality agents, then `scope-guardian` (mandatory), then `test-runner`, then `auditor`
- Bug fixes → `architect-advisor` first, then fix, then `scope-guardian` (mandatory), then `test-runner`, then `auditor`  
- Analysis → `analyst` agent, then `scope-guardian` if any changes made
- Refactoring → `architect-advisor`, then refactor, then `scope-guardian` (mandatory), then quality agents, then `test-runner`
- General queries → Appropriate MCP servers only (no scope-guardian needed)

### 3. Automatic Execution

Based on the analysis above, I will now:

1. **Select the optimal MCP servers** based on keywords in your request
2. **Choose the right subagents** based on the task type
3. **Execute your request immediately** using the selected tools
4. **Automatically run scope-guardian** after any code changes to ensure I did ONLY what was asked
5. **Show you which tools I selected** so you learn the system

---

**Executing your enhanced request now...**