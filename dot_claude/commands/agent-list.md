---
description: List all available subagents and their purposes
---

# List Available Subagents

Show me all the subagents available in Claude Code along with their purposes and when to use them.

## Instructions

1. Read the `.claude/agent-inventory.json` file
2. Organize agents by their type (meta, planning, analysis, verification, etc.)
3. For each agent, display:
   - Name
   - Type
   - Purpose
   - When to use it
   - What it combines (if applicable)
   - Order in workflow (if specified)

## Output Format

Format the output as a hierarchical list grouped by agent type.

Include:
- Workflow patterns for common tasks (new feature, bug fix, etc.)
- Which agents can run in parallel
- The recommended order of agent execution
- Tips on which agents are mandatory vs optional

Help users understand the agent ecosystem so they can leverage these tools effectively without having to memorize all the details.