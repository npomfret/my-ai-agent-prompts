---
description: Meta-prompt analyzer that enhances your prompts with relevant MCP servers and subagents
---

# Meta-Prompt Analyzer

## Session Initialization Check
First, check if this is the first `/p` command in this session. If so, initialize by:
1. Using `mcp__context-provider__get_code_context` to understand the project
2. Noting available MCP servers from `.mcp.json`
3. Setting MCP-first working mode

## Prompt Analysis

Analyze the following user prompt and enhance it by identifying relevant MCP servers and subagents that should be used.

**Original Prompt**: $ARGUMENTS

## Analysis Instructions

1. **Identify Task Type**:
   - Is this a new feature, bug fix, refactoring, analysis, or general query?
   - What is the primary goal?

2. **Match MCP Servers**:
   - Check if the task involves:
     - TypeScript/JavaScript analysis → suggest `mcp__typescript-mcp__`
     - General code context/search → suggest `mcp__context7__`
     - TypeScript refactoring → suggest `mcp__ts-morph__`
     - Code context analysis → suggest `mcp__context-provider__`
     - Browser automation → suggest `mcp__playwright__`
     - IDE diagnostics → suggest `mcp__ide__`

3. **Match Subagents**:
   - For ANY code changes → start with `architect-advisor`
   - For analysis tasks → use `analyst`
   - For testing → use `test-runner` (always at the end)
   - For quality checks → use detection agents in parallel:
     - `scope-creep-detector`
     - `no-fallback-detector`
     - `style-enforcer`
     - `duplicate-detector`
     - `comment-detector`
   - For commits → end with `auditor`

4. **Generate Enhanced Prompt**:
   Create a new version of the prompt that:
   - Explicitly mentions which MCP servers to use and why
   - Specifies the order of subagents to invoke
   - Includes specific instructions for each tool
   - Maintains the original intent while adding tool guidance

## Output Format

Provide:
1. **Task Classification**: [feature/bug/refactor/analysis/other]
2. **Recommended MCP Servers**: List with purpose for each
3. **Recommended Subagents**: Ordered list with timing
4. **Enhanced Prompt**: The full enhanced version of the original prompt

## Examples

### Example 1: "Fix the login bug"
- **Classification**: bug
- **MCP Servers**: `mcp__context7__` (search for auth code)
- **Subagents**: `architect-advisor` → make fix → `test-runner` → `auditor`
- **Enhanced**: "First use architect-advisor to understand the authentication architecture. Then use mcp__context7__ to search for login-related code. After fixing the bug, use test-runner to verify the fix works and auditor to create the commit."

### Example 2: "Analyze performance issues"
- **Classification**: analysis
- **MCP Servers**: `mcp__typescript-mcp__` (AST analysis), `mcp__context7__` (broad search)
- **Subagents**: `analyst` → `architect-advisor`
- **Enhanced**: "Use analyst agent to perform comprehensive performance analysis. Leverage mcp__typescript-mcp__ for AST-level analysis of React components and mcp__context7__ to identify performance bottlenecks across the codebase."

Now analyze the user's prompt and provide the enhanced version.